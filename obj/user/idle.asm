
obj/user/idle.debug:     formato del fichero elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 30 80 00 40 	movl   $0x801d40,0x803000
  800040:	1d 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 40 01 00 00       	call   800188 <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800055:	e8 0a 01 00 00       	call   800164 <sys_getenvid>
	if (id >= 0)
  80005a:	85 c0                	test   %eax,%eax
  80005c:	78 12                	js     800070 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x31>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 f8 03 00 00       	call   800497 <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 99 00 00 00       	call   800142 <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
  8000b4:	83 ec 1c             	sub    $0x1c,%esp
  8000b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000bd:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000c5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000c8:	8b 75 14             	mov    0x14(%ebp),%esi
  8000cb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000d1:	74 1d                	je     8000f0 <syscall+0x42>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	7e 19                	jle    8000f0 <syscall+0x42>
  8000d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	50                   	push   %eax
  8000de:	52                   	push   %edx
  8000df:	68 4f 1d 80 00       	push   $0x801d4f
  8000e4:	6a 23                	push   $0x23
  8000e6:	68 6c 1d 80 00       	push   $0x801d6c
  8000eb:	e8 e9 0e 00 00       	call   800fd9 <_panic>

	return ret;
}
  8000f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000fe:	6a 00                	push   $0x0
  800100:	6a 00                	push   $0x0
  800102:	6a 00                	push   $0x0
  800104:	ff 75 0c             	pushl  0xc(%ebp)
  800107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010a:	ba 00 00 00 00       	mov    $0x0,%edx
  80010f:	b8 00 00 00 00       	mov    $0x0,%eax
  800114:	e8 95 ff ff ff       	call   8000ae <syscall>
}
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	c9                   	leave  
  80011d:	c3                   	ret    

0080011e <sys_cgetc>:

int
sys_cgetc(void)
{
  80011e:	55                   	push   %ebp
  80011f:	89 e5                	mov    %esp,%ebp
  800121:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800124:	6a 00                	push   $0x0
  800126:	6a 00                	push   $0x0
  800128:	6a 00                	push   $0x0
  80012a:	6a 00                	push   $0x0
  80012c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800131:	ba 00 00 00 00       	mov    $0x0,%edx
  800136:	b8 01 00 00 00       	mov    $0x1,%eax
  80013b:	e8 6e ff ff ff       	call   8000ae <syscall>
}
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800148:	6a 00                	push   $0x0
  80014a:	6a 00                	push   $0x0
  80014c:	6a 00                	push   $0x0
  80014e:	6a 00                	push   $0x0
  800150:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800153:	ba 01 00 00 00       	mov    $0x1,%edx
  800158:	b8 03 00 00 00       	mov    $0x3,%eax
  80015d:	e8 4c ff ff ff       	call   8000ae <syscall>
}
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80016a:	6a 00                	push   $0x0
  80016c:	6a 00                	push   $0x0
  80016e:	6a 00                	push   $0x0
  800170:	6a 00                	push   $0x0
  800172:	b9 00 00 00 00       	mov    $0x0,%ecx
  800177:	ba 00 00 00 00       	mov    $0x0,%edx
  80017c:	b8 02 00 00 00       	mov    $0x2,%eax
  800181:	e8 28 ff ff ff       	call   8000ae <syscall>
}
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <sys_yield>:

void
sys_yield(void)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80018e:	6a 00                	push   $0x0
  800190:	6a 00                	push   $0x0
  800192:	6a 00                	push   $0x0
  800194:	6a 00                	push   $0x0
  800196:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019b:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001a5:	e8 04 ff ff ff       	call   8000ae <syscall>
}
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    

008001af <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001b5:	6a 00                	push   $0x0
  8001b7:	6a 00                	push   $0x0
  8001b9:	ff 75 10             	pushl  0x10(%ebp)
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c2:	ba 01 00 00 00       	mov    $0x1,%edx
  8001c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8001cc:	e8 dd fe ff ff       	call   8000ae <syscall>
}
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001d9:	ff 75 18             	pushl  0x18(%ebp)
  8001dc:	ff 75 14             	pushl  0x14(%ebp)
  8001df:	ff 75 10             	pushl  0x10(%ebp)
  8001e2:	ff 75 0c             	pushl  0xc(%ebp)
  8001e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e8:	ba 01 00 00 00       	mov    $0x1,%edx
  8001ed:	b8 05 00 00 00       	mov    $0x5,%eax
  8001f2:	e8 b7 fe ff ff       	call   8000ae <syscall>
}
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8001ff:	6a 00                	push   $0x0
  800201:	6a 00                	push   $0x0
  800203:	6a 00                	push   $0x0
  800205:	ff 75 0c             	pushl  0xc(%ebp)
  800208:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020b:	ba 01 00 00 00       	mov    $0x1,%edx
  800210:	b8 06 00 00 00       	mov    $0x6,%eax
  800215:	e8 94 fe ff ff       	call   8000ae <syscall>
}
  80021a:	c9                   	leave  
  80021b:	c3                   	ret    

0080021c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800222:	6a 00                	push   $0x0
  800224:	6a 00                	push   $0x0
  800226:	6a 00                	push   $0x0
  800228:	ff 75 0c             	pushl  0xc(%ebp)
  80022b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022e:	ba 01 00 00 00       	mov    $0x1,%edx
  800233:	b8 08 00 00 00       	mov    $0x8,%eax
  800238:	e8 71 fe ff ff       	call   8000ae <syscall>
}
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800245:	6a 00                	push   $0x0
  800247:	6a 00                	push   $0x0
  800249:	6a 00                	push   $0x0
  80024b:	ff 75 0c             	pushl  0xc(%ebp)
  80024e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800251:	ba 01 00 00 00       	mov    $0x1,%edx
  800256:	b8 09 00 00 00       	mov    $0x9,%eax
  80025b:	e8 4e fe ff ff       	call   8000ae <syscall>
}
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800268:	6a 00                	push   $0x0
  80026a:	6a 00                	push   $0x0
  80026c:	6a 00                	push   $0x0
  80026e:	ff 75 0c             	pushl  0xc(%ebp)
  800271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800274:	ba 01 00 00 00       	mov    $0x1,%edx
  800279:	b8 0a 00 00 00       	mov    $0xa,%eax
  80027e:	e8 2b fe ff ff       	call   8000ae <syscall>
}
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80028b:	6a 00                	push   $0x0
  80028d:	ff 75 14             	pushl  0x14(%ebp)
  800290:	ff 75 10             	pushl  0x10(%ebp)
  800293:	ff 75 0c             	pushl  0xc(%ebp)
  800296:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800299:	ba 00 00 00 00       	mov    $0x0,%edx
  80029e:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002a3:	e8 06 fe ff ff       	call   8000ae <syscall>
}
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002b0:	6a 00                	push   $0x0
  8002b2:	6a 00                	push   $0x0
  8002b4:	6a 00                	push   $0x0
  8002b6:	6a 00                	push   $0x0
  8002b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8002c0:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002c5:	e8 e4 fd ff ff       	call   8000ae <syscall>
}
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    

008002cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	05 00 00 00 30       	add    $0x30000000,%eax
  8002d7:	c1 e8 0c             	shr    $0xc,%eax
}
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    

008002dc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002df:	ff 75 08             	pushl  0x8(%ebp)
  8002e2:	e8 e5 ff ff ff       	call   8002cc <fd2num>
  8002e7:	83 c4 04             	add    $0x4,%esp
  8002ea:	c1 e0 0c             	shl    $0xc,%eax
  8002ed:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002fa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8002ff:	89 c2                	mov    %eax,%edx
  800301:	c1 ea 16             	shr    $0x16,%edx
  800304:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80030b:	f6 c2 01             	test   $0x1,%dl
  80030e:	74 11                	je     800321 <fd_alloc+0x2d>
  800310:	89 c2                	mov    %eax,%edx
  800312:	c1 ea 0c             	shr    $0xc,%edx
  800315:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80031c:	f6 c2 01             	test   $0x1,%dl
  80031f:	75 09                	jne    80032a <fd_alloc+0x36>
			*fd_store = fd;
  800321:	89 01                	mov    %eax,(%ecx)
			return 0;
  800323:	b8 00 00 00 00       	mov    $0x0,%eax
  800328:	eb 17                	jmp    800341 <fd_alloc+0x4d>
  80032a:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80032f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800334:	75 c9                	jne    8002ff <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800336:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80033c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800341:	5d                   	pop    %ebp
  800342:	c3                   	ret    

00800343 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800349:	83 f8 1f             	cmp    $0x1f,%eax
  80034c:	77 36                	ja     800384 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80034e:	c1 e0 0c             	shl    $0xc,%eax
  800351:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800356:	89 c2                	mov    %eax,%edx
  800358:	c1 ea 16             	shr    $0x16,%edx
  80035b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800362:	f6 c2 01             	test   $0x1,%dl
  800365:	74 24                	je     80038b <fd_lookup+0x48>
  800367:	89 c2                	mov    %eax,%edx
  800369:	c1 ea 0c             	shr    $0xc,%edx
  80036c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800373:	f6 c2 01             	test   $0x1,%dl
  800376:	74 1a                	je     800392 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037b:	89 02                	mov    %eax,(%edx)
	return 0;
  80037d:	b8 00 00 00 00       	mov    $0x0,%eax
  800382:	eb 13                	jmp    800397 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800384:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800389:	eb 0c                	jmp    800397 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80038b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800390:	eb 05                	jmp    800397 <fd_lookup+0x54>
  800392:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a2:	ba f8 1d 80 00       	mov    $0x801df8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003a7:	eb 13                	jmp    8003bc <dev_lookup+0x23>
  8003a9:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8003ac:	39 08                	cmp    %ecx,(%eax)
  8003ae:	75 0c                	jne    8003bc <dev_lookup+0x23>
			*dev = devtab[i];
  8003b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ba:	eb 2e                	jmp    8003ea <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003bc:	8b 02                	mov    (%edx),%eax
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	75 e7                	jne    8003a9 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8003c7:	8b 40 48             	mov    0x48(%eax),%eax
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	51                   	push   %ecx
  8003ce:	50                   	push   %eax
  8003cf:	68 7c 1d 80 00       	push   $0x801d7c
  8003d4:	e8 d9 0c 00 00       	call   8010b2 <cprintf>
	*dev = 0;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8003ea:	c9                   	leave  
  8003eb:	c3                   	ret    

