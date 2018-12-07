
obj/user/breakpoint.debug:     formato del fichero elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800041:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800044:	e8 0a 01 00 00       	call   800153 <sys_getenvid>
	if (id >= 0)
  800049:	85 c0                	test   %eax,%eax
  80004b:	78 12                	js     80005f <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80004d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800052:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800055:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005a:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005f:	85 db                	test   %ebx,%ebx
  800061:	7e 07                	jle    80006a <libmain+0x31>
		binaryname = argv[0];
  800063:	8b 06                	mov    (%esi),%eax
  800065:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	56                   	push   %esi
  80006e:	53                   	push   %ebx
  80006f:	e8 bf ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800074:	e8 0a 00 00 00       	call   800083 <exit>
}
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007f:	5b                   	pop    %ebx
  800080:	5e                   	pop    %esi
  800081:	5d                   	pop    %ebp
  800082:	c3                   	ret    

00800083 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800089:	e8 f8 03 00 00       	call   800486 <close_all>
	sys_env_destroy(0);
  80008e:	83 ec 0c             	sub    $0xc,%esp
  800091:	6a 00                	push   $0x0
  800093:	e8 99 00 00 00       	call   800131 <sys_env_destroy>
}
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	c9                   	leave  
  80009c:	c3                   	ret    

0080009d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80009d:	55                   	push   %ebp
  80009e:	89 e5                	mov    %esp,%ebp
  8000a0:	57                   	push   %edi
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
  8000a3:	83 ec 1c             	sub    $0x1c,%esp
  8000a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000ac:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000b4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000b7:	8b 75 14             	mov    0x14(%ebp),%esi
  8000ba:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c0:	74 1d                	je     8000df <syscall+0x42>
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	7e 19                	jle    8000df <syscall+0x42>
  8000c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000c9:	83 ec 0c             	sub    $0xc,%esp
  8000cc:	50                   	push   %eax
  8000cd:	52                   	push   %edx
  8000ce:	68 2a 1d 80 00       	push   $0x801d2a
  8000d3:	6a 23                	push   $0x23
  8000d5:	68 47 1d 80 00       	push   $0x801d47
  8000da:	e8 e9 0e 00 00       	call   800fc8 <_panic>

	return ret;
}
  8000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5f                   	pop    %edi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 0c             	pushl  0xc(%ebp)
  8000f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800103:	e8 95 ff ff ff       	call   80009d <syscall>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <sys_cgetc>:

int
sys_cgetc(void)
{
  80010d:	55                   	push   %ebp
  80010e:	89 e5                	mov    %esp,%ebp
  800110:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800113:	6a 00                	push   $0x0
  800115:	6a 00                	push   $0x0
  800117:	6a 00                	push   $0x0
  800119:	6a 00                	push   $0x0
  80011b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	b8 01 00 00 00       	mov    $0x1,%eax
  80012a:	e8 6e ff ff ff       	call   80009d <syscall>
}
  80012f:	c9                   	leave  
  800130:	c3                   	ret    

00800131 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800137:	6a 00                	push   $0x0
  800139:	6a 00                	push   $0x0
  80013b:	6a 00                	push   $0x0
  80013d:	6a 00                	push   $0x0
  80013f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800142:	ba 01 00 00 00       	mov    $0x1,%edx
  800147:	b8 03 00 00 00       	mov    $0x3,%eax
  80014c:	e8 4c ff ff ff       	call   80009d <syscall>
}
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800159:	6a 00                	push   $0x0
  80015b:	6a 00                	push   $0x0
  80015d:	6a 00                	push   $0x0
  80015f:	6a 00                	push   $0x0
  800161:	b9 00 00 00 00       	mov    $0x0,%ecx
  800166:	ba 00 00 00 00       	mov    $0x0,%edx
  80016b:	b8 02 00 00 00       	mov    $0x2,%eax
  800170:	e8 28 ff ff ff       	call   80009d <syscall>
}
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <sys_yield>:

void
sys_yield(void)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80017d:	6a 00                	push   $0x0
  80017f:	6a 00                	push   $0x0
  800181:	6a 00                	push   $0x0
  800183:	6a 00                	push   $0x0
  800185:	b9 00 00 00 00       	mov    $0x0,%ecx
  80018a:	ba 00 00 00 00       	mov    $0x0,%edx
  80018f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800194:	e8 04 ff ff ff       	call   80009d <syscall>
}
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001a4:	6a 00                	push   $0x0
  8001a6:	6a 00                	push   $0x0
  8001a8:	ff 75 10             	pushl  0x10(%ebp)
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b1:	ba 01 00 00 00       	mov    $0x1,%edx
  8001b6:	b8 04 00 00 00       	mov    $0x4,%eax
  8001bb:	e8 dd fe ff ff       	call   80009d <syscall>
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001c8:	ff 75 18             	pushl  0x18(%ebp)
  8001cb:	ff 75 14             	pushl  0x14(%ebp)
  8001ce:	ff 75 10             	pushl  0x10(%ebp)
  8001d1:	ff 75 0c             	pushl  0xc(%ebp)
  8001d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8001dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e1:	e8 b7 fe ff ff       	call   80009d <syscall>
}
  8001e6:	c9                   	leave  
  8001e7:	c3                   	ret    

008001e8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8001ee:	6a 00                	push   $0x0
  8001f0:	6a 00                	push   $0x0
  8001f2:	6a 00                	push   $0x0
  8001f4:	ff 75 0c             	pushl  0xc(%ebp)
  8001f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fa:	ba 01 00 00 00       	mov    $0x1,%edx
  8001ff:	b8 06 00 00 00       	mov    $0x6,%eax
  800204:	e8 94 fe ff ff       	call   80009d <syscall>
}
  800209:	c9                   	leave  
  80020a:	c3                   	ret    

0080020b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800211:	6a 00                	push   $0x0
  800213:	6a 00                	push   $0x0
  800215:	6a 00                	push   $0x0
  800217:	ff 75 0c             	pushl  0xc(%ebp)
  80021a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021d:	ba 01 00 00 00       	mov    $0x1,%edx
  800222:	b8 08 00 00 00       	mov    $0x8,%eax
  800227:	e8 71 fe ff ff       	call   80009d <syscall>
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800234:	6a 00                	push   $0x0
  800236:	6a 00                	push   $0x0
  800238:	6a 00                	push   $0x0
  80023a:	ff 75 0c             	pushl  0xc(%ebp)
  80023d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800240:	ba 01 00 00 00       	mov    $0x1,%edx
  800245:	b8 09 00 00 00       	mov    $0x9,%eax
  80024a:	e8 4e fe ff ff       	call   80009d <syscall>
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800257:	6a 00                	push   $0x0
  800259:	6a 00                	push   $0x0
  80025b:	6a 00                	push   $0x0
  80025d:	ff 75 0c             	pushl  0xc(%ebp)
  800260:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800263:	ba 01 00 00 00       	mov    $0x1,%edx
  800268:	b8 0a 00 00 00       	mov    $0xa,%eax
  80026d:	e8 2b fe ff ff       	call   80009d <syscall>
}
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  80027a:	6a 00                	push   $0x0
  80027c:	ff 75 14             	pushl  0x14(%ebp)
  80027f:	ff 75 10             	pushl  0x10(%ebp)
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800288:	ba 00 00 00 00       	mov    $0x0,%edx
  80028d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800292:	e8 06 fe ff ff       	call   80009d <syscall>
}
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  80029f:	6a 00                	push   $0x0
  8002a1:	6a 00                	push   $0x0
  8002a3:	6a 00                	push   $0x0
  8002a5:	6a 00                	push   $0x0
  8002a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002aa:	ba 01 00 00 00       	mov    $0x1,%edx
  8002af:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002b4:	e8 e4 fd ff ff       	call   80009d <syscall>
}
  8002b9:	c9                   	leave  
  8002ba:	c3                   	ret    

008002bb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	05 00 00 00 30       	add    $0x30000000,%eax
  8002c6:	c1 e8 0c             	shr    $0xc,%eax
}
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002ce:	ff 75 08             	pushl  0x8(%ebp)
  8002d1:	e8 e5 ff ff ff       	call   8002bb <fd2num>
  8002d6:	83 c4 04             	add    $0x4,%esp
  8002d9:	c1 e0 0c             	shl    $0xc,%eax
  8002dc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8002ee:	89 c2                	mov    %eax,%edx
  8002f0:	c1 ea 16             	shr    $0x16,%edx
  8002f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8002fa:	f6 c2 01             	test   $0x1,%dl
  8002fd:	74 11                	je     800310 <fd_alloc+0x2d>
  8002ff:	89 c2                	mov    %eax,%edx
  800301:	c1 ea 0c             	shr    $0xc,%edx
  800304:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80030b:	f6 c2 01             	test   $0x1,%dl
  80030e:	75 09                	jne    800319 <fd_alloc+0x36>
			*fd_store = fd;
  800310:	89 01                	mov    %eax,(%ecx)
			return 0;
  800312:	b8 00 00 00 00       	mov    $0x0,%eax
  800317:	eb 17                	jmp    800330 <fd_alloc+0x4d>
  800319:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80031e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800323:	75 c9                	jne    8002ee <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800325:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80032b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800338:	83 f8 1f             	cmp    $0x1f,%eax
  80033b:	77 36                	ja     800373 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80033d:	c1 e0 0c             	shl    $0xc,%eax
  800340:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800345:	89 c2                	mov    %eax,%edx
  800347:	c1 ea 16             	shr    $0x16,%edx
  80034a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800351:	f6 c2 01             	test   $0x1,%dl
  800354:	74 24                	je     80037a <fd_lookup+0x48>
  800356:	89 c2                	mov    %eax,%edx
  800358:	c1 ea 0c             	shr    $0xc,%edx
  80035b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800362:	f6 c2 01             	test   $0x1,%dl
  800365:	74 1a                	je     800381 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036a:	89 02                	mov    %eax,(%edx)
	return 0;
  80036c:	b8 00 00 00 00       	mov    $0x0,%eax
  800371:	eb 13                	jmp    800386 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800373:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800378:	eb 0c                	jmp    800386 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80037a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80037f:	eb 05                	jmp    800386 <fd_lookup+0x54>
  800381:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800391:	ba d4 1d 80 00       	mov    $0x801dd4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800396:	eb 13                	jmp    8003ab <dev_lookup+0x23>
  800398:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80039b:	39 08                	cmp    %ecx,(%eax)
  80039d:	75 0c                	jne    8003ab <dev_lookup+0x23>
			*dev = devtab[i];
  80039f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	eb 2e                	jmp    8003d9 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003ab:	8b 02                	mov    (%edx),%eax
  8003ad:	85 c0                	test   %eax,%eax
  8003af:	75 e7                	jne    800398 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8003b6:	8b 40 48             	mov    0x48(%eax),%eax
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	51                   	push   %ecx
  8003bd:	50                   	push   %eax
  8003be:	68 58 1d 80 00       	push   $0x801d58
  8003c3:	e8 d9 0c 00 00       	call   8010a1 <cprintf>
	*dev = 0;
  8003c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
  8003e0:	83 ec 10             	sub    $0x10,%esp
  8003e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8003e9:	56                   	push   %esi
  8003ea:	e8 cc fe ff ff       	call   8002bb <fd2num>
  8003ef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8003f2:	89 14 24             	mov    %edx,(%esp)
  8003f5:	50                   	push   %eax
  8003f6:	e8 37 ff ff ff       	call   800332 <fd_lookup>
  8003fb:	83 c4 08             	add    $0x8,%esp
  8003fe:	85 c0                	test   %eax,%eax
  800400:	78 05                	js     800407 <fd_close+0x2c>
	    || fd != fd2)
  800402:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800405:	74 0c                	je     800413 <fd_close+0x38>
		return (must_exist ? r : 0);
  800407:	84 db                	test   %bl,%bl
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
  80040e:	0f 44 c2             	cmove  %edx,%eax
  800411:	eb 41                	jmp    800454 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800419:	50                   	push   %eax
  80041a:	ff 36                	pushl  (%esi)
  80041c:	e8 67 ff ff ff       	call   800388 <dev_lookup>
  800421:	89 c3                	mov    %eax,%ebx
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	85 c0                	test   %eax,%eax
  800428:	78 1a                	js     800444 <fd_close+0x69>
		if (dev->dev_close)
  80042a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042d:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800430:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800435:	85 c0                	test   %eax,%eax
  800437:	74 0b                	je     800444 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800439:	83 ec 0c             	sub    $0xc,%esp
  80043c:	56                   	push   %esi
  80043d:	ff d0                	call   *%eax
  80043f:	89 c3                	mov    %eax,%ebx
  800441:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	56                   	push   %esi
  800448:	6a 00                	push   $0x0
  80044a:	e8 99 fd ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 d8                	mov    %ebx,%eax
}
  800454:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800457:	5b                   	pop    %ebx
  800458:	5e                   	pop    %esi
  800459:	5d                   	pop    %ebp
  80045a:	c3                   	ret    

