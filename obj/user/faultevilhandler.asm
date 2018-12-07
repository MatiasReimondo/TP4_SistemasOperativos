
obj/user/faultevilhandler.debug:     formato del fichero elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 83 01 00 00       	call   8001ca <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 27 02 00 00       	call   80027d <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800070:	e8 0a 01 00 00       	call   80017f <sys_getenvid>
	if (id >= 0)
  800075:	85 c0                	test   %eax,%eax
  800077:	78 12                	js     80008b <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800079:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800081:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800086:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008b:	85 db                	test   %ebx,%ebx
  80008d:	7e 07                	jle    800096 <libmain+0x31>
		binaryname = argv[0];
  80008f:	8b 06                	mov    (%esi),%eax
  800091:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	56                   	push   %esi
  80009a:	53                   	push   %ebx
  80009b:	e8 93 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a0:	e8 0a 00 00 00       	call   8000af <exit>
}
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ab:	5b                   	pop    %ebx
  8000ac:	5e                   	pop    %esi
  8000ad:	5d                   	pop    %ebp
  8000ae:	c3                   	ret    

008000af <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b5:	e8 f8 03 00 00       	call   8004b2 <close_all>
	sys_env_destroy(0);
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	6a 00                	push   $0x0
  8000bf:	e8 99 00 00 00       	call   80015d <sys_env_destroy>
}
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	c9                   	leave  
  8000c8:	c3                   	ret    

008000c9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000c9:	55                   	push   %ebp
  8000ca:	89 e5                	mov    %esp,%ebp
  8000cc:	57                   	push   %edi
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	83 ec 1c             	sub    $0x1c,%esp
  8000d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000d8:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000e0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000e3:	8b 75 14             	mov    0x14(%ebp),%esi
  8000e6:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000ec:	74 1d                	je     80010b <syscall+0x42>
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	7e 19                	jle    80010b <syscall+0x42>
  8000f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	50                   	push   %eax
  8000f9:	52                   	push   %edx
  8000fa:	68 6a 1d 80 00       	push   $0x801d6a
  8000ff:	6a 23                	push   $0x23
  800101:	68 87 1d 80 00       	push   $0x801d87
  800106:	e8 e9 0e 00 00       	call   800ff4 <_panic>

	return ret;
}
  80010b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800119:	6a 00                	push   $0x0
  80011b:	6a 00                	push   $0x0
  80011d:	6a 00                	push   $0x0
  80011f:	ff 75 0c             	pushl  0xc(%ebp)
  800122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800125:	ba 00 00 00 00       	mov    $0x0,%edx
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	e8 95 ff ff ff       	call   8000c9 <syscall>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	c9                   	leave  
  800138:	c3                   	ret    

00800139 <sys_cgetc>:

int
sys_cgetc(void)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80013f:	6a 00                	push   $0x0
  800141:	6a 00                	push   $0x0
  800143:	6a 00                	push   $0x0
  800145:	6a 00                	push   $0x0
  800147:	b9 00 00 00 00       	mov    $0x0,%ecx
  80014c:	ba 00 00 00 00       	mov    $0x0,%edx
  800151:	b8 01 00 00 00       	mov    $0x1,%eax
  800156:	e8 6e ff ff ff       	call   8000c9 <syscall>
}
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    

0080015d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800163:	6a 00                	push   $0x0
  800165:	6a 00                	push   $0x0
  800167:	6a 00                	push   $0x0
  800169:	6a 00                	push   $0x0
  80016b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016e:	ba 01 00 00 00       	mov    $0x1,%edx
  800173:	b8 03 00 00 00       	mov    $0x3,%eax
  800178:	e8 4c ff ff ff       	call   8000c9 <syscall>
}
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800185:	6a 00                	push   $0x0
  800187:	6a 00                	push   $0x0
  800189:	6a 00                	push   $0x0
  80018b:	6a 00                	push   $0x0
  80018d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800192:	ba 00 00 00 00       	mov    $0x0,%edx
  800197:	b8 02 00 00 00       	mov    $0x2,%eax
  80019c:	e8 28 ff ff ff       	call   8000c9 <syscall>
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <sys_yield>:

void
sys_yield(void)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8001a9:	6a 00                	push   $0x0
  8001ab:	6a 00                	push   $0x0
  8001ad:	6a 00                	push   $0x0
  8001af:	6a 00                	push   $0x0
  8001b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001c0:	e8 04 ff ff ff       	call   8000c9 <syscall>
}
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001d0:	6a 00                	push   $0x0
  8001d2:	6a 00                	push   $0x0
  8001d4:	ff 75 10             	pushl  0x10(%ebp)
  8001d7:	ff 75 0c             	pushl  0xc(%ebp)
  8001da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001dd:	ba 01 00 00 00       	mov    $0x1,%edx
  8001e2:	b8 04 00 00 00       	mov    $0x4,%eax
  8001e7:	e8 dd fe ff ff       	call   8000c9 <syscall>
}
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001f4:	ff 75 18             	pushl  0x18(%ebp)
  8001f7:	ff 75 14             	pushl  0x14(%ebp)
  8001fa:	ff 75 10             	pushl  0x10(%ebp)
  8001fd:	ff 75 0c             	pushl  0xc(%ebp)
  800200:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800203:	ba 01 00 00 00       	mov    $0x1,%edx
  800208:	b8 05 00 00 00       	mov    $0x5,%eax
  80020d:	e8 b7 fe ff ff       	call   8000c9 <syscall>
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  80021a:	6a 00                	push   $0x0
  80021c:	6a 00                	push   $0x0
  80021e:	6a 00                	push   $0x0
  800220:	ff 75 0c             	pushl  0xc(%ebp)
  800223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800226:	ba 01 00 00 00       	mov    $0x1,%edx
  80022b:	b8 06 00 00 00       	mov    $0x6,%eax
  800230:	e8 94 fe ff ff       	call   8000c9 <syscall>
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80023d:	6a 00                	push   $0x0
  80023f:	6a 00                	push   $0x0
  800241:	6a 00                	push   $0x0
  800243:	ff 75 0c             	pushl  0xc(%ebp)
  800246:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800249:	ba 01 00 00 00       	mov    $0x1,%edx
  80024e:	b8 08 00 00 00       	mov    $0x8,%eax
  800253:	e8 71 fe ff ff       	call   8000c9 <syscall>
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800260:	6a 00                	push   $0x0
  800262:	6a 00                	push   $0x0
  800264:	6a 00                	push   $0x0
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80026c:	ba 01 00 00 00       	mov    $0x1,%edx
  800271:	b8 09 00 00 00       	mov    $0x9,%eax
  800276:	e8 4e fe ff ff       	call   8000c9 <syscall>
}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800283:	6a 00                	push   $0x0
  800285:	6a 00                	push   $0x0
  800287:	6a 00                	push   $0x0
  800289:	ff 75 0c             	pushl  0xc(%ebp)
  80028c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028f:	ba 01 00 00 00       	mov    $0x1,%edx
  800294:	b8 0a 00 00 00       	mov    $0xa,%eax
  800299:	e8 2b fe ff ff       	call   8000c9 <syscall>
}
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8002a6:	6a 00                	push   $0x0
  8002a8:	ff 75 14             	pushl  0x14(%ebp)
  8002ab:	ff 75 10             	pushl  0x10(%ebp)
  8002ae:	ff 75 0c             	pushl  0xc(%ebp)
  8002b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002be:	e8 06 fe ff ff       	call   8000c9 <syscall>
}
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002cb:	6a 00                	push   $0x0
  8002cd:	6a 00                	push   $0x0
  8002cf:	6a 00                	push   $0x0
  8002d1:	6a 00                	push   $0x0
  8002d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002d6:	ba 01 00 00 00       	mov    $0x1,%edx
  8002db:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002e0:	e8 e4 fd ff ff       	call   8000c9 <syscall>
}
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ed:	05 00 00 00 30       	add    $0x30000000,%eax
  8002f2:	c1 e8 0c             	shr    $0xc,%eax
}
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	e8 e5 ff ff ff       	call   8002e7 <fd2num>
  800302:	83 c4 04             	add    $0x4,%esp
  800305:	c1 e0 0c             	shl    $0xc,%eax
  800308:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800315:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80031a:	89 c2                	mov    %eax,%edx
  80031c:	c1 ea 16             	shr    $0x16,%edx
  80031f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800326:	f6 c2 01             	test   $0x1,%dl
  800329:	74 11                	je     80033c <fd_alloc+0x2d>
  80032b:	89 c2                	mov    %eax,%edx
  80032d:	c1 ea 0c             	shr    $0xc,%edx
  800330:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800337:	f6 c2 01             	test   $0x1,%dl
  80033a:	75 09                	jne    800345 <fd_alloc+0x36>
			*fd_store = fd;
  80033c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80033e:	b8 00 00 00 00       	mov    $0x0,%eax
  800343:	eb 17                	jmp    80035c <fd_alloc+0x4d>
  800345:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80034a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80034f:	75 c9                	jne    80031a <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800351:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800357:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80035c:	5d                   	pop    %ebp
  80035d:	c3                   	ret    

0080035e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800364:	83 f8 1f             	cmp    $0x1f,%eax
  800367:	77 36                	ja     80039f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800369:	c1 e0 0c             	shl    $0xc,%eax
  80036c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800371:	89 c2                	mov    %eax,%edx
  800373:	c1 ea 16             	shr    $0x16,%edx
  800376:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80037d:	f6 c2 01             	test   $0x1,%dl
  800380:	74 24                	je     8003a6 <fd_lookup+0x48>
  800382:	89 c2                	mov    %eax,%edx
  800384:	c1 ea 0c             	shr    $0xc,%edx
  800387:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80038e:	f6 c2 01             	test   $0x1,%dl
  800391:	74 1a                	je     8003ad <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800393:	8b 55 0c             	mov    0xc(%ebp),%edx
  800396:	89 02                	mov    %eax,(%edx)
	return 0;
  800398:	b8 00 00 00 00       	mov    $0x0,%eax
  80039d:	eb 13                	jmp    8003b2 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80039f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003a4:	eb 0c                	jmp    8003b2 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8003a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003ab:	eb 05                	jmp    8003b2 <fd_lookup+0x54>
  8003ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8003b2:	5d                   	pop    %ebp
  8003b3:	c3                   	ret    

008003b4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	83 ec 08             	sub    $0x8,%esp
  8003ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003bd:	ba 14 1e 80 00       	mov    $0x801e14,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003c2:	eb 13                	jmp    8003d7 <dev_lookup+0x23>
  8003c4:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8003c7:	39 08                	cmp    %ecx,(%eax)
  8003c9:	75 0c                	jne    8003d7 <dev_lookup+0x23>
			*dev = devtab[i];
  8003cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ce:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d5:	eb 2e                	jmp    800405 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003d7:	8b 02                	mov    (%edx),%eax
  8003d9:	85 c0                	test   %eax,%eax
  8003db:	75 e7                	jne    8003c4 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8003e2:	8b 40 48             	mov    0x48(%eax),%eax
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	51                   	push   %ecx
  8003e9:	50                   	push   %eax
  8003ea:	68 98 1d 80 00       	push   $0x801d98
  8003ef:	e8 d9 0c 00 00       	call   8010cd <cprintf>
	*dev = 0;
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	56                   	push   %esi
  80040b:	53                   	push   %ebx
  80040c:	83 ec 10             	sub    $0x10,%esp
  80040f:	8b 75 08             	mov    0x8(%ebp),%esi
  800412:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800415:	56                   	push   %esi
  800416:	e8 cc fe ff ff       	call   8002e7 <fd2num>
  80041b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80041e:	89 14 24             	mov    %edx,(%esp)
  800421:	50                   	push   %eax
  800422:	e8 37 ff ff ff       	call   80035e <fd_lookup>
  800427:	83 c4 08             	add    $0x8,%esp
  80042a:	85 c0                	test   %eax,%eax
  80042c:	78 05                	js     800433 <fd_close+0x2c>
	    || fd != fd2)
  80042e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800431:	74 0c                	je     80043f <fd_close+0x38>
		return (must_exist ? r : 0);
  800433:	84 db                	test   %bl,%bl
  800435:	ba 00 00 00 00       	mov    $0x0,%edx
  80043a:	0f 44 c2             	cmove  %edx,%eax
  80043d:	eb 41                	jmp    800480 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800445:	50                   	push   %eax
  800446:	ff 36                	pushl  (%esi)
  800448:	e8 67 ff ff ff       	call   8003b4 <dev_lookup>
  80044d:	89 c3                	mov    %eax,%ebx
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	85 c0                	test   %eax,%eax
  800454:	78 1a                	js     800470 <fd_close+0x69>
		if (dev->dev_close)
  800456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800459:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80045c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800461:	85 c0                	test   %eax,%eax
  800463:	74 0b                	je     800470 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800465:	83 ec 0c             	sub    $0xc,%esp
  800468:	56                   	push   %esi
  800469:	ff d0                	call   *%eax
  80046b:	89 c3                	mov    %eax,%ebx
  80046d:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	56                   	push   %esi
  800474:	6a 00                	push   $0x0
  800476:	e8 99 fd ff ff       	call   800214 <sys_page_unmap>
	return r;
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 d8                	mov    %ebx,%eax
}
  800480:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800483:	5b                   	pop    %ebx
  800484:	5e                   	pop    %esi
  800485:	5d                   	pop    %ebp
  800486:	c3                   	ret    

