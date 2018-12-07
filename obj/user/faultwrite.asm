
obj/user/faultwrite.debug:     formato del fichero elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0 = 0;
  800036:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80004d:	e8 0a 01 00 00       	call   80015c <sys_getenvid>
	if (id >= 0)
  800052:	85 c0                	test   %eax,%eax
  800054:	78 12                	js     800068 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800056:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800063:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800068:	85 db                	test   %ebx,%ebx
  80006a:	7e 07                	jle    800073 <libmain+0x31>
		binaryname = argv[0];
  80006c:	8b 06                	mov    (%esi),%eax
  80006e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800073:	83 ec 08             	sub    $0x8,%esp
  800076:	56                   	push   %esi
  800077:	53                   	push   %ebx
  800078:	e8 b6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007d:	e8 0a 00 00 00       	call   80008c <exit>
}
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800088:	5b                   	pop    %ebx
  800089:	5e                   	pop    %esi
  80008a:	5d                   	pop    %ebp
  80008b:	c3                   	ret    

0080008c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800092:	e8 f8 03 00 00       	call   80048f <close_all>
	sys_env_destroy(0);
  800097:	83 ec 0c             	sub    $0xc,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	e8 99 00 00 00       	call   80013a <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
  8000ac:	83 ec 1c             	sub    $0x1c,%esp
  8000af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000b5:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000bd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000c0:	8b 75 14             	mov    0x14(%ebp),%esi
  8000c3:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c9:	74 1d                	je     8000e8 <syscall+0x42>
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	7e 19                	jle    8000e8 <syscall+0x42>
  8000cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	50                   	push   %eax
  8000d6:	52                   	push   %edx
  8000d7:	68 4a 1d 80 00       	push   $0x801d4a
  8000dc:	6a 23                	push   $0x23
  8000de:	68 67 1d 80 00       	push   $0x801d67
  8000e3:	e8 e9 0e 00 00       	call   800fd1 <_panic>

	return ret;
}
  8000e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000eb:	5b                   	pop    %ebx
  8000ec:	5e                   	pop    %esi
  8000ed:	5f                   	pop    %edi
  8000ee:	5d                   	pop    %ebp
  8000ef:	c3                   	ret    

008000f0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8000f6:	6a 00                	push   $0x0
  8000f8:	6a 00                	push   $0x0
  8000fa:	6a 00                	push   $0x0
  8000fc:	ff 75 0c             	pushl  0xc(%ebp)
  8000ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800102:	ba 00 00 00 00       	mov    $0x0,%edx
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	e8 95 ff ff ff       	call   8000a6 <syscall>
}
  800111:	83 c4 10             	add    $0x10,%esp
  800114:	c9                   	leave  
  800115:	c3                   	ret    

00800116 <sys_cgetc>:

int
sys_cgetc(void)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80011c:	6a 00                	push   $0x0
  80011e:	6a 00                	push   $0x0
  800120:	6a 00                	push   $0x0
  800122:	6a 00                	push   $0x0
  800124:	b9 00 00 00 00       	mov    $0x0,%ecx
  800129:	ba 00 00 00 00       	mov    $0x0,%edx
  80012e:	b8 01 00 00 00       	mov    $0x1,%eax
  800133:	e8 6e ff ff ff       	call   8000a6 <syscall>
}
  800138:	c9                   	leave  
  800139:	c3                   	ret    

0080013a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800140:	6a 00                	push   $0x0
  800142:	6a 00                	push   $0x0
  800144:	6a 00                	push   $0x0
  800146:	6a 00                	push   $0x0
  800148:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80014b:	ba 01 00 00 00       	mov    $0x1,%edx
  800150:	b8 03 00 00 00       	mov    $0x3,%eax
  800155:	e8 4c ff ff ff       	call   8000a6 <syscall>
}
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800162:	6a 00                	push   $0x0
  800164:	6a 00                	push   $0x0
  800166:	6a 00                	push   $0x0
  800168:	6a 00                	push   $0x0
  80016a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80016f:	ba 00 00 00 00       	mov    $0x0,%edx
  800174:	b8 02 00 00 00       	mov    $0x2,%eax
  800179:	e8 28 ff ff ff       	call   8000a6 <syscall>
}
  80017e:	c9                   	leave  
  80017f:	c3                   	ret    

00800180 <sys_yield>:

void
sys_yield(void)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800186:	6a 00                	push   $0x0
  800188:	6a 00                	push   $0x0
  80018a:	6a 00                	push   $0x0
  80018c:	6a 00                	push   $0x0
  80018e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800193:	ba 00 00 00 00       	mov    $0x0,%edx
  800198:	b8 0b 00 00 00       	mov    $0xb,%eax
  80019d:	e8 04 ff ff ff       	call   8000a6 <syscall>
}
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001ad:	6a 00                	push   $0x0
  8001af:	6a 00                	push   $0x0
  8001b1:	ff 75 10             	pushl  0x10(%ebp)
  8001b4:	ff 75 0c             	pushl  0xc(%ebp)
  8001b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8001bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8001c4:	e8 dd fe ff ff       	call   8000a6 <syscall>
}
  8001c9:	c9                   	leave  
  8001ca:	c3                   	ret    

008001cb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001d1:	ff 75 18             	pushl  0x18(%ebp)
  8001d4:	ff 75 14             	pushl  0x14(%ebp)
  8001d7:	ff 75 10             	pushl  0x10(%ebp)
  8001da:	ff 75 0c             	pushl  0xc(%ebp)
  8001dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e0:	ba 01 00 00 00       	mov    $0x1,%edx
  8001e5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ea:	e8 b7 fe ff ff       	call   8000a6 <syscall>
}
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8001f7:	6a 00                	push   $0x0
  8001f9:	6a 00                	push   $0x0
  8001fb:	6a 00                	push   $0x0
  8001fd:	ff 75 0c             	pushl  0xc(%ebp)
  800200:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800203:	ba 01 00 00 00       	mov    $0x1,%edx
  800208:	b8 06 00 00 00       	mov    $0x6,%eax
  80020d:	e8 94 fe ff ff       	call   8000a6 <syscall>
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80021a:	6a 00                	push   $0x0
  80021c:	6a 00                	push   $0x0
  80021e:	6a 00                	push   $0x0
  800220:	ff 75 0c             	pushl  0xc(%ebp)
  800223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800226:	ba 01 00 00 00       	mov    $0x1,%edx
  80022b:	b8 08 00 00 00       	mov    $0x8,%eax
  800230:	e8 71 fe ff ff       	call   8000a6 <syscall>
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80023d:	6a 00                	push   $0x0
  80023f:	6a 00                	push   $0x0
  800241:	6a 00                	push   $0x0
  800243:	ff 75 0c             	pushl  0xc(%ebp)
  800246:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800249:	ba 01 00 00 00       	mov    $0x1,%edx
  80024e:	b8 09 00 00 00       	mov    $0x9,%eax
  800253:	e8 4e fe ff ff       	call   8000a6 <syscall>
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800260:	6a 00                	push   $0x0
  800262:	6a 00                	push   $0x0
  800264:	6a 00                	push   $0x0
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80026c:	ba 01 00 00 00       	mov    $0x1,%edx
  800271:	b8 0a 00 00 00       	mov    $0xa,%eax
  800276:	e8 2b fe ff ff       	call   8000a6 <syscall>
}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800283:	6a 00                	push   $0x0
  800285:	ff 75 14             	pushl  0x14(%ebp)
  800288:	ff 75 10             	pushl  0x10(%ebp)
  80028b:	ff 75 0c             	pushl  0xc(%ebp)
  80028e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800291:	ba 00 00 00 00       	mov    $0x0,%edx
  800296:	b8 0c 00 00 00       	mov    $0xc,%eax
  80029b:	e8 06 fe ff ff       	call   8000a6 <syscall>
}
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002a8:	6a 00                	push   $0x0
  8002aa:	6a 00                	push   $0x0
  8002ac:	6a 00                	push   $0x0
  8002ae:	6a 00                	push   $0x0
  8002b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b3:	ba 01 00 00 00       	mov    $0x1,%edx
  8002b8:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002bd:	e8 e4 fd ff ff       	call   8000a6 <syscall>
}
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	05 00 00 00 30       	add    $0x30000000,%eax
  8002cf:	c1 e8 0c             	shr    $0xc,%eax
}
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    

008002d4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	e8 e5 ff ff ff       	call   8002c4 <fd2num>
  8002df:	83 c4 04             	add    $0x4,%esp
  8002e2:	c1 e0 0c             	shl    $0xc,%eax
  8002e5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8002f7:	89 c2                	mov    %eax,%edx
  8002f9:	c1 ea 16             	shr    $0x16,%edx
  8002fc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800303:	f6 c2 01             	test   $0x1,%dl
  800306:	74 11                	je     800319 <fd_alloc+0x2d>
  800308:	89 c2                	mov    %eax,%edx
  80030a:	c1 ea 0c             	shr    $0xc,%edx
  80030d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800314:	f6 c2 01             	test   $0x1,%dl
  800317:	75 09                	jne    800322 <fd_alloc+0x36>
			*fd_store = fd;
  800319:	89 01                	mov    %eax,(%ecx)
			return 0;
  80031b:	b8 00 00 00 00       	mov    $0x0,%eax
  800320:	eb 17                	jmp    800339 <fd_alloc+0x4d>
  800322:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800327:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80032c:	75 c9                	jne    8002f7 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80032e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800334:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800339:	5d                   	pop    %ebp
  80033a:	c3                   	ret    