008003ec <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	56                   	push   %esi
  8003f0:	53                   	push   %ebx
  8003f1:	83 ec 10             	sub    $0x10,%esp
  8003f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8003fa:	56                   	push   %esi
  8003fb:	e8 cc fe ff ff       	call   8002cc <fd2num>
  800400:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800403:	89 14 24             	mov    %edx,(%esp)
  800406:	50                   	push   %eax
  800407:	e8 37 ff ff ff       	call   800343 <fd_lookup>
  80040c:	83 c4 08             	add    $0x8,%esp
  80040f:	85 c0                	test   %eax,%eax
  800411:	78 05                	js     800418 <fd_close+0x2c>
	    || fd != fd2)
  800413:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800416:	74 0c                	je     800424 <fd_close+0x38>
		return (must_exist ? r : 0);
  800418:	84 db                	test   %bl,%bl
  80041a:	ba 00 00 00 00       	mov    $0x0,%edx
  80041f:	0f 44 c2             	cmove  %edx,%eax
  800422:	eb 41                	jmp    800465 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	ff 36                	pushl  (%esi)
  80042d:	e8 67 ff ff ff       	call   800399 <dev_lookup>
  800432:	89 c3                	mov    %eax,%ebx
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	85 c0                	test   %eax,%eax
  800439:	78 1a                	js     800455 <fd_close+0x69>
		if (dev->dev_close)
  80043b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043e:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800441:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800446:	85 c0                	test   %eax,%eax
  800448:	74 0b                	je     800455 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	56                   	push   %esi
  80044e:	ff d0                	call   *%eax
  800450:	89 c3                	mov    %eax,%ebx
  800452:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	56                   	push   %esi
  800459:	6a 00                	push   $0x0
  80045b:	e8 99 fd ff ff       	call   8001f9 <sys_page_unmap>
	return r;
  800460:	83 c4 10             	add    $0x10,%esp
  800463:	89 d8                	mov    %ebx,%eax
}
  800465:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800468:	5b                   	pop    %ebx
  800469:	5e                   	pop    %esi
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800472:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800475:	50                   	push   %eax
  800476:	ff 75 08             	pushl  0x8(%ebp)
  800479:	e8 c5 fe ff ff       	call   800343 <fd_lookup>
  80047e:	83 c4 08             	add    $0x8,%esp
  800481:	85 c0                	test   %eax,%eax
  800483:	78 10                	js     800495 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	6a 01                	push   $0x1
  80048a:	ff 75 f4             	pushl  -0xc(%ebp)
  80048d:	e8 5a ff ff ff       	call   8003ec <fd_close>
  800492:	83 c4 10             	add    $0x10,%esp
}
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <close_all>:

void
close_all(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	53                   	push   %ebx
  80049b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80049e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	e8 c0 ff ff ff       	call   80046c <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8004ac:	83 c3 01             	add    $0x1,%ebx
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	83 fb 20             	cmp    $0x20,%ebx
  8004b5:	75 ec                	jne    8004a3 <close_all+0xc>
		close(i);
}
  8004b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	57                   	push   %edi
  8004c0:	56                   	push   %esi
  8004c1:	53                   	push   %ebx
  8004c2:	83 ec 2c             	sub    $0x2c,%esp
  8004c5:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004cb:	50                   	push   %eax
  8004cc:	ff 75 08             	pushl  0x8(%ebp)
  8004cf:	e8 6f fe ff ff       	call   800343 <fd_lookup>
  8004d4:	83 c4 08             	add    $0x8,%esp
  8004d7:	85 c0                	test   %eax,%eax
  8004d9:	0f 88 c1 00 00 00    	js     8005a0 <dup+0xe4>
		return r;
	close(newfdnum);
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	56                   	push   %esi
  8004e3:	e8 84 ff ff ff       	call   80046c <close>

	newfd = INDEX2FD(newfdnum);
  8004e8:	89 f3                	mov    %esi,%ebx
  8004ea:	c1 e3 0c             	shl    $0xc,%ebx
  8004ed:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8004f3:	83 c4 04             	add    $0x4,%esp
  8004f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004f9:	e8 de fd ff ff       	call   8002dc <fd2data>
  8004fe:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800500:	89 1c 24             	mov    %ebx,(%esp)
  800503:	e8 d4 fd ff ff       	call   8002dc <fd2data>
  800508:	83 c4 10             	add    $0x10,%esp
  80050b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80050e:	89 f8                	mov    %edi,%eax
  800510:	c1 e8 16             	shr    $0x16,%eax
  800513:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80051a:	a8 01                	test   $0x1,%al
  80051c:	74 37                	je     800555 <dup+0x99>
  80051e:	89 f8                	mov    %edi,%eax
  800520:	c1 e8 0c             	shr    $0xc,%eax
  800523:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80052a:	f6 c2 01             	test   $0x1,%dl
  80052d:	74 26                	je     800555 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80052f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800536:	83 ec 0c             	sub    $0xc,%esp
  800539:	25 07 0e 00 00       	and    $0xe07,%eax
  80053e:	50                   	push   %eax
  80053f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800542:	6a 00                	push   $0x0
  800544:	57                   	push   %edi
  800545:	6a 00                	push   $0x0
  800547:	e8 87 fc ff ff       	call   8001d3 <sys_page_map>
  80054c:	89 c7                	mov    %eax,%edi
  80054e:	83 c4 20             	add    $0x20,%esp
  800551:	85 c0                	test   %eax,%eax
  800553:	78 2e                	js     800583 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800558:	89 d0                	mov    %edx,%eax
  80055a:	c1 e8 0c             	shr    $0xc,%eax
  80055d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	25 07 0e 00 00       	and    $0xe07,%eax
  80056c:	50                   	push   %eax
  80056d:	53                   	push   %ebx
  80056e:	6a 00                	push   $0x0
  800570:	52                   	push   %edx
  800571:	6a 00                	push   $0x0
  800573:	e8 5b fc ff ff       	call   8001d3 <sys_page_map>
  800578:	89 c7                	mov    %eax,%edi
  80057a:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80057d:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80057f:	85 ff                	test   %edi,%edi
  800581:	79 1d                	jns    8005a0 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	6a 00                	push   $0x0
  800589:	e8 6b fc ff ff       	call   8001f9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80058e:	83 c4 08             	add    $0x8,%esp
  800591:	ff 75 d4             	pushl  -0x2c(%ebp)
  800594:	6a 00                	push   $0x0
  800596:	e8 5e fc ff ff       	call   8001f9 <sys_page_unmap>
	return r;
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	89 f8                	mov    %edi,%eax
}
  8005a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a3:	5b                   	pop    %ebx
  8005a4:	5e                   	pop    %esi
  8005a5:	5f                   	pop    %edi
  8005a6:	5d                   	pop    %ebp
  8005a7:	c3                   	ret    

008005a8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
  8005ab:	53                   	push   %ebx
  8005ac:	83 ec 14             	sub    $0x14,%esp
  8005af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005b5:	50                   	push   %eax
  8005b6:	53                   	push   %ebx
  8005b7:	e8 87 fd ff ff       	call   800343 <fd_lookup>
  8005bc:	83 c4 08             	add    $0x8,%esp
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	85 c0                	test   %eax,%eax
  8005c3:	78 6d                	js     800632 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cf:	ff 30                	pushl  (%eax)
  8005d1:	e8 c3 fd ff ff       	call   800399 <dev_lookup>
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	85 c0                	test   %eax,%eax
  8005db:	78 4c                	js     800629 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005e0:	8b 42 08             	mov    0x8(%edx),%eax
  8005e3:	83 e0 03             	and    $0x3,%eax
  8005e6:	83 f8 01             	cmp    $0x1,%eax
  8005e9:	75 21                	jne    80060c <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8005eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8005f0:	8b 40 48             	mov    0x48(%eax),%eax
  8005f3:	83 ec 04             	sub    $0x4,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	50                   	push   %eax
  8005f8:	68 bd 1d 80 00       	push   $0x801dbd
  8005fd:	e8 b0 0a 00 00       	call   8010b2 <cprintf>
		return -E_INVAL;
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80060a:	eb 26                	jmp    800632 <read+0x8a>
	}
	if (!dev->dev_read)
  80060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060f:	8b 40 08             	mov    0x8(%eax),%eax
  800612:	85 c0                	test   %eax,%eax
  800614:	74 17                	je     80062d <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 10             	pushl  0x10(%ebp)
  80061c:	ff 75 0c             	pushl  0xc(%ebp)
  80061f:	52                   	push   %edx
  800620:	ff d0                	call   *%eax
  800622:	89 c2                	mov    %eax,%edx
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	eb 09                	jmp    800632 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800629:	89 c2                	mov    %eax,%edx
  80062b:	eb 05                	jmp    800632 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80062d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800632:	89 d0                	mov    %edx,%eax
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
  80063c:	57                   	push   %edi
  80063d:	56                   	push   %esi
  80063e:	53                   	push   %ebx
  80063f:	83 ec 0c             	sub    $0xc,%esp
  800642:	8b 7d 08             	mov    0x8(%ebp),%edi
  800645:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	eb 21                	jmp    800670 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80064f:	83 ec 04             	sub    $0x4,%esp
  800652:	89 f0                	mov    %esi,%eax
  800654:	29 d8                	sub    %ebx,%eax
  800656:	50                   	push   %eax
  800657:	89 d8                	mov    %ebx,%eax
  800659:	03 45 0c             	add    0xc(%ebp),%eax
  80065c:	50                   	push   %eax
  80065d:	57                   	push   %edi
  80065e:	e8 45 ff ff ff       	call   8005a8 <read>
		if (m < 0)
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	85 c0                	test   %eax,%eax
  800668:	78 10                	js     80067a <readn+0x41>
			return m;
		if (m == 0)
  80066a:	85 c0                	test   %eax,%eax
  80066c:	74 0a                	je     800678 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80066e:	01 c3                	add    %eax,%ebx
  800670:	39 f3                	cmp    %esi,%ebx
  800672:	72 db                	jb     80064f <readn+0x16>
  800674:	89 d8                	mov    %ebx,%eax
  800676:	eb 02                	jmp    80067a <readn+0x41>
  800678:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80067a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067d:	5b                   	pop    %ebx
  80067e:	5e                   	pop    %esi
  80067f:	5f                   	pop    %edi
  800680:	5d                   	pop    %ebp
  800681:	c3                   	ret    

00800682 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	53                   	push   %ebx
  800686:	83 ec 14             	sub    $0x14,%esp
  800689:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80068c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80068f:	50                   	push   %eax
  800690:	53                   	push   %ebx
  800691:	e8 ad fc ff ff       	call   800343 <fd_lookup>
  800696:	83 c4 08             	add    $0x8,%esp
  800699:	89 c2                	mov    %eax,%edx
  80069b:	85 c0                	test   %eax,%eax
  80069d:	78 68                	js     800707 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006a5:	50                   	push   %eax
  8006a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a9:	ff 30                	pushl  (%eax)
  8006ab:	e8 e9 fc ff ff       	call   800399 <dev_lookup>
  8006b0:	83 c4 10             	add    $0x10,%esp
  8006b3:	85 c0                	test   %eax,%eax
  8006b5:	78 47                	js     8006fe <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006be:	75 21                	jne    8006e1 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8006c5:	8b 40 48             	mov    0x48(%eax),%eax
  8006c8:	83 ec 04             	sub    $0x4,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	50                   	push   %eax
  8006cd:	68 d9 1d 80 00       	push   $0x801dd9
  8006d2:	e8 db 09 00 00       	call   8010b2 <cprintf>
		return -E_INVAL;
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006df:	eb 26                	jmp    800707 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e4:	8b 52 0c             	mov    0xc(%edx),%edx
  8006e7:	85 d2                	test   %edx,%edx
  8006e9:	74 17                	je     800702 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8006eb:	83 ec 04             	sub    $0x4,%esp
  8006ee:	ff 75 10             	pushl  0x10(%ebp)
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	50                   	push   %eax
  8006f5:	ff d2                	call   *%edx
  8006f7:	89 c2                	mov    %eax,%edx
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	eb 09                	jmp    800707 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006fe:	89 c2                	mov    %eax,%edx
  800700:	eb 05                	jmp    800707 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800702:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  800707:	89 d0                	mov    %edx,%eax
  800709:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070c:	c9                   	leave  
  80070d:	c3                   	ret    

