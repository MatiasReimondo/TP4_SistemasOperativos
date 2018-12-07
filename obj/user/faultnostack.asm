
obj/user/faultnostack.debug:     formato del fichero elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 d6 02 80 00       	push   $0x8002d6
  80003e:	6a 00                	push   $0x0
  800040:	e8 27 02 00 00       	call   80026c <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  80005f:	e8 0a 01 00 00       	call   80016e <sys_getenvid>
	if (id >= 0)
  800064:	85 c0                	test   %eax,%eax
  800066:	78 12                	js     80007a <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  800068:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800070:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800075:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007a:	85 db                	test   %ebx,%ebx
  80007c:	7e 07                	jle    800085 <libmain+0x31>
		binaryname = argv[0];
  80007e:	8b 06                	mov    (%esi),%eax
  800080:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800085:	83 ec 08             	sub    $0x8,%esp
  800088:	56                   	push   %esi
  800089:	53                   	push   %ebx
  80008a:	e8 a4 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008f:	e8 0a 00 00 00       	call   80009e <exit>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009a:	5b                   	pop    %ebx
  80009b:	5e                   	pop    %esi
  80009c:	5d                   	pop    %ebp
  80009d:	c3                   	ret    

0080009e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a4:	e8 1c 04 00 00       	call   8004c5 <close_all>
	sys_env_destroy(0);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	6a 00                	push   $0x0
  8000ae:	e8 99 00 00 00       	call   80014c <sys_env_destroy>
}
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	c9                   	leave  
  8000b7:	c3                   	ret    

008000b8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
  8000be:	83 ec 1c             	sub    $0x1c,%esp
  8000c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8000c7:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  8000d2:	8b 75 14             	mov    0x14(%ebp),%esi
  8000d5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000db:	74 1d                	je     8000fa <syscall+0x42>
  8000dd:	85 c0                	test   %eax,%eax
  8000df:	7e 19                	jle    8000fa <syscall+0x42>
  8000e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	50                   	push   %eax
  8000e8:	52                   	push   %edx
  8000e9:	68 ea 1d 80 00       	push   $0x801dea
  8000ee:	6a 23                	push   $0x23
  8000f0:	68 07 1e 80 00       	push   $0x801e07
  8000f5:	e8 0d 0f 00 00       	call   801007 <_panic>

	return ret;
}
  8000fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fd:	5b                   	pop    %ebx
  8000fe:	5e                   	pop    %esi
  8000ff:	5f                   	pop    %edi
  800100:	5d                   	pop    %ebp
  800101:	c3                   	ret    

00800102 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800108:	6a 00                	push   $0x0
  80010a:	6a 00                	push   $0x0
  80010c:	6a 00                	push   $0x0
  80010e:	ff 75 0c             	pushl  0xc(%ebp)
  800111:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800114:	ba 00 00 00 00       	mov    $0x0,%edx
  800119:	b8 00 00 00 00       	mov    $0x0,%eax
  80011e:	e8 95 ff ff ff       	call   8000b8 <syscall>
}
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	c9                   	leave  
  800127:	c3                   	ret    

00800128 <sys_cgetc>:

int
sys_cgetc(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80012e:	6a 00                	push   $0x0
  800130:	6a 00                	push   $0x0
  800132:	6a 00                	push   $0x0
  800134:	6a 00                	push   $0x0
  800136:	b9 00 00 00 00       	mov    $0x0,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	b8 01 00 00 00       	mov    $0x1,%eax
  800145:	e8 6e ff ff ff       	call   8000b8 <syscall>
}
  80014a:	c9                   	leave  
  80014b:	c3                   	ret    

0080014c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800152:	6a 00                	push   $0x0
  800154:	6a 00                	push   $0x0
  800156:	6a 00                	push   $0x0
  800158:	6a 00                	push   $0x0
  80015a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015d:	ba 01 00 00 00       	mov    $0x1,%edx
  800162:	b8 03 00 00 00       	mov    $0x3,%eax
  800167:	e8 4c ff ff ff       	call   8000b8 <syscall>
}
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    

0080016e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800174:	6a 00                	push   $0x0
  800176:	6a 00                	push   $0x0
  800178:	6a 00                	push   $0x0
  80017a:	6a 00                	push   $0x0
  80017c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800181:	ba 00 00 00 00       	mov    $0x0,%edx
  800186:	b8 02 00 00 00       	mov    $0x2,%eax
  80018b:	e8 28 ff ff ff       	call   8000b8 <syscall>
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <sys_yield>:

void
sys_yield(void)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800198:	6a 00                	push   $0x0
  80019a:	6a 00                	push   $0x0
  80019c:	6a 00                	push   $0x0
  80019e:	6a 00                	push   $0x0
  8001a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001aa:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001af:	e8 04 ff ff ff       	call   8000b8 <syscall>
}
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8001bf:	6a 00                	push   $0x0
  8001c1:	6a 00                	push   $0x0
  8001c3:	ff 75 10             	pushl  0x10(%ebp)
  8001c6:	ff 75 0c             	pushl  0xc(%ebp)
  8001c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001cc:	ba 01 00 00 00       	mov    $0x1,%edx
  8001d1:	b8 04 00 00 00       	mov    $0x4,%eax
  8001d6:	e8 dd fe ff ff       	call   8000b8 <syscall>
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8001e3:	ff 75 18             	pushl  0x18(%ebp)
  8001e6:	ff 75 14             	pushl  0x14(%ebp)
  8001e9:	ff 75 10             	pushl  0x10(%ebp)
  8001ec:	ff 75 0c             	pushl  0xc(%ebp)
  8001ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f2:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001fc:	e8 b7 fe ff ff       	call   8000b8 <syscall>
}
  800201:	c9                   	leave  
  800202:	c3                   	ret    

00800203 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800209:	6a 00                	push   $0x0
  80020b:	6a 00                	push   $0x0
  80020d:	6a 00                	push   $0x0
  80020f:	ff 75 0c             	pushl  0xc(%ebp)
  800212:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800215:	ba 01 00 00 00       	mov    $0x1,%edx
  80021a:	b8 06 00 00 00       	mov    $0x6,%eax
  80021f:	e8 94 fe ff ff       	call   8000b8 <syscall>
}
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80022c:	6a 00                	push   $0x0
  80022e:	6a 00                	push   $0x0
  800230:	6a 00                	push   $0x0
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800238:	ba 01 00 00 00       	mov    $0x1,%edx
  80023d:	b8 08 00 00 00       	mov    $0x8,%eax
  800242:	e8 71 fe ff ff       	call   8000b8 <syscall>
}
  800247:	c9                   	leave  
  800248:	c3                   	ret    

00800249 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80024f:	6a 00                	push   $0x0
  800251:	6a 00                	push   $0x0
  800253:	6a 00                	push   $0x0
  800255:	ff 75 0c             	pushl  0xc(%ebp)
  800258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025b:	ba 01 00 00 00       	mov    $0x1,%edx
  800260:	b8 09 00 00 00       	mov    $0x9,%eax
  800265:	e8 4e fe ff ff       	call   8000b8 <syscall>
}
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800272:	6a 00                	push   $0x0
  800274:	6a 00                	push   $0x0
  800276:	6a 00                	push   $0x0
  800278:	ff 75 0c             	pushl  0xc(%ebp)
  80027b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80027e:	ba 01 00 00 00       	mov    $0x1,%edx
  800283:	b8 0a 00 00 00       	mov    $0xa,%eax
  800288:	e8 2b fe ff ff       	call   8000b8 <syscall>
}
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800295:	6a 00                	push   $0x0
  800297:	ff 75 14             	pushl  0x14(%ebp)
  80029a:	ff 75 10             	pushl  0x10(%ebp)
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ad:	e8 06 fe ff ff       	call   8000b8 <syscall>
}
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8002ba:	6a 00                	push   $0x0
  8002bc:	6a 00                	push   $0x0
  8002be:	6a 00                	push   $0x0
  8002c0:	6a 00                	push   $0x0
  8002c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c5:	ba 01 00 00 00       	mov    $0x1,%edx
  8002ca:	b8 0d 00 00 00       	mov    $0xd,%eax
  8002cf:	e8 e4 fd ff ff       	call   8000b8 <syscall>
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8002d6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8002d7:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8002dc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8002de:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  8002e1:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  8002e6:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  8002ea:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  8002ee:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  8002f0:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8002f3:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  8002f4:	83 c4 04             	add    $0x4,%esp
	popfl
  8002f7:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8002f8:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8002f9:	c3                   	ret    

008002fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	05 00 00 00 30       	add    $0x30000000,%eax
  800305:	c1 e8 0c             	shr    $0xc,%eax
}
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 e5 ff ff ff       	call   8002fa <fd2num>
  800315:	83 c4 04             	add    $0x4,%esp
  800318:	c1 e0 0c             	shl    $0xc,%eax
  80031b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800320:	c9                   	leave  
  800321:	c3                   	ret    

00800322 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800328:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80032d:	89 c2                	mov    %eax,%edx
  80032f:	c1 ea 16             	shr    $0x16,%edx
  800332:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800339:	f6 c2 01             	test   $0x1,%dl
  80033c:	74 11                	je     80034f <fd_alloc+0x2d>
  80033e:	89 c2                	mov    %eax,%edx
  800340:	c1 ea 0c             	shr    $0xc,%edx
  800343:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80034a:	f6 c2 01             	test   $0x1,%dl
  80034d:	75 09                	jne    800358 <fd_alloc+0x36>
			*fd_store = fd;
  80034f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800351:	b8 00 00 00 00       	mov    $0x0,%eax
  800356:	eb 17                	jmp    80036f <fd_alloc+0x4d>
  800358:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80035d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800362:	75 c9                	jne    80032d <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800364:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80036a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80036f:	5d                   	pop    %ebp
  800370:	c3                   	ret    

00800371 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800377:	83 f8 1f             	cmp    $0x1f,%eax
  80037a:	77 36                	ja     8003b2 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80037c:	c1 e0 0c             	shl    $0xc,%eax
  80037f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800384:	89 c2                	mov    %eax,%edx
  800386:	c1 ea 16             	shr    $0x16,%edx
  800389:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800390:	f6 c2 01             	test   $0x1,%dl
  800393:	74 24                	je     8003b9 <fd_lookup+0x48>
  800395:	89 c2                	mov    %eax,%edx
  800397:	c1 ea 0c             	shr    $0xc,%edx
  80039a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003a1:	f6 c2 01             	test   $0x1,%dl
  8003a4:	74 1a                	je     8003c0 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a9:	89 02                	mov    %eax,(%edx)
	return 0;
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	eb 13                	jmp    8003c5 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8003b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003b7:	eb 0c                	jmp    8003c5 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8003b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8003be:	eb 05                	jmp    8003c5 <fd_lookup+0x54>
  8003c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8003c5:	5d                   	pop    %ebp
  8003c6:	c3                   	ret    

008003c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8003c7:	55                   	push   %ebp
  8003c8:	89 e5                	mov    %esp,%ebp
  8003ca:	83 ec 08             	sub    $0x8,%esp
  8003cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d0:	ba 94 1e 80 00       	mov    $0x801e94,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8003d5:	eb 13                	jmp    8003ea <dev_lookup+0x23>
  8003d7:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8003da:	39 08                	cmp    %ecx,(%eax)
  8003dc:	75 0c                	jne    8003ea <dev_lookup+0x23>
			*dev = devtab[i];
  8003de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	eb 2e                	jmp    800418 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8003ea:	8b 02                	mov    (%edx),%eax
  8003ec:	85 c0                	test   %eax,%eax
  8003ee:	75 e7                	jne    8003d7 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8003f0:	a1 04 40 80 00       	mov    0x804004,%eax
  8003f5:	8b 40 48             	mov    0x48(%eax),%eax
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	51                   	push   %ecx
  8003fc:	50                   	push   %eax
  8003fd:	68 18 1e 80 00       	push   $0x801e18
  800402:	e8 d9 0c 00 00       	call   8010e0 <cprintf>
	*dev = 0;
  800407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800410:	83 c4 10             	add    $0x10,%esp
  800413:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	56                   	push   %esi
  80041e:	53                   	push   %ebx
  80041f:	83 ec 10             	sub    $0x10,%esp
  800422:	8b 75 08             	mov    0x8(%ebp),%esi
  800425:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800428:	56                   	push   %esi
  800429:	e8 cc fe ff ff       	call   8002fa <fd2num>
  80042e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800431:	89 14 24             	mov    %edx,(%esp)
  800434:	50                   	push   %eax
  800435:	e8 37 ff ff ff       	call   800371 <fd_lookup>
  80043a:	83 c4 08             	add    $0x8,%esp
  80043d:	85 c0                	test   %eax,%eax
  80043f:	78 05                	js     800446 <fd_close+0x2c>
	    || fd != fd2)
  800441:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800444:	74 0c                	je     800452 <fd_close+0x38>
		return (must_exist ? r : 0);
  800446:	84 db                	test   %bl,%bl
  800448:	ba 00 00 00 00       	mov    $0x0,%edx
  80044d:	0f 44 c2             	cmove  %edx,%eax
  800450:	eb 41                	jmp    800493 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800458:	50                   	push   %eax
  800459:	ff 36                	pushl  (%esi)
  80045b:	e8 67 ff ff ff       	call   8003c7 <dev_lookup>
  800460:	89 c3                	mov    %eax,%ebx
  800462:	83 c4 10             	add    $0x10,%esp
  800465:	85 c0                	test   %eax,%eax
  800467:	78 1a                	js     800483 <fd_close+0x69>
		if (dev->dev_close)
  800469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046c:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80046f:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800474:	85 c0                	test   %eax,%eax
  800476:	74 0b                	je     800483 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	56                   	push   %esi
  80047c:	ff d0                	call   *%eax
  80047e:	89 c3                	mov    %eax,%ebx
  800480:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	56                   	push   %esi
  800487:	6a 00                	push   $0x0
  800489:	e8 75 fd ff ff       	call   800203 <sys_page_unmap>
	return r;
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	89 d8                	mov    %ebx,%eax
}
  800493:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800496:	5b                   	pop    %ebx
  800497:	5e                   	pop    %esi
  800498:	5d                   	pop    %ebp
  800499:	c3                   	ret    

