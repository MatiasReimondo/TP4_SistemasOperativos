
obj/user/buggyhello.debug:     formato del fichero elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 b3 00 00 00       	call   8000f5 <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800052:	e8 0a 01 00 00       	call   800161 <sys_getenvid>
	if (id >= 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	78 12                	js     80006d <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80005b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800060:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800063:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800068:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006d:	85 db                	test   %ebx,%ebx
  80006f:	7e 07                	jle    800078 <libmain+0x31>
		binaryname = argv[0];
  800071:	8b 06                	mov    (%esi),%eax
  800073:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	56                   	push   %esi
  80007c:	53                   	push   %ebx
  80007d:	e8 b1 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800082:	e8 0a 00 00 00       	call   800091 <exit>
}
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008d:	5b                   	pop    %ebx
  80008e:	5e                   	pop    %esi
  80008f:	5d                   	pop    %ebp
  800090:	c3                   	ret    

00800091 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800097:	e8 f8 03 00 00       	call   800494 <close_all>
	sys_env_destroy(0);
  80009c:	83 ec 0c             	sub    $0xc,%esp
  80009f:	6a 00                	push   $0x0
  8000a1:	e8 99 00 00 00       	call   80013f <sys_env_destroy>
}
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	c9                   	leave  
  8000aa:	c3                   	ret    

008000ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	57                   	push   %edi
  8000af:	56                   	push   %esi
  8000b0:	53                   	push   %ebx
  8000b1:	83 ec 1c             	sub    $0x1c,%esp
  8000b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000ba:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000c5:	8b 75 14             	mov    0x14(%ebp),%esi
  8000c8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000ce:	74 1d                	je     8000ed <syscall+0x42>
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	7e 19                	jle    8000ed <syscall+0x42>
  8000d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	50                   	push   %eax
  8000db:	52                   	push   %edx
  8000dc:	68 4a 1d 80 00       	push   $0x801d4a
  8000e1:	6a 23                	push   $0x23
  8000e3:	68 67 1d 80 00       	push   $0x801d67
  8000e8:	e8 e9 0e 00 00       	call   800fd6 <_panic>

	return ret;
}
  8000ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f0:	5b                   	pop    %ebx
  8000f1:	5e                   	pop    %esi
  8000f2:	5f                   	pop    %edi
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    

008000f5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000f5:	55                   	push   %ebp
  8000f6:	89 e5                	mov    %esp,%ebp
  8000f8:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000fb:	6a 00                	push   $0x0
  8000fd:	6a 00                	push   $0x0
  8000ff:	6a 00                	push   $0x0
  800101:	ff 75 0c             	pushl  0xc(%ebp)
  800104:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800107:	ba 00 00 00 00       	mov    $0x0,%edx
  80010c:	b8 00 00 00 00       	mov    $0x0,%eax
  800111:	e8 95 ff ff ff       	call   8000ab <syscall>
}
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	c9                   	leave  
  80011a:	c3                   	ret    

0080011b <sys_cgetc>:

int
sys_cgetc(void)
{
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800121:	6a 00                	push   $0x0
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	6a 00                	push   $0x0
  800129:	b9 00 00 00 00       	mov    $0x0,%ecx
  80012e:	ba 00 00 00 00       	mov    $0x0,%edx
  800133:	b8 01 00 00 00       	mov    $0x1,%eax
  800138:	e8 6e ff ff ff       	call   8000ab <syscall>
}
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    

0080013f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800145:	6a 00                	push   $0x0
  800147:	6a 00                	push   $0x0
  800149:	6a 00                	push   $0x0
  80014b:	6a 00                	push   $0x0
  80014d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800150:	ba 01 00 00 00       	mov    $0x1,%edx
  800155:	b8 03 00 00 00       	mov    $0x3,%eax
  80015a:	e8 4c ff ff ff       	call   8000ab <syscall>
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    

00800161 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800167:	6a 00                	push   $0x0
  800169:	6a 00                	push   $0x0
  80016b:	6a 00                	push   $0x0
  80016d:	6a 00                	push   $0x0
  80016f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800174:	ba 00 00 00 00       	mov    $0x0,%edx
  800179:	b8 02 00 00 00       	mov    $0x2,%eax
  80017e:	e8 28 ff ff ff       	call   8000ab <syscall>
}
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <sys_yield>:

void
sys_yield(void)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80018b:	6a 00                	push   $0x0
  80018d:	6a 00                	push   $0x0
  80018f:	6a 00                	push   $0x0
  800191:	6a 00                	push   $0x0
  800193:	b9 00 00 00 00       	mov    $0x0,%ecx
  800198:	ba 00 00 00 00       	mov    $0x0,%edx
  80019d:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001a2:	e8 04 ff ff ff       	call   8000ab <syscall>
}
  8001a7:	83 c4 10             	add    $0x10,%esp
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 00                	push   $0x0
  8001b6:	ff 75 10             	pushl  0x10(%ebp)
  8001b9:	ff 75 0c             	pushl  0xc(%ebp)
  8001bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8001c4:	b8 04 00 00 00       	mov    $0x4,%eax
  8001c9:	e8 dd fe ff ff       	call   8000ab <syscall>
}
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001d6:	ff 75 18             	pushl  0x18(%ebp)
  8001d9:	ff 75 14             	pushl  0x14(%ebp)
  8001dc:	ff 75 10             	pushl  0x10(%ebp)
  8001df:	ff 75 0c             	pushl  0xc(%ebp)
  8001e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e5:	ba 01 00 00 00       	mov    $0x1,%edx
  8001ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ef:	e8 b7 fe ff ff       	call   8000ab <syscall>
}
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8001fc:	6a 00                	push   $0x0
  8001fe:	6a 00                	push   $0x0
  800200:	6a 00                	push   $0x0
  800202:	ff 75 0c             	pushl  0xc(%ebp)
  800205:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800208:	ba 01 00 00 00       	mov    $0x1,%edx
  80020d:	b8 06 00 00 00       	mov    $0x6,%eax
  800212:	e8 94 fe ff ff       	call   8000ab <syscall>
}
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80021f:	6a 00                	push   $0x0
  800221:	6a 00                	push   $0x0
  800223:	6a 00                	push   $0x0
  800225:	ff 75 0c             	pushl  0xc(%ebp)
  800228:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022b:	ba 01 00 00 00       	mov    $0x1,%edx
  800230:	b8 08 00 00 00       	mov    $0x8,%eax
  800235:	e8 71 fe ff ff       	call   8000ab <syscall>
}
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800242:	6a 00                	push   $0x0
  800244:	6a 00                	push   $0x0
  800246:	6a 00                	push   $0x0
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80024e:	ba 01 00 00 00       	mov    $0x1,%edx
  800253:	b8 09 00 00 00       	mov    $0x9,%eax
  800258:	e8 4e fe ff ff       	call   8000ab <syscall>
}
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800265:	6a 00                	push   $0x0
  800267:	6a 00                	push   $0x0
  800269:	6a 00                	push   $0x0
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800271:	ba 01 00 00 00       	mov    $0x1,%edx
  800276:	b8 0a 00 00 00       	mov    $0xa,%eax
  80027b:	e8 2b fe ff ff       	call   8000ab <syscall>
}
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800288:	6a 00                	push   $0x0
  80028a:	ff 75 14             	pushl  0x14(%ebp)
  80028d:	ff 75 10             	pushl  0x10(%ebp)
  800290:	ff 75 0c             	pushl  0xc(%ebp)
  800293:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800296:	ba 00 00 00 00       	mov    $0x0,%edx
  80029b:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002a0:	e8 06 fe ff ff       	call   8000ab <syscall>
}
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002ad:	6a 00                	push   $0x0
  8002af:	6a 00                	push   $0x0
  8002b1:	6a 00                	push   $0x0
  8002b3:	6a 00                	push   $0x0
  8002b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b8:	ba 01 00 00 00       	mov    $0x1,%edx
  8002bd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002c2:	e8 e4 fd ff ff       	call   8000ab <syscall>
}
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cf:	05 00 00 00 30       	add    $0x30000000,%eax
  8002d4:	c1 e8 0c             	shr    $0xc,%eax
}
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    

008002d9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002dc:	ff 75 08             	pushl  0x8(%ebp)
  8002df:	e8 e5 ff ff ff       	call   8002c9 <fd2num>
  8002e4:	83 c4 04             	add    $0x4,%esp
  8002e7:	c1 e0 0c             	shl    $0xc,%eax
  8002ea:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8002fc:	89 c2                	mov    %eax,%edx
  8002fe:	c1 ea 16             	shr    $0x16,%edx
  800301:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800308:	f6 c2 01             	test   $0x1,%dl
  80030b:	74 11                	je     80031e <fd_alloc+0x2d>
  80030d:	89 c2                	mov    %eax,%edx
  80030f:	c1 ea 0c             	shr    $0xc,%edx
  800312:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800319:	f6 c2 01             	test   $0x1,%dl
  80031c:	75 09                	jne    800327 <fd_alloc+0x36>
			*fd_store = fd;
  80031e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800320:	b8 00 00 00 00       	mov    $0x0,%eax
  800325:	eb 17                	jmp    80033e <fd_alloc+0x4d>
  800327:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80032c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800331:	75 c9                	jne    8002fc <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800333:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800339:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80033e:	5d                   	pop    %ebp
  80033f:	c3                   	ret    