0080070e <seek>:

int
seek(int fdnum, off_t offset)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800714:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800717:	50                   	push   %eax
  800718:	ff 75 08             	pushl  0x8(%ebp)
  80071b:	e8 23 fc ff ff       	call   800343 <fd_lookup>
  800720:	83 c4 08             	add    $0x8,%esp
  800723:	85 c0                	test   %eax,%eax
  800725:	78 0e                	js     800735 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800735:	c9                   	leave  
  800736:	c3                   	ret    

00800737 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	53                   	push   %ebx
  80073b:	83 ec 14             	sub    $0x14,%esp
  80073e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800741:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	53                   	push   %ebx
  800746:	e8 f8 fb ff ff       	call   800343 <fd_lookup>
  80074b:	83 c4 08             	add    $0x8,%esp
  80074e:	89 c2                	mov    %eax,%edx
  800750:	85 c0                	test   %eax,%eax
  800752:	78 65                	js     8007b9 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80075a:	50                   	push   %eax
  80075b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075e:	ff 30                	pushl  (%eax)
  800760:	e8 34 fc ff ff       	call   800399 <dev_lookup>
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	85 c0                	test   %eax,%eax
  80076a:	78 44                	js     8007b0 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80076c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800773:	75 21                	jne    800796 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800775:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80077a:	8b 40 48             	mov    0x48(%eax),%eax
  80077d:	83 ec 04             	sub    $0x4,%esp
  800780:	53                   	push   %ebx
  800781:	50                   	push   %eax
  800782:	68 9c 1d 80 00       	push   $0x801d9c
  800787:	e8 26 09 00 00       	call   8010b2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800794:	eb 23                	jmp    8007b9 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	8b 52 18             	mov    0x18(%edx),%edx
  80079c:	85 d2                	test   %edx,%edx
  80079e:	74 14                	je     8007b4 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	ff d2                	call   *%edx
  8007a9:	89 c2                	mov    %eax,%edx
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	eb 09                	jmp    8007b9 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007b0:	89 c2                	mov    %eax,%edx
  8007b2:	eb 05                	jmp    8007b9 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007b4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007b9:	89 d0                	mov    %edx,%eax
  8007bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	53                   	push   %ebx
  8007c4:	83 ec 14             	sub    $0x14,%esp
  8007c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007cd:	50                   	push   %eax
  8007ce:	ff 75 08             	pushl  0x8(%ebp)
  8007d1:	e8 6d fb ff ff       	call   800343 <fd_lookup>
  8007d6:	83 c4 08             	add    $0x8,%esp
  8007d9:	89 c2                	mov    %eax,%edx
  8007db:	85 c0                	test   %eax,%eax
  8007dd:	78 58                	js     800837 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e5:	50                   	push   %eax
  8007e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e9:	ff 30                	pushl  (%eax)
  8007eb:	e8 a9 fb ff ff       	call   800399 <dev_lookup>
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	85 c0                	test   %eax,%eax
  8007f5:	78 37                	js     80082e <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8007f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007fa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8007fe:	74 32                	je     800832 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800800:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800803:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80080a:	00 00 00 
	stat->st_isdir = 0;
  80080d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800814:	00 00 00 
	stat->st_dev = dev;
  800817:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	ff 75 f0             	pushl  -0x10(%ebp)
  800824:	ff 50 14             	call   *0x14(%eax)
  800827:	89 c2                	mov    %eax,%edx
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	eb 09                	jmp    800837 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80082e:	89 c2                	mov    %eax,%edx
  800830:	eb 05                	jmp    800837 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800832:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800837:	89 d0                	mov    %edx,%eax
  800839:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083c:	c9                   	leave  
  80083d:	c3                   	ret    

0080083e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	56                   	push   %esi
  800842:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	6a 00                	push   $0x0
  800848:	ff 75 08             	pushl  0x8(%ebp)
  80084b:	e8 06 02 00 00       	call   800a56 <open>
  800850:	89 c3                	mov    %eax,%ebx
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	85 c0                	test   %eax,%eax
  800857:	78 1b                	js     800874 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	50                   	push   %eax
  800860:	e8 5b ff ff ff       	call   8007c0 <fstat>
  800865:	89 c6                	mov    %eax,%esi
	close(fd);
  800867:	89 1c 24             	mov    %ebx,(%esp)
  80086a:	e8 fd fb ff ff       	call   80046c <close>
	return r;
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	89 f0                	mov    %esi,%eax
}
  800874:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800877:	5b                   	pop    %ebx
  800878:	5e                   	pop    %esi
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	56                   	push   %esi
  80087f:	53                   	push   %ebx
  800880:	89 c6                	mov    %eax,%esi
  800882:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800884:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80088b:	75 12                	jne    80089f <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80088d:	83 ec 0c             	sub    $0xc,%esp
  800890:	6a 01                	push   $0x1
  800892:	e8 94 11 00 00       	call   801a2b <ipc_find_env>
  800897:	a3 00 40 80 00       	mov    %eax,0x804000
  80089c:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80089f:	6a 07                	push   $0x7
  8008a1:	68 00 50 80 00       	push   $0x805000
  8008a6:	56                   	push   %esi
  8008a7:	ff 35 00 40 80 00    	pushl  0x804000
  8008ad:	e8 25 11 00 00       	call   8019d7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008b2:	83 c4 0c             	add    $0xc,%esp
  8008b5:	6a 00                	push   $0x0
  8008b7:	53                   	push   %ebx
  8008b8:	6a 00                	push   $0x0
  8008ba:	e8 ad 10 00 00       	call   80196c <ipc_recv>
}
  8008bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008c2:	5b                   	pop    %ebx
  8008c3:	5e                   	pop    %esi
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8008d2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008df:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e4:	b8 02 00 00 00       	mov    $0x2,%eax
  8008e9:	e8 8d ff ff ff       	call   80087b <fsipc>
}
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8008fc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800901:	ba 00 00 00 00       	mov    $0x0,%edx
  800906:	b8 06 00 00 00       	mov    $0x6,%eax
  80090b:	e8 6b ff ff ff       	call   80087b <fsipc>
}
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	53                   	push   %ebx
  800916:	83 ec 04             	sub    $0x4,%esp
  800919:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 40 0c             	mov    0xc(%eax),%eax
  800922:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800927:	ba 00 00 00 00       	mov    $0x0,%edx
  80092c:	b8 05 00 00 00       	mov    $0x5,%eax
  800931:	e8 45 ff ff ff       	call   80087b <fsipc>
  800936:	85 c0                	test   %eax,%eax
  800938:	78 2c                	js     800966 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	68 00 50 80 00       	push   $0x805000
  800942:	53                   	push   %ebx
  800943:	e8 dc 0c 00 00       	call   801624 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800948:	a1 80 50 80 00       	mov    0x805080,%eax
  80094d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800953:	a1 84 50 80 00       	mov    0x805084,%eax
  800958:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	8b 55 0c             	mov    0xc(%ebp),%edx
  800974:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800977:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097a:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80097d:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  800983:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800988:	76 22                	jbe    8009ac <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80098a:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  800991:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  800994:	83 ec 04             	sub    $0x4,%esp
  800997:	68 f8 0f 00 00       	push   $0xff8
  80099c:	52                   	push   %edx
  80099d:	68 08 50 80 00       	push   $0x805008
  8009a2:	e8 10 0e 00 00       	call   8017b7 <memmove>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	eb 17                	jmp    8009c3 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8009ac:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	52                   	push   %edx
  8009b6:	68 08 50 80 00       	push   $0x805008
  8009bb:	e8 f7 0d 00 00       	call   8017b7 <memmove>
  8009c0:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c8:	b8 04 00 00 00       	mov    $0x4,%eax
  8009cd:	e8 a9 fe ff ff       	call   80087b <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009d2:	c9                   	leave  
  8009d3:	c3                   	ret    

008009d4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	56                   	push   %esi
  8009d8:	53                   	push   %ebx
  8009d9:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8009e7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8009ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f2:	b8 03 00 00 00       	mov    $0x3,%eax
  8009f7:	e8 7f fe ff ff       	call   80087b <fsipc>
  8009fc:	89 c3                	mov    %eax,%ebx
  8009fe:	85 c0                	test   %eax,%eax
  800a00:	78 4b                	js     800a4d <devfile_read+0x79>
		return r;
	assert(r <= n);
  800a02:	39 c6                	cmp    %eax,%esi
  800a04:	73 16                	jae    800a1c <devfile_read+0x48>
  800a06:	68 08 1e 80 00       	push   $0x801e08
  800a0b:	68 0f 1e 80 00       	push   $0x801e0f
  800a10:	6a 7c                	push   $0x7c
  800a12:	68 24 1e 80 00       	push   $0x801e24
  800a17:	e8 bd 05 00 00       	call   800fd9 <_panic>
	assert(r <= PGSIZE);
  800a1c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a21:	7e 16                	jle    800a39 <devfile_read+0x65>
  800a23:	68 2f 1e 80 00       	push   $0x801e2f
  800a28:	68 0f 1e 80 00       	push   $0x801e0f
  800a2d:	6a 7d                	push   $0x7d
  800a2f:	68 24 1e 80 00       	push   $0x801e24
  800a34:	e8 a0 05 00 00       	call   800fd9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a39:	83 ec 04             	sub    $0x4,%esp
  800a3c:	50                   	push   %eax
  800a3d:	68 00 50 80 00       	push   $0x805000
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	e8 6d 0d 00 00       	call   8017b7 <memmove>
	return r;
  800a4a:	83 c4 10             	add    $0x10,%esp
}
  800a4d:	89 d8                	mov    %ebx,%eax
  800a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	53                   	push   %ebx
  800a5a:	83 ec 20             	sub    $0x20,%esp
  800a5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a60:	53                   	push   %ebx
  800a61:	e8 85 0b 00 00       	call   8015eb <strlen>
  800a66:	83 c4 10             	add    $0x10,%esp
  800a69:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a6e:	7f 67                	jg     800ad7 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a70:	83 ec 0c             	sub    $0xc,%esp
  800a73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a76:	50                   	push   %eax
  800a77:	e8 78 f8 ff ff       	call   8002f4 <fd_alloc>
  800a7c:	83 c4 10             	add    $0x10,%esp
		return r;
  800a7f:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a81:	85 c0                	test   %eax,%eax
  800a83:	78 57                	js     800adc <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800a85:	83 ec 08             	sub    $0x8,%esp
  800a88:	53                   	push   %ebx
  800a89:	68 00 50 80 00       	push   $0x805000
  800a8e:	e8 91 0b 00 00       	call   801624 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  800aa3:	e8 d3 fd ff ff       	call   80087b <fsipc>
  800aa8:	89 c3                	mov    %eax,%ebx
  800aaa:	83 c4 10             	add    $0x10,%esp
  800aad:	85 c0                	test   %eax,%eax
  800aaf:	79 14                	jns    800ac5 <open+0x6f>
		fd_close(fd, 0);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	6a 00                	push   $0x0
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	e8 2e f9 ff ff       	call   8003ec <fd_close>
		return r;
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	89 da                	mov    %ebx,%edx
  800ac3:	eb 17                	jmp    800adc <open+0x86>
	}

	return fd2num(fd);
  800ac5:	83 ec 0c             	sub    $0xc,%esp
  800ac8:	ff 75 f4             	pushl  -0xc(%ebp)
  800acb:	e8 fc f7 ff ff       	call   8002cc <fd2num>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	83 c4 10             	add    $0x10,%esp
  800ad5:	eb 05                	jmp    800adc <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800ad7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800adc:	89 d0                	mov    %edx,%eax
  800ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    