0080049a <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004a3:	50                   	push   %eax
  8004a4:	ff 75 08             	pushl  0x8(%ebp)
  8004a7:	e8 c5 fe ff ff       	call   800371 <fd_lookup>
  8004ac:	83 c4 08             	add    $0x8,%esp
  8004af:	85 c0                	test   %eax,%eax
  8004b1:	78 10                	js     8004c3 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	6a 01                	push   $0x1
  8004b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004bb:	e8 5a ff ff ff       	call   80041a <fd_close>
  8004c0:	83 c4 10             	add    $0x10,%esp
}
  8004c3:	c9                   	leave  
  8004c4:	c3                   	ret    

008004c5 <close_all>:

void
close_all(void)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	53                   	push   %ebx
  8004c9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8004cc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8004d1:	83 ec 0c             	sub    $0xc,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	e8 c0 ff ff ff       	call   80049a <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8004da:	83 c3 01             	add    $0x1,%ebx
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	83 fb 20             	cmp    $0x20,%ebx
  8004e3:	75 ec                	jne    8004d1 <close_all+0xc>
		close(i);
}
  8004e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	57                   	push   %edi
  8004ee:	56                   	push   %esi
  8004ef:	53                   	push   %ebx
  8004f0:	83 ec 2c             	sub    $0x2c,%esp
  8004f3:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8004f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004f9:	50                   	push   %eax
  8004fa:	ff 75 08             	pushl  0x8(%ebp)
  8004fd:	e8 6f fe ff ff       	call   800371 <fd_lookup>
  800502:	83 c4 08             	add    $0x8,%esp
  800505:	85 c0                	test   %eax,%eax
  800507:	0f 88 c1 00 00 00    	js     8005ce <dup+0xe4>
		return r;
	close(newfdnum);
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	56                   	push   %esi
  800511:	e8 84 ff ff ff       	call   80049a <close>

	newfd = INDEX2FD(newfdnum);
  800516:	89 f3                	mov    %esi,%ebx
  800518:	c1 e3 0c             	shl    $0xc,%ebx
  80051b:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800521:	83 c4 04             	add    $0x4,%esp
  800524:	ff 75 e4             	pushl  -0x1c(%ebp)
  800527:	e8 de fd ff ff       	call   80030a <fd2data>
  80052c:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  80052e:	89 1c 24             	mov    %ebx,(%esp)
  800531:	e8 d4 fd ff ff       	call   80030a <fd2data>
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80053c:	89 f8                	mov    %edi,%eax
  80053e:	c1 e8 16             	shr    $0x16,%eax
  800541:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800548:	a8 01                	test   $0x1,%al
  80054a:	74 37                	je     800583 <dup+0x99>
  80054c:	89 f8                	mov    %edi,%eax
  80054e:	c1 e8 0c             	shr    $0xc,%eax
  800551:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800558:	f6 c2 01             	test   $0x1,%dl
  80055b:	74 26                	je     800583 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80055d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	25 07 0e 00 00       	and    $0xe07,%eax
  80056c:	50                   	push   %eax
  80056d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800570:	6a 00                	push   $0x0
  800572:	57                   	push   %edi
  800573:	6a 00                	push   $0x0
  800575:	e8 63 fc ff ff       	call   8001dd <sys_page_map>
  80057a:	89 c7                	mov    %eax,%edi
  80057c:	83 c4 20             	add    $0x20,%esp
  80057f:	85 c0                	test   %eax,%eax
  800581:	78 2e                	js     8005b1 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800583:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800586:	89 d0                	mov    %edx,%eax
  800588:	c1 e8 0c             	shr    $0xc,%eax
  80058b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	25 07 0e 00 00       	and    $0xe07,%eax
  80059a:	50                   	push   %eax
  80059b:	53                   	push   %ebx
  80059c:	6a 00                	push   $0x0
  80059e:	52                   	push   %edx
  80059f:	6a 00                	push   $0x0
  8005a1:	e8 37 fc ff ff       	call   8001dd <sys_page_map>
  8005a6:	89 c7                	mov    %eax,%edi
  8005a8:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8005ab:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005ad:	85 ff                	test   %edi,%edi
  8005af:	79 1d                	jns    8005ce <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 00                	push   $0x0
  8005b7:	e8 47 fc ff ff       	call   800203 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8005bc:	83 c4 08             	add    $0x8,%esp
  8005bf:	ff 75 d4             	pushl  -0x2c(%ebp)
  8005c2:	6a 00                	push   $0x0
  8005c4:	e8 3a fc ff ff       	call   800203 <sys_page_unmap>
	return r;
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	89 f8                	mov    %edi,%eax
}
  8005ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d1:	5b                   	pop    %ebx
  8005d2:	5e                   	pop    %esi
  8005d3:	5f                   	pop    %edi
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    

008005d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	53                   	push   %ebx
  8005da:	83 ec 14             	sub    $0x14,%esp
  8005dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8005e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005e3:	50                   	push   %eax
  8005e4:	53                   	push   %ebx
  8005e5:	e8 87 fd ff ff       	call   800371 <fd_lookup>
  8005ea:	83 c4 08             	add    $0x8,%esp
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	85 c0                	test   %eax,%eax
  8005f1:	78 6d                	js     800660 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005f9:	50                   	push   %eax
  8005fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fd:	ff 30                	pushl  (%eax)
  8005ff:	e8 c3 fd ff ff       	call   8003c7 <dev_lookup>
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	85 c0                	test   %eax,%eax
  800609:	78 4c                	js     800657 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80060b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80060e:	8b 42 08             	mov    0x8(%edx),%eax
  800611:	83 e0 03             	and    $0x3,%eax
  800614:	83 f8 01             	cmp    $0x1,%eax
  800617:	75 21                	jne    80063a <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800619:	a1 04 40 80 00       	mov    0x804004,%eax
  80061e:	8b 40 48             	mov    0x48(%eax),%eax
  800621:	83 ec 04             	sub    $0x4,%esp
  800624:	53                   	push   %ebx
  800625:	50                   	push   %eax
  800626:	68 59 1e 80 00       	push   $0x801e59
  80062b:	e8 b0 0a 00 00       	call   8010e0 <cprintf>
		return -E_INVAL;
  800630:	83 c4 10             	add    $0x10,%esp
  800633:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800638:	eb 26                	jmp    800660 <read+0x8a>
	}
	if (!dev->dev_read)
  80063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063d:	8b 40 08             	mov    0x8(%eax),%eax
  800640:	85 c0                	test   %eax,%eax
  800642:	74 17                	je     80065b <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800644:	83 ec 04             	sub    $0x4,%esp
  800647:	ff 75 10             	pushl  0x10(%ebp)
  80064a:	ff 75 0c             	pushl  0xc(%ebp)
  80064d:	52                   	push   %edx
  80064e:	ff d0                	call   *%eax
  800650:	89 c2                	mov    %eax,%edx
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	eb 09                	jmp    800660 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800657:	89 c2                	mov    %eax,%edx
  800659:	eb 05                	jmp    800660 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80065b:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800660:	89 d0                	mov    %edx,%eax
  800662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	57                   	push   %edi
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	8b 7d 08             	mov    0x8(%ebp),%edi
  800673:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800676:	bb 00 00 00 00       	mov    $0x0,%ebx
  80067b:	eb 21                	jmp    80069e <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	89 f0                	mov    %esi,%eax
  800682:	29 d8                	sub    %ebx,%eax
  800684:	50                   	push   %eax
  800685:	89 d8                	mov    %ebx,%eax
  800687:	03 45 0c             	add    0xc(%ebp),%eax
  80068a:	50                   	push   %eax
  80068b:	57                   	push   %edi
  80068c:	e8 45 ff ff ff       	call   8005d6 <read>
		if (m < 0)
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	85 c0                	test   %eax,%eax
  800696:	78 10                	js     8006a8 <readn+0x41>
			return m;
		if (m == 0)
  800698:	85 c0                	test   %eax,%eax
  80069a:	74 0a                	je     8006a6 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80069c:	01 c3                	add    %eax,%ebx
  80069e:	39 f3                	cmp    %esi,%ebx
  8006a0:	72 db                	jb     80067d <readn+0x16>
  8006a2:	89 d8                	mov    %ebx,%eax
  8006a4:	eb 02                	jmp    8006a8 <readn+0x41>
  8006a6:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8006a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ab:	5b                   	pop    %ebx
  8006ac:	5e                   	pop    %esi
  8006ad:	5f                   	pop    %edi
  8006ae:	5d                   	pop    %ebp
  8006af:	c3                   	ret    

008006b0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	53                   	push   %ebx
  8006b4:	83 ec 14             	sub    $0x14,%esp
  8006b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006bd:	50                   	push   %eax
  8006be:	53                   	push   %ebx
  8006bf:	e8 ad fc ff ff       	call   800371 <fd_lookup>
  8006c4:	83 c4 08             	add    $0x8,%esp
  8006c7:	89 c2                	mov    %eax,%edx
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	78 68                	js     800735 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006d3:	50                   	push   %eax
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	ff 30                	pushl  (%eax)
  8006d9:	e8 e9 fc ff ff       	call   8003c7 <dev_lookup>
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	78 47                	js     80072c <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8006e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8006ec:	75 21                	jne    80070f <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8006ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8006f3:	8b 40 48             	mov    0x48(%eax),%eax
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	50                   	push   %eax
  8006fb:	68 75 1e 80 00       	push   $0x801e75
  800700:	e8 db 09 00 00       	call   8010e0 <cprintf>
		return -E_INVAL;
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80070d:	eb 26                	jmp    800735 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80070f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800712:	8b 52 0c             	mov    0xc(%edx),%edx
  800715:	85 d2                	test   %edx,%edx
  800717:	74 17                	je     800730 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800719:	83 ec 04             	sub    $0x4,%esp
  80071c:	ff 75 10             	pushl  0x10(%ebp)
  80071f:	ff 75 0c             	pushl  0xc(%ebp)
  800722:	50                   	push   %eax
  800723:	ff d2                	call   *%edx
  800725:	89 c2                	mov    %eax,%edx
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb 09                	jmp    800735 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80072c:	89 c2                	mov    %eax,%edx
  80072e:	eb 05                	jmp    800735 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800730:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  800735:	89 d0                	mov    %edx,%eax
  800737:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <seek>:

int
seek(int fdnum, off_t offset)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800742:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800745:	50                   	push   %eax
  800746:	ff 75 08             	pushl  0x8(%ebp)
  800749:	e8 23 fc ff ff       	call   800371 <fd_lookup>
  80074e:	83 c4 08             	add    $0x8,%esp
  800751:	85 c0                	test   %eax,%eax
  800753:	78 0e                	js     800763 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800755:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80075b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	53                   	push   %ebx
  800769:	83 ec 14             	sub    $0x14,%esp
  80076c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80076f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800772:	50                   	push   %eax
  800773:	53                   	push   %ebx
  800774:	e8 f8 fb ff ff       	call   800371 <fd_lookup>
  800779:	83 c4 08             	add    $0x8,%esp
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	85 c0                	test   %eax,%eax
  800780:	78 65                	js     8007e7 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800788:	50                   	push   %eax
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	ff 30                	pushl  (%eax)
  80078e:	e8 34 fc ff ff       	call   8003c7 <dev_lookup>
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	85 c0                	test   %eax,%eax
  800798:	78 44                	js     8007de <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80079a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007a1:	75 21                	jne    8007c4 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8007a3:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8007a8:	8b 40 48             	mov    0x48(%eax),%eax
  8007ab:	83 ec 04             	sub    $0x4,%esp
  8007ae:	53                   	push   %ebx
  8007af:	50                   	push   %eax
  8007b0:	68 38 1e 80 00       	push   $0x801e38
  8007b5:	e8 26 09 00 00       	call   8010e0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8007c2:	eb 23                	jmp    8007e7 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8007c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c7:	8b 52 18             	mov    0x18(%edx),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	74 14                	je     8007e2 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	ff d2                	call   *%edx
  8007d7:	89 c2                	mov    %eax,%edx
  8007d9:	83 c4 10             	add    $0x10,%esp
  8007dc:	eb 09                	jmp    8007e7 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	eb 05                	jmp    8007e7 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8007e2:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  8007e7:	89 d0                	mov    %edx,%eax
  8007e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	53                   	push   %ebx
  8007f2:	83 ec 14             	sub    $0x14,%esp
  8007f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007fb:	50                   	push   %eax
  8007fc:	ff 75 08             	pushl  0x8(%ebp)
  8007ff:	e8 6d fb ff ff       	call   800371 <fd_lookup>
  800804:	83 c4 08             	add    $0x8,%esp
  800807:	89 c2                	mov    %eax,%edx
  800809:	85 c0                	test   %eax,%eax
  80080b:	78 58                	js     800865 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800813:	50                   	push   %eax
  800814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800817:	ff 30                	pushl  (%eax)
  800819:	e8 a9 fb ff ff       	call   8003c7 <dev_lookup>
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	85 c0                	test   %eax,%eax
  800823:	78 37                	js     80085c <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  800825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800828:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80082c:	74 32                	je     800860 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80082e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800831:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800838:	00 00 00 
	stat->st_isdir = 0;
  80083b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800842:	00 00 00 
	stat->st_dev = dev;
  800845:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	53                   	push   %ebx
  80084f:	ff 75 f0             	pushl  -0x10(%ebp)
  800852:	ff 50 14             	call   *0x14(%eax)
  800855:	89 c2                	mov    %eax,%edx
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	eb 09                	jmp    800865 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085c:	89 c2                	mov    %eax,%edx
  80085e:	eb 05                	jmp    800865 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800860:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800865:	89 d0                	mov    %edx,%eax
  800867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086a:	c9                   	leave  
  80086b:	c3                   	ret    