00800487 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80048d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800490:	50                   	push   %eax
  800491:	ff 75 08             	pushl  0x8(%ebp)
  800494:	e8 c5 fe ff ff       	call   80035e <fd_lookup>
  800499:	83 c4 08             	add    $0x8,%esp
  80049c:	85 c0                	test   %eax,%eax
  80049e:	78 10                	js     8004b0 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	6a 01                	push   $0x1
  8004a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a8:	e8 5a ff ff ff       	call   800407 <fd_close>
  8004ad:	83 c4 10             	add    $0x10,%esp
}
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <close_all>:

void
close_all(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	53                   	push   %ebx
  8004b6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8004b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004be:	83 ec 0c             	sub    $0xc,%esp
  8004c1:	53                   	push   %ebx
  8004c2:	e8 c0 ff ff ff       	call   800487 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8004c7:	83 c3 01             	add    $0x1,%ebx
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	83 fb 20             	cmp    $0x20,%ebx
  8004d0:	75 ec                	jne    8004be <close_all+0xc>
		close(i);
}
  8004d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d5:	c9                   	leave  
  8004d6:	c3                   	ret    

008004d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	57                   	push   %edi
  8004db:	56                   	push   %esi
  8004dc:	53                   	push   %ebx
  8004dd:	83 ec 2c             	sub    $0x2c,%esp
  8004e0:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004e3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 6f fe ff ff       	call   80035e <fd_lookup>
  8004ef:	83 c4 08             	add    $0x8,%esp
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	0f 88 c1 00 00 00    	js     8005bb <dup+0xe4>
		return r;
	close(newfdnum);
  8004fa:	83 ec 0c             	sub    $0xc,%esp
  8004fd:	56                   	push   %esi
  8004fe:	e8 84 ff ff ff       	call   800487 <close>

	newfd = INDEX2FD(newfdnum);
  800503:	89 f3                	mov    %esi,%ebx
  800505:	c1 e3 0c             	shl    $0xc,%ebx
  800508:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  80050e:	83 c4 04             	add    $0x4,%esp
  800511:	ff 75 e4             	pushl  -0x1c(%ebp)
  800514:	e8 de fd ff ff       	call   8002f7 <fd2data>
  800519:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  80051b:	89 1c 24             	mov    %ebx,(%esp)
  80051e:	e8 d4 fd ff ff       	call   8002f7 <fd2data>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800529:	89 f8                	mov    %edi,%eax
  80052b:	c1 e8 16             	shr    $0x16,%eax
  80052e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800535:	a8 01                	test   $0x1,%al
  800537:	74 37                	je     800570 <dup+0x99>
  800539:	89 f8                	mov    %edi,%eax
  80053b:	c1 e8 0c             	shr    $0xc,%eax
  80053e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800545:	f6 c2 01             	test   $0x1,%dl
  800548:	74 26                	je     800570 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80054a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	25 07 0e 00 00       	and    $0xe07,%eax
  800559:	50                   	push   %eax
  80055a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80055d:	6a 00                	push   $0x0
  80055f:	57                   	push   %edi
  800560:	6a 00                	push   $0x0
  800562:	e8 87 fc ff ff       	call   8001ee <sys_page_map>
  800567:	89 c7                	mov    %eax,%edi
  800569:	83 c4 20             	add    $0x20,%esp
  80056c:	85 c0                	test   %eax,%eax
  80056e:	78 2e                	js     80059e <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800573:	89 d0                	mov    %edx,%eax
  800575:	c1 e8 0c             	shr    $0xc,%eax
  800578:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80057f:	83 ec 0c             	sub    $0xc,%esp
  800582:	25 07 0e 00 00       	and    $0xe07,%eax
  800587:	50                   	push   %eax
  800588:	53                   	push   %ebx
  800589:	6a 00                	push   $0x0
  80058b:	52                   	push   %edx
  80058c:	6a 00                	push   $0x0
  80058e:	e8 5b fc ff ff       	call   8001ee <sys_page_map>
  800593:	89 c7                	mov    %eax,%edi
  800595:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800598:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80059a:	85 ff                	test   %edi,%edi
  80059c:	79 1d                	jns    8005bb <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	53                   	push   %ebx
  8005a2:	6a 00                	push   $0x0
  8005a4:	e8 6b fc ff ff       	call   800214 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8005a9:	83 c4 08             	add    $0x8,%esp
  8005ac:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005af:	6a 00                	push   $0x0
  8005b1:	e8 5e fc ff ff       	call   800214 <sys_page_unmap>
	return r;
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 f8                	mov    %edi,%eax
}
  8005bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005be:	5b                   	pop    %ebx
  8005bf:	5e                   	pop    %esi
  8005c0:	5f                   	pop    %edi
  8005c1:	5d                   	pop    %ebp
  8005c2:	c3                   	ret    

008005c3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005d0:	50                   	push   %eax
  8005d1:	53                   	push   %ebx
  8005d2:	e8 87 fd ff ff       	call   80035e <fd_lookup>
  8005d7:	83 c4 08             	add    $0x8,%esp
  8005da:	89 c2                	mov    %eax,%edx
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	78 6d                	js     80064d <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005e6:	50                   	push   %eax
  8005e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ea:	ff 30                	pushl  (%eax)
  8005ec:	e8 c3 fd ff ff       	call   8003b4 <dev_lookup>
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	85 c0                	test   %eax,%eax
  8005f6:	78 4c                	js     800644 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005fb:	8b 42 08             	mov    0x8(%edx),%eax
  8005fe:	83 e0 03             	and    $0x3,%eax
  800601:	83 f8 01             	cmp    $0x1,%eax
  800604:	75 21                	jne    800627 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800606:	a1 04 40 80 00       	mov    0x804004,%eax
  80060b:	8b 40 48             	mov    0x48(%eax),%eax
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	53                   	push   %ebx
  800612:	50                   	push   %eax
  800613:	68 d9 1d 80 00       	push   $0x801dd9
  800618:	e8 b0 0a 00 00       	call   8010cd <cprintf>
		return -E_INVAL;
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800625:	eb 26                	jmp    80064d <read+0x8a>
	}
	if (!dev->dev_read)
  800627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062a:	8b 40 08             	mov    0x8(%eax),%eax
  80062d:	85 c0                	test   %eax,%eax
  80062f:	74 17                	je     800648 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800631:	83 ec 04             	sub    $0x4,%esp
  800634:	ff 75 10             	pushl  0x10(%ebp)
  800637:	ff 75 0c             	pushl  0xc(%ebp)
  80063a:	52                   	push   %edx
  80063b:	ff d0                	call   *%eax
  80063d:	89 c2                	mov    %eax,%edx
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	eb 09                	jmp    80064d <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800644:	89 c2                	mov    %eax,%edx
  800646:	eb 05                	jmp    80064d <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800648:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80064d:	89 d0                	mov    %edx,%eax
  80064f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	57                   	push   %edi
  800658:	56                   	push   %esi
  800659:	53                   	push   %ebx
  80065a:	83 ec 0c             	sub    $0xc,%esp
  80065d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800660:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	eb 21                	jmp    80068b <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80066a:	83 ec 04             	sub    $0x4,%esp
  80066d:	89 f0                	mov    %esi,%eax
  80066f:	29 d8                	sub    %ebx,%eax
  800671:	50                   	push   %eax
  800672:	89 d8                	mov    %ebx,%eax
  800674:	03 45 0c             	add    0xc(%ebp),%eax
  800677:	50                   	push   %eax
  800678:	57                   	push   %edi
  800679:	e8 45 ff ff ff       	call   8005c3 <read>
		if (m < 0)
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	85 c0                	test   %eax,%eax
  800683:	78 10                	js     800695 <readn+0x41>
			return m;
		if (m == 0)
  800685:	85 c0                	test   %eax,%eax
  800687:	74 0a                	je     800693 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800689:	01 c3                	add    %eax,%ebx
  80068b:	39 f3                	cmp    %esi,%ebx
  80068d:	72 db                	jb     80066a <readn+0x16>
  80068f:	89 d8                	mov    %ebx,%eax
  800691:	eb 02                	jmp    800695 <readn+0x41>
  800693:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800695:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800698:	5b                   	pop    %ebx
  800699:	5e                   	pop    %esi
  80069a:	5f                   	pop    %edi
  80069b:	5d                   	pop    %ebp
  80069c:	c3                   	ret    

0080069d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	53                   	push   %ebx
  8006a1:	83 ec 14             	sub    $0x14,%esp
  8006a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006aa:	50                   	push   %eax
  8006ab:	53                   	push   %ebx
  8006ac:	e8 ad fc ff ff       	call   80035e <fd_lookup>
  8006b1:	83 c4 08             	add    $0x8,%esp
  8006b4:	89 c2                	mov    %eax,%edx
  8006b6:	85 c0                	test   %eax,%eax
  8006b8:	78 68                	js     800722 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006c0:	50                   	push   %eax
  8006c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c4:	ff 30                	pushl  (%eax)
  8006c6:	e8 e9 fc ff ff       	call   8003b4 <dev_lookup>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	78 47                	js     800719 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006d9:	75 21                	jne    8006fc <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006db:	a1 04 40 80 00       	mov    0x804004,%eax
  8006e0:	8b 40 48             	mov    0x48(%eax),%eax
  8006e3:	83 ec 04             	sub    $0x4,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	50                   	push   %eax
  8006e8:	68 f5 1d 80 00       	push   $0x801df5
  8006ed:	e8 db 09 00 00       	call   8010cd <cprintf>
		return -E_INVAL;
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006fa:	eb 26                	jmp    800722 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ff:	8b 52 0c             	mov    0xc(%edx),%edx
  800702:	85 d2                	test   %edx,%edx
  800704:	74 17                	je     80071d <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800706:	83 ec 04             	sub    $0x4,%esp
  800709:	ff 75 10             	pushl  0x10(%ebp)
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	50                   	push   %eax
  800710:	ff d2                	call   *%edx
  800712:	89 c2                	mov    %eax,%edx
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	eb 09                	jmp    800722 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800719:	89 c2                	mov    %eax,%edx
  80071b:	eb 05                	jmp    800722 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80071d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  800722:	89 d0                	mov    %edx,%eax
  800724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <seek>:

int
seek(int fdnum, off_t offset)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80072f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800732:	50                   	push   %eax
  800733:	ff 75 08             	pushl  0x8(%ebp)
  800736:	e8 23 fc ff ff       	call   80035e <fd_lookup>
  80073b:	83 c4 08             	add    $0x8,%esp
  80073e:	85 c0                	test   %eax,%eax
  800740:	78 0e                	js     800750 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800742:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800745:	8b 55 0c             	mov    0xc(%ebp),%edx
  800748:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80074b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800750:	c9                   	leave  
  800751:	c3                   	ret    

00800752 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	53                   	push   %ebx
  800756:	83 ec 14             	sub    $0x14,%esp
  800759:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80075c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80075f:	50                   	push   %eax
  800760:	53                   	push   %ebx
  800761:	e8 f8 fb ff ff       	call   80035e <fd_lookup>
  800766:	83 c4 08             	add    $0x8,%esp
  800769:	89 c2                	mov    %eax,%edx
  80076b:	85 c0                	test   %eax,%eax
  80076d:	78 65                	js     8007d4 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800775:	50                   	push   %eax
  800776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800779:	ff 30                	pushl  (%eax)
  80077b:	e8 34 fc ff ff       	call   8003b4 <dev_lookup>
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	85 c0                	test   %eax,%eax
  800785:	78 44                	js     8007cb <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80078e:	75 21                	jne    8007b1 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800790:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800795:	8b 40 48             	mov    0x48(%eax),%eax
  800798:	83 ec 04             	sub    $0x4,%esp
  80079b:	53                   	push   %ebx
  80079c:	50                   	push   %eax
  80079d:	68 b8 1d 80 00       	push   $0x801db8
  8007a2:	e8 26 09 00 00       	call   8010cd <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8007a7:	83 c4 10             	add    $0x10,%esp
  8007aa:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8007af:	eb 23                	jmp    8007d4 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8007b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b4:	8b 52 18             	mov    0x18(%edx),%edx
  8007b7:	85 d2                	test   %edx,%edx
  8007b9:	74 14                	je     8007cf <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	ff d2                	call   *%edx
  8007c4:	89 c2                	mov    %eax,%edx
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	eb 09                	jmp    8007d4 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007cb:	89 c2                	mov    %eax,%edx
  8007cd:	eb 05                	jmp    8007d4 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007cf:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d9:	c9                   	leave  
  8007da:	c3                   	ret    