00800ae3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  800aee:	b8 08 00 00 00       	mov    $0x8,%eax
  800af3:	e8 83 fd ff ff       	call   80087b <fsipc>
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b02:	83 ec 0c             	sub    $0xc,%esp
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 cf f7 ff ff       	call   8002dc <fd2data>
  800b0d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b0f:	83 c4 08             	add    $0x8,%esp
  800b12:	68 3b 1e 80 00       	push   $0x801e3b
  800b17:	53                   	push   %ebx
  800b18:	e8 07 0b 00 00       	call   801624 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b1d:	8b 46 04             	mov    0x4(%esi),%eax
  800b20:	2b 06                	sub    (%esi),%eax
  800b22:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b28:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b2f:	00 00 00 
	stat->st_dev = &devpipe;
  800b32:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b39:	30 80 00 
	return 0;
}
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b44:	5b                   	pop    %ebx
  800b45:	5e                   	pop    %esi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	53                   	push   %ebx
  800b4c:	83 ec 0c             	sub    $0xc,%esp
  800b4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b52:	53                   	push   %ebx
  800b53:	6a 00                	push   $0x0
  800b55:	e8 9f f6 ff ff       	call   8001f9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b5a:	89 1c 24             	mov    %ebx,(%esp)
  800b5d:	e8 7a f7 ff ff       	call   8002dc <fd2data>
  800b62:	83 c4 08             	add    $0x8,%esp
  800b65:	50                   	push   %eax
  800b66:	6a 00                	push   $0x0
  800b68:	e8 8c f6 ff ff       	call   8001f9 <sys_page_unmap>
}
  800b6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b70:	c9                   	leave  
  800b71:	c3                   	ret    

00800b72 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	83 ec 1c             	sub    $0x1c,%esp
  800b7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b7e:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b80:	a1 04 40 80 00       	mov    0x804004,%eax
  800b85:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800b88:	83 ec 0c             	sub    $0xc,%esp
  800b8b:	ff 75 e0             	pushl  -0x20(%ebp)
  800b8e:	e8 d1 0e 00 00       	call   801a64 <pageref>
  800b93:	89 c3                	mov    %eax,%ebx
  800b95:	89 3c 24             	mov    %edi,(%esp)
  800b98:	e8 c7 0e 00 00       	call   801a64 <pageref>
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	39 c3                	cmp    %eax,%ebx
  800ba2:	0f 94 c1             	sete   %cl
  800ba5:	0f b6 c9             	movzbl %cl,%ecx
  800ba8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800bab:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800bb1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800bb4:	39 ce                	cmp    %ecx,%esi
  800bb6:	74 1b                	je     800bd3 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800bb8:	39 c3                	cmp    %eax,%ebx
  800bba:	75 c4                	jne    800b80 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bbc:	8b 42 58             	mov    0x58(%edx),%eax
  800bbf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bc2:	50                   	push   %eax
  800bc3:	56                   	push   %esi
  800bc4:	68 42 1e 80 00       	push   $0x801e42
  800bc9:	e8 e4 04 00 00       	call   8010b2 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	eb ad                	jmp    800b80 <_pipeisclosed+0xe>
	}
}
  800bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd9:	5b                   	pop    %ebx
  800bda:	5e                   	pop    %esi
  800bdb:	5f                   	pop    %edi
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	83 ec 28             	sub    $0x28,%esp
  800be7:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800bea:	56                   	push   %esi
  800beb:	e8 ec f6 ff ff       	call   8002dc <fd2data>
  800bf0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfa:	eb 4b                	jmp    800c47 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800bfc:	89 da                	mov    %ebx,%edx
  800bfe:	89 f0                	mov    %esi,%eax
  800c00:	e8 6d ff ff ff       	call   800b72 <_pipeisclosed>
  800c05:	85 c0                	test   %eax,%eax
  800c07:	75 48                	jne    800c51 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800c09:	e8 7a f5 ff ff       	call   800188 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c0e:	8b 43 04             	mov    0x4(%ebx),%eax
  800c11:	8b 0b                	mov    (%ebx),%ecx
  800c13:	8d 51 20             	lea    0x20(%ecx),%edx
  800c16:	39 d0                	cmp    %edx,%eax
  800c18:	73 e2                	jae    800bfc <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c21:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c24:	89 c2                	mov    %eax,%edx
  800c26:	c1 fa 1f             	sar    $0x1f,%edx
  800c29:	89 d1                	mov    %edx,%ecx
  800c2b:	c1 e9 1b             	shr    $0x1b,%ecx
  800c2e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c31:	83 e2 1f             	and    $0x1f,%edx
  800c34:	29 ca                	sub    %ecx,%edx
  800c36:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c3a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c3e:	83 c0 01             	add    $0x1,%eax
  800c41:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c44:	83 c7 01             	add    $0x1,%edi
  800c47:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c4a:	75 c2                	jne    800c0e <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4f:	eb 05                	jmp    800c56 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c59:	5b                   	pop    %ebx
  800c5a:	5e                   	pop    %esi
  800c5b:	5f                   	pop    %edi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	57                   	push   %edi
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
  800c64:	83 ec 18             	sub    $0x18,%esp
  800c67:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c6a:	57                   	push   %edi
  800c6b:	e8 6c f6 ff ff       	call   8002dc <fd2data>
  800c70:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c72:	83 c4 10             	add    $0x10,%esp
  800c75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7a:	eb 3d                	jmp    800cb9 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c7c:	85 db                	test   %ebx,%ebx
  800c7e:	74 04                	je     800c84 <devpipe_read+0x26>
				return i;
  800c80:	89 d8                	mov    %ebx,%eax
  800c82:	eb 44                	jmp    800cc8 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c84:	89 f2                	mov    %esi,%edx
  800c86:	89 f8                	mov    %edi,%eax
  800c88:	e8 e5 fe ff ff       	call   800b72 <_pipeisclosed>
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	75 32                	jne    800cc3 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800c91:	e8 f2 f4 ff ff       	call   800188 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800c96:	8b 06                	mov    (%esi),%eax
  800c98:	3b 46 04             	cmp    0x4(%esi),%eax
  800c9b:	74 df                	je     800c7c <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800c9d:	99                   	cltd   
  800c9e:	c1 ea 1b             	shr    $0x1b,%edx
  800ca1:	01 d0                	add    %edx,%eax
  800ca3:	83 e0 1f             	and    $0x1f,%eax
  800ca6:	29 d0                	sub    %edx,%eax
  800ca8:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb0:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800cb3:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800cb6:	83 c3 01             	add    $0x1,%ebx
  800cb9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cbc:	75 d8                	jne    800c96 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc1:	eb 05                	jmp    800cc8 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cc3:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cdb:	50                   	push   %eax
  800cdc:	e8 13 f6 ff ff       	call   8002f4 <fd_alloc>
  800ce1:	83 c4 10             	add    $0x10,%esp
  800ce4:	89 c2                	mov    %eax,%edx
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	0f 88 2c 01 00 00    	js     800e1a <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800cee:	83 ec 04             	sub    $0x4,%esp
  800cf1:	68 07 04 00 00       	push   $0x407
  800cf6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf9:	6a 00                	push   $0x0
  800cfb:	e8 af f4 ff ff       	call   8001af <sys_page_alloc>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	85 c0                	test   %eax,%eax
  800d07:	0f 88 0d 01 00 00    	js     800e1a <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d13:	50                   	push   %eax
  800d14:	e8 db f5 ff ff       	call   8002f4 <fd_alloc>
  800d19:	89 c3                	mov    %eax,%ebx
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	85 c0                	test   %eax,%eax
  800d20:	0f 88 e2 00 00 00    	js     800e08 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	68 07 04 00 00       	push   $0x407
  800d2e:	ff 75 f0             	pushl  -0x10(%ebp)
  800d31:	6a 00                	push   $0x0
  800d33:	e8 77 f4 ff ff       	call   8001af <sys_page_alloc>
  800d38:	89 c3                	mov    %eax,%ebx
  800d3a:	83 c4 10             	add    $0x10,%esp
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	0f 88 c3 00 00 00    	js     800e08 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d45:	83 ec 0c             	sub    $0xc,%esp
  800d48:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4b:	e8 8c f5 ff ff       	call   8002dc <fd2data>
  800d50:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d52:	83 c4 0c             	add    $0xc,%esp
  800d55:	68 07 04 00 00       	push   $0x407
  800d5a:	50                   	push   %eax
  800d5b:	6a 00                	push   $0x0
  800d5d:	e8 4d f4 ff ff       	call   8001af <sys_page_alloc>
  800d62:	89 c3                	mov    %eax,%ebx
  800d64:	83 c4 10             	add    $0x10,%esp
  800d67:	85 c0                	test   %eax,%eax
  800d69:	0f 88 89 00 00 00    	js     800df8 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	ff 75 f0             	pushl  -0x10(%ebp)
  800d75:	e8 62 f5 ff ff       	call   8002dc <fd2data>
  800d7a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d81:	50                   	push   %eax
  800d82:	6a 00                	push   $0x0
  800d84:	56                   	push   %esi
  800d85:	6a 00                	push   $0x0
  800d87:	e8 47 f4 ff ff       	call   8001d3 <sys_page_map>
  800d8c:	89 c3                	mov    %eax,%ebx
  800d8e:	83 c4 20             	add    $0x20,%esp
  800d91:	85 c0                	test   %eax,%eax
  800d93:	78 55                	js     800dea <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800d95:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800daa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc5:	e8 02 f5 ff ff       	call   8002cc <fd2num>
  800dca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dcd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dcf:	83 c4 04             	add    $0x4,%esp
  800dd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd5:	e8 f2 f4 ff ff       	call   8002cc <fd2num>
  800dda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ddd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	ba 00 00 00 00       	mov    $0x0,%edx
  800de8:	eb 30                	jmp    800e1a <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	56                   	push   %esi
  800dee:	6a 00                	push   $0x0
  800df0:	e8 04 f4 ff ff       	call   8001f9 <sys_page_unmap>
  800df5:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800df8:	83 ec 08             	sub    $0x8,%esp
  800dfb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dfe:	6a 00                	push   $0x0
  800e00:	e8 f4 f3 ff ff       	call   8001f9 <sys_page_unmap>
  800e05:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800e08:	83 ec 08             	sub    $0x8,%esp
  800e0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0e:	6a 00                	push   $0x0
  800e10:	e8 e4 f3 ff ff       	call   8001f9 <sys_page_unmap>
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e1a:	89 d0                	mov    %edx,%eax
  800e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e2c:	50                   	push   %eax
  800e2d:	ff 75 08             	pushl  0x8(%ebp)
  800e30:	e8 0e f5 ff ff       	call   800343 <fd_lookup>
  800e35:	83 c4 10             	add    $0x10,%esp
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	78 18                	js     800e54 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e3c:	83 ec 0c             	sub    $0xc,%esp
  800e3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e42:	e8 95 f4 ff ff       	call   8002dc <fd2data>
	return _pipeisclosed(fd, p);
  800e47:	89 c2                	mov    %eax,%edx
  800e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4c:	e8 21 fd ff ff       	call   800b72 <_pipeisclosed>
  800e51:	83 c4 10             	add    $0x10,%esp
}
  800e54:	c9                   	leave  
  800e55:	c3                   	ret    