0080086c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	56                   	push   %esi
  800870:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	6a 00                	push   $0x0
  800876:	ff 75 08             	pushl  0x8(%ebp)
  800879:	e8 06 02 00 00       	call   800a84 <open>
  80087e:	89 c3                	mov    %eax,%ebx
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	85 c0                	test   %eax,%eax
  800885:	78 1b                	js     8008a2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	50                   	push   %eax
  80088e:	e8 5b ff ff ff       	call   8007ee <fstat>
  800893:	89 c6                	mov    %eax,%esi
	close(fd);
  800895:	89 1c 24             	mov    %ebx,(%esp)
  800898:	e8 fd fb ff ff       	call   80049a <close>
	return r;
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	89 f0                	mov    %esi,%eax
}
  8008a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	56                   	push   %esi
  8008ad:	53                   	push   %ebx
  8008ae:	89 c6                	mov    %eax,%esi
  8008b0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008b2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008b9:	75 12                	jne    8008cd <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8008bb:	83 ec 0c             	sub    $0xc,%esp
  8008be:	6a 01                	push   $0x1
  8008c0:	e8 03 12 00 00       	call   801ac8 <ipc_find_env>
  8008c5:	a3 00 40 80 00       	mov    %eax,0x804000
  8008ca:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008cd:	6a 07                	push   $0x7
  8008cf:	68 00 50 80 00       	push   $0x805000
  8008d4:	56                   	push   %esi
  8008d5:	ff 35 00 40 80 00    	pushl  0x804000
  8008db:	e8 94 11 00 00       	call   801a74 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008e0:	83 c4 0c             	add    $0xc,%esp
  8008e3:	6a 00                	push   $0x0
  8008e5:	53                   	push   %ebx
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 1c 11 00 00       	call   801a09 <ipc_recv>
}
  8008ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 40 0c             	mov    0xc(%eax),%eax
  800900:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800905:	8b 45 0c             	mov    0xc(%ebp),%eax
  800908:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80090d:	ba 00 00 00 00       	mov    $0x0,%edx
  800912:	b8 02 00 00 00       	mov    $0x2,%eax
  800917:	e8 8d ff ff ff       	call   8008a9 <fsipc>
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 40 0c             	mov    0xc(%eax),%eax
  80092a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80092f:	ba 00 00 00 00       	mov    $0x0,%edx
  800934:	b8 06 00 00 00       	mov    $0x6,%eax
  800939:	e8 6b ff ff ff       	call   8008a9 <fsipc>
}
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    

00800940 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	53                   	push   %ebx
  800944:	83 ec 04             	sub    $0x4,%esp
  800947:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 40 0c             	mov    0xc(%eax),%eax
  800950:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800955:	ba 00 00 00 00       	mov    $0x0,%edx
  80095a:	b8 05 00 00 00       	mov    $0x5,%eax
  80095f:	e8 45 ff ff ff       	call   8008a9 <fsipc>
  800964:	85 c0                	test   %eax,%eax
  800966:	78 2c                	js     800994 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	68 00 50 80 00       	push   $0x805000
  800970:	53                   	push   %ebx
  800971:	e8 dc 0c 00 00       	call   801652 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800976:	a1 80 50 80 00       	mov    0x805080,%eax
  80097b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800981:	a1 84 50 80 00       	mov    0x805084,%eax
  800986:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a8:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8009ab:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8009b1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009b6:	76 22                	jbe    8009da <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8009b8:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8009bf:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8009c2:	83 ec 04             	sub    $0x4,%esp
  8009c5:	68 f8 0f 00 00       	push   $0xff8
  8009ca:	52                   	push   %edx
  8009cb:	68 08 50 80 00       	push   $0x805008
  8009d0:	e8 10 0e 00 00       	call   8017e5 <memmove>
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	eb 17                	jmp    8009f1 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  8009da:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  8009df:	83 ec 04             	sub    $0x4,%esp
  8009e2:	50                   	push   %eax
  8009e3:	52                   	push   %edx
  8009e4:	68 08 50 80 00       	push   $0x805008
  8009e9:	e8 f7 0d 00 00       	call   8017e5 <memmove>
  8009ee:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  8009f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8009fb:	e8 a9 fe ff ff       	call   8008a9 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  800a10:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a15:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a20:	b8 03 00 00 00       	mov    $0x3,%eax
  800a25:	e8 7f fe ff ff       	call   8008a9 <fsipc>
  800a2a:	89 c3                	mov    %eax,%ebx
  800a2c:	85 c0                	test   %eax,%eax
  800a2e:	78 4b                	js     800a7b <devfile_read+0x79>
		return r;
	assert(r <= n);
  800a30:	39 c6                	cmp    %eax,%esi
  800a32:	73 16                	jae    800a4a <devfile_read+0x48>
  800a34:	68 a4 1e 80 00       	push   $0x801ea4
  800a39:	68 ab 1e 80 00       	push   $0x801eab
  800a3e:	6a 7c                	push   $0x7c
  800a40:	68 c0 1e 80 00       	push   $0x801ec0
  800a45:	e8 bd 05 00 00       	call   801007 <_panic>
	assert(r <= PGSIZE);
  800a4a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a4f:	7e 16                	jle    800a67 <devfile_read+0x65>
  800a51:	68 cb 1e 80 00       	push   $0x801ecb
  800a56:	68 ab 1e 80 00       	push   $0x801eab
  800a5b:	6a 7d                	push   $0x7d
  800a5d:	68 c0 1e 80 00       	push   $0x801ec0
  800a62:	e8 a0 05 00 00       	call   801007 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	50                   	push   %eax
  800a6b:	68 00 50 80 00       	push   $0x805000
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	e8 6d 0d 00 00       	call   8017e5 <memmove>
	return r;
  800a78:	83 c4 10             	add    $0x10,%esp
}
  800a7b:	89 d8                	mov    %ebx,%eax
  800a7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	53                   	push   %ebx
  800a88:	83 ec 20             	sub    $0x20,%esp
  800a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800a8e:	53                   	push   %ebx
  800a8f:	e8 85 0b 00 00       	call   801619 <strlen>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800a9c:	7f 67                	jg     800b05 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800a9e:	83 ec 0c             	sub    $0xc,%esp
  800aa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800aa4:	50                   	push   %eax
  800aa5:	e8 78 f8 ff ff       	call   800322 <fd_alloc>
  800aaa:	83 c4 10             	add    $0x10,%esp
		return r;
  800aad:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800aaf:	85 c0                	test   %eax,%eax
  800ab1:	78 57                	js     800b0a <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	53                   	push   %ebx
  800ab7:	68 00 50 80 00       	push   $0x805000
  800abc:	e8 91 0b 00 00       	call   801652 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac4:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800acc:	b8 01 00 00 00       	mov    $0x1,%eax
  800ad1:	e8 d3 fd ff ff       	call   8008a9 <fsipc>
  800ad6:	89 c3                	mov    %eax,%ebx
  800ad8:	83 c4 10             	add    $0x10,%esp
  800adb:	85 c0                	test   %eax,%eax
  800add:	79 14                	jns    800af3 <open+0x6f>
		fd_close(fd, 0);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	6a 00                	push   $0x0
  800ae4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae7:	e8 2e f9 ff ff       	call   80041a <fd_close>
		return r;
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	89 da                	mov    %ebx,%edx
  800af1:	eb 17                	jmp    800b0a <open+0x86>
	}

	return fd2num(fd);
  800af3:	83 ec 0c             	sub    $0xc,%esp
  800af6:	ff 75 f4             	pushl  -0xc(%ebp)
  800af9:	e8 fc f7 ff ff       	call   8002fa <fd2num>
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	eb 05                	jmp    800b0a <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800b05:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800b0a:	89 d0                	mov    %edx,%eax
  800b0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b17:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1c:	b8 08 00 00 00       	mov    $0x8,%eax
  800b21:	e8 83 fd ff ff       	call   8008a9 <fsipc>
}
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b30:	83 ec 0c             	sub    $0xc,%esp
  800b33:	ff 75 08             	pushl  0x8(%ebp)
  800b36:	e8 cf f7 ff ff       	call   80030a <fd2data>
  800b3b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b3d:	83 c4 08             	add    $0x8,%esp
  800b40:	68 d7 1e 80 00       	push   $0x801ed7
  800b45:	53                   	push   %ebx
  800b46:	e8 07 0b 00 00       	call   801652 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b4b:	8b 46 04             	mov    0x4(%esi),%eax
  800b4e:	2b 06                	sub    (%esi),%eax
  800b50:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b5d:	00 00 00 
	stat->st_dev = &devpipe;
  800b60:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b67:	30 80 00 
	return 0;
}
  800b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	53                   	push   %ebx
  800b7a:	83 ec 0c             	sub    $0xc,%esp
  800b7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b80:	53                   	push   %ebx
  800b81:	6a 00                	push   $0x0
  800b83:	e8 7b f6 ff ff       	call   800203 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b88:	89 1c 24             	mov    %ebx,(%esp)
  800b8b:	e8 7a f7 ff ff       	call   80030a <fd2data>
  800b90:	83 c4 08             	add    $0x8,%esp
  800b93:	50                   	push   %eax
  800b94:	6a 00                	push   $0x0
  800b96:	e8 68 f6 ff ff       	call   800203 <sys_page_unmap>
}
  800b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
  800ba6:	83 ec 1c             	sub    $0x1c,%esp
  800ba9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bac:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800bae:	a1 04 40 80 00       	mov    0x804004,%eax
  800bb3:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800bb6:	83 ec 0c             	sub    $0xc,%esp
  800bb9:	ff 75 e0             	pushl  -0x20(%ebp)
  800bbc:	e8 40 0f 00 00       	call   801b01 <pageref>
  800bc1:	89 c3                	mov    %eax,%ebx
  800bc3:	89 3c 24             	mov    %edi,(%esp)
  800bc6:	e8 36 0f 00 00       	call   801b01 <pageref>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	39 c3                	cmp    %eax,%ebx
  800bd0:	0f 94 c1             	sete   %cl
  800bd3:	0f b6 c9             	movzbl %cl,%ecx
  800bd6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800bd9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800bdf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800be2:	39 ce                	cmp    %ecx,%esi
  800be4:	74 1b                	je     800c01 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800be6:	39 c3                	cmp    %eax,%ebx
  800be8:	75 c4                	jne    800bae <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bea:	8b 42 58             	mov    0x58(%edx),%eax
  800bed:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	56                   	push   %esi
  800bf2:	68 de 1e 80 00       	push   $0x801ede
  800bf7:	e8 e4 04 00 00       	call   8010e0 <cprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	eb ad                	jmp    800bae <_pipeisclosed+0xe>
	}
}
  800c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	83 ec 28             	sub    $0x28,%esp
  800c15:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800c18:	56                   	push   %esi
  800c19:	e8 ec f6 ff ff       	call   80030a <fd2data>
  800c1e:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c20:	83 c4 10             	add    $0x10,%esp
  800c23:	bf 00 00 00 00       	mov    $0x0,%edi
  800c28:	eb 4b                	jmp    800c75 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800c2a:	89 da                	mov    %ebx,%edx
  800c2c:	89 f0                	mov    %esi,%eax
  800c2e:	e8 6d ff ff ff       	call   800ba0 <_pipeisclosed>
  800c33:	85 c0                	test   %eax,%eax
  800c35:	75 48                	jne    800c7f <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800c37:	e8 56 f5 ff ff       	call   800192 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c3c:	8b 43 04             	mov    0x4(%ebx),%eax
  800c3f:	8b 0b                	mov    (%ebx),%ecx
  800c41:	8d 51 20             	lea    0x20(%ecx),%edx
  800c44:	39 d0                	cmp    %edx,%eax
  800c46:	73 e2                	jae    800c2a <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c4f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c52:	89 c2                	mov    %eax,%edx
  800c54:	c1 fa 1f             	sar    $0x1f,%edx
  800c57:	89 d1                	mov    %edx,%ecx
  800c59:	c1 e9 1b             	shr    $0x1b,%ecx
  800c5c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c5f:	83 e2 1f             	and    $0x1f,%edx
  800c62:	29 ca                	sub    %ecx,%edx
  800c64:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c68:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c6c:	83 c0 01             	add    $0x1,%eax
  800c6f:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800c72:	83 c7 01             	add    $0x1,%edi
  800c75:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c78:	75 c2                	jne    800c3c <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7d:	eb 05                	jmp    800c84 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800c7f:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 18             	sub    $0x18,%esp
  800c95:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800c98:	57                   	push   %edi
  800c99:	e8 6c f6 ff ff       	call   80030a <fd2data>
  800c9e:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ca0:	83 c4 10             	add    $0x10,%esp
  800ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca8:	eb 3d                	jmp    800ce7 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800caa:	85 db                	test   %ebx,%ebx
  800cac:	74 04                	je     800cb2 <devpipe_read+0x26>
				return i;
  800cae:	89 d8                	mov    %ebx,%eax
  800cb0:	eb 44                	jmp    800cf6 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800cb2:	89 f2                	mov    %esi,%edx
  800cb4:	89 f8                	mov    %edi,%eax
  800cb6:	e8 e5 fe ff ff       	call   800ba0 <_pipeisclosed>
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	75 32                	jne    800cf1 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800cbf:	e8 ce f4 ff ff       	call   800192 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800cc4:	8b 06                	mov    (%esi),%eax
  800cc6:	3b 46 04             	cmp    0x4(%esi),%eax
  800cc9:	74 df                	je     800caa <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ccb:	99                   	cltd   
  800ccc:	c1 ea 1b             	shr    $0x1b,%edx
  800ccf:	01 d0                	add    %edx,%eax
  800cd1:	83 e0 1f             	and    $0x1f,%eax
  800cd4:	29 d0                	sub    %edx,%eax
  800cd6:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  800cdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cde:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800ce1:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ce4:	83 c3 01             	add    $0x1,%ebx
  800ce7:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800cea:	75 d8                	jne    800cc4 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800cec:	8b 45 10             	mov    0x10(%ebp),%eax
  800cef:	eb 05                	jmp    800cf6 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d09:	50                   	push   %eax
  800d0a:	e8 13 f6 ff ff       	call   800322 <fd_alloc>
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	89 c2                	mov    %eax,%edx
  800d14:	85 c0                	test   %eax,%eax
  800d16:	0f 88 2c 01 00 00    	js     800e48 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d1c:	83 ec 04             	sub    $0x4,%esp
  800d1f:	68 07 04 00 00       	push   $0x407
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	6a 00                	push   $0x0
  800d29:	e8 8b f4 ff ff       	call   8001b9 <sys_page_alloc>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	89 c2                	mov    %eax,%edx
  800d33:	85 c0                	test   %eax,%eax
  800d35:	0f 88 0d 01 00 00    	js     800e48 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800d3b:	83 ec 0c             	sub    $0xc,%esp
  800d3e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d41:	50                   	push   %eax
  800d42:	e8 db f5 ff ff       	call   800322 <fd_alloc>
  800d47:	89 c3                	mov    %eax,%ebx
  800d49:	83 c4 10             	add    $0x10,%esp
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	0f 88 e2 00 00 00    	js     800e36 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d54:	83 ec 04             	sub    $0x4,%esp
  800d57:	68 07 04 00 00       	push   $0x407
  800d5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800d5f:	6a 00                	push   $0x0
  800d61:	e8 53 f4 ff ff       	call   8001b9 <sys_page_alloc>
  800d66:	89 c3                	mov    %eax,%ebx
  800d68:	83 c4 10             	add    $0x10,%esp
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	0f 88 c3 00 00 00    	js     800e36 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	ff 75 f4             	pushl  -0xc(%ebp)
  800d79:	e8 8c f5 ff ff       	call   80030a <fd2data>
  800d7e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d80:	83 c4 0c             	add    $0xc,%esp
  800d83:	68 07 04 00 00       	push   $0x407
  800d88:	50                   	push   %eax
  800d89:	6a 00                	push   $0x0
  800d8b:	e8 29 f4 ff ff       	call   8001b9 <sys_page_alloc>
  800d90:	89 c3                	mov    %eax,%ebx
  800d92:	83 c4 10             	add    $0x10,%esp
  800d95:	85 c0                	test   %eax,%eax
  800d97:	0f 88 89 00 00 00    	js     800e26 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d9d:	83 ec 0c             	sub    $0xc,%esp
  800da0:	ff 75 f0             	pushl  -0x10(%ebp)
  800da3:	e8 62 f5 ff ff       	call   80030a <fd2data>
  800da8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800daf:	50                   	push   %eax
  800db0:	6a 00                	push   $0x0
  800db2:	56                   	push   %esi
  800db3:	6a 00                	push   $0x0
  800db5:	e8 23 f4 ff ff       	call   8001dd <sys_page_map>
  800dba:	89 c3                	mov    %eax,%ebx
  800dbc:	83 c4 20             	add    $0x20,%esp
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	78 55                	js     800e18 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800dc3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dcc:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800dd8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	ff 75 f4             	pushl  -0xc(%ebp)
  800df3:	e8 02 f5 ff ff       	call   8002fa <fd2num>
  800df8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800dfd:	83 c4 04             	add    $0x4,%esp
  800e00:	ff 75 f0             	pushl  -0x10(%ebp)
  800e03:	e8 f2 f4 ff ff       	call   8002fa <fd2num>
  800e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	eb 30                	jmp    800e48 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  800e18:	83 ec 08             	sub    $0x8,%esp
  800e1b:	56                   	push   %esi
  800e1c:	6a 00                	push   $0x0
  800e1e:	e8 e0 f3 ff ff       	call   800203 <sys_page_unmap>
  800e23:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 f0             	pushl  -0x10(%ebp)
  800e2c:	6a 00                	push   $0x0
  800e2e:	e8 d0 f3 ff ff       	call   800203 <sys_page_unmap>
  800e33:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  800e36:	83 ec 08             	sub    $0x8,%esp
  800e39:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3c:	6a 00                	push   $0x0
  800e3e:	e8 c0 f3 ff ff       	call   800203 <sys_page_unmap>
  800e43:	83 c4 10             	add    $0x10,%esp
  800e46:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  800e48:	89 d0                	mov    %edx,%eax
  800e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    