0080033b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800341:	83 f8 1f             	cmp    $0x1f,%eax
  800344:	77 36                	ja     80037c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800346:	c1 e0 0c             	shl    $0xc,%eax
  800349:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80034e:	89 c2                	mov    %eax,%edx
  800350:	c1 ea 16             	shr    $0x16,%edx
  800353:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80035a:	f6 c2 01             	test   $0x1,%dl
  80035d:	74 24                	je     800383 <fd_lookup+0x48>
  80035f:	89 c2                	mov    %eax,%edx
  800361:	c1 ea 0c             	shr    $0xc,%edx
  800364:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80036b:	f6 c2 01             	test   $0x1,%dl
  80036e:	74 1a                	je     80038a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800370:	8b 55 0c             	mov    0xc(%ebp),%edx
  800373:	89 02                	mov    %eax,(%edx)
	return 0;
  800375:	b8 00 00 00 00       	mov    $0x0,%eax
  80037a:	eb 13                	jmp    80038f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80037c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800381:	eb 0c                	jmp    80038f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800388:	eb 05                	jmp    80038f <fd_lookup+0x54>
  80038a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039a:	ba f4 1d 80 00       	mov    $0x801df4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80039f:	eb 13                	jmp    8003b4 <dev_lookup+0x23>
  8003a1:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8003a4:	39 08                	cmp    %ecx,(%eax)
  8003a6:	75 0c                	jne    8003b4 <dev_lookup+0x23>
			*dev = devtab[i];
  8003a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ab:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b2:	eb 2e                	jmp    8003e2 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003b4:	8b 02                	mov    (%edx),%eax
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	75 e7                	jne    8003a1 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8003bf:	8b 40 48             	mov    0x48(%eax),%eax
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	51                   	push   %ecx
  8003c6:	50                   	push   %eax
  8003c7:	68 78 1d 80 00       	push   $0x801d78
  8003cc:	e8 d9 0c 00 00       	call   8010aa <cprintf>
	*dev = 0;
  8003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	56                   	push   %esi
  8003e8:	53                   	push   %ebx
  8003e9:	83 ec 10             	sub    $0x10,%esp
  8003ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8003f2:	56                   	push   %esi
  8003f3:	e8 cc fe ff ff       	call   8002c4 <fd2num>
  8003f8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8003fb:	89 14 24             	mov    %edx,(%esp)
  8003fe:	50                   	push   %eax
  8003ff:	e8 37 ff ff ff       	call   80033b <fd_lookup>
  800404:	83 c4 08             	add    $0x8,%esp
  800407:	85 c0                	test   %eax,%eax
  800409:	78 05                	js     800410 <fd_close+0x2c>
	    || fd != fd2)
  80040b:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80040e:	74 0c                	je     80041c <fd_close+0x38>
		return (must_exist ? r : 0);
  800410:	84 db                	test   %bl,%bl
  800412:	ba 00 00 00 00       	mov    $0x0,%edx
  800417:	0f 44 c2             	cmove  %edx,%eax
  80041a:	eb 41                	jmp    80045d <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800422:	50                   	push   %eax
  800423:	ff 36                	pushl  (%esi)
  800425:	e8 67 ff ff ff       	call   800391 <dev_lookup>
  80042a:	89 c3                	mov    %eax,%ebx
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	85 c0                	test   %eax,%eax
  800431:	78 1a                	js     80044d <fd_close+0x69>
		if (dev->dev_close)
  800433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800436:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800439:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80043e:	85 c0                	test   %eax,%eax
  800440:	74 0b                	je     80044d <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800442:	83 ec 0c             	sub    $0xc,%esp
  800445:	56                   	push   %esi
  800446:	ff d0                	call   *%eax
  800448:	89 c3                	mov    %eax,%ebx
  80044a:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	56                   	push   %esi
  800451:	6a 00                	push   $0x0
  800453:	e8 99 fd ff ff       	call   8001f1 <sys_page_unmap>
	return r;
  800458:	83 c4 10             	add    $0x10,%esp
  80045b:	89 d8                	mov    %ebx,%eax
}
  80045d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800460:	5b                   	pop    %ebx
  800461:	5e                   	pop    %esi
  800462:	5d                   	pop    %ebp
  800463:	c3                   	ret    

00800464 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80046a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80046d:	50                   	push   %eax
  80046e:	ff 75 08             	pushl  0x8(%ebp)
  800471:	e8 c5 fe ff ff       	call   80033b <fd_lookup>
  800476:	83 c4 08             	add    $0x8,%esp
  800479:	85 c0                	test   %eax,%eax
  80047b:	78 10                	js     80048d <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	6a 01                	push   $0x1
  800482:	ff 75 f4             	pushl  -0xc(%ebp)
  800485:	e8 5a ff ff ff       	call   8003e4 <fd_close>
  80048a:	83 c4 10             	add    $0x10,%esp
}
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <close_all>:

void
close_all(void)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	53                   	push   %ebx
  800493:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800496:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	53                   	push   %ebx
  80049f:	e8 c0 ff ff ff       	call   800464 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8004a4:	83 c3 01             	add    $0x1,%ebx
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	83 fb 20             	cmp    $0x20,%ebx
  8004ad:	75 ec                	jne    80049b <close_all+0xc>
		close(i);
}
  8004af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	57                   	push   %edi
  8004b8:	56                   	push   %esi
  8004b9:	53                   	push   %ebx
  8004ba:	83 ec 2c             	sub    $0x2c,%esp
  8004bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004c3:	50                   	push   %eax
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	e8 6f fe ff ff       	call   80033b <fd_lookup>
  8004cc:	83 c4 08             	add    $0x8,%esp
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	0f 88 c1 00 00 00    	js     800598 <dup+0xe4>
		return r;
	close(newfdnum);
  8004d7:	83 ec 0c             	sub    $0xc,%esp
  8004da:	56                   	push   %esi
  8004db:	e8 84 ff ff ff       	call   800464 <close>

	newfd = INDEX2FD(newfdnum);
  8004e0:	89 f3                	mov    %esi,%ebx
  8004e2:	c1 e3 0c             	shl    $0xc,%ebx
  8004e5:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8004eb:	83 c4 04             	add    $0x4,%esp
  8004ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004f1:	e8 de fd ff ff       	call   8002d4 <fd2data>
  8004f6:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8004f8:	89 1c 24             	mov    %ebx,(%esp)
  8004fb:	e8 d4 fd ff ff       	call   8002d4 <fd2data>
  800500:	83 c4 10             	add    $0x10,%esp
  800503:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800506:	89 f8                	mov    %edi,%eax
  800508:	c1 e8 16             	shr    $0x16,%eax
  80050b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800512:	a8 01                	test   $0x1,%al
  800514:	74 37                	je     80054d <dup+0x99>
  800516:	89 f8                	mov    %edi,%eax
  800518:	c1 e8 0c             	shr    $0xc,%eax
  80051b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800522:	f6 c2 01             	test   $0x1,%dl
  800525:	74 26                	je     80054d <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800527:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	25 07 0e 00 00       	and    $0xe07,%eax
  800536:	50                   	push   %eax
  800537:	ff 75 d4             	pushl  -0x2c(%ebp)
  80053a:	6a 00                	push   $0x0
  80053c:	57                   	push   %edi
  80053d:	6a 00                	push   $0x0
  80053f:	e8 87 fc ff ff       	call   8001cb <sys_page_map>
  800544:	89 c7                	mov    %eax,%edi
  800546:	83 c4 20             	add    $0x20,%esp
  800549:	85 c0                	test   %eax,%eax
  80054b:	78 2e                	js     80057b <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80054d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800550:	89 d0                	mov    %edx,%eax
  800552:	c1 e8 0c             	shr    $0xc,%eax
  800555:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80055c:	83 ec 0c             	sub    $0xc,%esp
  80055f:	25 07 0e 00 00       	and    $0xe07,%eax
  800564:	50                   	push   %eax
  800565:	53                   	push   %ebx
  800566:	6a 00                	push   $0x0
  800568:	52                   	push   %edx
  800569:	6a 00                	push   $0x0
  80056b:	e8 5b fc ff ff       	call   8001cb <sys_page_map>
  800570:	89 c7                	mov    %eax,%edi
  800572:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800575:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800577:	85 ff                	test   %edi,%edi
  800579:	79 1d                	jns    800598 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	53                   	push   %ebx
  80057f:	6a 00                	push   $0x0
  800581:	e8 6b fc ff ff       	call   8001f1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800586:	83 c4 08             	add    $0x8,%esp
  800589:	ff 75 d4             	pushl  -0x2c(%ebp)
  80058c:	6a 00                	push   $0x0
  80058e:	e8 5e fc ff ff       	call   8001f1 <sys_page_unmap>
	return r;
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 f8                	mov    %edi,%eax
}
  800598:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80059b:	5b                   	pop    %ebx
  80059c:	5e                   	pop    %esi
  80059d:	5f                   	pop    %edi
  80059e:	5d                   	pop    %ebp
  80059f:	c3                   	ret    

008005a0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	53                   	push   %ebx
  8005a4:	83 ec 14             	sub    $0x14,%esp
  8005a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005ad:	50                   	push   %eax
  8005ae:	53                   	push   %ebx
  8005af:	e8 87 fd ff ff       	call   80033b <fd_lookup>
  8005b4:	83 c4 08             	add    $0x8,%esp
  8005b7:	89 c2                	mov    %eax,%edx
  8005b9:	85 c0                	test   %eax,%eax
  8005bb:	78 6d                	js     80062a <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005c3:	50                   	push   %eax
  8005c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c7:	ff 30                	pushl  (%eax)
  8005c9:	e8 c3 fd ff ff       	call   800391 <dev_lookup>
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	78 4c                	js     800621 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8005d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8005d8:	8b 42 08             	mov    0x8(%edx),%eax
  8005db:	83 e0 03             	and    $0x3,%eax
  8005de:	83 f8 01             	cmp    $0x1,%eax
  8005e1:	75 21                	jne    800604 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8005e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8005e8:	8b 40 48             	mov    0x48(%eax),%eax
  8005eb:	83 ec 04             	sub    $0x4,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	50                   	push   %eax
  8005f0:	68 b9 1d 80 00       	push   $0x801db9
  8005f5:	e8 b0 0a 00 00       	call   8010aa <cprintf>
		return -E_INVAL;
  8005fa:	83 c4 10             	add    $0x10,%esp
  8005fd:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800602:	eb 26                	jmp    80062a <read+0x8a>
	}
	if (!dev->dev_read)
  800604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800607:	8b 40 08             	mov    0x8(%eax),%eax
  80060a:	85 c0                	test   %eax,%eax
  80060c:	74 17                	je     800625 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	ff 75 10             	pushl  0x10(%ebp)
  800614:	ff 75 0c             	pushl  0xc(%ebp)
  800617:	52                   	push   %edx
  800618:	ff d0                	call   *%eax
  80061a:	89 c2                	mov    %eax,%edx
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	eb 09                	jmp    80062a <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800621:	89 c2                	mov    %eax,%edx
  800623:	eb 05                	jmp    80062a <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800625:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80062a:	89 d0                	mov    %edx,%eax
  80062c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062f:	c9                   	leave  
  800630:	c3                   	ret    

00800631 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	57                   	push   %edi
  800635:	56                   	push   %esi
  800636:	53                   	push   %ebx
  800637:	83 ec 0c             	sub    $0xc,%esp
  80063a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80063d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800640:	bb 00 00 00 00       	mov    $0x0,%ebx
  800645:	eb 21                	jmp    800668 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800647:	83 ec 04             	sub    $0x4,%esp
  80064a:	89 f0                	mov    %esi,%eax
  80064c:	29 d8                	sub    %ebx,%eax
  80064e:	50                   	push   %eax
  80064f:	89 d8                	mov    %ebx,%eax
  800651:	03 45 0c             	add    0xc(%ebp),%eax
  800654:	50                   	push   %eax
  800655:	57                   	push   %edi
  800656:	e8 45 ff ff ff       	call   8005a0 <read>
		if (m < 0)
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	85 c0                	test   %eax,%eax
  800660:	78 10                	js     800672 <readn+0x41>
			return m;
		if (m == 0)
  800662:	85 c0                	test   %eax,%eax
  800664:	74 0a                	je     800670 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800666:	01 c3                	add    %eax,%ebx
  800668:	39 f3                	cmp    %esi,%ebx
  80066a:	72 db                	jb     800647 <readn+0x16>
  80066c:	89 d8                	mov    %ebx,%eax
  80066e:	eb 02                	jmp    800672 <readn+0x41>
  800670:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800672:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800675:	5b                   	pop    %ebx
  800676:	5e                   	pop    %esi
  800677:	5f                   	pop    %edi
  800678:	5d                   	pop    %ebp
  800679:	c3                   	ret    