00800e56 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e59:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e66:	68 5a 1e 80 00       	push   $0x801e5a
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	e8 b1 07 00 00       	call   801624 <strcpy>
	return 0;
}
  800e73:	b8 00 00 00 00       	mov    $0x0,%eax
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e86:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e8b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e91:	eb 2d                	jmp    800ec0 <devcons_write+0x46>
		m = n - tot;
  800e93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e96:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800e98:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800e9b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800ea0:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800ea3:	83 ec 04             	sub    $0x4,%esp
  800ea6:	53                   	push   %ebx
  800ea7:	03 45 0c             	add    0xc(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	57                   	push   %edi
  800eac:	e8 06 09 00 00       	call   8017b7 <memmove>
		sys_cputs(buf, m);
  800eb1:	83 c4 08             	add    $0x8,%esp
  800eb4:	53                   	push   %ebx
  800eb5:	57                   	push   %edi
  800eb6:	e8 3d f2 ff ff       	call   8000f8 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800ebb:	01 de                	add    %ebx,%esi
  800ebd:	83 c4 10             	add    $0x10,%esp
  800ec0:	89 f0                	mov    %esi,%eax
  800ec2:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ec5:	72 cc                	jb     800e93 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eca:	5b                   	pop    %ebx
  800ecb:	5e                   	pop    %esi
  800ecc:	5f                   	pop    %edi
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800eda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ede:	74 2a                	je     800f0a <devcons_read+0x3b>
  800ee0:	eb 05                	jmp    800ee7 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800ee2:	e8 a1 f2 ff ff       	call   800188 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800ee7:	e8 32 f2 ff ff       	call   80011e <sys_cgetc>
  800eec:	85 c0                	test   %eax,%eax
  800eee:	74 f2                	je     800ee2 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	78 16                	js     800f0a <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800ef4:	83 f8 04             	cmp    $0x4,%eax
  800ef7:	74 0c                	je     800f05 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efc:	88 02                	mov    %al,(%edx)
	return 1;
  800efe:	b8 01 00 00 00       	mov    $0x1,%eax
  800f03:	eb 05                	jmp    800f0a <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800f05:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f18:	6a 01                	push   $0x1
  800f1a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	e8 d5 f1 ff ff       	call   8000f8 <sys_cputs>
}
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <getchar>:

int
getchar(void)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f2e:	6a 01                	push   $0x1
  800f30:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f33:	50                   	push   %eax
  800f34:	6a 00                	push   $0x0
  800f36:	e8 6d f6 ff ff       	call   8005a8 <read>
	if (r < 0)
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	78 0f                	js     800f51 <getchar+0x29>
		return r;
	if (r < 1)
  800f42:	85 c0                	test   %eax,%eax
  800f44:	7e 06                	jle    800f4c <getchar+0x24>
		return -E_EOF;
	return c;
  800f46:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f4a:	eb 05                	jmp    800f51 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f4c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f5c:	50                   	push   %eax
  800f5d:	ff 75 08             	pushl  0x8(%ebp)
  800f60:	e8 de f3 ff ff       	call   800343 <fd_lookup>
  800f65:	83 c4 10             	add    $0x10,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	78 11                	js     800f7d <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800f75:	39 10                	cmp    %edx,(%eax)
  800f77:	0f 94 c0             	sete   %al
  800f7a:	0f b6 c0             	movzbl %al,%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <opencons>:

int
opencons(void)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f88:	50                   	push   %eax
  800f89:	e8 66 f3 ff ff       	call   8002f4 <fd_alloc>
  800f8e:	83 c4 10             	add    $0x10,%esp
		return r;
  800f91:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	78 3e                	js     800fd5 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f97:	83 ec 04             	sub    $0x4,%esp
  800f9a:	68 07 04 00 00       	push   $0x407
  800f9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa2:	6a 00                	push   $0x0
  800fa4:	e8 06 f2 ff ff       	call   8001af <sys_page_alloc>
  800fa9:	83 c4 10             	add    $0x10,%esp
		return r;
  800fac:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	78 23                	js     800fd5 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800fb2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fbb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fc7:	83 ec 0c             	sub    $0xc,%esp
  800fca:	50                   	push   %eax
  800fcb:	e8 fc f2 ff ff       	call   8002cc <fd2num>
  800fd0:	89 c2                	mov    %eax,%edx
  800fd2:	83 c4 10             	add    $0x10,%esp
}
  800fd5:	89 d0                	mov    %edx,%eax
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fde:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fe1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800fe7:	e8 78 f1 ff ff       	call   800164 <sys_getenvid>
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	56                   	push   %esi
  800ff6:	50                   	push   %eax
  800ff7:	68 68 1e 80 00       	push   $0x801e68
  800ffc:	e8 b1 00 00 00       	call   8010b2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801001:	83 c4 18             	add    $0x18,%esp
  801004:	53                   	push   %ebx
  801005:	ff 75 10             	pushl  0x10(%ebp)
  801008:	e8 54 00 00 00       	call   801061 <vcprintf>
	cprintf("\n");
  80100d:	c7 04 24 53 1e 80 00 	movl   $0x801e53,(%esp)
  801014:	e8 99 00 00 00       	call   8010b2 <cprintf>
  801019:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80101c:	cc                   	int3   
  80101d:	eb fd                	jmp    80101c <_panic+0x43>

0080101f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	53                   	push   %ebx
  801023:	83 ec 04             	sub    $0x4,%esp
  801026:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801029:	8b 13                	mov    (%ebx),%edx
  80102b:	8d 42 01             	lea    0x1(%edx),%eax
  80102e:	89 03                	mov    %eax,(%ebx)
  801030:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801033:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801037:	3d ff 00 00 00       	cmp    $0xff,%eax
  80103c:	75 1a                	jne    801058 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80103e:	83 ec 08             	sub    $0x8,%esp
  801041:	68 ff 00 00 00       	push   $0xff
  801046:	8d 43 08             	lea    0x8(%ebx),%eax
  801049:	50                   	push   %eax
  80104a:	e8 a9 f0 ff ff       	call   8000f8 <sys_cputs>
		b->idx = 0;
  80104f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801055:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801058:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80105c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80106a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801071:	00 00 00 
	b.cnt = 0;
  801074:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80107b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80107e:	ff 75 0c             	pushl  0xc(%ebp)
  801081:	ff 75 08             	pushl  0x8(%ebp)
  801084:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108a:	50                   	push   %eax
  80108b:	68 1f 10 80 00       	push   $0x80101f
  801090:	e8 86 01 00 00       	call   80121b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801095:	83 c4 08             	add    $0x8,%esp
  801098:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80109e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010a4:	50                   	push   %eax
  8010a5:	e8 4e f0 ff ff       	call   8000f8 <sys_cputs>

	return b.cnt;
}
  8010aa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010b8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010bb:	50                   	push   %eax
  8010bc:	ff 75 08             	pushl  0x8(%ebp)
  8010bf:	e8 9d ff ff ff       	call   801061 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
  8010cc:	83 ec 1c             	sub    $0x1c,%esp
  8010cf:	89 c7                	mov    %eax,%edi
  8010d1:	89 d6                	mov    %edx,%esi
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8010ea:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010ed:	39 d3                	cmp    %edx,%ebx
  8010ef:	72 05                	jb     8010f6 <printnum+0x30>
  8010f1:	39 45 10             	cmp    %eax,0x10(%ebp)
  8010f4:	77 45                	ja     80113b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010f6:	83 ec 0c             	sub    $0xc,%esp
  8010f9:	ff 75 18             	pushl  0x18(%ebp)
  8010fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801102:	53                   	push   %ebx
  801103:	ff 75 10             	pushl  0x10(%ebp)
  801106:	83 ec 08             	sub    $0x8,%esp
  801109:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110c:	ff 75 e0             	pushl  -0x20(%ebp)
  80110f:	ff 75 dc             	pushl  -0x24(%ebp)
  801112:	ff 75 d8             	pushl  -0x28(%ebp)
  801115:	e8 86 09 00 00       	call   801aa0 <__udivdi3>
  80111a:	83 c4 18             	add    $0x18,%esp
  80111d:	52                   	push   %edx
  80111e:	50                   	push   %eax
  80111f:	89 f2                	mov    %esi,%edx
  801121:	89 f8                	mov    %edi,%eax
  801123:	e8 9e ff ff ff       	call   8010c6 <printnum>
  801128:	83 c4 20             	add    $0x20,%esp
  80112b:	eb 18                	jmp    801145 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	56                   	push   %esi
  801131:	ff 75 18             	pushl  0x18(%ebp)
  801134:	ff d7                	call   *%edi
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	eb 03                	jmp    80113e <printnum+0x78>
  80113b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80113e:	83 eb 01             	sub    $0x1,%ebx
  801141:	85 db                	test   %ebx,%ebx
  801143:	7f e8                	jg     80112d <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	56                   	push   %esi
  801149:	83 ec 04             	sub    $0x4,%esp
  80114c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114f:	ff 75 e0             	pushl  -0x20(%ebp)
  801152:	ff 75 dc             	pushl  -0x24(%ebp)
  801155:	ff 75 d8             	pushl  -0x28(%ebp)
  801158:	e8 73 0a 00 00       	call   801bd0 <__umoddi3>
  80115d:	83 c4 14             	add    $0x14,%esp
  801160:	0f be 80 8b 1e 80 00 	movsbl 0x801e8b(%eax),%eax
  801167:	50                   	push   %eax
  801168:	ff d7                	call   *%edi
}
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801170:	5b                   	pop    %ebx
  801171:	5e                   	pop    %esi
  801172:	5f                   	pop    %edi
  801173:	5d                   	pop    %ebp
  801174:	c3                   	ret    