00800e51 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e5a:	50                   	push   %eax
  800e5b:	ff 75 08             	pushl  0x8(%ebp)
  800e5e:	e8 0e f5 ff ff       	call   800371 <fd_lookup>
  800e63:	83 c4 10             	add    $0x10,%esp
  800e66:	85 c0                	test   %eax,%eax
  800e68:	78 18                	js     800e82 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e70:	e8 95 f4 ff ff       	call   80030a <fd2data>
	return _pipeisclosed(fd, p);
  800e75:	89 c2                	mov    %eax,%edx
  800e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7a:	e8 21 fd ff ff       	call   800ba0 <_pipeisclosed>
  800e7f:	83 c4 10             	add    $0x10,%esp
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    

00800e8e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e94:	68 f6 1e 80 00       	push   $0x801ef6
  800e99:	ff 75 0c             	pushl  0xc(%ebp)
  800e9c:	e8 b1 07 00 00       	call   801652 <strcpy>
	return 0;
}
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
  800eae:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800eb4:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800eb9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800ebf:	eb 2d                	jmp    800eee <devcons_write+0x46>
		m = n - tot;
  800ec1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec4:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800ec6:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800ec9:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800ece:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800ed1:	83 ec 04             	sub    $0x4,%esp
  800ed4:	53                   	push   %ebx
  800ed5:	03 45 0c             	add    0xc(%ebp),%eax
  800ed8:	50                   	push   %eax
  800ed9:	57                   	push   %edi
  800eda:	e8 06 09 00 00       	call   8017e5 <memmove>
		sys_cputs(buf, m);
  800edf:	83 c4 08             	add    $0x8,%esp
  800ee2:	53                   	push   %ebx
  800ee3:	57                   	push   %edi
  800ee4:	e8 19 f2 ff ff       	call   800102 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800ee9:	01 de                	add    %ebx,%esi
  800eeb:	83 c4 10             	add    $0x10,%esp
  800eee:	89 f0                	mov    %esi,%eax
  800ef0:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ef3:	72 cc                	jb     800ec1 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 08             	sub    $0x8,%esp
  800f03:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  800f08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0c:	74 2a                	je     800f38 <devcons_read+0x3b>
  800f0e:	eb 05                	jmp    800f15 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800f10:	e8 7d f2 ff ff       	call   800192 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800f15:	e8 0e f2 ff ff       	call   800128 <sys_cgetc>
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	74 f2                	je     800f10 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800f1e:	85 c0                	test   %eax,%eax
  800f20:	78 16                	js     800f38 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800f22:	83 f8 04             	cmp    $0x4,%eax
  800f25:	74 0c                	je     800f33 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2a:	88 02                	mov    %al,(%edx)
	return 1;
  800f2c:	b8 01 00 00 00       	mov    $0x1,%eax
  800f31:	eb 05                	jmp    800f38 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800f33:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800f46:	6a 01                	push   $0x1
  800f48:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f4b:	50                   	push   %eax
  800f4c:	e8 b1 f1 ff ff       	call   800102 <sys_cputs>
}
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <getchar>:

int
getchar(void)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800f5c:	6a 01                	push   $0x1
  800f5e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f61:	50                   	push   %eax
  800f62:	6a 00                	push   $0x0
  800f64:	e8 6d f6 ff ff       	call   8005d6 <read>
	if (r < 0)
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	78 0f                	js     800f7f <getchar+0x29>
		return r;
	if (r < 1)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	7e 06                	jle    800f7a <getchar+0x24>
		return -E_EOF;
	return c;
  800f74:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800f78:	eb 05                	jmp    800f7f <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800f7a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 08             	pushl  0x8(%ebp)
  800f8e:	e8 de f3 ff ff       	call   800371 <fd_lookup>
  800f93:	83 c4 10             	add    $0x10,%esp
  800f96:	85 c0                	test   %eax,%eax
  800f98:	78 11                	js     800fab <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fa3:	39 10                	cmp    %edx,(%eax)
  800fa5:	0f 94 c0             	sete   %al
  800fa8:	0f b6 c0             	movzbl %al,%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <opencons>:

int
opencons(void)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800fb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb6:	50                   	push   %eax
  800fb7:	e8 66 f3 ff ff       	call   800322 <fd_alloc>
  800fbc:	83 c4 10             	add    $0x10,%esp
		return r;
  800fbf:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	78 3e                	js     801003 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	68 07 04 00 00       	push   $0x407
  800fcd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd0:	6a 00                	push   $0x0
  800fd2:	e8 e2 f1 ff ff       	call   8001b9 <sys_page_alloc>
  800fd7:	83 c4 10             	add    $0x10,%esp
		return r;
  800fda:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	78 23                	js     801003 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800fe0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	e8 fc f2 ff ff       	call   8002fa <fd2num>
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	83 c4 10             	add    $0x10,%esp
}
  801003:	89 d0                	mov    %edx,%eax
  801005:	c9                   	leave  
  801006:	c3                   	ret    

00801007 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	56                   	push   %esi
  80100b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80100c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80100f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801015:	e8 54 f1 ff ff       	call   80016e <sys_getenvid>
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	ff 75 0c             	pushl  0xc(%ebp)
  801020:	ff 75 08             	pushl  0x8(%ebp)
  801023:	56                   	push   %esi
  801024:	50                   	push   %eax
  801025:	68 04 1f 80 00       	push   $0x801f04
  80102a:	e8 b1 00 00 00       	call   8010e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80102f:	83 c4 18             	add    $0x18,%esp
  801032:	53                   	push   %ebx
  801033:	ff 75 10             	pushl  0x10(%ebp)
  801036:	e8 54 00 00 00       	call   80108f <vcprintf>
	cprintf("\n");
  80103b:	c7 04 24 ef 1e 80 00 	movl   $0x801eef,(%esp)
  801042:	e8 99 00 00 00       	call   8010e0 <cprintf>
  801047:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80104a:	cc                   	int3   
  80104b:	eb fd                	jmp    80104a <_panic+0x43>