00800340 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800346:	83 f8 1f             	cmp    $0x1f,%eax
  800349:	77 36                	ja     800381 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80034b:	c1 e0 0c             	shl    $0xc,%eax
  80034e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800353:	89 c2                	mov    %eax,%edx
  800355:	c1 ea 16             	shr    $0x16,%edx
  800358:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80035f:	f6 c2 01             	test   $0x1,%dl
  800362:	74 24                	je     800388 <fd_lookup+0x48>
  800364:	89 c2                	mov    %eax,%edx
  800366:	c1 ea 0c             	shr    $0xc,%edx
  800369:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800370:	f6 c2 01             	test   $0x1,%dl
  800373:	74 1a                	je     80038f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800375:	8b 55 0c             	mov    0xc(%ebp),%edx
  800378:	89 02                	mov    %eax,(%edx)
	return 0;
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	eb 13                	jmp    800394 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800381:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800386:	eb 0c                	jmp    800394 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800388:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80038d:	eb 05                	jmp    800394 <fd_lookup+0x54>
  80038f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039f:	ba f4 1d 80 00       	mov    $0x801df4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003a4:	eb 13                	jmp    8003b9 <dev_lookup+0x23>
  8003a6:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8003a9:	39 08                	cmp    %ecx,(%eax)
  8003ab:	75 0c                	jne    8003b9 <dev_lookup+0x23>
			*dev = devtab[i];
  8003ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b7:	eb 2e                	jmp    8003e7 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003b9:	8b 02                	mov    (%edx),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	75 e7                	jne    8003a6 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8003c4:	8b 40 48             	mov    0x48(%eax),%eax
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	51                   	push   %ecx
  8003cb:	50                   	push   %eax
  8003cc:	68 78 1d 80 00       	push   $0x801d78
  8003d1:	e8 d9 0c 00 00       	call   8010af <cprintf>
	*dev = 0;
  8003d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003df:	83 c4 10             	add    $0x10,%esp
  8003e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	56                   	push   %esi
  8003ed:	53                   	push   %ebx
  8003ee:	83 ec 10             	sub    $0x10,%esp
  8003f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8003f7:	56                   	push   %esi
  8003f8:	e8 cc fe ff ff       	call   8002c9 <fd2num>
  8003fd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800400:	89 14 24             	mov    %edx,(%esp)
  800403:	50                   	push   %eax
  800404:	e8 37 ff ff ff       	call   800340 <fd_lookup>
  800409:	83 c4 08             	add    $0x8,%esp
  80040c:	85 c0                	test   %eax,%eax
  80040e:	78 05                	js     800415 <fd_close+0x2c>
	    || fd != fd2)
  800410:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800413:	74 0c                	je     800421 <fd_close+0x38>
		return (must_exist ? r : 0);
  800415:	84 db                	test   %bl,%bl
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
  80041c:	0f 44 c2             	cmove  %edx,%eax
  80041f:	eb 41                	jmp    800462 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800421:	83 ec 08             	sub    $0x8,%esp
  800424:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800427:	50                   	push   %eax
  800428:	ff 36                	pushl  (%esi)
  80042a:	e8 67 ff ff ff       	call   800396 <dev_lookup>
  80042f:	89 c3                	mov    %eax,%ebx
  800431:	83 c4 10             	add    $0x10,%esp
  800434:	85 c0                	test   %eax,%eax
  800436:	78 1a                	js     800452 <fd_close+0x69>
		if (dev->dev_close)
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80043e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800443:	85 c0                	test   %eax,%eax
  800445:	74 0b                	je     800452 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	56                   	push   %esi
  80044b:	ff d0                	call   *%eax
  80044d:	89 c3                	mov    %eax,%ebx
  80044f:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	56                   	push   %esi
  800456:	6a 00                	push   $0x0
  800458:	e8 99 fd ff ff       	call   8001f6 <sys_page_unmap>
	return r;
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	89 d8                	mov    %ebx,%eax
}
  800462:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800465:	5b                   	pop    %ebx
  800466:	5e                   	pop    %esi
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80046f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800472:	50                   	push   %eax
  800473:	ff 75 08             	pushl  0x8(%ebp)
  800476:	e8 c5 fe ff ff       	call   800340 <fd_lookup>
  80047b:	83 c4 08             	add    $0x8,%esp
  80047e:	85 c0                	test   %eax,%eax
  800480:	78 10                	js     800492 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	6a 01                	push   $0x1
  800487:	ff 75 f4             	pushl  -0xc(%ebp)
  80048a:	e8 5a ff ff ff       	call   8003e9 <fd_close>
  80048f:	83 c4 10             	add    $0x10,%esp
}
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <close_all>:

void
close_all(void)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	53                   	push   %ebx
  800498:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80049b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004a0:	83 ec 0c             	sub    $0xc,%esp
  8004a3:	53                   	push   %ebx
  8004a4:	e8 c0 ff ff ff       	call   800469 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8004a9:	83 c3 01             	add    $0x1,%ebx
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	83 fb 20             	cmp    $0x20,%ebx
  8004b2:	75 ec                	jne    8004a0 <close_all+0xc>
		close(i);
}
  8004b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b7:	c9                   	leave  
  8004b8:	c3                   	ret    

008004b9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	57                   	push   %edi
  8004bd:	56                   	push   %esi
  8004be:	53                   	push   %ebx
  8004bf:	83 ec 2c             	sub    $0x2c,%esp
  8004c2:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004c8:	50                   	push   %eax
  8004c9:	ff 75 08             	pushl  0x8(%ebp)
  8004cc:	e8 6f fe ff ff       	call   800340 <fd_lookup>
  8004d1:	83 c4 08             	add    $0x8,%esp
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	0f 88 c1 00 00 00    	js     80059d <dup+0xe4>
		return r;
	close(newfdnum);
  8004dc:	83 ec 0c             	sub    $0xc,%esp
  8004df:	56                   	push   %esi
  8004e0:	e8 84 ff ff ff       	call   800469 <close>

	newfd = INDEX2FD(newfdnum);
  8004e5:	89 f3                	mov    %esi,%ebx
  8004e7:	c1 e3 0c             	shl    $0xc,%ebx
  8004ea:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8004f0:	83 c4 04             	add    $0x4,%esp
  8004f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004f6:	e8 de fd ff ff       	call   8002d9 <fd2data>
  8004fb:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8004fd:	89 1c 24             	mov    %ebx,(%esp)
  800500:	e8 d4 fd ff ff       	call   8002d9 <fd2data>
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80050b:	89 f8                	mov    %edi,%eax
  80050d:	c1 e8 16             	shr    $0x16,%eax
  800510:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800517:	a8 01                	test   $0x1,%al
  800519:	74 37                	je     800552 <dup+0x99>
  80051b:	89 f8                	mov    %edi,%eax
  80051d:	c1 e8 0c             	shr    $0xc,%eax
  800520:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800527:	f6 c2 01             	test   $0x1,%dl
  80052a:	74 26                	je     800552 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80052c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800533:	83 ec 0c             	sub    $0xc,%esp
  800536:	25 07 0e 00 00       	and    $0xe07,%eax
  80053b:	50                   	push   %eax
  80053c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80053f:	6a 00                	push   $0x0
  800541:	57                   	push   %edi
  800542:	6a 00                	push   $0x0
  800544:	e8 87 fc ff ff       	call   8001d0 <sys_page_map>
  800549:	89 c7                	mov    %eax,%edi
  80054b:	83 c4 20             	add    $0x20,%esp
  80054e:	85 c0                	test   %eax,%eax
  800550:	78 2e                	js     800580 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800552:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800555:	89 d0                	mov    %edx,%eax
  800557:	c1 e8 0c             	shr    $0xc,%eax
  80055a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	25 07 0e 00 00       	and    $0xe07,%eax
  800569:	50                   	push   %eax
  80056a:	53                   	push   %ebx
  80056b:	6a 00                	push   $0x0
  80056d:	52                   	push   %edx
  80056e:	6a 00                	push   $0x0
  800570:	e8 5b fc ff ff       	call   8001d0 <sys_page_map>
  800575:	89 c7                	mov    %eax,%edi
  800577:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80057a:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80057c:	85 ff                	test   %edi,%edi
  80057e:	79 1d                	jns    80059d <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	53                   	push   %ebx
  800584:	6a 00                	push   $0x0
  800586:	e8 6b fc ff ff       	call   8001f6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80058b:	83 c4 08             	add    $0x8,%esp
  80058e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800591:	6a 00                	push   $0x0
  800593:	e8 5e fc ff ff       	call   8001f6 <sys_page_unmap>
	return r;
  800598:	83 c4 10             	add    $0x10,%esp
  80059b:	89 f8                	mov    %edi,%eax
}
  80059d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a0:	5b                   	pop    %ebx
  8005a1:	5e                   	pop    %esi
  8005a2:	5f                   	pop    %edi
  8005a3:	5d                   	pop    %ebp
  8005a4:	c3                   	ret    

008005a5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	53                   	push   %ebx
  8005a9:	83 ec 14             	sub    $0x14,%esp
  8005ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005b2:	50                   	push   %eax
  8005b3:	53                   	push   %ebx
  8005b4:	e8 87 fd ff ff       	call   800340 <fd_lookup>
  8005b9:	83 c4 08             	add    $0x8,%esp
  8005bc:	89 c2                	mov    %eax,%edx
  8005be:	85 c0                	test   %eax,%eax
  8005c0:	78 6d                	js     80062f <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005c8:	50                   	push   %eax
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cc:	ff 30                	pushl  (%eax)
  8005ce:	e8 c3 fd ff ff       	call   800396 <dev_lookup>
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	78 4c                	js     800626 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005dd:	8b 42 08             	mov    0x8(%edx),%eax
  8005e0:	83 e0 03             	and    $0x3,%eax
  8005e3:	83 f8 01             	cmp    $0x1,%eax
  8005e6:	75 21                	jne    800609 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8005e8:	a1 04 40 80 00       	mov    0x804004,%eax
  8005ed:	8b 40 48             	mov    0x48(%eax),%eax
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	50                   	push   %eax
  8005f5:	68 b9 1d 80 00       	push   $0x801db9
  8005fa:	e8 b0 0a 00 00       	call   8010af <cprintf>
		return -E_INVAL;
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800607:	eb 26                	jmp    80062f <read+0x8a>
	}
	if (!dev->dev_read)
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060c:	8b 40 08             	mov    0x8(%eax),%eax
  80060f:	85 c0                	test   %eax,%eax
  800611:	74 17                	je     80062a <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	ff 75 10             	pushl  0x10(%ebp)
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	52                   	push   %edx
  80061d:	ff d0                	call   *%eax
  80061f:	89 c2                	mov    %eax,%edx
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	eb 09                	jmp    80062f <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800626:	89 c2                	mov    %eax,%edx
  800628:	eb 05                	jmp    80062f <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80062a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80062f:	89 d0                	mov    %edx,%eax
  800631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800634:	c9                   	leave  
  800635:	c3                   	ret    

00800636 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	57                   	push   %edi
  80063a:	56                   	push   %esi
  80063b:	53                   	push   %ebx
  80063c:	83 ec 0c             	sub    $0xc,%esp
  80063f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800642:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800645:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064a:	eb 21                	jmp    80066d <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80064c:	83 ec 04             	sub    $0x4,%esp
  80064f:	89 f0                	mov    %esi,%eax
  800651:	29 d8                	sub    %ebx,%eax
  800653:	50                   	push   %eax
  800654:	89 d8                	mov    %ebx,%eax
  800656:	03 45 0c             	add    0xc(%ebp),%eax
  800659:	50                   	push   %eax
  80065a:	57                   	push   %edi
  80065b:	e8 45 ff ff ff       	call   8005a5 <read>
		if (m < 0)
  800660:	83 c4 10             	add    $0x10,%esp
  800663:	85 c0                	test   %eax,%eax
  800665:	78 10                	js     800677 <readn+0x41>
			return m;
		if (m == 0)
  800667:	85 c0                	test   %eax,%eax
  800669:	74 0a                	je     800675 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80066b:	01 c3                	add    %eax,%ebx
  80066d:	39 f3                	cmp    %esi,%ebx
  80066f:	72 db                	jb     80064c <readn+0x16>
  800671:	89 d8                	mov    %ebx,%eax
  800673:	eb 02                	jmp    800677 <readn+0x41>
  800675:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800677:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067a:	5b                   	pop    %ebx
  80067b:	5e                   	pop    %esi
  80067c:	5f                   	pop    %edi
  80067d:	5d                   	pop    %ebp
  80067e:	c3                   	ret    