00801175 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801178:	83 fa 01             	cmp    $0x1,%edx
  80117b:	7e 0e                	jle    80118b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80117d:	8b 10                	mov    (%eax),%edx
  80117f:	8d 4a 08             	lea    0x8(%edx),%ecx
  801182:	89 08                	mov    %ecx,(%eax)
  801184:	8b 02                	mov    (%edx),%eax
  801186:	8b 52 04             	mov    0x4(%edx),%edx
  801189:	eb 22                	jmp    8011ad <getuint+0x38>
	else if (lflag)
  80118b:	85 d2                	test   %edx,%edx
  80118d:	74 10                	je     80119f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80118f:	8b 10                	mov    (%eax),%edx
  801191:	8d 4a 04             	lea    0x4(%edx),%ecx
  801194:	89 08                	mov    %ecx,(%eax)
  801196:	8b 02                	mov    (%edx),%eax
  801198:	ba 00 00 00 00       	mov    $0x0,%edx
  80119d:	eb 0e                	jmp    8011ad <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011a4:	89 08                	mov    %ecx,(%eax)
  8011a6:	8b 02                	mov    (%edx),%eax
  8011a8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011b2:	83 fa 01             	cmp    $0x1,%edx
  8011b5:	7e 0e                	jle    8011c5 <getint+0x16>
		return va_arg(*ap, long long);
  8011b7:	8b 10                	mov    (%eax),%edx
  8011b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011bc:	89 08                	mov    %ecx,(%eax)
  8011be:	8b 02                	mov    (%edx),%eax
  8011c0:	8b 52 04             	mov    0x4(%edx),%edx
  8011c3:	eb 1a                	jmp    8011df <getint+0x30>
	else if (lflag)
  8011c5:	85 d2                	test   %edx,%edx
  8011c7:	74 0c                	je     8011d5 <getint+0x26>
		return va_arg(*ap, long);
  8011c9:	8b 10                	mov    (%eax),%edx
  8011cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011ce:	89 08                	mov    %ecx,(%eax)
  8011d0:	8b 02                	mov    (%edx),%eax
  8011d2:	99                   	cltd   
  8011d3:	eb 0a                	jmp    8011df <getint+0x30>
	else
		return va_arg(*ap, int);
  8011d5:	8b 10                	mov    (%eax),%edx
  8011d7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011da:	89 08                	mov    %ecx,(%eax)
  8011dc:	8b 02                	mov    (%edx),%eax
  8011de:	99                   	cltd   
}
  8011df:	5d                   	pop    %ebp
  8011e0:	c3                   	ret    

008011e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011e7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011eb:	8b 10                	mov    (%eax),%edx
  8011ed:	3b 50 04             	cmp    0x4(%eax),%edx
  8011f0:	73 0a                	jae    8011fc <sprintputch+0x1b>
		*b->buf++ = ch;
  8011f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f5:	89 08                	mov    %ecx,(%eax)
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	88 02                	mov    %al,(%edx)
}
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  801204:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801207:	50                   	push   %eax
  801208:	ff 75 10             	pushl  0x10(%ebp)
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	ff 75 08             	pushl  0x8(%ebp)
  801211:	e8 05 00 00 00       	call   80121b <vprintfmt>
	va_end(ap);
}
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	57                   	push   %edi
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	83 ec 2c             	sub    $0x2c,%esp
  801224:	8b 75 08             	mov    0x8(%ebp),%esi
  801227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80122a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80122d:	eb 12                	jmp    801241 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80122f:	85 c0                	test   %eax,%eax
  801231:	0f 84 44 03 00 00    	je     80157b <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	53                   	push   %ebx
  80123b:	50                   	push   %eax
  80123c:	ff d6                	call   *%esi
  80123e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801241:	83 c7 01             	add    $0x1,%edi
  801244:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801248:	83 f8 25             	cmp    $0x25,%eax
  80124b:	75 e2                	jne    80122f <vprintfmt+0x14>
  80124d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801251:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801258:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80125f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801266:	ba 00 00 00 00       	mov    $0x0,%edx
  80126b:	eb 07                	jmp    801274 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80126d:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801270:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801274:	8d 47 01             	lea    0x1(%edi),%eax
  801277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80127a:	0f b6 07             	movzbl (%edi),%eax
  80127d:	0f b6 c8             	movzbl %al,%ecx
  801280:	83 e8 23             	sub    $0x23,%eax
  801283:	3c 55                	cmp    $0x55,%al
  801285:	0f 87 d5 02 00 00    	ja     801560 <vprintfmt+0x345>
  80128b:	0f b6 c0             	movzbl %al,%eax
  80128e:	ff 24 85 c0 1f 80 00 	jmp    *0x801fc0(,%eax,4)
  801295:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801298:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80129c:	eb d6                	jmp    801274 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80129e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8012a9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8012ac:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012b0:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012b3:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012b6:	83 fa 09             	cmp    $0x9,%edx
  8012b9:	77 39                	ja     8012f4 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012bb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012be:	eb e9                	jmp    8012a9 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c3:	8d 48 04             	lea    0x4(%eax),%ecx
  8012c6:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012d1:	eb 27                	jmp    8012fa <vprintfmt+0xdf>
  8012d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012dd:	0f 49 c8             	cmovns %eax,%ecx
  8012e0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012e6:	eb 8c                	jmp    801274 <vprintfmt+0x59>
  8012e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8012eb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012f2:	eb 80                	jmp    801274 <vprintfmt+0x59>
  8012f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012f7:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8012fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fe:	0f 89 70 ff ff ff    	jns    801274 <vprintfmt+0x59>
				width = precision, precision = -1;
  801304:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801307:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80130a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801311:	e9 5e ff ff ff       	jmp    801274 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801316:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80131c:	e9 53 ff ff ff       	jmp    801274 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801321:	8b 45 14             	mov    0x14(%ebp),%eax
  801324:	8d 50 04             	lea    0x4(%eax),%edx
  801327:	89 55 14             	mov    %edx,0x14(%ebp)
  80132a:	83 ec 08             	sub    $0x8,%esp
  80132d:	53                   	push   %ebx
  80132e:	ff 30                	pushl  (%eax)
  801330:	ff d6                	call   *%esi
			break;
  801332:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801338:	e9 04 ff ff ff       	jmp    801241 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	8d 50 04             	lea    0x4(%eax),%edx
  801343:	89 55 14             	mov    %edx,0x14(%ebp)
  801346:	8b 00                	mov    (%eax),%eax
  801348:	99                   	cltd   
  801349:	31 d0                	xor    %edx,%eax
  80134b:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80134d:	83 f8 0f             	cmp    $0xf,%eax
  801350:	7f 0b                	jg     80135d <vprintfmt+0x142>
  801352:	8b 14 85 20 21 80 00 	mov    0x802120(,%eax,4),%edx
  801359:	85 d2                	test   %edx,%edx
  80135b:	75 18                	jne    801375 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80135d:	50                   	push   %eax
  80135e:	68 a3 1e 80 00       	push   $0x801ea3
  801363:	53                   	push   %ebx
  801364:	56                   	push   %esi
  801365:	e8 94 fe ff ff       	call   8011fe <printfmt>
  80136a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80136d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801370:	e9 cc fe ff ff       	jmp    801241 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801375:	52                   	push   %edx
  801376:	68 21 1e 80 00       	push   $0x801e21
  80137b:	53                   	push   %ebx
  80137c:	56                   	push   %esi
  80137d:	e8 7c fe ff ff       	call   8011fe <printfmt>
  801382:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801388:	e9 b4 fe ff ff       	jmp    801241 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80138d:	8b 45 14             	mov    0x14(%ebp),%eax
  801390:	8d 50 04             	lea    0x4(%eax),%edx
  801393:	89 55 14             	mov    %edx,0x14(%ebp)
  801396:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801398:	85 ff                	test   %edi,%edi
  80139a:	b8 9c 1e 80 00       	mov    $0x801e9c,%eax
  80139f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8013a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013a6:	0f 8e 94 00 00 00    	jle    801440 <vprintfmt+0x225>
  8013ac:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013b0:	0f 84 98 00 00 00    	je     80144e <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8013bc:	57                   	push   %edi
  8013bd:	e8 41 02 00 00       	call   801603 <strnlen>
  8013c2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013c5:	29 c1                	sub    %eax,%ecx
  8013c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013ca:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013cd:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013d4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013d7:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d9:	eb 0f                	jmp    8013ea <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	53                   	push   %ebx
  8013df:	ff 75 e0             	pushl  -0x20(%ebp)
  8013e2:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013e4:	83 ef 01             	sub    $0x1,%edi
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 ff                	test   %edi,%edi
  8013ec:	7f ed                	jg     8013db <vprintfmt+0x1c0>
  8013ee:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013f1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8013f4:	85 c9                	test   %ecx,%ecx
  8013f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fb:	0f 49 c1             	cmovns %ecx,%eax
  8013fe:	29 c1                	sub    %eax,%ecx
  801400:	89 75 08             	mov    %esi,0x8(%ebp)
  801403:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801406:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801409:	89 cb                	mov    %ecx,%ebx
  80140b:	eb 4d                	jmp    80145a <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80140d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801411:	74 1b                	je     80142e <vprintfmt+0x213>
  801413:	0f be c0             	movsbl %al,%eax
  801416:	83 e8 20             	sub    $0x20,%eax
  801419:	83 f8 5e             	cmp    $0x5e,%eax
  80141c:	76 10                	jbe    80142e <vprintfmt+0x213>
					putch('?', putdat);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	6a 3f                	push   $0x3f
  801426:	ff 55 08             	call   *0x8(%ebp)
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	eb 0d                	jmp    80143b <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	52                   	push   %edx
  801435:	ff 55 08             	call   *0x8(%ebp)
  801438:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80143b:	83 eb 01             	sub    $0x1,%ebx
  80143e:	eb 1a                	jmp    80145a <vprintfmt+0x23f>
  801440:	89 75 08             	mov    %esi,0x8(%ebp)
  801443:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801446:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801449:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80144c:	eb 0c                	jmp    80145a <vprintfmt+0x23f>
  80144e:	89 75 08             	mov    %esi,0x8(%ebp)
  801451:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801454:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801457:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80145a:	83 c7 01             	add    $0x1,%edi
  80145d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801461:	0f be d0             	movsbl %al,%edx
  801464:	85 d2                	test   %edx,%edx
  801466:	74 23                	je     80148b <vprintfmt+0x270>
  801468:	85 f6                	test   %esi,%esi
  80146a:	78 a1                	js     80140d <vprintfmt+0x1f2>
  80146c:	83 ee 01             	sub    $0x1,%esi
  80146f:	79 9c                	jns    80140d <vprintfmt+0x1f2>
  801471:	89 df                	mov    %ebx,%edi
  801473:	8b 75 08             	mov    0x8(%ebp),%esi
  801476:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801479:	eb 18                	jmp    801493 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	53                   	push   %ebx
  80147f:	6a 20                	push   $0x20
  801481:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801483:	83 ef 01             	sub    $0x1,%edi
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	eb 08                	jmp    801493 <vprintfmt+0x278>
  80148b:	89 df                	mov    %ebx,%edi
  80148d:	8b 75 08             	mov    0x8(%ebp),%esi
  801490:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801493:	85 ff                	test   %edi,%edi
  801495:	7f e4                	jg     80147b <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80149a:	e9 a2 fd ff ff       	jmp    801241 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80149f:	8d 45 14             	lea    0x14(%ebp),%eax
  8014a2:	e8 08 fd ff ff       	call   8011af <getint>
  8014a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8014ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014b6:	79 74                	jns    80152c <vprintfmt+0x311>
				putch('-', putdat);
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	53                   	push   %ebx
  8014bc:	6a 2d                	push   $0x2d
  8014be:	ff d6                	call   *%esi
				num = -(long long) num;
  8014c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014c6:	f7 d8                	neg    %eax
  8014c8:	83 d2 00             	adc    $0x0,%edx
  8014cb:	f7 da                	neg    %edx
  8014cd:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014d0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014d5:	eb 55                	jmp    80152c <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014d7:	8d 45 14             	lea    0x14(%ebp),%eax
  8014da:	e8 96 fc ff ff       	call   801175 <getuint>
			base = 10;
  8014df:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014e4:	eb 46                	jmp    80152c <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8014e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e9:	e8 87 fc ff ff       	call   801175 <getuint>
			base = 8;
  8014ee:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8014f3:	eb 37                	jmp    80152c <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8014f5:	83 ec 08             	sub    $0x8,%esp
  8014f8:	53                   	push   %ebx
  8014f9:	6a 30                	push   $0x30
  8014fb:	ff d6                	call   *%esi
			putch('x', putdat);
  8014fd:	83 c4 08             	add    $0x8,%esp
  801500:	53                   	push   %ebx
  801501:	6a 78                	push   $0x78
  801503:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801505:	8b 45 14             	mov    0x14(%ebp),%eax
  801508:	8d 50 04             	lea    0x4(%eax),%edx
  80150b:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80150e:	8b 00                	mov    (%eax),%eax
  801510:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801515:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801518:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80151d:	eb 0d                	jmp    80152c <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80151f:	8d 45 14             	lea    0x14(%ebp),%eax
  801522:	e8 4e fc ff ff       	call   801175 <getuint>
			base = 16;
  801527:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801533:	57                   	push   %edi
  801534:	ff 75 e0             	pushl  -0x20(%ebp)
  801537:	51                   	push   %ecx
  801538:	52                   	push   %edx
  801539:	50                   	push   %eax
  80153a:	89 da                	mov    %ebx,%edx
  80153c:	89 f0                	mov    %esi,%eax
  80153e:	e8 83 fb ff ff       	call   8010c6 <printnum>
			break;
  801543:	83 c4 20             	add    $0x20,%esp
  801546:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801549:	e9 f3 fc ff ff       	jmp    801241 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	53                   	push   %ebx
  801552:	51                   	push   %ecx
  801553:	ff d6                	call   *%esi
			break;
  801555:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801558:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80155b:	e9 e1 fc ff ff       	jmp    801241 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	53                   	push   %ebx
  801564:	6a 25                	push   $0x25
  801566:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	eb 03                	jmp    801570 <vprintfmt+0x355>
  80156d:	83 ef 01             	sub    $0x1,%edi
  801570:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  801574:	75 f7                	jne    80156d <vprintfmt+0x352>
  801576:	e9 c6 fc ff ff       	jmp    801241 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80157b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157e:	5b                   	pop    %ebx
  80157f:	5e                   	pop    %esi
  801580:	5f                   	pop    %edi
  801581:	5d                   	pop    %ebp
  801582:	c3                   	ret    