0080067a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	53                   	push   %ebx
  80067e:	83 ec 14             	sub    $0x14,%esp
  800681:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800684:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800687:	50                   	push   %eax
  800688:	53                   	push   %ebx
  800689:	e8 ad fc ff ff       	call   80033b <fd_lookup>
  80068e:	83 c4 08             	add    $0x8,%esp
  800691:	89 c2                	mov    %eax,%edx
  800693:	85 c0                	test   %eax,%eax
  800695:	78 68                	js     8006ff <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80069d:	50                   	push   %eax
  80069e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a1:	ff 30                	pushl  (%eax)
  8006a3:	e8 e9 fc ff ff       	call   800391 <dev_lookup>
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	85 c0                	test   %eax,%eax
  8006ad:	78 47                	js     8006f6 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006b6:	75 21                	jne    8006d9 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b8:	a1 04 40 80 00       	mov    0x804004,%eax
  8006bd:	8b 40 48             	mov    0x48(%eax),%eax
  8006c0:	83 ec 04             	sub    $0x4,%esp
  8006c3:	53                   	push   %ebx
  8006c4:	50                   	push   %eax
  8006c5:	68 d5 1d 80 00       	push   $0x801dd5
  8006ca:	e8 db 09 00 00       	call   8010aa <cprintf>
		return -E_INVAL;
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8006d7:	eb 26                	jmp    8006ff <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8006d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8006df:	85 d2                	test   %edx,%edx
  8006e1:	74 17                	je     8006fa <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8006e3:	83 ec 04             	sub    $0x4,%esp
  8006e6:	ff 75 10             	pushl  0x10(%ebp)
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	ff d2                	call   *%edx
  8006ef:	89 c2                	mov    %eax,%edx
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb 09                	jmp    8006ff <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006f6:	89 c2                	mov    %eax,%edx
  8006f8:	eb 05                	jmp    8006ff <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8006fa:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  8006ff:	89 d0                	mov    %edx,%eax
  800701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <seek>:

int
seek(int fdnum, off_t offset)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80070c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	e8 23 fc ff ff       	call   80033b <fd_lookup>
  800718:	83 c4 08             	add    $0x8,%esp
  80071b:	85 c0                	test   %eax,%eax
  80071d:	78 0e                	js     80072d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80071f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800722:	8b 55 0c             	mov    0xc(%ebp),%edx
  800725:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	53                   	push   %ebx
  800733:	83 ec 14             	sub    $0x14,%esp
  800736:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800739:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	53                   	push   %ebx
  80073e:	e8 f8 fb ff ff       	call   80033b <fd_lookup>
  800743:	83 c4 08             	add    $0x8,%esp
  800746:	89 c2                	mov    %eax,%edx
  800748:	85 c0                	test   %eax,%eax
  80074a:	78 65                	js     8007b1 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800752:	50                   	push   %eax
  800753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800756:	ff 30                	pushl  (%eax)
  800758:	e8 34 fc ff ff       	call   800391 <dev_lookup>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	85 c0                	test   %eax,%eax
  800762:	78 44                	js     8007a8 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800767:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80076b:	75 21                	jne    80078e <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80076d:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800772:	8b 40 48             	mov    0x48(%eax),%eax
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	53                   	push   %ebx
  800779:	50                   	push   %eax
  80077a:	68 98 1d 80 00       	push   $0x801d98
  80077f:	e8 26 09 00 00       	call   8010aa <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80078c:	eb 23                	jmp    8007b1 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	8b 52 18             	mov    0x18(%edx),%edx
  800794:	85 d2                	test   %edx,%edx
  800796:	74 14                	je     8007ac <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	50                   	push   %eax
  80079f:	ff d2                	call   *%edx
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	eb 09                	jmp    8007b1 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007a8:	89 c2                	mov    %eax,%edx
  8007aa:	eb 05                	jmp    8007b1 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007ac:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007b1:	89 d0                	mov    %edx,%eax
  8007b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007c5:	50                   	push   %eax
  8007c6:	ff 75 08             	pushl  0x8(%ebp)
  8007c9:	e8 6d fb ff ff       	call   80033b <fd_lookup>
  8007ce:	83 c4 08             	add    $0x8,%esp
  8007d1:	89 c2                	mov    %eax,%edx
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	78 58                	js     80082f <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007dd:	50                   	push   %eax
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	ff 30                	pushl  (%eax)
  8007e3:	e8 a9 fb ff ff       	call   800391 <dev_lookup>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	85 c0                	test   %eax,%eax
  8007ed:	78 37                	js     800826 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  8007ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8007f6:	74 32                	je     80082a <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8007f8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8007fb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800802:	00 00 00 
	stat->st_isdir = 0;
  800805:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80080c:	00 00 00 
	stat->st_dev = dev;
  80080f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	ff 75 f0             	pushl  -0x10(%ebp)
  80081c:	ff 50 14             	call   *0x14(%eax)
  80081f:	89 c2                	mov    %eax,%edx
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	eb 09                	jmp    80082f <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800826:	89 c2                	mov    %eax,%edx
  800828:	eb 05                	jmp    80082f <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80082a:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80082f:	89 d0                	mov    %edx,%eax
  800831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	56                   	push   %esi
  80083a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	6a 00                	push   $0x0
  800840:	ff 75 08             	pushl  0x8(%ebp)
  800843:	e8 06 02 00 00       	call   800a4e <open>
  800848:	89 c3                	mov    %eax,%ebx
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	85 c0                	test   %eax,%eax
  80084f:	78 1b                	js     80086c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	50                   	push   %eax
  800858:	e8 5b ff ff ff       	call   8007b8 <fstat>
  80085d:	89 c6                	mov    %eax,%esi
	close(fd);
  80085f:	89 1c 24             	mov    %ebx,(%esp)
  800862:	e8 fd fb ff ff       	call   800464 <close>
	return r;
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	89 f0                	mov    %esi,%eax
}
  80086c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	56                   	push   %esi
  800877:	53                   	push   %ebx
  800878:	89 c6                	mov    %eax,%esi
  80087a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80087c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800883:	75 12                	jne    800897 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800885:	83 ec 0c             	sub    $0xc,%esp
  800888:	6a 01                	push   $0x1
  80088a:	e8 94 11 00 00       	call   801a23 <ipc_find_env>
  80088f:	a3 00 40 80 00       	mov    %eax,0x804000
  800894:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800897:	6a 07                	push   $0x7
  800899:	68 00 50 80 00       	push   $0x805000
  80089e:	56                   	push   %esi
  80089f:	ff 35 00 40 80 00    	pushl  0x804000
  8008a5:	e8 25 11 00 00       	call   8019cf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008aa:	83 c4 0c             	add    $0xc,%esp
  8008ad:	6a 00                	push   $0x0
  8008af:	53                   	push   %ebx
  8008b0:	6a 00                	push   $0x0
  8008b2:	e8 ad 10 00 00       	call   801964 <ipc_recv>
}
  8008b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ba:	5b                   	pop    %ebx
  8008bb:	5e                   	pop    %esi
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8008ca:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8008cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	b8 02 00 00 00       	mov    $0x2,%eax
  8008e1:	e8 8d ff ff ff       	call   800873 <fsipc>
}
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8008f4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8008f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fe:	b8 06 00 00 00       	mov    $0x6,%eax
  800903:	e8 6b ff ff ff       	call   800873 <fsipc>
}
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	53                   	push   %ebx
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 40 0c             	mov    0xc(%eax),%eax
  80091a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	b8 05 00 00 00       	mov    $0x5,%eax
  800929:	e8 45 ff ff ff       	call   800873 <fsipc>
  80092e:	85 c0                	test   %eax,%eax
  800930:	78 2c                	js     80095e <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	68 00 50 80 00       	push   $0x805000
  80093a:	53                   	push   %ebx
  80093b:	e8 dc 0c 00 00       	call   80161c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800940:	a1 80 50 80 00       	mov    0x805080,%eax
  800945:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80094b:	a1 84 50 80 00       	mov    0x805084,%eax
  800950:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800956:	83 c4 10             	add    $0x10,%esp
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80096f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800972:	8b 49 0c             	mov    0xc(%ecx),%ecx
  800975:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  80097b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800980:	76 22                	jbe    8009a4 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  800982:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  800989:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  80098c:	83 ec 04             	sub    $0x4,%esp
  80098f:	68 f8 0f 00 00       	push   $0xff8
  800994:	52                   	push   %edx
  800995:	68 08 50 80 00       	push   $0x805008
  80099a:	e8 10 0e 00 00       	call   8017af <memmove>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	eb 17                	jmp    8009bb <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8009a4:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009a9:	83 ec 04             	sub    $0x4,%esp
  8009ac:	50                   	push   %eax
  8009ad:	52                   	push   %edx
  8009ae:	68 08 50 80 00       	push   $0x805008
  8009b3:	e8 f7 0d 00 00       	call   8017af <memmove>
  8009b8:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c0:	b8 04 00 00 00       	mov    $0x4,%eax
  8009c5:	e8 a9 fe ff ff       	call   800873 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	56                   	push   %esi
  8009d0:	53                   	push   %ebx
  8009d1:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8009da:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8009df:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8009e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ea:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ef:	e8 7f fe ff ff       	call   800873 <fsipc>
  8009f4:	89 c3                	mov    %eax,%ebx
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	78 4b                	js     800a45 <devfile_read+0x79>
		return r;
	assert(r <= n);
  8009fa:	39 c6                	cmp    %eax,%esi
  8009fc:	73 16                	jae    800a14 <devfile_read+0x48>
  8009fe:	68 04 1e 80 00       	push   $0x801e04
  800a03:	68 0b 1e 80 00       	push   $0x801e0b
  800a08:	6a 7c                	push   $0x7c
  800a0a:	68 20 1e 80 00       	push   $0x801e20
  800a0f:	e8 bd 05 00 00       	call   800fd1 <_panic>
	assert(r <= PGSIZE);
  800a14:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a19:	7e 16                	jle    800a31 <devfile_read+0x65>
  800a1b:	68 2b 1e 80 00       	push   $0x801e2b
  800a20:	68 0b 1e 80 00       	push   $0x801e0b
  800a25:	6a 7d                	push   $0x7d
  800a27:	68 20 1e 80 00       	push   $0x801e20
  800a2c:	e8 a0 05 00 00       	call   800fd1 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	50                   	push   %eax
  800a35:	68 00 50 80 00       	push   $0x805000
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	e8 6d 0d 00 00       	call   8017af <memmove>
	return r;
  800a42:	83 c4 10             	add    $0x10,%esp
}
  800a45:	89 d8                	mov    %ebx,%eax
  800a47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4a:	5b                   	pop    %ebx
  800a4b:	5e                   	pop    %esi
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	53                   	push   %ebx
  800a52:	83 ec 20             	sub    $0x20,%esp
  800a55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a58:	53                   	push   %ebx
  800a59:	e8 85 0b 00 00       	call   8015e3 <strlen>
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a66:	7f 67                	jg     800acf <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a68:	83 ec 0c             	sub    $0xc,%esp
  800a6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a6e:	50                   	push   %eax
  800a6f:	e8 78 f8 ff ff       	call   8002ec <fd_alloc>
  800a74:	83 c4 10             	add    $0x10,%esp
		return r;
  800a77:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a79:	85 c0                	test   %eax,%eax
  800a7b:	78 57                	js     800ad4 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	53                   	push   %ebx
  800a81:	68 00 50 80 00       	push   $0x805000
  800a86:	e8 91 0b 00 00       	call   80161c <strcpy>
	fsipcbuf.open.req_omode = mode;
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a96:	b8 01 00 00 00       	mov    $0x1,%eax
  800a9b:	e8 d3 fd ff ff       	call   800873 <fsipc>
  800aa0:	89 c3                	mov    %eax,%ebx
  800aa2:	83 c4 10             	add    $0x10,%esp
  800aa5:	85 c0                	test   %eax,%eax
  800aa7:	79 14                	jns    800abd <open+0x6f>
		fd_close(fd, 0);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	6a 00                	push   $0x0
  800aae:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab1:	e8 2e f9 ff ff       	call   8003e4 <fd_close>
		return r;
  800ab6:	83 c4 10             	add    $0x10,%esp
  800ab9:	89 da                	mov    %ebx,%edx
  800abb:	eb 17                	jmp    800ad4 <open+0x86>
	}

	return fd2num(fd);
  800abd:	83 ec 0c             	sub    $0xc,%esp
  800ac0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac3:	e8 fc f7 ff ff       	call   8002c4 <fd2num>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	eb 05                	jmp    800ad4 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800acf:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800ad4:	89 d0                	mov    %edx,%eax
  800ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    