0080067f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800689:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80068c:	50                   	push   %eax
  80068d:	53                   	push   %ebx
  80068e:	e8 ad fc ff ff       	call   800340 <fd_lookup>
  800693:	83 c4 08             	add    $0x8,%esp
  800696:	89 c2                	mov    %eax,%edx
  800698:	85 c0                	test   %eax,%eax
  80069a:	78 68                	js     800704 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a6:	ff 30                	pushl  (%eax)
  8006a8:	e8 e9 fc ff ff       	call   800396 <dev_lookup>
  8006ad:	83 c4 10             	add    $0x10,%esp
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	78 47                	js     8006fb <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006bb:	75 21                	jne    8006de <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8006c2:	8b 40 48             	mov    0x48(%eax),%eax
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	53                   	push   %ebx
  8006c9:	50                   	push   %eax
  8006ca:	68 d5 1d 80 00       	push   $0x801dd5
  8006cf:	e8 db 09 00 00       	call   8010af <cprintf>
		return -E_INVAL;
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006dc:	eb 26                	jmp    800704 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e1:	8b 52 0c             	mov    0xc(%edx),%edx
  8006e4:	85 d2                	test   %edx,%edx
  8006e6:	74 17                	je     8006ff <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	ff 75 10             	pushl  0x10(%ebp)
  8006ee:	ff 75 0c             	pushl  0xc(%ebp)
  8006f1:	50                   	push   %eax
  8006f2:	ff d2                	call   *%edx
  8006f4:	89 c2                	mov    %eax,%edx
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	eb 09                	jmp    800704 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006fb:	89 c2                	mov    %eax,%edx
  8006fd:	eb 05                	jmp    800704 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8006ff:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  800704:	89 d0                	mov    %edx,%eax
  800706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800709:	c9                   	leave  
  80070a:	c3                   	ret    

0080070b <seek>:

int
seek(int fdnum, off_t offset)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800711:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800714:	50                   	push   %eax
  800715:	ff 75 08             	pushl  0x8(%ebp)
  800718:	e8 23 fc ff ff       	call   800340 <fd_lookup>
  80071d:	83 c4 08             	add    $0x8,%esp
  800720:	85 c0                	test   %eax,%eax
  800722:	78 0e                	js     800732 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800724:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80072d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800732:	c9                   	leave  
  800733:	c3                   	ret    

00800734 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	53                   	push   %ebx
  800738:	83 ec 14             	sub    $0x14,%esp
  80073b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80073e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800741:	50                   	push   %eax
  800742:	53                   	push   %ebx
  800743:	e8 f8 fb ff ff       	call   800340 <fd_lookup>
  800748:	83 c4 08             	add    $0x8,%esp
  80074b:	89 c2                	mov    %eax,%edx
  80074d:	85 c0                	test   %eax,%eax
  80074f:	78 65                	js     8007b6 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800757:	50                   	push   %eax
  800758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075b:	ff 30                	pushl  (%eax)
  80075d:	e8 34 fc ff ff       	call   800396 <dev_lookup>
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	85 c0                	test   %eax,%eax
  800767:	78 44                	js     8007ad <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800770:	75 21                	jne    800793 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800772:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800777:	8b 40 48             	mov    0x48(%eax),%eax
  80077a:	83 ec 04             	sub    $0x4,%esp
  80077d:	53                   	push   %ebx
  80077e:	50                   	push   %eax
  80077f:	68 98 1d 80 00       	push   $0x801d98
  800784:	e8 26 09 00 00       	call   8010af <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800791:	eb 23                	jmp    8007b6 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	8b 52 18             	mov    0x18(%edx),%edx
  800799:	85 d2                	test   %edx,%edx
  80079b:	74 14                	je     8007b1 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	50                   	push   %eax
  8007a4:	ff d2                	call   *%edx
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	eb 09                	jmp    8007b6 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ad:	89 c2                	mov    %eax,%edx
  8007af:	eb 05                	jmp    8007b6 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007b1:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007b6:	89 d0                	mov    %edx,%eax
  8007b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	53                   	push   %ebx
  8007c1:	83 ec 14             	sub    $0x14,%esp
  8007c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007ca:	50                   	push   %eax
  8007cb:	ff 75 08             	pushl  0x8(%ebp)
  8007ce:	e8 6d fb ff ff       	call   800340 <fd_lookup>
  8007d3:	83 c4 08             	add    $0x8,%esp
  8007d6:	89 c2                	mov    %eax,%edx
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	78 58                	js     800834 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007e2:	50                   	push   %eax
  8007e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e6:	ff 30                	pushl  (%eax)
  8007e8:	e8 a9 fb ff ff       	call   800396 <dev_lookup>
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	78 37                	js     80082b <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8007f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8007fb:	74 32                	je     80082f <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8007fd:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800800:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800807:	00 00 00 
	stat->st_isdir = 0;
  80080a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800811:	00 00 00 
	stat->st_dev = dev;
  800814:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	ff 75 f0             	pushl  -0x10(%ebp)
  800821:	ff 50 14             	call   *0x14(%eax)
  800824:	89 c2                	mov    %eax,%edx
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	eb 09                	jmp    800834 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80082b:	89 c2                	mov    %eax,%edx
  80082d:	eb 05                	jmp    800834 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80082f:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800834:	89 d0                	mov    %edx,%eax
  800836:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	56                   	push   %esi
  80083f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	6a 00                	push   $0x0
  800845:	ff 75 08             	pushl  0x8(%ebp)
  800848:	e8 06 02 00 00       	call   800a53 <open>
  80084d:	89 c3                	mov    %eax,%ebx
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	85 c0                	test   %eax,%eax
  800854:	78 1b                	js     800871 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	50                   	push   %eax
  80085d:	e8 5b ff ff ff       	call   8007bd <fstat>
  800862:	89 c6                	mov    %eax,%esi
	close(fd);
  800864:	89 1c 24             	mov    %ebx,(%esp)
  800867:	e8 fd fb ff ff       	call   800469 <close>
	return r;
  80086c:	83 c4 10             	add    $0x10,%esp
  80086f:	89 f0                	mov    %esi,%eax
}
  800871:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800874:	5b                   	pop    %ebx
  800875:	5e                   	pop    %esi
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	56                   	push   %esi
  80087c:	53                   	push   %ebx
  80087d:	89 c6                	mov    %eax,%esi
  80087f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800881:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800888:	75 12                	jne    80089c <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80088a:	83 ec 0c             	sub    $0xc,%esp
  80088d:	6a 01                	push   $0x1
  80088f:	e8 94 11 00 00       	call   801a28 <ipc_find_env>
  800894:	a3 00 40 80 00       	mov    %eax,0x804000
  800899:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80089c:	6a 07                	push   $0x7
  80089e:	68 00 50 80 00       	push   $0x805000
  8008a3:	56                   	push   %esi
  8008a4:	ff 35 00 40 80 00    	pushl  0x804000
  8008aa:	e8 25 11 00 00       	call   8019d4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008af:	83 c4 0c             	add    $0xc,%esp
  8008b2:	6a 00                	push   $0x0
  8008b4:	53                   	push   %ebx
  8008b5:	6a 00                	push   $0x0
  8008b7:	e8 ad 10 00 00       	call   801969 <ipc_recv>
}
  8008bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8008cf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e1:	b8 02 00 00 00       	mov    $0x2,%eax
  8008e6:	e8 8d ff ff ff       	call   800878 <fsipc>
}
  8008eb:	c9                   	leave  
  8008ec:	c3                   	ret    

008008ed <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8008f9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800903:	b8 06 00 00 00       	mov    $0x6,%eax
  800908:	e8 6b ff ff ff       	call   800878 <fsipc>
}
  80090d:	c9                   	leave  
  80090e:	c3                   	ret    

0080090f <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	53                   	push   %ebx
  800913:	83 ec 04             	sub    $0x4,%esp
  800916:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 40 0c             	mov    0xc(%eax),%eax
  80091f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
  800929:	b8 05 00 00 00       	mov    $0x5,%eax
  80092e:	e8 45 ff ff ff       	call   800878 <fsipc>
  800933:	85 c0                	test   %eax,%eax
  800935:	78 2c                	js     800963 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	68 00 50 80 00       	push   $0x805000
  80093f:	53                   	push   %ebx
  800940:	e8 dc 0c 00 00       	call   801621 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800945:	a1 80 50 80 00       	mov    0x805080,%eax
  80094a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800950:	a1 84 50 80 00       	mov    0x805084,%eax
  800955:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800963:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800974:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800977:	8b 49 0c             	mov    0xc(%ecx),%ecx
  80097a:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  800980:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800985:	76 22                	jbe    8009a9 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  800987:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  80098e:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	68 f8 0f 00 00       	push   $0xff8
  800999:	52                   	push   %edx
  80099a:	68 08 50 80 00       	push   $0x805008
  80099f:	e8 10 0e 00 00       	call   8017b4 <memmove>
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	eb 17                	jmp    8009c0 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8009a9:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009ae:	83 ec 04             	sub    $0x4,%esp
  8009b1:	50                   	push   %eax
  8009b2:	52                   	push   %edx
  8009b3:	68 08 50 80 00       	push   $0x805008
  8009b8:	e8 f7 0d 00 00       	call   8017b4 <memmove>
  8009bd:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	b8 04 00 00 00       	mov    $0x4,%eax
  8009ca:	e8 a9 fe ff ff       	call   800878 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8009df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8009e4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8009ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8009f4:	e8 7f fe ff ff       	call   800878 <fsipc>
  8009f9:	89 c3                	mov    %eax,%ebx
  8009fb:	85 c0                	test   %eax,%eax
  8009fd:	78 4b                	js     800a4a <devfile_read+0x79>
		return r;
	assert(r <= n);
  8009ff:	39 c6                	cmp    %eax,%esi
  800a01:	73 16                	jae    800a19 <devfile_read+0x48>
  800a03:	68 04 1e 80 00       	push   $0x801e04
  800a08:	68 0b 1e 80 00       	push   $0x801e0b
  800a0d:	6a 7c                	push   $0x7c
  800a0f:	68 20 1e 80 00       	push   $0x801e20
  800a14:	e8 bd 05 00 00       	call   800fd6 <_panic>
	assert(r <= PGSIZE);
  800a19:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a1e:	7e 16                	jle    800a36 <devfile_read+0x65>
  800a20:	68 2b 1e 80 00       	push   $0x801e2b
  800a25:	68 0b 1e 80 00       	push   $0x801e0b
  800a2a:	6a 7d                	push   $0x7d
  800a2c:	68 20 1e 80 00       	push   $0x801e20
  800a31:	e8 a0 05 00 00       	call   800fd6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a36:	83 ec 04             	sub    $0x4,%esp
  800a39:	50                   	push   %eax
  800a3a:	68 00 50 80 00       	push   $0x805000
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	e8 6d 0d 00 00       	call   8017b4 <memmove>
	return r;
  800a47:	83 c4 10             	add    $0x10,%esp
}
  800a4a:	89 d8                	mov    %ebx,%eax
  800a4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4f:	5b                   	pop    %ebx
  800a50:	5e                   	pop    %esi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	53                   	push   %ebx
  800a57:	83 ec 20             	sub    $0x20,%esp
  800a5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a5d:	53                   	push   %ebx
  800a5e:	e8 85 0b 00 00       	call   8015e8 <strlen>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a6b:	7f 67                	jg     800ad4 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a6d:	83 ec 0c             	sub    $0xc,%esp
  800a70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 78 f8 ff ff       	call   8002f1 <fd_alloc>
  800a79:	83 c4 10             	add    $0x10,%esp
		return r;
  800a7c:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a7e:	85 c0                	test   %eax,%eax
  800a80:	78 57                	js     800ad9 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	53                   	push   %ebx
  800a86:	68 00 50 80 00       	push   $0x805000
  800a8b:	e8 91 0b 00 00       	call   801621 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9b:	b8 01 00 00 00       	mov    $0x1,%eax
  800aa0:	e8 d3 fd ff ff       	call   800878 <fsipc>
  800aa5:	89 c3                	mov    %eax,%ebx
  800aa7:	83 c4 10             	add    $0x10,%esp
  800aaa:	85 c0                	test   %eax,%eax
  800aac:	79 14                	jns    800ac2 <open+0x6f>
		fd_close(fd, 0);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	6a 00                	push   $0x0
  800ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab6:	e8 2e f9 ff ff       	call   8003e9 <fd_close>
		return r;
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	89 da                	mov    %ebx,%edx
  800ac0:	eb 17                	jmp    800ad9 <open+0x86>
	}

	return fd2num(fd);
  800ac2:	83 ec 0c             	sub    $0xc,%esp
  800ac5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac8:	e8 fc f7 ff ff       	call   8002c9 <fd2num>
  800acd:	89 c2                	mov    %eax,%edx
  800acf:	83 c4 10             	add    $0x10,%esp
  800ad2:	eb 05                	jmp    800ad9 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800ad4:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800ad9:	89 d0                	mov    %edx,%eax
  800adb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aeb:	b8 08 00 00 00       	mov    $0x8,%eax
  800af0:	e8 83 fd ff ff       	call   800878 <fsipc>
}
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	56                   	push   %esi
  800afb:	53                   	push   %ebx
  800afc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800aff:	83 ec 0c             	sub    $0xc,%esp
  800b02:	ff 75 08             	pushl  0x8(%ebp)
  800b05:	e8 cf f7 ff ff       	call   8002d9 <fd2data>
  800b0a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b0c:	83 c4 08             	add    $0x8,%esp
  800b0f:	68 37 1e 80 00       	push   $0x801e37
  800b14:	53                   	push   %ebx
  800b15:	e8 07 0b 00 00       	call   801621 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b1a:	8b 46 04             	mov    0x4(%esi),%eax
  800b1d:	2b 06                	sub    (%esi),%eax
  800b1f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b25:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b2c:	00 00 00 
	stat->st_dev = &devpipe;
  800b2f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b36:	30 80 00 
	return 0;
}
  800b39:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	53                   	push   %ebx
  800b49:	83 ec 0c             	sub    $0xc,%esp
  800b4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b4f:	53                   	push   %ebx
  800b50:	6a 00                	push   $0x0
  800b52:	e8 9f f6 ff ff       	call   8001f6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b57:	89 1c 24             	mov    %ebx,(%esp)
  800b5a:	e8 7a f7 ff ff       	call   8002d9 <fd2data>
  800b5f:	83 c4 08             	add    $0x8,%esp
  800b62:	50                   	push   %eax
  800b63:	6a 00                	push   $0x0
  800b65:	e8 8c f6 ff ff       	call   8001f6 <sys_page_unmap>
}
  800b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    