008007db <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	53                   	push   %ebx
  8007df:	83 ec 14             	sub    $0x14,%esp
  8007e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e8:	50                   	push   %eax
  8007e9:	ff 75 08             	pushl  0x8(%ebp)
  8007ec:	e8 6d fb ff ff       	call   80035e <fd_lookup>
  8007f1:	83 c4 08             	add    $0x8,%esp
  8007f4:	89 c2                	mov    %eax,%edx
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	78 58                	js     800852 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800800:	50                   	push   %eax
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	ff 30                	pushl  (%eax)
  800806:	e8 a9 fb ff ff       	call   8003b4 <dev_lookup>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	85 c0                	test   %eax,%eax
  800810:	78 37                	js     800849 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  800812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800815:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800819:	74 32                	je     80084d <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80081b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80081e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800825:	00 00 00 
	stat->st_isdir = 0;
  800828:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80082f:	00 00 00 
	stat->st_dev = dev;
  800832:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	53                   	push   %ebx
  80083c:	ff 75 f0             	pushl  -0x10(%ebp)
  80083f:	ff 50 14             	call   *0x14(%eax)
  800842:	89 c2                	mov    %eax,%edx
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	eb 09                	jmp    800852 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800849:	89 c2                	mov    %eax,%edx
  80084b:	eb 05                	jmp    800852 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80084d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800852:	89 d0                	mov    %edx,%eax
  800854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800857:	c9                   	leave  
  800858:	c3                   	ret    

00800859 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	56                   	push   %esi
  80085d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	6a 00                	push   $0x0
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 06 02 00 00       	call   800a71 <open>
  80086b:	89 c3                	mov    %eax,%ebx
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	85 c0                	test   %eax,%eax
  800872:	78 1b                	js     80088f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	50                   	push   %eax
  80087b:	e8 5b ff ff ff       	call   8007db <fstat>
  800880:	89 c6                	mov    %eax,%esi
	close(fd);
  800882:	89 1c 24             	mov    %ebx,(%esp)
  800885:	e8 fd fb ff ff       	call   800487 <close>
	return r;
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	89 f0                	mov    %esi,%eax
}
  80088f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	89 c6                	mov    %eax,%esi
  80089d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80089f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008a6:	75 12                	jne    8008ba <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8008a8:	83 ec 0c             	sub    $0xc,%esp
  8008ab:	6a 01                	push   $0x1
  8008ad:	e8 94 11 00 00       	call   801a46 <ipc_find_env>
  8008b2:	a3 00 40 80 00       	mov    %eax,0x804000
  8008b7:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008ba:	6a 07                	push   $0x7
  8008bc:	68 00 50 80 00       	push   $0x805000
  8008c1:	56                   	push   %esi
  8008c2:	ff 35 00 40 80 00    	pushl  0x804000
  8008c8:	e8 25 11 00 00       	call   8019f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008cd:	83 c4 0c             	add    $0xc,%esp
  8008d0:	6a 00                	push   $0x0
  8008d2:	53                   	push   %ebx
  8008d3:	6a 00                	push   $0x0
  8008d5:	e8 ad 10 00 00       	call   801987 <ipc_recv>
}
  8008da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8008ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ff:	b8 02 00 00 00       	mov    $0x2,%eax
  800904:	e8 8d ff ff ff       	call   800896 <fsipc>
}
  800909:	c9                   	leave  
  80090a:	c3                   	ret    

0080090b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 40 0c             	mov    0xc(%eax),%eax
  800917:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80091c:	ba 00 00 00 00       	mov    $0x0,%edx
  800921:	b8 06 00 00 00       	mov    $0x6,%eax
  800926:	e8 6b ff ff ff       	call   800896 <fsipc>
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	83 ec 04             	sub    $0x4,%esp
  800934:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 40 0c             	mov    0xc(%eax),%eax
  80093d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800942:	ba 00 00 00 00       	mov    $0x0,%edx
  800947:	b8 05 00 00 00       	mov    $0x5,%eax
  80094c:	e8 45 ff ff ff       	call   800896 <fsipc>
  800951:	85 c0                	test   %eax,%eax
  800953:	78 2c                	js     800981 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	68 00 50 80 00       	push   $0x805000
  80095d:	53                   	push   %ebx
  80095e:	e8 dc 0c 00 00       	call   80163f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800963:	a1 80 50 80 00       	mov    0x805080,%eax
  800968:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80096e:	a1 84 50 80 00       	mov    0x805084,%eax
  800973:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800981:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800992:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800995:	8b 49 0c             	mov    0xc(%ecx),%ecx
  800998:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80099e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009a3:	76 22                	jbe    8009c7 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8009a5:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8009ac:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8009af:	83 ec 04             	sub    $0x4,%esp
  8009b2:	68 f8 0f 00 00       	push   $0xff8
  8009b7:	52                   	push   %edx
  8009b8:	68 08 50 80 00       	push   $0x805008
  8009bd:	e8 10 0e 00 00       	call   8017d2 <memmove>
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	eb 17                	jmp    8009de <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8009c7:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009cc:	83 ec 04             	sub    $0x4,%esp
  8009cf:	50                   	push   %eax
  8009d0:	52                   	push   %edx
  8009d1:	68 08 50 80 00       	push   $0x805008
  8009d6:	e8 f7 0d 00 00       	call   8017d2 <memmove>
  8009db:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009de:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8009e8:	e8 a9 fe ff ff       	call   800896 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8009fd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a02:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a12:	e8 7f fe ff ff       	call   800896 <fsipc>
  800a17:	89 c3                	mov    %eax,%ebx
  800a19:	85 c0                	test   %eax,%eax
  800a1b:	78 4b                	js     800a68 <devfile_read+0x79>
		return r;
	assert(r <= n);
  800a1d:	39 c6                	cmp    %eax,%esi
  800a1f:	73 16                	jae    800a37 <devfile_read+0x48>
  800a21:	68 24 1e 80 00       	push   $0x801e24
  800a26:	68 2b 1e 80 00       	push   $0x801e2b
  800a2b:	6a 7c                	push   $0x7c
  800a2d:	68 40 1e 80 00       	push   $0x801e40
  800a32:	e8 bd 05 00 00       	call   800ff4 <_panic>
	assert(r <= PGSIZE);
  800a37:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a3c:	7e 16                	jle    800a54 <devfile_read+0x65>
  800a3e:	68 4b 1e 80 00       	push   $0x801e4b
  800a43:	68 2b 1e 80 00       	push   $0x801e2b
  800a48:	6a 7d                	push   $0x7d
  800a4a:	68 40 1e 80 00       	push   $0x801e40
  800a4f:	e8 a0 05 00 00       	call   800ff4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a54:	83 ec 04             	sub    $0x4,%esp
  800a57:	50                   	push   %eax
  800a58:	68 00 50 80 00       	push   $0x805000
  800a5d:	ff 75 0c             	pushl  0xc(%ebp)
  800a60:	e8 6d 0d 00 00       	call   8017d2 <memmove>
	return r;
  800a65:	83 c4 10             	add    $0x10,%esp
}
  800a68:	89 d8                	mov    %ebx,%eax
  800a6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a6d:	5b                   	pop    %ebx
  800a6e:	5e                   	pop    %esi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	53                   	push   %ebx
  800a75:	83 ec 20             	sub    $0x20,%esp
  800a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a7b:	53                   	push   %ebx
  800a7c:	e8 85 0b 00 00       	call   801606 <strlen>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a89:	7f 67                	jg     800af2 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a8b:	83 ec 0c             	sub    $0xc,%esp
  800a8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 78 f8 ff ff       	call   80030f <fd_alloc>
  800a97:	83 c4 10             	add    $0x10,%esp
		return r;
  800a9a:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a9c:	85 c0                	test   %eax,%eax
  800a9e:	78 57                	js     800af7 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	53                   	push   %ebx
  800aa4:	68 00 50 80 00       	push   $0x805000
  800aa9:	e8 91 0b 00 00       	call   80163f <strcpy>
	fsipcbuf.open.req_omode = mode;
  800aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab1:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  800abe:	e8 d3 fd ff ff       	call   800896 <fsipc>
  800ac3:	89 c3                	mov    %eax,%ebx
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	85 c0                	test   %eax,%eax
  800aca:	79 14                	jns    800ae0 <open+0x6f>
		fd_close(fd, 0);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	6a 00                	push   $0x0
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	e8 2e f9 ff ff       	call   800407 <fd_close>
		return r;
  800ad9:	83 c4 10             	add    $0x10,%esp
  800adc:	89 da                	mov    %ebx,%edx
  800ade:	eb 17                	jmp    800af7 <open+0x86>
	}

	return fd2num(fd);
  800ae0:	83 ec 0c             	sub    $0xc,%esp
  800ae3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae6:	e8 fc f7 ff ff       	call   8002e7 <fd2num>
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	eb 05                	jmp    800af7 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800af2:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800af7:	89 d0                	mov    %edx,%eax
  800af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    

00800afe <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b04:	ba 00 00 00 00       	mov    $0x0,%edx
  800b09:	b8 08 00 00 00       	mov    $0x8,%eax
  800b0e:	e8 83 fd ff ff       	call   800896 <fsipc>
}
  800b13:	c9                   	leave  
  800b14:	c3                   	ret    