0080045b <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800464:	50                   	push   %eax
  800465:	ff 75 08             	pushl  0x8(%ebp)
  800468:	e8 c5 fe ff ff       	call   800332 <fd_lookup>
  80046d:	83 c4 08             	add    $0x8,%esp
  800470:	85 c0                	test   %eax,%eax
  800472:	78 10                	js     800484 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	6a 01                	push   $0x1
  800479:	ff 75 f4             	pushl  -0xc(%ebp)
  80047c:	e8 5a ff ff ff       	call   8003db <fd_close>
  800481:	83 c4 10             	add    $0x10,%esp
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <close_all>:

void
close_all(void)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	53                   	push   %ebx
  80048a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80048d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800492:	83 ec 0c             	sub    $0xc,%esp
  800495:	53                   	push   %ebx
  800496:	e8 c0 ff ff ff       	call   80045b <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80049b:	83 c3 01             	add    $0x1,%ebx
  80049e:	83 c4 10             	add    $0x10,%esp
  8004a1:	83 fb 20             	cmp    $0x20,%ebx
  8004a4:	75 ec                	jne    800492 <close_all+0xc>
		close(i);
}
  8004a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a9:	c9                   	leave  
  8004aa:	c3                   	ret    

008004ab <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	57                   	push   %edi
  8004af:	56                   	push   %esi
  8004b0:	53                   	push   %ebx
  8004b1:	83 ec 2c             	sub    $0x2c,%esp
  8004b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004ba:	50                   	push   %eax
  8004bb:	ff 75 08             	pushl  0x8(%ebp)
  8004be:	e8 6f fe ff ff       	call   800332 <fd_lookup>
  8004c3:	83 c4 08             	add    $0x8,%esp
  8004c6:	85 c0                	test   %eax,%eax
  8004c8:	0f 88 c1 00 00 00    	js     80058f <dup+0xe4>
		return r;
	close(newfdnum);
  8004ce:	83 ec 0c             	sub    $0xc,%esp
  8004d1:	56                   	push   %esi
  8004d2:	e8 84 ff ff ff       	call   80045b <close>

	newfd = INDEX2FD(newfdnum);
  8004d7:	89 f3                	mov    %esi,%ebx
  8004d9:	c1 e3 0c             	shl    $0xc,%ebx
  8004dc:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8004e2:	83 c4 04             	add    $0x4,%esp
  8004e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004e8:	e8 de fd ff ff       	call   8002cb <fd2data>
  8004ed:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8004ef:	89 1c 24             	mov    %ebx,(%esp)
  8004f2:	e8 d4 fd ff ff       	call   8002cb <fd2data>
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8004fd:	89 f8                	mov    %edi,%eax
  8004ff:	c1 e8 16             	shr    $0x16,%eax
  800502:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800509:	a8 01                	test   $0x1,%al
  80050b:	74 37                	je     800544 <dup+0x99>
  80050d:	89 f8                	mov    %edi,%eax
  80050f:	c1 e8 0c             	shr    $0xc,%eax
  800512:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800519:	f6 c2 01             	test   $0x1,%dl
  80051c:	74 26                	je     800544 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80051e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800525:	83 ec 0c             	sub    $0xc,%esp
  800528:	25 07 0e 00 00       	and    $0xe07,%eax
  80052d:	50                   	push   %eax
  80052e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800531:	6a 00                	push   $0x0
  800533:	57                   	push   %edi
  800534:	6a 00                	push   $0x0
  800536:	e8 87 fc ff ff       	call   8001c2 <sys_page_map>
  80053b:	89 c7                	mov    %eax,%edi
  80053d:	83 c4 20             	add    $0x20,%esp
  800540:	85 c0                	test   %eax,%eax
  800542:	78 2e                	js     800572 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800544:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800547:	89 d0                	mov    %edx,%eax
  800549:	c1 e8 0c             	shr    $0xc,%eax
  80054c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	25 07 0e 00 00       	and    $0xe07,%eax
  80055b:	50                   	push   %eax
  80055c:	53                   	push   %ebx
  80055d:	6a 00                	push   $0x0
  80055f:	52                   	push   %edx
  800560:	6a 00                	push   $0x0
  800562:	e8 5b fc ff ff       	call   8001c2 <sys_page_map>
  800567:	89 c7                	mov    %eax,%edi
  800569:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80056c:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80056e:	85 ff                	test   %edi,%edi
  800570:	79 1d                	jns    80058f <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	53                   	push   %ebx
  800576:	6a 00                	push   $0x0
  800578:	e8 6b fc ff ff       	call   8001e8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80057d:	83 c4 08             	add    $0x8,%esp
  800580:	ff 75 d4             	pushl  -0x2c(%ebp)
  800583:	6a 00                	push   $0x0
  800585:	e8 5e fc ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	89 f8                	mov    %edi,%eax
}
  80058f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800592:	5b                   	pop    %ebx
  800593:	5e                   	pop    %esi
  800594:	5f                   	pop    %edi
  800595:	5d                   	pop    %ebp
  800596:	c3                   	ret    

00800597 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	53                   	push   %ebx
  80059b:	83 ec 14             	sub    $0x14,%esp
  80059e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005a4:	50                   	push   %eax
  8005a5:	53                   	push   %ebx
  8005a6:	e8 87 fd ff ff       	call   800332 <fd_lookup>
  8005ab:	83 c4 08             	add    $0x8,%esp
  8005ae:	89 c2                	mov    %eax,%edx
  8005b0:	85 c0                	test   %eax,%eax
  8005b2:	78 6d                	js     800621 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005ba:	50                   	push   %eax
  8005bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005be:	ff 30                	pushl  (%eax)
  8005c0:	e8 c3 fd ff ff       	call   800388 <dev_lookup>
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	85 c0                	test   %eax,%eax
  8005ca:	78 4c                	js     800618 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005cf:	8b 42 08             	mov    0x8(%edx),%eax
  8005d2:	83 e0 03             	and    $0x3,%eax
  8005d5:	83 f8 01             	cmp    $0x1,%eax
  8005d8:	75 21                	jne    8005fb <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8005da:	a1 04 40 80 00       	mov    0x804004,%eax
  8005df:	8b 40 48             	mov    0x48(%eax),%eax
  8005e2:	83 ec 04             	sub    $0x4,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	50                   	push   %eax
  8005e7:	68 99 1d 80 00       	push   $0x801d99
  8005ec:	e8 b0 0a 00 00       	call   8010a1 <cprintf>
		return -E_INVAL;
  8005f1:	83 c4 10             	add    $0x10,%esp
  8005f4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8005f9:	eb 26                	jmp    800621 <read+0x8a>
	}
	if (!dev->dev_read)
  8005fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fe:	8b 40 08             	mov    0x8(%eax),%eax
  800601:	85 c0                	test   %eax,%eax
  800603:	74 17                	je     80061c <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800605:	83 ec 04             	sub    $0x4,%esp
  800608:	ff 75 10             	pushl  0x10(%ebp)
  80060b:	ff 75 0c             	pushl  0xc(%ebp)
  80060e:	52                   	push   %edx
  80060f:	ff d0                	call   *%eax
  800611:	89 c2                	mov    %eax,%edx
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	eb 09                	jmp    800621 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800618:	89 c2                	mov    %eax,%edx
  80061a:	eb 05                	jmp    800621 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80061c:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800621:	89 d0                	mov    %edx,%eax
  800623:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800626:	c9                   	leave  
  800627:	c3                   	ret    

00800628 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	57                   	push   %edi
  80062c:	56                   	push   %esi
  80062d:	53                   	push   %ebx
  80062e:	83 ec 0c             	sub    $0xc,%esp
  800631:	8b 7d 08             	mov    0x8(%ebp),%edi
  800634:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800637:	bb 00 00 00 00       	mov    $0x0,%ebx
  80063c:	eb 21                	jmp    80065f <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80063e:	83 ec 04             	sub    $0x4,%esp
  800641:	89 f0                	mov    %esi,%eax
  800643:	29 d8                	sub    %ebx,%eax
  800645:	50                   	push   %eax
  800646:	89 d8                	mov    %ebx,%eax
  800648:	03 45 0c             	add    0xc(%ebp),%eax
  80064b:	50                   	push   %eax
  80064c:	57                   	push   %edi
  80064d:	e8 45 ff ff ff       	call   800597 <read>
		if (m < 0)
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	85 c0                	test   %eax,%eax
  800657:	78 10                	js     800669 <readn+0x41>
			return m;
		if (m == 0)
  800659:	85 c0                	test   %eax,%eax
  80065b:	74 0a                	je     800667 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80065d:	01 c3                	add    %eax,%ebx
  80065f:	39 f3                	cmp    %esi,%ebx
  800661:	72 db                	jb     80063e <readn+0x16>
  800663:	89 d8                	mov    %ebx,%eax
  800665:	eb 02                	jmp    800669 <readn+0x41>
  800667:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800669:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066c:	5b                   	pop    %ebx
  80066d:	5e                   	pop    %esi
  80066e:	5f                   	pop    %edi
  80066f:	5d                   	pop    %ebp
  800670:	c3                   	ret    