00800b6f <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	83 ec 1c             	sub    $0x1c,%esp
  800b78:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b7b:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b7d:	a1 04 40 80 00       	mov    0x804004,%eax
  800b82:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800b85:	83 ec 0c             	sub    $0xc,%esp
  800b88:	ff 75 e0             	pushl  -0x20(%ebp)
  800b8b:	e8 d1 0e 00 00       	call   801a61 <pageref>
  800b90:	89 c3                	mov    %eax,%ebx
  800b92:	89 3c 24             	mov    %edi,(%esp)
  800b95:	e8 c7 0e 00 00       	call   801a61 <pageref>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	39 c3                	cmp    %eax,%ebx
  800b9f:	0f 94 c1             	sete   %cl
  800ba2:	0f b6 c9             	movzbl %cl,%ecx
  800ba5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800ba8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800bae:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800bb1:	39 ce                	cmp    %ecx,%esi
  800bb3:	74 1b                	je     800bd0 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800bb5:	39 c3                	cmp    %eax,%ebx
  800bb7:	75 c4                	jne    800b7d <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bb9:	8b 42 58             	mov    0x58(%edx),%eax
  800bbc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bbf:	50                   	push   %eax
  800bc0:	56                   	push   %esi
  800bc1:	68 3e 1e 80 00       	push   $0x801e3e
  800bc6:	e8 e4 04 00 00       	call   8010af <cprintf>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	eb ad                	jmp    800b7d <_pipeisclosed+0xe>
	}
}
  800bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	57                   	push   %edi
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
  800be1:	83 ec 28             	sub    $0x28,%esp
  800be4:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800be7:	56                   	push   %esi
  800be8:	e8 ec f6 ff ff       	call   8002d9 <fd2data>
  800bed:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf7:	eb 4b                	jmp    800c44 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800bf9:	89 da                	mov    %ebx,%edx
  800bfb:	89 f0                	mov    %esi,%eax
  800bfd:	e8 6d ff ff ff       	call   800b6f <_pipeisclosed>
  800c02:	85 c0                	test   %eax,%eax
  800c04:	75 48                	jne    800c4e <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800c06:	e8 7a f5 ff ff       	call   800185 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c0b:	8b 43 04             	mov    0x4(%ebx),%eax
  800c0e:	8b 0b                	mov    (%ebx),%ecx
  800c10:	8d 51 20             	lea    0x20(%ecx),%edx
  800c13:	39 d0                	cmp    %edx,%eax
  800c15:	73 e2                	jae    800bf9 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c1e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c21:	89 c2                	mov    %eax,%edx
  800c23:	c1 fa 1f             	sar    $0x1f,%edx
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	c1 e9 1b             	shr    $0x1b,%ecx
  800c2b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c2e:	83 e2 1f             	and    $0x1f,%edx
  800c31:	29 ca                	sub    %ecx,%edx
  800c33:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c37:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c3b:	83 c0 01             	add    $0x1,%eax
  800c3e:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c41:	83 c7 01             	add    $0x1,%edi
  800c44:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c47:	75 c2                	jne    800c0b <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c49:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4c:	eb 05                	jmp    800c53 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c4e:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	83 ec 18             	sub    $0x18,%esp
  800c64:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c67:	57                   	push   %edi
  800c68:	e8 6c f6 ff ff       	call   8002d9 <fd2data>
  800c6d:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c77:	eb 3d                	jmp    800cb6 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c79:	85 db                	test   %ebx,%ebx
  800c7b:	74 04                	je     800c81 <devpipe_read+0x26>
				return i;
  800c7d:	89 d8                	mov    %ebx,%eax
  800c7f:	eb 44                	jmp    800cc5 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c81:	89 f2                	mov    %esi,%edx
  800c83:	89 f8                	mov    %edi,%eax
  800c85:	e8 e5 fe ff ff       	call   800b6f <_pipeisclosed>
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	75 32                	jne    800cc0 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800c8e:	e8 f2 f4 ff ff       	call   800185 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800c93:	8b 06                	mov    (%esi),%eax
  800c95:	3b 46 04             	cmp    0x4(%esi),%eax
  800c98:	74 df                	je     800c79 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800c9a:	99                   	cltd   
  800c9b:	c1 ea 1b             	shr    $0x1b,%edx
  800c9e:	01 d0                	add    %edx,%eax
  800ca0:	83 e0 1f             	and    $0x1f,%eax
  800ca3:	29 d0                	sub    %edx,%eax
  800ca5:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800cb0:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800cb3:	83 c3 01             	add    $0x1,%ebx
  800cb6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cb9:	75 d8                	jne    800c93 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbe:	eb 05                	jmp    800cc5 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    

00800ccd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
  800cd2:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cd8:	50                   	push   %eax
  800cd9:	e8 13 f6 ff ff       	call   8002f1 <fd_alloc>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	89 c2                	mov    %eax,%edx
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	0f 88 2c 01 00 00    	js     800e17 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ceb:	83 ec 04             	sub    $0x4,%esp
  800cee:	68 07 04 00 00       	push   $0x407
  800cf3:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf6:	6a 00                	push   $0x0
  800cf8:	e8 af f4 ff ff       	call   8001ac <sys_page_alloc>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	85 c0                	test   %eax,%eax
  800d04:	0f 88 0d 01 00 00    	js     800e17 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d10:	50                   	push   %eax
  800d11:	e8 db f5 ff ff       	call   8002f1 <fd_alloc>
  800d16:	89 c3                	mov    %eax,%ebx
  800d18:	83 c4 10             	add    $0x10,%esp
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	0f 88 e2 00 00 00    	js     800e05 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d23:	83 ec 04             	sub    $0x4,%esp
  800d26:	68 07 04 00 00       	push   $0x407
  800d2b:	ff 75 f0             	pushl  -0x10(%ebp)
  800d2e:	6a 00                	push   $0x0
  800d30:	e8 77 f4 ff ff       	call   8001ac <sys_page_alloc>
  800d35:	89 c3                	mov    %eax,%ebx
  800d37:	83 c4 10             	add    $0x10,%esp
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	0f 88 c3 00 00 00    	js     800e05 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	ff 75 f4             	pushl  -0xc(%ebp)
  800d48:	e8 8c f5 ff ff       	call   8002d9 <fd2data>
  800d4d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d4f:	83 c4 0c             	add    $0xc,%esp
  800d52:	68 07 04 00 00       	push   $0x407
  800d57:	50                   	push   %eax
  800d58:	6a 00                	push   $0x0
  800d5a:	e8 4d f4 ff ff       	call   8001ac <sys_page_alloc>
  800d5f:	89 c3                	mov    %eax,%ebx
  800d61:	83 c4 10             	add    $0x10,%esp
  800d64:	85 c0                	test   %eax,%eax
  800d66:	0f 88 89 00 00 00    	js     800df5 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	ff 75 f0             	pushl  -0x10(%ebp)
  800d72:	e8 62 f5 ff ff       	call   8002d9 <fd2data>
  800d77:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d7e:	50                   	push   %eax
  800d7f:	6a 00                	push   $0x0
  800d81:	56                   	push   %esi
  800d82:	6a 00                	push   $0x0
  800d84:	e8 47 f4 ff ff       	call   8001d0 <sys_page_map>
  800d89:	89 c3                	mov    %eax,%ebx
  800d8b:	83 c4 20             	add    $0x20,%esp
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	78 55                	js     800de7 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800d92:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9b:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800da0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800da7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800dbc:	83 ec 0c             	sub    $0xc,%esp
  800dbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc2:	e8 02 f5 ff ff       	call   8002c9 <fd2num>
  800dc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dcc:	83 c4 04             	add    $0x4,%esp
  800dcf:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd2:	e8 f2 f4 ff ff       	call   8002c9 <fd2num>
  800dd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dda:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800ddd:	83 c4 10             	add    $0x10,%esp
  800de0:	ba 00 00 00 00       	mov    $0x0,%edx
  800de5:	eb 30                	jmp    800e17 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	56                   	push   %esi
  800deb:	6a 00                	push   $0x0
  800ded:	e8 04 f4 ff ff       	call   8001f6 <sys_page_unmap>
  800df2:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800df5:	83 ec 08             	sub    $0x8,%esp
  800df8:	ff 75 f0             	pushl  -0x10(%ebp)
  800dfb:	6a 00                	push   $0x0
  800dfd:	e8 f4 f3 ff ff       	call   8001f6 <sys_page_unmap>
  800e02:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0b:	6a 00                	push   $0x0
  800e0d:	e8 e4 f3 ff ff       	call   8001f6 <sys_page_unmap>
  800e12:	83 c4 10             	add    $0x10,%esp
  800e15:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e17:	89 d0                	mov    %edx,%eax
  800e19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e29:	50                   	push   %eax
  800e2a:	ff 75 08             	pushl  0x8(%ebp)
  800e2d:	e8 0e f5 ff ff       	call   800340 <fd_lookup>
  800e32:	83 c4 10             	add    $0x10,%esp
  800e35:	85 c0                	test   %eax,%eax
  800e37:	78 18                	js     800e51 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3f:	e8 95 f4 ff ff       	call   8002d9 <fd2data>
	return _pipeisclosed(fd, p);
  800e44:	89 c2                	mov    %eax,%edx
  800e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e49:	e8 21 fd ff ff       	call   800b6f <_pipeisclosed>
  800e4e:	83 c4 10             	add    $0x10,%esp
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e56:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e63:	68 56 1e 80 00       	push   $0x801e56
  800e68:	ff 75 0c             	pushl  0xc(%ebp)
  800e6b:	e8 b1 07 00 00       	call   801621 <strcpy>
	return 0;
}
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e83:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e88:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e8e:	eb 2d                	jmp    800ebd <devcons_write+0x46>
		m = n - tot;
  800e90:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e93:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800e95:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800e98:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800e9d:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800ea0:	83 ec 04             	sub    $0x4,%esp
  800ea3:	53                   	push   %ebx
  800ea4:	03 45 0c             	add    0xc(%ebp),%eax
  800ea7:	50                   	push   %eax
  800ea8:	57                   	push   %edi
  800ea9:	e8 06 09 00 00       	call   8017b4 <memmove>
		sys_cputs(buf, m);
  800eae:	83 c4 08             	add    $0x8,%esp
  800eb1:	53                   	push   %ebx
  800eb2:	57                   	push   %edi
  800eb3:	e8 3d f2 ff ff       	call   8000f5 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800eb8:	01 de                	add    %ebx,%esi
  800eba:	83 c4 10             	add    $0x10,%esp
  800ebd:	89 f0                	mov    %esi,%eax
  800ebf:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ec2:	72 cc                	jb     800e90 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 08             	sub    $0x8,%esp
  800ed2:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800ed7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edb:	74 2a                	je     800f07 <devcons_read+0x3b>
  800edd:	eb 05                	jmp    800ee4 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800edf:	e8 a1 f2 ff ff       	call   800185 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800ee4:	e8 32 f2 ff ff       	call   80011b <sys_cgetc>
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	74 f2                	je     800edf <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800eed:	85 c0                	test   %eax,%eax
  800eef:	78 16                	js     800f07 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800ef1:	83 f8 04             	cmp    $0x4,%eax
  800ef4:	74 0c                	je     800f02 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef9:	88 02                	mov    %al,(%edx)
	return 1;
  800efb:	b8 01 00 00 00       	mov    $0x1,%eax
  800f00:	eb 05                	jmp    800f07 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800f02:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f15:	6a 01                	push   $0x1
  800f17:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f1a:	50                   	push   %eax
  800f1b:	e8 d5 f1 ff ff       	call   8000f5 <sys_cputs>
}
  800f20:	83 c4 10             	add    $0x10,%esp
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <getchar>:

int
getchar(void)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f2b:	6a 01                	push   $0x1
  800f2d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f30:	50                   	push   %eax
  800f31:	6a 00                	push   $0x0
  800f33:	e8 6d f6 ff ff       	call   8005a5 <read>
	if (r < 0)
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	78 0f                	js     800f4e <getchar+0x29>
		return r;
	if (r < 1)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	7e 06                	jle    800f49 <getchar+0x24>
		return -E_EOF;
	return c;
  800f43:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f47:	eb 05                	jmp    800f4e <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f49:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f59:	50                   	push   %eax
  800f5a:	ff 75 08             	pushl  0x8(%ebp)
  800f5d:	e8 de f3 ff ff       	call   800340 <fd_lookup>
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	85 c0                	test   %eax,%eax
  800f67:	78 11                	js     800f7a <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800f72:	39 10                	cmp    %edx,(%eax)
  800f74:	0f 94 c0             	sete   %al
  800f77:	0f b6 c0             	movzbl %al,%eax
}
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    

00800f7c <opencons>:

int
opencons(void)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f85:	50                   	push   %eax
  800f86:	e8 66 f3 ff ff       	call   8002f1 <fd_alloc>
  800f8b:	83 c4 10             	add    $0x10,%esp
		return r;
  800f8e:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f90:	85 c0                	test   %eax,%eax
  800f92:	78 3e                	js     800fd2 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	68 07 04 00 00       	push   $0x407
  800f9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9f:	6a 00                	push   $0x0
  800fa1:	e8 06 f2 ff ff       	call   8001ac <sys_page_alloc>
  800fa6:	83 c4 10             	add    $0x10,%esp
		return r;
  800fa9:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fab:	85 c0                	test   %eax,%eax
  800fad:	78 23                	js     800fd2 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800faf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fbd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fc4:	83 ec 0c             	sub    $0xc,%esp
  800fc7:	50                   	push   %eax
  800fc8:	e8 fc f2 ff ff       	call   8002c9 <fd2num>
  800fcd:	89 c2                	mov    %eax,%edx
  800fcf:	83 c4 10             	add    $0x10,%esp
}
  800fd2:	89 d0                	mov    %edx,%eax
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	56                   	push   %esi
  800fda:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fdb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fde:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800fe4:	e8 78 f1 ff ff       	call   800161 <sys_getenvid>
  800fe9:	83 ec 0c             	sub    $0xc,%esp
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	56                   	push   %esi
  800ff3:	50                   	push   %eax
  800ff4:	68 64 1e 80 00       	push   $0x801e64
  800ff9:	e8 b1 00 00 00       	call   8010af <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ffe:	83 c4 18             	add    $0x18,%esp
  801001:	53                   	push   %ebx
  801002:	ff 75 10             	pushl  0x10(%ebp)
  801005:	e8 54 00 00 00       	call   80105e <vcprintf>
	cprintf("\n");
  80100a:	c7 04 24 4f 1e 80 00 	movl   $0x801e4f,(%esp)
  801011:	e8 99 00 00 00       	call   8010af <cprintf>
  801016:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801019:	cc                   	int3   
  80101a:	eb fd                	jmp    801019 <_panic+0x43>

0080101c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	53                   	push   %ebx
  801020:	83 ec 04             	sub    $0x4,%esp
  801023:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801026:	8b 13                	mov    (%ebx),%edx
  801028:	8d 42 01             	lea    0x1(%edx),%eax
  80102b:	89 03                	mov    %eax,(%ebx)
  80102d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801030:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801034:	3d ff 00 00 00       	cmp    $0xff,%eax
  801039:	75 1a                	jne    801055 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	68 ff 00 00 00       	push   $0xff
  801043:	8d 43 08             	lea    0x8(%ebx),%eax
  801046:	50                   	push   %eax
  801047:	e8 a9 f0 ff ff       	call   8000f5 <sys_cputs>
		b->idx = 0;
  80104c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801052:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801055:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801067:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80106e:	00 00 00 
	b.cnt = 0;
  801071:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801078:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80107b:	ff 75 0c             	pushl  0xc(%ebp)
  80107e:	ff 75 08             	pushl  0x8(%ebp)
  801081:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801087:	50                   	push   %eax
  801088:	68 1c 10 80 00       	push   $0x80101c
  80108d:	e8 86 01 00 00       	call   801218 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801092:	83 c4 08             	add    $0x8,%esp
  801095:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80109b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010a1:	50                   	push   %eax
  8010a2:	e8 4e f0 ff ff       	call   8000f5 <sys_cputs>

	return b.cnt;
}
  8010a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010b8:	50                   	push   %eax
  8010b9:	ff 75 08             	pushl  0x8(%ebp)
  8010bc:	e8 9d ff ff ff       	call   80105e <vcprintf>
	va_end(ap);

	return cnt;
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	57                   	push   %edi
  8010c7:	56                   	push   %esi
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 1c             	sub    $0x1c,%esp
  8010cc:	89 c7                	mov    %eax,%edi
  8010ce:	89 d6                	mov    %edx,%esi
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8010e7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010ea:	39 d3                	cmp    %edx,%ebx
  8010ec:	72 05                	jb     8010f3 <printnum+0x30>
  8010ee:	39 45 10             	cmp    %eax,0x10(%ebp)
  8010f1:	77 45                	ja     801138 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010f3:	83 ec 0c             	sub    $0xc,%esp
  8010f6:	ff 75 18             	pushl  0x18(%ebp)
  8010f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010ff:	53                   	push   %ebx
  801100:	ff 75 10             	pushl  0x10(%ebp)
  801103:	83 ec 08             	sub    $0x8,%esp
  801106:	ff 75 e4             	pushl  -0x1c(%ebp)
  801109:	ff 75 e0             	pushl  -0x20(%ebp)
  80110c:	ff 75 dc             	pushl  -0x24(%ebp)
  80110f:	ff 75 d8             	pushl  -0x28(%ebp)
  801112:	e8 89 09 00 00       	call   801aa0 <__udivdi3>
  801117:	83 c4 18             	add    $0x18,%esp
  80111a:	52                   	push   %edx
  80111b:	50                   	push   %eax
  80111c:	89 f2                	mov    %esi,%edx
  80111e:	89 f8                	mov    %edi,%eax
  801120:	e8 9e ff ff ff       	call   8010c3 <printnum>
  801125:	83 c4 20             	add    $0x20,%esp
  801128:	eb 18                	jmp    801142 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80112a:	83 ec 08             	sub    $0x8,%esp
  80112d:	56                   	push   %esi
  80112e:	ff 75 18             	pushl  0x18(%ebp)
  801131:	ff d7                	call   *%edi
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	eb 03                	jmp    80113b <printnum+0x78>
  801138:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80113b:	83 eb 01             	sub    $0x1,%ebx
  80113e:	85 db                	test   %ebx,%ebx
  801140:	7f e8                	jg     80112a <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801142:	83 ec 08             	sub    $0x8,%esp
  801145:	56                   	push   %esi
  801146:	83 ec 04             	sub    $0x4,%esp
  801149:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114c:	ff 75 e0             	pushl  -0x20(%ebp)
  80114f:	ff 75 dc             	pushl  -0x24(%ebp)
  801152:	ff 75 d8             	pushl  -0x28(%ebp)
  801155:	e8 76 0a 00 00       	call   801bd0 <__umoddi3>
  80115a:	83 c4 14             	add    $0x14,%esp
  80115d:	0f be 80 87 1e 80 00 	movsbl 0x801e87(%eax),%eax
  801164:	50                   	push   %eax
  801165:	ff d7                	call   *%edi
}
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5e                   	pop    %esi
  80116f:	5f                   	pop    %edi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    