00800b15 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b1d:	83 ec 0c             	sub    $0xc,%esp
  800b20:	ff 75 08             	pushl  0x8(%ebp)
  800b23:	e8 cf f7 ff ff       	call   8002f7 <fd2data>
  800b28:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b2a:	83 c4 08             	add    $0x8,%esp
  800b2d:	68 57 1e 80 00       	push   $0x801e57
  800b32:	53                   	push   %ebx
  800b33:	e8 07 0b 00 00       	call   80163f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b38:	8b 46 04             	mov    0x4(%esi),%eax
  800b3b:	2b 06                	sub    (%esi),%eax
  800b3d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b43:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b4a:	00 00 00 
	stat->st_dev = &devpipe;
  800b4d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b54:	30 80 00 
	return 0;
}
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	53                   	push   %ebx
  800b67:	83 ec 0c             	sub    $0xc,%esp
  800b6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b6d:	53                   	push   %ebx
  800b6e:	6a 00                	push   $0x0
  800b70:	e8 9f f6 ff ff       	call   800214 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b75:	89 1c 24             	mov    %ebx,(%esp)
  800b78:	e8 7a f7 ff ff       	call   8002f7 <fd2data>
  800b7d:	83 c4 08             	add    $0x8,%esp
  800b80:	50                   	push   %eax
  800b81:	6a 00                	push   $0x0
  800b83:	e8 8c f6 ff ff       	call   800214 <sys_page_unmap>
}
  800b88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	83 ec 1c             	sub    $0x1c,%esp
  800b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b99:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b9b:	a1 04 40 80 00       	mov    0x804004,%eax
  800ba0:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800ba3:	83 ec 0c             	sub    $0xc,%esp
  800ba6:	ff 75 e0             	pushl  -0x20(%ebp)
  800ba9:	e8 d1 0e 00 00       	call   801a7f <pageref>
  800bae:	89 c3                	mov    %eax,%ebx
  800bb0:	89 3c 24             	mov    %edi,(%esp)
  800bb3:	e8 c7 0e 00 00       	call   801a7f <pageref>
  800bb8:	83 c4 10             	add    $0x10,%esp
  800bbb:	39 c3                	cmp    %eax,%ebx
  800bbd:	0f 94 c1             	sete   %cl
  800bc0:	0f b6 c9             	movzbl %cl,%ecx
  800bc3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800bc6:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800bcc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800bcf:	39 ce                	cmp    %ecx,%esi
  800bd1:	74 1b                	je     800bee <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800bd3:	39 c3                	cmp    %eax,%ebx
  800bd5:	75 c4                	jne    800b9b <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bd7:	8b 42 58             	mov    0x58(%edx),%eax
  800bda:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bdd:	50                   	push   %eax
  800bde:	56                   	push   %esi
  800bdf:	68 5e 1e 80 00       	push   $0x801e5e
  800be4:	e8 e4 04 00 00       	call   8010cd <cprintf>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	eb ad                	jmp    800b9b <_pipeisclosed+0xe>
	}
}
  800bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5f                   	pop    %edi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 28             	sub    $0x28,%esp
  800c02:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800c05:	56                   	push   %esi
  800c06:	e8 ec f6 ff ff       	call   8002f7 <fd2data>
  800c0b:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	bf 00 00 00 00       	mov    $0x0,%edi
  800c15:	eb 4b                	jmp    800c62 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800c17:	89 da                	mov    %ebx,%edx
  800c19:	89 f0                	mov    %esi,%eax
  800c1b:	e8 6d ff ff ff       	call   800b8d <_pipeisclosed>
  800c20:	85 c0                	test   %eax,%eax
  800c22:	75 48                	jne    800c6c <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800c24:	e8 7a f5 ff ff       	call   8001a3 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c29:	8b 43 04             	mov    0x4(%ebx),%eax
  800c2c:	8b 0b                	mov    (%ebx),%ecx
  800c2e:	8d 51 20             	lea    0x20(%ecx),%edx
  800c31:	39 d0                	cmp    %edx,%eax
  800c33:	73 e2                	jae    800c17 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c38:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c3c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c3f:	89 c2                	mov    %eax,%edx
  800c41:	c1 fa 1f             	sar    $0x1f,%edx
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	c1 e9 1b             	shr    $0x1b,%ecx
  800c49:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c4c:	83 e2 1f             	and    $0x1f,%edx
  800c4f:	29 ca                	sub    %ecx,%edx
  800c51:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c55:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c59:	83 c0 01             	add    $0x1,%eax
  800c5c:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c5f:	83 c7 01             	add    $0x1,%edi
  800c62:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c65:	75 c2                	jne    800c29 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	eb 05                	jmp    800c71 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	53                   	push   %ebx
  800c7f:	83 ec 18             	sub    $0x18,%esp
  800c82:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c85:	57                   	push   %edi
  800c86:	e8 6c f6 ff ff       	call   8002f7 <fd2data>
  800c8b:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c8d:	83 c4 10             	add    $0x10,%esp
  800c90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c95:	eb 3d                	jmp    800cd4 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c97:	85 db                	test   %ebx,%ebx
  800c99:	74 04                	je     800c9f <devpipe_read+0x26>
				return i;
  800c9b:	89 d8                	mov    %ebx,%eax
  800c9d:	eb 44                	jmp    800ce3 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c9f:	89 f2                	mov    %esi,%edx
  800ca1:	89 f8                	mov    %edi,%eax
  800ca3:	e8 e5 fe ff ff       	call   800b8d <_pipeisclosed>
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	75 32                	jne    800cde <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800cac:	e8 f2 f4 ff ff       	call   8001a3 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800cb1:	8b 06                	mov    (%esi),%eax
  800cb3:	3b 46 04             	cmp    0x4(%esi),%eax
  800cb6:	74 df                	je     800c97 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800cb8:	99                   	cltd   
  800cb9:	c1 ea 1b             	shr    $0x1b,%edx
  800cbc:	01 d0                	add    %edx,%eax
  800cbe:	83 e0 1f             	and    $0x1f,%eax
  800cc1:	29 d0                	sub    %edx,%eax
  800cc3:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800cce:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800cd1:	83 c3 01             	add    $0x1,%ebx
  800cd4:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cd7:	75 d8                	jne    800cb1 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdc:	eb 05                	jmp    800ce3 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800cf3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cf6:	50                   	push   %eax
  800cf7:	e8 13 f6 ff ff       	call   80030f <fd_alloc>
  800cfc:	83 c4 10             	add    $0x10,%esp
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	85 c0                	test   %eax,%eax
  800d03:	0f 88 2c 01 00 00    	js     800e35 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d09:	83 ec 04             	sub    $0x4,%esp
  800d0c:	68 07 04 00 00       	push   $0x407
  800d11:	ff 75 f4             	pushl  -0xc(%ebp)
  800d14:	6a 00                	push   $0x0
  800d16:	e8 af f4 ff ff       	call   8001ca <sys_page_alloc>
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	89 c2                	mov    %eax,%edx
  800d20:	85 c0                	test   %eax,%eax
  800d22:	0f 88 0d 01 00 00    	js     800e35 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800d28:	83 ec 0c             	sub    $0xc,%esp
  800d2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d2e:	50                   	push   %eax
  800d2f:	e8 db f5 ff ff       	call   80030f <fd_alloc>
  800d34:	89 c3                	mov    %eax,%ebx
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	0f 88 e2 00 00 00    	js     800e23 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d41:	83 ec 04             	sub    $0x4,%esp
  800d44:	68 07 04 00 00       	push   $0x407
  800d49:	ff 75 f0             	pushl  -0x10(%ebp)
  800d4c:	6a 00                	push   $0x0
  800d4e:	e8 77 f4 ff ff       	call   8001ca <sys_page_alloc>
  800d53:	89 c3                	mov    %eax,%ebx
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	0f 88 c3 00 00 00    	js     800e23 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	ff 75 f4             	pushl  -0xc(%ebp)
  800d66:	e8 8c f5 ff ff       	call   8002f7 <fd2data>
  800d6b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d6d:	83 c4 0c             	add    $0xc,%esp
  800d70:	68 07 04 00 00       	push   $0x407
  800d75:	50                   	push   %eax
  800d76:	6a 00                	push   $0x0
  800d78:	e8 4d f4 ff ff       	call   8001ca <sys_page_alloc>
  800d7d:	89 c3                	mov    %eax,%ebx
  800d7f:	83 c4 10             	add    $0x10,%esp
  800d82:	85 c0                	test   %eax,%eax
  800d84:	0f 88 89 00 00 00    	js     800e13 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d8a:	83 ec 0c             	sub    $0xc,%esp
  800d8d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d90:	e8 62 f5 ff ff       	call   8002f7 <fd2data>
  800d95:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d9c:	50                   	push   %eax
  800d9d:	6a 00                	push   $0x0
  800d9f:	56                   	push   %esi
  800da0:	6a 00                	push   $0x0
  800da2:	e8 47 f4 ff ff       	call   8001ee <sys_page_map>
  800da7:	89 c3                	mov    %eax,%ebx
  800da9:	83 c4 20             	add    $0x20,%esp
  800dac:	85 c0                	test   %eax,%eax
  800dae:	78 55                	js     800e05 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800db0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db9:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800dc5:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800dda:	83 ec 0c             	sub    $0xc,%esp
  800ddd:	ff 75 f4             	pushl  -0xc(%ebp)
  800de0:	e8 02 f5 ff ff       	call   8002e7 <fd2num>
  800de5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dea:	83 c4 04             	add    $0x4,%esp
  800ded:	ff 75 f0             	pushl  -0x10(%ebp)
  800df0:	e8 f2 f4 ff ff       	call   8002e7 <fd2num>
  800df5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800dfb:	83 c4 10             	add    $0x10,%esp
  800dfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800e03:	eb 30                	jmp    800e35 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	56                   	push   %esi
  800e09:	6a 00                	push   $0x0
  800e0b:	e8 04 f4 ff ff       	call   800214 <sys_page_unmap>
  800e10:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800e13:	83 ec 08             	sub    $0x8,%esp
  800e16:	ff 75 f0             	pushl  -0x10(%ebp)
  800e19:	6a 00                	push   $0x0
  800e1b:	e8 f4 f3 ff ff       	call   800214 <sys_page_unmap>
  800e20:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800e23:	83 ec 08             	sub    $0x8,%esp
  800e26:	ff 75 f4             	pushl  -0xc(%ebp)
  800e29:	6a 00                	push   $0x0
  800e2b:	e8 e4 f3 ff ff       	call   800214 <sys_page_unmap>
  800e30:	83 c4 10             	add    $0x10,%esp
  800e33:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e35:	89 d0                	mov    %edx,%eax
  800e37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e47:	50                   	push   %eax
  800e48:	ff 75 08             	pushl  0x8(%ebp)
  800e4b:	e8 0e f5 ff ff       	call   80035e <fd_lookup>
  800e50:	83 c4 10             	add    $0x10,%esp
  800e53:	85 c0                	test   %eax,%eax
  800e55:	78 18                	js     800e6f <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e57:	83 ec 0c             	sub    $0xc,%esp
  800e5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e5d:	e8 95 f4 ff ff       	call   8002f7 <fd2data>
	return _pipeisclosed(fd, p);
  800e62:	89 c2                	mov    %eax,%edx
  800e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e67:	e8 21 fd ff ff       	call   800b8d <_pipeisclosed>
  800e6c:	83 c4 10             	add    $0x10,%esp
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e74:	b8 00 00 00 00       	mov    $0x0,%eax
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e81:	68 76 1e 80 00       	push   $0x801e76
  800e86:	ff 75 0c             	pushl  0xc(%ebp)
  800e89:	e8 b1 07 00 00       	call   80163f <strcpy>
	return 0;
}
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
  800e9b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800ea1:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800ea6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800eac:	eb 2d                	jmp    800edb <devcons_write+0x46>
		m = n - tot;
  800eae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb1:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800eb3:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800eb6:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800ebb:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800ebe:	83 ec 04             	sub    $0x4,%esp
  800ec1:	53                   	push   %ebx
  800ec2:	03 45 0c             	add    0xc(%ebp),%eax
  800ec5:	50                   	push   %eax
  800ec6:	57                   	push   %edi
  800ec7:	e8 06 09 00 00       	call   8017d2 <memmove>
		sys_cputs(buf, m);
  800ecc:	83 c4 08             	add    $0x8,%esp
  800ecf:	53                   	push   %ebx
  800ed0:	57                   	push   %edi
  800ed1:	e8 3d f2 ff ff       	call   800113 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800ed6:	01 de                	add    %ebx,%esi
  800ed8:	83 c4 10             	add    $0x10,%esp
  800edb:	89 f0                	mov    %esi,%eax
  800edd:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ee0:	72 cc                	jb     800eae <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800ef5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef9:	74 2a                	je     800f25 <devcons_read+0x3b>
  800efb:	eb 05                	jmp    800f02 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800efd:	e8 a1 f2 ff ff       	call   8001a3 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800f02:	e8 32 f2 ff ff       	call   800139 <sys_cgetc>
  800f07:	85 c0                	test   %eax,%eax
  800f09:	74 f2                	je     800efd <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	78 16                	js     800f25 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800f0f:	83 f8 04             	cmp    $0x4,%eax
  800f12:	74 0c                	je     800f20 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f17:	88 02                	mov    %al,(%edx)
	return 1;
  800f19:	b8 01 00 00 00       	mov    $0x1,%eax
  800f1e:	eb 05                	jmp    800f25 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800f25:	c9                   	leave  
  800f26:	c3                   	ret    

00800f27 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f33:	6a 01                	push   $0x1
  800f35:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f38:	50                   	push   %eax
  800f39:	e8 d5 f1 ff ff       	call   800113 <sys_cputs>
}
  800f3e:	83 c4 10             	add    $0x10,%esp
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <getchar>:

int
getchar(void)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f49:	6a 01                	push   $0x1
  800f4b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f4e:	50                   	push   %eax
  800f4f:	6a 00                	push   $0x0
  800f51:	e8 6d f6 ff ff       	call   8005c3 <read>
	if (r < 0)
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	78 0f                	js     800f6c <getchar+0x29>
		return r;
	if (r < 1)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7e 06                	jle    800f67 <getchar+0x24>
		return -E_EOF;
	return c;
  800f61:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f65:	eb 05                	jmp    800f6c <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f67:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f77:	50                   	push   %eax
  800f78:	ff 75 08             	pushl  0x8(%ebp)
  800f7b:	e8 de f3 ff ff       	call   80035e <fd_lookup>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	85 c0                	test   %eax,%eax
  800f85:	78 11                	js     800f98 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800f90:	39 10                	cmp    %edx,(%eax)
  800f92:	0f 94 c0             	sete   %al
  800f95:	0f b6 c0             	movzbl %al,%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <opencons>:

int
opencons(void)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800fa0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa3:	50                   	push   %eax
  800fa4:	e8 66 f3 ff ff       	call   80030f <fd_alloc>
  800fa9:	83 c4 10             	add    $0x10,%esp
		return r;
  800fac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	78 3e                	js     800ff0 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fb2:	83 ec 04             	sub    $0x4,%esp
  800fb5:	68 07 04 00 00       	push   $0x407
  800fba:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbd:	6a 00                	push   $0x0
  800fbf:	e8 06 f2 ff ff       	call   8001ca <sys_page_alloc>
  800fc4:	83 c4 10             	add    $0x10,%esp
		return r;
  800fc7:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	78 23                	js     800ff0 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800fcd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fe2:	83 ec 0c             	sub    $0xc,%esp
  800fe5:	50                   	push   %eax
  800fe6:	e8 fc f2 ff ff       	call   8002e7 <fd2num>
  800feb:	89 c2                	mov    %eax,%edx
  800fed:	83 c4 10             	add    $0x10,%esp
}
  800ff0:	89 d0                	mov    %edx,%eax
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800ff9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ffc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801002:	e8 78 f1 ff ff       	call   80017f <sys_getenvid>
  801007:	83 ec 0c             	sub    $0xc,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	ff 75 08             	pushl  0x8(%ebp)
  801010:	56                   	push   %esi
  801011:	50                   	push   %eax
  801012:	68 84 1e 80 00       	push   $0x801e84
  801017:	e8 b1 00 00 00       	call   8010cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80101c:	83 c4 18             	add    $0x18,%esp
  80101f:	53                   	push   %ebx
  801020:	ff 75 10             	pushl  0x10(%ebp)
  801023:	e8 54 00 00 00       	call   80107c <vcprintf>
	cprintf("\n");
  801028:	c7 04 24 6f 1e 80 00 	movl   $0x801e6f,(%esp)
  80102f:	e8 99 00 00 00       	call   8010cd <cprintf>
  801034:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801037:	cc                   	int3   
  801038:	eb fd                	jmp    801037 <_panic+0x43>

