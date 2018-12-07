
obj/user/softint.debug:     formato del fichero elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800045:	e8 0a 01 00 00       	call   800154 <sys_getenvid>
	if (id >= 0)
  80004a:	85 c0                	test   %eax,%eax
  80004c:	78 12                	js     800060 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x31>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008a:	e8 f8 03 00 00       	call   800487 <close_all>
	sys_env_destroy(0);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	6a 00                	push   $0x0
  800094:	e8 99 00 00 00       	call   800132 <sys_env_destroy>
}
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	57                   	push   %edi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	83 ec 1c             	sub    $0x1c,%esp
  8000a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000ad:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000b5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000b8:	8b 75 14             	mov    0x14(%ebp),%esi
  8000bb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c1:	74 1d                	je     8000e0 <syscall+0x42>
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	7e 19                	jle    8000e0 <syscall+0x42>
  8000c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	50                   	push   %eax
  8000ce:	52                   	push   %edx
  8000cf:	68 2a 1d 80 00       	push   $0x801d2a
  8000d4:	6a 23                	push   $0x23
  8000d6:	68 47 1d 80 00       	push   $0x801d47
  8000db:	e8 e9 0e 00 00       	call   800fc9 <_panic>

	return ret;
}
  8000e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5f                   	pop    %edi
  8000e6:	5d                   	pop    %ebp
  8000e7:	c3                   	ret    

008000e8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000ee:	6a 00                	push   $0x0
  8000f0:	6a 00                	push   $0x0
  8000f2:	6a 00                	push   $0x0
  8000f4:	ff 75 0c             	pushl  0xc(%ebp)
  8000f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	e8 95 ff ff ff       	call   80009e <syscall>
}
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	c9                   	leave  
  80010d:	c3                   	ret    

0080010e <sys_cgetc>:

int
sys_cgetc(void)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800114:	6a 00                	push   $0x0
  800116:	6a 00                	push   $0x0
  800118:	6a 00                	push   $0x0
  80011a:	6a 00                	push   $0x0
  80011c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800121:	ba 00 00 00 00       	mov    $0x0,%edx
  800126:	b8 01 00 00 00       	mov    $0x1,%eax
  80012b:	e8 6e ff ff ff       	call   80009e <syscall>
}
  800130:	c9                   	leave  
  800131:	c3                   	ret    

00800132 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800138:	6a 00                	push   $0x0
  80013a:	6a 00                	push   $0x0
  80013c:	6a 00                	push   $0x0
  80013e:	6a 00                	push   $0x0
  800140:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800143:	ba 01 00 00 00       	mov    $0x1,%edx
  800148:	b8 03 00 00 00       	mov    $0x3,%eax
  80014d:	e8 4c ff ff ff       	call   80009e <syscall>
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80015a:	6a 00                	push   $0x0
  80015c:	6a 00                	push   $0x0
  80015e:	6a 00                	push   $0x0
  800160:	6a 00                	push   $0x0
  800162:	b9 00 00 00 00       	mov    $0x0,%ecx
  800167:	ba 00 00 00 00       	mov    $0x0,%edx
  80016c:	b8 02 00 00 00       	mov    $0x2,%eax
  800171:	e8 28 ff ff ff       	call   80009e <syscall>
}
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <sys_yield>:

void
sys_yield(void)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80017e:	6a 00                	push   $0x0
  800180:	6a 00                	push   $0x0
  800182:	6a 00                	push   $0x0
  800184:	6a 00                	push   $0x0
  800186:	b9 00 00 00 00       	mov    $0x0,%ecx
  80018b:	ba 00 00 00 00       	mov    $0x0,%edx
  800190:	b8 0b 00 00 00       	mov    $0xb,%eax
  800195:	e8 04 ff ff ff       	call   80009e <syscall>
}
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	c9                   	leave  
  80019e:	c3                   	ret    

0080019f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001a5:	6a 00                	push   $0x0
  8001a7:	6a 00                	push   $0x0
  8001a9:	ff 75 10             	pushl  0x10(%ebp)
  8001ac:	ff 75 0c             	pushl  0xc(%ebp)
  8001af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b2:	ba 01 00 00 00       	mov    $0x1,%edx
  8001b7:	b8 04 00 00 00       	mov    $0x4,%eax
  8001bc:	e8 dd fe ff ff       	call   80009e <syscall>
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001c9:	ff 75 18             	pushl  0x18(%ebp)
  8001cc:	ff 75 14             	pushl  0x14(%ebp)
  8001cf:	ff 75 10             	pushl  0x10(%ebp)
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d8:	ba 01 00 00 00       	mov    $0x1,%edx
  8001dd:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e2:	e8 b7 fe ff ff       	call   80009e <syscall>
}
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    

008001e9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8001ef:	6a 00                	push   $0x0
  8001f1:	6a 00                	push   $0x0
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fb:	ba 01 00 00 00       	mov    $0x1,%edx
  800200:	b8 06 00 00 00       	mov    $0x6,%eax
  800205:	e8 94 fe ff ff       	call   80009e <syscall>
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800212:	6a 00                	push   $0x0
  800214:	6a 00                	push   $0x0
  800216:	6a 00                	push   $0x0
  800218:	ff 75 0c             	pushl  0xc(%ebp)
  80021b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021e:	ba 01 00 00 00       	mov    $0x1,%edx
  800223:	b8 08 00 00 00       	mov    $0x8,%eax
  800228:	e8 71 fe ff ff       	call   80009e <syscall>
}
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800235:	6a 00                	push   $0x0
  800237:	6a 00                	push   $0x0
  800239:	6a 00                	push   $0x0
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800241:	ba 01 00 00 00       	mov    $0x1,%edx
  800246:	b8 09 00 00 00       	mov    $0x9,%eax
  80024b:	e8 4e fe ff ff       	call   80009e <syscall>
}
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800258:	6a 00                	push   $0x0
  80025a:	6a 00                	push   $0x0
  80025c:	6a 00                	push   $0x0
  80025e:	ff 75 0c             	pushl  0xc(%ebp)
  800261:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800264:	ba 01 00 00 00       	mov    $0x1,%edx
  800269:	b8 0a 00 00 00       	mov    $0xa,%eax
  80026e:	e8 2b fe ff ff       	call   80009e <syscall>
}
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80027b:	6a 00                	push   $0x0
  80027d:	ff 75 14             	pushl  0x14(%ebp)
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800289:	ba 00 00 00 00       	mov    $0x0,%edx
  80028e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800293:	e8 06 fe ff ff       	call   80009e <syscall>
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002a0:	6a 00                	push   $0x0
  8002a2:	6a 00                	push   $0x0
  8002a4:	6a 00                	push   $0x0
  8002a6:	6a 00                	push   $0x0
  8002a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ab:	ba 01 00 00 00       	mov    $0x1,%edx
  8002b0:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002b5:	e8 e4 fd ff ff       	call   80009e <syscall>
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	05 00 00 00 30       	add    $0x30000000,%eax
  8002c7:	c1 e8 0c             	shr    $0xc,%eax
}
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    

008002cc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 e5 ff ff ff       	call   8002bc <fd2num>
  8002d7:	83 c4 04             	add    $0x4,%esp
  8002da:	c1 e0 0c             	shl    $0xc,%eax
  8002dd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ea:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8002ef:	89 c2                	mov    %eax,%edx
  8002f1:	c1 ea 16             	shr    $0x16,%edx
  8002f4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8002fb:	f6 c2 01             	test   $0x1,%dl
  8002fe:	74 11                	je     800311 <fd_alloc+0x2d>
  800300:	89 c2                	mov    %eax,%edx
  800302:	c1 ea 0c             	shr    $0xc,%edx
  800305:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80030c:	f6 c2 01             	test   $0x1,%dl
  80030f:	75 09                	jne    80031a <fd_alloc+0x36>
			*fd_store = fd;
  800311:	89 01                	mov    %eax,(%ecx)
			return 0;
  800313:	b8 00 00 00 00       	mov    $0x0,%eax
  800318:	eb 17                	jmp    800331 <fd_alloc+0x4d>
  80031a:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80031f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800324:	75 c9                	jne    8002ef <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800326:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80032c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800331:	5d                   	pop    %ebp
  800332:	c3                   	ret    

00800333 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800339:	83 f8 1f             	cmp    $0x1f,%eax
  80033c:	77 36                	ja     800374 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80033e:	c1 e0 0c             	shl    $0xc,%eax
  800341:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800346:	89 c2                	mov    %eax,%edx
  800348:	c1 ea 16             	shr    $0x16,%edx
  80034b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800352:	f6 c2 01             	test   $0x1,%dl
  800355:	74 24                	je     80037b <fd_lookup+0x48>
  800357:	89 c2                	mov    %eax,%edx
  800359:	c1 ea 0c             	shr    $0xc,%edx
  80035c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800363:	f6 c2 01             	test   $0x1,%dl
  800366:	74 1a                	je     800382 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036b:	89 02                	mov    %eax,(%edx)
	return 0;
  80036d:	b8 00 00 00 00       	mov    $0x0,%eax
  800372:	eb 13                	jmp    800387 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800374:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800379:	eb 0c                	jmp    800387 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80037b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800380:	eb 05                	jmp    800387 <fd_lookup+0x54>
  800382:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800392:	ba d4 1d 80 00       	mov    $0x801dd4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800397:	eb 13                	jmp    8003ac <dev_lookup+0x23>
  800399:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80039c:	39 08                	cmp    %ecx,(%eax)
  80039e:	75 0c                	jne    8003ac <dev_lookup+0x23>
			*dev = devtab[i];
  8003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003aa:	eb 2e                	jmp    8003da <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003ac:	8b 02                	mov    (%edx),%eax
  8003ae:	85 c0                	test   %eax,%eax
  8003b0:	75 e7                	jne    800399 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8003b7:	8b 40 48             	mov    0x48(%eax),%eax
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	51                   	push   %ecx
  8003be:	50                   	push   %eax
  8003bf:	68 58 1d 80 00       	push   $0x801d58
  8003c4:	e8 d9 0c 00 00       	call   8010a2 <cprintf>
	*dev = 0;
  8003c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    

008003dc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	56                   	push   %esi
  8003e0:	53                   	push   %ebx
  8003e1:	83 ec 10             	sub    $0x10,%esp
  8003e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8003ea:	56                   	push   %esi
  8003eb:	e8 cc fe ff ff       	call   8002bc <fd2num>
  8003f0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8003f3:	89 14 24             	mov    %edx,(%esp)
  8003f6:	50                   	push   %eax
  8003f7:	e8 37 ff ff ff       	call   800333 <fd_lookup>
  8003fc:	83 c4 08             	add    $0x8,%esp
  8003ff:	85 c0                	test   %eax,%eax
  800401:	78 05                	js     800408 <fd_close+0x2c>
	    || fd != fd2)
  800403:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800406:	74 0c                	je     800414 <fd_close+0x38>
		return (must_exist ? r : 0);
  800408:	84 db                	test   %bl,%bl
  80040a:	ba 00 00 00 00       	mov    $0x0,%edx
  80040f:	0f 44 c2             	cmove  %edx,%eax
  800412:	eb 41                	jmp    800455 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80041a:	50                   	push   %eax
  80041b:	ff 36                	pushl  (%esi)
  80041d:	e8 67 ff ff ff       	call   800389 <dev_lookup>
  800422:	89 c3                	mov    %eax,%ebx
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	85 c0                	test   %eax,%eax
  800429:	78 1a                	js     800445 <fd_close+0x69>
		if (dev->dev_close)
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800431:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800436:	85 c0                	test   %eax,%eax
  800438:	74 0b                	je     800445 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  80043a:	83 ec 0c             	sub    $0xc,%esp
  80043d:	56                   	push   %esi
  80043e:	ff d0                	call   *%eax
  800440:	89 c3                	mov    %eax,%ebx
  800442:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	56                   	push   %esi
  800449:	6a 00                	push   $0x0
  80044b:	e8 99 fd ff ff       	call   8001e9 <sys_page_unmap>
	return r;
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	89 d8                	mov    %ebx,%eax
}
  800455:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800458:	5b                   	pop    %ebx
  800459:	5e                   	pop    %esi
  80045a:	5d                   	pop    %ebp
  80045b:	c3                   	ret    

0080045c <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800465:	50                   	push   %eax
  800466:	ff 75 08             	pushl  0x8(%ebp)
  800469:	e8 c5 fe ff ff       	call   800333 <fd_lookup>
  80046e:	83 c4 08             	add    $0x8,%esp
  800471:	85 c0                	test   %eax,%eax
  800473:	78 10                	js     800485 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800475:	83 ec 08             	sub    $0x8,%esp
  800478:	6a 01                	push   $0x1
  80047a:	ff 75 f4             	pushl  -0xc(%ebp)
  80047d:	e8 5a ff ff ff       	call   8003dc <fd_close>
  800482:	83 c4 10             	add    $0x10,%esp
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <close_all>:

void
close_all(void)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	53                   	push   %ebx
  80048b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80048e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	53                   	push   %ebx
  800497:	e8 c0 ff ff ff       	call   80045c <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80049c:	83 c3 01             	add    $0x1,%ebx
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	83 fb 20             	cmp    $0x20,%ebx
  8004a5:	75 ec                	jne    800493 <close_all+0xc>
		close(i);
}
  8004a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004aa:	c9                   	leave  
  8004ab:	c3                   	ret    

008004ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	57                   	push   %edi
  8004b0:	56                   	push   %esi
  8004b1:	53                   	push   %ebx
  8004b2:	83 ec 2c             	sub    $0x2c,%esp
  8004b5:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004bb:	50                   	push   %eax
  8004bc:	ff 75 08             	pushl  0x8(%ebp)
  8004bf:	e8 6f fe ff ff       	call   800333 <fd_lookup>
  8004c4:	83 c4 08             	add    $0x8,%esp
  8004c7:	85 c0                	test   %eax,%eax
  8004c9:	0f 88 c1 00 00 00    	js     800590 <dup+0xe4>
		return r;
	close(newfdnum);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	56                   	push   %esi
  8004d3:	e8 84 ff ff ff       	call   80045c <close>

	newfd = INDEX2FD(newfdnum);
  8004d8:	89 f3                	mov    %esi,%ebx
  8004da:	c1 e3 0c             	shl    $0xc,%ebx
  8004dd:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8004e3:	83 c4 04             	add    $0x4,%esp
  8004e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004e9:	e8 de fd ff ff       	call   8002cc <fd2data>
  8004ee:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8004f0:	89 1c 24             	mov    %ebx,(%esp)
  8004f3:	e8 d4 fd ff ff       	call   8002cc <fd2data>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8004fe:	89 f8                	mov    %edi,%eax
  800500:	c1 e8 16             	shr    $0x16,%eax
  800503:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80050a:	a8 01                	test   $0x1,%al
  80050c:	74 37                	je     800545 <dup+0x99>
  80050e:	89 f8                	mov    %edi,%eax
  800510:	c1 e8 0c             	shr    $0xc,%eax
  800513:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80051a:	f6 c2 01             	test   $0x1,%dl
  80051d:	74 26                	je     800545 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80051f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800526:	83 ec 0c             	sub    $0xc,%esp
  800529:	25 07 0e 00 00       	and    $0xe07,%eax
  80052e:	50                   	push   %eax
  80052f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800532:	6a 00                	push   $0x0
  800534:	57                   	push   %edi
  800535:	6a 00                	push   $0x0
  800537:	e8 87 fc ff ff       	call   8001c3 <sys_page_map>
  80053c:	89 c7                	mov    %eax,%edi
  80053e:	83 c4 20             	add    $0x20,%esp
  800541:	85 c0                	test   %eax,%eax
  800543:	78 2e                	js     800573 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800545:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800548:	89 d0                	mov    %edx,%eax
  80054a:	c1 e8 0c             	shr    $0xc,%eax
  80054d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	25 07 0e 00 00       	and    $0xe07,%eax
  80055c:	50                   	push   %eax
  80055d:	53                   	push   %ebx
  80055e:	6a 00                	push   $0x0
  800560:	52                   	push   %edx
  800561:	6a 00                	push   $0x0
  800563:	e8 5b fc ff ff       	call   8001c3 <sys_page_map>
  800568:	89 c7                	mov    %eax,%edi
  80056a:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80056d:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80056f:	85 ff                	test   %edi,%edi
  800571:	79 1d                	jns    800590 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	6a 00                	push   $0x0
  800579:	e8 6b fc ff ff       	call   8001e9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80057e:	83 c4 08             	add    $0x8,%esp
  800581:	ff 75 d4             	pushl  -0x2c(%ebp)
  800584:	6a 00                	push   $0x0
  800586:	e8 5e fc ff ff       	call   8001e9 <sys_page_unmap>
	return r;
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 f8                	mov    %edi,%eax
}
  800590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800593:	5b                   	pop    %ebx
  800594:	5e                   	pop    %esi
  800595:	5f                   	pop    %edi
  800596:	5d                   	pop    %ebp
  800597:	c3                   	ret    

00800598 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	53                   	push   %ebx
  80059c:	83 ec 14             	sub    $0x14,%esp
  80059f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005a5:	50                   	push   %eax
  8005a6:	53                   	push   %ebx
  8005a7:	e8 87 fd ff ff       	call   800333 <fd_lookup>
  8005ac:	83 c4 08             	add    $0x8,%esp
  8005af:	89 c2                	mov    %eax,%edx
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	78 6d                	js     800622 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005bb:	50                   	push   %eax
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	ff 30                	pushl  (%eax)
  8005c1:	e8 c3 fd ff ff       	call   800389 <dev_lookup>
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	85 c0                	test   %eax,%eax
  8005cb:	78 4c                	js     800619 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005d0:	8b 42 08             	mov    0x8(%edx),%eax
  8005d3:	83 e0 03             	and    $0x3,%eax
  8005d6:	83 f8 01             	cmp    $0x1,%eax
  8005d9:	75 21                	jne    8005fc <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8005db:	a1 04 40 80 00       	mov    0x804004,%eax
  8005e0:	8b 40 48             	mov    0x48(%eax),%eax
  8005e3:	83 ec 04             	sub    $0x4,%esp
  8005e6:	53                   	push   %ebx
  8005e7:	50                   	push   %eax
  8005e8:	68 99 1d 80 00       	push   $0x801d99
  8005ed:	e8 b0 0a 00 00       	call   8010a2 <cprintf>
		return -E_INVAL;
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8005fa:	eb 26                	jmp    800622 <read+0x8a>
	}
	if (!dev->dev_read)
  8005fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ff:	8b 40 08             	mov    0x8(%eax),%eax
  800602:	85 c0                	test   %eax,%eax
  800604:	74 17                	je     80061d <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	ff 75 10             	pushl  0x10(%ebp)
  80060c:	ff 75 0c             	pushl  0xc(%ebp)
  80060f:	52                   	push   %edx
  800610:	ff d0                	call   *%eax
  800612:	89 c2                	mov    %eax,%edx
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	eb 09                	jmp    800622 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800619:	89 c2                	mov    %eax,%edx
  80061b:	eb 05                	jmp    800622 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80061d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800622:	89 d0                	mov    %edx,%eax
  800624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800627:	c9                   	leave  
  800628:	c3                   	ret    

00800629 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	57                   	push   %edi
  80062d:	56                   	push   %esi
  80062e:	53                   	push   %ebx
  80062f:	83 ec 0c             	sub    $0xc,%esp
  800632:	8b 7d 08             	mov    0x8(%ebp),%edi
  800635:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800638:	bb 00 00 00 00       	mov    $0x0,%ebx
  80063d:	eb 21                	jmp    800660 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80063f:	83 ec 04             	sub    $0x4,%esp
  800642:	89 f0                	mov    %esi,%eax
  800644:	29 d8                	sub    %ebx,%eax
  800646:	50                   	push   %eax
  800647:	89 d8                	mov    %ebx,%eax
  800649:	03 45 0c             	add    0xc(%ebp),%eax
  80064c:	50                   	push   %eax
  80064d:	57                   	push   %edi
  80064e:	e8 45 ff ff ff       	call   800598 <read>
		if (m < 0)
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	85 c0                	test   %eax,%eax
  800658:	78 10                	js     80066a <readn+0x41>
			return m;
		if (m == 0)
  80065a:	85 c0                	test   %eax,%eax
  80065c:	74 0a                	je     800668 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80065e:	01 c3                	add    %eax,%ebx
  800660:	39 f3                	cmp    %esi,%ebx
  800662:	72 db                	jb     80063f <readn+0x16>
  800664:	89 d8                	mov    %ebx,%eax
  800666:	eb 02                	jmp    80066a <readn+0x41>
  800668:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80066a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066d:	5b                   	pop    %ebx
  80066e:	5e                   	pop    %esi
  80066f:	5f                   	pop    %edi
  800670:	5d                   	pop    %ebp
  800671:	c3                   	ret    

00800672 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	53                   	push   %ebx
  800676:	83 ec 14             	sub    $0x14,%esp
  800679:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80067c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80067f:	50                   	push   %eax
  800680:	53                   	push   %ebx
  800681:	e8 ad fc ff ff       	call   800333 <fd_lookup>
  800686:	83 c4 08             	add    $0x8,%esp
  800689:	89 c2                	mov    %eax,%edx
  80068b:	85 c0                	test   %eax,%eax
  80068d:	78 68                	js     8006f7 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800699:	ff 30                	pushl  (%eax)
  80069b:	e8 e9 fc ff ff       	call   800389 <dev_lookup>
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	85 c0                	test   %eax,%eax
  8006a5:	78 47                	js     8006ee <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006ae:	75 21                	jne    8006d1 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b0:	a1 04 40 80 00       	mov    0x804004,%eax
  8006b5:	8b 40 48             	mov    0x48(%eax),%eax
  8006b8:	83 ec 04             	sub    $0x4,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	50                   	push   %eax
  8006bd:	68 b5 1d 80 00       	push   $0x801db5
  8006c2:	e8 db 09 00 00       	call   8010a2 <cprintf>
		return -E_INVAL;
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006cf:	eb 26                	jmp    8006f7 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8006d7:	85 d2                	test   %edx,%edx
  8006d9:	74 17                	je     8006f2 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	ff 75 10             	pushl  0x10(%ebp)
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	50                   	push   %eax
  8006e5:	ff d2                	call   *%edx
  8006e7:	89 c2                	mov    %eax,%edx
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb 09                	jmp    8006f7 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ee:	89 c2                	mov    %eax,%edx
  8006f0:	eb 05                	jmp    8006f7 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8006f2:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8006f7:	89 d0                	mov    %edx,%eax
  8006f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fc:	c9                   	leave  
  8006fd:	c3                   	ret    

008006fe <seek>:

int
seek(int fdnum, off_t offset)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800704:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800707:	50                   	push   %eax
  800708:	ff 75 08             	pushl  0x8(%ebp)
  80070b:	e8 23 fc ff ff       	call   800333 <fd_lookup>
  800710:	83 c4 08             	add    $0x8,%esp
  800713:	85 c0                	test   %eax,%eax
  800715:	78 0e                	js     800725 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	53                   	push   %ebx
  80072b:	83 ec 14             	sub    $0x14,%esp
  80072e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800731:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800734:	50                   	push   %eax
  800735:	53                   	push   %ebx
  800736:	e8 f8 fb ff ff       	call   800333 <fd_lookup>
  80073b:	83 c4 08             	add    $0x8,%esp
  80073e:	89 c2                	mov    %eax,%edx
  800740:	85 c0                	test   %eax,%eax
  800742:	78 65                	js     8007a9 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80074a:	50                   	push   %eax
  80074b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074e:	ff 30                	pushl  (%eax)
  800750:	e8 34 fc ff ff       	call   800389 <dev_lookup>
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	85 c0                	test   %eax,%eax
  80075a:	78 44                	js     8007a0 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800763:	75 21                	jne    800786 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800765:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80076a:	8b 40 48             	mov    0x48(%eax),%eax
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	53                   	push   %ebx
  800771:	50                   	push   %eax
  800772:	68 78 1d 80 00       	push   $0x801d78
  800777:	e8 26 09 00 00       	call   8010a2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80077c:	83 c4 10             	add    $0x10,%esp
  80077f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800784:	eb 23                	jmp    8007a9 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  800786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800789:	8b 52 18             	mov    0x18(%edx),%edx
  80078c:	85 d2                	test   %edx,%edx
  80078e:	74 14                	je     8007a4 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 0c             	pushl  0xc(%ebp)
  800796:	50                   	push   %eax
  800797:	ff d2                	call   *%edx
  800799:	89 c2                	mov    %eax,%edx
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	eb 09                	jmp    8007a9 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007a0:	89 c2                	mov    %eax,%edx
  8007a2:	eb 05                	jmp    8007a9 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007a4:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007a9:	89 d0                	mov    %edx,%eax
  8007ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	53                   	push   %ebx
  8007b4:	83 ec 14             	sub    $0x14,%esp
  8007b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007bd:	50                   	push   %eax
  8007be:	ff 75 08             	pushl  0x8(%ebp)
  8007c1:	e8 6d fb ff ff       	call   800333 <fd_lookup>
  8007c6:	83 c4 08             	add    $0x8,%esp
  8007c9:	89 c2                	mov    %eax,%edx
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	78 58                	js     800827 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d5:	50                   	push   %eax
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	ff 30                	pushl  (%eax)
  8007db:	e8 a9 fb ff ff       	call   800389 <dev_lookup>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	78 37                	js     80081e <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ea:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8007ee:	74 32                	je     800822 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8007f0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8007f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8007fa:	00 00 00 
	stat->st_isdir = 0;
  8007fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800804:	00 00 00 
	stat->st_dev = dev;
  800807:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	ff 75 f0             	pushl  -0x10(%ebp)
  800814:	ff 50 14             	call   *0x14(%eax)
  800817:	89 c2                	mov    %eax,%edx
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	eb 09                	jmp    800827 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80081e:	89 c2                	mov    %eax,%edx
  800820:	eb 05                	jmp    800827 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800822:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800827:	89 d0                	mov    %edx,%eax
  800829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	56                   	push   %esi
  800832:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	6a 00                	push   $0x0
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 06 02 00 00       	call   800a46 <open>
  800840:	89 c3                	mov    %eax,%ebx
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	85 c0                	test   %eax,%eax
  800847:	78 1b                	js     800864 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	50                   	push   %eax
  800850:	e8 5b ff ff ff       	call   8007b0 <fstat>
  800855:	89 c6                	mov    %eax,%esi
	close(fd);
  800857:	89 1c 24             	mov    %ebx,(%esp)
  80085a:	e8 fd fb ff ff       	call   80045c <close>
	return r;
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	89 f0                	mov    %esi,%eax
}
  800864:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800867:	5b                   	pop    %ebx
  800868:	5e                   	pop    %esi
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	56                   	push   %esi
  80086f:	53                   	push   %ebx
  800870:	89 c6                	mov    %eax,%esi
  800872:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800874:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80087b:	75 12                	jne    80088f <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80087d:	83 ec 0c             	sub    $0xc,%esp
  800880:	6a 01                	push   $0x1
  800882:	e8 94 11 00 00       	call   801a1b <ipc_find_env>
  800887:	a3 00 40 80 00       	mov    %eax,0x804000
  80088c:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80088f:	6a 07                	push   $0x7
  800891:	68 00 50 80 00       	push   $0x805000
  800896:	56                   	push   %esi
  800897:	ff 35 00 40 80 00    	pushl  0x804000
  80089d:	e8 25 11 00 00       	call   8019c7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008a2:	83 c4 0c             	add    $0xc,%esp
  8008a5:	6a 00                	push   $0x0
  8008a7:	53                   	push   %ebx
  8008a8:	6a 00                	push   $0x0
  8008aa:	e8 ad 10 00 00       	call   80195c <ipc_recv>
}
  8008af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b2:	5b                   	pop    %ebx
  8008b3:	5e                   	pop    %esi
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8008c2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8008d9:	e8 8d ff ff ff       	call   80086b <fsipc>
}
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8008ec:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8008f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8008fb:	e8 6b ff ff ff       	call   80086b <fsipc>
}
  800900:	c9                   	leave  
  800901:	c3                   	ret    

00800902 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	53                   	push   %ebx
  800906:	83 ec 04             	sub    $0x4,%esp
  800909:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 40 0c             	mov    0xc(%eax),%eax
  800912:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800917:	ba 00 00 00 00       	mov    $0x0,%edx
  80091c:	b8 05 00 00 00       	mov    $0x5,%eax
  800921:	e8 45 ff ff ff       	call   80086b <fsipc>
  800926:	85 c0                	test   %eax,%eax
  800928:	78 2c                	js     800956 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	68 00 50 80 00       	push   $0x805000
  800932:	53                   	push   %ebx
  800933:	e8 dc 0c 00 00       	call   801614 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800938:	a1 80 50 80 00       	mov    0x805080,%eax
  80093d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800943:	a1 84 50 80 00       	mov    0x805084,%eax
  800948:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	8b 55 0c             	mov    0xc(%ebp),%edx
  800964:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800967:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096a:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80096d:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  800973:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800978:	76 22                	jbe    80099c <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  80097a:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  800981:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  800984:	83 ec 04             	sub    $0x4,%esp
  800987:	68 f8 0f 00 00       	push   $0xff8
  80098c:	52                   	push   %edx
  80098d:	68 08 50 80 00       	push   $0x805008
  800992:	e8 10 0e 00 00       	call   8017a7 <memmove>
  800997:	83 c4 10             	add    $0x10,%esp
  80099a:	eb 17                	jmp    8009b3 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80099c:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009a1:	83 ec 04             	sub    $0x4,%esp
  8009a4:	50                   	push   %eax
  8009a5:	52                   	push   %edx
  8009a6:	68 08 50 80 00       	push   $0x805008
  8009ab:	e8 f7 0d 00 00       	call   8017a7 <memmove>
  8009b0:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b8:	b8 04 00 00 00       	mov    $0x4,%eax
  8009bd:	e8 a9 fe ff ff       	call   80086b <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8009d2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8009d7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8009dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8009e7:	e8 7f fe ff ff       	call   80086b <fsipc>
  8009ec:	89 c3                	mov    %eax,%ebx
  8009ee:	85 c0                	test   %eax,%eax
  8009f0:	78 4b                	js     800a3d <devfile_read+0x79>
		return r;
	assert(r <= n);
  8009f2:	39 c6                	cmp    %eax,%esi
  8009f4:	73 16                	jae    800a0c <devfile_read+0x48>
  8009f6:	68 e4 1d 80 00       	push   $0x801de4
  8009fb:	68 eb 1d 80 00       	push   $0x801deb
  800a00:	6a 7c                	push   $0x7c
  800a02:	68 00 1e 80 00       	push   $0x801e00
  800a07:	e8 bd 05 00 00       	call   800fc9 <_panic>
	assert(r <= PGSIZE);
  800a0c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a11:	7e 16                	jle    800a29 <devfile_read+0x65>
  800a13:	68 0b 1e 80 00       	push   $0x801e0b
  800a18:	68 eb 1d 80 00       	push   $0x801deb
  800a1d:	6a 7d                	push   $0x7d
  800a1f:	68 00 1e 80 00       	push   $0x801e00
  800a24:	e8 a0 05 00 00       	call   800fc9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	68 00 50 80 00       	push   $0x805000
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	e8 6d 0d 00 00       	call   8017a7 <memmove>
	return r;
  800a3a:	83 c4 10             	add    $0x10,%esp
}
  800a3d:	89 d8                	mov    %ebx,%eax
  800a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	53                   	push   %ebx
  800a4a:	83 ec 20             	sub    $0x20,%esp
  800a4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a50:	53                   	push   %ebx
  800a51:	e8 85 0b 00 00       	call   8015db <strlen>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a5e:	7f 67                	jg     800ac7 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a60:	83 ec 0c             	sub    $0xc,%esp
  800a63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a66:	50                   	push   %eax
  800a67:	e8 78 f8 ff ff       	call   8002e4 <fd_alloc>
  800a6c:	83 c4 10             	add    $0x10,%esp
		return r;
  800a6f:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a71:	85 c0                	test   %eax,%eax
  800a73:	78 57                	js     800acc <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	53                   	push   %ebx
  800a79:	68 00 50 80 00       	push   $0x805000
  800a7e:	e8 91 0b 00 00       	call   801614 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800a93:	e8 d3 fd ff ff       	call   80086b <fsipc>
  800a98:	89 c3                	mov    %eax,%ebx
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	79 14                	jns    800ab5 <open+0x6f>
		fd_close(fd, 0);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	6a 00                	push   $0x0
  800aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa9:	e8 2e f9 ff ff       	call   8003dc <fd_close>
		return r;
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 da                	mov    %ebx,%edx
  800ab3:	eb 17                	jmp    800acc <open+0x86>
	}

	return fd2num(fd);
  800ab5:	83 ec 0c             	sub    $0xc,%esp
  800ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  800abb:	e8 fc f7 ff ff       	call   8002bc <fd2num>
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	eb 05                	jmp    800acc <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800ac7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800acc:	89 d0                	mov    %edx,%eax
  800ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	b8 08 00 00 00       	mov    $0x8,%eax
  800ae3:	e8 83 fd ff ff       	call   80086b <fsipc>
}
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	56                   	push   %esi
  800aee:	53                   	push   %ebx
  800aef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800af2:	83 ec 0c             	sub    $0xc,%esp
  800af5:	ff 75 08             	pushl  0x8(%ebp)
  800af8:	e8 cf f7 ff ff       	call   8002cc <fd2data>
  800afd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800aff:	83 c4 08             	add    $0x8,%esp
  800b02:	68 17 1e 80 00       	push   $0x801e17
  800b07:	53                   	push   %ebx
  800b08:	e8 07 0b 00 00       	call   801614 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b0d:	8b 46 04             	mov    0x4(%esi),%eax
  800b10:	2b 06                	sub    (%esi),%eax
  800b12:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b18:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b1f:	00 00 00 
	stat->st_dev = &devpipe;
  800b22:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b29:	30 80 00 
	return 0;
}
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	53                   	push   %ebx
  800b3c:	83 ec 0c             	sub    $0xc,%esp
  800b3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b42:	53                   	push   %ebx
  800b43:	6a 00                	push   $0x0
  800b45:	e8 9f f6 ff ff       	call   8001e9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b4a:	89 1c 24             	mov    %ebx,(%esp)
  800b4d:	e8 7a f7 ff ff       	call   8002cc <fd2data>
  800b52:	83 c4 08             	add    $0x8,%esp
  800b55:	50                   	push   %eax
  800b56:	6a 00                	push   $0x0
  800b58:	e8 8c f6 ff ff       	call   8001e9 <sys_page_unmap>
}
  800b5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	57                   	push   %edi
  800b66:	56                   	push   %esi
  800b67:	53                   	push   %ebx
  800b68:	83 ec 1c             	sub    $0x1c,%esp
  800b6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b6e:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b70:	a1 04 40 80 00       	mov    0x804004,%eax
  800b75:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800b78:	83 ec 0c             	sub    $0xc,%esp
  800b7b:	ff 75 e0             	pushl  -0x20(%ebp)
  800b7e:	e8 d1 0e 00 00       	call   801a54 <pageref>
  800b83:	89 c3                	mov    %eax,%ebx
  800b85:	89 3c 24             	mov    %edi,(%esp)
  800b88:	e8 c7 0e 00 00       	call   801a54 <pageref>
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	39 c3                	cmp    %eax,%ebx
  800b92:	0f 94 c1             	sete   %cl
  800b95:	0f b6 c9             	movzbl %cl,%ecx
  800b98:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800b9b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ba1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800ba4:	39 ce                	cmp    %ecx,%esi
  800ba6:	74 1b                	je     800bc3 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800ba8:	39 c3                	cmp    %eax,%ebx
  800baa:	75 c4                	jne    800b70 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bac:	8b 42 58             	mov    0x58(%edx),%eax
  800baf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb2:	50                   	push   %eax
  800bb3:	56                   	push   %esi
  800bb4:	68 1e 1e 80 00       	push   $0x801e1e
  800bb9:	e8 e4 04 00 00       	call   8010a2 <cprintf>
  800bbe:	83 c4 10             	add    $0x10,%esp
  800bc1:	eb ad                	jmp    800b70 <_pipeisclosed+0xe>
	}
}
  800bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 28             	sub    $0x28,%esp
  800bd7:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800bda:	56                   	push   %esi
  800bdb:	e8 ec f6 ff ff       	call   8002cc <fd2data>
  800be0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	bf 00 00 00 00       	mov    $0x0,%edi
  800bea:	eb 4b                	jmp    800c37 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800bec:	89 da                	mov    %ebx,%edx
  800bee:	89 f0                	mov    %esi,%eax
  800bf0:	e8 6d ff ff ff       	call   800b62 <_pipeisclosed>
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	75 48                	jne    800c41 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800bf9:	e8 7a f5 ff ff       	call   800178 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800bfe:	8b 43 04             	mov    0x4(%ebx),%eax
  800c01:	8b 0b                	mov    (%ebx),%ecx
  800c03:	8d 51 20             	lea    0x20(%ecx),%edx
  800c06:	39 d0                	cmp    %edx,%eax
  800c08:	73 e2                	jae    800bec <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c11:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c14:	89 c2                	mov    %eax,%edx
  800c16:	c1 fa 1f             	sar    $0x1f,%edx
  800c19:	89 d1                	mov    %edx,%ecx
  800c1b:	c1 e9 1b             	shr    $0x1b,%ecx
  800c1e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c21:	83 e2 1f             	and    $0x1f,%edx
  800c24:	29 ca                	sub    %ecx,%edx
  800c26:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c2a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c2e:	83 c0 01             	add    $0x1,%eax
  800c31:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c34:	83 c7 01             	add    $0x1,%edi
  800c37:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c3a:	75 c2                	jne    800bfe <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3f:	eb 05                	jmp    800c46 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c41:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c49:	5b                   	pop    %ebx
  800c4a:	5e                   	pop    %esi
  800c4b:	5f                   	pop    %edi
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	83 ec 18             	sub    $0x18,%esp
  800c57:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c5a:	57                   	push   %edi
  800c5b:	e8 6c f6 ff ff       	call   8002cc <fd2data>
  800c60:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6a:	eb 3d                	jmp    800ca9 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c6c:	85 db                	test   %ebx,%ebx
  800c6e:	74 04                	je     800c74 <devpipe_read+0x26>
				return i;
  800c70:	89 d8                	mov    %ebx,%eax
  800c72:	eb 44                	jmp    800cb8 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c74:	89 f2                	mov    %esi,%edx
  800c76:	89 f8                	mov    %edi,%eax
  800c78:	e8 e5 fe ff ff       	call   800b62 <_pipeisclosed>
  800c7d:	85 c0                	test   %eax,%eax
  800c7f:	75 32                	jne    800cb3 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800c81:	e8 f2 f4 ff ff       	call   800178 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800c86:	8b 06                	mov    (%esi),%eax
  800c88:	3b 46 04             	cmp    0x4(%esi),%eax
  800c8b:	74 df                	je     800c6c <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800c8d:	99                   	cltd   
  800c8e:	c1 ea 1b             	shr    $0x1b,%edx
  800c91:	01 d0                	add    %edx,%eax
  800c93:	83 e0 1f             	and    $0x1f,%eax
  800c96:	29 d0                	sub    %edx,%eax
  800c98:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800ca3:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ca6:	83 c3 01             	add    $0x1,%ebx
  800ca9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cac:	75 d8                	jne    800c86 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cae:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb1:	eb 05                	jmp    800cb8 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
  800cc5:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800cc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ccb:	50                   	push   %eax
  800ccc:	e8 13 f6 ff ff       	call   8002e4 <fd_alloc>
  800cd1:	83 c4 10             	add    $0x10,%esp
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	0f 88 2c 01 00 00    	js     800e0a <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800cde:	83 ec 04             	sub    $0x4,%esp
  800ce1:	68 07 04 00 00       	push   $0x407
  800ce6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce9:	6a 00                	push   $0x0
  800ceb:	e8 af f4 ff ff       	call   80019f <sys_page_alloc>
  800cf0:	83 c4 10             	add    $0x10,%esp
  800cf3:	89 c2                	mov    %eax,%edx
  800cf5:	85 c0                	test   %eax,%eax
  800cf7:	0f 88 0d 01 00 00    	js     800e0a <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d03:	50                   	push   %eax
  800d04:	e8 db f5 ff ff       	call   8002e4 <fd_alloc>
  800d09:	89 c3                	mov    %eax,%ebx
  800d0b:	83 c4 10             	add    $0x10,%esp
  800d0e:	85 c0                	test   %eax,%eax
  800d10:	0f 88 e2 00 00 00    	js     800df8 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d16:	83 ec 04             	sub    $0x4,%esp
  800d19:	68 07 04 00 00       	push   $0x407
  800d1e:	ff 75 f0             	pushl  -0x10(%ebp)
  800d21:	6a 00                	push   $0x0
  800d23:	e8 77 f4 ff ff       	call   80019f <sys_page_alloc>
  800d28:	89 c3                	mov    %eax,%ebx
  800d2a:	83 c4 10             	add    $0x10,%esp
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	0f 88 c3 00 00 00    	js     800df8 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d35:	83 ec 0c             	sub    $0xc,%esp
  800d38:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3b:	e8 8c f5 ff ff       	call   8002cc <fd2data>
  800d40:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d42:	83 c4 0c             	add    $0xc,%esp
  800d45:	68 07 04 00 00       	push   $0x407
  800d4a:	50                   	push   %eax
  800d4b:	6a 00                	push   $0x0
  800d4d:	e8 4d f4 ff ff       	call   80019f <sys_page_alloc>
  800d52:	89 c3                	mov    %eax,%ebx
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	85 c0                	test   %eax,%eax
  800d59:	0f 88 89 00 00 00    	js     800de8 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d5f:	83 ec 0c             	sub    $0xc,%esp
  800d62:	ff 75 f0             	pushl  -0x10(%ebp)
  800d65:	e8 62 f5 ff ff       	call   8002cc <fd2data>
  800d6a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d71:	50                   	push   %eax
  800d72:	6a 00                	push   $0x0
  800d74:	56                   	push   %esi
  800d75:	6a 00                	push   $0x0
  800d77:	e8 47 f4 ff ff       	call   8001c3 <sys_page_map>
  800d7c:	89 c3                	mov    %eax,%ebx
  800d7e:	83 c4 20             	add    $0x20,%esp
  800d81:	85 c0                	test   %eax,%eax
  800d83:	78 55                	js     800dda <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800d85:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800d9a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	ff 75 f4             	pushl  -0xc(%ebp)
  800db5:	e8 02 f5 ff ff       	call   8002bc <fd2num>
  800dba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dbf:	83 c4 04             	add    $0x4,%esp
  800dc2:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc5:	e8 f2 f4 ff ff       	call   8002bc <fd2num>
  800dca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dcd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800dd0:	83 c4 10             	add    $0x10,%esp
  800dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd8:	eb 30                	jmp    800e0a <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	56                   	push   %esi
  800dde:	6a 00                	push   $0x0
  800de0:	e8 04 f4 ff ff       	call   8001e9 <sys_page_unmap>
  800de5:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dee:	6a 00                	push   $0x0
  800df0:	e8 f4 f3 ff ff       	call   8001e9 <sys_page_unmap>
  800df5:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800df8:	83 ec 08             	sub    $0x8,%esp
  800dfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfe:	6a 00                	push   $0x0
  800e00:	e8 e4 f3 ff ff       	call   8001e9 <sys_page_unmap>
  800e05:	83 c4 10             	add    $0x10,%esp
  800e08:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e0a:	89 d0                	mov    %edx,%eax
  800e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e1c:	50                   	push   %eax
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 0e f5 ff ff       	call   800333 <fd_lookup>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	78 18                	js     800e44 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e32:	e8 95 f4 ff ff       	call   8002cc <fd2data>
	return _pipeisclosed(fd, p);
  800e37:	89 c2                	mov    %eax,%edx
  800e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3c:	e8 21 fd ff ff       	call   800b62 <_pipeisclosed>
  800e41:	83 c4 10             	add    $0x10,%esp
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e49:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e56:	68 36 1e 80 00       	push   $0x801e36
  800e5b:	ff 75 0c             	pushl  0xc(%ebp)
  800e5e:	e8 b1 07 00 00       	call   801614 <strcpy>
	return 0;
}
  800e63:	b8 00 00 00 00       	mov    $0x0,%eax
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e76:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e7b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e81:	eb 2d                	jmp    800eb0 <devcons_write+0x46>
		m = n - tot;
  800e83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e86:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800e88:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800e8b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800e90:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e93:	83 ec 04             	sub    $0x4,%esp
  800e96:	53                   	push   %ebx
  800e97:	03 45 0c             	add    0xc(%ebp),%eax
  800e9a:	50                   	push   %eax
  800e9b:	57                   	push   %edi
  800e9c:	e8 06 09 00 00       	call   8017a7 <memmove>
		sys_cputs(buf, m);
  800ea1:	83 c4 08             	add    $0x8,%esp
  800ea4:	53                   	push   %ebx
  800ea5:	57                   	push   %edi
  800ea6:	e8 3d f2 ff ff       	call   8000e8 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800eab:	01 de                	add    %ebx,%esi
  800ead:	83 c4 10             	add    $0x10,%esp
  800eb0:	89 f0                	mov    %esi,%eax
  800eb2:	3b 75 10             	cmp    0x10(%ebp),%esi
  800eb5:	72 cc                	jb     800e83 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ece:	74 2a                	je     800efa <devcons_read+0x3b>
  800ed0:	eb 05                	jmp    800ed7 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800ed2:	e8 a1 f2 ff ff       	call   800178 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800ed7:	e8 32 f2 ff ff       	call   80010e <sys_cgetc>
  800edc:	85 c0                	test   %eax,%eax
  800ede:	74 f2                	je     800ed2 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	78 16                	js     800efa <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800ee4:	83 f8 04             	cmp    $0x4,%eax
  800ee7:	74 0c                	je     800ef5 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eec:	88 02                	mov    %al,(%edx)
	return 1;
  800eee:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef3:	eb 05                	jmp    800efa <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800ef5:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f08:	6a 01                	push   $0x1
  800f0a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f0d:	50                   	push   %eax
  800f0e:	e8 d5 f1 ff ff       	call   8000e8 <sys_cputs>
}
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <getchar>:

int
getchar(void)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f1e:	6a 01                	push   $0x1
  800f20:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f23:	50                   	push   %eax
  800f24:	6a 00                	push   $0x0
  800f26:	e8 6d f6 ff ff       	call   800598 <read>
	if (r < 0)
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	78 0f                	js     800f41 <getchar+0x29>
		return r;
	if (r < 1)
  800f32:	85 c0                	test   %eax,%eax
  800f34:	7e 06                	jle    800f3c <getchar+0x24>
		return -E_EOF;
	return c;
  800f36:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f3a:	eb 05                	jmp    800f41 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f3c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f4c:	50                   	push   %eax
  800f4d:	ff 75 08             	pushl  0x8(%ebp)
  800f50:	e8 de f3 ff ff       	call   800333 <fd_lookup>
  800f55:	83 c4 10             	add    $0x10,%esp
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	78 11                	js     800f6d <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800f65:	39 10                	cmp    %edx,(%eax)
  800f67:	0f 94 c0             	sete   %al
  800f6a:	0f b6 c0             	movzbl %al,%eax
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <opencons>:

int
opencons(void)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f78:	50                   	push   %eax
  800f79:	e8 66 f3 ff ff       	call   8002e4 <fd_alloc>
  800f7e:	83 c4 10             	add    $0x10,%esp
		return r;
  800f81:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	78 3e                	js     800fc5 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f87:	83 ec 04             	sub    $0x4,%esp
  800f8a:	68 07 04 00 00       	push   $0x407
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	6a 00                	push   $0x0
  800f94:	e8 06 f2 ff ff       	call   80019f <sys_page_alloc>
  800f99:	83 c4 10             	add    $0x10,%esp
		return r;
  800f9c:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	78 23                	js     800fc5 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800fa2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fb7:	83 ec 0c             	sub    $0xc,%esp
  800fba:	50                   	push   %eax
  800fbb:	e8 fc f2 ff ff       	call   8002bc <fd2num>
  800fc0:	89 c2                	mov    %eax,%edx
  800fc2:	83 c4 10             	add    $0x10,%esp
}
  800fc5:	89 d0                	mov    %edx,%eax
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    

00800fc9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fd1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800fd7:	e8 78 f1 ff ff       	call   800154 <sys_getenvid>
  800fdc:	83 ec 0c             	sub    $0xc,%esp
  800fdf:	ff 75 0c             	pushl  0xc(%ebp)
  800fe2:	ff 75 08             	pushl  0x8(%ebp)
  800fe5:	56                   	push   %esi
  800fe6:	50                   	push   %eax
  800fe7:	68 44 1e 80 00       	push   $0x801e44
  800fec:	e8 b1 00 00 00       	call   8010a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ff1:	83 c4 18             	add    $0x18,%esp
  800ff4:	53                   	push   %ebx
  800ff5:	ff 75 10             	pushl  0x10(%ebp)
  800ff8:	e8 54 00 00 00       	call   801051 <vcprintf>
	cprintf("\n");
  800ffd:	c7 04 24 2f 1e 80 00 	movl   $0x801e2f,(%esp)
  801004:	e8 99 00 00 00       	call   8010a2 <cprintf>
  801009:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80100c:	cc                   	int3   
  80100d:	eb fd                	jmp    80100c <_panic+0x43>