00800671 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	53                   	push   %ebx
  800675:	83 ec 14             	sub    $0x14,%esp
  800678:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80067b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80067e:	50                   	push   %eax
  80067f:	53                   	push   %ebx
  800680:	e8 ad fc ff ff       	call   800332 <fd_lookup>
  800685:	83 c4 08             	add    $0x8,%esp
  800688:	89 c2                	mov    %eax,%edx
  80068a:	85 c0                	test   %eax,%eax
  80068c:	78 68                	js     8006f6 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800694:	50                   	push   %eax
  800695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800698:	ff 30                	pushl  (%eax)
  80069a:	e8 e9 fc ff ff       	call   800388 <dev_lookup>
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	85 c0                	test   %eax,%eax
  8006a4:	78 47                	js     8006ed <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006ad:	75 21                	jne    8006d0 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006af:	a1 04 40 80 00       	mov    0x804004,%eax
  8006b4:	8b 40 48             	mov    0x48(%eax),%eax
  8006b7:	83 ec 04             	sub    $0x4,%esp
  8006ba:	53                   	push   %ebx
  8006bb:	50                   	push   %eax
  8006bc:	68 b5 1d 80 00       	push   $0x801db5
  8006c1:	e8 db 09 00 00       	call   8010a1 <cprintf>
		return -E_INVAL;
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006ce:	eb 26                	jmp    8006f6 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d3:	8b 52 0c             	mov    0xc(%edx),%edx
  8006d6:	85 d2                	test   %edx,%edx
  8006d8:	74 17                	je     8006f1 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	ff 75 10             	pushl  0x10(%ebp)
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	50                   	push   %eax
  8006e4:	ff d2                	call   *%edx
  8006e6:	89 c2                	mov    %eax,%edx
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	eb 09                	jmp    8006f6 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ed:	89 c2                	mov    %eax,%edx
  8006ef:	eb 05                	jmp    8006f6 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8006f1:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8006f6:	89 d0                	mov    %edx,%eax
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <seek>:

int
seek(int fdnum, off_t offset)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800703:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	ff 75 08             	pushl  0x8(%ebp)
  80070a:	e8 23 fc ff ff       	call   800332 <fd_lookup>
  80070f:	83 c4 08             	add    $0x8,%esp
  800712:	85 c0                	test   %eax,%eax
  800714:	78 0e                	js     800724 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800716:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80071f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	53                   	push   %ebx
  80072a:	83 ec 14             	sub    $0x14,%esp
  80072d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800730:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	53                   	push   %ebx
  800735:	e8 f8 fb ff ff       	call   800332 <fd_lookup>
  80073a:	83 c4 08             	add    $0x8,%esp
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	85 c0                	test   %eax,%eax
  800741:	78 65                	js     8007a8 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074d:	ff 30                	pushl  (%eax)
  80074f:	e8 34 fc ff ff       	call   800388 <dev_lookup>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	85 c0                	test   %eax,%eax
  800759:	78 44                	js     80079f <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800762:	75 21                	jne    800785 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800764:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800769:	8b 40 48             	mov    0x48(%eax),%eax
  80076c:	83 ec 04             	sub    $0x4,%esp
  80076f:	53                   	push   %ebx
  800770:	50                   	push   %eax
  800771:	68 78 1d 80 00       	push   $0x801d78
  800776:	e8 26 09 00 00       	call   8010a1 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800783:	eb 23                	jmp    8007a8 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  800785:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800788:	8b 52 18             	mov    0x18(%edx),%edx
  80078b:	85 d2                	test   %edx,%edx
  80078d:	74 14                	je     8007a3 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	50                   	push   %eax
  800796:	ff d2                	call   *%edx
  800798:	89 c2                	mov    %eax,%edx
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	eb 09                	jmp    8007a8 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	eb 05                	jmp    8007a8 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007a3:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007a8:	89 d0                	mov    %edx,%eax
  8007aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ad:	c9                   	leave  
  8007ae:	c3                   	ret    

008007af <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	53                   	push   %ebx
  8007b3:	83 ec 14             	sub    $0x14,%esp
  8007b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	ff 75 08             	pushl  0x8(%ebp)
  8007c0:	e8 6d fb ff ff       	call   800332 <fd_lookup>
  8007c5:	83 c4 08             	add    $0x8,%esp
  8007c8:	89 c2                	mov    %eax,%edx
  8007ca:	85 c0                	test   %eax,%eax
  8007cc:	78 58                	js     800826 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d4:	50                   	push   %eax
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d8:	ff 30                	pushl  (%eax)
  8007da:	e8 a9 fb ff ff       	call   800388 <dev_lookup>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	85 c0                	test   %eax,%eax
  8007e4:	78 37                	js     80081d <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8007ed:	74 32                	je     800821 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8007ef:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8007f2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8007f9:	00 00 00 
	stat->st_isdir = 0;
  8007fc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800803:	00 00 00 
	stat->st_dev = dev;
  800806:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	53                   	push   %ebx
  800810:	ff 75 f0             	pushl  -0x10(%ebp)
  800813:	ff 50 14             	call   *0x14(%eax)
  800816:	89 c2                	mov    %eax,%edx
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	eb 09                	jmp    800826 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	eb 05                	jmp    800826 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800821:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800826:	89 d0                	mov    %edx,%eax
  800828:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082b:	c9                   	leave  
  80082c:	c3                   	ret    

0080082d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	56                   	push   %esi
  800831:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	6a 00                	push   $0x0
  800837:	ff 75 08             	pushl  0x8(%ebp)
  80083a:	e8 06 02 00 00       	call   800a45 <open>
  80083f:	89 c3                	mov    %eax,%ebx
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	85 c0                	test   %eax,%eax
  800846:	78 1b                	js     800863 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	50                   	push   %eax
  80084f:	e8 5b ff ff ff       	call   8007af <fstat>
  800854:	89 c6                	mov    %eax,%esi
	close(fd);
  800856:	89 1c 24             	mov    %ebx,(%esp)
  800859:	e8 fd fb ff ff       	call   80045b <close>
	return r;
  80085e:	83 c4 10             	add    $0x10,%esp
  800861:	89 f0                	mov    %esi,%eax
}
  800863:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800866:	5b                   	pop    %ebx
  800867:	5e                   	pop    %esi
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	89 c6                	mov    %eax,%esi
  800871:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800873:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80087a:	75 12                	jne    80088e <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80087c:	83 ec 0c             	sub    $0xc,%esp
  80087f:	6a 01                	push   $0x1
  800881:	e8 94 11 00 00       	call   801a1a <ipc_find_env>
  800886:	a3 00 40 80 00       	mov    %eax,0x804000
  80088b:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80088e:	6a 07                	push   $0x7
  800890:	68 00 50 80 00       	push   $0x805000
  800895:	56                   	push   %esi
  800896:	ff 35 00 40 80 00    	pushl  0x804000
  80089c:	e8 25 11 00 00       	call   8019c6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008a1:	83 c4 0c             	add    $0xc,%esp
  8008a4:	6a 00                	push   $0x0
  8008a6:	53                   	push   %ebx
  8008a7:	6a 00                	push   $0x0
  8008a9:	e8 ad 10 00 00       	call   80195b <ipc_recv>
}
  8008ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 40 0c             	mov    0xc(%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	b8 02 00 00 00       	mov    $0x2,%eax
  8008d8:	e8 8d ff ff ff       	call   80086a <fsipc>
}
  8008dd:	c9                   	leave  
  8008de:	c3                   	ret    

008008df <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8008eb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8008f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f5:	b8 06 00 00 00       	mov    $0x6,%eax
  8008fa:	e8 6b ff ff ff       	call   80086a <fsipc>
}
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	53                   	push   %ebx
  800905:	83 ec 04             	sub    $0x4,%esp
  800908:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 40 0c             	mov    0xc(%eax),%eax
  800911:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800916:	ba 00 00 00 00       	mov    $0x0,%edx
  80091b:	b8 05 00 00 00       	mov    $0x5,%eax
  800920:	e8 45 ff ff ff       	call   80086a <fsipc>
  800925:	85 c0                	test   %eax,%eax
  800927:	78 2c                	js     800955 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	68 00 50 80 00       	push   $0x805000
  800931:	53                   	push   %ebx
  800932:	e8 dc 0c 00 00       	call   801613 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800937:	a1 80 50 80 00       	mov    0x805080,%eax
  80093c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800942:	a1 84 50 80 00       	mov    0x805084,%eax
  800947:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
  800963:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800969:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80096c:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  800972:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800977:	76 22                	jbe    80099b <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  800979:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  800980:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  800983:	83 ec 04             	sub    $0x4,%esp
  800986:	68 f8 0f 00 00       	push   $0xff8
  80098b:	52                   	push   %edx
  80098c:	68 08 50 80 00       	push   $0x805008
  800991:	e8 10 0e 00 00       	call   8017a6 <memmove>
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	eb 17                	jmp    8009b2 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80099b:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	52                   	push   %edx
  8009a5:	68 08 50 80 00       	push   $0x805008
  8009aa:	e8 f7 0d 00 00       	call   8017a6 <memmove>
  8009af:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b7:	b8 04 00 00 00       	mov    $0x4,%eax
  8009bc:	e8 a9 fe ff ff       	call   80086a <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009c1:	c9                   	leave  
  8009c2:	c3                   	ret    

008009c3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	56                   	push   %esi
  8009c7:	53                   	push   %ebx
  8009c8:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8009d1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8009d6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8009dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8009e6:	e8 7f fe ff ff       	call   80086a <fsipc>
  8009eb:	89 c3                	mov    %eax,%ebx
  8009ed:	85 c0                	test   %eax,%eax
  8009ef:	78 4b                	js     800a3c <devfile_read+0x79>
		return r;
	assert(r <= n);
  8009f1:	39 c6                	cmp    %eax,%esi
  8009f3:	73 16                	jae    800a0b <devfile_read+0x48>
  8009f5:	68 e4 1d 80 00       	push   $0x801de4
  8009fa:	68 eb 1d 80 00       	push   $0x801deb
  8009ff:	6a 7c                	push   $0x7c
  800a01:	68 00 1e 80 00       	push   $0x801e00
  800a06:	e8 bd 05 00 00       	call   800fc8 <_panic>
	assert(r <= PGSIZE);
  800a0b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a10:	7e 16                	jle    800a28 <devfile_read+0x65>
  800a12:	68 0b 1e 80 00       	push   $0x801e0b
  800a17:	68 eb 1d 80 00       	push   $0x801deb
  800a1c:	6a 7d                	push   $0x7d
  800a1e:	68 00 1e 80 00       	push   $0x801e00
  800a23:	e8 a0 05 00 00       	call   800fc8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	50                   	push   %eax
  800a2c:	68 00 50 80 00       	push   $0x805000
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	e8 6d 0d 00 00       	call   8017a6 <memmove>
	return r;
  800a39:	83 c4 10             	add    $0x10,%esp
}
  800a3c:	89 d8                	mov    %ebx,%eax
  800a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a41:	5b                   	pop    %ebx
  800a42:	5e                   	pop    %esi
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	53                   	push   %ebx
  800a49:	83 ec 20             	sub    $0x20,%esp
  800a4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a4f:	53                   	push   %ebx
  800a50:	e8 85 0b 00 00       	call   8015da <strlen>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a5d:	7f 67                	jg     800ac6 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a5f:	83 ec 0c             	sub    $0xc,%esp
  800a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	e8 78 f8 ff ff       	call   8002e3 <fd_alloc>
  800a6b:	83 c4 10             	add    $0x10,%esp
		return r;
  800a6e:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a70:	85 c0                	test   %eax,%eax
  800a72:	78 57                	js     800acb <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	53                   	push   %ebx
  800a78:	68 00 50 80 00       	push   $0x805000
  800a7d:	e8 91 0b 00 00       	call   801613 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  800a92:	e8 d3 fd ff ff       	call   80086a <fsipc>
  800a97:	89 c3                	mov    %eax,%ebx
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	85 c0                	test   %eax,%eax
  800a9e:	79 14                	jns    800ab4 <open+0x6f>
		fd_close(fd, 0);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	6a 00                	push   $0x0
  800aa5:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa8:	e8 2e f9 ff ff       	call   8003db <fd_close>
		return r;
  800aad:	83 c4 10             	add    $0x10,%esp
  800ab0:	89 da                	mov    %ebx,%edx
  800ab2:	eb 17                	jmp    800acb <open+0x86>
	}

	return fd2num(fd);
  800ab4:	83 ec 0c             	sub    $0xc,%esp
  800ab7:	ff 75 f4             	pushl  -0xc(%ebp)
  800aba:	e8 fc f7 ff ff       	call   8002bb <fd2num>
  800abf:	89 c2                	mov    %eax,%edx
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	eb 05                	jmp    800acb <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800ac6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800acb:	89 d0                	mov    %edx,%eax
  800acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    