00800adb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800ae1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae6:	b8 08 00 00 00       	mov    $0x8,%eax
  800aeb:	e8 83 fd ff ff       	call   800873 <fsipc>
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
  800af7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800afa:	83 ec 0c             	sub    $0xc,%esp
  800afd:	ff 75 08             	pushl  0x8(%ebp)
  800b00:	e8 cf f7 ff ff       	call   8002d4 <fd2data>
  800b05:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b07:	83 c4 08             	add    $0x8,%esp
  800b0a:	68 37 1e 80 00       	push   $0x801e37
  800b0f:	53                   	push   %ebx
  800b10:	e8 07 0b 00 00       	call   80161c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b15:	8b 46 04             	mov    0x4(%esi),%eax
  800b18:	2b 06                	sub    (%esi),%eax
  800b1a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b20:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b27:	00 00 00 
	stat->st_dev = &devpipe;
  800b2a:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b31:	30 80 00 
	return 0;
}
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	53                   	push   %ebx
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b4a:	53                   	push   %ebx
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 9f f6 ff ff       	call   8001f1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b52:	89 1c 24             	mov    %ebx,(%esp)
  800b55:	e8 7a f7 ff ff       	call   8002d4 <fd2data>
  800b5a:	83 c4 08             	add    $0x8,%esp
  800b5d:	50                   	push   %eax
  800b5e:	6a 00                	push   $0x0
  800b60:	e8 8c f6 ff ff       	call   8001f1 <sys_page_unmap>
}
  800b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	83 ec 1c             	sub    $0x1c,%esp
  800b73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b76:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800b78:	a1 04 40 80 00       	mov    0x804004,%eax
  800b7d:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800b80:	83 ec 0c             	sub    $0xc,%esp
  800b83:	ff 75 e0             	pushl  -0x20(%ebp)
  800b86:	e8 d1 0e 00 00       	call   801a5c <pageref>
  800b8b:	89 c3                	mov    %eax,%ebx
  800b8d:	89 3c 24             	mov    %edi,(%esp)
  800b90:	e8 c7 0e 00 00       	call   801a5c <pageref>
  800b95:	83 c4 10             	add    $0x10,%esp
  800b98:	39 c3                	cmp    %eax,%ebx
  800b9a:	0f 94 c1             	sete   %cl
  800b9d:	0f b6 c9             	movzbl %cl,%ecx
  800ba0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800ba3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ba9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800bac:	39 ce                	cmp    %ecx,%esi
  800bae:	74 1b                	je     800bcb <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800bb0:	39 c3                	cmp    %eax,%ebx
  800bb2:	75 c4                	jne    800b78 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bb4:	8b 42 58             	mov    0x58(%edx),%eax
  800bb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bba:	50                   	push   %eax
  800bbb:	56                   	push   %esi
  800bbc:	68 3e 1e 80 00       	push   $0x801e3e
  800bc1:	e8 e4 04 00 00       	call   8010aa <cprintf>
  800bc6:	83 c4 10             	add    $0x10,%esp
  800bc9:	eb ad                	jmp    800b78 <_pipeisclosed+0xe>
	}
}
  800bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	57                   	push   %edi
  800bda:	56                   	push   %esi
  800bdb:	53                   	push   %ebx
  800bdc:	83 ec 28             	sub    $0x28,%esp
  800bdf:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800be2:	56                   	push   %esi
  800be3:	e8 ec f6 ff ff       	call   8002d4 <fd2data>
  800be8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf2:	eb 4b                	jmp    800c3f <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800bf4:	89 da                	mov    %ebx,%edx
  800bf6:	89 f0                	mov    %esi,%eax
  800bf8:	e8 6d ff ff ff       	call   800b6a <_pipeisclosed>
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	75 48                	jne    800c49 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800c01:	e8 7a f5 ff ff       	call   800180 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c06:	8b 43 04             	mov    0x4(%ebx),%eax
  800c09:	8b 0b                	mov    (%ebx),%ecx
  800c0b:	8d 51 20             	lea    0x20(%ecx),%edx
  800c0e:	39 d0                	cmp    %edx,%eax
  800c10:	73 e2                	jae    800bf4 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c15:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c19:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c1c:	89 c2                	mov    %eax,%edx
  800c1e:	c1 fa 1f             	sar    $0x1f,%edx
  800c21:	89 d1                	mov    %edx,%ecx
  800c23:	c1 e9 1b             	shr    $0x1b,%ecx
  800c26:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c29:	83 e2 1f             	and    $0x1f,%edx
  800c2c:	29 ca                	sub    %ecx,%edx
  800c2e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c32:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c36:	83 c0 01             	add    $0x1,%eax
  800c39:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c3c:	83 c7 01             	add    $0x1,%edi
  800c3f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c42:	75 c2                	jne    800c06 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c44:	8b 45 10             	mov    0x10(%ebp),%eax
  800c47:	eb 05                	jmp    800c4e <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c49:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
  800c5c:	83 ec 18             	sub    $0x18,%esp
  800c5f:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c62:	57                   	push   %edi
  800c63:	e8 6c f6 ff ff       	call   8002d4 <fd2data>
  800c68:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c72:	eb 3d                	jmp    800cb1 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800c74:	85 db                	test   %ebx,%ebx
  800c76:	74 04                	je     800c7c <devpipe_read+0x26>
				return i;
  800c78:	89 d8                	mov    %ebx,%eax
  800c7a:	eb 44                	jmp    800cc0 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800c7c:	89 f2                	mov    %esi,%edx
  800c7e:	89 f8                	mov    %edi,%eax
  800c80:	e8 e5 fe ff ff       	call   800b6a <_pipeisclosed>
  800c85:	85 c0                	test   %eax,%eax
  800c87:	75 32                	jne    800cbb <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800c89:	e8 f2 f4 ff ff       	call   800180 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800c8e:	8b 06                	mov    (%esi),%eax
  800c90:	3b 46 04             	cmp    0x4(%esi),%eax
  800c93:	74 df                	je     800c74 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800c95:	99                   	cltd   
  800c96:	c1 ea 1b             	shr    $0x1b,%edx
  800c99:	01 d0                	add    %edx,%eax
  800c9b:	83 e0 1f             	and    $0x1f,%eax
  800c9e:	29 d0                	sub    %edx,%eax
  800ca0:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800cab:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800cae:	83 c3 01             	add    $0x1,%ebx
  800cb1:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cb4:	75 d8                	jne    800c8e <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	eb 05                	jmp    800cc0 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cbb:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800cd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cd3:	50                   	push   %eax
  800cd4:	e8 13 f6 ff ff       	call   8002ec <fd_alloc>
  800cd9:	83 c4 10             	add    $0x10,%esp
  800cdc:	89 c2                	mov    %eax,%edx
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	0f 88 2c 01 00 00    	js     800e12 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ce6:	83 ec 04             	sub    $0x4,%esp
  800ce9:	68 07 04 00 00       	push   $0x407
  800cee:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf1:	6a 00                	push   $0x0
  800cf3:	e8 af f4 ff ff       	call   8001a7 <sys_page_alloc>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	89 c2                	mov    %eax,%edx
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	0f 88 0d 01 00 00    	js     800e12 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800d05:	83 ec 0c             	sub    $0xc,%esp
  800d08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	e8 db f5 ff ff       	call   8002ec <fd_alloc>
  800d11:	89 c3                	mov    %eax,%ebx
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	85 c0                	test   %eax,%eax
  800d18:	0f 88 e2 00 00 00    	js     800e00 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d1e:	83 ec 04             	sub    $0x4,%esp
  800d21:	68 07 04 00 00       	push   $0x407
  800d26:	ff 75 f0             	pushl  -0x10(%ebp)
  800d29:	6a 00                	push   $0x0
  800d2b:	e8 77 f4 ff ff       	call   8001a7 <sys_page_alloc>
  800d30:	89 c3                	mov    %eax,%ebx
  800d32:	83 c4 10             	add    $0x10,%esp
  800d35:	85 c0                	test   %eax,%eax
  800d37:	0f 88 c3 00 00 00    	js     800e00 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d3d:	83 ec 0c             	sub    $0xc,%esp
  800d40:	ff 75 f4             	pushl  -0xc(%ebp)
  800d43:	e8 8c f5 ff ff       	call   8002d4 <fd2data>
  800d48:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d4a:	83 c4 0c             	add    $0xc,%esp
  800d4d:	68 07 04 00 00       	push   $0x407
  800d52:	50                   	push   %eax
  800d53:	6a 00                	push   $0x0
  800d55:	e8 4d f4 ff ff       	call   8001a7 <sys_page_alloc>
  800d5a:	89 c3                	mov    %eax,%ebx
  800d5c:	83 c4 10             	add    $0x10,%esp
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	0f 88 89 00 00 00    	js     800df0 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	ff 75 f0             	pushl  -0x10(%ebp)
  800d6d:	e8 62 f5 ff ff       	call   8002d4 <fd2data>
  800d72:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800d79:	50                   	push   %eax
  800d7a:	6a 00                	push   $0x0
  800d7c:	56                   	push   %esi
  800d7d:	6a 00                	push   $0x0
  800d7f:	e8 47 f4 ff ff       	call   8001cb <sys_page_map>
  800d84:	89 c3                	mov    %eax,%ebx
  800d86:	83 c4 20             	add    $0x20,%esp
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	78 55                	js     800de2 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800d8d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d96:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800da2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dab:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800db7:	83 ec 0c             	sub    $0xc,%esp
  800dba:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbd:	e8 02 f5 ff ff       	call   8002c4 <fd2num>
  800dc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dc7:	83 c4 04             	add    $0x4,%esp
  800dca:	ff 75 f0             	pushl  -0x10(%ebp)
  800dcd:	e8 f2 f4 ff ff       	call   8002c4 <fd2num>
  800dd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800dd8:	83 c4 10             	add    $0x10,%esp
  800ddb:	ba 00 00 00 00       	mov    $0x0,%edx
  800de0:	eb 30                	jmp    800e12 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800de2:	83 ec 08             	sub    $0x8,%esp
  800de5:	56                   	push   %esi
  800de6:	6a 00                	push   $0x0
  800de8:	e8 04 f4 ff ff       	call   8001f1 <sys_page_unmap>
  800ded:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	ff 75 f0             	pushl  -0x10(%ebp)
  800df6:	6a 00                	push   $0x0
  800df8:	e8 f4 f3 ff ff       	call   8001f1 <sys_page_unmap>
  800dfd:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800e00:	83 ec 08             	sub    $0x8,%esp
  800e03:	ff 75 f4             	pushl  -0xc(%ebp)
  800e06:	6a 00                	push   $0x0
  800e08:	e8 e4 f3 ff ff       	call   8001f1 <sys_page_unmap>
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e12:	89 d0                	mov    %edx,%eax
  800e14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e24:	50                   	push   %eax
  800e25:	ff 75 08             	pushl  0x8(%ebp)
  800e28:	e8 0e f5 ff ff       	call   80033b <fd_lookup>
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	85 c0                	test   %eax,%eax
  800e32:	78 18                	js     800e4c <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3a:	e8 95 f4 ff ff       	call   8002d4 <fd2data>
	return _pipeisclosed(fd, p);
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e44:	e8 21 fd ff ff       	call   800b6a <_pipeisclosed>
  800e49:	83 c4 10             	add    $0x10,%esp
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e51:	b8 00 00 00 00       	mov    $0x0,%eax
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e5e:	68 56 1e 80 00       	push   $0x801e56
  800e63:	ff 75 0c             	pushl  0xc(%ebp)
  800e66:	e8 b1 07 00 00       	call   80161c <strcpy>
	return 0;
}
  800e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	57                   	push   %edi
  800e76:	56                   	push   %esi
  800e77:	53                   	push   %ebx
  800e78:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e7e:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e83:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800e89:	eb 2d                	jmp    800eb8 <devcons_write+0x46>
		m = n - tot;
  800e8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8e:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800e90:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800e93:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800e98:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800e9b:	83 ec 04             	sub    $0x4,%esp
  800e9e:	53                   	push   %ebx
  800e9f:	03 45 0c             	add    0xc(%ebp),%eax
  800ea2:	50                   	push   %eax
  800ea3:	57                   	push   %edi
  800ea4:	e8 06 09 00 00       	call   8017af <memmove>
		sys_cputs(buf, m);
  800ea9:	83 c4 08             	add    $0x8,%esp
  800eac:	53                   	push   %ebx
  800ead:	57                   	push   %edi
  800eae:	e8 3d f2 ff ff       	call   8000f0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800eb3:	01 de                	add    %ebx,%esi
  800eb5:	83 c4 10             	add    $0x10,%esp
  800eb8:	89 f0                	mov    %esi,%eax
  800eba:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ebd:	72 cc                	jb     800e8b <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 08             	sub    $0x8,%esp
  800ecd:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800ed2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed6:	74 2a                	je     800f02 <devcons_read+0x3b>
  800ed8:	eb 05                	jmp    800edf <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800eda:	e8 a1 f2 ff ff       	call   800180 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800edf:	e8 32 f2 ff ff       	call   800116 <sys_cgetc>
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	74 f2                	je     800eda <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	78 16                	js     800f02 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800eec:	83 f8 04             	cmp    $0x4,%eax
  800eef:	74 0c                	je     800efd <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef4:	88 02                	mov    %al,(%edx)
	return 1;
  800ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  800efb:	eb 05                	jmp    800f02 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800efd:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f10:	6a 01                	push   $0x1
  800f12:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f15:	50                   	push   %eax
  800f16:	e8 d5 f1 ff ff       	call   8000f0 <sys_cputs>
}
  800f1b:	83 c4 10             	add    $0x10,%esp
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <getchar>:

int
getchar(void)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f26:	6a 01                	push   $0x1
  800f28:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f2b:	50                   	push   %eax
  800f2c:	6a 00                	push   $0x0
  800f2e:	e8 6d f6 ff ff       	call   8005a0 <read>
	if (r < 0)
  800f33:	83 c4 10             	add    $0x10,%esp
  800f36:	85 c0                	test   %eax,%eax
  800f38:	78 0f                	js     800f49 <getchar+0x29>
		return r;
	if (r < 1)
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	7e 06                	jle    800f44 <getchar+0x24>
		return -E_EOF;
	return c;
  800f3e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f42:	eb 05                	jmp    800f49 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f44:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f54:	50                   	push   %eax
  800f55:	ff 75 08             	pushl  0x8(%ebp)
  800f58:	e8 de f3 ff ff       	call   80033b <fd_lookup>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	85 c0                	test   %eax,%eax
  800f62:	78 11                	js     800f75 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f67:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800f6d:	39 10                	cmp    %edx,(%eax)
  800f6f:	0f 94 c0             	sete   %al
  800f72:	0f b6 c0             	movzbl %al,%eax
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <opencons>:

int
opencons(void)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f80:	50                   	push   %eax
  800f81:	e8 66 f3 ff ff       	call   8002ec <fd_alloc>
  800f86:	83 c4 10             	add    $0x10,%esp
		return r;
  800f89:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	78 3e                	js     800fcd <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	68 07 04 00 00       	push   $0x407
  800f97:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9a:	6a 00                	push   $0x0
  800f9c:	e8 06 f2 ff ff       	call   8001a7 <sys_page_alloc>
  800fa1:	83 c4 10             	add    $0x10,%esp
		return r;
  800fa4:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	78 23                	js     800fcd <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800faa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	50                   	push   %eax
  800fc3:	e8 fc f2 ff ff       	call   8002c4 <fd2num>
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	83 c4 10             	add    $0x10,%esp
}
  800fcd:	89 d0                	mov    %edx,%eax
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800fd6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800fd9:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800fdf:	e8 78 f1 ff ff       	call   80015c <sys_getenvid>
  800fe4:	83 ec 0c             	sub    $0xc,%esp
  800fe7:	ff 75 0c             	pushl  0xc(%ebp)
  800fea:	ff 75 08             	pushl  0x8(%ebp)
  800fed:	56                   	push   %esi
  800fee:	50                   	push   %eax
  800fef:	68 64 1e 80 00       	push   $0x801e64
  800ff4:	e8 b1 00 00 00       	call   8010aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ff9:	83 c4 18             	add    $0x18,%esp
  800ffc:	53                   	push   %ebx
  800ffd:	ff 75 10             	pushl  0x10(%ebp)
  801000:	e8 54 00 00 00       	call   801059 <vcprintf>
	cprintf("\n");
  801005:	c7 04 24 4f 1e 80 00 	movl   $0x801e4f,(%esp)
  80100c:	e8 99 00 00 00       	call   8010aa <cprintf>
  801011:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801014:	cc                   	int3   
  801015:	eb fd                	jmp    801014 <_panic+0x43>