00801583 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 18             	sub    $0x18,%esp
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80158f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801592:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801596:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	74 26                	je     8015ca <vsnprintf+0x47>
  8015a4:	85 d2                	test   %edx,%edx
  8015a6:	7e 22                	jle    8015ca <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015a8:	ff 75 14             	pushl  0x14(%ebp)
  8015ab:	ff 75 10             	pushl  0x10(%ebp)
  8015ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015b1:	50                   	push   %eax
  8015b2:	68 e1 11 80 00       	push   $0x8011e1
  8015b7:	e8 5f fc ff ff       	call   80121b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	eb 05                	jmp    8015cf <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015d7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015da:	50                   	push   %eax
  8015db:	ff 75 10             	pushl  0x10(%ebp)
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	ff 75 08             	pushl  0x8(%ebp)
  8015e4:	e8 9a ff ff ff       	call   801583 <vsnprintf>
	va_end(ap);

	return rc;
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f6:	eb 03                	jmp    8015fb <strlen+0x10>
		n++;
  8015f8:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8015ff:	75 f7                	jne    8015f8 <strlen+0xd>
		n++;
	return n;
}
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801609:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80160c:	ba 00 00 00 00       	mov    $0x0,%edx
  801611:	eb 03                	jmp    801616 <strnlen+0x13>
		n++;
  801613:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 08                	je     801622 <strnlen+0x1f>
  80161a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80161e:	75 f3                	jne    801613 <strnlen+0x10>
  801620:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  801622:	5d                   	pop    %ebp
  801623:	c3                   	ret    

00801624 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	53                   	push   %ebx
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80162e:	89 c2                	mov    %eax,%edx
  801630:	83 c2 01             	add    $0x1,%edx
  801633:	83 c1 01             	add    $0x1,%ecx
  801636:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80163a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80163d:	84 db                	test   %bl,%bl
  80163f:	75 ef                	jne    801630 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801641:	5b                   	pop    %ebx
  801642:	5d                   	pop    %ebp
  801643:	c3                   	ret    

00801644 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	53                   	push   %ebx
  801648:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80164b:	53                   	push   %ebx
  80164c:	e8 9a ff ff ff       	call   8015eb <strlen>
  801651:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801654:	ff 75 0c             	pushl  0xc(%ebp)
  801657:	01 d8                	add    %ebx,%eax
  801659:	50                   	push   %eax
  80165a:	e8 c5 ff ff ff       	call   801624 <strcpy>
	return dst;
}
  80165f:	89 d8                	mov    %ebx,%eax
  801661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	8b 75 08             	mov    0x8(%ebp),%esi
  80166e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801671:	89 f3                	mov    %esi,%ebx
  801673:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801676:	89 f2                	mov    %esi,%edx
  801678:	eb 0f                	jmp    801689 <strncpy+0x23>
		*dst++ = *src;
  80167a:	83 c2 01             	add    $0x1,%edx
  80167d:	0f b6 01             	movzbl (%ecx),%eax
  801680:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801683:	80 39 01             	cmpb   $0x1,(%ecx)
  801686:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801689:	39 da                	cmp    %ebx,%edx
  80168b:	75 ed                	jne    80167a <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80168d:	89 f0                	mov    %esi,%eax
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
  801698:	8b 75 08             	mov    0x8(%ebp),%esi
  80169b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80169e:	8b 55 10             	mov    0x10(%ebp),%edx
  8016a1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8016a3:	85 d2                	test   %edx,%edx
  8016a5:	74 21                	je     8016c8 <strlcpy+0x35>
  8016a7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8016ab:	89 f2                	mov    %esi,%edx
  8016ad:	eb 09                	jmp    8016b8 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016af:	83 c2 01             	add    $0x1,%edx
  8016b2:	83 c1 01             	add    $0x1,%ecx
  8016b5:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016b8:	39 c2                	cmp    %eax,%edx
  8016ba:	74 09                	je     8016c5 <strlcpy+0x32>
  8016bc:	0f b6 19             	movzbl (%ecx),%ebx
  8016bf:	84 db                	test   %bl,%bl
  8016c1:	75 ec                	jne    8016af <strlcpy+0x1c>
  8016c3:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016c5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016c8:	29 f0                	sub    %esi,%eax
}
  8016ca:	5b                   	pop    %ebx
  8016cb:	5e                   	pop    %esi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    

008016ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016d7:	eb 06                	jmp    8016df <strcmp+0x11>
		p++, q++;
  8016d9:	83 c1 01             	add    $0x1,%ecx
  8016dc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016df:	0f b6 01             	movzbl (%ecx),%eax
  8016e2:	84 c0                	test   %al,%al
  8016e4:	74 04                	je     8016ea <strcmp+0x1c>
  8016e6:	3a 02                	cmp    (%edx),%al
  8016e8:	74 ef                	je     8016d9 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016ea:	0f b6 c0             	movzbl %al,%eax
  8016ed:	0f b6 12             	movzbl (%edx),%edx
  8016f0:	29 d0                	sub    %edx,%eax
}
  8016f2:	5d                   	pop    %ebp
  8016f3:	c3                   	ret    

008016f4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	53                   	push   %ebx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fe:	89 c3                	mov    %eax,%ebx
  801700:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801703:	eb 06                	jmp    80170b <strncmp+0x17>
		n--, p++, q++;
  801705:	83 c0 01             	add    $0x1,%eax
  801708:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80170b:	39 d8                	cmp    %ebx,%eax
  80170d:	74 15                	je     801724 <strncmp+0x30>
  80170f:	0f b6 08             	movzbl (%eax),%ecx
  801712:	84 c9                	test   %cl,%cl
  801714:	74 04                	je     80171a <strncmp+0x26>
  801716:	3a 0a                	cmp    (%edx),%cl
  801718:	74 eb                	je     801705 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80171a:	0f b6 00             	movzbl (%eax),%eax
  80171d:	0f b6 12             	movzbl (%edx),%edx
  801720:	29 d0                	sub    %edx,%eax
  801722:	eb 05                	jmp    801729 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801729:	5b                   	pop    %ebx
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801736:	eb 07                	jmp    80173f <strchr+0x13>
		if (*s == c)
  801738:	38 ca                	cmp    %cl,%dl
  80173a:	74 0f                	je     80174b <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80173c:	83 c0 01             	add    $0x1,%eax
  80173f:	0f b6 10             	movzbl (%eax),%edx
  801742:	84 d2                	test   %dl,%dl
  801744:	75 f2                	jne    801738 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801757:	eb 03                	jmp    80175c <strfind+0xf>
  801759:	83 c0 01             	add    $0x1,%eax
  80175c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80175f:	38 ca                	cmp    %cl,%dl
  801761:	74 04                	je     801767 <strfind+0x1a>
  801763:	84 d2                	test   %dl,%dl
  801765:	75 f2                	jne    801759 <strfind+0xc>
			break;
	return (char *) s;
}
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    

00801769 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	57                   	push   %edi
  80176d:	56                   	push   %esi
  80176e:	53                   	push   %ebx
  80176f:	8b 55 08             	mov    0x8(%ebp),%edx
  801772:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801775:	85 c9                	test   %ecx,%ecx
  801777:	74 37                	je     8017b0 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801779:	f6 c2 03             	test   $0x3,%dl
  80177c:	75 2a                	jne    8017a8 <memset+0x3f>
  80177e:	f6 c1 03             	test   $0x3,%cl
  801781:	75 25                	jne    8017a8 <memset+0x3f>
		c &= 0xFF;
  801783:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801787:	89 df                	mov    %ebx,%edi
  801789:	c1 e7 08             	shl    $0x8,%edi
  80178c:	89 de                	mov    %ebx,%esi
  80178e:	c1 e6 18             	shl    $0x18,%esi
  801791:	89 d8                	mov    %ebx,%eax
  801793:	c1 e0 10             	shl    $0x10,%eax
  801796:	09 f0                	or     %esi,%eax
  801798:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80179a:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80179d:	89 f8                	mov    %edi,%eax
  80179f:	09 d8                	or     %ebx,%eax
  8017a1:	89 d7                	mov    %edx,%edi
  8017a3:	fc                   	cld    
  8017a4:	f3 ab                	rep stos %eax,%es:(%edi)
  8017a6:	eb 08                	jmp    8017b0 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017a8:	89 d7                	mov    %edx,%edi
  8017aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ad:	fc                   	cld    
  8017ae:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017b0:	89 d0                	mov    %edx,%eax
  8017b2:	5b                   	pop    %ebx
  8017b3:	5e                   	pop    %esi
  8017b4:	5f                   	pop    %edi
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	57                   	push   %edi
  8017bb:	56                   	push   %esi
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017c5:	39 c6                	cmp    %eax,%esi
  8017c7:	73 35                	jae    8017fe <memmove+0x47>
  8017c9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017cc:	39 d0                	cmp    %edx,%eax
  8017ce:	73 2e                	jae    8017fe <memmove+0x47>
		s += n;
		d += n;
  8017d0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017d3:	89 d6                	mov    %edx,%esi
  8017d5:	09 fe                	or     %edi,%esi
  8017d7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017dd:	75 13                	jne    8017f2 <memmove+0x3b>
  8017df:	f6 c1 03             	test   $0x3,%cl
  8017e2:	75 0e                	jne    8017f2 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017e4:	83 ef 04             	sub    $0x4,%edi
  8017e7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8017ea:	c1 e9 02             	shr    $0x2,%ecx
  8017ed:	fd                   	std    
  8017ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8017f0:	eb 09                	jmp    8017fb <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017f2:	83 ef 01             	sub    $0x1,%edi
  8017f5:	8d 72 ff             	lea    -0x1(%edx),%esi
  8017f8:	fd                   	std    
  8017f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017fb:	fc                   	cld    
  8017fc:	eb 1d                	jmp    80181b <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017fe:	89 f2                	mov    %esi,%edx
  801800:	09 c2                	or     %eax,%edx
  801802:	f6 c2 03             	test   $0x3,%dl
  801805:	75 0f                	jne    801816 <memmove+0x5f>
  801807:	f6 c1 03             	test   $0x3,%cl
  80180a:	75 0a                	jne    801816 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80180c:	c1 e9 02             	shr    $0x2,%ecx
  80180f:	89 c7                	mov    %eax,%edi
  801811:	fc                   	cld    
  801812:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801814:	eb 05                	jmp    80181b <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801816:	89 c7                	mov    %eax,%edi
  801818:	fc                   	cld    
  801819:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80181b:	5e                   	pop    %esi
  80181c:	5f                   	pop    %edi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    