00800ad2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  800add:	b8 08 00 00 00       	mov    $0x8,%eax
  800ae2:	e8 83 fd ff ff       	call   80086a <fsipc>
}
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800af1:	83 ec 0c             	sub    $0xc,%esp
  800af4:	ff 75 08             	pushl  0x8(%ebp)
  800af7:	e8 cf f7 ff ff       	call   8002cb <fd2data>
  800afc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800afe:	83 c4 08             	add    $0x8,%esp
  800b01:	68 17 1e 80 00       	push   $0x801e17
  800b06:	53                   	push   %ebx
  800b07:	e8 07 0b 00 00       	call   801613 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b0c:	8b 46 04             	mov    0x4(%esi),%eax
  800b0f:	2b 06                	sub    (%esi),%eax
  800b11:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b17:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b1e:	00 00 00 
	stat->st_dev = &devpipe;
  800b21:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b28:	30 80 00 
	return 0;
}
  800b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	53                   	push   %ebx
  800b3b:	83 ec 0c             	sub    $0xc,%esp
  800b3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b41:	53                   	push   %ebx
  800b42:	6a 00                	push   $0x0
  800b44:	e8 9f f6 ff ff       	call   8001e8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b49:	89 1c 24             	mov    %ebx,(%esp)
  800b4c:	e8 7a f7 ff ff       	call   8002cb <fd2data>
  800b51:	83 c4 08             	add    $0x8,%esp
  800b54:	50                   	push   %eax
  800b55:	6a 00                	push   $0x0
  800b57:	e8 8c f6 ff ff       	call   8001e8 <sys_page_unmap>
}
  800b5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
  800b67:	83 ec 1c             	sub    $0x1c,%esp
  800b6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b6d:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b6f:	a1 04 40 80 00       	mov    0x804004,%eax
  800b74:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800b77:	83 ec 0c             	sub    $0xc,%esp
  800b7a:	ff 75 e0             	pushl  -0x20(%ebp)
  800b7d:	e8 d1 0e 00 00       	call   801a53 <pageref>
  800b82:	89 c3                	mov    %eax,%ebx
  800b84:	89 3c 24             	mov    %edi,(%esp)
  800b87:	e8 c7 0e 00 00       	call   801a53 <pageref>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	39 c3                	cmp    %eax,%ebx
  800b91:	0f 94 c1             	sete   %cl
  800b94:	0f b6 c9             	movzbl %cl,%ecx
  800b97:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800b9a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ba0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800ba3:	39 ce                	cmp    %ecx,%esi
  800ba5:	74 1b                	je     800bc2 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800ba7:	39 c3                	cmp    %eax,%ebx
  800ba9:	75 c4                	jne    800b6f <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bab:	8b 42 58             	mov    0x58(%edx),%eax
  800bae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb1:	50                   	push   %eax
  800bb2:	56                   	push   %esi
  800bb3:	68 1e 1e 80 00       	push   $0x801e1e
  800bb8:	e8 e4 04 00 00       	call   8010a1 <cprintf>
  800bbd:	83 c4 10             	add    $0x10,%esp
  800bc0:	eb ad                	jmp    800b6f <_pipeisclosed+0xe>
	}
}
  800bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	83 ec 28             	sub    $0x28,%esp
  800bd6:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800bd9:	56                   	push   %esi
  800bda:	e8 ec f6 ff ff       	call   8002cb <fd2data>
  800bdf:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	bf 00 00 00 00       	mov    $0x0,%edi
  800be9:	eb 4b                	jmp    800c36 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800beb:	89 da                	mov    %ebx,%edx
  800bed:	89 f0                	mov    %esi,%eax
  800bef:	e8 6d ff ff ff       	call   800b61 <_pipeisclosed>
  800bf4:	85 c0                	test   %eax,%eax
  800bf6:	75 48                	jne    800c40 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800bf8:	e8 7a f5 ff ff       	call   800177 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800bfd:	8b 43 04             	mov    0x4(%ebx),%eax
  800c00:	8b 0b                	mov    (%ebx),%ecx
  800c02:	8d 51 20             	lea    0x20(%ecx),%edx
  800c05:	39 d0                	cmp    %edx,%eax
  800c07:	73 e2                	jae    800beb <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c10:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c13:	89 c2                	mov    %eax,%edx
  800c15:	c1 fa 1f             	sar    $0x1f,%edx
  800c18:	89 d1                	mov    %edx,%ecx
  800c1a:	c1 e9 1b             	shr    $0x1b,%ecx
  800c1d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c20:	83 e2 1f             	and    $0x1f,%edx
  800c23:	29 ca                	sub    %ecx,%edx
  800c25:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c29:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c2d:	83 c0 01             	add    $0x1,%eax
  800c30:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c33:	83 c7 01             	add    $0x1,%edi
  800c36:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c39:	75 c2                	jne    800bfd <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	eb 05                	jmp    800c45 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c40:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
  800c53:	83 ec 18             	sub    $0x18,%esp
  800c56:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c59:	57                   	push   %edi
  800c5a:	e8 6c f6 ff ff       	call   8002cb <fd2data>
  800c5f:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c61:	83 c4 10             	add    $0x10,%esp
  800c64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c69:	eb 3d                	jmp    800ca8 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c6b:	85 db                	test   %ebx,%ebx
  800c6d:	74 04                	je     800c73 <devpipe_read+0x26>
				return i;
  800c6f:	89 d8                	mov    %ebx,%eax
  800c71:	eb 44                	jmp    800cb7 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c73:	89 f2                	mov    %esi,%edx
  800c75:	89 f8                	mov    %edi,%eax
  800c77:	e8 e5 fe ff ff       	call   800b61 <_pipeisclosed>
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	75 32                	jne    800cb2 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800c80:	e8 f2 f4 ff ff       	call   800177 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800c85:	8b 06                	mov    (%esi),%eax
  800c87:	3b 46 04             	cmp    0x4(%esi),%eax
  800c8a:	74 df                	je     800c6b <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800c8c:	99                   	cltd   
  800c8d:	c1 ea 1b             	shr    $0x1b,%edx
  800c90:	01 d0                	add    %edx,%eax
  800c92:	83 e0 1f             	and    $0x1f,%eax
  800c95:	29 d0                	sub    %edx,%eax
  800c97:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800ca2:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ca5:	83 c3 01             	add    $0x1,%ebx
  800ca8:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cab:	75 d8                	jne    800c85 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cad:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb0:	eb 05                	jmp    800cb7 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cb2:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cba:	5b                   	pop    %ebx
  800cbb:	5e                   	pop    %esi
  800cbc:	5f                   	pop    %edi
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    

00800cbf <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800cc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cca:	50                   	push   %eax
  800ccb:	e8 13 f6 ff ff       	call   8002e3 <fd_alloc>
  800cd0:	83 c4 10             	add    $0x10,%esp
  800cd3:	89 c2                	mov    %eax,%edx
  800cd5:	85 c0                	test   %eax,%eax
  800cd7:	0f 88 2c 01 00 00    	js     800e09 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800cdd:	83 ec 04             	sub    $0x4,%esp
  800ce0:	68 07 04 00 00       	push   $0x407
  800ce5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce8:	6a 00                	push   $0x0
  800cea:	e8 af f4 ff ff       	call   80019e <sys_page_alloc>
  800cef:	83 c4 10             	add    $0x10,%esp
  800cf2:	89 c2                	mov    %eax,%edx
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	0f 88 0d 01 00 00    	js     800e09 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d02:	50                   	push   %eax
  800d03:	e8 db f5 ff ff       	call   8002e3 <fd_alloc>
  800d08:	89 c3                	mov    %eax,%ebx
  800d0a:	83 c4 10             	add    $0x10,%esp
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	0f 88 e2 00 00 00    	js     800df7 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d15:	83 ec 04             	sub    $0x4,%esp
  800d18:	68 07 04 00 00       	push   $0x407
  800d1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d20:	6a 00                	push   $0x0
  800d22:	e8 77 f4 ff ff       	call   80019e <sys_page_alloc>
  800d27:	89 c3                	mov    %eax,%ebx
  800d29:	83 c4 10             	add    $0x10,%esp
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	0f 88 c3 00 00 00    	js     800df7 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d34:	83 ec 0c             	sub    $0xc,%esp
  800d37:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3a:	e8 8c f5 ff ff       	call   8002cb <fd2data>
  800d3f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d41:	83 c4 0c             	add    $0xc,%esp
  800d44:	68 07 04 00 00       	push   $0x407
  800d49:	50                   	push   %eax
  800d4a:	6a 00                	push   $0x0
  800d4c:	e8 4d f4 ff ff       	call   80019e <sys_page_alloc>
  800d51:	89 c3                	mov    %eax,%ebx
  800d53:	83 c4 10             	add    $0x10,%esp
  800d56:	85 c0                	test   %eax,%eax
  800d58:	0f 88 89 00 00 00    	js     800de7 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	ff 75 f0             	pushl  -0x10(%ebp)
  800d64:	e8 62 f5 ff ff       	call   8002cb <fd2data>
  800d69:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d70:	50                   	push   %eax
  800d71:	6a 00                	push   $0x0
  800d73:	56                   	push   %esi
  800d74:	6a 00                	push   $0x0
  800d76:	e8 47 f4 ff ff       	call   8001c2 <sys_page_map>
  800d7b:	89 c3                	mov    %eax,%ebx
  800d7d:	83 c4 20             	add    $0x20,%esp
  800d80:	85 c0                	test   %eax,%eax
  800d82:	78 55                	js     800dd9 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800d84:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800d99:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800dae:	83 ec 0c             	sub    $0xc,%esp
  800db1:	ff 75 f4             	pushl  -0xc(%ebp)
  800db4:	e8 02 f5 ff ff       	call   8002bb <fd2num>
  800db9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dbe:	83 c4 04             	add    $0x4,%esp
  800dc1:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc4:	e8 f2 f4 ff ff       	call   8002bb <fd2num>
  800dc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dcc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800dcf:	83 c4 10             	add    $0x10,%esp
  800dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd7:	eb 30                	jmp    800e09 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	56                   	push   %esi
  800ddd:	6a 00                	push   $0x0
  800ddf:	e8 04 f4 ff ff       	call   8001e8 <sys_page_unmap>
  800de4:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 f0             	pushl  -0x10(%ebp)
  800ded:	6a 00                	push   $0x0
  800def:	e8 f4 f3 ff ff       	call   8001e8 <sys_page_unmap>
  800df4:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800df7:	83 ec 08             	sub    $0x8,%esp
  800dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfd:	6a 00                	push   $0x0
  800dff:	e8 e4 f3 ff ff       	call   8001e8 <sys_page_unmap>
  800e04:	83 c4 10             	add    $0x10,%esp
  800e07:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e09:	89 d0                	mov    %edx,%eax
  800e0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 08             	pushl  0x8(%ebp)
  800e1f:	e8 0e f5 ff ff       	call   800332 <fd_lookup>
  800e24:	83 c4 10             	add    $0x10,%esp
  800e27:	85 c0                	test   %eax,%eax
  800e29:	78 18                	js     800e43 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e31:	e8 95 f4 ff ff       	call   8002cb <fd2data>
	return _pipeisclosed(fd, p);
  800e36:	89 c2                	mov    %eax,%edx
  800e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3b:	e8 21 fd ff ff       	call   800b61 <_pipeisclosed>
  800e40:	83 c4 10             	add    $0x10,%esp
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e55:	68 36 1e 80 00       	push   $0x801e36
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	e8 b1 07 00 00       	call   801613 <strcpy>
	return 0;
}
  800e62:	b8 00 00 00 00       	mov    $0x0,%eax
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e75:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e7a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e80:	eb 2d                	jmp    800eaf <devcons_write+0x46>
		m = n - tot;
  800e82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e85:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800e87:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800e8a:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800e8f:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e92:	83 ec 04             	sub    $0x4,%esp
  800e95:	53                   	push   %ebx
  800e96:	03 45 0c             	add    0xc(%ebp),%eax
  800e99:	50                   	push   %eax
  800e9a:	57                   	push   %edi
  800e9b:	e8 06 09 00 00       	call   8017a6 <memmove>
		sys_cputs(buf, m);
  800ea0:	83 c4 08             	add    $0x8,%esp
  800ea3:	53                   	push   %ebx
  800ea4:	57                   	push   %edi
  800ea5:	e8 3d f2 ff ff       	call   8000e7 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800eaa:	01 de                	add    %ebx,%esi
  800eac:	83 c4 10             	add    $0x10,%esp
  800eaf:	89 f0                	mov    %esi,%eax
  800eb1:	3b 75 10             	cmp    0x10(%ebp),%esi
  800eb4:	72 cc                	jb     800e82 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	74 2a                	je     800ef9 <devcons_read+0x3b>
  800ecf:	eb 05                	jmp    800ed6 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800ed1:	e8 a1 f2 ff ff       	call   800177 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800ed6:	e8 32 f2 ff ff       	call   80010d <sys_cgetc>
  800edb:	85 c0                	test   %eax,%eax
  800edd:	74 f2                	je     800ed1 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	78 16                	js     800ef9 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800ee3:	83 f8 04             	cmp    $0x4,%eax
  800ee6:	74 0c                	je     800ef4 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eeb:	88 02                	mov    %al,(%edx)
	return 1;
  800eed:	b8 01 00 00 00       	mov    $0x1,%eax
  800ef2:	eb 05                	jmp    800ef9 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800ef4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f07:	6a 01                	push   $0x1
  800f09:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f0c:	50                   	push   %eax
  800f0d:	e8 d5 f1 ff ff       	call   8000e7 <sys_cputs>
}
  800f12:	83 c4 10             	add    $0x10,%esp
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    