00801017 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	53                   	push   %ebx
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801021:	8b 13                	mov    (%ebx),%edx
  801023:	8d 42 01             	lea    0x1(%edx),%eax
  801026:	89 03                	mov    %eax,(%ebx)
  801028:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80102f:	3d ff 00 00 00       	cmp    $0xff,%eax
  801034:	75 1a                	jne    801050 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	68 ff 00 00 00       	push   $0xff
  80103e:	8d 43 08             	lea    0x8(%ebx),%eax
  801041:	50                   	push   %eax
  801042:	e8 a9 f0 ff ff       	call   8000f0 <sys_cputs>
		b->idx = 0;
  801047:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80104d:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801050:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801062:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801069:	00 00 00 
	b.cnt = 0;
  80106c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801073:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801076:	ff 75 0c             	pushl  0xc(%ebp)
  801079:	ff 75 08             	pushl  0x8(%ebp)
  80107c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 17 10 80 00       	push   $0x801017
  801088:	e8 86 01 00 00       	call   801213 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80108d:	83 c4 08             	add    $0x8,%esp
  801090:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801096:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80109c:	50                   	push   %eax
  80109d:	e8 4e f0 ff ff       	call   8000f0 <sys_cputs>

	return b.cnt;
}
  8010a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010b0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010b3:	50                   	push   %eax
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 9d ff ff ff       	call   801059 <vcprintf>
	va_end(ap);

	return cnt;
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 1c             	sub    $0x1c,%esp
  8010c7:	89 c7                	mov    %eax,%edi
  8010c9:	89 d6                	mov    %edx,%esi
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8010d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8010d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8010e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010e5:	39 d3                	cmp    %edx,%ebx
  8010e7:	72 05                	jb     8010ee <printnum+0x30>
  8010e9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8010ec:	77 45                	ja     801133 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	ff 75 18             	pushl  0x18(%ebp)
  8010f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8010fa:	53                   	push   %ebx
  8010fb:	ff 75 10             	pushl  0x10(%ebp)
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 e4             	pushl  -0x1c(%ebp)
  801104:	ff 75 e0             	pushl  -0x20(%ebp)
  801107:	ff 75 dc             	pushl  -0x24(%ebp)
  80110a:	ff 75 d8             	pushl  -0x28(%ebp)
  80110d:	e8 8e 09 00 00       	call   801aa0 <__udivdi3>
  801112:	83 c4 18             	add    $0x18,%esp
  801115:	52                   	push   %edx
  801116:	50                   	push   %eax
  801117:	89 f2                	mov    %esi,%edx
  801119:	89 f8                	mov    %edi,%eax
  80111b:	e8 9e ff ff ff       	call   8010be <printnum>
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	eb 18                	jmp    80113d <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801125:	83 ec 08             	sub    $0x8,%esp
  801128:	56                   	push   %esi
  801129:	ff 75 18             	pushl  0x18(%ebp)
  80112c:	ff d7                	call   *%edi
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	eb 03                	jmp    801136 <printnum+0x78>
  801133:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801136:	83 eb 01             	sub    $0x1,%ebx
  801139:	85 db                	test   %ebx,%ebx
  80113b:	7f e8                	jg     801125 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	56                   	push   %esi
  801141:	83 ec 04             	sub    $0x4,%esp
  801144:	ff 75 e4             	pushl  -0x1c(%ebp)
  801147:	ff 75 e0             	pushl  -0x20(%ebp)
  80114a:	ff 75 dc             	pushl  -0x24(%ebp)
  80114d:	ff 75 d8             	pushl  -0x28(%ebp)
  801150:	e8 7b 0a 00 00       	call   801bd0 <__umoddi3>
  801155:	83 c4 14             	add    $0x14,%esp
  801158:	0f be 80 87 1e 80 00 	movsbl 0x801e87(%eax),%eax
  80115f:	50                   	push   %eax
  801160:	ff d7                	call   *%edi
}
  801162:	83 c4 10             	add    $0x10,%esp
  801165:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801168:	5b                   	pop    %ebx
  801169:	5e                   	pop    %esi
  80116a:	5f                   	pop    %edi
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801170:	83 fa 01             	cmp    $0x1,%edx
  801173:	7e 0e                	jle    801183 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801175:	8b 10                	mov    (%eax),%edx
  801177:	8d 4a 08             	lea    0x8(%edx),%ecx
  80117a:	89 08                	mov    %ecx,(%eax)
  80117c:	8b 02                	mov    (%edx),%eax
  80117e:	8b 52 04             	mov    0x4(%edx),%edx
  801181:	eb 22                	jmp    8011a5 <getuint+0x38>
	else if (lflag)
  801183:	85 d2                	test   %edx,%edx
  801185:	74 10                	je     801197 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801187:	8b 10                	mov    (%eax),%edx
  801189:	8d 4a 04             	lea    0x4(%edx),%ecx
  80118c:	89 08                	mov    %ecx,(%eax)
  80118e:	8b 02                	mov    (%edx),%eax
  801190:	ba 00 00 00 00       	mov    $0x0,%edx
  801195:	eb 0e                	jmp    8011a5 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801197:	8b 10                	mov    (%eax),%edx
  801199:	8d 4a 04             	lea    0x4(%edx),%ecx
  80119c:	89 08                	mov    %ecx,(%eax)
  80119e:	8b 02                	mov    (%edx),%eax
  8011a0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011aa:	83 fa 01             	cmp    $0x1,%edx
  8011ad:	7e 0e                	jle    8011bd <getint+0x16>
		return va_arg(*ap, long long);
  8011af:	8b 10                	mov    (%eax),%edx
  8011b1:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011b4:	89 08                	mov    %ecx,(%eax)
  8011b6:	8b 02                	mov    (%edx),%eax
  8011b8:	8b 52 04             	mov    0x4(%edx),%edx
  8011bb:	eb 1a                	jmp    8011d7 <getint+0x30>
	else if (lflag)
  8011bd:	85 d2                	test   %edx,%edx
  8011bf:	74 0c                	je     8011cd <getint+0x26>
		return va_arg(*ap, long);
  8011c1:	8b 10                	mov    (%eax),%edx
  8011c3:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011c6:	89 08                	mov    %ecx,(%eax)
  8011c8:	8b 02                	mov    (%edx),%eax
  8011ca:	99                   	cltd   
  8011cb:	eb 0a                	jmp    8011d7 <getint+0x30>
	else
		return va_arg(*ap, int);
  8011cd:	8b 10                	mov    (%eax),%edx
  8011cf:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011d2:	89 08                	mov    %ecx,(%eax)
  8011d4:	8b 02                	mov    (%edx),%eax
  8011d6:	99                   	cltd   
}
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011e3:	8b 10                	mov    (%eax),%edx
  8011e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8011e8:	73 0a                	jae    8011f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8011ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011ed:	89 08                	mov    %ecx,(%eax)
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	88 02                	mov    %al,(%edx)
}
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8011fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8011ff:	50                   	push   %eax
  801200:	ff 75 10             	pushl  0x10(%ebp)
  801203:	ff 75 0c             	pushl  0xc(%ebp)
  801206:	ff 75 08             	pushl  0x8(%ebp)
  801209:	e8 05 00 00 00       	call   801213 <vprintfmt>
	va_end(ap);
}
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 2c             	sub    $0x2c,%esp
  80121c:	8b 75 08             	mov    0x8(%ebp),%esi
  80121f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801222:	8b 7d 10             	mov    0x10(%ebp),%edi
  801225:	eb 12                	jmp    801239 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801227:	85 c0                	test   %eax,%eax
  801229:	0f 84 44 03 00 00    	je     801573 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80122f:	83 ec 08             	sub    $0x8,%esp
  801232:	53                   	push   %ebx
  801233:	50                   	push   %eax
  801234:	ff d6                	call   *%esi
  801236:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801239:	83 c7 01             	add    $0x1,%edi
  80123c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801240:	83 f8 25             	cmp    $0x25,%eax
  801243:	75 e2                	jne    801227 <vprintfmt+0x14>
  801245:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801249:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801250:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801257:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80125e:	ba 00 00 00 00       	mov    $0x0,%edx
  801263:	eb 07                	jmp    80126c <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801265:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801268:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80126c:	8d 47 01             	lea    0x1(%edi),%eax
  80126f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801272:	0f b6 07             	movzbl (%edi),%eax
  801275:	0f b6 c8             	movzbl %al,%ecx
  801278:	83 e8 23             	sub    $0x23,%eax
  80127b:	3c 55                	cmp    $0x55,%al
  80127d:	0f 87 d5 02 00 00    	ja     801558 <vprintfmt+0x345>
  801283:	0f b6 c0             	movzbl %al,%eax
  801286:	ff 24 85 c0 1f 80 00 	jmp    *0x801fc0(,%eax,4)
  80128d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801290:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801294:	eb d6                	jmp    80126c <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801296:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8012a1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8012a4:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012a8:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012ab:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012ae:	83 fa 09             	cmp    $0x9,%edx
  8012b1:	77 39                	ja     8012ec <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012b3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012b6:	eb e9                	jmp    8012a1 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8012be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012c1:	8b 00                	mov    (%eax),%eax
  8012c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012c9:	eb 27                	jmp    8012f2 <vprintfmt+0xdf>
  8012cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d5:	0f 49 c8             	cmovns %eax,%ecx
  8012d8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012de:	eb 8c                	jmp    80126c <vprintfmt+0x59>
  8012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8012e3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012ea:	eb 80                	jmp    80126c <vprintfmt+0x59>
  8012ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012ef:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8012f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012f6:	0f 89 70 ff ff ff    	jns    80126c <vprintfmt+0x59>
				width = precision, precision = -1;
  8012fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801302:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801309:	e9 5e ff ff ff       	jmp    80126c <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80130e:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801311:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801314:	e9 53 ff ff ff       	jmp    80126c <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801319:	8b 45 14             	mov    0x14(%ebp),%eax
  80131c:	8d 50 04             	lea    0x4(%eax),%edx
  80131f:	89 55 14             	mov    %edx,0x14(%ebp)
  801322:	83 ec 08             	sub    $0x8,%esp
  801325:	53                   	push   %ebx
  801326:	ff 30                	pushl  (%eax)
  801328:	ff d6                	call   *%esi
			break;
  80132a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80132d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801330:	e9 04 ff ff ff       	jmp    801239 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8d 50 04             	lea    0x4(%eax),%edx
  80133b:	89 55 14             	mov    %edx,0x14(%ebp)
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	99                   	cltd   
  801341:	31 d0                	xor    %edx,%eax
  801343:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801345:	83 f8 0f             	cmp    $0xf,%eax
  801348:	7f 0b                	jg     801355 <vprintfmt+0x142>
  80134a:	8b 14 85 20 21 80 00 	mov    0x802120(,%eax,4),%edx
  801351:	85 d2                	test   %edx,%edx
  801353:	75 18                	jne    80136d <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  801355:	50                   	push   %eax
  801356:	68 9f 1e 80 00       	push   $0x801e9f
  80135b:	53                   	push   %ebx
  80135c:	56                   	push   %esi
  80135d:	e8 94 fe ff ff       	call   8011f6 <printfmt>
  801362:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801368:	e9 cc fe ff ff       	jmp    801239 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80136d:	52                   	push   %edx
  80136e:	68 1d 1e 80 00       	push   $0x801e1d
  801373:	53                   	push   %ebx
  801374:	56                   	push   %esi
  801375:	e8 7c fe ff ff       	call   8011f6 <printfmt>
  80137a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80137d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801380:	e9 b4 fe ff ff       	jmp    801239 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801385:	8b 45 14             	mov    0x14(%ebp),%eax
  801388:	8d 50 04             	lea    0x4(%eax),%edx
  80138b:	89 55 14             	mov    %edx,0x14(%ebp)
  80138e:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801390:	85 ff                	test   %edi,%edi
  801392:	b8 98 1e 80 00       	mov    $0x801e98,%eax
  801397:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80139a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80139e:	0f 8e 94 00 00 00    	jle    801438 <vprintfmt+0x225>
  8013a4:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013a8:	0f 84 98 00 00 00    	je     801446 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	ff 75 d0             	pushl  -0x30(%ebp)
  8013b4:	57                   	push   %edi
  8013b5:	e8 41 02 00 00       	call   8015fb <strnlen>
  8013ba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013bd:	29 c1                	sub    %eax,%ecx
  8013bf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013c2:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013c5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013cc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8013cf:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013d1:	eb 0f                	jmp    8013e2 <vprintfmt+0x1cf>
					putch(padc, putdat);
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	53                   	push   %ebx
  8013d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8013da:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013dc:	83 ef 01             	sub    $0x1,%edi
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 ff                	test   %edi,%edi
  8013e4:	7f ed                	jg     8013d3 <vprintfmt+0x1c0>
  8013e6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8013e9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8013ec:	85 c9                	test   %ecx,%ecx
  8013ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f3:	0f 49 c1             	cmovns %ecx,%eax
  8013f6:	29 c1                	sub    %eax,%ecx
  8013f8:	89 75 08             	mov    %esi,0x8(%ebp)
  8013fb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013fe:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801401:	89 cb                	mov    %ecx,%ebx
  801403:	eb 4d                	jmp    801452 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801405:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801409:	74 1b                	je     801426 <vprintfmt+0x213>
  80140b:	0f be c0             	movsbl %al,%eax
  80140e:	83 e8 20             	sub    $0x20,%eax
  801411:	83 f8 5e             	cmp    $0x5e,%eax
  801414:	76 10                	jbe    801426 <vprintfmt+0x213>
					putch('?', putdat);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	6a 3f                	push   $0x3f
  80141e:	ff 55 08             	call   *0x8(%ebp)
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	eb 0d                	jmp    801433 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  801426:	83 ec 08             	sub    $0x8,%esp
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	52                   	push   %edx
  80142d:	ff 55 08             	call   *0x8(%ebp)
  801430:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801433:	83 eb 01             	sub    $0x1,%ebx
  801436:	eb 1a                	jmp    801452 <vprintfmt+0x23f>
  801438:	89 75 08             	mov    %esi,0x8(%ebp)
  80143b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80143e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801444:	eb 0c                	jmp    801452 <vprintfmt+0x23f>
  801446:	89 75 08             	mov    %esi,0x8(%ebp)
  801449:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80144c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80144f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801452:	83 c7 01             	add    $0x1,%edi
  801455:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801459:	0f be d0             	movsbl %al,%edx
  80145c:	85 d2                	test   %edx,%edx
  80145e:	74 23                	je     801483 <vprintfmt+0x270>
  801460:	85 f6                	test   %esi,%esi
  801462:	78 a1                	js     801405 <vprintfmt+0x1f2>
  801464:	83 ee 01             	sub    $0x1,%esi
  801467:	79 9c                	jns    801405 <vprintfmt+0x1f2>
  801469:	89 df                	mov    %ebx,%edi
  80146b:	8b 75 08             	mov    0x8(%ebp),%esi
  80146e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801471:	eb 18                	jmp    80148b <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	53                   	push   %ebx
  801477:	6a 20                	push   $0x20
  801479:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80147b:	83 ef 01             	sub    $0x1,%edi
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	eb 08                	jmp    80148b <vprintfmt+0x278>
  801483:	89 df                	mov    %ebx,%edi
  801485:	8b 75 08             	mov    0x8(%ebp),%esi
  801488:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80148b:	85 ff                	test   %edi,%edi
  80148d:	7f e4                	jg     801473 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80148f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801492:	e9 a2 fd ff ff       	jmp    801239 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801497:	8d 45 14             	lea    0x14(%ebp),%eax
  80149a:	e8 08 fd ff ff       	call   8011a7 <getint>
  80149f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8014a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014ae:	79 74                	jns    801524 <vprintfmt+0x311>
				putch('-', putdat);
  8014b0:	83 ec 08             	sub    $0x8,%esp
  8014b3:	53                   	push   %ebx
  8014b4:	6a 2d                	push   $0x2d
  8014b6:	ff d6                	call   *%esi
				num = -(long long) num;
  8014b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014be:	f7 d8                	neg    %eax
  8014c0:	83 d2 00             	adc    $0x0,%edx
  8014c3:	f7 da                	neg    %edx
  8014c5:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014cd:	eb 55                	jmp    801524 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8014cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8014d2:	e8 96 fc ff ff       	call   80116d <getuint>
			base = 10;
  8014d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8014dc:	eb 46                	jmp    801524 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8014de:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e1:	e8 87 fc ff ff       	call   80116d <getuint>
			base = 8;
  8014e6:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8014eb:	eb 37                	jmp    801524 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8014ed:	83 ec 08             	sub    $0x8,%esp
  8014f0:	53                   	push   %ebx
  8014f1:	6a 30                	push   $0x30
  8014f3:	ff d6                	call   *%esi
			putch('x', putdat);
  8014f5:	83 c4 08             	add    $0x8,%esp
  8014f8:	53                   	push   %ebx
  8014f9:	6a 78                	push   $0x78
  8014fb:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8014fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801500:	8d 50 04             	lea    0x4(%eax),%edx
  801503:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801506:	8b 00                	mov    (%eax),%eax
  801508:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80150d:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801510:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801515:	eb 0d                	jmp    801524 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801517:	8d 45 14             	lea    0x14(%ebp),%eax
  80151a:	e8 4e fc ff ff       	call   80116d <getuint>
			base = 16;
  80151f:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801524:	83 ec 0c             	sub    $0xc,%esp
  801527:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80152b:	57                   	push   %edi
  80152c:	ff 75 e0             	pushl  -0x20(%ebp)
  80152f:	51                   	push   %ecx
  801530:	52                   	push   %edx
  801531:	50                   	push   %eax
  801532:	89 da                	mov    %ebx,%edx
  801534:	89 f0                	mov    %esi,%eax
  801536:	e8 83 fb ff ff       	call   8010be <printnum>
			break;
  80153b:	83 c4 20             	add    $0x20,%esp
  80153e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801541:	e9 f3 fc ff ff       	jmp    801239 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801546:	83 ec 08             	sub    $0x8,%esp
  801549:	53                   	push   %ebx
  80154a:	51                   	push   %ecx
  80154b:	ff d6                	call   *%esi
			break;
  80154d:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801550:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801553:	e9 e1 fc ff ff       	jmp    801239 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	53                   	push   %ebx
  80155c:	6a 25                	push   $0x25
  80155e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	eb 03                	jmp    801568 <vprintfmt+0x355>
  801565:	83 ef 01             	sub    $0x1,%edi
  801568:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80156c:	75 f7                	jne    801565 <vprintfmt+0x352>
  80156e:	e9 c6 fc ff ff       	jmp    801239 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  801573:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801576:	5b                   	pop    %ebx
  801577:	5e                   	pop    %esi
  801578:	5f                   	pop    %edi
  801579:	5d                   	pop    %ebp
  80157a:	c3                   	ret    