0080181f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801822:	ff 75 10             	pushl  0x10(%ebp)
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	ff 75 08             	pushl  0x8(%ebp)
  80182b:	e8 87 ff ff ff       	call   8017b7 <memmove>
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	56                   	push   %esi
  801836:	53                   	push   %ebx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183d:	89 c6                	mov    %eax,%esi
  80183f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801842:	eb 1a                	jmp    80185e <memcmp+0x2c>
		if (*s1 != *s2)
  801844:	0f b6 08             	movzbl (%eax),%ecx
  801847:	0f b6 1a             	movzbl (%edx),%ebx
  80184a:	38 d9                	cmp    %bl,%cl
  80184c:	74 0a                	je     801858 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  80184e:	0f b6 c1             	movzbl %cl,%eax
  801851:	0f b6 db             	movzbl %bl,%ebx
  801854:	29 d8                	sub    %ebx,%eax
  801856:	eb 0f                	jmp    801867 <memcmp+0x35>
		s1++, s2++;
  801858:	83 c0 01             	add    $0x1,%eax
  80185b:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80185e:	39 f0                	cmp    %esi,%eax
  801860:	75 e2                	jne    801844 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801862:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5d                   	pop    %ebp
  80186a:	c3                   	ret    

0080186b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	53                   	push   %ebx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801872:	89 c1                	mov    %eax,%ecx
  801874:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  801877:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80187b:	eb 0a                	jmp    801887 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  80187d:	0f b6 10             	movzbl (%eax),%edx
  801880:	39 da                	cmp    %ebx,%edx
  801882:	74 07                	je     80188b <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801884:	83 c0 01             	add    $0x1,%eax
  801887:	39 c8                	cmp    %ecx,%eax
  801889:	72 f2                	jb     80187d <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80188b:	5b                   	pop    %ebx
  80188c:	5d                   	pop    %ebp
  80188d:	c3                   	ret    

0080188e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	57                   	push   %edi
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801897:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80189a:	eb 03                	jmp    80189f <strtol+0x11>
		s++;
  80189c:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80189f:	0f b6 01             	movzbl (%ecx),%eax
  8018a2:	3c 20                	cmp    $0x20,%al
  8018a4:	74 f6                	je     80189c <strtol+0xe>
  8018a6:	3c 09                	cmp    $0x9,%al
  8018a8:	74 f2                	je     80189c <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018aa:	3c 2b                	cmp    $0x2b,%al
  8018ac:	75 0a                	jne    8018b8 <strtol+0x2a>
		s++;
  8018ae:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b6:	eb 11                	jmp    8018c9 <strtol+0x3b>
  8018b8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018bd:	3c 2d                	cmp    $0x2d,%al
  8018bf:	75 08                	jne    8018c9 <strtol+0x3b>
		s++, neg = 1;
  8018c1:	83 c1 01             	add    $0x1,%ecx
  8018c4:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018c9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018cf:	75 15                	jne    8018e6 <strtol+0x58>
  8018d1:	80 39 30             	cmpb   $0x30,(%ecx)
  8018d4:	75 10                	jne    8018e6 <strtol+0x58>
  8018d6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018da:	75 7c                	jne    801958 <strtol+0xca>
		s += 2, base = 16;
  8018dc:	83 c1 02             	add    $0x2,%ecx
  8018df:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018e4:	eb 16                	jmp    8018fc <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8018e6:	85 db                	test   %ebx,%ebx
  8018e8:	75 12                	jne    8018fc <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8018ea:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8018ef:	80 39 30             	cmpb   $0x30,(%ecx)
  8018f2:	75 08                	jne    8018fc <strtol+0x6e>
		s++, base = 8;
  8018f4:	83 c1 01             	add    $0x1,%ecx
  8018f7:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801901:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801904:	0f b6 11             	movzbl (%ecx),%edx
  801907:	8d 72 d0             	lea    -0x30(%edx),%esi
  80190a:	89 f3                	mov    %esi,%ebx
  80190c:	80 fb 09             	cmp    $0x9,%bl
  80190f:	77 08                	ja     801919 <strtol+0x8b>
			dig = *s - '0';
  801911:	0f be d2             	movsbl %dl,%edx
  801914:	83 ea 30             	sub    $0x30,%edx
  801917:	eb 22                	jmp    80193b <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  801919:	8d 72 9f             	lea    -0x61(%edx),%esi
  80191c:	89 f3                	mov    %esi,%ebx
  80191e:	80 fb 19             	cmp    $0x19,%bl
  801921:	77 08                	ja     80192b <strtol+0x9d>
			dig = *s - 'a' + 10;
  801923:	0f be d2             	movsbl %dl,%edx
  801926:	83 ea 57             	sub    $0x57,%edx
  801929:	eb 10                	jmp    80193b <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  80192b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80192e:	89 f3                	mov    %esi,%ebx
  801930:	80 fb 19             	cmp    $0x19,%bl
  801933:	77 16                	ja     80194b <strtol+0xbd>
			dig = *s - 'A' + 10;
  801935:	0f be d2             	movsbl %dl,%edx
  801938:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  80193b:	3b 55 10             	cmp    0x10(%ebp),%edx
  80193e:	7d 0b                	jge    80194b <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  801940:	83 c1 01             	add    $0x1,%ecx
  801943:	0f af 45 10          	imul   0x10(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  801949:	eb b9                	jmp    801904 <strtol+0x76>

	if (endptr)
  80194b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80194f:	74 0d                	je     80195e <strtol+0xd0>
		*endptr = (char *) s;
  801951:	8b 75 0c             	mov    0xc(%ebp),%esi
  801954:	89 0e                	mov    %ecx,(%esi)
  801956:	eb 06                	jmp    80195e <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801958:	85 db                	test   %ebx,%ebx
  80195a:	74 98                	je     8018f4 <strtol+0x66>
  80195c:	eb 9e                	jmp    8018fc <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  80195e:	89 c2                	mov    %eax,%edx
  801960:	f7 da                	neg    %edx
  801962:	85 ff                	test   %edi,%edi
  801964:	0f 45 c2             	cmovne %edx,%eax
}
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	56                   	push   %esi
  801970:	53                   	push   %ebx
  801971:	8b 75 08             	mov    0x8(%ebp),%esi
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80197a:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80197c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801981:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801984:	83 ec 0c             	sub    $0xc,%esp
  801987:	50                   	push   %eax
  801988:	e8 1d e9 ff ff       	call   8002aa <sys_ipc_recv>
	if (from_env_store)
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	85 f6                	test   %esi,%esi
  801992:	74 0b                	je     80199f <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801994:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80199a:	8b 52 74             	mov    0x74(%edx),%edx
  80199d:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80199f:	85 db                	test   %ebx,%ebx
  8019a1:	74 0b                	je     8019ae <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019a3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019a9:	8b 52 78             	mov    0x78(%edx),%edx
  8019ac:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	79 16                	jns    8019c8 <ipc_recv+0x5c>
		if (from_env_store)
  8019b2:	85 f6                	test   %esi,%esi
  8019b4:	74 06                	je     8019bc <ipc_recv+0x50>
			*from_env_store = 0;
  8019b6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019bc:	85 db                	test   %ebx,%ebx
  8019be:	74 10                	je     8019d0 <ipc_recv+0x64>
			*perm_store = 0;
  8019c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019c6:	eb 08                	jmp    8019d0 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019c8:	a1 04 40 80 00       	mov    0x804004,%eax
  8019cd:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    

008019d7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	57                   	push   %edi
  8019db:	56                   	push   %esi
  8019dc:	53                   	push   %ebx
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019e9:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019eb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019f0:	0f 44 d8             	cmove  %eax,%ebx
  8019f3:	eb 1c                	jmp    801a11 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019f5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019f8:	74 12                	je     801a0c <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019fa:	50                   	push   %eax
  8019fb:	68 80 21 80 00       	push   $0x802180
  801a00:	6a 42                	push   $0x42
  801a02:	68 96 21 80 00       	push   $0x802196
  801a07:	e8 cd f5 ff ff       	call   800fd9 <_panic>
		sys_yield();
  801a0c:	e8 77 e7 ff ff       	call   800188 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a11:	ff 75 14             	pushl  0x14(%ebp)
  801a14:	53                   	push   %ebx
  801a15:	56                   	push   %esi
  801a16:	57                   	push   %edi
  801a17:	e8 69 e8 ff ff       	call   800285 <sys_ipc_try_send>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	75 d2                	jne    8019f5 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a26:	5b                   	pop    %ebx
  801a27:	5e                   	pop    %esi
  801a28:	5f                   	pop    %edi
  801a29:	5d                   	pop    %ebp
  801a2a:	c3                   	ret    

00801a2b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a36:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a39:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a3f:	8b 52 50             	mov    0x50(%edx),%edx
  801a42:	39 ca                	cmp    %ecx,%edx
  801a44:	75 0d                	jne    801a53 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a46:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a49:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a4e:	8b 40 48             	mov    0x48(%eax),%eax
  801a51:	eb 0f                	jmp    801a62 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a53:	83 c0 01             	add    $0x1,%eax
  801a56:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a5b:	75 d9                	jne    801a36 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    

00801a64 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a6a:	89 d0                	mov    %edx,%eax
  801a6c:	c1 e8 16             	shr    $0x16,%eax
  801a6f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a7b:	f6 c1 01             	test   $0x1,%cl
  801a7e:	74 1d                	je     801a9d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a80:	c1 ea 0c             	shr    $0xc,%edx
  801a83:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a8a:	f6 c2 01             	test   $0x1,%dl
  801a8d:	74 0e                	je     801a9d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a8f:	c1 ea 0c             	shr    $0xc,%edx
  801a92:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a99:	ef 
  801a9a:	0f b7 c0             	movzwl %ax,%eax
}
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    
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