00800f17 <getchar>:

int
getchar(void)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f1d:	6a 01                	push   $0x1
  800f1f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f22:	50                   	push   %eax
  800f23:	6a 00                	push   $0x0
  800f25:	e8 6d f6 ff ff       	call   800597 <read>
	if (r < 0)
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	78 0f                	js     800f40 <getchar+0x29>
		return r;
	if (r < 1)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7e 06                	jle    800f3b <getchar+0x24>
		return -E_EOF;
	return c;
  800f35:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f39:	eb 05                	jmp    800f40 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f3b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f40:	c9                   	leave  
  800f41:	c3                   	ret    

00800f42 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 08             	pushl  0x8(%ebp)
  800f4f:	e8 de f3 ff ff       	call   800332 <fd_lookup>
  800f54:	83 c4 10             	add    $0x10,%esp
  800f57:	85 c0                	test   %eax,%eax
  800f59:	78 11                	js     800f6c <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f5e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800f64:	39 10                	cmp    %edx,(%eax)
  800f66:	0f 94 c0             	sete   %al
  800f69:	0f b6 c0             	movzbl %al,%eax
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <opencons>:

int
opencons(void)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f77:	50                   	push   %eax
  800f78:	e8 66 f3 ff ff       	call   8002e3 <fd_alloc>
  800f7d:	83 c4 10             	add    $0x10,%esp
		return r;
  800f80:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	78 3e                	js     800fc4 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	68 07 04 00 00       	push   $0x407
  800f8e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f91:	6a 00                	push   $0x0
  800f93:	e8 06 f2 ff ff       	call   80019e <sys_page_alloc>
  800f98:	83 c4 10             	add    $0x10,%esp
		return r;
  800f9b:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	78 23                	js     800fc4 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800fa1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800faa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800faf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	50                   	push   %eax
  800fba:	e8 fc f2 ff ff       	call   8002bb <fd2num>
  800fbf:	89 c2                	mov    %eax,%edx
  800fc1:	83 c4 10             	add    $0x10,%esp
}
  800fc4:	89 d0                	mov    %edx,%eax
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fcd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fd0:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800fd6:	e8 78 f1 ff ff       	call   800153 <sys_getenvid>
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	ff 75 0c             	pushl  0xc(%ebp)
  800fe1:	ff 75 08             	pushl  0x8(%ebp)
  800fe4:	56                   	push   %esi
  800fe5:	50                   	push   %eax
  800fe6:	68 44 1e 80 00       	push   $0x801e44
  800feb:	e8 b1 00 00 00       	call   8010a1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ff0:	83 c4 18             	add    $0x18,%esp
  800ff3:	53                   	push   %ebx
  800ff4:	ff 75 10             	pushl  0x10(%ebp)
  800ff7:	e8 54 00 00 00       	call   801050 <vcprintf>
	cprintf("\n");
  800ffc:	c7 04 24 2f 1e 80 00 	movl   $0x801e2f,(%esp)
  801003:	e8 99 00 00 00       	call   8010a1 <cprintf>
  801008:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80100b:	cc                   	int3   
  80100c:	eb fd                	jmp    80100b <_panic+0x43>

0080100e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	53                   	push   %ebx
  801012:	83 ec 04             	sub    $0x4,%esp
  801015:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801018:	8b 13                	mov    (%ebx),%edx
  80101a:	8d 42 01             	lea    0x1(%edx),%eax
  80101d:	89 03                	mov    %eax,(%ebx)
  80101f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801022:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801026:	3d ff 00 00 00       	cmp    $0xff,%eax
  80102b:	75 1a                	jne    801047 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80102d:	83 ec 08             	sub    $0x8,%esp
  801030:	68 ff 00 00 00       	push   $0xff
  801035:	8d 43 08             	lea    0x8(%ebx),%eax
  801038:	50                   	push   %eax
  801039:	e8 a9 f0 ff ff       	call   8000e7 <sys_cputs>
		b->idx = 0;
  80103e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801044:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801047:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80104b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104e:	c9                   	leave  
  80104f:	c3                   	ret    

00801050 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801059:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801060:	00 00 00 
	b.cnt = 0;
  801063:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80106a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	ff 75 08             	pushl  0x8(%ebp)
  801073:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801079:	50                   	push   %eax
  80107a:	68 0e 10 80 00       	push   $0x80100e
  80107f:	e8 86 01 00 00       	call   80120a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801084:	83 c4 08             	add    $0x8,%esp
  801087:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80108d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801093:	50                   	push   %eax
  801094:	e8 4e f0 ff ff       	call   8000e7 <sys_cputs>

	return b.cnt;
}
  801099:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010a7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010aa:	50                   	push   %eax
  8010ab:	ff 75 08             	pushl  0x8(%ebp)
  8010ae:	e8 9d ff ff ff       	call   801050 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
  8010bb:	83 ec 1c             	sub    $0x1c,%esp
  8010be:	89 c7                	mov    %eax,%edi
  8010c0:	89 d6                	mov    %edx,%esi
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8010d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010dc:	39 d3                	cmp    %edx,%ebx
  8010de:	72 05                	jb     8010e5 <printnum+0x30>
  8010e0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8010e3:	77 45                	ja     80112a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010e5:	83 ec 0c             	sub    $0xc,%esp
  8010e8:	ff 75 18             	pushl  0x18(%ebp)
  8010eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010f1:	53                   	push   %ebx
  8010f2:	ff 75 10             	pushl  0x10(%ebp)
  8010f5:	83 ec 08             	sub    $0x8,%esp
  8010f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8010fe:	ff 75 dc             	pushl  -0x24(%ebp)
  801101:	ff 75 d8             	pushl  -0x28(%ebp)
  801104:	e8 87 09 00 00       	call   801a90 <__udivdi3>
  801109:	83 c4 18             	add    $0x18,%esp
  80110c:	52                   	push   %edx
  80110d:	50                   	push   %eax
  80110e:	89 f2                	mov    %esi,%edx
  801110:	89 f8                	mov    %edi,%eax
  801112:	e8 9e ff ff ff       	call   8010b5 <printnum>
  801117:	83 c4 20             	add    $0x20,%esp
  80111a:	eb 18                	jmp    801134 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80111c:	83 ec 08             	sub    $0x8,%esp
  80111f:	56                   	push   %esi
  801120:	ff 75 18             	pushl  0x18(%ebp)
  801123:	ff d7                	call   *%edi
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	eb 03                	jmp    80112d <printnum+0x78>
  80112a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80112d:	83 eb 01             	sub    $0x1,%ebx
  801130:	85 db                	test   %ebx,%ebx
  801132:	7f e8                	jg     80111c <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801134:	83 ec 08             	sub    $0x8,%esp
  801137:	56                   	push   %esi
  801138:	83 ec 04             	sub    $0x4,%esp
  80113b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113e:	ff 75 e0             	pushl  -0x20(%ebp)
  801141:	ff 75 dc             	pushl  -0x24(%ebp)
  801144:	ff 75 d8             	pushl  -0x28(%ebp)
  801147:	e8 74 0a 00 00       	call   801bc0 <__umoddi3>
  80114c:	83 c4 14             	add    $0x14,%esp
  80114f:	0f be 80 67 1e 80 00 	movsbl 0x801e67(%eax),%eax
  801156:	50                   	push   %eax
  801157:	ff d7                	call   *%edi
}
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5f                   	pop    %edi
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    