0080104d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	53                   	push   %ebx
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801057:	8b 13                	mov    (%ebx),%edx
  801059:	8d 42 01             	lea    0x1(%edx),%eax
  80105c:	89 03                	mov    %eax,(%ebx)
  80105e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801061:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801065:	3d ff 00 00 00       	cmp    $0xff,%eax
  80106a:	75 1a                	jne    801086 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	68 ff 00 00 00       	push   $0xff
  801074:	8d 43 08             	lea    0x8(%ebx),%eax
  801077:	50                   	push   %eax
  801078:	e8 85 f0 ff ff       	call   800102 <sys_cputs>
		b->idx = 0;
  80107d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801083:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801086:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80108a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801098:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80109f:	00 00 00 
	b.cnt = 0;
  8010a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8010a9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8010ac:	ff 75 0c             	pushl  0xc(%ebp)
  8010af:	ff 75 08             	pushl  0x8(%ebp)
  8010b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8010b8:	50                   	push   %eax
  8010b9:	68 4d 10 80 00       	push   $0x80104d
  8010be:	e8 86 01 00 00       	call   801249 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8010c3:	83 c4 08             	add    $0x8,%esp
  8010c6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8010cc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	e8 2a f0 ff ff       	call   800102 <sys_cputs>

	return b.cnt;
}
  8010d8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010e6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010e9:	50                   	push   %eax
  8010ea:	ff 75 08             	pushl  0x8(%ebp)
  8010ed:	e8 9d ff ff ff       	call   80108f <vcprintf>
	va_end(ap);

	return cnt;
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	57                   	push   %edi
  8010f8:	56                   	push   %esi
  8010f9:	53                   	push   %ebx
  8010fa:	83 ec 1c             	sub    $0x1c,%esp
  8010fd:	89 c7                	mov    %eax,%edi
  8010ff:	89 d6                	mov    %edx,%esi
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8b 55 0c             	mov    0xc(%ebp),%edx
  801107:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80110a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80110d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801110:	bb 00 00 00 00       	mov    $0x0,%ebx
  801115:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801118:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80111b:	39 d3                	cmp    %edx,%ebx
  80111d:	72 05                	jb     801124 <printnum+0x30>
  80111f:	39 45 10             	cmp    %eax,0x10(%ebp)
  801122:	77 45                	ja     801169 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801124:	83 ec 0c             	sub    $0xc,%esp
  801127:	ff 75 18             	pushl  0x18(%ebp)
  80112a:	8b 45 14             	mov    0x14(%ebp),%eax
  80112d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801130:	53                   	push   %ebx
  801131:	ff 75 10             	pushl  0x10(%ebp)
  801134:	83 ec 08             	sub    $0x8,%esp
  801137:	ff 75 e4             	pushl  -0x1c(%ebp)
  80113a:	ff 75 e0             	pushl  -0x20(%ebp)
  80113d:	ff 75 dc             	pushl  -0x24(%ebp)
  801140:	ff 75 d8             	pushl  -0x28(%ebp)
  801143:	e8 f8 09 00 00       	call   801b40 <__udivdi3>
  801148:	83 c4 18             	add    $0x18,%esp
  80114b:	52                   	push   %edx
  80114c:	50                   	push   %eax
  80114d:	89 f2                	mov    %esi,%edx
  80114f:	89 f8                	mov    %edi,%eax
  801151:	e8 9e ff ff ff       	call   8010f4 <printnum>
  801156:	83 c4 20             	add    $0x20,%esp
  801159:	eb 18                	jmp    801173 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80115b:	83 ec 08             	sub    $0x8,%esp
  80115e:	56                   	push   %esi
  80115f:	ff 75 18             	pushl  0x18(%ebp)
  801162:	ff d7                	call   *%edi
  801164:	83 c4 10             	add    $0x10,%esp
  801167:	eb 03                	jmp    80116c <printnum+0x78>
  801169:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80116c:	83 eb 01             	sub    $0x1,%ebx
  80116f:	85 db                	test   %ebx,%ebx
  801171:	7f e8                	jg     80115b <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801173:	83 ec 08             	sub    $0x8,%esp
  801176:	56                   	push   %esi
  801177:	83 ec 04             	sub    $0x4,%esp
  80117a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117d:	ff 75 e0             	pushl  -0x20(%ebp)
  801180:	ff 75 dc             	pushl  -0x24(%ebp)
  801183:	ff 75 d8             	pushl  -0x28(%ebp)
  801186:	e8 e5 0a 00 00       	call   801c70 <__umoddi3>
  80118b:	83 c4 14             	add    $0x14,%esp
  80118e:	0f be 80 27 1f 80 00 	movsbl 0x801f27(%eax),%eax
  801195:	50                   	push   %eax
  801196:	ff d7                	call   *%edi
}
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119e:	5b                   	pop    %ebx
  80119f:	5e                   	pop    %esi
  8011a0:	5f                   	pop    %edi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011a6:	83 fa 01             	cmp    $0x1,%edx
  8011a9:	7e 0e                	jle    8011b9 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8011ab:	8b 10                	mov    (%eax),%edx
  8011ad:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011b0:	89 08                	mov    %ecx,(%eax)
  8011b2:	8b 02                	mov    (%edx),%eax
  8011b4:	8b 52 04             	mov    0x4(%edx),%edx
  8011b7:	eb 22                	jmp    8011db <getuint+0x38>
	else if (lflag)
  8011b9:	85 d2                	test   %edx,%edx
  8011bb:	74 10                	je     8011cd <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8011bd:	8b 10                	mov    (%eax),%edx
  8011bf:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011c2:	89 08                	mov    %ecx,(%eax)
  8011c4:	8b 02                	mov    (%edx),%eax
  8011c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cb:	eb 0e                	jmp    8011db <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8011cd:	8b 10                	mov    (%eax),%edx
  8011cf:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011d2:	89 08                	mov    %ecx,(%eax)
  8011d4:	8b 02                	mov    (%edx),%eax
  8011d6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011e0:	83 fa 01             	cmp    $0x1,%edx
  8011e3:	7e 0e                	jle    8011f3 <getint+0x16>
		return va_arg(*ap, long long);
  8011e5:	8b 10                	mov    (%eax),%edx
  8011e7:	8d 4a 08             	lea    0x8(%edx),%ecx
  8011ea:	89 08                	mov    %ecx,(%eax)
  8011ec:	8b 02                	mov    (%edx),%eax
  8011ee:	8b 52 04             	mov    0x4(%edx),%edx
  8011f1:	eb 1a                	jmp    80120d <getint+0x30>
	else if (lflag)
  8011f3:	85 d2                	test   %edx,%edx
  8011f5:	74 0c                	je     801203 <getint+0x26>
		return va_arg(*ap, long);
  8011f7:	8b 10                	mov    (%eax),%edx
  8011f9:	8d 4a 04             	lea    0x4(%edx),%ecx
  8011fc:	89 08                	mov    %ecx,(%eax)
  8011fe:	8b 02                	mov    (%edx),%eax
  801200:	99                   	cltd   
  801201:	eb 0a                	jmp    80120d <getint+0x30>
	else
		return va_arg(*ap, int);
  801203:	8b 10                	mov    (%eax),%edx
  801205:	8d 4a 04             	lea    0x4(%edx),%ecx
  801208:	89 08                	mov    %ecx,(%eax)
  80120a:	8b 02                	mov    (%edx),%eax
  80120c:	99                   	cltd   
}
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    