0080157b <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 18             	sub    $0x18,%esp
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801587:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80158a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80158e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801591:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 26                	je     8015c2 <vsnprintf+0x47>
  80159c:	85 d2                	test   %edx,%edx
  80159e:	7e 22                	jle    8015c2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015a0:	ff 75 14             	pushl  0x14(%ebp)
  8015a3:	ff 75 10             	pushl  0x10(%ebp)
  8015a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015a9:	50                   	push   %eax
  8015aa:	68 d9 11 80 00       	push   $0x8011d9
  8015af:	e8 5f fc ff ff       	call   801213 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	eb 05                	jmp    8015c7 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015cf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8015d2:	50                   	push   %eax
  8015d3:	ff 75 10             	pushl  0x10(%ebp)
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	e8 9a ff ff ff       	call   80157b <vsnprintf>
	va_end(ap);

	return rc;
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ee:	eb 03                	jmp    8015f3 <strlen+0x10>
		n++;
  8015f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8015f7:	75 f7                	jne    8015f0 <strlen+0xd>
		n++;
	return n;
}
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    

008015fb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801604:	ba 00 00 00 00       	mov    $0x0,%edx
  801609:	eb 03                	jmp    80160e <strnlen+0x13>
		n++;
  80160b:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80160e:	39 c2                	cmp    %eax,%edx
  801610:	74 08                	je     80161a <strnlen+0x1f>
  801612:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801616:	75 f3                	jne    80160b <strnlen+0x10>
  801618:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	53                   	push   %ebx
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801626:	89 c2                	mov    %eax,%edx
  801628:	83 c2 01             	add    $0x1,%edx
  80162b:	83 c1 01             	add    $0x1,%ecx
  80162e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801632:	88 5a ff             	mov    %bl,-0x1(%edx)
  801635:	84 db                	test   %bl,%bl
  801637:	75 ef                	jne    801628 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801639:	5b                   	pop    %ebx
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	53                   	push   %ebx
  801640:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801643:	53                   	push   %ebx
  801644:	e8 9a ff ff ff       	call   8015e3 <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80164c:	ff 75 0c             	pushl  0xc(%ebp)
  80164f:	01 d8                	add    %ebx,%eax
  801651:	50                   	push   %eax
  801652:	e8 c5 ff ff ff       	call   80161c <strcpy>
	return dst;
}
  801657:	89 d8                	mov    %ebx,%eax
  801659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	8b 75 08             	mov    0x8(%ebp),%esi
  801666:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801669:	89 f3                	mov    %esi,%ebx
  80166b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166e:	89 f2                	mov    %esi,%edx
  801670:	eb 0f                	jmp    801681 <strncpy+0x23>
		*dst++ = *src;
  801672:	83 c2 01             	add    $0x1,%edx
  801675:	0f b6 01             	movzbl (%ecx),%eax
  801678:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80167b:	80 39 01             	cmpb   $0x1,(%ecx)
  80167e:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801681:	39 da                	cmp    %ebx,%edx
  801683:	75 ed                	jne    801672 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801685:	89 f0                	mov    %esi,%eax
  801687:	5b                   	pop    %ebx
  801688:	5e                   	pop    %esi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    

0080168b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
  801690:	8b 75 08             	mov    0x8(%ebp),%esi
  801693:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801696:	8b 55 10             	mov    0x10(%ebp),%edx
  801699:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80169b:	85 d2                	test   %edx,%edx
  80169d:	74 21                	je     8016c0 <strlcpy+0x35>
  80169f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8016a3:	89 f2                	mov    %esi,%edx
  8016a5:	eb 09                	jmp    8016b0 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016a7:	83 c2 01             	add    $0x1,%edx
  8016aa:	83 c1 01             	add    $0x1,%ecx
  8016ad:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016b0:	39 c2                	cmp    %eax,%edx
  8016b2:	74 09                	je     8016bd <strlcpy+0x32>
  8016b4:	0f b6 19             	movzbl (%ecx),%ebx
  8016b7:	84 db                	test   %bl,%bl
  8016b9:	75 ec                	jne    8016a7 <strlcpy+0x1c>
  8016bb:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016c0:	29 f0                	sub    %esi,%eax
}
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    

008016c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8016cf:	eb 06                	jmp    8016d7 <strcmp+0x11>
		p++, q++;
  8016d1:	83 c1 01             	add    $0x1,%ecx
  8016d4:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d7:	0f b6 01             	movzbl (%ecx),%eax
  8016da:	84 c0                	test   %al,%al
  8016dc:	74 04                	je     8016e2 <strcmp+0x1c>
  8016de:	3a 02                	cmp    (%edx),%al
  8016e0:	74 ef                	je     8016d1 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016e2:	0f b6 c0             	movzbl %al,%eax
  8016e5:	0f b6 12             	movzbl (%edx),%edx
  8016e8:	29 d0                	sub    %edx,%eax
}
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	53                   	push   %ebx
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f6:	89 c3                	mov    %eax,%ebx
  8016f8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8016fb:	eb 06                	jmp    801703 <strncmp+0x17>
		n--, p++, q++;
  8016fd:	83 c0 01             	add    $0x1,%eax
  801700:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801703:	39 d8                	cmp    %ebx,%eax
  801705:	74 15                	je     80171c <strncmp+0x30>
  801707:	0f b6 08             	movzbl (%eax),%ecx
  80170a:	84 c9                	test   %cl,%cl
  80170c:	74 04                	je     801712 <strncmp+0x26>
  80170e:	3a 0a                	cmp    (%edx),%cl
  801710:	74 eb                	je     8016fd <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801712:	0f b6 00             	movzbl (%eax),%eax
  801715:	0f b6 12             	movzbl (%edx),%edx
  801718:	29 d0                	sub    %edx,%eax
  80171a:	eb 05                	jmp    801721 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801721:	5b                   	pop    %ebx
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80172e:	eb 07                	jmp    801737 <strchr+0x13>
		if (*s == c)
  801730:	38 ca                	cmp    %cl,%dl
  801732:	74 0f                	je     801743 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801734:	83 c0 01             	add    $0x1,%eax
  801737:	0f b6 10             	movzbl (%eax),%edx
  80173a:	84 d2                	test   %dl,%dl
  80173c:	75 f2                	jne    801730 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80174f:	eb 03                	jmp    801754 <strfind+0xf>
  801751:	83 c0 01             	add    $0x1,%eax
  801754:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801757:	38 ca                	cmp    %cl,%dl
  801759:	74 04                	je     80175f <strfind+0x1a>
  80175b:	84 d2                	test   %dl,%dl
  80175d:	75 f2                	jne    801751 <strfind+0xc>
			break;
	return (char *) s;
}
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	57                   	push   %edi
  801765:	56                   	push   %esi
  801766:	53                   	push   %ebx
  801767:	8b 55 08             	mov    0x8(%ebp),%edx
  80176a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80176d:	85 c9                	test   %ecx,%ecx
  80176f:	74 37                	je     8017a8 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801771:	f6 c2 03             	test   $0x3,%dl
  801774:	75 2a                	jne    8017a0 <memset+0x3f>
  801776:	f6 c1 03             	test   $0x3,%cl
  801779:	75 25                	jne    8017a0 <memset+0x3f>
		c &= 0xFF;
  80177b:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80177f:	89 df                	mov    %ebx,%edi
  801781:	c1 e7 08             	shl    $0x8,%edi
  801784:	89 de                	mov    %ebx,%esi
  801786:	c1 e6 18             	shl    $0x18,%esi
  801789:	89 d8                	mov    %ebx,%eax
  80178b:	c1 e0 10             	shl    $0x10,%eax
  80178e:	09 f0                	or     %esi,%eax
  801790:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  801792:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801795:	89 f8                	mov    %edi,%eax
  801797:	09 d8                	or     %ebx,%eax
  801799:	89 d7                	mov    %edx,%edi
  80179b:	fc                   	cld    
  80179c:	f3 ab                	rep stos %eax,%es:(%edi)
  80179e:	eb 08                	jmp    8017a8 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017a0:	89 d7                	mov    %edx,%edi
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	fc                   	cld    
  8017a6:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017a8:	89 d0                	mov    %edx,%eax
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5f                   	pop    %edi
  8017ad:	5d                   	pop    %ebp
  8017ae:	c3                   	ret    