00801164 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801167:	83 fa 01             	cmp    $0x1,%edx
  80116a:	7e 0e                	jle    80117a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80116c:	8b 10                	mov    (%eax),%edx
  80116e:	8d 4a 08             	lea    0x8(%edx),%ecx
  801171:	89 08                	mov    %ecx,(%eax)
  801173:	8b 02                	mov    (%edx),%eax
  801175:	8b 52 04             	mov    0x4(%edx),%edx
  801178:	eb 22                	jmp    80119c <getuint+0x38>
	else if (lflag)
  80117a:	85 d2                	test   %edx,%edx
  80117c:	74 10                	je     80118e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80117e:	8b 10                	mov    (%eax),%edx
  801180:	8d 4a 04             	lea    0x4(%edx),%ecx
  801183:	89 08                	mov    %ecx,(%eax)
  801185:	8b 02                	mov    (%edx),%eax
  801187:	ba 00 00 00 00       	mov    $0x0,%edx
  80118c:	eb 0e                	jmp    80119c <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80118e:	8b 10                	mov    (%eax),%edx
  801190:	8d 4a 04             	lea    0x4(%edx),%ecx
  801193:	89 08                	mov    %ecx,(%eax)
  801195:	8b 02                	mov    (%edx),%eax
  801197:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011a1:	83 fa 01             	cmp    $0x1,%edx
  8011a4:	7e 0e                	jle    8011b4 <getint+0x16>
		return va_arg(*ap, long long);
  8011a6:	8b 10                	mov    (%eax),%edx
  8011a8:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011ab:	89 08                	mov    %ecx,(%eax)
  8011ad:	8b 02                	mov    (%edx),%eax
  8011af:	8b 52 04             	mov    0x4(%edx),%edx
  8011b2:	eb 1a                	jmp    8011ce <getint+0x30>
	else if (lflag)
  8011b4:	85 d2                	test   %edx,%edx
  8011b6:	74 0c                	je     8011c4 <getint+0x26>
		return va_arg(*ap, long);
  8011b8:	8b 10                	mov    (%eax),%edx
  8011ba:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011bd:	89 08                	mov    %ecx,(%eax)
  8011bf:	8b 02                	mov    (%edx),%eax
  8011c1:	99                   	cltd   
  8011c2:	eb 0a                	jmp    8011ce <getint+0x30>
	else
		return va_arg(*ap, int);
  8011c4:	8b 10                	mov    (%eax),%edx
  8011c6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011c9:	89 08                	mov    %ecx,(%eax)
  8011cb:	8b 02                	mov    (%edx),%eax
  8011cd:	99                   	cltd   
}
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011d6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011da:	8b 10                	mov    (%eax),%edx
  8011dc:	3b 50 04             	cmp    0x4(%eax),%edx
  8011df:	73 0a                	jae    8011eb <sprintputch+0x1b>
		*b->buf++ = ch;
  8011e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e4:	89 08                	mov    %ecx,(%eax)
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	88 02                	mov    %al,(%edx)
}
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8011f3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	e8 05 00 00 00       	call   80120a <vprintfmt>
	va_end(ap);
}
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	57                   	push   %edi
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 2c             	sub    $0x2c,%esp
  801213:	8b 75 08             	mov    0x8(%ebp),%esi
  801216:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801219:	8b 7d 10             	mov    0x10(%ebp),%edi
  80121c:	eb 12                	jmp    801230 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80121e:	85 c0                	test   %eax,%eax
  801220:	0f 84 44 03 00 00    	je     80156a <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  801226:	83 ec 08             	sub    $0x8,%esp
  801229:	53                   	push   %ebx
  80122a:	50                   	push   %eax
  80122b:	ff d6                	call   *%esi
  80122d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801230:	83 c7 01             	add    $0x1,%edi
  801233:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801237:	83 f8 25             	cmp    $0x25,%eax
  80123a:	75 e2                	jne    80121e <vprintfmt+0x14>
  80123c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801240:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801247:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80124e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801255:	ba 00 00 00 00       	mov    $0x0,%edx
  80125a:	eb 07                	jmp    801263 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80125c:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80125f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801263:	8d 47 01             	lea    0x1(%edi),%eax
  801266:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801269:	0f b6 07             	movzbl (%edi),%eax
  80126c:	0f b6 c8             	movzbl %al,%ecx
  80126f:	83 e8 23             	sub    $0x23,%eax
  801272:	3c 55                	cmp    $0x55,%al
  801274:	0f 87 d5 02 00 00    	ja     80154f <vprintfmt+0x345>
  80127a:	0f b6 c0             	movzbl %al,%eax
  80127d:	ff 24 85 a0 1f 80 00 	jmp    *0x801fa0(,%eax,4)
  801284:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801287:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80128b:	eb d6                	jmp    801263 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80128d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801290:	b8 00 00 00 00       	mov    $0x0,%eax
  801295:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801298:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80129b:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  80129f:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012a2:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012a5:	83 fa 09             	cmp    $0x9,%edx
  8012a8:	77 39                	ja     8012e3 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012aa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012ad:	eb e9                	jmp    801298 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012af:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b2:	8d 48 04             	lea    0x4(%eax),%ecx
  8012b5:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012c0:	eb 27                	jmp    8012e9 <vprintfmt+0xdf>
  8012c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012cc:	0f 49 c8             	cmovns %eax,%ecx
  8012cf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012d5:	eb 8c                	jmp    801263 <vprintfmt+0x59>
  8012d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8012da:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012e1:	eb 80                	jmp    801263 <vprintfmt+0x59>
  8012e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012e6:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8012e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012ed:	0f 89 70 ff ff ff    	jns    801263 <vprintfmt+0x59>
				width = precision, precision = -1;
  8012f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012f9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801300:	e9 5e ff ff ff       	jmp    801263 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801305:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801308:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80130b:	e9 53 ff ff ff       	jmp    801263 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801310:	8b 45 14             	mov    0x14(%ebp),%eax
  801313:	8d 50 04             	lea    0x4(%eax),%edx
  801316:	89 55 14             	mov    %edx,0x14(%ebp)
  801319:	83 ec 08             	sub    $0x8,%esp
  80131c:	53                   	push   %ebx
  80131d:	ff 30                	pushl  (%eax)
  80131f:	ff d6                	call   *%esi
			break;
  801321:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801327:	e9 04 ff ff ff       	jmp    801230 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8d 50 04             	lea    0x4(%eax),%edx
  801332:	89 55 14             	mov    %edx,0x14(%ebp)
  801335:	8b 00                	mov    (%eax),%eax
  801337:	99                   	cltd   
  801338:	31 d0                	xor    %edx,%eax
  80133a:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80133c:	83 f8 0f             	cmp    $0xf,%eax
  80133f:	7f 0b                	jg     80134c <vprintfmt+0x142>
  801341:	8b 14 85 00 21 80 00 	mov    0x802100(,%eax,4),%edx
  801348:	85 d2                	test   %edx,%edx
  80134a:	75 18                	jne    801364 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80134c:	50                   	push   %eax
  80134d:	68 7f 1e 80 00       	push   $0x801e7f
  801352:	53                   	push   %ebx
  801353:	56                   	push   %esi
  801354:	e8 94 fe ff ff       	call   8011ed <printfmt>
  801359:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80135c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80135f:	e9 cc fe ff ff       	jmp    801230 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801364:	52                   	push   %edx
  801365:	68 fd 1d 80 00       	push   $0x801dfd
  80136a:	53                   	push   %ebx
  80136b:	56                   	push   %esi
  80136c:	e8 7c fe ff ff       	call   8011ed <printfmt>
  801371:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801377:	e9 b4 fe ff ff       	jmp    801230 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80137c:	8b 45 14             	mov    0x14(%ebp),%eax
  80137f:	8d 50 04             	lea    0x4(%eax),%edx
  801382:	89 55 14             	mov    %edx,0x14(%ebp)
  801385:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801387:	85 ff                	test   %edi,%edi
  801389:	b8 78 1e 80 00       	mov    $0x801e78,%eax
  80138e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801391:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801395:	0f 8e 94 00 00 00    	jle    80142f <vprintfmt+0x225>
  80139b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80139f:	0f 84 98 00 00 00    	je     80143d <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	ff 75 d0             	pushl  -0x30(%ebp)
  8013ab:	57                   	push   %edi
  8013ac:	e8 41 02 00 00       	call   8015f2 <strnlen>
  8013b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013b4:	29 c1                	sub    %eax,%ecx
  8013b6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013b9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013bc:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013c3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013c6:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c8:	eb 0f                	jmp    8013d9 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	53                   	push   %ebx
  8013ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8013d1:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d3:	83 ef 01             	sub    $0x1,%edi
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	85 ff                	test   %edi,%edi
  8013db:	7f ed                	jg     8013ca <vprintfmt+0x1c0>
  8013dd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013e0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8013e3:	85 c9                	test   %ecx,%ecx
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ea:	0f 49 c1             	cmovns %ecx,%eax
  8013ed:	29 c1                	sub    %eax,%ecx
  8013ef:	89 75 08             	mov    %esi,0x8(%ebp)
  8013f2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013f5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8013f8:	89 cb                	mov    %ecx,%ebx
  8013fa:	eb 4d                	jmp    801449 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8013fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801400:	74 1b                	je     80141d <vprintfmt+0x213>
  801402:	0f be c0             	movsbl %al,%eax
  801405:	83 e8 20             	sub    $0x20,%eax
  801408:	83 f8 5e             	cmp    $0x5e,%eax
  80140b:	76 10                	jbe    80141d <vprintfmt+0x213>
					putch('?', putdat);
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	ff 75 0c             	pushl  0xc(%ebp)
  801413:	6a 3f                	push   $0x3f
  801415:	ff 55 08             	call   *0x8(%ebp)
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	eb 0d                	jmp    80142a <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	ff 75 0c             	pushl  0xc(%ebp)
  801423:	52                   	push   %edx
  801424:	ff 55 08             	call   *0x8(%ebp)
  801427:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80142a:	83 eb 01             	sub    $0x1,%ebx
  80142d:	eb 1a                	jmp    801449 <vprintfmt+0x23f>
  80142f:	89 75 08             	mov    %esi,0x8(%ebp)
  801432:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801435:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801438:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80143b:	eb 0c                	jmp    801449 <vprintfmt+0x23f>
  80143d:	89 75 08             	mov    %esi,0x8(%ebp)
  801440:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801443:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801446:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801449:	83 c7 01             	add    $0x1,%edi
  80144c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801450:	0f be d0             	movsbl %al,%edx
  801453:	85 d2                	test   %edx,%edx
  801455:	74 23                	je     80147a <vprintfmt+0x270>
  801457:	85 f6                	test   %esi,%esi
  801459:	78 a1                	js     8013fc <vprintfmt+0x1f2>
  80145b:	83 ee 01             	sub    $0x1,%esi
  80145e:	79 9c                	jns    8013fc <vprintfmt+0x1f2>
  801460:	89 df                	mov    %ebx,%edi
  801462:	8b 75 08             	mov    0x8(%ebp),%esi
  801465:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801468:	eb 18                	jmp    801482 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	53                   	push   %ebx
  80146e:	6a 20                	push   $0x20
  801470:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801472:	83 ef 01             	sub    $0x1,%edi
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	eb 08                	jmp    801482 <vprintfmt+0x278>
  80147a:	89 df                	mov    %ebx,%edi
  80147c:	8b 75 08             	mov    0x8(%ebp),%esi
  80147f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801482:	85 ff                	test   %edi,%edi
  801484:	7f e4                	jg     80146a <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801489:	e9 a2 fd ff ff       	jmp    801230 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80148e:	8d 45 14             	lea    0x14(%ebp),%eax
  801491:	e8 08 fd ff ff       	call   80119e <getint>
  801496:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801499:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  80149c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014a5:	79 74                	jns    80151b <vprintfmt+0x311>
				putch('-', putdat);
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	53                   	push   %ebx
  8014ab:	6a 2d                	push   $0x2d
  8014ad:	ff d6                	call   *%esi
				num = -(long long) num;
  8014af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014b5:	f7 d8                	neg    %eax
  8014b7:	83 d2 00             	adc    $0x0,%edx
  8014ba:	f7 da                	neg    %edx
  8014bc:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	eb 55                	jmp    80151b <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8014c9:	e8 96 fc ff ff       	call   801164 <getuint>
			base = 10;
  8014ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014d3:	eb 46                	jmp    80151b <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8014d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8014d8:	e8 87 fc ff ff       	call   801164 <getuint>
			base = 8;
  8014dd:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8014e2:	eb 37                	jmp    80151b <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	53                   	push   %ebx
  8014e8:	6a 30                	push   $0x30
  8014ea:	ff d6                	call   *%esi
			putch('x', putdat);
  8014ec:	83 c4 08             	add    $0x8,%esp
  8014ef:	53                   	push   %ebx
  8014f0:	6a 78                	push   $0x78
  8014f2:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	8d 50 04             	lea    0x4(%eax),%edx
  8014fa:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014fd:	8b 00                	mov    (%eax),%eax
  8014ff:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801504:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801507:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80150c:	eb 0d                	jmp    80151b <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80150e:	8d 45 14             	lea    0x14(%ebp),%eax
  801511:	e8 4e fc ff ff       	call   801164 <getuint>
			base = 16;
  801516:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80151b:	83 ec 0c             	sub    $0xc,%esp
  80151e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801522:	57                   	push   %edi
  801523:	ff 75 e0             	pushl  -0x20(%ebp)
  801526:	51                   	push   %ecx
  801527:	52                   	push   %edx
  801528:	50                   	push   %eax
  801529:	89 da                	mov    %ebx,%edx
  80152b:	89 f0                	mov    %esi,%eax
  80152d:	e8 83 fb ff ff       	call   8010b5 <printnum>
			break;
  801532:	83 c4 20             	add    $0x20,%esp
  801535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801538:	e9 f3 fc ff ff       	jmp    801230 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	53                   	push   %ebx
  801541:	51                   	push   %ecx
  801542:	ff d6                	call   *%esi
			break;
  801544:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801547:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  80154a:	e9 e1 fc ff ff       	jmp    801230 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	53                   	push   %ebx
  801553:	6a 25                	push   $0x25
  801555:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	eb 03                	jmp    80155f <vprintfmt+0x355>
  80155c:	83 ef 01             	sub    $0x1,%edi
  80155f:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  801563:	75 f7                	jne    80155c <vprintfmt+0x352>
  801565:	e9 c6 fc ff ff       	jmp    801230 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  80156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5f                   	pop    %edi
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 18             	sub    $0x18,%esp
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80157e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801581:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801585:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801588:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80158f:	85 c0                	test   %eax,%eax
  801591:	74 26                	je     8015b9 <vsnprintf+0x47>
  801593:	85 d2                	test   %edx,%edx
  801595:	7e 22                	jle    8015b9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801597:	ff 75 14             	pushl  0x14(%ebp)
  80159a:	ff 75 10             	pushl  0x10(%ebp)
  80159d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	68 d0 11 80 00       	push   $0x8011d0
  8015a6:	e8 5f fc ff ff       	call   80120a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	eb 05                	jmp    8015be <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015c6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 10             	pushl  0x10(%ebp)
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	ff 75 08             	pushl  0x8(%ebp)
  8015d3:	e8 9a ff ff ff       	call   801572 <vsnprintf>
	va_end(ap);

	return rc;
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e5:	eb 03                	jmp    8015ea <strlen+0x10>
		n++;
  8015e7:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ea:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8015ee:	75 f7                	jne    8015e7 <strlen+0xd>
		n++;
	return n;
}
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    