00801172 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801175:	83 fa 01             	cmp    $0x1,%edx
  801178:	7e 0e                	jle    801188 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80117a:	8b 10                	mov    (%eax),%edx
  80117c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80117f:	89 08                	mov    %ecx,(%eax)
  801181:	8b 02                	mov    (%edx),%eax
  801183:	8b 52 04             	mov    0x4(%edx),%edx
  801186:	eb 22                	jmp    8011aa <getuint+0x38>
	else if (lflag)
  801188:	85 d2                	test   %edx,%edx
  80118a:	74 10                	je     80119c <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80118c:	8b 10                	mov    (%eax),%edx
  80118e:	8d 4a 04             	lea    0x4(%edx),%ecx
  801191:	89 08                	mov    %ecx,(%eax)
  801193:	8b 02                	mov    (%edx),%eax
  801195:	ba 00 00 00 00       	mov    $0x0,%edx
  80119a:	eb 0e                	jmp    8011aa <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80119c:	8b 10                	mov    (%eax),%edx
  80119e:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011a1:	89 08                	mov    %ecx,(%eax)
  8011a3:	8b 02                	mov    (%edx),%eax
  8011a5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011af:	83 fa 01             	cmp    $0x1,%edx
  8011b2:	7e 0e                	jle    8011c2 <getint+0x16>
		return va_arg(*ap, long long);
  8011b4:	8b 10                	mov    (%eax),%edx
  8011b6:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011b9:	89 08                	mov    %ecx,(%eax)
  8011bb:	8b 02                	mov    (%edx),%eax
  8011bd:	8b 52 04             	mov    0x4(%edx),%edx
  8011c0:	eb 1a                	jmp    8011dc <getint+0x30>
	else if (lflag)
  8011c2:	85 d2                	test   %edx,%edx
  8011c4:	74 0c                	je     8011d2 <getint+0x26>
		return va_arg(*ap, long);
  8011c6:	8b 10                	mov    (%eax),%edx
  8011c8:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011cb:	89 08                	mov    %ecx,(%eax)
  8011cd:	8b 02                	mov    (%edx),%eax
  8011cf:	99                   	cltd   
  8011d0:	eb 0a                	jmp    8011dc <getint+0x30>
	else
		return va_arg(*ap, int);
  8011d2:	8b 10                	mov    (%eax),%edx
  8011d4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011d7:	89 08                	mov    %ecx,(%eax)
  8011d9:	8b 02                	mov    (%edx),%eax
  8011db:	99                   	cltd   
}
  8011dc:	5d                   	pop    %ebp
  8011dd:	c3                   	ret    

008011de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011e8:	8b 10                	mov    (%eax),%edx
  8011ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8011ed:	73 0a                	jae    8011f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8011ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011f2:	89 08                	mov    %ecx,(%eax)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	88 02                	mov    %al,(%edx)
}
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  801201:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801204:	50                   	push   %eax
  801205:	ff 75 10             	pushl  0x10(%ebp)
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	ff 75 08             	pushl  0x8(%ebp)
  80120e:	e8 05 00 00 00       	call   801218 <vprintfmt>
	va_end(ap);
}
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	57                   	push   %edi
  80121c:	56                   	push   %esi
  80121d:	53                   	push   %ebx
  80121e:	83 ec 2c             	sub    $0x2c,%esp
  801221:	8b 75 08             	mov    0x8(%ebp),%esi
  801224:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801227:	8b 7d 10             	mov    0x10(%ebp),%edi
  80122a:	eb 12                	jmp    80123e <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80122c:	85 c0                	test   %eax,%eax
  80122e:	0f 84 44 03 00 00    	je     801578 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	53                   	push   %ebx
  801238:	50                   	push   %eax
  801239:	ff d6                	call   *%esi
  80123b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80123e:	83 c7 01             	add    $0x1,%edi
  801241:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801245:	83 f8 25             	cmp    $0x25,%eax
  801248:	75 e2                	jne    80122c <vprintfmt+0x14>
  80124a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80124e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801255:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80125c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801263:	ba 00 00 00 00       	mov    $0x0,%edx
  801268:	eb 07                	jmp    801271 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80126a:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80126d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801271:	8d 47 01             	lea    0x1(%edi),%eax
  801274:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801277:	0f b6 07             	movzbl (%edi),%eax
  80127a:	0f b6 c8             	movzbl %al,%ecx
  80127d:	83 e8 23             	sub    $0x23,%eax
  801280:	3c 55                	cmp    $0x55,%al
  801282:	0f 87 d5 02 00 00    	ja     80155d <vprintfmt+0x345>
  801288:	0f b6 c0             	movzbl %al,%eax
  80128b:	ff 24 85 c0 1f 80 00 	jmp    *0x801fc0(,%eax,4)
  801292:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801295:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801299:	eb d6                	jmp    801271 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80129b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80129e:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8012a6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8012a9:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012ad:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012b0:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012b3:	83 fa 09             	cmp    $0x9,%edx
  8012b6:	77 39                	ja     8012f1 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012b8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012bb:	eb e9                	jmp    8012a6 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c0:	8d 48 04             	lea    0x4(%eax),%ecx
  8012c3:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012c6:	8b 00                	mov    (%eax),%eax
  8012c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012ce:	eb 27                	jmp    8012f7 <vprintfmt+0xdf>
  8012d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012da:	0f 49 c8             	cmovns %eax,%ecx
  8012dd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012e3:	eb 8c                	jmp    801271 <vprintfmt+0x59>
  8012e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8012e8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012ef:	eb 80                	jmp    801271 <vprintfmt+0x59>
  8012f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012f4:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8012f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fb:	0f 89 70 ff ff ff    	jns    801271 <vprintfmt+0x59>
				width = precision, precision = -1;
  801301:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801304:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801307:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80130e:	e9 5e ff ff ff       	jmp    801271 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801313:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801319:	e9 53 ff ff ff       	jmp    801271 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80131e:	8b 45 14             	mov    0x14(%ebp),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	89 55 14             	mov    %edx,0x14(%ebp)
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	53                   	push   %ebx
  80132b:	ff 30                	pushl  (%eax)
  80132d:	ff d6                	call   *%esi
			break;
  80132f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801335:	e9 04 ff ff ff       	jmp    80123e <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80133a:	8b 45 14             	mov    0x14(%ebp),%eax
  80133d:	8d 50 04             	lea    0x4(%eax),%edx
  801340:	89 55 14             	mov    %edx,0x14(%ebp)
  801343:	8b 00                	mov    (%eax),%eax
  801345:	99                   	cltd   
  801346:	31 d0                	xor    %edx,%eax
  801348:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80134a:	83 f8 0f             	cmp    $0xf,%eax
  80134d:	7f 0b                	jg     80135a <vprintfmt+0x142>
  80134f:	8b 14 85 20 21 80 00 	mov    0x802120(,%eax,4),%edx
  801356:	85 d2                	test   %edx,%edx
  801358:	75 18                	jne    801372 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80135a:	50                   	push   %eax
  80135b:	68 9f 1e 80 00       	push   $0x801e9f
  801360:	53                   	push   %ebx
  801361:	56                   	push   %esi
  801362:	e8 94 fe ff ff       	call   8011fb <printfmt>
  801367:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80136a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80136d:	e9 cc fe ff ff       	jmp    80123e <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801372:	52                   	push   %edx
  801373:	68 1d 1e 80 00       	push   $0x801e1d
  801378:	53                   	push   %ebx
  801379:	56                   	push   %esi
  80137a:	e8 7c fe ff ff       	call   8011fb <printfmt>
  80137f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801385:	e9 b4 fe ff ff       	jmp    80123e <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8d 50 04             	lea    0x4(%eax),%edx
  801390:	89 55 14             	mov    %edx,0x14(%ebp)
  801393:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801395:	85 ff                	test   %edi,%edi
  801397:	b8 98 1e 80 00       	mov    $0x801e98,%eax
  80139c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80139f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013a3:	0f 8e 94 00 00 00    	jle    80143d <vprintfmt+0x225>
  8013a9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013ad:	0f 84 98 00 00 00    	je     80144b <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 d0             	pushl  -0x30(%ebp)
  8013b9:	57                   	push   %edi
  8013ba:	e8 41 02 00 00       	call   801600 <strnlen>
  8013bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013c2:	29 c1                	sub    %eax,%ecx
  8013c4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013c7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013ca:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013d1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013d4:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d6:	eb 0f                	jmp    8013e7 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013d8:	83 ec 08             	sub    $0x8,%esp
  8013db:	53                   	push   %ebx
  8013dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8013df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013e1:	83 ef 01             	sub    $0x1,%edi
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	85 ff                	test   %edi,%edi
  8013e9:	7f ed                	jg     8013d8 <vprintfmt+0x1c0>
  8013eb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013ee:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8013f1:	85 c9                	test   %ecx,%ecx
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f8:	0f 49 c1             	cmovns %ecx,%eax
  8013fb:	29 c1                	sub    %eax,%ecx
  8013fd:	89 75 08             	mov    %esi,0x8(%ebp)
  801400:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801403:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801406:	89 cb                	mov    %ecx,%ebx
  801408:	eb 4d                	jmp    801457 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80140a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80140e:	74 1b                	je     80142b <vprintfmt+0x213>
  801410:	0f be c0             	movsbl %al,%eax
  801413:	83 e8 20             	sub    $0x20,%eax
  801416:	83 f8 5e             	cmp    $0x5e,%eax
  801419:	76 10                	jbe    80142b <vprintfmt+0x213>
					putch('?', putdat);
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	ff 75 0c             	pushl  0xc(%ebp)
  801421:	6a 3f                	push   $0x3f
  801423:	ff 55 08             	call   *0x8(%ebp)
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	eb 0d                	jmp    801438 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	52                   	push   %edx
  801432:	ff 55 08             	call   *0x8(%ebp)
  801435:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801438:	83 eb 01             	sub    $0x1,%ebx
  80143b:	eb 1a                	jmp    801457 <vprintfmt+0x23f>
  80143d:	89 75 08             	mov    %esi,0x8(%ebp)
  801440:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801443:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801446:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801449:	eb 0c                	jmp    801457 <vprintfmt+0x23f>
  80144b:	89 75 08             	mov    %esi,0x8(%ebp)
  80144e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801451:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801454:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801457:	83 c7 01             	add    $0x1,%edi
  80145a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80145e:	0f be d0             	movsbl %al,%edx
  801461:	85 d2                	test   %edx,%edx
  801463:	74 23                	je     801488 <vprintfmt+0x270>
  801465:	85 f6                	test   %esi,%esi
  801467:	78 a1                	js     80140a <vprintfmt+0x1f2>
  801469:	83 ee 01             	sub    $0x1,%esi
  80146c:	79 9c                	jns    80140a <vprintfmt+0x1f2>
  80146e:	89 df                	mov    %ebx,%edi
  801470:	8b 75 08             	mov    0x8(%ebp),%esi
  801473:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801476:	eb 18                	jmp    801490 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	53                   	push   %ebx
  80147c:	6a 20                	push   $0x20
  80147e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801480:	83 ef 01             	sub    $0x1,%edi
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 08                	jmp    801490 <vprintfmt+0x278>
  801488:	89 df                	mov    %ebx,%edi
  80148a:	8b 75 08             	mov    0x8(%ebp),%esi
  80148d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801490:	85 ff                	test   %edi,%edi
  801492:	7f e4                	jg     801478 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801494:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801497:	e9 a2 fd ff ff       	jmp    80123e <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80149c:	8d 45 14             	lea    0x14(%ebp),%eax
  80149f:	e8 08 fd ff ff       	call   8011ac <getint>
  8014a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8014aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014b3:	79 74                	jns    801529 <vprintfmt+0x311>
				putch('-', putdat);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	53                   	push   %ebx
  8014b9:	6a 2d                	push   $0x2d
  8014bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8014bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014c3:	f7 d8                	neg    %eax
  8014c5:	83 d2 00             	adc    $0x0,%edx
  8014c8:	f7 da                	neg    %edx
  8014ca:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014d2:	eb 55                	jmp    801529 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8014d7:	e8 96 fc ff ff       	call   801172 <getuint>
			base = 10;
  8014dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014e1:	eb 46                	jmp    801529 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8014e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e6:	e8 87 fc ff ff       	call   801172 <getuint>
			base = 8;
  8014eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8014f0:	eb 37                	jmp    801529 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	53                   	push   %ebx
  8014f6:	6a 30                	push   $0x30
  8014f8:	ff d6                	call   *%esi
			putch('x', putdat);
  8014fa:	83 c4 08             	add    $0x8,%esp
  8014fd:	53                   	push   %ebx
  8014fe:	6a 78                	push   $0x78
  801500:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801502:	8b 45 14             	mov    0x14(%ebp),%eax
  801505:	8d 50 04             	lea    0x4(%eax),%edx
  801508:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80150b:	8b 00                	mov    (%eax),%eax
  80150d:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801512:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801515:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80151a:	eb 0d                	jmp    801529 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80151c:	8d 45 14             	lea    0x14(%ebp),%eax
  80151f:	e8 4e fc ff ff       	call   801172 <getuint>
			base = 16;
  801524:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801529:	83 ec 0c             	sub    $0xc,%esp
  80152c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801530:	57                   	push   %edi
  801531:	ff 75 e0             	pushl  -0x20(%ebp)
  801534:	51                   	push   %ecx
  801535:	52                   	push   %edx
  801536:	50                   	push   %eax
  801537:	89 da                	mov    %ebx,%edx
  801539:	89 f0                	mov    %esi,%eax
  80153b:	e8 83 fb ff ff       	call   8010c3 <printnum>
			break;
  801540:	83 c4 20             	add    $0x20,%esp
  801543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801546:	e9 f3 fc ff ff       	jmp    80123e <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	53                   	push   %ebx
  80154f:	51                   	push   %ecx
  801550:	ff d6                	call   *%esi
			break;
  801552:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801555:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801558:	e9 e1 fc ff ff       	jmp    80123e <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80155d:	83 ec 08             	sub    $0x8,%esp
  801560:	53                   	push   %ebx
  801561:	6a 25                	push   $0x25
  801563:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	eb 03                	jmp    80156d <vprintfmt+0x355>
  80156a:	83 ef 01             	sub    $0x1,%edi
  80156d:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  801571:	75 f7                	jne    80156a <vprintfmt+0x352>
  801573:	e9 c6 fc ff ff       	jmp    80123e <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5f                   	pop    %edi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 18             	sub    $0x18,%esp
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80158c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80158f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801593:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801596:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 26                	je     8015c7 <vsnprintf+0x47>
  8015a1:	85 d2                	test   %edx,%edx
  8015a3:	7e 22                	jle    8015c7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015a5:	ff 75 14             	pushl  0x14(%ebp)
  8015a8:	ff 75 10             	pushl  0x10(%ebp)
  8015ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015ae:	50                   	push   %eax
  8015af:	68 de 11 80 00       	push   $0x8011de
  8015b4:	e8 5f fc ff ff       	call   801218 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	eb 05                	jmp    8015cc <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015d4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015d7:	50                   	push   %eax
  8015d8:	ff 75 10             	pushl  0x10(%ebp)
  8015db:	ff 75 0c             	pushl  0xc(%ebp)
  8015de:	ff 75 08             	pushl  0x8(%ebp)
  8015e1:	e8 9a ff ff ff       	call   801580 <vsnprintf>
	va_end(ap);

	return rc;
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f3:	eb 03                	jmp    8015f8 <strlen+0x10>
		n++;
  8015f5:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8015fc:	75 f7                	jne    8015f5 <strlen+0xd>
		n++;
	return n;
}
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	ba 00 00 00 00       	mov    $0x0,%edx
  80160e:	eb 03                	jmp    801613 <strnlen+0x13>
		n++;
  801610:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801613:	39 c2                	cmp    %eax,%edx
  801615:	74 08                	je     80161f <strnlen+0x1f>
  801617:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80161b:	75 f3                	jne    801610 <strnlen+0x10>
  80161d:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	53                   	push   %ebx
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80162b:	89 c2                	mov    %eax,%edx
  80162d:	83 c2 01             	add    $0x1,%edx
  801630:	83 c1 01             	add    $0x1,%ecx
  801633:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801637:	88 5a ff             	mov    %bl,-0x1(%edx)
  80163a:	84 db                	test   %bl,%bl
  80163c:	75 ef                	jne    80162d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80163e:	5b                   	pop    %ebx
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	53                   	push   %ebx
  801645:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801648:	53                   	push   %ebx
  801649:	e8 9a ff ff ff       	call   8015e8 <strlen>
  80164e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	01 d8                	add    %ebx,%eax
  801656:	50                   	push   %eax
  801657:	e8 c5 ff ff ff       	call   801621 <strcpy>
	return dst;
}
  80165c:	89 d8                	mov    %ebx,%eax
  80165e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	56                   	push   %esi
  801667:	53                   	push   %ebx
  801668:	8b 75 08             	mov    0x8(%ebp),%esi
  80166b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80166e:	89 f3                	mov    %esi,%ebx
  801670:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801673:	89 f2                	mov    %esi,%edx
  801675:	eb 0f                	jmp    801686 <strncpy+0x23>
		*dst++ = *src;
  801677:	83 c2 01             	add    $0x1,%edx
  80167a:	0f b6 01             	movzbl (%ecx),%eax
  80167d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801680:	80 39 01             	cmpb   $0x1,(%ecx)
  801683:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801686:	39 da                	cmp    %ebx,%edx
  801688:	75 ed                	jne    801677 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80168a:	89 f0                	mov    %esi,%eax
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	56                   	push   %esi
  801694:	53                   	push   %ebx
  801695:	8b 75 08             	mov    0x8(%ebp),%esi
  801698:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80169b:	8b 55 10             	mov    0x10(%ebp),%edx
  80169e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8016a0:	85 d2                	test   %edx,%edx
  8016a2:	74 21                	je     8016c5 <strlcpy+0x35>
  8016a4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8016a8:	89 f2                	mov    %esi,%edx
  8016aa:	eb 09                	jmp    8016b5 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016ac:	83 c2 01             	add    $0x1,%edx
  8016af:	83 c1 01             	add    $0x1,%ecx
  8016b2:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016b5:	39 c2                	cmp    %eax,%edx
  8016b7:	74 09                	je     8016c2 <strlcpy+0x32>
  8016b9:	0f b6 19             	movzbl (%ecx),%ebx
  8016bc:	84 db                	test   %bl,%bl
  8016be:	75 ec                	jne    8016ac <strlcpy+0x1c>
  8016c0:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016c2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016c5:	29 f0                	sub    %esi,%eax
}
  8016c7:	5b                   	pop    %ebx
  8016c8:	5e                   	pop    %esi
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016d4:	eb 06                	jmp    8016dc <strcmp+0x11>
		p++, q++;
  8016d6:	83 c1 01             	add    $0x1,%ecx
  8016d9:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016dc:	0f b6 01             	movzbl (%ecx),%eax
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 04                	je     8016e7 <strcmp+0x1c>
  8016e3:	3a 02                	cmp    (%edx),%al
  8016e5:	74 ef                	je     8016d6 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e7:	0f b6 c0             	movzbl %al,%eax
  8016ea:	0f b6 12             	movzbl (%edx),%edx
  8016ed:	29 d0                	sub    %edx,%eax
}
  8016ef:	5d                   	pop    %ebp
  8016f0:	c3                   	ret    