0080103a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	53                   	push   %ebx
  80103e:	83 ec 04             	sub    $0x4,%esp
  801041:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801044:	8b 13                	mov    (%ebx),%edx
  801046:	8d 42 01             	lea    0x1(%edx),%eax
  801049:	89 03                	mov    %eax,(%ebx)
  80104b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801052:	3d ff 00 00 00       	cmp    $0xff,%eax
  801057:	75 1a                	jne    801073 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  801059:	83 ec 08             	sub    $0x8,%esp
  80105c:	68 ff 00 00 00       	push   $0xff
  801061:	8d 43 08             	lea    0x8(%ebx),%eax
  801064:	50                   	push   %eax
  801065:	e8 a9 f0 ff ff       	call   800113 <sys_cputs>
		b->idx = 0;
  80106a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801070:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801073:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801085:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80108c:	00 00 00 
	b.cnt = 0;
  80108f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801096:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	ff 75 08             	pushl  0x8(%ebp)
  80109f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8010a5:	50                   	push   %eax
  8010a6:	68 3a 10 80 00       	push   $0x80103a
  8010ab:	e8 86 01 00 00       	call   801236 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8010b0:	83 c4 08             	add    $0x8,%esp
  8010b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8010b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010bf:	50                   	push   %eax
  8010c0:	e8 4e f0 ff ff       	call   800113 <sys_cputs>

	return b.cnt;
}
  8010c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 08             	pushl  0x8(%ebp)
  8010da:	e8 9d ff ff ff       	call   80107c <vcprintf>
	va_end(ap);

	return cnt;
}
  8010df:	c9                   	leave  
  8010e0:	c3                   	ret    

008010e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 1c             	sub    $0x1c,%esp
  8010ea:	89 c7                	mov    %eax,%edi
  8010ec:	89 d6                	mov    %edx,%esi
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801102:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801105:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801108:	39 d3                	cmp    %edx,%ebx
  80110a:	72 05                	jb     801111 <printnum+0x30>
  80110c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80110f:	77 45                	ja     801156 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	ff 75 18             	pushl  0x18(%ebp)
  801117:	8b 45 14             	mov    0x14(%ebp),%eax
  80111a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80111d:	53                   	push   %ebx
  80111e:	ff 75 10             	pushl  0x10(%ebp)
  801121:	83 ec 08             	sub    $0x8,%esp
  801124:	ff 75 e4             	pushl  -0x1c(%ebp)
  801127:	ff 75 e0             	pushl  -0x20(%ebp)
  80112a:	ff 75 dc             	pushl  -0x24(%ebp)
  80112d:	ff 75 d8             	pushl  -0x28(%ebp)
  801130:	e8 8b 09 00 00       	call   801ac0 <__udivdi3>
  801135:	83 c4 18             	add    $0x18,%esp
  801138:	52                   	push   %edx
  801139:	50                   	push   %eax
  80113a:	89 f2                	mov    %esi,%edx
  80113c:	89 f8                	mov    %edi,%eax
  80113e:	e8 9e ff ff ff       	call   8010e1 <printnum>
  801143:	83 c4 20             	add    $0x20,%esp
  801146:	eb 18                	jmp    801160 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	56                   	push   %esi
  80114c:	ff 75 18             	pushl  0x18(%ebp)
  80114f:	ff d7                	call   *%edi
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	eb 03                	jmp    801159 <printnum+0x78>
  801156:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801159:	83 eb 01             	sub    $0x1,%ebx
  80115c:	85 db                	test   %ebx,%ebx
  80115e:	7f e8                	jg     801148 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801160:	83 ec 08             	sub    $0x8,%esp
  801163:	56                   	push   %esi
  801164:	83 ec 04             	sub    $0x4,%esp
  801167:	ff 75 e4             	pushl  -0x1c(%ebp)
  80116a:	ff 75 e0             	pushl  -0x20(%ebp)
  80116d:	ff 75 dc             	pushl  -0x24(%ebp)
  801170:	ff 75 d8             	pushl  -0x28(%ebp)
  801173:	e8 78 0a 00 00       	call   801bf0 <__umoddi3>
  801178:	83 c4 14             	add    $0x14,%esp
  80117b:	0f be 80 a7 1e 80 00 	movsbl 0x801ea7(%eax),%eax
  801182:	50                   	push   %eax
  801183:	ff d7                	call   *%edi
}
  801185:	83 c4 10             	add    $0x10,%esp
  801188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801193:	83 fa 01             	cmp    $0x1,%edx
  801196:	7e 0e                	jle    8011a6 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801198:	8b 10                	mov    (%eax),%edx
  80119a:	8d 4a 08             	lea    0x8(%edx),%ecx
  80119d:	89 08                	mov    %ecx,(%eax)
  80119f:	8b 02                	mov    (%edx),%eax
  8011a1:	8b 52 04             	mov    0x4(%edx),%edx
  8011a4:	eb 22                	jmp    8011c8 <getuint+0x38>
	else if (lflag)
  8011a6:	85 d2                	test   %edx,%edx
  8011a8:	74 10                	je     8011ba <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8011aa:	8b 10                	mov    (%eax),%edx
  8011ac:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011af:	89 08                	mov    %ecx,(%eax)
  8011b1:	8b 02                	mov    (%edx),%eax
  8011b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b8:	eb 0e                	jmp    8011c8 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8011ba:	8b 10                	mov    (%eax),%edx
  8011bc:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011bf:	89 08                	mov    %ecx,(%eax)
  8011c1:	8b 02                	mov    (%edx),%eax
  8011c3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011cd:	83 fa 01             	cmp    $0x1,%edx
  8011d0:	7e 0e                	jle    8011e0 <getint+0x16>
		return va_arg(*ap, long long);
  8011d2:	8b 10                	mov    (%eax),%edx
  8011d4:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011d7:	89 08                	mov    %ecx,(%eax)
  8011d9:	8b 02                	mov    (%edx),%eax
  8011db:	8b 52 04             	mov    0x4(%edx),%edx
  8011de:	eb 1a                	jmp    8011fa <getint+0x30>
	else if (lflag)
  8011e0:	85 d2                	test   %edx,%edx
  8011e2:	74 0c                	je     8011f0 <getint+0x26>
		return va_arg(*ap, long);
  8011e4:	8b 10                	mov    (%eax),%edx
  8011e6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011e9:	89 08                	mov    %ecx,(%eax)
  8011eb:	8b 02                	mov    (%edx),%eax
  8011ed:	99                   	cltd   
  8011ee:	eb 0a                	jmp    8011fa <getint+0x30>
	else
		return va_arg(*ap, int);
  8011f0:	8b 10                	mov    (%eax),%edx
  8011f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011f5:	89 08                	mov    %ecx,(%eax)
  8011f7:	8b 02                	mov    (%edx),%eax
  8011f9:	99                   	cltd   
}
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801202:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801206:	8b 10                	mov    (%eax),%edx
  801208:	3b 50 04             	cmp    0x4(%eax),%edx
  80120b:	73 0a                	jae    801217 <sprintputch+0x1b>
		*b->buf++ = ch;
  80120d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801210:	89 08                	mov    %ecx,(%eax)
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	88 02                	mov    %al,(%edx)
}
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    