008015f2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801600:	eb 03                	jmp    801605 <strnlen+0x13>
		n++;
  801602:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 08                	je     801611 <strnlen+0x1f>
  801609:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80160d:	75 f3                	jne    801602 <strnlen+0x10>
  80160f:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    

00801613 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	53                   	push   %ebx
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80161d:	89 c2                	mov    %eax,%edx
  80161f:	83 c2 01             	add    $0x1,%edx
  801622:	83 c1 01             	add    $0x1,%ecx
  801625:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801629:	88 5a ff             	mov    %bl,-0x1(%edx)
  80162c:	84 db                	test   %bl,%bl
  80162e:	75 ef                	jne    80161f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801630:	5b                   	pop    %ebx
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	53                   	push   %ebx
  801637:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80163a:	53                   	push   %ebx
  80163b:	e8 9a ff ff ff       	call   8015da <strlen>
  801640:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	01 d8                	add    %ebx,%eax
  801648:	50                   	push   %eax
  801649:	e8 c5 ff ff ff       	call   801613 <strcpy>
	return dst;
}
  80164e:	89 d8                	mov    %ebx,%eax
  801650:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
  80165a:	8b 75 08             	mov    0x8(%ebp),%esi
  80165d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801660:	89 f3                	mov    %esi,%ebx
  801662:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801665:	89 f2                	mov    %esi,%edx
  801667:	eb 0f                	jmp    801678 <strncpy+0x23>
		*dst++ = *src;
  801669:	83 c2 01             	add    $0x1,%edx
  80166c:	0f b6 01             	movzbl (%ecx),%eax
  80166f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801672:	80 39 01             	cmpb   $0x1,(%ecx)
  801675:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801678:	39 da                	cmp    %ebx,%edx
  80167a:	75 ed                	jne    801669 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80167c:	89 f0                	mov    %esi,%eax
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	56                   	push   %esi
  801686:	53                   	push   %ebx
  801687:	8b 75 08             	mov    0x8(%ebp),%esi
  80168a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168d:	8b 55 10             	mov    0x10(%ebp),%edx
  801690:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801692:	85 d2                	test   %edx,%edx
  801694:	74 21                	je     8016b7 <strlcpy+0x35>
  801696:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80169a:	89 f2                	mov    %esi,%edx
  80169c:	eb 09                	jmp    8016a7 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80169e:	83 c2 01             	add    $0x1,%edx
  8016a1:	83 c1 01             	add    $0x1,%ecx
  8016a4:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a7:	39 c2                	cmp    %eax,%edx
  8016a9:	74 09                	je     8016b4 <strlcpy+0x32>
  8016ab:	0f b6 19             	movzbl (%ecx),%ebx
  8016ae:	84 db                	test   %bl,%bl
  8016b0:	75 ec                	jne    80169e <strlcpy+0x1c>
  8016b2:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016b4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016b7:	29 f0                	sub    %esi,%eax
}
  8016b9:	5b                   	pop    %ebx
  8016ba:	5e                   	pop    %esi
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    

008016bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016c6:	eb 06                	jmp    8016ce <strcmp+0x11>
		p++, q++;
  8016c8:	83 c1 01             	add    $0x1,%ecx
  8016cb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016ce:	0f b6 01             	movzbl (%ecx),%eax
  8016d1:	84 c0                	test   %al,%al
  8016d3:	74 04                	je     8016d9 <strcmp+0x1c>
  8016d5:	3a 02                	cmp    (%edx),%al
  8016d7:	74 ef                	je     8016c8 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016d9:	0f b6 c0             	movzbl %al,%eax
  8016dc:	0f b6 12             	movzbl (%edx),%edx
  8016df:	29 d0                	sub    %edx,%eax
}
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	53                   	push   %ebx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ed:	89 c3                	mov    %eax,%ebx
  8016ef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8016f2:	eb 06                	jmp    8016fa <strncmp+0x17>
		n--, p++, q++;
  8016f4:	83 c0 01             	add    $0x1,%eax
  8016f7:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8016fa:	39 d8                	cmp    %ebx,%eax
  8016fc:	74 15                	je     801713 <strncmp+0x30>
  8016fe:	0f b6 08             	movzbl (%eax),%ecx
  801701:	84 c9                	test   %cl,%cl
  801703:	74 04                	je     801709 <strncmp+0x26>
  801705:	3a 0a                	cmp    (%edx),%cl
  801707:	74 eb                	je     8016f4 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801709:	0f b6 00             	movzbl (%eax),%eax
  80170c:	0f b6 12             	movzbl (%edx),%edx
  80170f:	29 d0                	sub    %edx,%eax
  801711:	eb 05                	jmp    801718 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801718:	5b                   	pop    %ebx
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    

0080171b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801725:	eb 07                	jmp    80172e <strchr+0x13>
		if (*s == c)
  801727:	38 ca                	cmp    %cl,%dl
  801729:	74 0f                	je     80173a <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80172b:	83 c0 01             	add    $0x1,%eax
  80172e:	0f b6 10             	movzbl (%eax),%edx
  801731:	84 d2                	test   %dl,%dl
  801733:	75 f2                	jne    801727 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801746:	eb 03                	jmp    80174b <strfind+0xf>
  801748:	83 c0 01             	add    $0x1,%eax
  80174b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80174e:	38 ca                	cmp    %cl,%dl
  801750:	74 04                	je     801756 <strfind+0x1a>
  801752:	84 d2                	test   %dl,%dl
  801754:	75 f2                	jne    801748 <strfind+0xc>
			break;
	return (char *) s;
}
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	57                   	push   %edi
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801764:	85 c9                	test   %ecx,%ecx
  801766:	74 37                	je     80179f <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801768:	f6 c2 03             	test   $0x3,%dl
  80176b:	75 2a                	jne    801797 <memset+0x3f>
  80176d:	f6 c1 03             	test   $0x3,%cl
  801770:	75 25                	jne    801797 <memset+0x3f>
		c &= 0xFF;
  801772:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801776:	89 df                	mov    %ebx,%edi
  801778:	c1 e7 08             	shl    $0x8,%edi
  80177b:	89 de                	mov    %ebx,%esi
  80177d:	c1 e6 18             	shl    $0x18,%esi
  801780:	89 d8                	mov    %ebx,%eax
  801782:	c1 e0 10             	shl    $0x10,%eax
  801785:	09 f0                	or     %esi,%eax
  801787:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801789:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80178c:	89 f8                	mov    %edi,%eax
  80178e:	09 d8                	or     %ebx,%eax
  801790:	89 d7                	mov    %edx,%edi
  801792:	fc                   	cld    
  801793:	f3 ab                	rep stos %eax,%es:(%edi)
  801795:	eb 08                	jmp    80179f <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801797:	89 d7                	mov    %edx,%edi
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	fc                   	cld    
  80179d:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  80179f:	89 d0                	mov    %edx,%eax
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5f                   	pop    %edi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    