0080120f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801215:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801219:	8b 10                	mov    (%eax),%edx
  80121b:	3b 50 04             	cmp    0x4(%eax),%edx
  80121e:	73 0a                	jae    80122a <sprintputch+0x1b>
		*b->buf++ = ch;
  801220:	8d 4a 01             	lea    0x1(%edx),%ecx
  801223:	89 08                	mov    %ecx,(%eax)
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	88 02                	mov    %al,(%edx)
}
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  801232:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801235:	50                   	push   %eax
  801236:	ff 75 10             	pushl  0x10(%ebp)
  801239:	ff 75 0c             	pushl  0xc(%ebp)
  80123c:	ff 75 08             	pushl  0x8(%ebp)
  80123f:	e8 05 00 00 00       	call   801249 <vprintfmt>
	va_end(ap);
}
  801244:	83 c4 10             	add    $0x10,%esp
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	57                   	push   %edi
  80124d:	56                   	push   %esi
  80124e:	53                   	push   %ebx
  80124f:	83 ec 2c             	sub    $0x2c,%esp
  801252:	8b 75 08             	mov    0x8(%ebp),%esi
  801255:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801258:	8b 7d 10             	mov    0x10(%ebp),%edi
  80125b:	eb 12                	jmp    80126f <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80125d:	85 c0                	test   %eax,%eax
  80125f:	0f 84 44 03 00 00    	je     8015a9 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  801265:	83 ec 08             	sub    $0x8,%esp
  801268:	53                   	push   %ebx
  801269:	50                   	push   %eax
  80126a:	ff d6                	call   *%esi
  80126c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80126f:	83 c7 01             	add    $0x1,%edi
  801272:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801276:	83 f8 25             	cmp    $0x25,%eax
  801279:	75 e2                	jne    80125d <vprintfmt+0x14>
  80127b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80127f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801286:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80128d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801294:	ba 00 00 00 00       	mov    $0x0,%edx
  801299:	eb 07                	jmp    8012a2 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80129b:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  80129e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012a2:	8d 47 01             	lea    0x1(%edi),%eax
  8012a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012a8:	0f b6 07             	movzbl (%edi),%eax
  8012ab:	0f b6 c8             	movzbl %al,%ecx
  8012ae:	83 e8 23             	sub    $0x23,%eax
  8012b1:	3c 55                	cmp    $0x55,%al
  8012b3:	0f 87 d5 02 00 00    	ja     80158e <vprintfmt+0x345>
  8012b9:	0f b6 c0             	movzbl %al,%eax
  8012bc:	ff 24 85 60 20 80 00 	jmp    *0x802060(,%eax,4)
  8012c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012c6:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8012ca:	eb d6                	jmp    8012a2 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8012d7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8012da:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8012de:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8012e1:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8012e4:	83 fa 09             	cmp    $0x9,%edx
  8012e7:	77 39                	ja     801322 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012e9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012ec:	eb e9                	jmp    8012d7 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8d 48 04             	lea    0x4(%eax),%ecx
  8012f4:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8012ff:	eb 27                	jmp    801328 <vprintfmt+0xdf>
  801301:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801304:	85 c0                	test   %eax,%eax
  801306:	b9 00 00 00 00       	mov    $0x0,%ecx
  80130b:	0f 49 c8             	cmovns %eax,%ecx
  80130e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801311:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801314:	eb 8c                	jmp    8012a2 <vprintfmt+0x59>
  801316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801319:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801320:	eb 80                	jmp    8012a2 <vprintfmt+0x59>
  801322:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801325:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  801328:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80132c:	0f 89 70 ff ff ff    	jns    8012a2 <vprintfmt+0x59>
				width = precision, precision = -1;
  801332:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801335:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801338:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80133f:	e9 5e ff ff ff       	jmp    8012a2 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801344:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801347:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80134a:	e9 53 ff ff ff       	jmp    8012a2 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80134f:	8b 45 14             	mov    0x14(%ebp),%eax
  801352:	8d 50 04             	lea    0x4(%eax),%edx
  801355:	89 55 14             	mov    %edx,0x14(%ebp)
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	53                   	push   %ebx
  80135c:	ff 30                	pushl  (%eax)
  80135e:	ff d6                	call   *%esi
			break;
  801360:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801363:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801366:	e9 04 ff ff ff       	jmp    80126f <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	8d 50 04             	lea    0x4(%eax),%edx
  801371:	89 55 14             	mov    %edx,0x14(%ebp)
  801374:	8b 00                	mov    (%eax),%eax
  801376:	99                   	cltd   
  801377:	31 d0                	xor    %edx,%eax
  801379:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80137b:	83 f8 0f             	cmp    $0xf,%eax
  80137e:	7f 0b                	jg     80138b <vprintfmt+0x142>
  801380:	8b 14 85 c0 21 80 00 	mov    0x8021c0(,%eax,4),%edx
  801387:	85 d2                	test   %edx,%edx
  801389:	75 18                	jne    8013a3 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  80138b:	50                   	push   %eax
  80138c:	68 3f 1f 80 00       	push   $0x801f3f
  801391:	53                   	push   %ebx
  801392:	56                   	push   %esi
  801393:	e8 94 fe ff ff       	call   80122c <printfmt>
  801398:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80139b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  80139e:	e9 cc fe ff ff       	jmp    80126f <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8013a3:	52                   	push   %edx
  8013a4:	68 bd 1e 80 00       	push   $0x801ebd
  8013a9:	53                   	push   %ebx
  8013aa:	56                   	push   %esi
  8013ab:	e8 7c fe ff ff       	call   80122c <printfmt>
  8013b0:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013b6:	e9 b4 fe ff ff       	jmp    80126f <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8013bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013be:	8d 50 04             	lea    0x4(%eax),%edx
  8013c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8013c4:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8013c6:	85 ff                	test   %edi,%edi
  8013c8:	b8 38 1f 80 00       	mov    $0x801f38,%eax
  8013cd:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8013d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d4:	0f 8e 94 00 00 00    	jle    80146e <vprintfmt+0x225>
  8013da:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8013de:	0f 84 98 00 00 00    	je     80147c <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8013e4:	83 ec 08             	sub    $0x8,%esp
  8013e7:	ff 75 d0             	pushl  -0x30(%ebp)
  8013ea:	57                   	push   %edi
  8013eb:	e8 41 02 00 00       	call   801631 <strnlen>
  8013f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8013f3:	29 c1                	sub    %eax,%ecx
  8013f5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8013f8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8013fb:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8013ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801402:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801405:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801407:	eb 0f                	jmp    801418 <vprintfmt+0x1cf>
					putch(padc, putdat);
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	53                   	push   %ebx
  80140d:	ff 75 e0             	pushl  -0x20(%ebp)
  801410:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801412:	83 ef 01             	sub    $0x1,%edi
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	85 ff                	test   %edi,%edi
  80141a:	7f ed                	jg     801409 <vprintfmt+0x1c0>
  80141c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80141f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801422:	85 c9                	test   %ecx,%ecx
  801424:	b8 00 00 00 00       	mov    $0x0,%eax
  801429:	0f 49 c1             	cmovns %ecx,%eax
  80142c:	29 c1                	sub    %eax,%ecx
  80142e:	89 75 08             	mov    %esi,0x8(%ebp)
  801431:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801434:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801437:	89 cb                	mov    %ecx,%ebx
  801439:	eb 4d                	jmp    801488 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80143b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80143f:	74 1b                	je     80145c <vprintfmt+0x213>
  801441:	0f be c0             	movsbl %al,%eax
  801444:	83 e8 20             	sub    $0x20,%eax
  801447:	83 f8 5e             	cmp    $0x5e,%eax
  80144a:	76 10                	jbe    80145c <vprintfmt+0x213>
					putch('?', putdat);
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	6a 3f                	push   $0x3f
  801454:	ff 55 08             	call   *0x8(%ebp)
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	eb 0d                	jmp    801469 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	ff 75 0c             	pushl  0xc(%ebp)
  801462:	52                   	push   %edx
  801463:	ff 55 08             	call   *0x8(%ebp)
  801466:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801469:	83 eb 01             	sub    $0x1,%ebx
  80146c:	eb 1a                	jmp    801488 <vprintfmt+0x23f>
  80146e:	89 75 08             	mov    %esi,0x8(%ebp)
  801471:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801474:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801477:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80147a:	eb 0c                	jmp    801488 <vprintfmt+0x23f>
  80147c:	89 75 08             	mov    %esi,0x8(%ebp)
  80147f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801482:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801485:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801488:	83 c7 01             	add    $0x1,%edi
  80148b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80148f:	0f be d0             	movsbl %al,%edx
  801492:	85 d2                	test   %edx,%edx
  801494:	74 23                	je     8014b9 <vprintfmt+0x270>
  801496:	85 f6                	test   %esi,%esi
  801498:	78 a1                	js     80143b <vprintfmt+0x1f2>
  80149a:	83 ee 01             	sub    $0x1,%esi
  80149d:	79 9c                	jns    80143b <vprintfmt+0x1f2>
  80149f:	89 df                	mov    %ebx,%edi
  8014a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8014a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014a7:	eb 18                	jmp    8014c1 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8014a9:	83 ec 08             	sub    $0x8,%esp
  8014ac:	53                   	push   %ebx
  8014ad:	6a 20                	push   $0x20
  8014af:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b1:	83 ef 01             	sub    $0x1,%edi
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	eb 08                	jmp    8014c1 <vprintfmt+0x278>
  8014b9:	89 df                	mov    %ebx,%edi
  8014bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8014be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014c1:	85 ff                	test   %edi,%edi
  8014c3:	7f e4                	jg     8014a9 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8014c8:	e9 a2 fd ff ff       	jmp    80126f <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014d0:	e8 08 fd ff ff       	call   8011dd <getint>
  8014d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8014e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8014e4:	79 74                	jns    80155a <vprintfmt+0x311>
				putch('-', putdat);
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	53                   	push   %ebx
  8014ea:	6a 2d                	push   $0x2d
  8014ec:	ff d6                	call   *%esi
				num = -(long long) num;
  8014ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014f4:	f7 d8                	neg    %eax
  8014f6:	83 d2 00             	adc    $0x0,%edx
  8014f9:	f7 da                	neg    %edx
  8014fb:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8014fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801503:	eb 55                	jmp    80155a <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801505:	8d 45 14             	lea    0x14(%ebp),%eax
  801508:	e8 96 fc ff ff       	call   8011a3 <getuint>
			base = 10;
  80150d:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801512:	eb 46                	jmp    80155a <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801514:	8d 45 14             	lea    0x14(%ebp),%eax
  801517:	e8 87 fc ff ff       	call   8011a3 <getuint>
			base = 8;
  80151c:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801521:	eb 37                	jmp    80155a <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	53                   	push   %ebx
  801527:	6a 30                	push   $0x30
  801529:	ff d6                	call   *%esi
			putch('x', putdat);
  80152b:	83 c4 08             	add    $0x8,%esp
  80152e:	53                   	push   %ebx
  80152f:	6a 78                	push   $0x78
  801531:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801533:	8b 45 14             	mov    0x14(%ebp),%eax
  801536:	8d 50 04             	lea    0x4(%eax),%edx
  801539:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801543:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801546:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80154b:	eb 0d                	jmp    80155a <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80154d:	8d 45 14             	lea    0x14(%ebp),%eax
  801550:	e8 4e fc ff ff       	call   8011a3 <getuint>
			base = 16;
  801555:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801561:	57                   	push   %edi
  801562:	ff 75 e0             	pushl  -0x20(%ebp)
  801565:	51                   	push   %ecx
  801566:	52                   	push   %edx
  801567:	50                   	push   %eax
  801568:	89 da                	mov    %ebx,%edx
  80156a:	89 f0                	mov    %esi,%eax
  80156c:	e8 83 fb ff ff       	call   8010f4 <printnum>
			break;
  801571:	83 c4 20             	add    $0x20,%esp
  801574:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801577:	e9 f3 fc ff ff       	jmp    80126f <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80157c:	83 ec 08             	sub    $0x8,%esp
  80157f:	53                   	push   %ebx
  801580:	51                   	push   %ecx
  801581:	ff d6                	call   *%esi
			break;
  801583:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801586:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801589:	e9 e1 fc ff ff       	jmp    80126f <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	53                   	push   %ebx
  801592:	6a 25                	push   $0x25
  801594:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	eb 03                	jmp    80159e <vprintfmt+0x355>
  80159b:	83 ef 01             	sub    $0x1,%edi
  80159e:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8015a2:	75 f7                	jne    80159b <vprintfmt+0x352>
  8015a4:	e9 c6 fc ff ff       	jmp    80126f <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8015a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ac:	5b                   	pop    %ebx
  8015ad:	5e                   	pop    %esi
  8015ae:	5f                   	pop    %edi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    

008015b1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 18             	sub    $0x18,%esp
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015c0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8015c4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8015c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	74 26                	je     8015f8 <vsnprintf+0x47>
  8015d2:	85 d2                	test   %edx,%edx
  8015d4:	7e 22                	jle    8015f8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8015d6:	ff 75 14             	pushl  0x14(%ebp)
  8015d9:	ff 75 10             	pushl  0x10(%ebp)
  8015dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015df:	50                   	push   %eax
  8015e0:	68 0f 12 80 00       	push   $0x80120f
  8015e5:	e8 5f fc ff ff       	call   801249 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8015ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ed:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	eb 05                	jmp    8015fd <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8015f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801605:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801608:	50                   	push   %eax
  801609:	ff 75 10             	pushl  0x10(%ebp)
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	ff 75 08             	pushl  0x8(%ebp)
  801612:	e8 9a ff ff ff       	call   8015b1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80161f:	b8 00 00 00 00       	mov    $0x0,%eax
  801624:	eb 03                	jmp    801629 <strlen+0x10>
		n++;
  801626:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801629:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80162d:	75 f7                	jne    801626 <strlen+0xd>
		n++;
	return n;
}
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	eb 03                	jmp    801644 <strnlen+0x13>
		n++;
  801641:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801644:	39 c2                	cmp    %eax,%edx
  801646:	74 08                	je     801650 <strnlen+0x1f>
  801648:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80164c:	75 f3                	jne    801641 <strnlen+0x10>
  80164e:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    

00801652 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	53                   	push   %ebx
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	83 c2 01             	add    $0x1,%edx
  801661:	83 c1 01             	add    $0x1,%ecx
  801664:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801668:	88 5a ff             	mov    %bl,-0x1(%edx)
  80166b:	84 db                	test   %bl,%bl
  80166d:	75 ef                	jne    80165e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80166f:	5b                   	pop    %ebx
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	53                   	push   %ebx
  801676:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801679:	53                   	push   %ebx
  80167a:	e8 9a ff ff ff       	call   801619 <strlen>
  80167f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	01 d8                	add    %ebx,%eax
  801687:	50                   	push   %eax
  801688:	e8 c5 ff ff ff       	call   801652 <strcpy>
	return dst;
}
  80168d:	89 d8                	mov    %ebx,%eax
  80168f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
  801699:	8b 75 08             	mov    0x8(%ebp),%esi
  80169c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80169f:	89 f3                	mov    %esi,%ebx
  8016a1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8016a4:	89 f2                	mov    %esi,%edx
  8016a6:	eb 0f                	jmp    8016b7 <strncpy+0x23>
		*dst++ = *src;
  8016a8:	83 c2 01             	add    $0x1,%edx
  8016ab:	0f b6 01             	movzbl (%ecx),%eax
  8016ae:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8016b1:	80 39 01             	cmpb   $0x1,(%ecx)
  8016b4:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8016b7:	39 da                	cmp    %ebx,%edx
  8016b9:	75 ed                	jne    8016a8 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8016bb:	89 f0                	mov    %esi,%eax
  8016bd:	5b                   	pop    %ebx
  8016be:	5e                   	pop    %esi
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    

008016c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8016c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8016cf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8016d1:	85 d2                	test   %edx,%edx
  8016d3:	74 21                	je     8016f6 <strlcpy+0x35>
  8016d5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8016d9:	89 f2                	mov    %esi,%edx
  8016db:	eb 09                	jmp    8016e6 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8016dd:	83 c2 01             	add    $0x1,%edx
  8016e0:	83 c1 01             	add    $0x1,%ecx
  8016e3:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016e6:	39 c2                	cmp    %eax,%edx
  8016e8:	74 09                	je     8016f3 <strlcpy+0x32>
  8016ea:	0f b6 19             	movzbl (%ecx),%ebx
  8016ed:	84 db                	test   %bl,%bl
  8016ef:	75 ec                	jne    8016dd <strlcpy+0x1c>
  8016f1:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8016f3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016f6:	29 f0                	sub    %esi,%eax
}
  8016f8:	5b                   	pop    %ebx
  8016f9:	5e                   	pop    %esi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    

008016fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801702:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801705:	eb 06                	jmp    80170d <strcmp+0x11>
		p++, q++;
  801707:	83 c1 01             	add    $0x1,%ecx
  80170a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80170d:	0f b6 01             	movzbl (%ecx),%eax
  801710:	84 c0                	test   %al,%al
  801712:	74 04                	je     801718 <strcmp+0x1c>
  801714:	3a 02                	cmp    (%edx),%al
  801716:	74 ef                	je     801707 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	0f b6 12             	movzbl (%edx),%edx
  80171e:	29 d0                	sub    %edx,%eax
}
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	53                   	push   %ebx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801731:	eb 06                	jmp    801739 <strncmp+0x17>
		n--, p++, q++;
  801733:	83 c0 01             	add    $0x1,%eax
  801736:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801739:	39 d8                	cmp    %ebx,%eax
  80173b:	74 15                	je     801752 <strncmp+0x30>
  80173d:	0f b6 08             	movzbl (%eax),%ecx
  801740:	84 c9                	test   %cl,%cl
  801742:	74 04                	je     801748 <strncmp+0x26>
  801744:	3a 0a                	cmp    (%edx),%cl
  801746:	74 eb                	je     801733 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801748:	0f b6 00             	movzbl (%eax),%eax
  80174b:	0f b6 12             	movzbl (%edx),%edx
  80174e:	29 d0                	sub    %edx,%eax
  801750:	eb 05                	jmp    801757 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801757:	5b                   	pop    %ebx
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801764:	eb 07                	jmp    80176d <strchr+0x13>
		if (*s == c)
  801766:	38 ca                	cmp    %cl,%dl
  801768:	74 0f                	je     801779 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176a:	83 c0 01             	add    $0x1,%eax
  80176d:	0f b6 10             	movzbl (%eax),%edx
  801770:	84 d2                	test   %dl,%dl
  801772:	75 f2                	jne    801766 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    