0080100f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	53                   	push   %ebx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801019:	8b 13                	mov    (%ebx),%edx
  80101b:	8d 42 01             	lea    0x1(%edx),%eax
  80101e:	89 03                	mov    %eax,(%ebx)
  801020:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801023:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801027:	3d ff 00 00 00       	cmp    $0xff,%eax
  80102c:	75 1a                	jne    801048 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80102e:	83 ec 08             	sub    $0x8,%esp
  801031:	68 ff 00 00 00       	push   $0xff
  801036:	8d 43 08             	lea    0x8(%ebx),%eax
  801039:	50                   	push   %eax
  80103a:	e8 a9 f0 ff ff       	call   8000e8 <sys_cputs>
		b->idx = 0;
  80103f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801045:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801048:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80104c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80105a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801061:	00 00 00 
	b.cnt = 0;
  801064:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80106b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	ff 75 08             	pushl  0x8(%ebp)
  801074:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80107a:	50                   	push   %eax
  80107b:	68 0f 10 80 00       	push   $0x80100f
  801080:	e8 86 01 00 00       	call   80120b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801085:	83 c4 08             	add    $0x8,%esp
  801088:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80108e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801094:	50                   	push   %eax
  801095:	e8 4e f0 ff ff       	call   8000e8 <sys_cputs>

	return b.cnt;
}
  80109a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010ab:	50                   	push   %eax
  8010ac:	ff 75 08             	pushl  0x8(%ebp)
  8010af:	e8 9d ff ff ff       	call   801051 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
  8010bc:	83 ec 1c             	sub    $0x1c,%esp
  8010bf:	89 c7                	mov    %eax,%edi
  8010c1:	89 d6                	mov    %edx,%esi
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8010da:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010dd:	39 d3                	cmp    %edx,%ebx
  8010df:	72 05                	jb     8010e6 <printnum+0x30>
  8010e1:	39 45 10             	cmp    %eax,0x10(%ebp)
  8010e4:	77 45                	ja     80112b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	ff 75 18             	pushl  0x18(%ebp)
  8010ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ef:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010f2:	53                   	push   %ebx
  8010f3:	ff 75 10             	pushl  0x10(%ebp)
  8010f6:	83 ec 08             	sub    $0x8,%esp
  8010f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8010ff:	ff 75 dc             	pushl  -0x24(%ebp)
  801102:	ff 75 d8             	pushl  -0x28(%ebp)
  801105:	e8 86 09 00 00       	call   801a90 <__udivdi3>
  80110a:	83 c4 18             	add    $0x18,%esp
  80110d:	52                   	push   %edx
  80110e:	50                   	push   %eax
  80110f:	89 f2                	mov    %esi,%edx
  801111:	89 f8                	mov    %edi,%eax
  801113:	e8 9e ff ff ff       	call   8010b6 <printnum>
  801118:	83 c4 20             	add    $0x20,%esp
  80111b:	eb 18                	jmp    801135 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80111d:	83 ec 08             	sub    $0x8,%esp
  801120:	56                   	push   %esi
  801121:	ff 75 18             	pushl  0x18(%ebp)
  801124:	ff d7                	call   *%edi
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	eb 03                	jmp    80112e <printnum+0x78>
  80112b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80112e:	83 eb 01             	sub    $0x1,%ebx
  801131:	85 db                	test   %ebx,%ebx
  801133:	7f e8                	jg     80111d <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801135:	83 ec 08             	sub    $0x8,%esp
  801138:	56                   	push   %esi
  801139:	83 ec 04             	sub    $0x4,%esp
  80113c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113f:	ff 75 e0             	pushl  -0x20(%ebp)
  801142:	ff 75 dc             	pushl  -0x24(%ebp)
  801145:	ff 75 d8             	pushl  -0x28(%ebp)
  801148:	e8 73 0a 00 00       	call   801bc0 <__umoddi3>
  80114d:	83 c4 14             	add    $0x14,%esp
  801150:	0f be 80 67 1e 80 00 	movsbl 0x801e67(%eax),%eax
  801157:	50                   	push   %eax
  801158:	ff d7                	call   *%edi
}
  80115a:	83 c4 10             	add    $0x10,%esp
  80115d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801160:	5b                   	pop    %ebx
  801161:	5e                   	pop    %esi
  801162:	5f                   	pop    %edi
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    

00801165 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801168:	83 fa 01             	cmp    $0x1,%edx
  80116b:	7e 0e                	jle    80117b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80116d:	8b 10                	mov    (%eax),%edx
  80116f:	8d 4a 08             	lea    0x8(%edx),%ecx
  801172:	89 08                	mov    %ecx,(%eax)
  801174:	8b 02                	mov    (%edx),%eax
  801176:	8b 52 04             	mov    0x4(%edx),%edx
  801179:	eb 22                	jmp    80119d <getuint+0x38>
	else if (lflag)
  80117b:	85 d2                	test   %edx,%edx
  80117d:	74 10                	je     80118f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80117f:	8b 10                	mov    (%eax),%edx
  801181:	8d 4a 04             	lea    0x4(%edx),%ecx
  801184:	89 08                	mov    %ecx,(%eax)
  801186:	8b 02                	mov    (%edx),%eax
  801188:	ba 00 00 00 00       	mov    $0x0,%edx
  80118d:	eb 0e                	jmp    80119d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80118f:	8b 10                	mov    (%eax),%edx
  801191:	8d 4a 04             	lea    0x4(%edx),%ecx
  801194:	89 08                	mov    %ecx,(%eax)
  801196:	8b 02                	mov    (%edx),%eax
  801198:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011a2:	83 fa 01             	cmp    $0x1,%edx
  8011a5:	7e 0e                	jle    8011b5 <getint+0x16>
		return va_arg(*ap, long long);
  8011a7:	8b 10                	mov    (%eax),%edx
  8011a9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011ac:	89 08                	mov    %ecx,(%eax)
  8011ae:	8b 02                	mov    (%edx),%eax
  8011b0:	8b 52 04             	mov    0x4(%edx),%edx
  8011b3:	eb 1a                	jmp    8011cf <getint+0x30>
	else if (lflag)
  8011b5:	85 d2                	test   %edx,%edx
  8011b7:	74 0c                	je     8011c5 <getint+0x26>
		return va_arg(*ap, long);
  8011b9:	8b 10                	mov    (%eax),%edx
  8011bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011be:	89 08                	mov    %ecx,(%eax)
  8011c0:	8b 02                	mov    (%edx),%eax
  8011c2:	99                   	cltd   
  8011c3:	eb 0a                	jmp    8011cf <getint+0x30>
	else
		return va_arg(*ap, int);
  8011c5:	8b 10                	mov    (%eax),%edx
  8011c7:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011ca:	89 08                	mov    %ecx,(%eax)
  8011cc:	8b 02                	mov    (%edx),%eax
  8011ce:	99                   	cltd   
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    