008016f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	53                   	push   %ebx
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	89 c3                	mov    %eax,%ebx
  8016fd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801700:	eb 06                	jmp    801708 <strncmp+0x17>
		n--, p++, q++;
  801702:	83 c0 01             	add    $0x1,%eax
  801705:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801708:	39 d8                	cmp    %ebx,%eax
  80170a:	74 15                	je     801721 <strncmp+0x30>
  80170c:	0f b6 08             	movzbl (%eax),%ecx
  80170f:	84 c9                	test   %cl,%cl
  801711:	74 04                	je     801717 <strncmp+0x26>
  801713:	3a 0a                	cmp    (%edx),%cl
  801715:	74 eb                	je     801702 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801717:	0f b6 00             	movzbl (%eax),%eax
  80171a:	0f b6 12             	movzbl (%edx),%edx
  80171d:	29 d0                	sub    %edx,%eax
  80171f:	eb 05                	jmp    801726 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801721:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801726:	5b                   	pop    %ebx
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801733:	eb 07                	jmp    80173c <strchr+0x13>
		if (*s == c)
  801735:	38 ca                	cmp    %cl,%dl
  801737:	74 0f                	je     801748 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801739:	83 c0 01             	add    $0x1,%eax
  80173c:	0f b6 10             	movzbl (%eax),%edx
  80173f:	84 d2                	test   %dl,%dl
  801741:	75 f2                	jne    801735 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    

0080174a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801754:	eb 03                	jmp    801759 <strfind+0xf>
  801756:	83 c0 01             	add    $0x1,%eax
  801759:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80175c:	38 ca                	cmp    %cl,%dl
  80175e:	74 04                	je     801764 <strfind+0x1a>
  801760:	84 d2                	test   %dl,%dl
  801762:	75 f2                	jne    801756 <strfind+0xc>
			break;
	return (char *) s;
}
  801764:	5d                   	pop    %ebp
  801765:	c3                   	ret    

00801766 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	57                   	push   %edi
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	8b 55 08             	mov    0x8(%ebp),%edx
  80176f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  801772:	85 c9                	test   %ecx,%ecx
  801774:	74 37                	je     8017ad <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801776:	f6 c2 03             	test   $0x3,%dl
  801779:	75 2a                	jne    8017a5 <memset+0x3f>
  80177b:	f6 c1 03             	test   $0x3,%cl
  80177e:	75 25                	jne    8017a5 <memset+0x3f>
		c &= 0xFF;
  801780:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801784:	89 df                	mov    %ebx,%edi
  801786:	c1 e7 08             	shl    $0x8,%edi
  801789:	89 de                	mov    %ebx,%esi
  80178b:	c1 e6 18             	shl    $0x18,%esi
  80178e:	89 d8                	mov    %ebx,%eax
  801790:	c1 e0 10             	shl    $0x10,%eax
  801793:	09 f0                	or     %esi,%eax
  801795:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801797:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80179a:	89 f8                	mov    %edi,%eax
  80179c:	09 d8                	or     %ebx,%eax
  80179e:	89 d7                	mov    %edx,%edi
  8017a0:	fc                   	cld    
  8017a1:	f3 ab                	rep stos %eax,%es:(%edi)
  8017a3:	eb 08                	jmp    8017ad <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017a5:	89 d7                	mov    %edx,%edi
  8017a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017aa:	fc                   	cld    
  8017ab:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017ad:	89 d0                	mov    %edx,%eax
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    