00801219 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80121f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801222:	50                   	push   %eax
  801223:	ff 75 10             	pushl  0x10(%ebp)
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	ff 75 08             	pushl  0x8(%ebp)
  80122c:	e8 05 00 00 00       	call   801236 <vprintfmt>
	va_end(ap);
}
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	57                   	push   %edi
  80123a:	56                   	push   %esi
  80123b:	53                   	push   %ebx
  80123c:	83 ec 2c             	sub    $0x2c,%esp
  80123f:	8b 75 08             	mov    0x8(%ebp),%esi
  801242:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801245:	8b 7d 10             	mov    0x10(%ebp),%edi
  801248:	eb 12                	jmp    80125c <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80124a:	85 c0                	test   %eax,%eax
  80124c:	0f 84 44 03 00 00    	je     801596 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  801252:	83 ec 08             	sub    $0x8,%esp
  801255:	53                   	push   %ebx
  801256:	50                   	push   %eax
  801257:	ff d6                	call   *%esi
  801259:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80125c:	83 c7 01             	add    $0x1,%edi
  80125f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801263:	83 f8 25             	cmp    $0x25,%eax
  801266:	75 e2                	jne    80124a <vprintfmt+0x14>
  801268:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80126c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801273:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80127a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801281:	ba 00 00 00 00       	mov    $0x0,%edx
  801286:	eb 07                	jmp    80128f <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801288:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80128b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80128f:	8d 47 01             	lea    0x1(%edi),%eax
  801292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801295:	0f b6 07             	movzbl (%edi),%eax
  801298:	0f b6 c8             	movzbl %al,%ecx
  80129b:	83 e8 23             	sub    $0x23,%eax
  80129e:	3c 55                	cmp    $0x55,%al
  8012a0:	0f 87 d5 02 00 00    	ja     80157b <vprintfmt+0x345>
  8012a6:	0f b6 c0             	movzbl %al,%eax
  8012a9:	ff 24 85 e0 1f 80 00 	jmp    *0x801fe0(,%eax,4)
  8012b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012b3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8012b7:	eb d6                	jmp    80128f <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8012c4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8012c7:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012cb:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012ce:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012d1:	83 fa 09             	cmp    $0x9,%edx
  8012d4:	77 39                	ja     80130f <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012d6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012d9:	eb e9                	jmp    8012c4 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	8d 48 04             	lea    0x4(%eax),%ecx
  8012e1:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012e4:	8b 00                	mov    (%eax),%eax
  8012e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012ec:	eb 27                	jmp    801315 <vprintfmt+0xdf>
  8012ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f8:	0f 49 c8             	cmovns %eax,%ecx
  8012fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801301:	eb 8c                	jmp    80128f <vprintfmt+0x59>
  801303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801306:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80130d:	eb 80                	jmp    80128f <vprintfmt+0x59>
  80130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801312:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  801315:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801319:	0f 89 70 ff ff ff    	jns    80128f <vprintfmt+0x59>
				width = precision, precision = -1;
  80131f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801322:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801325:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80132c:	e9 5e ff ff ff       	jmp    80128f <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801331:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801334:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801337:	e9 53 ff ff ff       	jmp    80128f <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	8d 50 04             	lea    0x4(%eax),%edx
  801342:	89 55 14             	mov    %edx,0x14(%ebp)
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	53                   	push   %ebx
  801349:	ff 30                	pushl  (%eax)
  80134b:	ff d6                	call   *%esi
			break;
  80134d:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801353:	e9 04 ff ff ff       	jmp    80125c <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801358:	8b 45 14             	mov    0x14(%ebp),%eax
  80135b:	8d 50 04             	lea    0x4(%eax),%edx
  80135e:	89 55 14             	mov    %edx,0x14(%ebp)
  801361:	8b 00                	mov    (%eax),%eax
  801363:	99                   	cltd   
  801364:	31 d0                	xor    %edx,%eax
  801366:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801368:	83 f8 0f             	cmp    $0xf,%eax
  80136b:	7f 0b                	jg     801378 <vprintfmt+0x142>
  80136d:	8b 14 85 40 21 80 00 	mov    0x802140(,%eax,4),%edx
  801374:	85 d2                	test   %edx,%edx
  801376:	75 18                	jne    801390 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  801378:	50                   	push   %eax
  801379:	68 bf 1e 80 00       	push   $0x801ebf
  80137e:	53                   	push   %ebx
  80137f:	56                   	push   %esi
  801380:	e8 94 fe ff ff       	call   801219 <printfmt>
  801385:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80138b:	e9 cc fe ff ff       	jmp    80125c <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801390:	52                   	push   %edx
  801391:	68 3d 1e 80 00       	push   $0x801e3d
  801396:	53                   	push   %ebx
  801397:	56                   	push   %esi
  801398:	e8 7c fe ff ff       	call   801219 <printfmt>
  80139d:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013a3:	e9 b4 fe ff ff       	jmp    80125c <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8013a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ab:	8d 50 04             	lea    0x4(%eax),%edx
  8013ae:	89 55 14             	mov    %edx,0x14(%ebp)
  8013b1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8013b3:	85 ff                	test   %edi,%edi
  8013b5:	b8 b8 1e 80 00       	mov    $0x801eb8,%eax
  8013ba:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8013bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013c1:	0f 8e 94 00 00 00    	jle    80145b <vprintfmt+0x225>
  8013c7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013cb:	0f 84 98 00 00 00    	je     801469 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d1:	83 ec 08             	sub    $0x8,%esp
  8013d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8013d7:	57                   	push   %edi
  8013d8:	e8 41 02 00 00       	call   80161e <strnlen>
  8013dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013e0:	29 c1                	sub    %eax,%ecx
  8013e2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013e5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013e8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013ef:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013f2:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013f4:	eb 0f                	jmp    801405 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013f6:	83 ec 08             	sub    $0x8,%esp
  8013f9:	53                   	push   %ebx
  8013fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8013fd:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013ff:	83 ef 01             	sub    $0x1,%edi
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 ff                	test   %edi,%edi
  801407:	7f ed                	jg     8013f6 <vprintfmt+0x1c0>
  801409:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80140c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  80140f:	85 c9                	test   %ecx,%ecx
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	0f 49 c1             	cmovns %ecx,%eax
  801419:	29 c1                	sub    %eax,%ecx
  80141b:	89 75 08             	mov    %esi,0x8(%ebp)
  80141e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801421:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801424:	89 cb                	mov    %ecx,%ebx
  801426:	eb 4d                	jmp    801475 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801428:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80142c:	74 1b                	je     801449 <vprintfmt+0x213>
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 20             	sub    $0x20,%eax
  801434:	83 f8 5e             	cmp    $0x5e,%eax
  801437:	76 10                	jbe    801449 <vprintfmt+0x213>
					putch('?', putdat);
  801439:	83 ec 08             	sub    $0x8,%esp
  80143c:	ff 75 0c             	pushl  0xc(%ebp)
  80143f:	6a 3f                	push   $0x3f
  801441:	ff 55 08             	call   *0x8(%ebp)
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	eb 0d                	jmp    801456 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	ff 75 0c             	pushl  0xc(%ebp)
  80144f:	52                   	push   %edx
  801450:	ff 55 08             	call   *0x8(%ebp)
  801453:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801456:	83 eb 01             	sub    $0x1,%ebx
  801459:	eb 1a                	jmp    801475 <vprintfmt+0x23f>
  80145b:	89 75 08             	mov    %esi,0x8(%ebp)
  80145e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801461:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801464:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801467:	eb 0c                	jmp    801475 <vprintfmt+0x23f>
  801469:	89 75 08             	mov    %esi,0x8(%ebp)
  80146c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80146f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801472:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801475:	83 c7 01             	add    $0x1,%edi
  801478:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80147c:	0f be d0             	movsbl %al,%edx
  80147f:	85 d2                	test   %edx,%edx
  801481:	74 23                	je     8014a6 <vprintfmt+0x270>
  801483:	85 f6                	test   %esi,%esi
  801485:	78 a1                	js     801428 <vprintfmt+0x1f2>
  801487:	83 ee 01             	sub    $0x1,%esi
  80148a:	79 9c                	jns    801428 <vprintfmt+0x1f2>
  80148c:	89 df                	mov    %ebx,%edi
  80148e:	8b 75 08             	mov    0x8(%ebp),%esi
  801491:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801494:	eb 18                	jmp    8014ae <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	53                   	push   %ebx
  80149a:	6a 20                	push   $0x20
  80149c:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80149e:	83 ef 01             	sub    $0x1,%edi
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	eb 08                	jmp    8014ae <vprintfmt+0x278>
  8014a6:	89 df                	mov    %ebx,%edi
  8014a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8014ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014ae:	85 ff                	test   %edi,%edi
  8014b0:	7f e4                	jg     801496 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8014b5:	e9 a2 fd ff ff       	jmp    80125c <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8014bd:	e8 08 fd ff ff       	call   8011ca <getint>
  8014c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8014c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014d1:	79 74                	jns    801547 <vprintfmt+0x311>
				putch('-', putdat);
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	53                   	push   %ebx
  8014d7:	6a 2d                	push   $0x2d
  8014d9:	ff d6                	call   *%esi
				num = -(long long) num;
  8014db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014e1:	f7 d8                	neg    %eax
  8014e3:	83 d2 00             	adc    $0x0,%edx
  8014e6:	f7 da                	neg    %edx
  8014e8:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f0:	eb 55                	jmp    801547 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8014f5:	e8 96 fc ff ff       	call   801190 <getuint>
			base = 10;
  8014fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014ff:	eb 46                	jmp    801547 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801501:	8d 45 14             	lea    0x14(%ebp),%eax
  801504:	e8 87 fc ff ff       	call   801190 <getuint>
			base = 8;
  801509:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80150e:	eb 37                	jmp    801547 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  801510:	83 ec 08             	sub    $0x8,%esp
  801513:	53                   	push   %ebx
  801514:	6a 30                	push   $0x30
  801516:	ff d6                	call   *%esi
			putch('x', putdat);
  801518:	83 c4 08             	add    $0x8,%esp
  80151b:	53                   	push   %ebx
  80151c:	6a 78                	push   $0x78
  80151e:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8d 50 04             	lea    0x4(%eax),%edx
  801526:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801530:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801533:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801538:	eb 0d                	jmp    801547 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80153a:	8d 45 14             	lea    0x14(%ebp),%eax
  80153d:	e8 4e fc ff ff       	call   801190 <getuint>
			base = 16;
  801542:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801547:	83 ec 0c             	sub    $0xc,%esp
  80154a:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80154e:	57                   	push   %edi
  80154f:	ff 75 e0             	pushl  -0x20(%ebp)
  801552:	51                   	push   %ecx
  801553:	52                   	push   %edx
  801554:	50                   	push   %eax
  801555:	89 da                	mov    %ebx,%edx
  801557:	89 f0                	mov    %esi,%eax
  801559:	e8 83 fb ff ff       	call   8010e1 <printnum>
			break;
  80155e:	83 c4 20             	add    $0x20,%esp
  801561:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801564:	e9 f3 fc ff ff       	jmp    80125c <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	53                   	push   %ebx
  80156d:	51                   	push   %ecx
  80156e:	ff d6                	call   *%esi
			break;
  801570:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801576:	e9 e1 fc ff ff       	jmp    80125c <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	53                   	push   %ebx
  80157f:	6a 25                	push   $0x25
  801581:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	eb 03                	jmp    80158b <vprintfmt+0x355>
  801588:	83 ef 01             	sub    $0x1,%edi
  80158b:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80158f:	75 f7                	jne    801588 <vprintfmt+0x352>
  801591:	e9 c6 fc ff ff       	jmp    80125c <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  801596:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5f                   	pop    %edi
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 18             	sub    $0x18,%esp
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015ad:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8015b1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8015b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	74 26                	je     8015e5 <vsnprintf+0x47>
  8015bf:	85 d2                	test   %edx,%edx
  8015c1:	7e 22                	jle    8015e5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015c3:	ff 75 14             	pushl  0x14(%ebp)
  8015c6:	ff 75 10             	pushl  0x10(%ebp)
  8015c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015cc:	50                   	push   %eax
  8015cd:	68 fc 11 80 00       	push   $0x8011fc
  8015d2:	e8 5f fc ff ff       	call   801236 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015da:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	eb 05                	jmp    8015ea <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015f5:	50                   	push   %eax
  8015f6:	ff 75 10             	pushl  0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 9a ff ff ff       	call   80159e <vsnprintf>
	va_end(ap);

	return rc;
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
  801611:	eb 03                	jmp    801616 <strlen+0x10>
		n++;
  801613:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801616:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80161a:	75 f7                	jne    801613 <strlen+0xd>
		n++;
	return n;
}
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	eb 03                	jmp    801631 <strnlen+0x13>
		n++;
  80162e:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801631:	39 c2                	cmp    %eax,%edx
  801633:	74 08                	je     80163d <strnlen+0x1f>
  801635:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801639:	75 f3                	jne    80162e <strnlen+0x10>
  80163b:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80163d:	5d                   	pop    %ebp
  80163e:	c3                   	ret    

0080163f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	53                   	push   %ebx
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801649:	89 c2                	mov    %eax,%edx
  80164b:	83 c2 01             	add    $0x1,%edx
  80164e:	83 c1 01             	add    $0x1,%ecx
  801651:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801655:	88 5a ff             	mov    %bl,-0x1(%edx)
  801658:	84 db                	test   %bl,%bl
  80165a:	75 ef                	jne    80164b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80165c:	5b                   	pop    %ebx
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    

0080165f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	53                   	push   %ebx
  801663:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801666:	53                   	push   %ebx
  801667:	e8 9a ff ff ff       	call   801606 <strlen>
  80166c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	01 d8                	add    %ebx,%eax
  801674:	50                   	push   %eax
  801675:	e8 c5 ff ff ff       	call   80163f <strcpy>
	return dst;
}
  80167a:	89 d8                	mov    %ebx,%eax
  80167c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	56                   	push   %esi
  801685:	53                   	push   %ebx
  801686:	8b 75 08             	mov    0x8(%ebp),%esi
  801689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168c:	89 f3                	mov    %esi,%ebx
  80168e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801691:	89 f2                	mov    %esi,%edx
  801693:	eb 0f                	jmp    8016a4 <strncpy+0x23>
		*dst++ = *src;
  801695:	83 c2 01             	add    $0x1,%edx
  801698:	0f b6 01             	movzbl (%ecx),%eax
  80169b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80169e:	80 39 01             	cmpb   $0x1,(%ecx)
  8016a1:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8016a4:	39 da                	cmp    %ebx,%edx
  8016a6:	75 ed                	jne    801695 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8016a8:	89 f0                	mov    %esi,%eax
  8016aa:	5b                   	pop    %ebx
  8016ab:	5e                   	pop    %esi
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    

008016ae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	56                   	push   %esi
  8016b2:	53                   	push   %ebx
  8016b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016b9:	8b 55 10             	mov    0x10(%ebp),%edx
  8016bc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8016be:	85 d2                	test   %edx,%edx
  8016c0:	74 21                	je     8016e3 <strlcpy+0x35>
  8016c2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8016c6:	89 f2                	mov    %esi,%edx
  8016c8:	eb 09                	jmp    8016d3 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016ca:	83 c2 01             	add    $0x1,%edx
  8016cd:	83 c1 01             	add    $0x1,%ecx
  8016d0:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016d3:	39 c2                	cmp    %eax,%edx
  8016d5:	74 09                	je     8016e0 <strlcpy+0x32>
  8016d7:	0f b6 19             	movzbl (%ecx),%ebx
  8016da:	84 db                	test   %bl,%bl
  8016dc:	75 ec                	jne    8016ca <strlcpy+0x1c>
  8016de:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016e0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e3:	29 f0                	sub    %esi,%eax
}
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016f2:	eb 06                	jmp    8016fa <strcmp+0x11>
		p++, q++;
  8016f4:	83 c1 01             	add    $0x1,%ecx
  8016f7:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016fa:	0f b6 01             	movzbl (%ecx),%eax
  8016fd:	84 c0                	test   %al,%al
  8016ff:	74 04                	je     801705 <strcmp+0x1c>
  801701:	3a 02                	cmp    (%edx),%al
  801703:	74 ef                	je     8016f4 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801705:	0f b6 c0             	movzbl %al,%eax
  801708:	0f b6 12             	movzbl (%edx),%edx
  80170b:	29 d0                	sub    %edx,%eax
}
  80170d:	5d                   	pop    %ebp
  80170e:	c3                   	ret    

0080170f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	53                   	push   %ebx
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8b 55 0c             	mov    0xc(%ebp),%edx
  801719:	89 c3                	mov    %eax,%ebx
  80171b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80171e:	eb 06                	jmp    801726 <strncmp+0x17>
		n--, p++, q++;
  801720:	83 c0 01             	add    $0x1,%eax
  801723:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801726:	39 d8                	cmp    %ebx,%eax
  801728:	74 15                	je     80173f <strncmp+0x30>
  80172a:	0f b6 08             	movzbl (%eax),%ecx
  80172d:	84 c9                	test   %cl,%cl
  80172f:	74 04                	je     801735 <strncmp+0x26>
  801731:	3a 0a                	cmp    (%edx),%cl
  801733:	74 eb                	je     801720 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801735:	0f b6 00             	movzbl (%eax),%eax
  801738:	0f b6 12             	movzbl (%edx),%edx
  80173b:	29 d0                	sub    %edx,%eax
  80173d:	eb 05                	jmp    801744 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801744:	5b                   	pop    %ebx
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    

00801747 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801751:	eb 07                	jmp    80175a <strchr+0x13>
		if (*s == c)
  801753:	38 ca                	cmp    %cl,%dl
  801755:	74 0f                	je     801766 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801757:	83 c0 01             	add    $0x1,%eax
  80175a:	0f b6 10             	movzbl (%eax),%edx
  80175d:	84 d2                	test   %dl,%dl
  80175f:	75 f2                	jne    801753 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801772:	eb 03                	jmp    801777 <strfind+0xf>
  801774:	83 c0 01             	add    $0x1,%eax
  801777:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80177a:	38 ca                	cmp    %cl,%dl
  80177c:	74 04                	je     801782 <strfind+0x1a>
  80177e:	84 d2                	test   %dl,%dl
  801780:	75 f2                	jne    801774 <strfind+0xc>
			break;
	return (char *) s;
}
  801782:	5d                   	pop    %ebp
  801783:	c3                   	ret    