008011d1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011db:	8b 10                	mov    (%eax),%edx
  8011dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8011e0:	73 0a                	jae    8011ec <sprintputch+0x1b>
		*b->buf++ = ch;
  8011e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e5:	89 08                	mov    %ecx,(%eax)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	88 02                	mov    %al,(%edx)
}
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8011f4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8011f7:	50                   	push   %eax
  8011f8:	ff 75 10             	pushl  0x10(%ebp)
  8011fb:	ff 75 0c             	pushl  0xc(%ebp)
  8011fe:	ff 75 08             	pushl  0x8(%ebp)
  801201:	e8 05 00 00 00       	call   80120b <vprintfmt>
	va_end(ap);
}
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
  801211:	83 ec 2c             	sub    $0x2c,%esp
  801214:	8b 75 08             	mov    0x8(%ebp),%esi
  801217:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80121a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80121d:	eb 12                	jmp    801231 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80121f:	85 c0                	test   %eax,%eax
  801221:	0f 84 44 03 00 00    	je     80156b <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	53                   	push   %ebx
  80122b:	50                   	push   %eax
  80122c:	ff d6                	call   *%esi
  80122e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801231:	83 c7 01             	add    $0x1,%edi
  801234:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801238:	83 f8 25             	cmp    $0x25,%eax
  80123b:	75 e2                	jne    80121f <vprintfmt+0x14>
  80123d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801241:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801248:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80124f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801256:	ba 00 00 00 00       	mov    $0x0,%edx
  80125b:	eb 07                	jmp    801264 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80125d:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801260:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801264:	8d 47 01             	lea    0x1(%edi),%eax
  801267:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80126a:	0f b6 07             	movzbl (%edi),%eax
  80126d:	0f b6 c8             	movzbl %al,%ecx
  801270:	83 e8 23             	sub    $0x23,%eax
  801273:	3c 55                	cmp    $0x55,%al
  801275:	0f 87 d5 02 00 00    	ja     801550 <vprintfmt+0x345>
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	ff 24 85 a0 1f 80 00 	jmp    *0x801fa0(,%eax,4)
  801285:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801288:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80128c:	eb d6                	jmp    801264 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80128e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801291:	b8 00 00 00 00       	mov    $0x0,%eax
  801296:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801299:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80129c:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012a0:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012a3:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012a6:	83 fa 09             	cmp    $0x9,%edx
  8012a9:	77 39                	ja     8012e4 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012ab:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012ae:	eb e9                	jmp    801299 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8d 48 04             	lea    0x4(%eax),%ecx
  8012b6:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012b9:	8b 00                	mov    (%eax),%eax
  8012bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012c1:	eb 27                	jmp    8012ea <vprintfmt+0xdf>
  8012c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012cd:	0f 49 c8             	cmovns %eax,%ecx
  8012d0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012d6:	eb 8c                	jmp    801264 <vprintfmt+0x59>
  8012d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8012db:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012e2:	eb 80                	jmp    801264 <vprintfmt+0x59>
  8012e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012e7:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8012ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012ee:	0f 89 70 ff ff ff    	jns    801264 <vprintfmt+0x59>
				width = precision, precision = -1;
  8012f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801301:	e9 5e ff ff ff       	jmp    801264 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801306:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801309:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80130c:	e9 53 ff ff ff       	jmp    801264 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801311:	8b 45 14             	mov    0x14(%ebp),%eax
  801314:	8d 50 04             	lea    0x4(%eax),%edx
  801317:	89 55 14             	mov    %edx,0x14(%ebp)
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	53                   	push   %ebx
  80131e:	ff 30                	pushl  (%eax)
  801320:	ff d6                	call   *%esi
			break;
  801322:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801328:	e9 04 ff ff ff       	jmp    801231 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80132d:	8b 45 14             	mov    0x14(%ebp),%eax
  801330:	8d 50 04             	lea    0x4(%eax),%edx
  801333:	89 55 14             	mov    %edx,0x14(%ebp)
  801336:	8b 00                	mov    (%eax),%eax
  801338:	99                   	cltd   
  801339:	31 d0                	xor    %edx,%eax
  80133b:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80133d:	83 f8 0f             	cmp    $0xf,%eax
  801340:	7f 0b                	jg     80134d <vprintfmt+0x142>
  801342:	8b 14 85 00 21 80 00 	mov    0x802100(,%eax,4),%edx
  801349:	85 d2                	test   %edx,%edx
  80134b:	75 18                	jne    801365 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80134d:	50                   	push   %eax
  80134e:	68 7f 1e 80 00       	push   $0x801e7f
  801353:	53                   	push   %ebx
  801354:	56                   	push   %esi
  801355:	e8 94 fe ff ff       	call   8011ee <printfmt>
  80135a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80135d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801360:	e9 cc fe ff ff       	jmp    801231 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801365:	52                   	push   %edx
  801366:	68 fd 1d 80 00       	push   $0x801dfd
  80136b:	53                   	push   %ebx
  80136c:	56                   	push   %esi
  80136d:	e8 7c fe ff ff       	call   8011ee <printfmt>
  801372:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801378:	e9 b4 fe ff ff       	jmp    801231 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80137d:	8b 45 14             	mov    0x14(%ebp),%eax
  801380:	8d 50 04             	lea    0x4(%eax),%edx
  801383:	89 55 14             	mov    %edx,0x14(%ebp)
  801386:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801388:	85 ff                	test   %edi,%edi
  80138a:	b8 78 1e 80 00       	mov    $0x801e78,%eax
  80138f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801392:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801396:	0f 8e 94 00 00 00    	jle    801430 <vprintfmt+0x225>
  80139c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013a0:	0f 84 98 00 00 00    	je     80143e <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013a6:	83 ec 08             	sub    $0x8,%esp
  8013a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8013ac:	57                   	push   %edi
  8013ad:	e8 41 02 00 00       	call   8015f3 <strnlen>
  8013b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013b5:	29 c1                	sub    %eax,%ecx
  8013b7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013ba:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013bd:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013c7:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c9:	eb 0f                	jmp    8013da <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	53                   	push   %ebx
  8013cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8013d2:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d4:	83 ef 01             	sub    $0x1,%edi
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 ff                	test   %edi,%edi
  8013dc:	7f ed                	jg     8013cb <vprintfmt+0x1c0>
  8013de:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013e1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8013e4:	85 c9                	test   %ecx,%ecx
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013eb:	0f 49 c1             	cmovns %ecx,%eax
  8013ee:	29 c1                	sub    %eax,%ecx
  8013f0:	89 75 08             	mov    %esi,0x8(%ebp)
  8013f3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013f6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8013f9:	89 cb                	mov    %ecx,%ebx
  8013fb:	eb 4d                	jmp    80144a <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8013fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801401:	74 1b                	je     80141e <vprintfmt+0x213>
  801403:	0f be c0             	movsbl %al,%eax
  801406:	83 e8 20             	sub    $0x20,%eax
  801409:	83 f8 5e             	cmp    $0x5e,%eax
  80140c:	76 10                	jbe    80141e <vprintfmt+0x213>
					putch('?', putdat);
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	ff 75 0c             	pushl  0xc(%ebp)
  801414:	6a 3f                	push   $0x3f
  801416:	ff 55 08             	call   *0x8(%ebp)
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	eb 0d                	jmp    80142b <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	52                   	push   %edx
  801425:	ff 55 08             	call   *0x8(%ebp)
  801428:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80142b:	83 eb 01             	sub    $0x1,%ebx
  80142e:	eb 1a                	jmp    80144a <vprintfmt+0x23f>
  801430:	89 75 08             	mov    %esi,0x8(%ebp)
  801433:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801436:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801439:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80143c:	eb 0c                	jmp    80144a <vprintfmt+0x23f>
  80143e:	89 75 08             	mov    %esi,0x8(%ebp)
  801441:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801444:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801447:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80144a:	83 c7 01             	add    $0x1,%edi
  80144d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801451:	0f be d0             	movsbl %al,%edx
  801454:	85 d2                	test   %edx,%edx
  801456:	74 23                	je     80147b <vprintfmt+0x270>
  801458:	85 f6                	test   %esi,%esi
  80145a:	78 a1                	js     8013fd <vprintfmt+0x1f2>
  80145c:	83 ee 01             	sub    $0x1,%esi
  80145f:	79 9c                	jns    8013fd <vprintfmt+0x1f2>
  801461:	89 df                	mov    %ebx,%edi
  801463:	8b 75 08             	mov    0x8(%ebp),%esi
  801466:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801469:	eb 18                	jmp    801483 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	53                   	push   %ebx
  80146f:	6a 20                	push   $0x20
  801471:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801473:	83 ef 01             	sub    $0x1,%edi
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	eb 08                	jmp    801483 <vprintfmt+0x278>
  80147b:	89 df                	mov    %ebx,%edi
  80147d:	8b 75 08             	mov    0x8(%ebp),%esi
  801480:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801483:	85 ff                	test   %edi,%edi
  801485:	7f e4                	jg     80146b <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80148a:	e9 a2 fd ff ff       	jmp    801231 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80148f:	8d 45 14             	lea    0x14(%ebp),%eax
  801492:	e8 08 fd ff ff       	call   80119f <getint>
  801497:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80149a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80149d:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014a6:	79 74                	jns    80151c <vprintfmt+0x311>
				putch('-', putdat);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	53                   	push   %ebx
  8014ac:	6a 2d                	push   $0x2d
  8014ae:	ff d6                	call   *%esi
				num = -(long long) num;
  8014b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014b6:	f7 d8                	neg    %eax
  8014b8:	83 d2 00             	adc    $0x0,%edx
  8014bb:	f7 da                	neg    %edx
  8014bd:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c5:	eb 55                	jmp    80151c <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8014ca:	e8 96 fc ff ff       	call   801165 <getuint>
			base = 10;
  8014cf:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014d4:	eb 46                	jmp    80151c <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8014d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8014d9:	e8 87 fc ff ff       	call   801165 <getuint>
			base = 8;
  8014de:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8014e3:	eb 37                	jmp    80151c <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	53                   	push   %ebx
  8014e9:	6a 30                	push   $0x30
  8014eb:	ff d6                	call   *%esi
			putch('x', putdat);
  8014ed:	83 c4 08             	add    $0x8,%esp
  8014f0:	53                   	push   %ebx
  8014f1:	6a 78                	push   $0x78
  8014f3:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8014f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f8:	8d 50 04             	lea    0x4(%eax),%edx
  8014fb:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014fe:	8b 00                	mov    (%eax),%eax
  801500:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801505:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801508:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80150d:	eb 0d                	jmp    80151c <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80150f:	8d 45 14             	lea    0x14(%ebp),%eax
  801512:	e8 4e fc ff ff       	call   801165 <getuint>
			base = 16;
  801517:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801523:	57                   	push   %edi
  801524:	ff 75 e0             	pushl  -0x20(%ebp)
  801527:	51                   	push   %ecx
  801528:	52                   	push   %edx
  801529:	50                   	push   %eax
  80152a:	89 da                	mov    %ebx,%edx
  80152c:	89 f0                	mov    %esi,%eax
  80152e:	e8 83 fb ff ff       	call   8010b6 <printnum>
			break;
  801533:	83 c4 20             	add    $0x20,%esp
  801536:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801539:	e9 f3 fc ff ff       	jmp    801231 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	53                   	push   %ebx
  801542:	51                   	push   %ecx
  801543:	ff d6                	call   *%esi
			break;
  801545:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801548:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80154b:	e9 e1 fc ff ff       	jmp    801231 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	53                   	push   %ebx
  801554:	6a 25                	push   $0x25
  801556:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	eb 03                	jmp    801560 <vprintfmt+0x355>
  80155d:	83 ef 01             	sub    $0x1,%edi
  801560:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  801564:	75 f7                	jne    80155d <vprintfmt+0x352>
  801566:	e9 c6 fc ff ff       	jmp    801231 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80156b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156e:	5b                   	pop    %ebx
  80156f:	5e                   	pop    %esi
  801570:	5f                   	pop    %edi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 18             	sub    $0x18,%esp
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80157f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801582:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801586:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801589:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801590:	85 c0                	test   %eax,%eax
  801592:	74 26                	je     8015ba <vsnprintf+0x47>
  801594:	85 d2                	test   %edx,%edx
  801596:	7e 22                	jle    8015ba <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801598:	ff 75 14             	pushl  0x14(%ebp)
  80159b:	ff 75 10             	pushl  0x10(%ebp)
  80159e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015a1:	50                   	push   %eax
  8015a2:	68 d1 11 80 00       	push   $0x8011d1
  8015a7:	e8 5f fc ff ff       	call   80120b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	eb 05                	jmp    8015bf <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015c7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015ca:	50                   	push   %eax
  8015cb:	ff 75 10             	pushl  0x10(%ebp)
  8015ce:	ff 75 0c             	pushl  0xc(%ebp)
  8015d1:	ff 75 08             	pushl  0x8(%ebp)
  8015d4:	e8 9a ff ff ff       	call   801573 <vsnprintf>
	va_end(ap);

	return rc;
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e6:	eb 03                	jmp    8015eb <strlen+0x10>
		n++;
  8015e8:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8015ef:	75 f7                	jne    8015e8 <strlen+0xd>
		n++;
	return n;
}
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    

008015f3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801601:	eb 03                	jmp    801606 <strnlen+0x13>
		n++;
  801603:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801606:	39 c2                	cmp    %eax,%edx
  801608:	74 08                	je     801612 <strnlen+0x1f>
  80160a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80160e:	75 f3                	jne    801603 <strnlen+0x10>
  801610:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    

00801614 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	53                   	push   %ebx
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80161e:	89 c2                	mov    %eax,%edx
  801620:	83 c2 01             	add    $0x1,%edx
  801623:	83 c1 01             	add    $0x1,%ecx
  801626:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80162a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80162d:	84 db                	test   %bl,%bl
  80162f:	75 ef                	jne    801620 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801631:	5b                   	pop    %ebx
  801632:	5d                   	pop    %ebp
  801633:	c3                   	ret    

00801634 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	53                   	push   %ebx
  801638:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80163b:	53                   	push   %ebx
  80163c:	e8 9a ff ff ff       	call   8015db <strlen>
  801641:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	01 d8                	add    %ebx,%eax
  801649:	50                   	push   %eax
  80164a:	e8 c5 ff ff ff       	call   801614 <strcpy>
	return dst;
}
  80164f:	89 d8                	mov    %ebx,%eax
  801651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
  80165b:	8b 75 08             	mov    0x8(%ebp),%esi
  80165e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801661:	89 f3                	mov    %esi,%ebx
  801663:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801666:	89 f2                	mov    %esi,%edx
  801668:	eb 0f                	jmp    801679 <strncpy+0x23>
		*dst++ = *src;
  80166a:	83 c2 01             	add    $0x1,%edx
  80166d:	0f b6 01             	movzbl (%ecx),%eax
  801670:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801673:	80 39 01             	cmpb   $0x1,(%ecx)
  801676:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801679:	39 da                	cmp    %ebx,%edx
  80167b:	75 ed                	jne    80166a <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80167d:	89 f0                	mov    %esi,%eax
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	56                   	push   %esi
  801687:	53                   	push   %ebx
  801688:	8b 75 08             	mov    0x8(%ebp),%esi
  80168b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168e:	8b 55 10             	mov    0x10(%ebp),%edx
  801691:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801693:	85 d2                	test   %edx,%edx
  801695:	74 21                	je     8016b8 <strlcpy+0x35>
  801697:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80169b:	89 f2                	mov    %esi,%edx
  80169d:	eb 09                	jmp    8016a8 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80169f:	83 c2 01             	add    $0x1,%edx
  8016a2:	83 c1 01             	add    $0x1,%ecx
  8016a5:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a8:	39 c2                	cmp    %eax,%edx
  8016aa:	74 09                	je     8016b5 <strlcpy+0x32>
  8016ac:	0f b6 19             	movzbl (%ecx),%ebx
  8016af:	84 db                	test   %bl,%bl
  8016b1:	75 ec                	jne    80169f <strlcpy+0x1c>
  8016b3:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016b5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016b8:	29 f0                	sub    %esi,%eax
}
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016c7:	eb 06                	jmp    8016cf <strcmp+0x11>
		p++, q++;
  8016c9:	83 c1 01             	add    $0x1,%ecx
  8016cc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016cf:	0f b6 01             	movzbl (%ecx),%eax
  8016d2:	84 c0                	test   %al,%al
  8016d4:	74 04                	je     8016da <strcmp+0x1c>
  8016d6:	3a 02                	cmp    (%edx),%al
  8016d8:	74 ef                	je     8016c9 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016da:	0f b6 c0             	movzbl %al,%eax
  8016dd:	0f b6 12             	movzbl (%edx),%edx
  8016e0:	29 d0                	sub    %edx,%eax
}
  8016e2:	5d                   	pop    %ebp
  8016e3:	c3                   	ret    

008016e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	53                   	push   %ebx
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	89 c3                	mov    %eax,%ebx
  8016f0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8016f3:	eb 06                	jmp    8016fb <strncmp+0x17>
		n--, p++, q++;
  8016f5:	83 c0 01             	add    $0x1,%eax
  8016f8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8016fb:	39 d8                	cmp    %ebx,%eax
  8016fd:	74 15                	je     801714 <strncmp+0x30>
  8016ff:	0f b6 08             	movzbl (%eax),%ecx
  801702:	84 c9                	test   %cl,%cl
  801704:	74 04                	je     80170a <strncmp+0x26>
  801706:	3a 0a                	cmp    (%edx),%cl
  801708:	74 eb                	je     8016f5 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80170a:	0f b6 00             	movzbl (%eax),%eax
  80170d:	0f b6 12             	movzbl (%edx),%edx
  801710:	29 d0                	sub    %edx,%eax
  801712:	eb 05                	jmp    801719 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801719:	5b                   	pop    %ebx
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801726:	eb 07                	jmp    80172f <strchr+0x13>
		if (*s == c)
  801728:	38 ca                	cmp    %cl,%dl
  80172a:	74 0f                	je     80173b <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80172c:	83 c0 01             	add    $0x1,%eax
  80172f:	0f b6 10             	movzbl (%eax),%edx
  801732:	84 d2                	test   %dl,%dl
  801734:	75 f2                	jne    801728 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    