0080177b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801785:	eb 03                	jmp    80178a <strfind+0xf>
  801787:	83 c0 01             	add    $0x1,%eax
  80178a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80178d:	38 ca                	cmp    %cl,%dl
  80178f:	74 04                	je     801795 <strfind+0x1a>
  801791:	84 d2                	test   %dl,%dl
  801793:	75 f2                	jne    801787 <strfind+0xc>
			break;
	return (char *) s;
}
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	57                   	push   %edi
  80179b:	56                   	push   %esi
  80179c:	53                   	push   %ebx
  80179d:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8017a3:	85 c9                	test   %ecx,%ecx
  8017a5:	74 37                	je     8017de <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8017a7:	f6 c2 03             	test   $0x3,%dl
  8017aa:	75 2a                	jne    8017d6 <memset+0x3f>
  8017ac:	f6 c1 03             	test   $0x3,%cl
  8017af:	75 25                	jne    8017d6 <memset+0x3f>
		c &= 0xFF;
  8017b1:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8017b5:	89 df                	mov    %ebx,%edi
  8017b7:	c1 e7 08             	shl    $0x8,%edi
  8017ba:	89 de                	mov    %ebx,%esi
  8017bc:	c1 e6 18             	shl    $0x18,%esi
  8017bf:	89 d8                	mov    %ebx,%eax
  8017c1:	c1 e0 10             	shl    $0x10,%eax
  8017c4:	09 f0                	or     %esi,%eax
  8017c6:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8017c8:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017cb:	89 f8                	mov    %edi,%eax
  8017cd:	09 d8                	or     %ebx,%eax
  8017cf:	89 d7                	mov    %edx,%edi
  8017d1:	fc                   	cld    
  8017d2:	f3 ab                	rep stos %eax,%es:(%edi)
  8017d4:	eb 08                	jmp    8017de <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017d6:	89 d7                	mov    %edx,%edi
  8017d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017db:	fc                   	cld    
  8017dc:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8017de:	89 d0                	mov    %edx,%eax
  8017e0:	5b                   	pop    %ebx
  8017e1:	5e                   	pop    %esi
  8017e2:	5f                   	pop    %edi
  8017e3:	5d                   	pop    %ebp
  8017e4:	c3                   	ret    

008017e5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	57                   	push   %edi
  8017e9:	56                   	push   %esi
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8017f3:	39 c6                	cmp    %eax,%esi
  8017f5:	73 35                	jae    80182c <memmove+0x47>
  8017f7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8017fa:	39 d0                	cmp    %edx,%eax
  8017fc:	73 2e                	jae    80182c <memmove+0x47>
		s += n;
		d += n;
  8017fe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801801:	89 d6                	mov    %edx,%esi
  801803:	09 fe                	or     %edi,%esi
  801805:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80180b:	75 13                	jne    801820 <memmove+0x3b>
  80180d:	f6 c1 03             	test   $0x3,%cl
  801810:	75 0e                	jne    801820 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  801812:	83 ef 04             	sub    $0x4,%edi
  801815:	8d 72 fc             	lea    -0x4(%edx),%esi
  801818:	c1 e9 02             	shr    $0x2,%ecx
  80181b:	fd                   	std    
  80181c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80181e:	eb 09                	jmp    801829 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801820:	83 ef 01             	sub    $0x1,%edi
  801823:	8d 72 ff             	lea    -0x1(%edx),%esi
  801826:	fd                   	std    
  801827:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801829:	fc                   	cld    
  80182a:	eb 1d                	jmp    801849 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80182c:	89 f2                	mov    %esi,%edx
  80182e:	09 c2                	or     %eax,%edx
  801830:	f6 c2 03             	test   $0x3,%dl
  801833:	75 0f                	jne    801844 <memmove+0x5f>
  801835:	f6 c1 03             	test   $0x3,%cl
  801838:	75 0a                	jne    801844 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  80183a:	c1 e9 02             	shr    $0x2,%ecx
  80183d:	89 c7                	mov    %eax,%edi
  80183f:	fc                   	cld    
  801840:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801842:	eb 05                	jmp    801849 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801844:	89 c7                	mov    %eax,%edi
  801846:	fc                   	cld    
  801847:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801849:	5e                   	pop    %esi
  80184a:	5f                   	pop    %edi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    

0080184d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801850:	ff 75 10             	pushl  0x10(%ebp)
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	e8 87 ff ff ff       	call   8017e5 <memmove>
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186b:	89 c6                	mov    %eax,%esi
  80186d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801870:	eb 1a                	jmp    80188c <memcmp+0x2c>
		if (*s1 != *s2)
  801872:	0f b6 08             	movzbl (%eax),%ecx
  801875:	0f b6 1a             	movzbl (%edx),%ebx
  801878:	38 d9                	cmp    %bl,%cl
  80187a:	74 0a                	je     801886 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  80187c:	0f b6 c1             	movzbl %cl,%eax
  80187f:	0f b6 db             	movzbl %bl,%ebx
  801882:	29 d8                	sub    %ebx,%eax
  801884:	eb 0f                	jmp    801895 <memcmp+0x35>
		s1++, s2++;
  801886:	83 c0 01             	add    $0x1,%eax
  801889:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80188c:	39 f0                	cmp    %esi,%eax
  80188e:	75 e2                	jne    801872 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	53                   	push   %ebx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8018a0:	89 c1                	mov    %eax,%ecx
  8018a2:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8018a5:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018a9:	eb 0a                	jmp    8018b5 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018ab:	0f b6 10             	movzbl (%eax),%edx
  8018ae:	39 da                	cmp    %ebx,%edx
  8018b0:	74 07                	je     8018b9 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018b2:	83 c0 01             	add    $0x1,%eax
  8018b5:	39 c8                	cmp    %ecx,%eax
  8018b7:	72 f2                	jb     8018ab <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8018b9:	5b                   	pop    %ebx
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	57                   	push   %edi
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018c8:	eb 03                	jmp    8018cd <strtol+0x11>
		s++;
  8018ca:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018cd:	0f b6 01             	movzbl (%ecx),%eax
  8018d0:	3c 20                	cmp    $0x20,%al
  8018d2:	74 f6                	je     8018ca <strtol+0xe>
  8018d4:	3c 09                	cmp    $0x9,%al
  8018d6:	74 f2                	je     8018ca <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018d8:	3c 2b                	cmp    $0x2b,%al
  8018da:	75 0a                	jne    8018e6 <strtol+0x2a>
		s++;
  8018dc:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8018df:	bf 00 00 00 00       	mov    $0x0,%edi
  8018e4:	eb 11                	jmp    8018f7 <strtol+0x3b>
  8018e6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8018eb:	3c 2d                	cmp    $0x2d,%al
  8018ed:	75 08                	jne    8018f7 <strtol+0x3b>
		s++, neg = 1;
  8018ef:	83 c1 01             	add    $0x1,%ecx
  8018f2:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018f7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8018fd:	75 15                	jne    801914 <strtol+0x58>
  8018ff:	80 39 30             	cmpb   $0x30,(%ecx)
  801902:	75 10                	jne    801914 <strtol+0x58>
  801904:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801908:	75 7c                	jne    801986 <strtol+0xca>
		s += 2, base = 16;
  80190a:	83 c1 02             	add    $0x2,%ecx
  80190d:	bb 10 00 00 00       	mov    $0x10,%ebx
  801912:	eb 16                	jmp    80192a <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  801914:	85 db                	test   %ebx,%ebx
  801916:	75 12                	jne    80192a <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801918:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80191d:	80 39 30             	cmpb   $0x30,(%ecx)
  801920:	75 08                	jne    80192a <strtol+0x6e>
		s++, base = 8;
  801922:	83 c1 01             	add    $0x1,%ecx
  801925:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
  80192f:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801932:	0f b6 11             	movzbl (%ecx),%edx
  801935:	8d 72 d0             	lea    -0x30(%edx),%esi
  801938:	89 f3                	mov    %esi,%ebx
  80193a:	80 fb 09             	cmp    $0x9,%bl
  80193d:	77 08                	ja     801947 <strtol+0x8b>
			dig = *s - '0';
  80193f:	0f be d2             	movsbl %dl,%edx
  801942:	83 ea 30             	sub    $0x30,%edx
  801945:	eb 22                	jmp    801969 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  801947:	8d 72 9f             	lea    -0x61(%edx),%esi
  80194a:	89 f3                	mov    %esi,%ebx
  80194c:	80 fb 19             	cmp    $0x19,%bl
  80194f:	77 08                	ja     801959 <strtol+0x9d>
			dig = *s - 'a' + 10;
  801951:	0f be d2             	movsbl %dl,%edx
  801954:	83 ea 57             	sub    $0x57,%edx
  801957:	eb 10                	jmp    801969 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  801959:	8d 72 bf             	lea    -0x41(%edx),%esi
  80195c:	89 f3                	mov    %esi,%ebx
  80195e:	80 fb 19             	cmp    $0x19,%bl
  801961:	77 16                	ja     801979 <strtol+0xbd>
			dig = *s - 'A' + 10;
  801963:	0f be d2             	movsbl %dl,%edx
  801966:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  801969:	3b 55 10             	cmp    0x10(%ebp),%edx
  80196c:	7d 0b                	jge    801979 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  80196e:	83 c1 01             	add    $0x1,%ecx
  801971:	0f af 45 10          	imul   0x10(%ebp),%eax
  801975:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  801977:	eb b9                	jmp    801932 <strtol+0x76>

	if (endptr)
  801979:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80197d:	74 0d                	je     80198c <strtol+0xd0>
		*endptr = (char *) s;
  80197f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801982:	89 0e                	mov    %ecx,(%esi)
  801984:	eb 06                	jmp    80198c <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801986:	85 db                	test   %ebx,%ebx
  801988:	74 98                	je     801922 <strtol+0x66>
  80198a:	eb 9e                	jmp    80192a <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  80198c:	89 c2                	mov    %eax,%edx
  80198e:	f7 da                	neg    %edx
  801990:	85 ff                	test   %edi,%edi
  801992:	0f 45 c2             	cmovne %edx,%eax
}
  801995:	5b                   	pop    %ebx
  801996:	5e                   	pop    %esi
  801997:	5f                   	pop    %edi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8019a0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8019a7:	75 2c                	jne    8019d5 <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	6a 07                	push   $0x7
  8019ae:	68 00 f0 bf ee       	push   $0xeebff000
  8019b3:	6a 00                	push   $0x0
  8019b5:	e8 ff e7 ff ff       	call   8001b9 <sys_page_alloc>
		if(r < 0)
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	79 14                	jns    8019d5 <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	68 20 22 80 00       	push   $0x802220
  8019c9:	6a 22                	push   $0x22
  8019cb:	68 8c 22 80 00       	push   $0x80228c
  8019d0:	e8 32 f6 ff ff       	call   801007 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	a3 00 60 80 00       	mov    %eax,0x806000
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	68 d6 02 80 00       	push   $0x8002d6
  8019e5:	6a 00                	push   $0x0
  8019e7:	e8 80 e8 ff ff       	call   80026c <sys_env_set_pgfault_upcall>
	if (r < 0)
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	79 14                	jns    801a07 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	68 50 22 80 00       	push   $0x802250
  8019fb:	6a 29                	push   $0x29
  8019fd:	68 8c 22 80 00       	push   $0x80228c
  801a02:	e8 00 f6 ff ff       	call   801007 <_panic>
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
  801a0e:	8b 75 08             	mov    0x8(%ebp),%esi
  801a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801a17:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801a19:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a1e:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801a21:	83 ec 0c             	sub    $0xc,%esp
  801a24:	50                   	push   %eax
  801a25:	e8 8a e8 ff ff       	call   8002b4 <sys_ipc_recv>
	if (from_env_store)
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	85 f6                	test   %esi,%esi
  801a2f:	74 0b                	je     801a3c <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801a31:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a37:	8b 52 74             	mov    0x74(%edx),%edx
  801a3a:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801a3c:	85 db                	test   %ebx,%ebx
  801a3e:	74 0b                	je     801a4b <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801a40:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a46:	8b 52 78             	mov    0x78(%edx),%edx
  801a49:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	79 16                	jns    801a65 <ipc_recv+0x5c>
		if (from_env_store)
  801a4f:	85 f6                	test   %esi,%esi
  801a51:	74 06                	je     801a59 <ipc_recv+0x50>
			*from_env_store = 0;
  801a53:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801a59:	85 db                	test   %ebx,%ebx
  801a5b:	74 10                	je     801a6d <ipc_recv+0x64>
			*perm_store = 0;
  801a5d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a63:	eb 08                	jmp    801a6d <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801a65:	a1 04 40 80 00       	mov    0x804004,%eax
  801a6a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    

00801a74 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	57                   	push   %edi
  801a78:	56                   	push   %esi
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 0c             	sub    $0xc,%esp
  801a7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a80:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801a86:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a88:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a8d:	0f 44 d8             	cmove  %eax,%ebx
  801a90:	eb 1c                	jmp    801aae <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a92:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a95:	74 12                	je     801aa9 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a97:	50                   	push   %eax
  801a98:	68 9a 22 80 00       	push   $0x80229a
  801a9d:	6a 42                	push   $0x42
  801a9f:	68 b0 22 80 00       	push   $0x8022b0
  801aa4:	e8 5e f5 ff ff       	call   801007 <_panic>
		sys_yield();
  801aa9:	e8 e4 e6 ff ff       	call   800192 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801aae:	ff 75 14             	pushl  0x14(%ebp)
  801ab1:	53                   	push   %ebx
  801ab2:	56                   	push   %esi
  801ab3:	57                   	push   %edi
  801ab4:	e8 d6 e7 ff ff       	call   80028f <sys_ipc_try_send>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	75 d2                	jne    801a92 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5e                   	pop    %esi
  801ac5:	5f                   	pop    %edi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    