00801784 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	57                   	push   %edi
  801788:	56                   	push   %esi
  801789:	53                   	push   %ebx
  80178a:	8b 55 08             	mov    0x8(%ebp),%edx
  80178d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801790:	85 c9                	test   %ecx,%ecx
  801792:	74 37                	je     8017cb <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801794:	f6 c2 03             	test   $0x3,%dl
  801797:	75 2a                	jne    8017c3 <memset+0x3f>
  801799:	f6 c1 03             	test   $0x3,%cl
  80179c:	75 25                	jne    8017c3 <memset+0x3f>
		c &= 0xFF;
  80179e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8017a2:	89 df                	mov    %ebx,%edi
  8017a4:	c1 e7 08             	shl    $0x8,%edi
  8017a7:	89 de                	mov    %ebx,%esi
  8017a9:	c1 e6 18             	shl    $0x18,%esi
  8017ac:	89 d8                	mov    %ebx,%eax
  8017ae:	c1 e0 10             	shl    $0x10,%eax
  8017b1:	09 f0                	or     %esi,%eax
  8017b3:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8017b5:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017b8:	89 f8                	mov    %edi,%eax
  8017ba:	09 d8                	or     %ebx,%eax
  8017bc:	89 d7                	mov    %edx,%edi
  8017be:	fc                   	cld    
  8017bf:	f3 ab                	rep stos %eax,%es:(%edi)
  8017c1:	eb 08                	jmp    8017cb <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017c3:	89 d7                	mov    %edx,%edi
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	fc                   	cld    
  8017c9:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017cb:	89 d0                	mov    %edx,%eax
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5f                   	pop    %edi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    

008017d2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	57                   	push   %edi
  8017d6:	56                   	push   %esi
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017e0:	39 c6                	cmp    %eax,%esi
  8017e2:	73 35                	jae    801819 <memmove+0x47>
  8017e4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017e7:	39 d0                	cmp    %edx,%eax
  8017e9:	73 2e                	jae    801819 <memmove+0x47>
		s += n;
		d += n;
  8017eb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017ee:	89 d6                	mov    %edx,%esi
  8017f0:	09 fe                	or     %edi,%esi
  8017f2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017f8:	75 13                	jne    80180d <memmove+0x3b>
  8017fa:	f6 c1 03             	test   $0x3,%cl
  8017fd:	75 0e                	jne    80180d <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017ff:	83 ef 04             	sub    $0x4,%edi
  801802:	8d 72 fc             	lea    -0x4(%edx),%esi
  801805:	c1 e9 02             	shr    $0x2,%ecx
  801808:	fd                   	std    
  801809:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80180b:	eb 09                	jmp    801816 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80180d:	83 ef 01             	sub    $0x1,%edi
  801810:	8d 72 ff             	lea    -0x1(%edx),%esi
  801813:	fd                   	std    
  801814:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801816:	fc                   	cld    
  801817:	eb 1d                	jmp    801836 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801819:	89 f2                	mov    %esi,%edx
  80181b:	09 c2                	or     %eax,%edx
  80181d:	f6 c2 03             	test   $0x3,%dl
  801820:	75 0f                	jne    801831 <memmove+0x5f>
  801822:	f6 c1 03             	test   $0x3,%cl
  801825:	75 0a                	jne    801831 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  801827:	c1 e9 02             	shr    $0x2,%ecx
  80182a:	89 c7                	mov    %eax,%edi
  80182c:	fc                   	cld    
  80182d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80182f:	eb 05                	jmp    801836 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801831:	89 c7                	mov    %eax,%edi
  801833:	fc                   	cld    
  801834:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801836:	5e                   	pop    %esi
  801837:	5f                   	pop    %edi
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    

0080183a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80183d:	ff 75 10             	pushl  0x10(%ebp)
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 87 ff ff ff       	call   8017d2 <memmove>
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	56                   	push   %esi
  801851:	53                   	push   %ebx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	89 c6                	mov    %eax,%esi
  80185a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80185d:	eb 1a                	jmp    801879 <memcmp+0x2c>
		if (*s1 != *s2)
  80185f:	0f b6 08             	movzbl (%eax),%ecx
  801862:	0f b6 1a             	movzbl (%edx),%ebx
  801865:	38 d9                	cmp    %bl,%cl
  801867:	74 0a                	je     801873 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801869:	0f b6 c1             	movzbl %cl,%eax
  80186c:	0f b6 db             	movzbl %bl,%ebx
  80186f:	29 d8                	sub    %ebx,%eax
  801871:	eb 0f                	jmp    801882 <memcmp+0x35>
		s1++, s2++;
  801873:	83 c0 01             	add    $0x1,%eax
  801876:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801879:	39 f0                	cmp    %esi,%eax
  80187b:	75 e2                	jne    80185f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801882:	5b                   	pop    %ebx
  801883:	5e                   	pop    %esi
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80188d:	89 c1                	mov    %eax,%ecx
  80188f:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  801892:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801896:	eb 0a                	jmp    8018a2 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  801898:	0f b6 10             	movzbl (%eax),%edx
  80189b:	39 da                	cmp    %ebx,%edx
  80189d:	74 07                	je     8018a6 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80189f:	83 c0 01             	add    $0x1,%eax
  8018a2:	39 c8                	cmp    %ecx,%eax
  8018a4:	72 f2                	jb     801898 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8018a6:	5b                   	pop    %ebx
  8018a7:	5d                   	pop    %ebp
  8018a8:	c3                   	ret    

008018a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	57                   	push   %edi
  8018ad:	56                   	push   %esi
  8018ae:	53                   	push   %ebx
  8018af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018b5:	eb 03                	jmp    8018ba <strtol+0x11>
		s++;
  8018b7:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ba:	0f b6 01             	movzbl (%ecx),%eax
  8018bd:	3c 20                	cmp    $0x20,%al
  8018bf:	74 f6                	je     8018b7 <strtol+0xe>
  8018c1:	3c 09                	cmp    $0x9,%al
  8018c3:	74 f2                	je     8018b7 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018c5:	3c 2b                	cmp    $0x2b,%al
  8018c7:	75 0a                	jne    8018d3 <strtol+0x2a>
		s++;
  8018c9:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8018d1:	eb 11                	jmp    8018e4 <strtol+0x3b>
  8018d3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018d8:	3c 2d                	cmp    $0x2d,%al
  8018da:	75 08                	jne    8018e4 <strtol+0x3b>
		s++, neg = 1;
  8018dc:	83 c1 01             	add    $0x1,%ecx
  8018df:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018e4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018ea:	75 15                	jne    801901 <strtol+0x58>
  8018ec:	80 39 30             	cmpb   $0x30,(%ecx)
  8018ef:	75 10                	jne    801901 <strtol+0x58>
  8018f1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018f5:	75 7c                	jne    801973 <strtol+0xca>
		s += 2, base = 16;
  8018f7:	83 c1 02             	add    $0x2,%ecx
  8018fa:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018ff:	eb 16                	jmp    801917 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  801901:	85 db                	test   %ebx,%ebx
  801903:	75 12                	jne    801917 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801905:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80190a:	80 39 30             	cmpb   $0x30,(%ecx)
  80190d:	75 08                	jne    801917 <strtol+0x6e>
		s++, base = 8;
  80190f:	83 c1 01             	add    $0x1,%ecx
  801912:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  801917:	b8 00 00 00 00       	mov    $0x0,%eax
  80191c:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80191f:	0f b6 11             	movzbl (%ecx),%edx
  801922:	8d 72 d0             	lea    -0x30(%edx),%esi
  801925:	89 f3                	mov    %esi,%ebx
  801927:	80 fb 09             	cmp    $0x9,%bl
  80192a:	77 08                	ja     801934 <strtol+0x8b>
			dig = *s - '0';
  80192c:	0f be d2             	movsbl %dl,%edx
  80192f:	83 ea 30             	sub    $0x30,%edx
  801932:	eb 22                	jmp    801956 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  801934:	8d 72 9f             	lea    -0x61(%edx),%esi
  801937:	89 f3                	mov    %esi,%ebx
  801939:	80 fb 19             	cmp    $0x19,%bl
  80193c:	77 08                	ja     801946 <strtol+0x9d>
			dig = *s - 'a' + 10;
  80193e:	0f be d2             	movsbl %dl,%edx
  801941:	83 ea 57             	sub    $0x57,%edx
  801944:	eb 10                	jmp    801956 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  801946:	8d 72 bf             	lea    -0x41(%edx),%esi
  801949:	89 f3                	mov    %esi,%ebx
  80194b:	80 fb 19             	cmp    $0x19,%bl
  80194e:	77 16                	ja     801966 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801950:	0f be d2             	movsbl %dl,%edx
  801953:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  801956:	3b 55 10             	cmp    0x10(%ebp),%edx
  801959:	7d 0b                	jge    801966 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  80195b:	83 c1 01             	add    $0x1,%ecx
  80195e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801962:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  801964:	eb b9                	jmp    80191f <strtol+0x76>

	if (endptr)
  801966:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80196a:	74 0d                	je     801979 <strtol+0xd0>
		*endptr = (char *) s;
  80196c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80196f:	89 0e                	mov    %ecx,(%esi)
  801971:	eb 06                	jmp    801979 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801973:	85 db                	test   %ebx,%ebx
  801975:	74 98                	je     80190f <strtol+0x66>
  801977:	eb 9e                	jmp    801917 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  801979:	89 c2                	mov    %eax,%edx
  80197b:	f7 da                	neg    %edx
  80197d:	85 ff                	test   %edi,%edi
  80197f:	0f 45 c2             	cmovne %edx,%eax
}
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	56                   	push   %esi
  80198b:	53                   	push   %ebx
  80198c:	8b 75 08             	mov    0x8(%ebp),%esi
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801995:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801997:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80199c:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80199f:	83 ec 0c             	sub    $0xc,%esp
  8019a2:	50                   	push   %eax
  8019a3:	e8 1d e9 ff ff       	call   8002c5 <sys_ipc_recv>
	if (from_env_store)
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 f6                	test   %esi,%esi
  8019ad:	74 0b                	je     8019ba <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  8019af:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019b5:	8b 52 74             	mov    0x74(%edx),%edx
  8019b8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8019ba:	85 db                	test   %ebx,%ebx
  8019bc:	74 0b                	je     8019c9 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019be:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019c4:	8b 52 78             	mov    0x78(%edx),%edx
  8019c7:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	79 16                	jns    8019e3 <ipc_recv+0x5c>
		if (from_env_store)
  8019cd:	85 f6                	test   %esi,%esi
  8019cf:	74 06                	je     8019d7 <ipc_recv+0x50>
			*from_env_store = 0;
  8019d1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019d7:	85 db                	test   %ebx,%ebx
  8019d9:	74 10                	je     8019eb <ipc_recv+0x64>
			*perm_store = 0;
  8019db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019e1:	eb 08                	jmp    8019eb <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8019e8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ee:	5b                   	pop    %ebx
  8019ef:	5e                   	pop    %esi
  8019f0:	5d                   	pop    %ebp
  8019f1:	c3                   	ret    

008019f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	57                   	push   %edi
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
  8019f8:	83 ec 0c             	sub    $0xc,%esp
  8019fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019fe:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801a04:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a06:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a0b:	0f 44 d8             	cmove  %eax,%ebx
  801a0e:	eb 1c                	jmp    801a2c <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a10:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a13:	74 12                	je     801a27 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a15:	50                   	push   %eax
  801a16:	68 a0 21 80 00       	push   $0x8021a0
  801a1b:	6a 42                	push   $0x42
  801a1d:	68 b6 21 80 00       	push   $0x8021b6
  801a22:	e8 cd f5 ff ff       	call   800ff4 <_panic>
		sys_yield();
  801a27:	e8 77 e7 ff ff       	call   8001a3 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a2c:	ff 75 14             	pushl  0x14(%ebp)
  801a2f:	53                   	push   %ebx
  801a30:	56                   	push   %esi
  801a31:	57                   	push   %edi
  801a32:	e8 69 e8 ff ff       	call   8002a0 <sys_ipc_try_send>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	75 d2                	jne    801a10 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a41:	5b                   	pop    %ebx
  801a42:	5e                   	pop    %esi
  801a43:	5f                   	pop    %edi
  801a44:	5d                   	pop    %ebp
  801a45:	c3                   	ret    