008017a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	57                   	push   %edi
  8017aa:	56                   	push   %esi
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017b4:	39 c6                	cmp    %eax,%esi
  8017b6:	73 35                	jae    8017ed <memmove+0x47>
  8017b8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017bb:	39 d0                	cmp    %edx,%eax
  8017bd:	73 2e                	jae    8017ed <memmove+0x47>
		s += n;
		d += n;
  8017bf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017c2:	89 d6                	mov    %edx,%esi
  8017c4:	09 fe                	or     %edi,%esi
  8017c6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017cc:	75 13                	jne    8017e1 <memmove+0x3b>
  8017ce:	f6 c1 03             	test   $0x3,%cl
  8017d1:	75 0e                	jne    8017e1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017d3:	83 ef 04             	sub    $0x4,%edi
  8017d6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8017d9:	c1 e9 02             	shr    $0x2,%ecx
  8017dc:	fd                   	std    
  8017dd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8017df:	eb 09                	jmp    8017ea <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017e1:	83 ef 01             	sub    $0x1,%edi
  8017e4:	8d 72 ff             	lea    -0x1(%edx),%esi
  8017e7:	fd                   	std    
  8017e8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017ea:	fc                   	cld    
  8017eb:	eb 1d                	jmp    80180a <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017ed:	89 f2                	mov    %esi,%edx
  8017ef:	09 c2                	or     %eax,%edx
  8017f1:	f6 c2 03             	test   $0x3,%dl
  8017f4:	75 0f                	jne    801805 <memmove+0x5f>
  8017f6:	f6 c1 03             	test   $0x3,%cl
  8017f9:	75 0a                	jne    801805 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  8017fb:	c1 e9 02             	shr    $0x2,%ecx
  8017fe:	89 c7                	mov    %eax,%edi
  801800:	fc                   	cld    
  801801:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801803:	eb 05                	jmp    80180a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801805:	89 c7                	mov    %eax,%edi
  801807:	fc                   	cld    
  801808:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80180a:	5e                   	pop    %esi
  80180b:	5f                   	pop    %edi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801811:	ff 75 10             	pushl  0x10(%ebp)
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	ff 75 08             	pushl  0x8(%ebp)
  80181a:	e8 87 ff ff ff       	call   8017a6 <memmove>
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182c:	89 c6                	mov    %eax,%esi
  80182e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801831:	eb 1a                	jmp    80184d <memcmp+0x2c>
		if (*s1 != *s2)
  801833:	0f b6 08             	movzbl (%eax),%ecx
  801836:	0f b6 1a             	movzbl (%edx),%ebx
  801839:	38 d9                	cmp    %bl,%cl
  80183b:	74 0a                	je     801847 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  80183d:	0f b6 c1             	movzbl %cl,%eax
  801840:	0f b6 db             	movzbl %bl,%ebx
  801843:	29 d8                	sub    %ebx,%eax
  801845:	eb 0f                	jmp    801856 <memcmp+0x35>
		s1++, s2++;
  801847:	83 c0 01             	add    $0x1,%eax
  80184a:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80184d:	39 f0                	cmp    %esi,%eax
  80184f:	75 e2                	jne    801833 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801856:	5b                   	pop    %ebx
  801857:	5e                   	pop    %esi
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    

0080185a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	53                   	push   %ebx
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  801861:	89 c1                	mov    %eax,%ecx
  801863:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  801866:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80186a:	eb 0a                	jmp    801876 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  80186c:	0f b6 10             	movzbl (%eax),%edx
  80186f:	39 da                	cmp    %ebx,%edx
  801871:	74 07                	je     80187a <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801873:	83 c0 01             	add    $0x1,%eax
  801876:	39 c8                	cmp    %ecx,%eax
  801878:	72 f2                	jb     80186c <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80187a:	5b                   	pop    %ebx
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    

0080187d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	57                   	push   %edi
  801881:	56                   	push   %esi
  801882:	53                   	push   %ebx
  801883:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801886:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801889:	eb 03                	jmp    80188e <strtol+0x11>
		s++;
  80188b:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80188e:	0f b6 01             	movzbl (%ecx),%eax
  801891:	3c 20                	cmp    $0x20,%al
  801893:	74 f6                	je     80188b <strtol+0xe>
  801895:	3c 09                	cmp    $0x9,%al
  801897:	74 f2                	je     80188b <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801899:	3c 2b                	cmp    $0x2b,%al
  80189b:	75 0a                	jne    8018a7 <strtol+0x2a>
		s++;
  80189d:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a5:	eb 11                	jmp    8018b8 <strtol+0x3b>
  8018a7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018ac:	3c 2d                	cmp    $0x2d,%al
  8018ae:	75 08                	jne    8018b8 <strtol+0x3b>
		s++, neg = 1;
  8018b0:	83 c1 01             	add    $0x1,%ecx
  8018b3:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018b8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018be:	75 15                	jne    8018d5 <strtol+0x58>
  8018c0:	80 39 30             	cmpb   $0x30,(%ecx)
  8018c3:	75 10                	jne    8018d5 <strtol+0x58>
  8018c5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018c9:	75 7c                	jne    801947 <strtol+0xca>
		s += 2, base = 16;
  8018cb:	83 c1 02             	add    $0x2,%ecx
  8018ce:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018d3:	eb 16                	jmp    8018eb <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8018d5:	85 db                	test   %ebx,%ebx
  8018d7:	75 12                	jne    8018eb <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8018d9:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8018de:	80 39 30             	cmpb   $0x30,(%ecx)
  8018e1:	75 08                	jne    8018eb <strtol+0x6e>
		s++, base = 8;
  8018e3:	83 c1 01             	add    $0x1,%ecx
  8018e6:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f0:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018f3:	0f b6 11             	movzbl (%ecx),%edx
  8018f6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8018f9:	89 f3                	mov    %esi,%ebx
  8018fb:	80 fb 09             	cmp    $0x9,%bl
  8018fe:	77 08                	ja     801908 <strtol+0x8b>
			dig = *s - '0';
  801900:	0f be d2             	movsbl %dl,%edx
  801903:	83 ea 30             	sub    $0x30,%edx
  801906:	eb 22                	jmp    80192a <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  801908:	8d 72 9f             	lea    -0x61(%edx),%esi
  80190b:	89 f3                	mov    %esi,%ebx
  80190d:	80 fb 19             	cmp    $0x19,%bl
  801910:	77 08                	ja     80191a <strtol+0x9d>
			dig = *s - 'a' + 10;
  801912:	0f be d2             	movsbl %dl,%edx
  801915:	83 ea 57             	sub    $0x57,%edx
  801918:	eb 10                	jmp    80192a <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  80191a:	8d 72 bf             	lea    -0x41(%edx),%esi
  80191d:	89 f3                	mov    %esi,%ebx
  80191f:	80 fb 19             	cmp    $0x19,%bl
  801922:	77 16                	ja     80193a <strtol+0xbd>
			dig = *s - 'A' + 10;
  801924:	0f be d2             	movsbl %dl,%edx
  801927:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  80192a:	3b 55 10             	cmp    0x10(%ebp),%edx
  80192d:	7d 0b                	jge    80193a <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  80192f:	83 c1 01             	add    $0x1,%ecx
  801932:	0f af 45 10          	imul   0x10(%ebp),%eax
  801936:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  801938:	eb b9                	jmp    8018f3 <strtol+0x76>

	if (endptr)
  80193a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80193e:	74 0d                	je     80194d <strtol+0xd0>
		*endptr = (char *) s;
  801940:	8b 75 0c             	mov    0xc(%ebp),%esi
  801943:	89 0e                	mov    %ecx,(%esi)
  801945:	eb 06                	jmp    80194d <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801947:	85 db                	test   %ebx,%ebx
  801949:	74 98                	je     8018e3 <strtol+0x66>
  80194b:	eb 9e                	jmp    8018eb <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  80194d:	89 c2                	mov    %eax,%edx
  80194f:	f7 da                	neg    %edx
  801951:	85 ff                	test   %edi,%edi
  801953:	0f 45 c2             	cmovne %edx,%eax
}
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5f                   	pop    %edi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    

0080195b <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	8b 75 08             	mov    0x8(%ebp),%esi
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801969:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80196b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801970:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801973:	83 ec 0c             	sub    $0xc,%esp
  801976:	50                   	push   %eax
  801977:	e8 1d e9 ff ff       	call   800299 <sys_ipc_recv>
	if (from_env_store)
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 f6                	test   %esi,%esi
  801981:	74 0b                	je     80198e <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801983:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801989:	8b 52 74             	mov    0x74(%edx),%edx
  80198c:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80198e:	85 db                	test   %ebx,%ebx
  801990:	74 0b                	je     80199d <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801992:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801998:	8b 52 78             	mov    0x78(%edx),%edx
  80199b:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  80199d:	85 c0                	test   %eax,%eax
  80199f:	79 16                	jns    8019b7 <ipc_recv+0x5c>
		if (from_env_store)
  8019a1:	85 f6                	test   %esi,%esi
  8019a3:	74 06                	je     8019ab <ipc_recv+0x50>
			*from_env_store = 0;
  8019a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019ab:	85 db                	test   %ebx,%ebx
  8019ad:	74 10                	je     8019bf <ipc_recv+0x64>
			*perm_store = 0;
  8019af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019b5:	eb 08                	jmp    8019bf <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019b7:	a1 04 40 80 00       	mov    0x804004,%eax
  8019bc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	57                   	push   %edi
  8019ca:	56                   	push   %esi
  8019cb:	53                   	push   %ebx
  8019cc:	83 ec 0c             	sub    $0xc,%esp
  8019cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019d8:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019da:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019df:	0f 44 d8             	cmove  %eax,%ebx
  8019e2:	eb 1c                	jmp    801a00 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019e4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019e7:	74 12                	je     8019fb <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019e9:	50                   	push   %eax
  8019ea:	68 60 21 80 00       	push   $0x802160
  8019ef:	6a 42                	push   $0x42
  8019f1:	68 76 21 80 00       	push   $0x802176
  8019f6:	e8 cd f5 ff ff       	call   800fc8 <_panic>
		sys_yield();
  8019fb:	e8 77 e7 ff ff       	call   800177 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a00:	ff 75 14             	pushl  0x14(%ebp)
  801a03:	53                   	push   %ebx
  801a04:	56                   	push   %esi
  801a05:	57                   	push   %edi
  801a06:	e8 69 e8 ff ff       	call   800274 <sys_ipc_try_send>
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	75 d2                	jne    8019e4 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5f                   	pop    %edi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    

00801a1a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a20:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a25:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a28:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a2e:	8b 52 50             	mov    0x50(%edx),%edx
  801a31:	39 ca                	cmp    %ecx,%edx
  801a33:	75 0d                	jne    801a42 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a35:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a38:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a3d:	8b 40 48             	mov    0x48(%eax),%eax
  801a40:	eb 0f                	jmp    801a51 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a42:	83 c0 01             	add    $0x1,%eax
  801a45:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a4a:	75 d9                	jne    801a25 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    

00801a53 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a59:	89 d0                	mov    %edx,%eax
  801a5b:	c1 e8 16             	shr    $0x16,%eax
  801a5e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a6a:	f6 c1 01             	test   $0x1,%cl
  801a6d:	74 1d                	je     801a8c <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a6f:	c1 ea 0c             	shr    $0xc,%edx
  801a72:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a79:	f6 c2 01             	test   $0x1,%dl
  801a7c:	74 0e                	je     801a8c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a7e:	c1 ea 0c             	shr    $0xc,%edx
  801a81:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a88:	ef 
  801a89:	0f b7 c0             	movzwl %ax,%eax
}
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    
  801a8e:	66 90                	xchg   %ax,%ax

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