00801ac8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ace:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ad3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ad6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801adc:	8b 52 50             	mov    0x50(%edx),%edx
  801adf:	39 ca                	cmp    %ecx,%edx
  801ae1:	75 0d                	jne    801af0 <ipc_find_env+0x28>
			return envs[i].env_id;
  801ae3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ae6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801aeb:	8b 40 48             	mov    0x48(%eax),%eax
  801aee:	eb 0f                	jmp    801aff <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801af0:	83 c0 01             	add    $0x1,%eax
  801af3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801af8:	75 d9                	jne    801ad3 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b07:	89 d0                	mov    %edx,%eax
  801b09:	c1 e8 16             	shr    $0x16,%eax
  801b0c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b13:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b18:	f6 c1 01             	test   $0x1,%cl
  801b1b:	74 1d                	je     801b3a <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801b1d:	c1 ea 0c             	shr    $0xc,%edx
  801b20:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b27:	f6 c2 01             	test   $0x1,%dl
  801b2a:	74 0e                	je     801b3a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b2c:	c1 ea 0c             	shr    $0xc,%edx
  801b2f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b36:	ef 
  801b37:	0f b7 c0             	movzwl %ax,%eax
}
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    
  801b3c:	66 90                	xchg   %ax,%ax
  801b3e:	66 90                	xchg   %ax,%ax

00801b40 <__udivdi3>:
  801b40:	55                   	push   %ebp
  801b41:	57                   	push   %edi
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 1c             	sub    $0x1c,%esp
  801b47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b57:	85 f6                	test   %esi,%esi
  801b59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b5d:	89 ca                	mov    %ecx,%edx
  801b5f:	89 f8                	mov    %edi,%eax
  801b61:	75 3d                	jne    801ba0 <__udivdi3+0x60>
  801b63:	39 cf                	cmp    %ecx,%edi
  801b65:	0f 87 c5 00 00 00    	ja     801c30 <__udivdi3+0xf0>
  801b6b:	85 ff                	test   %edi,%edi
  801b6d:	89 fd                	mov    %edi,%ebp
  801b6f:	75 0b                	jne    801b7c <__udivdi3+0x3c>
  801b71:	b8 01 00 00 00       	mov    $0x1,%eax
  801b76:	31 d2                	xor    %edx,%edx
  801b78:	f7 f7                	div    %edi
  801b7a:	89 c5                	mov    %eax,%ebp
  801b7c:	89 c8                	mov    %ecx,%eax
  801b7e:	31 d2                	xor    %edx,%edx
  801b80:	f7 f5                	div    %ebp
  801b82:	89 c1                	mov    %eax,%ecx
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	89 cf                	mov    %ecx,%edi
  801b88:	f7 f5                	div    %ebp
  801b8a:	89 c3                	mov    %eax,%ebx
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
  801ba0:	39 ce                	cmp    %ecx,%esi
  801ba2:	77 74                	ja     801c18 <__udivdi3+0xd8>
  801ba4:	0f bd fe             	bsr    %esi,%edi
  801ba7:	83 f7 1f             	xor    $0x1f,%edi
  801baa:	0f 84 98 00 00 00    	je     801c48 <__udivdi3+0x108>
  801bb0:	bb 20 00 00 00       	mov    $0x20,%ebx
  801bb5:	89 f9                	mov    %edi,%ecx
  801bb7:	89 c5                	mov    %eax,%ebp
  801bb9:	29 fb                	sub    %edi,%ebx
  801bbb:	d3 e6                	shl    %cl,%esi
  801bbd:	89 d9                	mov    %ebx,%ecx
  801bbf:	d3 ed                	shr    %cl,%ebp
  801bc1:	89 f9                	mov    %edi,%ecx
  801bc3:	d3 e0                	shl    %cl,%eax
  801bc5:	09 ee                	or     %ebp,%esi
  801bc7:	89 d9                	mov    %ebx,%ecx
  801bc9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bcd:	89 d5                	mov    %edx,%ebp
  801bcf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd3:	d3 ed                	shr    %cl,%ebp
  801bd5:	89 f9                	mov    %edi,%ecx
  801bd7:	d3 e2                	shl    %cl,%edx
  801bd9:	89 d9                	mov    %ebx,%ecx
  801bdb:	d3 e8                	shr    %cl,%eax
  801bdd:	09 c2                	or     %eax,%edx
  801bdf:	89 d0                	mov    %edx,%eax
  801be1:	89 ea                	mov    %ebp,%edx
  801be3:	f7 f6                	div    %esi
  801be5:	89 d5                	mov    %edx,%ebp
  801be7:	89 c3                	mov    %eax,%ebx
  801be9:	f7 64 24 0c          	mull   0xc(%esp)
  801bed:	39 d5                	cmp    %edx,%ebp
  801bef:	72 10                	jb     801c01 <__udivdi3+0xc1>
  801bf1:	8b 74 24 08          	mov    0x8(%esp),%esi
  801bf5:	89 f9                	mov    %edi,%ecx
  801bf7:	d3 e6                	shl    %cl,%esi
  801bf9:	39 c6                	cmp    %eax,%esi
  801bfb:	73 07                	jae    801c04 <__udivdi3+0xc4>
  801bfd:	39 d5                	cmp    %edx,%ebp
  801bff:	75 03                	jne    801c04 <__udivdi3+0xc4>
  801c01:	83 eb 01             	sub    $0x1,%ebx
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	89 d8                	mov    %ebx,%eax
  801c08:	89 fa                	mov    %edi,%edx
  801c0a:	83 c4 1c             	add    $0x1c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
  801c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c18:	31 ff                	xor    %edi,%edi
  801c1a:	31 db                	xor    %ebx,%ebx
  801c1c:	89 d8                	mov    %ebx,%eax
  801c1e:	89 fa                	mov    %edi,%edx
  801c20:	83 c4 1c             	add    $0x1c,%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
  801c28:	90                   	nop
  801c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c30:	89 d8                	mov    %ebx,%eax
  801c32:	f7 f7                	div    %edi
  801c34:	31 ff                	xor    %edi,%edi
  801c36:	89 c3                	mov    %eax,%ebx
  801c38:	89 d8                	mov    %ebx,%eax
  801c3a:	89 fa                	mov    %edi,%edx
  801c3c:	83 c4 1c             	add    $0x1c,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
  801c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c48:	39 ce                	cmp    %ecx,%esi
  801c4a:	72 0c                	jb     801c58 <__udivdi3+0x118>
  801c4c:	31 db                	xor    %ebx,%ebx
  801c4e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c52:	0f 87 34 ff ff ff    	ja     801b8c <__udivdi3+0x4c>
  801c58:	bb 01 00 00 00       	mov    $0x1,%ebx
  801c5d:	e9 2a ff ff ff       	jmp    801b8c <__udivdi3+0x4c>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	66 90                	xchg   %ax,%ax
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	66 90                	xchg   %ax,%ax
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	66 90                	xchg   %ax,%ax
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <__umoddi3>:
  801c70:	55                   	push   %ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c87:	85 d2                	test   %edx,%edx
  801c89:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c91:	89 f3                	mov    %esi,%ebx
  801c93:	89 3c 24             	mov    %edi,(%esp)
  801c96:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c9a:	75 1c                	jne    801cb8 <__umoddi3+0x48>
  801c9c:	39 f7                	cmp    %esi,%edi
  801c9e:	76 50                	jbe    801cf0 <__umoddi3+0x80>
  801ca0:	89 c8                	mov    %ecx,%eax
  801ca2:	89 f2                	mov    %esi,%edx
  801ca4:	f7 f7                	div    %edi
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	31 d2                	xor    %edx,%edx
  801caa:	83 c4 1c             	add    $0x1c,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5e                   	pop    %esi
  801caf:	5f                   	pop    %edi
  801cb0:	5d                   	pop    %ebp
  801cb1:	c3                   	ret    
  801cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cb8:	39 f2                	cmp    %esi,%edx
  801cba:	89 d0                	mov    %edx,%eax
  801cbc:	77 52                	ja     801d10 <__umoddi3+0xa0>
  801cbe:	0f bd ea             	bsr    %edx,%ebp
  801cc1:	83 f5 1f             	xor    $0x1f,%ebp
  801cc4:	75 5a                	jne    801d20 <__umoddi3+0xb0>
  801cc6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  801cca:	0f 82 e0 00 00 00    	jb     801db0 <__umoddi3+0x140>
  801cd0:	39 0c 24             	cmp    %ecx,(%esp)
  801cd3:	0f 86 d7 00 00 00    	jbe    801db0 <__umoddi3+0x140>
  801cd9:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cdd:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ce1:	83 c4 1c             	add    $0x1c,%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5f                   	pop    %edi
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
  801ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cf0:	85 ff                	test   %edi,%edi
  801cf2:	89 fd                	mov    %edi,%ebp
  801cf4:	75 0b                	jne    801d01 <__umoddi3+0x91>
  801cf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfb:	31 d2                	xor    %edx,%edx
  801cfd:	f7 f7                	div    %edi
  801cff:	89 c5                	mov    %eax,%ebp
  801d01:	89 f0                	mov    %esi,%eax
  801d03:	31 d2                	xor    %edx,%edx
  801d05:	f7 f5                	div    %ebp
  801d07:	89 c8                	mov    %ecx,%eax
  801d09:	f7 f5                	div    %ebp
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	eb 99                	jmp    801ca8 <__umoddi3+0x38>
  801d0f:	90                   	nop
  801d10:	89 c8                	mov    %ecx,%eax
  801d12:	89 f2                	mov    %esi,%edx
  801d14:	83 c4 1c             	add    $0x1c,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d20:	8b 34 24             	mov    (%esp),%esi
  801d23:	bf 20 00 00 00       	mov    $0x20,%edi
  801d28:	89 e9                	mov    %ebp,%ecx
  801d2a:	29 ef                	sub    %ebp,%edi
  801d2c:	d3 e0                	shl    %cl,%eax
  801d2e:	89 f9                	mov    %edi,%ecx
  801d30:	89 f2                	mov    %esi,%edx
  801d32:	d3 ea                	shr    %cl,%edx
  801d34:	89 e9                	mov    %ebp,%ecx
  801d36:	09 c2                	or     %eax,%edx
  801d38:	89 d8                	mov    %ebx,%eax
  801d3a:	89 14 24             	mov    %edx,(%esp)
  801d3d:	89 f2                	mov    %esi,%edx
  801d3f:	d3 e2                	shl    %cl,%edx
  801d41:	89 f9                	mov    %edi,%ecx
  801d43:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d47:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801d4b:	d3 e8                	shr    %cl,%eax
  801d4d:	89 e9                	mov    %ebp,%ecx
  801d4f:	89 c6                	mov    %eax,%esi
  801d51:	d3 e3                	shl    %cl,%ebx
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	89 d0                	mov    %edx,%eax
  801d57:	d3 e8                	shr    %cl,%eax
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	09 d8                	or     %ebx,%eax
  801d5d:	89 d3                	mov    %edx,%ebx
  801d5f:	89 f2                	mov    %esi,%edx
  801d61:	f7 34 24             	divl   (%esp)
  801d64:	89 d6                	mov    %edx,%esi
  801d66:	d3 e3                	shl    %cl,%ebx
  801d68:	f7 64 24 04          	mull   0x4(%esp)
  801d6c:	39 d6                	cmp    %edx,%esi
  801d6e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d72:	89 d1                	mov    %edx,%ecx
  801d74:	89 c3                	mov    %eax,%ebx
  801d76:	72 08                	jb     801d80 <__umoddi3+0x110>
  801d78:	75 11                	jne    801d8b <__umoddi3+0x11b>
  801d7a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801d7e:	73 0b                	jae    801d8b <__umoddi3+0x11b>
  801d80:	2b 44 24 04          	sub    0x4(%esp),%eax
  801d84:	1b 14 24             	sbb    (%esp),%edx
  801d87:	89 d1                	mov    %edx,%ecx
  801d89:	89 c3                	mov    %eax,%ebx
  801d8b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d8f:	29 da                	sub    %ebx,%edx
  801d91:	19 ce                	sbb    %ecx,%esi
  801d93:	89 f9                	mov    %edi,%ecx
  801d95:	89 f0                	mov    %esi,%eax
  801d97:	d3 e0                	shl    %cl,%eax
  801d99:	89 e9                	mov    %ebp,%ecx
  801d9b:	d3 ea                	shr    %cl,%edx
  801d9d:	89 e9                	mov    %ebp,%ecx
  801d9f:	d3 ee                	shr    %cl,%esi
  801da1:	09 d0                	or     %edx,%eax
  801da3:	89 f2                	mov    %esi,%edx
  801da5:	83 c4 1c             	add    $0x1c,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
  801dad:	8d 76 00             	lea    0x0(%esi),%esi
  801db0:	29 f9                	sub    %edi,%ecx
  801db2:	19 d6                	sbb    %edx,%esi
  801db4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801db8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dbc:	e9 18 ff ff ff       	jmp    801cd9 <__umoddi3+0x69>