00801a46 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a51:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a54:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a5a:	8b 52 50             	mov    0x50(%edx),%edx
  801a5d:	39 ca                	cmp    %ecx,%edx
  801a5f:	75 0d                	jne    801a6e <ipc_find_env+0x28>
			return envs[i].env_id;
  801a61:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a64:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a69:	8b 40 48             	mov    0x48(%eax),%eax
  801a6c:	eb 0f                	jmp    801a7d <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a6e:	83 c0 01             	add    $0x1,%eax
  801a71:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a76:	75 d9                	jne    801a51 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    

00801a7f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a85:	89 d0                	mov    %edx,%eax
  801a87:	c1 e8 16             	shr    $0x16,%eax
  801a8a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a96:	f6 c1 01             	test   $0x1,%cl
  801a99:	74 1d                	je     801ab8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a9b:	c1 ea 0c             	shr    $0xc,%edx
  801a9e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801aa5:	f6 c2 01             	test   $0x1,%dl
  801aa8:	74 0e                	je     801ab8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801aaa:	c1 ea 0c             	shr    $0xc,%edx
  801aad:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ab4:	ef 
  801ab5:	0f b7 c0             	movzwl %ax,%eax
}
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	66 90                	xchg   %ax,%ax
  801abe:	66 90                	xchg   %ax,%ax

00801ac0 <__udivdi3>:
  801ac0:	55                   	push   %ebp
  801ac1:	57                   	push   %edi
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 1c             	sub    $0x1c,%esp
  801ac7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801acb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801acf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ad7:	85 f6                	test   %esi,%esi
  801ad9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801add:	89 ca                	mov    %ecx,%edx
  801adf:	89 f8                	mov    %edi,%eax
  801ae1:	75 3d                	jne    801b20 <__udivdi3+0x60>
  801ae3:	39 cf                	cmp    %ecx,%edi
  801ae5:	0f 87 c5 00 00 00    	ja     801bb0 <__udivdi3+0xf0>
  801aeb:	85 ff                	test   %edi,%edi
  801aed:	89 fd                	mov    %edi,%ebp
  801aef:	75 0b                	jne    801afc <__udivdi3+0x3c>
  801af1:	b8 01 00 00 00       	mov    $0x1,%eax
  801af6:	31 d2                	xor    %edx,%edx
  801af8:	f7 f7                	div    %edi
  801afa:	89 c5                	mov    %eax,%ebp
  801afc:	89 c8                	mov    %ecx,%eax
  801afe:	31 d2                	xor    %edx,%edx
  801b00:	f7 f5                	div    %ebp
  801b02:	89 c1                	mov    %eax,%ecx
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	89 cf                	mov    %ecx,%edi
  801b08:	f7 f5                	div    %ebp
  801b0a:	89 c3                	mov    %eax,%ebx
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	89 fa                	mov    %edi,%edx
  801b10:	83 c4 1c             	add    $0x1c,%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5f                   	pop    %edi
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
  801b18:	90                   	nop
  801b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b20:	39 ce                	cmp    %ecx,%esi
  801b22:	77 74                	ja     801b98 <__udivdi3+0xd8>
  801b24:	0f bd fe             	bsr    %esi,%edi
  801b27:	83 f7 1f             	xor    $0x1f,%edi
  801b2a:	0f 84 98 00 00 00    	je     801bc8 <__udivdi3+0x108>
  801b30:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b35:	89 f9                	mov    %edi,%ecx
  801b37:	89 c5                	mov    %eax,%ebp
  801b39:	29 fb                	sub    %edi,%ebx
  801b3b:	d3 e6                	shl    %cl,%esi
  801b3d:	89 d9                	mov    %ebx,%ecx
  801b3f:	d3 ed                	shr    %cl,%ebp
  801b41:	89 f9                	mov    %edi,%ecx
  801b43:	d3 e0                	shl    %cl,%eax
  801b45:	09 ee                	or     %ebp,%esi
  801b47:	89 d9                	mov    %ebx,%ecx
  801b49:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b4d:	89 d5                	mov    %edx,%ebp
  801b4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b53:	d3 ed                	shr    %cl,%ebp
  801b55:	89 f9                	mov    %edi,%ecx
  801b57:	d3 e2                	shl    %cl,%edx
  801b59:	89 d9                	mov    %ebx,%ecx
  801b5b:	d3 e8                	shr    %cl,%eax
  801b5d:	09 c2                	or     %eax,%edx
  801b5f:	89 d0                	mov    %edx,%eax
  801b61:	89 ea                	mov    %ebp,%edx
  801b63:	f7 f6                	div    %esi
  801b65:	89 d5                	mov    %edx,%ebp
  801b67:	89 c3                	mov    %eax,%ebx
  801b69:	f7 64 24 0c          	mull   0xc(%esp)
  801b6d:	39 d5                	cmp    %edx,%ebp
  801b6f:	72 10                	jb     801b81 <__udivdi3+0xc1>
  801b71:	8b 74 24 08          	mov    0x8(%esp),%esi
  801b75:	89 f9                	mov    %edi,%ecx
  801b77:	d3 e6                	shl    %cl,%esi
  801b79:	39 c6                	cmp    %eax,%esi
  801b7b:	73 07                	jae    801b84 <__udivdi3+0xc4>
  801b7d:	39 d5                	cmp    %edx,%ebp
  801b7f:	75 03                	jne    801b84 <__udivdi3+0xc4>
  801b81:	83 eb 01             	sub    $0x1,%ebx
  801b84:	31 ff                	xor    %edi,%edi
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	89 fa                	mov    %edi,%edx
  801b8a:	83 c4 1c             	add    $0x1c,%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5e                   	pop    %esi
  801b8f:	5f                   	pop    %edi
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    
  801b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801b98:	31 ff                	xor    %edi,%edi
  801b9a:	31 db                	xor    %ebx,%ebx
  801b9c:	89 d8                	mov    %ebx,%eax
  801b9e:	89 fa                	mov    %edi,%edx
  801ba0:	83 c4 1c             	add    $0x1c,%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
  801ba8:	90                   	nop
  801ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	f7 f7                	div    %edi
  801bb4:	31 ff                	xor    %edi,%edi
  801bb6:	89 c3                	mov    %eax,%ebx
  801bb8:	89 d8                	mov    %ebx,%eax
  801bba:	89 fa                	mov    %edi,%edx
  801bbc:	83 c4 1c             	add    $0x1c,%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    
  801bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801bc8:	39 ce                	cmp    %ecx,%esi
  801bca:	72 0c                	jb     801bd8 <__udivdi3+0x118>
  801bcc:	31 db                	xor    %ebx,%ebx
  801bce:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd2:	0f 87 34 ff ff ff    	ja     801b0c <__udivdi3+0x4c>
  801bd8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801bdd:	e9 2a ff ff ff       	jmp    801b0c <__udivdi3+0x4c>
  801be2:	66 90                	xchg   %ax,%ax
  801be4:	66 90                	xchg   %ax,%ax
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	66 90                	xchg   %ax,%ax
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	66 90                	xchg   %ax,%ax
  801bee:	66 90                	xchg   %ax,%ax

00801bf0 <__umoddi3>:
  801bf0:	55                   	push   %ebp
  801bf1:	57                   	push   %edi
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 1c             	sub    $0x1c,%esp
  801bf7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c07:	85 d2                	test   %edx,%edx
  801c09:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c11:	89 f3                	mov    %esi,%ebx
  801c13:	89 3c 24             	mov    %edi,(%esp)
  801c16:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1a:	75 1c                	jne    801c38 <__umoddi3+0x48>
  801c1c:	39 f7                	cmp    %esi,%edi
  801c1e:	76 50                	jbe    801c70 <__umoddi3+0x80>
  801c20:	89 c8                	mov    %ecx,%eax
  801c22:	89 f2                	mov    %esi,%edx
  801c24:	f7 f7                	div    %edi
  801c26:	89 d0                	mov    %edx,%eax
  801c28:	31 d2                	xor    %edx,%edx
  801c2a:	83 c4 1c             	add    $0x1c,%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
  801c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c38:	39 f2                	cmp    %esi,%edx
  801c3a:	89 d0                	mov    %edx,%eax
  801c3c:	77 52                	ja     801c90 <__umoddi3+0xa0>
  801c3e:	0f bd ea             	bsr    %edx,%ebp
  801c41:	83 f5 1f             	xor    $0x1f,%ebp
  801c44:	75 5a                	jne    801ca0 <__umoddi3+0xb0>
  801c46:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c4a:	0f 82 e0 00 00 00    	jb     801d30 <__umoddi3+0x140>
  801c50:	39 0c 24             	cmp    %ecx,(%esp)
  801c53:	0f 86 d7 00 00 00    	jbe    801d30 <__umoddi3+0x140>
  801c59:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c61:	83 c4 1c             	add    $0x1c,%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5f                   	pop    %edi
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    
  801c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c70:	85 ff                	test   %edi,%edi
  801c72:	89 fd                	mov    %edi,%ebp
  801c74:	75 0b                	jne    801c81 <__umoddi3+0x91>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	31 d2                	xor    %edx,%edx
  801c7d:	f7 f7                	div    %edi
  801c7f:	89 c5                	mov    %eax,%ebp
  801c81:	89 f0                	mov    %esi,%eax
  801c83:	31 d2                	xor    %edx,%edx
  801c85:	f7 f5                	div    %ebp
  801c87:	89 c8                	mov    %ecx,%eax
  801c89:	f7 f5                	div    %ebp
  801c8b:	89 d0                	mov    %edx,%eax
  801c8d:	eb 99                	jmp    801c28 <__umoddi3+0x38>
  801c8f:	90                   	nop
  801c90:	89 c8                	mov    %ecx,%eax
  801c92:	89 f2                	mov    %esi,%edx
  801c94:	83 c4 1c             	add    $0x1c,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
  801c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ca0:	8b 34 24             	mov    (%esp),%esi
  801ca3:	bf 20 00 00 00       	mov    $0x20,%edi
  801ca8:	89 e9                	mov    %ebp,%ecx
  801caa:	29 ef                	sub    %ebp,%edi
  801cac:	d3 e0                	shl    %cl,%eax
  801cae:	89 f9                	mov    %edi,%ecx
  801cb0:	89 f2                	mov    %esi,%edx
  801cb2:	d3 ea                	shr    %cl,%edx
  801cb4:	89 e9                	mov    %ebp,%ecx
  801cb6:	09 c2                	or     %eax,%edx
  801cb8:	89 d8                	mov    %ebx,%eax
  801cba:	89 14 24             	mov    %edx,(%esp)
  801cbd:	89 f2                	mov    %esi,%edx
  801cbf:	d3 e2                	shl    %cl,%edx
  801cc1:	89 f9                	mov    %edi,%ecx
  801cc3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cc7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801ccb:	d3 e8                	shr    %cl,%eax
  801ccd:	89 e9                	mov    %ebp,%ecx
  801ccf:	89 c6                	mov    %eax,%esi
  801cd1:	d3 e3                	shl    %cl,%ebx
  801cd3:	89 f9                	mov    %edi,%ecx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	d3 e8                	shr    %cl,%eax
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	09 d8                	or     %ebx,%eax
  801cdd:	89 d3                	mov    %edx,%ebx
  801cdf:	89 f2                	mov    %esi,%edx
  801ce1:	f7 34 24             	divl   (%esp)
  801ce4:	89 d6                	mov    %edx,%esi
  801ce6:	d3 e3                	shl    %cl,%ebx
  801ce8:	f7 64 24 04          	mull   0x4(%esp)
  801cec:	39 d6                	cmp    %edx,%esi
  801cee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cf2:	89 d1                	mov    %edx,%ecx
  801cf4:	89 c3                	mov    %eax,%ebx
  801cf6:	72 08                	jb     801d00 <__umoddi3+0x110>
  801cf8:	75 11                	jne    801d0b <__umoddi3+0x11b>
  801cfa:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801cfe:	73 0b                	jae    801d0b <__umoddi3+0x11b>
  801d00:	2b 44 24 04          	sub    0x4(%esp),%eax
  801d04:	1b 14 24             	sbb    (%esp),%edx
  801d07:	89 d1                	mov    %edx,%ecx
  801d09:	89 c3                	mov    %eax,%ebx
  801d0b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d0f:	29 da                	sub    %ebx,%edx
  801d11:	19 ce                	sbb    %ecx,%esi
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	89 f0                	mov    %esi,%eax
  801d17:	d3 e0                	shl    %cl,%eax
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 ea                	shr    %cl,%edx
  801d1d:	89 e9                	mov    %ebp,%ecx
  801d1f:	d3 ee                	shr    %cl,%esi
  801d21:	09 d0                	or     %edx,%eax
  801d23:	89 f2                	mov    %esi,%edx
  801d25:	83 c4 1c             	add    $0x1c,%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5f                   	pop    %edi
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    
  801d2d:	8d 76 00             	lea    0x0(%esi),%esi
  801d30:	29 f9                	sub    %edi,%ecx
  801d32:	19 d6                	sbb    %edx,%esi
  801d34:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d38:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d3c:	e9 18 ff ff ff       	jmp    801c59 <__umoddi3+0x69>