008017af <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	57                   	push   %edi
  8017b3:	56                   	push   %esi
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017bd:	39 c6                	cmp    %eax,%esi
  8017bf:	73 35                	jae    8017f6 <memmove+0x47>
  8017c1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017c4:	39 d0                	cmp    %edx,%eax
  8017c6:	73 2e                	jae    8017f6 <memmove+0x47>
		s += n;
		d += n;
  8017c8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017cb:	89 d6                	mov    %edx,%esi
  8017cd:	09 fe                	or     %edi,%esi
  8017cf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8017d5:	75 13                	jne    8017ea <memmove+0x3b>
  8017d7:	f6 c1 03             	test   $0x3,%cl
  8017da:	75 0e                	jne    8017ea <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8017dc:	83 ef 04             	sub    $0x4,%edi
  8017df:	8d 72 fc             	lea    -0x4(%edx),%esi
  8017e2:	c1 e9 02             	shr    $0x2,%ecx
  8017e5:	fd                   	std    
  8017e6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8017e8:	eb 09                	jmp    8017f3 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017ea:	83 ef 01             	sub    $0x1,%edi
  8017ed:	8d 72 ff             	lea    -0x1(%edx),%esi
  8017f0:	fd                   	std    
  8017f1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017f3:	fc                   	cld    
  8017f4:	eb 1d                	jmp    801813 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8017f6:	89 f2                	mov    %esi,%edx
  8017f8:	09 c2                	or     %eax,%edx
  8017fa:	f6 c2 03             	test   $0x3,%dl
  8017fd:	75 0f                	jne    80180e <memmove+0x5f>
  8017ff:	f6 c1 03             	test   $0x3,%cl
  801802:	75 0a                	jne    80180e <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  801804:	c1 e9 02             	shr    $0x2,%ecx
  801807:	89 c7                	mov    %eax,%edi
  801809:	fc                   	cld    
  80180a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80180c:	eb 05                	jmp    801813 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80180e:	89 c7                	mov    %eax,%edi
  801810:	fc                   	cld    
  801811:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801813:	5e                   	pop    %esi
  801814:	5f                   	pop    %edi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80181a:	ff 75 10             	pushl  0x10(%ebp)
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	e8 87 ff ff ff       	call   8017af <memmove>
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	89 c6                	mov    %eax,%esi
  801837:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80183a:	eb 1a                	jmp    801856 <memcmp+0x2c>
		if (*s1 != *s2)
  80183c:	0f b6 08             	movzbl (%eax),%ecx
  80183f:	0f b6 1a             	movzbl (%edx),%ebx
  801842:	38 d9                	cmp    %bl,%cl
  801844:	74 0a                	je     801850 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801846:	0f b6 c1             	movzbl %cl,%eax
  801849:	0f b6 db             	movzbl %bl,%ebx
  80184c:	29 d8                	sub    %ebx,%eax
  80184e:	eb 0f                	jmp    80185f <memcmp+0x35>
		s1++, s2++;
  801850:	83 c0 01             	add    $0x1,%eax
  801853:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801856:	39 f0                	cmp    %esi,%eax
  801858:	75 e2                	jne    80183c <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5d                   	pop    %ebp
  801862:	c3                   	ret    

00801863 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	53                   	push   %ebx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80186a:	89 c1                	mov    %eax,%ecx
  80186c:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  80186f:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801873:	eb 0a                	jmp    80187f <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  801875:	0f b6 10             	movzbl (%eax),%edx
  801878:	39 da                	cmp    %ebx,%edx
  80187a:	74 07                	je     801883 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80187c:	83 c0 01             	add    $0x1,%eax
  80187f:	39 c8                	cmp    %ecx,%eax
  801881:	72 f2                	jb     801875 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801883:	5b                   	pop    %ebx
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	57                   	push   %edi
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80188f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801892:	eb 03                	jmp    801897 <strtol+0x11>
		s++;
  801894:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801897:	0f b6 01             	movzbl (%ecx),%eax
  80189a:	3c 20                	cmp    $0x20,%al
  80189c:	74 f6                	je     801894 <strtol+0xe>
  80189e:	3c 09                	cmp    $0x9,%al
  8018a0:	74 f2                	je     801894 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018a2:	3c 2b                	cmp    $0x2b,%al
  8018a4:	75 0a                	jne    8018b0 <strtol+0x2a>
		s++;
  8018a6:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ae:	eb 11                	jmp    8018c1 <strtol+0x3b>
  8018b0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018b5:	3c 2d                	cmp    $0x2d,%al
  8018b7:	75 08                	jne    8018c1 <strtol+0x3b>
		s++, neg = 1;
  8018b9:	83 c1 01             	add    $0x1,%ecx
  8018bc:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018c1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018c7:	75 15                	jne    8018de <strtol+0x58>
  8018c9:	80 39 30             	cmpb   $0x30,(%ecx)
  8018cc:	75 10                	jne    8018de <strtol+0x58>
  8018ce:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8018d2:	75 7c                	jne    801950 <strtol+0xca>
		s += 2, base = 16;
  8018d4:	83 c1 02             	add    $0x2,%ecx
  8018d7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8018dc:	eb 16                	jmp    8018f4 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8018de:	85 db                	test   %ebx,%ebx
  8018e0:	75 12                	jne    8018f4 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8018e2:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8018e7:	80 39 30             	cmpb   $0x30,(%ecx)
  8018ea:	75 08                	jne    8018f4 <strtol+0x6e>
		s++, base = 8;
  8018ec:	83 c1 01             	add    $0x1,%ecx
  8018ef:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018fc:	0f b6 11             	movzbl (%ecx),%edx
  8018ff:	8d 72 d0             	lea    -0x30(%edx),%esi
  801902:	89 f3                	mov    %esi,%ebx
  801904:	80 fb 09             	cmp    $0x9,%bl
  801907:	77 08                	ja     801911 <strtol+0x8b>
			dig = *s - '0';
  801909:	0f be d2             	movsbl %dl,%edx
  80190c:	83 ea 30             	sub    $0x30,%edx
  80190f:	eb 22                	jmp    801933 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  801911:	8d 72 9f             	lea    -0x61(%edx),%esi
  801914:	89 f3                	mov    %esi,%ebx
  801916:	80 fb 19             	cmp    $0x19,%bl
  801919:	77 08                	ja     801923 <strtol+0x9d>
			dig = *s - 'a' + 10;
  80191b:	0f be d2             	movsbl %dl,%edx
  80191e:	83 ea 57             	sub    $0x57,%edx
  801921:	eb 10                	jmp    801933 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  801923:	8d 72 bf             	lea    -0x41(%edx),%esi
  801926:	89 f3                	mov    %esi,%ebx
  801928:	80 fb 19             	cmp    $0x19,%bl
  80192b:	77 16                	ja     801943 <strtol+0xbd>
			dig = *s - 'A' + 10;
  80192d:	0f be d2             	movsbl %dl,%edx
  801930:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  801933:	3b 55 10             	cmp    0x10(%ebp),%edx
  801936:	7d 0b                	jge    801943 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  801938:	83 c1 01             	add    $0x1,%ecx
  80193b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80193f:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  801941:	eb b9                	jmp    8018fc <strtol+0x76>

	if (endptr)
  801943:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801947:	74 0d                	je     801956 <strtol+0xd0>
		*endptr = (char *) s;
  801949:	8b 75 0c             	mov    0xc(%ebp),%esi
  80194c:	89 0e                	mov    %ecx,(%esi)
  80194e:	eb 06                	jmp    801956 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801950:	85 db                	test   %ebx,%ebx
  801952:	74 98                	je     8018ec <strtol+0x66>
  801954:	eb 9e                	jmp    8018f4 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  801956:	89 c2                	mov    %eax,%edx
  801958:	f7 da                	neg    %edx
  80195a:	85 ff                	test   %edi,%edi
  80195c:	0f 45 c2             	cmovne %edx,%eax
}
  80195f:	5b                   	pop    %ebx
  801960:	5e                   	pop    %esi
  801961:	5f                   	pop    %edi
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    

00801964 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	56                   	push   %esi
  801968:	53                   	push   %ebx
  801969:	8b 75 08             	mov    0x8(%ebp),%esi
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801972:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801974:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801979:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80197c:	83 ec 0c             	sub    $0xc,%esp
  80197f:	50                   	push   %eax
  801980:	e8 1d e9 ff ff       	call   8002a2 <sys_ipc_recv>
	if (from_env_store)
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	85 f6                	test   %esi,%esi
  80198a:	74 0b                	je     801997 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  80198c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801992:	8b 52 74             	mov    0x74(%edx),%edx
  801995:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801997:	85 db                	test   %ebx,%ebx
  801999:	74 0b                	je     8019a6 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  80199b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019a1:	8b 52 78             	mov    0x78(%edx),%edx
  8019a4:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	79 16                	jns    8019c0 <ipc_recv+0x5c>
		if (from_env_store)
  8019aa:	85 f6                	test   %esi,%esi
  8019ac:	74 06                	je     8019b4 <ipc_recv+0x50>
			*from_env_store = 0;
  8019ae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  8019b4:	85 db                	test   %ebx,%ebx
  8019b6:	74 10                	je     8019c8 <ipc_recv+0x64>
			*perm_store = 0;
  8019b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8019be:	eb 08                	jmp    8019c8 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  8019c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8019c5:	8b 40 70             	mov    0x70(%eax),%eax
}
  8019c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5d                   	pop    %ebp
  8019ce:	c3                   	ret    

008019cf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	57                   	push   %edi
  8019d3:	56                   	push   %esi
  8019d4:	53                   	push   %ebx
  8019d5:	83 ec 0c             	sub    $0xc,%esp
  8019d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8019e1:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8019e3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8019e8:	0f 44 d8             	cmove  %eax,%ebx
  8019eb:	eb 1c                	jmp    801a09 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8019ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8019f0:	74 12                	je     801a04 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8019f2:	50                   	push   %eax
  8019f3:	68 80 21 80 00       	push   $0x802180
  8019f8:	6a 42                	push   $0x42
  8019fa:	68 96 21 80 00       	push   $0x802196
  8019ff:	e8 cd f5 ff ff       	call   800fd1 <_panic>
		sys_yield();
  801a04:	e8 77 e7 ff ff       	call   800180 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801a09:	ff 75 14             	pushl  0x14(%ebp)
  801a0c:	53                   	push   %ebx
  801a0d:	56                   	push   %esi
  801a0e:	57                   	push   %edi
  801a0f:	e8 69 e8 ff ff       	call   80027d <sys_ipc_try_send>
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	75 d2                	jne    8019ed <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801a1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a1e:	5b                   	pop    %ebx
  801a1f:	5e                   	pop    %esi
  801a20:	5f                   	pop    %edi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a2e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a31:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a37:	8b 52 50             	mov    0x50(%edx),%edx
  801a3a:	39 ca                	cmp    %ecx,%edx
  801a3c:	75 0d                	jne    801a4b <ipc_find_env+0x28>
			return envs[i].env_id;
  801a3e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a41:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a46:	8b 40 48             	mov    0x48(%eax),%eax
  801a49:	eb 0f                	jmp    801a5a <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801a4b:	83 c0 01             	add    $0x1,%eax
  801a4e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a53:	75 d9                	jne    801a2e <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801a55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    

00801a5c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a62:	89 d0                	mov    %edx,%eax
  801a64:	c1 e8 16             	shr    $0x16,%eax
  801a67:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a6e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a73:	f6 c1 01             	test   $0x1,%cl
  801a76:	74 1d                	je     801a95 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801a78:	c1 ea 0c             	shr    $0xc,%edx
  801a7b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a82:	f6 c2 01             	test   $0x1,%dl
  801a85:	74 0e                	je     801a95 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a87:	c1 ea 0c             	shr    $0xc,%edx
  801a8a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a91:	ef 
  801a92:	0f b7 c0             	movzwl %ax,%eax
}
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    
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