008017b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	57                   	push   %edi
  8017b8:	56                   	push   %esi
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017c2:	39 c6                	cmp    %eax,%esi
  8017c4:	73 35                	jae    8017fb <memmove+0x47>
  8017c6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017c9:	39 d0                	cmp    %edx,%eax
  8017cb:	73 2e                	jae    8017fb <memmove+0x47>
		s += n;
		d += n;
  8017cd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017d0:	89 d6                	mov    %edx,%esi
  8017d2:	09 fe                	or     %edi,%esi
  8017d4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017da:	75 13                	jne    8017ef <memmove+0x3b>
  8017dc:	f6 c1 03             	test   $0x3,%cl
  8017df:	75 0e                	jne    8017ef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017e1:	83 ef 04             	sub    $0x4,%edi
  8017e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8017e7:	c1 e9 02             	shr    $0x2,%ecx
  8017ea:	fd                   	std    
  8017eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8017ed:	eb 09                	jmp    8017f8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017ef:	83 ef 01             	sub    $0x1,%edi
  8017f2:	8d 72 ff             	lea    -0x1(%edx),%esi
  8017f5:	fd                   	std    
  8017f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017f8:	fc                   	cld    
  8017f9:	eb 1d                	jmp    801818 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017fb:	89 f2                	mov    %esi,%edx
  8017fd:	09 c2                	or     %eax,%edx
  8017ff:	f6 c2 03             	test   $0x3,%dl
  801802:	75 0f                	jne    801813 <memmove+0x5f>
  801804:	f6 c1 03             	test   $0x3,%cl
  801807:	75 0a                	jne    801813 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  801809:	c1 e9 02             	shr    $0x2,%ecx
  80180c:	89 c7                	mov    %eax,%edi
  80180e:	fc                   	cld    
  80180f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801811:	eb 05                	jmp    801818 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801813:	89 c7                	mov    %eax,%edi
  801815:	fc                   	cld    
  801816:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80181f:	ff 75 10             	pushl  0x10(%ebp)
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 87 ff ff ff       	call   8017b4 <memmove>
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	89 c6                	mov    %eax,%esi
  80183c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80183f:	eb 1a                	jmp    80185b <memcmp+0x2c>
		if (*s1 != *s2)
  801841:	0f b6 08             	movzbl (%eax),%ecx
  801844:	0f b6 1a             	movzbl (%edx),%ebx
  801847:	38 d9                	cmp    %bl,%cl
  801849:	74 0a                	je     801855 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  80184b:	0f b6 c1             	movzbl %cl,%eax
  80184e:	0f b6 db             	movzbl %bl,%ebx
  801851:	29 d8                	sub    %ebx,%eax
  801853:	eb 0f                	jmp    801864 <memcmp+0x35>
		s1++, s2++;
  801855:	83 c0 01             	add    $0x1,%eax
  801858:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80185b:	39 f0                	cmp    %esi,%eax
  80185d:	75 e2                	jne    801841 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	53                   	push   %ebx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80186f:	89 c1                	mov    %eax,%ecx
  801871:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  801874:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801878:	eb 0a                	jmp    801884 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  80187a:	0f b6 10             	movzbl (%eax),%edx
  80187d:	39 da                	cmp    %ebx,%edx
  80187f:	74 07                	je     801888 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801881:	83 c0 01             	add    $0x1,%eax
  801884:	39 c8                	cmp    %ecx,%eax
  801886:	72 f2                	jb     80187a <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801888:	5b                   	pop    %ebx
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    

0080188b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	57                   	push   %edi
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801894:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801897:	eb 03                	jmp    80189c <strtol+0x11>
		s++;
  801899:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80189c:	0f b6 01             	movzbl (%ecx),%eax
  80189f:	3c 20                	cmp    $0x20,%al
  8018a1:	74 f6                	je     801899 <strtol+0xe>
  8018a3:	3c 09                	cmp    $0x9,%al
  8018a5:	74 f2                	je     801899 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018a7:	3c 2b                	cmp    $0x2b,%al
  8018a9:	75 0a                	jne    8018b5 <strtol+0x2a>
		s++;
  8018ab:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b3:	eb 11                	jmp    8018c6 <strtol+0x3b>
  8018b5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018ba:	3c 2d                	cmp    $0x2d,%al
  8018bc:	75 08                	jne    8018c6 <strtol+0x3b>
		s++, neg = 1;
  8018be:	83 c1 01             	add    $0x1,%ecx
  8018c1:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018c6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018cc:	75 15                	jne    8018e3 <strtol+0x58>
  8018ce:	80 39 30             	cmpb   $0x30,(%ecx)
  8018d1:	75 10                	jne    8018e3 <strtol+0x58>
  8018d3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018d7:	75 7c                	jne    801955 <strtol+0xca>
		s += 2, base = 16;
  8018d9:	83 c1 02             	add    $0x2,%ecx
  8018dc:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018e1:	eb 16                	jmp    8018f9 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8018e3:	85 db                	test   %ebx,%ebx
  8018e5:	75 12                	jne    8018f9 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8018e7:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8018ec:	80 39 30             	cmpb   $0x30,(%ecx)
  8018ef:	75 08                	jne    8018f9 <strtol+0x6e>
		s++, base = 8;
  8018f1:	83 c1 01             	add    $0x1,%ecx
  8018f4:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8018f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fe:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801901:	0f b6 11             	movzbl (%ecx),%edx
  801904:	8d 72 d0             	lea    -0x30(%edx),%esi
  801907:	89 f3                	mov    %esi,%ebx
  801909:	80 fb 09             	cmp    $0x9,%bl
  80190c:	77 08                	ja     801916 <strtol+0x8b>
			dig = *s - '0';
  80190e:	0f be d2             	movsbl %dl,%edx
  801911:	83 ea 30             	sub    $0x30,%edx
  801914:	eb 22                	jmp    801938 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  801916:	8d 72 9f             	lea    -0x61(%edx),%esi
  801919:	89 f3                	mov    %esi,%ebx
  80191b:	80 fb 19             	cmp    $0x19,%bl
  80191e:	77 08                	ja     801928 <strtol+0x9d>
			dig = *s - 'a' + 10;
  801920:	0f be d2             	movsbl %dl,%edx
  801923:	83 ea 57             	sub    $0x57,%edx
  801926:	eb 10                	jmp    801938 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  801928:	8d 72 bf             	lea    -0x41(%edx),%esi
  80192b:	89 f3                	mov    %esi,%ebx
  80192d:	80 fb 19             	cmp    $0x19,%bl
  801930:	77 16                	ja     801948 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801932:	0f be d2             	movsbl %dl,%edx
  801935:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  801938:	3b 55 10             	cmp    0x10(%ebp),%edx
  80193b:	7d 0b                	jge    801948 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  80193d:	83 c1 01             	add    $0x1,%ecx
  801940:	0f af 45 10          	imul   0x10(%ebp),%eax
  801944:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  801946:	eb b9                	jmp    801901 <strtol+0x76>

	if (endptr)
  801948:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80194c:	74 0d                	je     80195b <strtol+0xd0>
		*endptr = (char *) s;
  80194e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801951:	89 0e                	mov    %ecx,(%esi)
  801953:	eb 06                	jmp    80195b <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801955:	85 db                	test   %ebx,%ebx
  801957:	74 98                	je     8018f1 <strtol+0x66>
  801959:	eb 9e                	jmp    8018f9 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  80195b:	89 c2                	mov    %eax,%edx
  80195d:	f7 da                	neg    %edx
  80195f:	85 ff                	test   %edi,%edi
  801961:	0f 45 c2             	cmovne %edx,%eax
}
  801964:	5b                   	pop    %ebx
  801965:	5e                   	pop    %esi
  801966:	5f                   	pop    %edi
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    

00801969 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	56                   	push   %esi
  80196d:	53                   	push   %ebx
  80196e:	8b 75 08             	mov    0x8(%ebp),%esi
  801971:	8b 45 0c             	mov    0xc(%ebp),%eax
  801974:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801977:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801979:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80197e:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801981:	83 ec 0c             	sub    $0xc,%esp
  801984:	50                   	push   %eax
  801985:	e8 1d e9 ff ff       	call   8002a7 <sys_ipc_recv>
	if (from_env_store)
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 f6                	test   %esi,%esi
  80198f:	74 0b                	je     80199c <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801991:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801997:	8b 52 74             	mov    0x74(%edx),%edx
  80199a:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80199c:	85 db                	test   %ebx,%ebx
  80199e:	74 0b                	je     8019ab <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  8019a0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019a6:	8b 52 78             	mov    0x78(%edx),%edx
  8019a9:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	79 16                	jns    8019c5 <ipc_recv+0x5c>
		if (from_env_store)
  8019af:	85 f6                	test   %esi,%esi
  8019b1:	74 06                	je     8019b9 <ipc_recv+0x50>
			*from_env_store = 0;
  8019b3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019b9:	85 db                	test   %ebx,%ebx
  8019bb:	74 10                	je     8019cd <ipc_recv+0x64>
			*perm_store = 0;
  8019bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019c3:	eb 08                	jmp    8019cd <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8019ca:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	57                   	push   %edi
  8019d8:	56                   	push   %esi
  8019d9:	53                   	push   %ebx
  8019da:	83 ec 0c             	sub    $0xc,%esp
  8019dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019e6:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019e8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019ed:	0f 44 d8             	cmove  %eax,%ebx
  8019f0:	eb 1c                	jmp    801a0e <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019f2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019f5:	74 12                	je     801a09 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019f7:	50                   	push   %eax
  8019f8:	68 80 21 80 00       	push   $0x802180
  8019fd:	6a 42                	push   $0x42
  8019ff:	68 96 21 80 00       	push   $0x802196
  801a04:	e8 cd f5 ff ff       	call   800fd6 <_panic>
		sys_yield();
  801a09:	e8 77 e7 ff ff       	call   800185 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a0e:	ff 75 14             	pushl  0x14(%ebp)
  801a11:	53                   	push   %ebx
  801a12:	56                   	push   %esi
  801a13:	57                   	push   %edi
  801a14:	e8 69 e8 ff ff       	call   800282 <sys_ipc_try_send>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	75 d2                	jne    8019f2 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    

00801a28 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a33:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a36:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a3c:	8b 52 50             	mov    0x50(%edx),%edx
  801a3f:	39 ca                	cmp    %ecx,%edx
  801a41:	75 0d                	jne    801a50 <ipc_find_env+0x28>
			return envs[i].env_id;
  801a43:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a46:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a4b:	8b 40 48             	mov    0x48(%eax),%eax
  801a4e:	eb 0f                	jmp    801a5f <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a50:	83 c0 01             	add    $0x1,%eax
  801a53:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a58:	75 d9                	jne    801a33 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    

00801a61 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a67:	89 d0                	mov    %edx,%eax
  801a69:	c1 e8 16             	shr    $0x16,%eax
  801a6c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a78:	f6 c1 01             	test   $0x1,%cl
  801a7b:	74 1d                	je     801a9a <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a7d:	c1 ea 0c             	shr    $0xc,%edx
  801a80:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a87:	f6 c2 01             	test   $0x1,%dl
  801a8a:	74 0e                	je     801a9a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a8c:	c1 ea 0c             	shr    $0xc,%edx
  801a8f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a96:	ef 
  801a97:	0f b7 c0             	movzwl %ax,%eax
}
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    
  801a9c:	66 90                	xchg   %ax,%ax
  801a9e:	66 90                	xchg   %ax,%ax

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