0080173d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801747:	eb 03                	jmp    80174c <strfind+0xf>
  801749:	83 c0 01             	add    $0x1,%eax
  80174c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80174f:	38 ca                	cmp    %cl,%dl
  801751:	74 04                	je     801757 <strfind+0x1a>
  801753:	84 d2                	test   %dl,%dl
  801755:	75 f2                	jne    801749 <strfind+0xc>
			break;
	return (char *) s;
}
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	57                   	push   %edi
  80175d:	56                   	push   %esi
  80175e:	53                   	push   %ebx
  80175f:	8b 55 08             	mov    0x8(%ebp),%edx
  801762:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801765:	85 c9                	test   %ecx,%ecx
  801767:	74 37                	je     8017a0 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801769:	f6 c2 03             	test   $0x3,%dl
  80176c:	75 2a                	jne    801798 <memset+0x3f>
  80176e:	f6 c1 03             	test   $0x3,%cl
  801771:	75 25                	jne    801798 <memset+0x3f>
		c &= 0xFF;
  801773:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801777:	89 df                	mov    %ebx,%edi
  801779:	c1 e7 08             	shl    $0x8,%edi
  80177c:	89 de                	mov    %ebx,%esi
  80177e:	c1 e6 18             	shl    $0x18,%esi
  801781:	89 d8                	mov    %ebx,%eax
  801783:	c1 e0 10             	shl    $0x10,%eax
  801786:	09 f0                	or     %esi,%eax
  801788:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  80178a:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80178d:	89 f8                	mov    %edi,%eax
  80178f:	09 d8                	or     %ebx,%eax
  801791:	89 d7                	mov    %edx,%edi
  801793:	fc                   	cld    
  801794:	f3 ab                	rep stos %eax,%es:(%edi)
  801796:	eb 08                	jmp    8017a0 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801798:	89 d7                	mov    %edx,%edi
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	fc                   	cld    
  80179e:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017a0:	89 d0                	mov    %edx,%eax
  8017a2:	5b                   	pop    %ebx
  8017a3:	5e                   	pop    %esi
  8017a4:	5f                   	pop    %edi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	57                   	push   %edi
  8017ab:	56                   	push   %esi
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017b5:	39 c6                	cmp    %eax,%esi
  8017b7:	73 35                	jae    8017ee <memmove+0x47>
  8017b9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017bc:	39 d0                	cmp    %edx,%eax
  8017be:	73 2e                	jae    8017ee <memmove+0x47>
		s += n;
		d += n;
  8017c0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017c3:	89 d6                	mov    %edx,%esi
  8017c5:	09 fe                	or     %edi,%esi
  8017c7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017cd:	75 13                	jne    8017e2 <memmove+0x3b>
  8017cf:	f6 c1 03             	test   $0x3,%cl
  8017d2:	75 0e                	jne    8017e2 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017d4:	83 ef 04             	sub    $0x4,%edi
  8017d7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8017da:	c1 e9 02             	shr    $0x2,%ecx
  8017dd:	fd                   	std    
  8017de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8017e0:	eb 09                	jmp    8017eb <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017e2:	83 ef 01             	sub    $0x1,%edi
  8017e5:	8d 72 ff             	lea    -0x1(%edx),%esi
  8017e8:	fd                   	std    
  8017e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017eb:	fc                   	cld    
  8017ec:	eb 1d                	jmp    80180b <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017ee:	89 f2                	mov    %esi,%edx
  8017f0:	09 c2                	or     %eax,%edx
  8017f2:	f6 c2 03             	test   $0x3,%dl
  8017f5:	75 0f                	jne    801806 <memmove+0x5f>
  8017f7:	f6 c1 03             	test   $0x3,%cl
  8017fa:	75 0a                	jne    801806 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8017fc:	c1 e9 02             	shr    $0x2,%ecx
  8017ff:	89 c7                	mov    %eax,%edi
  801801:	fc                   	cld    
  801802:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801804:	eb 05                	jmp    80180b <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801806:	89 c7                	mov    %eax,%edi
  801808:	fc                   	cld    
  801809:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801812:	ff 75 10             	pushl  0x10(%ebp)
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	e8 87 ff ff ff       	call   8017a7 <memmove>
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182d:	89 c6                	mov    %eax,%esi
  80182f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801832:	eb 1a                	jmp    80184e <memcmp+0x2c>
		if (*s1 != *s2)
  801834:	0f b6 08             	movzbl (%eax),%ecx
  801837:	0f b6 1a             	movzbl (%edx),%ebx
  80183a:	38 d9                	cmp    %bl,%cl
  80183c:	74 0a                	je     801848 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  80183e:	0f b6 c1             	movzbl %cl,%eax
  801841:	0f b6 db             	movzbl %bl,%ebx
  801844:	29 d8                	sub    %ebx,%eax
  801846:	eb 0f                	jmp    801857 <memcmp+0x35>
		s1++, s2++;
  801848:	83 c0 01             	add    $0x1,%eax
  80184b:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80184e:	39 f0                	cmp    %esi,%eax
  801850:	75 e2                	jne    801834 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801857:	5b                   	pop    %ebx
  801858:	5e                   	pop    %esi
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    

0080185b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	53                   	push   %ebx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801862:	89 c1                	mov    %eax,%ecx
  801864:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  801867:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80186b:	eb 0a                	jmp    801877 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  80186d:	0f b6 10             	movzbl (%eax),%edx
  801870:	39 da                	cmp    %ebx,%edx
  801872:	74 07                	je     80187b <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801874:	83 c0 01             	add    $0x1,%eax
  801877:	39 c8                	cmp    %ecx,%eax
  801879:	72 f2                	jb     80186d <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80187b:	5b                   	pop    %ebx
  80187c:	5d                   	pop    %ebp
  80187d:	c3                   	ret    

0080187e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	57                   	push   %edi
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801887:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80188a:	eb 03                	jmp    80188f <strtol+0x11>
		s++;
  80188c:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80188f:	0f b6 01             	movzbl (%ecx),%eax
  801892:	3c 20                	cmp    $0x20,%al
  801894:	74 f6                	je     80188c <strtol+0xe>
  801896:	3c 09                	cmp    $0x9,%al
  801898:	74 f2                	je     80188c <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  80189a:	3c 2b                	cmp    $0x2b,%al
  80189c:	75 0a                	jne    8018a8 <strtol+0x2a>
		s++;
  80189e:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a6:	eb 11                	jmp    8018b9 <strtol+0x3b>
  8018a8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018ad:	3c 2d                	cmp    $0x2d,%al
  8018af:	75 08                	jne    8018b9 <strtol+0x3b>
		s++, neg = 1;
  8018b1:	83 c1 01             	add    $0x1,%ecx
  8018b4:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018b9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018bf:	75 15                	jne    8018d6 <strtol+0x58>
  8018c1:	80 39 30             	cmpb   $0x30,(%ecx)
  8018c4:	75 10                	jne    8018d6 <strtol+0x58>
  8018c6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018ca:	75 7c                	jne    801948 <strtol+0xca>
		s += 2, base = 16;
  8018cc:	83 c1 02             	add    $0x2,%ecx
  8018cf:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018d4:	eb 16                	jmp    8018ec <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8018d6:	85 db                	test   %ebx,%ebx
  8018d8:	75 12                	jne    8018ec <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8018da:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8018df:	80 39 30             	cmpb   $0x30,(%ecx)
  8018e2:	75 08                	jne    8018ec <strtol+0x6e>
		s++, base = 8;
  8018e4:	83 c1 01             	add    $0x1,%ecx
  8018e7:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f1:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018f4:	0f b6 11             	movzbl (%ecx),%edx
  8018f7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8018fa:	89 f3                	mov    %esi,%ebx
  8018fc:	80 fb 09             	cmp    $0x9,%bl
  8018ff:	77 08                	ja     801909 <strtol+0x8b>
			dig = *s - '0';
  801901:	0f be d2             	movsbl %dl,%edx
  801904:	83 ea 30             	sub    $0x30,%edx
  801907:	eb 22                	jmp    80192b <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  801909:	8d 72 9f             	lea    -0x61(%edx),%esi
  80190c:	89 f3                	mov    %esi,%ebx
  80190e:	80 fb 19             	cmp    $0x19,%bl
  801911:	77 08                	ja     80191b <strtol+0x9d>
			dig = *s - 'a' + 10;
  801913:	0f be d2             	movsbl %dl,%edx
  801916:	83 ea 57             	sub    $0x57,%edx
  801919:	eb 10                	jmp    80192b <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  80191b:	8d 72 bf             	lea    -0x41(%edx),%esi
  80191e:	89 f3                	mov    %esi,%ebx
  801920:	80 fb 19             	cmp    $0x19,%bl
  801923:	77 16                	ja     80193b <strtol+0xbd>
			dig = *s - 'A' + 10;
  801925:	0f be d2             	movsbl %dl,%edx
  801928:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  80192b:	3b 55 10             	cmp    0x10(%ebp),%edx
  80192e:	7d 0b                	jge    80193b <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  801930:	83 c1 01             	add    $0x1,%ecx
  801933:	0f af 45 10          	imul   0x10(%ebp),%eax
  801937:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  801939:	eb b9                	jmp    8018f4 <strtol+0x76>

	if (endptr)
  80193b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80193f:	74 0d                	je     80194e <strtol+0xd0>
		*endptr = (char *) s;
  801941:	8b 75 0c             	mov    0xc(%ebp),%esi
  801944:	89 0e                	mov    %ecx,(%esi)
  801946:	eb 06                	jmp    80194e <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801948:	85 db                	test   %ebx,%ebx
  80194a:	74 98                	je     8018e4 <strtol+0x66>
  80194c:	eb 9e                	jmp    8018ec <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  80194e:	89 c2                	mov    %eax,%edx
  801950:	f7 da                	neg    %edx
  801952:	85 ff                	test   %edi,%edi
  801954:	0f 45 c2             	cmovne %edx,%eax
}
  801957:	5b                   	pop    %ebx
  801958:	5e                   	pop    %esi
  801959:	5f                   	pop    %edi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	8b 75 08             	mov    0x8(%ebp),%esi
  801964:	8b 45 0c             	mov    0xc(%ebp),%eax
  801967:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80196a:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80196c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801971:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801974:	83 ec 0c             	sub    $0xc,%esp
  801977:	50                   	push   %eax
  801978:	e8 1d e9 ff ff       	call   80029a <sys_ipc_recv>
	if (from_env_store)
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	85 f6                	test   %esi,%esi
  801982:	74 0b                	je     80198f <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801984:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80198a:	8b 52 74             	mov    0x74(%edx),%edx
  80198d:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80198f:	85 db                	test   %ebx,%ebx
  801991:	74 0b                	je     80199e <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801993:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801999:	8b 52 78             	mov    0x78(%edx),%edx
  80199c:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	79 16                	jns    8019b8 <ipc_recv+0x5c>
		if (from_env_store)
  8019a2:	85 f6                	test   %esi,%esi
  8019a4:	74 06                	je     8019ac <ipc_recv+0x50>
			*from_env_store = 0;
  8019a6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019ac:	85 db                	test   %ebx,%ebx
  8019ae:	74 10                	je     8019c0 <ipc_recv+0x64>
			*perm_store = 0;
  8019b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019b6:	eb 08                	jmp    8019c0 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019b8:	a1 04 40 80 00       	mov    0x804004,%eax
  8019bd:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5d                   	pop    %ebp
  8019c6:	c3                   	ret    

008019c7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	57                   	push   %edi
  8019cb:	56                   	push   %esi
  8019cc:	53                   	push   %ebx
  8019cd:	83 ec 0c             	sub    $0xc,%esp
  8019d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019d9:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019db:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019e0:	0f 44 d8             	cmove  %eax,%ebx
  8019e3:	eb 1c                	jmp    801a01 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019e5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019e8:	74 12                	je     8019fc <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019ea:	50                   	push   %eax
  8019eb:	68 60 21 80 00       	push   $0x802160
  8019f0:	6a 42                	push   $0x42
  8019f2:	68 76 21 80 00       	push   $0x802176
  8019f7:	e8 cd f5 ff ff       	call   800fc9 <_panic>
		sys_yield();
  8019fc:	e8 77 e7 ff ff       	call   800178 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a01:	ff 75 14             	pushl  0x14(%ebp)
  801a04:	53                   	push   %ebx
  801a05:	56                   	push   %esi
  801a06:	57                   	push   %edi
  801a07:	e8 69 e8 ff ff       	call   800275 <sys_ipc_try_send>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	75 d2                	jne    8019e5 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a16:	5b                   	pop    %ebx
  801a17:	5e                   	pop    %esi
  801a18:	5f                   	pop    %edi
  801a19:	5d                   	pop    %ebp
  801a1a:	c3                   	ret    

00801a1b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a21:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a26:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a29:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a2f:	8b 52 50             	mov    0x50(%edx),%edx
  801a32:	39 ca                	cmp    %ecx,%edx
  801a34:	75 0d                	jne    801a43 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a36:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a39:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a3e:	8b 40 48             	mov    0x48(%eax),%eax
  801a41:	eb 0f                	jmp    801a52 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a43:	83 c0 01             	add    $0x1,%eax
  801a46:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a4b:	75 d9                	jne    801a26 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    

00801a54 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a5a:	89 d0                	mov    %edx,%eax
  801a5c:	c1 e8 16             	shr    $0x16,%eax
  801a5f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a6b:	f6 c1 01             	test   $0x1,%cl
  801a6e:	74 1d                	je     801a8d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a70:	c1 ea 0c             	shr    $0xc,%edx
  801a73:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a7a:	f6 c2 01             	test   $0x1,%dl
  801a7d:	74 0e                	je     801a8d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a7f:	c1 ea 0c             	shr    $0xc,%edx
  801a82:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a89:	ef 
  801a8a:	0f b7 c0             	movzwl %ax,%eax
}
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    
  801a8f:	90                   	nop

00801a90 <__udivdi3>:
  801a90:	55                   	push   %ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 1c             	sub    $0x1c,%esp
  801a97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aa7:	85 f6                	test   %esi,%esi
  801aa9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aad:	89 ca                	mov    %ecx,%edx
  801aaf:	89 f8                	mov    %edi,%eax
  801ab1:	75 3d                	jne    801af0 <__udivdi3+0x60>
  801ab3:	39 cf                	cmp    %ecx,%edi
  801ab5:	0f 87 c5 00 00 00    	ja     801b80 <__udivdi3+0xf0>
  801abb:	85 ff                	test   %edi,%edi
  801abd:	89 fd                	mov    %edi,%ebp
  801abf:	75 0b                	jne    801acc <__udivdi3+0x3c>
  801ac1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac6:	31 d2                	xor    %edx,%edx
  801ac8:	f7 f7                	div    %edi
  801aca:	89 c5                	mov    %eax,%ebp
  801acc:	89 c8                	mov    %ecx,%eax
  801ace:	31 d2                	xor    %edx,%edx
  801ad0:	f7 f5                	div    %ebp
  801ad2:	89 c1                	mov    %eax,%ecx
  801ad4:	89 d8                	mov    %ebx,%eax
  801ad6:	89 cf                	mov    %ecx,%edi
  801ad8:	f7 f5                	div    %ebp
  801ada:	89 c3                	mov    %eax,%ebx
  801adc:	89 d8                	mov    %ebx,%eax
  801ade:	89 fa                	mov    %edi,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	90                   	nop
  801ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801af0:	39 ce                	cmp    %ecx,%esi
  801af2:	77 74                	ja     801b68 <__udivdi3+0xd8>
  801af4:	0f bd fe             	bsr    %esi,%edi
  801af7:	83 f7 1f             	xor    $0x1f,%edi
  801afa:	0f 84 98 00 00 00    	je     801b98 <__udivdi3+0x108>
  801b00:	bb 20 00 00 00       	mov    $0x20,%ebx
  801b05:	89 f9                	mov    %edi,%ecx
  801b07:	89 c5                	mov    %eax,%ebp
  801b09:	29 fb                	sub    %edi,%ebx
  801b0b:	d3 e6                	shl    %cl,%esi
  801b0d:	89 d9                	mov    %ebx,%ecx
  801b0f:	d3 ed                	shr    %cl,%ebp
  801b11:	89 f9                	mov    %edi,%ecx
  801b13:	d3 e0                	shl    %cl,%eax
  801b15:	09 ee                	or     %ebp,%esi
  801b17:	89 d9                	mov    %ebx,%ecx
  801b19:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1d:	89 d5                	mov    %edx,%ebp
  801b1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b23:	d3 ed                	shr    %cl,%ebp
  801b25:	89 f9                	mov    %edi,%ecx
  801b27:	d3 e2                	shl    %cl,%edx
  801b29:	89 d9                	mov    %ebx,%ecx
  801b2b:	d3 e8                	shr    %cl,%eax
  801b2d:	09 c2                	or     %eax,%edx
  801b2f:	89 d0                	mov    %edx,%eax
  801b31:	89 ea                	mov    %ebp,%edx
  801b33:	f7 f6                	div    %esi
  801b35:	89 d5                	mov    %edx,%ebp
  801b37:	89 c3                	mov    %eax,%ebx
  801b39:	f7 64 24 0c          	mull   0xc(%esp)
  801b3d:	39 d5                	cmp    %edx,%ebp
  801b3f:	72 10                	jb     801b51 <__udivdi3+0xc1>
  801b41:	8b 74 24 08          	mov    0x8(%esp),%esi
  801b45:	89 f9                	mov    %edi,%ecx
  801b47:	d3 e6                	shl    %cl,%esi
  801b49:	39 c6                	cmp    %eax,%esi
  801b4b:	73 07                	jae    801b54 <__udivdi3+0xc4>
  801b4d:	39 d5                	cmp    %edx,%ebp
  801b4f:	75 03                	jne    801b54 <__udivdi3+0xc4>
  801b51:	83 eb 01             	sub    $0x1,%ebx
  801b54:	31 ff                	xor    %edi,%edi
  801b56:	89 d8                	mov    %ebx,%eax
  801b58:	89 fa                	mov    %edi,%edx
  801b5a:	83 c4 1c             	add    $0x1c,%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5f                   	pop    %edi
  801b60:	5d                   	pop    %ebp
  801b61:	c3                   	ret    
  801b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801b68:	31 ff                	xor    %edi,%edi
  801b6a:	31 db                	xor    %ebx,%ebx
  801b6c:	89 d8                	mov    %ebx,%eax
  801b6e:	89 fa                	mov    %edi,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	90                   	nop
  801b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801b80:	89 d8                	mov    %ebx,%eax
  801b82:	f7 f7                	div    %edi
  801b84:	31 ff                	xor    %edi,%edi
  801b86:	89 c3                	mov    %eax,%ebx
  801b88:	89 d8                	mov    %ebx,%eax
  801b8a:	89 fa                	mov    %edi,%edx
  801b8c:	83 c4 1c             	add    $0x1c,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
  801b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b98:	39 ce                	cmp    %ecx,%esi
  801b9a:	72 0c                	jb     801ba8 <__udivdi3+0x118>
  801b9c:	31 db                	xor    %ebx,%ebx
  801b9e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ba2:	0f 87 34 ff ff ff    	ja     801adc <__udivdi3+0x4c>
  801ba8:	bb 01 00 00 00       	mov    $0x1,%ebx
  801bad:	e9 2a ff ff ff       	jmp    801adc <__udivdi3+0x4c>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	66 90                	xchg   %ax,%ax
  801bb6:	66 90                	xchg   %ax,%ax
  801bb8:	66 90                	xchg   %ax,%ax
  801bba:	66 90                	xchg   %ax,%ax
  801bbc:	66 90                	xchg   %ax,%ax
  801bbe:	66 90                	xchg   %ax,%ax

00801bc0 <__umoddi3>:
  801bc0:	55                   	push   %ebp
  801bc1:	57                   	push   %edi
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 1c             	sub    $0x1c,%esp
  801bc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801bcb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bd7:	85 d2                	test   %edx,%edx
  801bd9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801be1:	89 f3                	mov    %esi,%ebx
  801be3:	89 3c 24             	mov    %edi,(%esp)
  801be6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bea:	75 1c                	jne    801c08 <__umoddi3+0x48>
  801bec:	39 f7                	cmp    %esi,%edi
  801bee:	76 50                	jbe    801c40 <__umoddi3+0x80>
  801bf0:	89 c8                	mov    %ecx,%eax
  801bf2:	89 f2                	mov    %esi,%edx
  801bf4:	f7 f7                	div    %edi
  801bf6:	89 d0                	mov    %edx,%eax
  801bf8:	31 d2                	xor    %edx,%edx
  801bfa:	83 c4 1c             	add    $0x1c,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5e                   	pop    %esi
  801bff:	5f                   	pop    %edi
  801c00:	5d                   	pop    %ebp
  801c01:	c3                   	ret    
  801c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c08:	39 f2                	cmp    %esi,%edx
  801c0a:	89 d0                	mov    %edx,%eax
  801c0c:	77 52                	ja     801c60 <__umoddi3+0xa0>
  801c0e:	0f bd ea             	bsr    %edx,%ebp
  801c11:	83 f5 1f             	xor    $0x1f,%ebp
  801c14:	75 5a                	jne    801c70 <__umoddi3+0xb0>
  801c16:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801c1a:	0f 82 e0 00 00 00    	jb     801d00 <__umoddi3+0x140>
  801c20:	39 0c 24             	cmp    %ecx,(%esp)
  801c23:	0f 86 d7 00 00 00    	jbe    801d00 <__umoddi3+0x140>
  801c29:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c31:	83 c4 1c             	add    $0x1c,%esp
  801c34:	5b                   	pop    %ebx
  801c35:	5e                   	pop    %esi
  801c36:	5f                   	pop    %edi
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    
  801c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c40:	85 ff                	test   %edi,%edi
  801c42:	89 fd                	mov    %edi,%ebp
  801c44:	75 0b                	jne    801c51 <__umoddi3+0x91>
  801c46:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4b:	31 d2                	xor    %edx,%edx
  801c4d:	f7 f7                	div    %edi
  801c4f:	89 c5                	mov    %eax,%ebp
  801c51:	89 f0                	mov    %esi,%eax
  801c53:	31 d2                	xor    %edx,%edx
  801c55:	f7 f5                	div    %ebp
  801c57:	89 c8                	mov    %ecx,%eax
  801c59:	f7 f5                	div    %ebp
  801c5b:	89 d0                	mov    %edx,%eax
  801c5d:	eb 99                	jmp    801bf8 <__umoddi3+0x38>
  801c5f:	90                   	nop
  801c60:	89 c8                	mov    %ecx,%eax
  801c62:	89 f2                	mov    %esi,%edx
  801c64:	83 c4 1c             	add    $0x1c,%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c70:	8b 34 24             	mov    (%esp),%esi
  801c73:	bf 20 00 00 00       	mov    $0x20,%edi
  801c78:	89 e9                	mov    %ebp,%ecx
  801c7a:	29 ef                	sub    %ebp,%edi
  801c7c:	d3 e0                	shl    %cl,%eax
  801c7e:	89 f9                	mov    %edi,%ecx
  801c80:	89 f2                	mov    %esi,%edx
  801c82:	d3 ea                	shr    %cl,%edx
  801c84:	89 e9                	mov    %ebp,%ecx
  801c86:	09 c2                	or     %eax,%edx
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	89 14 24             	mov    %edx,(%esp)
  801c8d:	89 f2                	mov    %esi,%edx
  801c8f:	d3 e2                	shl    %cl,%edx
  801c91:	89 f9                	mov    %edi,%ecx
  801c93:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c97:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801c9b:	d3 e8                	shr    %cl,%eax
  801c9d:	89 e9                	mov    %ebp,%ecx
  801c9f:	89 c6                	mov    %eax,%esi
  801ca1:	d3 e3                	shl    %cl,%ebx
  801ca3:	89 f9                	mov    %edi,%ecx
  801ca5:	89 d0                	mov    %edx,%eax
  801ca7:	d3 e8                	shr    %cl,%eax
  801ca9:	89 e9                	mov    %ebp,%ecx
  801cab:	09 d8                	or     %ebx,%eax
  801cad:	89 d3                	mov    %edx,%ebx
  801caf:	89 f2                	mov    %esi,%edx
  801cb1:	f7 34 24             	divl   (%esp)
  801cb4:	89 d6                	mov    %edx,%esi
  801cb6:	d3 e3                	shl    %cl,%ebx
  801cb8:	f7 64 24 04          	mull   0x4(%esp)
  801cbc:	39 d6                	cmp    %edx,%esi
  801cbe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cc2:	89 d1                	mov    %edx,%ecx
  801cc4:	89 c3                	mov    %eax,%ebx
  801cc6:	72 08                	jb     801cd0 <__umoddi3+0x110>
  801cc8:	75 11                	jne    801cdb <__umoddi3+0x11b>
  801cca:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801cce:	73 0b                	jae    801cdb <__umoddi3+0x11b>
  801cd0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801cd4:	1b 14 24             	sbb    (%esp),%edx
  801cd7:	89 d1                	mov    %edx,%ecx
  801cd9:	89 c3                	mov    %eax,%ebx
  801cdb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cdf:	29 da                	sub    %ebx,%edx
  801ce1:	19 ce                	sbb    %ecx,%esi
  801ce3:	89 f9                	mov    %edi,%ecx
  801ce5:	89 f0                	mov    %esi,%eax
  801ce7:	d3 e0                	shl    %cl,%eax
  801ce9:	89 e9                	mov    %ebp,%ecx
  801ceb:	d3 ea                	shr    %cl,%edx
  801ced:	89 e9                	mov    %ebp,%ecx
  801cef:	d3 ee                	shr    %cl,%esi
  801cf1:	09 d0                	or     %edx,%eax
  801cf3:	89 f2                	mov    %esi,%edx
  801cf5:	83 c4 1c             	add    $0x1c,%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
  801cfd:	8d 76 00             	lea    0x0(%esi),%esi
  801d00:	29 f9                	sub    %edi,%ecx
  801d02:	19 d6                	sbb    %edx,%esi
  801d04:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d08:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d0c:	e9 18 ff ff ff       	jmp    801c29 <__umoddi3+0x69>
