
obj/kern/kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

f0100000 <_start+0xeffffff4>:
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
_start = RELOC(entry)

.globl entry
.func entry
entry:
	movw	$0x1234,0x472			# warm boot
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Habilito el soporte para large pages
	movl	%cr4, %ecx
f010001d:	0f 20 e1             	mov    %cr4,%ecx
	orl	$(CR4_PSE), %ecx
f0100020:	83 c9 10             	or     $0x10,%ecx
	movl	%ecx, %cr4
f0100023:	0f 22 e1             	mov    %ecx,%cr4

	# Turn on paging.
	movl	%cr0, %eax
f0100026:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100029:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f010002e:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100031:	b8 38 00 10 f0       	mov    $0xf0100038,%eax
	jmp	*%eax
f0100036:	ff e0                	jmp    *%eax

f0100038 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f0100038:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f010003d:	bc 00 00 12 f0       	mov    $0xf0120000,%esp

	# now to C code
	call	i386_init
f0100042:	e8 82 01 00 00       	call   f01001c9 <i386_init>

f0100047 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f0100047:	eb fe                	jmp    f0100047 <spin>

f0100049 <lcr3>:
	return val;
}

static inline void
lcr3(uint32_t val)
{
f0100049:	55                   	push   %ebp
f010004a:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010004c:	0f 22 d8             	mov    %eax,%cr3
}
f010004f:	5d                   	pop    %ebp
f0100050:	c3                   	ret    

f0100051 <xchg>:
	return tsc;
}

static inline uint32_t
xchg(volatile uint32_t *addr, uint32_t newval)
{
f0100051:	55                   	push   %ebp
f0100052:	89 e5                	mov    %esp,%ebp
f0100054:	89 c1                	mov    %eax,%ecx
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100056:	89 d0                	mov    %edx,%eax
f0100058:	f0 87 01             	lock xchg %eax,(%ecx)
		     : "+m" (*addr), "=a" (result)
		     : "1" (newval)
		     : "cc");
	return result;
}
f010005b:	5d                   	pop    %ebp
f010005c:	c3                   	ret    

f010005d <lock_kernel>:

extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
f010005d:	55                   	push   %ebp
f010005e:	89 e5                	mov    %esp,%ebp
f0100060:	83 ec 14             	sub    $0x14,%esp
	spin_lock(&kernel_lock);
f0100063:	68 c0 13 12 f0       	push   $0xf01213c0
f0100068:	e8 33 5e 00 00       	call   f0105ea0 <spin_lock>
}
f010006d:	83 c4 10             	add    $0x10,%esp
f0100070:	c9                   	leave  
f0100071:	c3                   	ret    

f0100072 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100072:	55                   	push   %ebp
f0100073:	89 e5                	mov    %esp,%ebp
f0100075:	56                   	push   %esi
f0100076:	53                   	push   %ebx
f0100077:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010007a:	83 3d 80 ae 21 f0 00 	cmpl   $0x0,0xf021ae80
f0100081:	75 3a                	jne    f01000bd <_panic+0x4b>
		goto dead;
	panicstr = fmt;
f0100083:	89 35 80 ae 21 f0    	mov    %esi,0xf021ae80

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");
f0100089:	fa                   	cli    
f010008a:	fc                   	cld    

	va_start(ap, fmt);
f010008b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf(">>>\n>>> kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010008e:	e8 37 5b 00 00       	call   f0105bca <cpunum>
f0100093:	ff 75 0c             	pushl  0xc(%ebp)
f0100096:	ff 75 08             	pushl  0x8(%ebp)
f0100099:	50                   	push   %eax
f010009a:	68 80 62 10 f0       	push   $0xf0106280
f010009f:	e8 b7 36 00 00       	call   f010375b <cprintf>
	vcprintf(fmt, ap);
f01000a4:	83 c4 08             	add    $0x8,%esp
f01000a7:	53                   	push   %ebx
f01000a8:	56                   	push   %esi
f01000a9:	e8 87 36 00 00       	call   f0103735 <vcprintf>
	cprintf("\n>>>\n");
f01000ae:	c7 04 24 f4 62 10 f0 	movl   $0xf01062f4,(%esp)
f01000b5:	e8 a1 36 00 00       	call   f010375b <cprintf>
	va_end(ap);
f01000ba:	83 c4 10             	add    $0x10,%esp

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000bd:	83 ec 0c             	sub    $0xc,%esp
f01000c0:	6a 00                	push   $0x0
f01000c2:	e8 9a 0a 00 00       	call   f0100b61 <monitor>
f01000c7:	83 c4 10             	add    $0x10,%esp
f01000ca:	eb f1                	jmp    f01000bd <_panic+0x4b>

f01000cc <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f01000cc:	55                   	push   %ebp
f01000cd:	89 e5                	mov    %esp,%ebp
f01000cf:	53                   	push   %ebx
f01000d0:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f01000d3:	89 cb                	mov    %ecx,%ebx
f01000d5:	c1 eb 0c             	shr    $0xc,%ebx
f01000d8:	3b 1d 88 ae 21 f0    	cmp    0xf021ae88,%ebx
f01000de:	72 0d                	jb     f01000ed <_kaddr+0x21>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01000e0:	51                   	push   %ecx
f01000e1:	68 ac 62 10 f0       	push   $0xf01062ac
f01000e6:	52                   	push   %edx
f01000e7:	50                   	push   %eax
f01000e8:	e8 85 ff ff ff       	call   f0100072 <_panic>
	return (void *)(pa + KERNBASE);
f01000ed:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f01000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01000f6:	c9                   	leave  
f01000f7:	c3                   	ret    

f01000f8 <_paddr>:
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01000f8:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01000fe:	77 13                	ja     f0100113 <_paddr+0x1b>
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
f0100100:	55                   	push   %ebp
f0100101:	89 e5                	mov    %esp,%ebp
f0100103:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100106:	51                   	push   %ecx
f0100107:	68 d0 62 10 f0       	push   $0xf01062d0
f010010c:	52                   	push   %edx
f010010d:	50                   	push   %eax
f010010e:	e8 5f ff ff ff       	call   f0100072 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0100113:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0100119:	c3                   	ret    

f010011a <boot_aps>:
void *mpentry_kstack;

// Start the non-boot (AP) processors.
static void
boot_aps(void)
{
f010011a:	55                   	push   %ebp
f010011b:	89 e5                	mov    %esp,%ebp
f010011d:	56                   	push   %esi
f010011e:	53                   	push   %ebx
	extern unsigned char mpentry_start[], mpentry_end[];
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
f010011f:	b9 00 70 00 00       	mov    $0x7000,%ecx
f0100124:	ba 67 00 00 00       	mov    $0x67,%edx
f0100129:	b8 fa 62 10 f0       	mov    $0xf01062fa,%eax
f010012e:	e8 99 ff ff ff       	call   f01000cc <_kaddr>
f0100133:	89 c6                	mov    %eax,%esi
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100135:	83 ec 04             	sub    $0x4,%esp
f0100138:	b8 ae 57 10 f0       	mov    $0xf01057ae,%eax
f010013d:	2d 2c 57 10 f0       	sub    $0xf010572c,%eax
f0100142:	50                   	push   %eax
f0100143:	68 2c 57 10 f0       	push   $0xf010572c
f0100148:	56                   	push   %esi
f0100149:	e8 29 54 00 00       	call   f0105577 <memmove>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f010014e:	83 c4 10             	add    $0x10,%esp
f0100151:	bb 20 b0 21 f0       	mov    $0xf021b020,%ebx
f0100156:	eb 5a                	jmp    f01001b2 <boot_aps+0x98>
		if (c == cpus + cpunum())  // We've started already.
f0100158:	e8 6d 5a 00 00       	call   f0105bca <cpunum>
f010015d:	6b c0 74             	imul   $0x74,%eax,%eax
f0100160:	05 20 b0 21 f0       	add    $0xf021b020,%eax
f0100165:	39 c3                	cmp    %eax,%ebx
f0100167:	74 46                	je     f01001af <boot_aps+0x95>
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100169:	89 d8                	mov    %ebx,%eax
f010016b:	2d 20 b0 21 f0       	sub    $0xf021b020,%eax
f0100170:	c1 f8 02             	sar    $0x2,%eax
f0100173:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100179:	c1 e0 0f             	shl    $0xf,%eax
f010017c:	05 00 40 22 f0       	add    $0xf0224000,%eax
f0100181:	a3 84 ae 21 f0       	mov    %eax,0xf021ae84
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f0100186:	89 f1                	mov    %esi,%ecx
f0100188:	ba 72 00 00 00       	mov    $0x72,%edx
f010018d:	b8 fa 62 10 f0       	mov    $0xf01062fa,%eax
f0100192:	e8 61 ff ff ff       	call   f01000f8 <_paddr>
f0100197:	83 ec 08             	sub    $0x8,%esp
f010019a:	50                   	push   %eax
f010019b:	0f b6 03             	movzbl (%ebx),%eax
f010019e:	50                   	push   %eax
f010019f:	e8 8f 5b 00 00       	call   f0105d33 <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
f01001a4:	83 c4 10             	add    $0x10,%esp
f01001a7:	8b 43 04             	mov    0x4(%ebx),%eax
f01001aa:	83 f8 01             	cmp    $0x1,%eax
f01001ad:	75 f8                	jne    f01001a7 <boot_aps+0x8d>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01001af:	83 c3 74             	add    $0x74,%ebx
f01001b2:	6b 05 c4 b3 21 f0 74 	imul   $0x74,0xf021b3c4,%eax
f01001b9:	05 20 b0 21 f0       	add    $0xf021b020,%eax
f01001be:	39 c3                	cmp    %eax,%ebx
f01001c0:	72 96                	jb     f0100158 <boot_aps+0x3e>
		lapic_startap(c->cpu_id, PADDR(code));
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
			;
	}
}
f01001c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01001c5:	5b                   	pop    %ebx
f01001c6:	5e                   	pop    %esi
f01001c7:	5d                   	pop    %ebp
f01001c8:	c3                   	ret    

f01001c9 <i386_init>:
static void boot_aps(void);


void
i386_init(void)
{
f01001c9:	55                   	push   %ebp
f01001ca:	89 e5                	mov    %esp,%ebp
f01001cc:	83 ec 0c             	sub    $0xc,%esp
	extern char __bss_start[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(__bss_start, 0, end - __bss_start);
f01001cf:	b8 08 c0 25 f0       	mov    $0xf025c008,%eax
f01001d4:	2d 00 a0 21 f0       	sub    $0xf021a000,%eax
f01001d9:	50                   	push   %eax
f01001da:	6a 00                	push   $0x0
f01001dc:	68 00 a0 21 f0       	push   $0xf021a000
f01001e1:	e8 43 53 00 00       	call   f0105529 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01001e6:	e8 08 07 00 00       	call   f01008f3 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f01001eb:	83 c4 08             	add    $0x8,%esp
f01001ee:	68 ac 1a 00 00       	push   $0x1aac
f01001f3:	68 06 63 10 f0       	push   $0xf0106306
f01001f8:	e8 5e 35 00 00       	call   f010375b <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f01001fd:	e8 c0 28 00 00       	call   f0102ac2 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f0100202:	e8 0f 2f 00 00       	call   f0103116 <env_init>
	trap_init();
f0100207:	e8 5b 36 00 00       	call   f0103867 <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f010020c:	e8 f5 57 00 00       	call   f0105a06 <mp_init>
	lapic_init();
f0100211:	e8 cf 59 00 00       	call   f0105be5 <lapic_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100216:	e8 00 34 00 00       	call   f010361b <pic_init>

	// Acquire the big kernel lock before waking up APs
	// Your code here:

	// Starting non-boot CPUs
	lock_kernel();
f010021b:	e8 3d fe ff ff       	call   f010005d <lock_kernel>
	boot_aps();
f0100220:	e8 f5 fe ff ff       	call   f010011a <boot_aps>

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100225:	83 c4 08             	add    $0x8,%esp
f0100228:	6a 01                	push   $0x1
f010022a:	68 3c 74 1d f0       	push   $0xf01d743c
f010022f:	e8 28 30 00 00       	call   f010325c <env_create>

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100234:	83 c4 08             	add    $0x8,%esp
f0100237:	6a 00                	push   $0x0
f0100239:	68 a8 98 20 f0       	push   $0xf02098a8
f010023e:	e8 19 30 00 00       	call   f010325c <env_create>
	ENV_CREATE(user_yield, ENV_TYPE_USER);
	ENV_CREATE(user_yield, ENV_TYPE_USER);
#endif

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f0100243:	e8 2a 06 00 00       	call   f0100872 <kbd_intr>


	// Schedule and run the first user environment!
	sched_yield();
f0100248:	e8 1e 40 00 00       	call   f010426b <sched_yield>

f010024d <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f010024d:	55                   	push   %ebp
f010024e:	89 e5                	mov    %esp,%ebp
f0100250:	83 ec 08             	sub    $0x8,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f0100253:	8b 0d 8c ae 21 f0    	mov    0xf021ae8c,%ecx
f0100259:	ba 7e 00 00 00       	mov    $0x7e,%edx
f010025e:	b8 fa 62 10 f0       	mov    $0xf01062fa,%eax
f0100263:	e8 90 fe ff ff       	call   f01000f8 <_paddr>
f0100268:	e8 dc fd ff ff       	call   f0100049 <lcr3>
	cprintf("SMP: CPU %d starting\n", cpunum());
f010026d:	e8 58 59 00 00       	call   f0105bca <cpunum>
f0100272:	83 ec 08             	sub    $0x8,%esp
f0100275:	50                   	push   %eax
f0100276:	68 21 63 10 f0       	push   $0xf0106321
f010027b:	e8 db 34 00 00       	call   f010375b <cprintf>

	lapic_init();
f0100280:	e8 60 59 00 00       	call   f0105be5 <lapic_init>
	env_init_percpu();
f0100285:	e8 58 2e 00 00       	call   f01030e2 <env_init_percpu>
	trap_init_percpu();
f010028a:	e8 52 35 00 00       	call   f01037e1 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f010028f:	e8 36 59 00 00       	call   f0105bca <cpunum>
f0100294:	6b c0 74             	imul   $0x74,%eax,%eax
f0100297:	05 24 b0 21 f0       	add    $0xf021b024,%eax
f010029c:	ba 01 00 00 00       	mov    $0x1,%edx
f01002a1:	e8 ab fd ff ff       	call   f0100051 <xchg>
	// Now that we have finished some basic setup, call sched_yield()
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();
f01002a6:	e8 b2 fd ff ff       	call   f010005d <lock_kernel>
	sched_yield();
f01002ab:	e8 bb 3f 00 00       	call   f010426b <sched_yield>

f01002b0 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002b0:	55                   	push   %ebp
f01002b1:	89 e5                	mov    %esp,%ebp
f01002b3:	53                   	push   %ebx
f01002b4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01002b7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002ba:	ff 75 0c             	pushl  0xc(%ebp)
f01002bd:	ff 75 08             	pushl  0x8(%ebp)
f01002c0:	68 37 63 10 f0       	push   $0xf0106337
f01002c5:	e8 91 34 00 00       	call   f010375b <cprintf>
	vcprintf(fmt, ap);
f01002ca:	83 c4 08             	add    $0x8,%esp
f01002cd:	53                   	push   %ebx
f01002ce:	ff 75 10             	pushl  0x10(%ebp)
f01002d1:	e8 5f 34 00 00       	call   f0103735 <vcprintf>
	cprintf("\n");
f01002d6:	c7 04 24 54 74 10 f0 	movl   $0xf0107454,(%esp)
f01002dd:	e8 79 34 00 00       	call   f010375b <cprintf>
	va_end(ap);
}
f01002e2:	83 c4 10             	add    $0x10,%esp
f01002e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002e8:	c9                   	leave  
f01002e9:	c3                   	ret    

f01002ea <inb>:
	asm volatile("int3");
}

static inline uint8_t
inb(int port)
{
f01002ea:	55                   	push   %ebp
f01002eb:	89 e5                	mov    %esp,%ebp
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002ed:	89 c2                	mov    %eax,%edx
f01002ef:	ec                   	in     (%dx),%al
	return data;
}
f01002f0:	5d                   	pop    %ebp
f01002f1:	c3                   	ret    

f01002f2 <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
f01002f2:	55                   	push   %ebp
f01002f3:	89 e5                	mov    %esp,%ebp
f01002f5:	89 c1                	mov    %eax,%ecx
f01002f7:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002f9:	89 ca                	mov    %ecx,%edx
f01002fb:	ee                   	out    %al,(%dx)
}
f01002fc:	5d                   	pop    %ebp
f01002fd:	c3                   	ret    

f01002fe <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f01002fe:	55                   	push   %ebp
f01002ff:	89 e5                	mov    %esp,%ebp
	inb(0x84);
f0100301:	b8 84 00 00 00       	mov    $0x84,%eax
f0100306:	e8 df ff ff ff       	call   f01002ea <inb>
	inb(0x84);
f010030b:	b8 84 00 00 00       	mov    $0x84,%eax
f0100310:	e8 d5 ff ff ff       	call   f01002ea <inb>
	inb(0x84);
f0100315:	b8 84 00 00 00       	mov    $0x84,%eax
f010031a:	e8 cb ff ff ff       	call   f01002ea <inb>
	inb(0x84);
f010031f:	b8 84 00 00 00       	mov    $0x84,%eax
f0100324:	e8 c1 ff ff ff       	call   f01002ea <inb>
}
f0100329:	5d                   	pop    %ebp
f010032a:	c3                   	ret    

f010032b <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010032b:	55                   	push   %ebp
f010032c:	89 e5                	mov    %esp,%ebp
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010032e:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100333:	e8 b2 ff ff ff       	call   f01002ea <inb>
f0100338:	a8 01                	test   $0x1,%al
f010033a:	74 0f                	je     f010034b <serial_proc_data+0x20>
		return -1;
	return inb(COM1+COM_RX);
f010033c:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100341:	e8 a4 ff ff ff       	call   f01002ea <inb>
f0100346:	0f b6 c0             	movzbl %al,%eax
f0100349:	eb 05                	jmp    f0100350 <serial_proc_data+0x25>

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f010034b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return inb(COM1+COM_RX);
}
f0100350:	5d                   	pop    %ebp
f0100351:	c3                   	ret    

f0100352 <serial_putc>:
		cons_intr(serial_proc_data);
}

static void
serial_putc(int c)
{
f0100352:	55                   	push   %ebp
f0100353:	89 e5                	mov    %esp,%ebp
f0100355:	56                   	push   %esi
f0100356:	53                   	push   %ebx
f0100357:	89 c6                	mov    %eax,%esi
	int i;

	for (i = 0;
f0100359:	bb 00 00 00 00       	mov    $0x0,%ebx
f010035e:	eb 08                	jmp    f0100368 <serial_putc+0x16>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f0100360:	e8 99 ff ff ff       	call   f01002fe <delay>
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
f0100365:	83 c3 01             	add    $0x1,%ebx
serial_putc(int c)
{
	int i;

	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100368:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f010036d:	e8 78 ff ff ff       	call   f01002ea <inb>
f0100372:	a8 20                	test   $0x20,%al
f0100374:	75 08                	jne    f010037e <serial_putc+0x2c>
f0100376:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010037c:	7e e2                	jle    f0100360 <serial_putc+0xe>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f010037e:	89 f0                	mov    %esi,%eax
f0100380:	0f b6 d0             	movzbl %al,%edx
f0100383:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100388:	e8 65 ff ff ff       	call   f01002f2 <outb>
}
f010038d:	5b                   	pop    %ebx
f010038e:	5e                   	pop    %esi
f010038f:	5d                   	pop    %ebp
f0100390:	c3                   	ret    

f0100391 <lpt_putc>:
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
f0100391:	55                   	push   %ebp
f0100392:	89 e5                	mov    %esp,%ebp
f0100394:	56                   	push   %esi
f0100395:	53                   	push   %ebx
f0100396:	89 c6                	mov    %eax,%esi
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100398:	bb 00 00 00 00       	mov    $0x0,%ebx
f010039d:	eb 08                	jmp    f01003a7 <lpt_putc+0x16>
		delay();
f010039f:	e8 5a ff ff ff       	call   f01002fe <delay>
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003a4:	83 c3 01             	add    $0x1,%ebx
f01003a7:	b8 79 03 00 00       	mov    $0x379,%eax
f01003ac:	e8 39 ff ff ff       	call   f01002ea <inb>
f01003b1:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f01003b7:	7f 04                	jg     f01003bd <lpt_putc+0x2c>
f01003b9:	84 c0                	test   %al,%al
f01003bb:	79 e2                	jns    f010039f <lpt_putc+0xe>
		delay();
	outb(0x378+0, c);
f01003bd:	89 f0                	mov    %esi,%eax
f01003bf:	0f b6 d0             	movzbl %al,%edx
f01003c2:	b8 78 03 00 00       	mov    $0x378,%eax
f01003c7:	e8 26 ff ff ff       	call   f01002f2 <outb>
	outb(0x378+2, 0x08|0x04|0x01);
f01003cc:	ba 0d 00 00 00       	mov    $0xd,%edx
f01003d1:	b8 7a 03 00 00       	mov    $0x37a,%eax
f01003d6:	e8 17 ff ff ff       	call   f01002f2 <outb>
	outb(0x378+2, 0x08);
f01003db:	ba 08 00 00 00       	mov    $0x8,%edx
f01003e0:	b8 7a 03 00 00       	mov    $0x37a,%eax
f01003e5:	e8 08 ff ff ff       	call   f01002f2 <outb>
}
f01003ea:	5b                   	pop    %ebx
f01003eb:	5e                   	pop    %esi
f01003ec:	5d                   	pop    %ebp
f01003ed:	c3                   	ret    

f01003ee <cga_init>:
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
f01003ee:	55                   	push   %ebp
f01003ef:	89 e5                	mov    %esp,%ebp
f01003f1:	57                   	push   %edi
f01003f2:	56                   	push   %esi
f01003f3:	53                   	push   %ebx
f01003f4:	83 ec 04             	sub    $0x4,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01003f7:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01003fe:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100405:	5a a5 
	if (*cp != 0xA55A) {
f0100407:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010040e:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100412:	74 13                	je     f0100427 <cga_init+0x39>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f0100414:	c7 05 30 a2 21 f0 b4 	movl   $0x3b4,0xf021a230
f010041b:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010041e:	c7 45 f0 00 00 0b f0 	movl   $0xf00b0000,-0x10(%ebp)
f0100425:	eb 18                	jmp    f010043f <cga_init+0x51>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f0100427:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010042e:	c7 05 30 a2 21 f0 d4 	movl   $0x3d4,0xf021a230
f0100435:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100438:	c7 45 f0 00 80 0b f0 	movl   $0xf00b8000,-0x10(%ebp)
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f010043f:	8b 35 30 a2 21 f0    	mov    0xf021a230,%esi
f0100445:	ba 0e 00 00 00       	mov    $0xe,%edx
f010044a:	89 f0                	mov    %esi,%eax
f010044c:	e8 a1 fe ff ff       	call   f01002f2 <outb>
	pos = inb(addr_6845 + 1) << 8;
f0100451:	8d 7e 01             	lea    0x1(%esi),%edi
f0100454:	89 f8                	mov    %edi,%eax
f0100456:	e8 8f fe ff ff       	call   f01002ea <inb>
f010045b:	0f b6 d8             	movzbl %al,%ebx
f010045e:	c1 e3 08             	shl    $0x8,%ebx
	outb(addr_6845, 15);
f0100461:	ba 0f 00 00 00       	mov    $0xf,%edx
f0100466:	89 f0                	mov    %esi,%eax
f0100468:	e8 85 fe ff ff       	call   f01002f2 <outb>
	pos |= inb(addr_6845 + 1);
f010046d:	89 f8                	mov    %edi,%eax
f010046f:	e8 76 fe ff ff       	call   f01002ea <inb>

	crt_buf = (uint16_t*) cp;
f0100474:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0100477:	89 0d 2c a2 21 f0    	mov    %ecx,0xf021a22c
	crt_pos = pos;
f010047d:	0f b6 c0             	movzbl %al,%eax
f0100480:	09 c3                	or     %eax,%ebx
f0100482:	66 89 1d 28 a2 21 f0 	mov    %bx,0xf021a228
}
f0100489:	83 c4 04             	add    $0x4,%esp
f010048c:	5b                   	pop    %ebx
f010048d:	5e                   	pop    %esi
f010048e:	5f                   	pop    %edi
f010048f:	5d                   	pop    %ebp
f0100490:	c3                   	ret    

f0100491 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100491:	55                   	push   %ebp
f0100492:	89 e5                	mov    %esp,%ebp
f0100494:	53                   	push   %ebx
f0100495:	83 ec 04             	sub    $0x4,%esp
f0100498:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010049a:	eb 2b                	jmp    f01004c7 <cons_intr+0x36>
		if (c == 0)
f010049c:	85 c0                	test   %eax,%eax
f010049e:	74 27                	je     f01004c7 <cons_intr+0x36>
			continue;
		cons.buf[cons.wpos++] = c;
f01004a0:	8b 0d 24 a2 21 f0    	mov    0xf021a224,%ecx
f01004a6:	8d 51 01             	lea    0x1(%ecx),%edx
f01004a9:	89 15 24 a2 21 f0    	mov    %edx,0xf021a224
f01004af:	88 81 20 a0 21 f0    	mov    %al,-0xfde5fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01004b5:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01004bb:	75 0a                	jne    f01004c7 <cons_intr+0x36>
			cons.wpos = 0;
f01004bd:	c7 05 24 a2 21 f0 00 	movl   $0x0,0xf021a224
f01004c4:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01004c7:	ff d3                	call   *%ebx
f01004c9:	83 f8 ff             	cmp    $0xffffffff,%eax
f01004cc:	75 ce                	jne    f010049c <cons_intr+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f01004ce:	83 c4 04             	add    $0x4,%esp
f01004d1:	5b                   	pop    %ebx
f01004d2:	5d                   	pop    %ebp
f01004d3:	c3                   	ret    

f01004d4 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f01004d4:	55                   	push   %ebp
f01004d5:	89 e5                	mov    %esp,%ebp
f01004d7:	53                   	push   %ebx
f01004d8:	83 ec 04             	sub    $0x4,%esp
	int c;
	uint8_t stat, data;
	static uint32_t shift;

	stat = inb(KBSTATP);
f01004db:	b8 64 00 00 00       	mov    $0x64,%eax
f01004e0:	e8 05 fe ff ff       	call   f01002ea <inb>
	if ((stat & KBS_DIB) == 0)
f01004e5:	a8 01                	test   $0x1,%al
f01004e7:	0f 84 fe 00 00 00    	je     f01005eb <kbd_proc_data+0x117>
		return -1;
	// Ignore data from mouse.
	if (stat & KBS_TERR)
f01004ed:	a8 20                	test   $0x20,%al
f01004ef:	0f 85 fd 00 00 00    	jne    f01005f2 <kbd_proc_data+0x11e>
		return -1;

	data = inb(KBDATAP);
f01004f5:	b8 60 00 00 00       	mov    $0x60,%eax
f01004fa:	e8 eb fd ff ff       	call   f01002ea <inb>

	if (data == 0xE0) {
f01004ff:	3c e0                	cmp    $0xe0,%al
f0100501:	75 11                	jne    f0100514 <kbd_proc_data+0x40>
		// E0 escape character
		shift |= E0ESC;
f0100503:	83 0d 00 a0 21 f0 40 	orl    $0x40,0xf021a000
		return 0;
f010050a:	b8 00 00 00 00       	mov    $0x0,%eax
f010050f:	e9 e7 00 00 00       	jmp    f01005fb <kbd_proc_data+0x127>
	} else if (data & 0x80) {
f0100514:	84 c0                	test   %al,%al
f0100516:	79 38                	jns    f0100550 <kbd_proc_data+0x7c>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f0100518:	8b 0d 00 a0 21 f0    	mov    0xf021a000,%ecx
f010051e:	89 cb                	mov    %ecx,%ebx
f0100520:	83 e3 40             	and    $0x40,%ebx
f0100523:	89 c2                	mov    %eax,%edx
f0100525:	83 e2 7f             	and    $0x7f,%edx
f0100528:	85 db                	test   %ebx,%ebx
f010052a:	0f 44 c2             	cmove  %edx,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f010052d:	0f b6 c0             	movzbl %al,%eax
f0100530:	0f b6 80 a0 64 10 f0 	movzbl -0xfef9b60(%eax),%eax
f0100537:	83 c8 40             	or     $0x40,%eax
f010053a:	0f b6 c0             	movzbl %al,%eax
f010053d:	f7 d0                	not    %eax
f010053f:	21 c8                	and    %ecx,%eax
f0100541:	a3 00 a0 21 f0       	mov    %eax,0xf021a000
		return 0;
f0100546:	b8 00 00 00 00       	mov    $0x0,%eax
f010054b:	e9 ab 00 00 00       	jmp    f01005fb <kbd_proc_data+0x127>
	} else if (shift & E0ESC) {
f0100550:	8b 15 00 a0 21 f0    	mov    0xf021a000,%edx
f0100556:	f6 c2 40             	test   $0x40,%dl
f0100559:	74 0c                	je     f0100567 <kbd_proc_data+0x93>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f010055b:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f010055e:	83 e2 bf             	and    $0xffffffbf,%edx
f0100561:	89 15 00 a0 21 f0    	mov    %edx,0xf021a000
	}

	shift |= shiftcode[data];
f0100567:	0f b6 c0             	movzbl %al,%eax
	shift ^= togglecode[data];
f010056a:	0f b6 90 a0 64 10 f0 	movzbl -0xfef9b60(%eax),%edx
f0100571:	0b 15 00 a0 21 f0    	or     0xf021a000,%edx
f0100577:	0f b6 88 a0 63 10 f0 	movzbl -0xfef9c60(%eax),%ecx
f010057e:	31 ca                	xor    %ecx,%edx
f0100580:	89 15 00 a0 21 f0    	mov    %edx,0xf021a000

	c = charcode[shift & (CTL | SHIFT)][data];
f0100586:	89 d1                	mov    %edx,%ecx
f0100588:	83 e1 03             	and    $0x3,%ecx
f010058b:	8b 0c 8d 80 63 10 f0 	mov    -0xfef9c80(,%ecx,4),%ecx
f0100592:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
f0100596:	0f b6 d8             	movzbl %al,%ebx
	if (shift & CAPSLOCK) {
f0100599:	f6 c2 08             	test   $0x8,%dl
f010059c:	74 1b                	je     f01005b9 <kbd_proc_data+0xe5>
		if ('a' <= c && c <= 'z')
f010059e:	89 d8                	mov    %ebx,%eax
f01005a0:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f01005a3:	83 f9 19             	cmp    $0x19,%ecx
f01005a6:	77 05                	ja     f01005ad <kbd_proc_data+0xd9>
			c += 'A' - 'a';
f01005a8:	83 eb 20             	sub    $0x20,%ebx
f01005ab:	eb 0c                	jmp    f01005b9 <kbd_proc_data+0xe5>
		else if ('A' <= c && c <= 'Z')
f01005ad:	83 e8 41             	sub    $0x41,%eax
			c += 'a' - 'A';
f01005b0:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01005b3:	83 f8 19             	cmp    $0x19,%eax
f01005b6:	0f 46 d9             	cmovbe %ecx,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01005b9:	f7 d2                	not    %edx
f01005bb:	f6 c2 06             	test   $0x6,%dl
f01005be:	75 39                	jne    f01005f9 <kbd_proc_data+0x125>
f01005c0:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01005c6:	75 31                	jne    f01005f9 <kbd_proc_data+0x125>
		cprintf("Rebooting!\n");
f01005c8:	83 ec 0c             	sub    $0xc,%esp
f01005cb:	68 51 63 10 f0       	push   $0xf0106351
f01005d0:	e8 86 31 00 00       	call   f010375b <cprintf>
		outb(0x92, 0x3); // courtesy of Chris Frost
f01005d5:	ba 03 00 00 00       	mov    $0x3,%edx
f01005da:	b8 92 00 00 00       	mov    $0x92,%eax
f01005df:	e8 0e fd ff ff       	call   f01002f2 <outb>
f01005e4:	83 c4 10             	add    $0x10,%esp
	}

	return c;
f01005e7:	89 d8                	mov    %ebx,%eax
f01005e9:	eb 10                	jmp    f01005fb <kbd_proc_data+0x127>
	uint8_t stat, data;
	static uint32_t shift;

	stat = inb(KBSTATP);
	if ((stat & KBS_DIB) == 0)
		return -1;
f01005eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01005f0:	eb 09                	jmp    f01005fb <kbd_proc_data+0x127>
	// Ignore data from mouse.
	if (stat & KBS_TERR)
		return -1;
f01005f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01005f7:	eb 02                	jmp    f01005fb <kbd_proc_data+0x127>
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f01005f9:	89 d8                	mov    %ebx,%eax
}
f01005fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01005fe:	c9                   	leave  
f01005ff:	c3                   	ret    

f0100600 <serial_init>:
	outb(COM1 + COM_TX, c);
}

static void
serial_init(void)
{
f0100600:	55                   	push   %ebp
f0100601:	89 e5                	mov    %esp,%ebp
f0100603:	53                   	push   %ebx
f0100604:	83 ec 04             	sub    $0x4,%esp
	// Turn off the FIFO
	outb(COM1+COM_FCR, 0);
f0100607:	ba 00 00 00 00       	mov    $0x0,%edx
f010060c:	b8 fa 03 00 00       	mov    $0x3fa,%eax
f0100611:	e8 dc fc ff ff       	call   f01002f2 <outb>

	// Set speed; requires DLAB latch
	outb(COM1+COM_LCR, COM_LCR_DLAB);
f0100616:	ba 80 00 00 00       	mov    $0x80,%edx
f010061b:	b8 fb 03 00 00       	mov    $0x3fb,%eax
f0100620:	e8 cd fc ff ff       	call   f01002f2 <outb>
	outb(COM1+COM_DLL, (uint8_t) (115200 / 9600));
f0100625:	ba 0c 00 00 00       	mov    $0xc,%edx
f010062a:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f010062f:	e8 be fc ff ff       	call   f01002f2 <outb>
	outb(COM1+COM_DLM, 0);
f0100634:	ba 00 00 00 00       	mov    $0x0,%edx
f0100639:	b8 f9 03 00 00       	mov    $0x3f9,%eax
f010063e:	e8 af fc ff ff       	call   f01002f2 <outb>

	// 8 data bits, 1 stop bit, parity off; turn off DLAB latch
	outb(COM1+COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
f0100643:	ba 03 00 00 00       	mov    $0x3,%edx
f0100648:	b8 fb 03 00 00       	mov    $0x3fb,%eax
f010064d:	e8 a0 fc ff ff       	call   f01002f2 <outb>

	// No modem controls
	outb(COM1+COM_MCR, 0);
f0100652:	ba 00 00 00 00       	mov    $0x0,%edx
f0100657:	b8 fc 03 00 00       	mov    $0x3fc,%eax
f010065c:	e8 91 fc ff ff       	call   f01002f2 <outb>
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);
f0100661:	ba 01 00 00 00       	mov    $0x1,%edx
f0100666:	b8 f9 03 00 00       	mov    $0x3f9,%eax
f010066b:	e8 82 fc ff ff       	call   f01002f2 <outb>

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100670:	b8 fd 03 00 00       	mov    $0x3fd,%eax
f0100675:	e8 70 fc ff ff       	call   f01002ea <inb>
f010067a:	89 c3                	mov    %eax,%ebx
f010067c:	3c ff                	cmp    $0xff,%al
f010067e:	0f 95 05 34 a2 21 f0 	setne  0xf021a234
	(void) inb(COM1+COM_IIR);
f0100685:	b8 fa 03 00 00       	mov    $0x3fa,%eax
f010068a:	e8 5b fc ff ff       	call   f01002ea <inb>
	(void) inb(COM1+COM_RX);
f010068f:	b8 f8 03 00 00       	mov    $0x3f8,%eax
f0100694:	e8 51 fc ff ff       	call   f01002ea <inb>

	// Enable serial interrupts
	if (serial_exists)
f0100699:	80 fb ff             	cmp    $0xff,%bl
f010069c:	74 18                	je     f01006b6 <serial_init+0xb6>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010069e:	83 ec 0c             	sub    $0xc,%esp
f01006a1:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f01006a8:	25 ef ff 00 00       	and    $0xffef,%eax
f01006ad:	50                   	push   %eax
f01006ae:	e8 e5 2e 00 00       	call   f0103598 <irq_setmask_8259A>
f01006b3:	83 c4 10             	add    $0x10,%esp
}
f01006b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01006b9:	c9                   	leave  
f01006ba:	c3                   	ret    

f01006bb <cga_putc>:



static void
cga_putc(int c)
{
f01006bb:	55                   	push   %ebp
f01006bc:	89 e5                	mov    %esp,%ebp
f01006be:	57                   	push   %edi
f01006bf:	56                   	push   %esi
f01006c0:	53                   	push   %ebx
f01006c1:	83 ec 0c             	sub    $0xc,%esp
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f01006c4:	89 c1                	mov    %eax,%ecx
f01006c6:	81 e1 00 ff ff ff    	and    $0xffffff00,%ecx
		c |= 0x0700;
f01006cc:	89 c2                	mov    %eax,%edx
f01006ce:	80 ce 07             	or     $0x7,%dh
f01006d1:	85 c9                	test   %ecx,%ecx
f01006d3:	0f 44 c2             	cmove  %edx,%eax

	switch (c & 0xff) {
f01006d6:	0f b6 d0             	movzbl %al,%edx
f01006d9:	83 fa 09             	cmp    $0x9,%edx
f01006dc:	74 72                	je     f0100750 <cga_putc+0x95>
f01006de:	83 fa 09             	cmp    $0x9,%edx
f01006e1:	7f 0a                	jg     f01006ed <cga_putc+0x32>
f01006e3:	83 fa 08             	cmp    $0x8,%edx
f01006e6:	74 14                	je     f01006fc <cga_putc+0x41>
f01006e8:	e9 97 00 00 00       	jmp    f0100784 <cga_putc+0xc9>
f01006ed:	83 fa 0a             	cmp    $0xa,%edx
f01006f0:	74 38                	je     f010072a <cga_putc+0x6f>
f01006f2:	83 fa 0d             	cmp    $0xd,%edx
f01006f5:	74 3b                	je     f0100732 <cga_putc+0x77>
f01006f7:	e9 88 00 00 00       	jmp    f0100784 <cga_putc+0xc9>
	case '\b':
		if (crt_pos > 0) {
f01006fc:	0f b7 15 28 a2 21 f0 	movzwl 0xf021a228,%edx
f0100703:	66 85 d2             	test   %dx,%dx
f0100706:	0f 84 e4 00 00 00    	je     f01007f0 <cga_putc+0x135>
			crt_pos--;
f010070c:	83 ea 01             	sub    $0x1,%edx
f010070f:	66 89 15 28 a2 21 f0 	mov    %dx,0xf021a228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100716:	0f b7 d2             	movzwl %dx,%edx
f0100719:	b0 00                	mov    $0x0,%al
f010071b:	83 c8 20             	or     $0x20,%eax
f010071e:	8b 0d 2c a2 21 f0    	mov    0xf021a22c,%ecx
f0100724:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
f0100728:	eb 78                	jmp    f01007a2 <cga_putc+0xe7>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f010072a:	66 83 05 28 a2 21 f0 	addw   $0x50,0xf021a228
f0100731:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100732:	0f b7 05 28 a2 21 f0 	movzwl 0xf021a228,%eax
f0100739:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010073f:	c1 e8 16             	shr    $0x16,%eax
f0100742:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100745:	c1 e0 04             	shl    $0x4,%eax
f0100748:	66 a3 28 a2 21 f0    	mov    %ax,0xf021a228
		break;
f010074e:	eb 52                	jmp    f01007a2 <cga_putc+0xe7>
	case '\t':
		cons_putc(' ');
f0100750:	b8 20 00 00 00       	mov    $0x20,%eax
f0100755:	e8 da 00 00 00       	call   f0100834 <cons_putc>
		cons_putc(' ');
f010075a:	b8 20 00 00 00       	mov    $0x20,%eax
f010075f:	e8 d0 00 00 00       	call   f0100834 <cons_putc>
		cons_putc(' ');
f0100764:	b8 20 00 00 00       	mov    $0x20,%eax
f0100769:	e8 c6 00 00 00       	call   f0100834 <cons_putc>
		cons_putc(' ');
f010076e:	b8 20 00 00 00       	mov    $0x20,%eax
f0100773:	e8 bc 00 00 00       	call   f0100834 <cons_putc>
		cons_putc(' ');
f0100778:	b8 20 00 00 00       	mov    $0x20,%eax
f010077d:	e8 b2 00 00 00       	call   f0100834 <cons_putc>
		break;
f0100782:	eb 1e                	jmp    f01007a2 <cga_putc+0xe7>
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f0100784:	0f b7 15 28 a2 21 f0 	movzwl 0xf021a228,%edx
f010078b:	8d 4a 01             	lea    0x1(%edx),%ecx
f010078e:	66 89 0d 28 a2 21 f0 	mov    %cx,0xf021a228
f0100795:	0f b7 d2             	movzwl %dx,%edx
f0100798:	8b 0d 2c a2 21 f0    	mov    0xf021a22c,%ecx
f010079e:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f01007a2:	66 81 3d 28 a2 21 f0 	cmpw   $0x7cf,0xf021a228
f01007a9:	cf 07 
f01007ab:	76 43                	jbe    f01007f0 <cga_putc+0x135>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01007ad:	a1 2c a2 21 f0       	mov    0xf021a22c,%eax
f01007b2:	83 ec 04             	sub    $0x4,%esp
f01007b5:	68 00 0f 00 00       	push   $0xf00
f01007ba:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01007c0:	52                   	push   %edx
f01007c1:	50                   	push   %eax
f01007c2:	e8 b0 4d 00 00       	call   f0105577 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f01007c7:	8b 15 2c a2 21 f0    	mov    0xf021a22c,%edx
f01007cd:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01007d3:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01007d9:	83 c4 10             	add    $0x10,%esp
f01007dc:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01007e1:	83 c0 02             	add    $0x2,%eax
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01007e4:	39 d0                	cmp    %edx,%eax
f01007e6:	75 f4                	jne    f01007dc <cga_putc+0x121>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f01007e8:	66 83 2d 28 a2 21 f0 	subw   $0x50,0xf021a228
f01007ef:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f01007f0:	8b 3d 30 a2 21 f0    	mov    0xf021a230,%edi
f01007f6:	ba 0e 00 00 00       	mov    $0xe,%edx
f01007fb:	89 f8                	mov    %edi,%eax
f01007fd:	e8 f0 fa ff ff       	call   f01002f2 <outb>
	outb(addr_6845 + 1, crt_pos >> 8);
f0100802:	0f b7 1d 28 a2 21 f0 	movzwl 0xf021a228,%ebx
f0100809:	8d 77 01             	lea    0x1(%edi),%esi
f010080c:	0f b6 d7             	movzbl %bh,%edx
f010080f:	89 f0                	mov    %esi,%eax
f0100811:	e8 dc fa ff ff       	call   f01002f2 <outb>
	outb(addr_6845, 15);
f0100816:	ba 0f 00 00 00       	mov    $0xf,%edx
f010081b:	89 f8                	mov    %edi,%eax
f010081d:	e8 d0 fa ff ff       	call   f01002f2 <outb>
	outb(addr_6845 + 1, crt_pos);
f0100822:	0f b6 d3             	movzbl %bl,%edx
f0100825:	89 f0                	mov    %esi,%eax
f0100827:	e8 c6 fa ff ff       	call   f01002f2 <outb>
}
f010082c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010082f:	5b                   	pop    %ebx
f0100830:	5e                   	pop    %esi
f0100831:	5f                   	pop    %edi
f0100832:	5d                   	pop    %ebp
f0100833:	c3                   	ret    

f0100834 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100834:	55                   	push   %ebp
f0100835:	89 e5                	mov    %esp,%ebp
f0100837:	53                   	push   %ebx
f0100838:	83 ec 04             	sub    $0x4,%esp
f010083b:	89 c3                	mov    %eax,%ebx
	serial_putc(c);
f010083d:	e8 10 fb ff ff       	call   f0100352 <serial_putc>
	lpt_putc(c);
f0100842:	89 d8                	mov    %ebx,%eax
f0100844:	e8 48 fb ff ff       	call   f0100391 <lpt_putc>
	cga_putc(c);
f0100849:	89 d8                	mov    %ebx,%eax
f010084b:	e8 6b fe ff ff       	call   f01006bb <cga_putc>
}
f0100850:	83 c4 04             	add    $0x4,%esp
f0100853:	5b                   	pop    %ebx
f0100854:	5d                   	pop    %ebp
f0100855:	c3                   	ret    

f0100856 <serial_intr>:
}

void
serial_intr(void)
{
	if (serial_exists)
f0100856:	80 3d 34 a2 21 f0 00 	cmpb   $0x0,0xf021a234
f010085d:	74 11                	je     f0100870 <serial_intr+0x1a>
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f010085f:	55                   	push   %ebp
f0100860:	89 e5                	mov    %esp,%ebp
f0100862:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
		cons_intr(serial_proc_data);
f0100865:	b8 2b 03 10 f0       	mov    $0xf010032b,%eax
f010086a:	e8 22 fc ff ff       	call   f0100491 <cons_intr>
}
f010086f:	c9                   	leave  
f0100870:	f3 c3                	repz ret 

f0100872 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f0100872:	55                   	push   %ebp
f0100873:	89 e5                	mov    %esp,%ebp
f0100875:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100878:	b8 d4 04 10 f0       	mov    $0xf01004d4,%eax
f010087d:	e8 0f fc ff ff       	call   f0100491 <cons_intr>
}
f0100882:	c9                   	leave  
f0100883:	c3                   	ret    

f0100884 <kbd_init>:

static void
kbd_init(void)
{
f0100884:	55                   	push   %ebp
f0100885:	89 e5                	mov    %esp,%ebp
f0100887:	83 ec 08             	sub    $0x8,%esp
	// Drain the kbd buffer so that QEMU generates interrupts.
	kbd_intr();
f010088a:	e8 e3 ff ff ff       	call   f0100872 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f010088f:	83 ec 0c             	sub    $0xc,%esp
f0100892:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f0100899:	25 fd ff 00 00       	and    $0xfffd,%eax
f010089e:	50                   	push   %eax
f010089f:	e8 f4 2c 00 00       	call   f0103598 <irq_setmask_8259A>
}
f01008a4:	83 c4 10             	add    $0x10,%esp
f01008a7:	c9                   	leave  
f01008a8:	c3                   	ret    

f01008a9 <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f01008a9:	55                   	push   %ebp
f01008aa:	89 e5                	mov    %esp,%ebp
f01008ac:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f01008af:	e8 a2 ff ff ff       	call   f0100856 <serial_intr>
	kbd_intr();
f01008b4:	e8 b9 ff ff ff       	call   f0100872 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f01008b9:	a1 20 a2 21 f0       	mov    0xf021a220,%eax
f01008be:	3b 05 24 a2 21 f0    	cmp    0xf021a224,%eax
f01008c4:	74 26                	je     f01008ec <cons_getc+0x43>
		c = cons.buf[cons.rpos++];
f01008c6:	8d 50 01             	lea    0x1(%eax),%edx
f01008c9:	89 15 20 a2 21 f0    	mov    %edx,0xf021a220
f01008cf:	0f b6 88 20 a0 21 f0 	movzbl -0xfde5fe0(%eax),%ecx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
f01008d6:	89 c8                	mov    %ecx,%eax
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
f01008d8:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01008de:	75 11                	jne    f01008f1 <cons_getc+0x48>
			cons.rpos = 0;
f01008e0:	c7 05 20 a2 21 f0 00 	movl   $0x0,0xf021a220
f01008e7:	00 00 00 
f01008ea:	eb 05                	jmp    f01008f1 <cons_getc+0x48>
		return c;
	}
	return 0;
f01008ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01008f1:	c9                   	leave  
f01008f2:	c3                   	ret    

f01008f3 <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f01008f3:	55                   	push   %ebp
f01008f4:	89 e5                	mov    %esp,%ebp
f01008f6:	83 ec 08             	sub    $0x8,%esp
	cga_init();
f01008f9:	e8 f0 fa ff ff       	call   f01003ee <cga_init>
	kbd_init();
f01008fe:	e8 81 ff ff ff       	call   f0100884 <kbd_init>
	serial_init();
f0100903:	e8 f8 fc ff ff       	call   f0100600 <serial_init>

	if (!serial_exists)
f0100908:	80 3d 34 a2 21 f0 00 	cmpb   $0x0,0xf021a234
f010090f:	75 10                	jne    f0100921 <cons_init+0x2e>
		cprintf("Serial port does not exist!\n");
f0100911:	83 ec 0c             	sub    $0xc,%esp
f0100914:	68 5d 63 10 f0       	push   $0xf010635d
f0100919:	e8 3d 2e 00 00       	call   f010375b <cprintf>
f010091e:	83 c4 10             	add    $0x10,%esp
}
f0100921:	c9                   	leave  
f0100922:	c3                   	ret    

f0100923 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100923:	55                   	push   %ebp
f0100924:	89 e5                	mov    %esp,%ebp
f0100926:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100929:	8b 45 08             	mov    0x8(%ebp),%eax
f010092c:	e8 03 ff ff ff       	call   f0100834 <cons_putc>
}
f0100931:	c9                   	leave  
f0100932:	c3                   	ret    

f0100933 <getchar>:

int
getchar(void)
{
f0100933:	55                   	push   %ebp
f0100934:	89 e5                	mov    %esp,%ebp
f0100936:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100939:	e8 6b ff ff ff       	call   f01008a9 <cons_getc>
f010093e:	85 c0                	test   %eax,%eax
f0100940:	74 f7                	je     f0100939 <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100942:	c9                   	leave  
f0100943:	c3                   	ret    

f0100944 <iscons>:

int
iscons(int fdnum)
{
f0100944:	55                   	push   %ebp
f0100945:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100947:	b8 01 00 00 00       	mov    $0x1,%eax
f010094c:	5d                   	pop    %ebp
f010094d:	c3                   	ret    

f010094e <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f010094e:	55                   	push   %ebp
f010094f:	89 e5                	mov    %esp,%ebp
f0100951:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100954:	68 a0 65 10 f0       	push   $0xf01065a0
f0100959:	68 be 65 10 f0       	push   $0xf01065be
f010095e:	68 c3 65 10 f0       	push   $0xf01065c3
f0100963:	e8 f3 2d 00 00       	call   f010375b <cprintf>
f0100968:	83 c4 0c             	add    $0xc,%esp
f010096b:	68 2c 66 10 f0       	push   $0xf010662c
f0100970:	68 cc 65 10 f0       	push   $0xf01065cc
f0100975:	68 c3 65 10 f0       	push   $0xf01065c3
f010097a:	e8 dc 2d 00 00       	call   f010375b <cprintf>
	return 0;
}
f010097f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100984:	c9                   	leave  
f0100985:	c3                   	ret    

f0100986 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100986:	55                   	push   %ebp
f0100987:	89 e5                	mov    %esp,%ebp
f0100989:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010098c:	68 d5 65 10 f0       	push   $0xf01065d5
f0100991:	e8 c5 2d 00 00       	call   f010375b <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100996:	83 c4 08             	add    $0x8,%esp
f0100999:	68 0c 00 10 00       	push   $0x10000c
f010099e:	68 54 66 10 f0       	push   $0xf0106654
f01009a3:	e8 b3 2d 00 00       	call   f010375b <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01009a8:	83 c4 0c             	add    $0xc,%esp
f01009ab:	68 0c 00 10 00       	push   $0x10000c
f01009b0:	68 0c 00 10 f0       	push   $0xf010000c
f01009b5:	68 7c 66 10 f0       	push   $0xf010667c
f01009ba:	e8 9c 2d 00 00       	call   f010375b <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01009bf:	83 c4 0c             	add    $0xc,%esp
f01009c2:	68 71 62 10 00       	push   $0x106271
f01009c7:	68 71 62 10 f0       	push   $0xf0106271
f01009cc:	68 a0 66 10 f0       	push   $0xf01066a0
f01009d1:	e8 85 2d 00 00       	call   f010375b <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01009d6:	83 c4 0c             	add    $0xc,%esp
f01009d9:	68 7c 97 21 00       	push   $0x21977c
f01009de:	68 7c 97 21 f0       	push   $0xf021977c
f01009e3:	68 c4 66 10 f0       	push   $0xf01066c4
f01009e8:	e8 6e 2d 00 00       	call   f010375b <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01009ed:	83 c4 0c             	add    $0xc,%esp
f01009f0:	68 08 c0 25 00       	push   $0x25c008
f01009f5:	68 08 c0 25 f0       	push   $0xf025c008
f01009fa:	68 e8 66 10 f0       	push   $0xf01066e8
f01009ff:	e8 57 2d 00 00       	call   f010375b <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f0100a04:	b8 07 c4 25 f0       	mov    $0xf025c407,%eax
f0100a09:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100a0e:	83 c4 08             	add    $0x8,%esp
f0100a11:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0100a16:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f0100a1c:	85 c0                	test   %eax,%eax
f0100a1e:	0f 48 c2             	cmovs  %edx,%eax
f0100a21:	c1 f8 0a             	sar    $0xa,%eax
f0100a24:	50                   	push   %eax
f0100a25:	68 0c 67 10 f0       	push   $0xf010670c
f0100a2a:	e8 2c 2d 00 00       	call   f010375b <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f0100a2f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a34:	c9                   	leave  
f0100a35:	c3                   	ret    

f0100a36 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f0100a36:	55                   	push   %ebp
f0100a37:	89 e5                	mov    %esp,%ebp
f0100a39:	57                   	push   %edi
f0100a3a:	56                   	push   %esi
f0100a3b:	53                   	push   %ebx
f0100a3c:	83 ec 5c             	sub    $0x5c,%esp
f0100a3f:	89 c3                	mov    %eax,%ebx
f0100a41:	89 55 a4             	mov    %edx,-0x5c(%ebp)
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100a44:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100a4b:	be 00 00 00 00       	mov    $0x0,%esi
f0100a50:	eb 0a                	jmp    f0100a5c <runcmd+0x26>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100a52:	c6 03 00             	movb   $0x0,(%ebx)
f0100a55:	89 f7                	mov    %esi,%edi
f0100a57:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100a5a:	89 fe                	mov    %edi,%esi
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a5c:	0f b6 03             	movzbl (%ebx),%eax
f0100a5f:	84 c0                	test   %al,%al
f0100a61:	74 6d                	je     f0100ad0 <runcmd+0x9a>
f0100a63:	83 ec 08             	sub    $0x8,%esp
f0100a66:	0f be c0             	movsbl %al,%eax
f0100a69:	50                   	push   %eax
f0100a6a:	68 ee 65 10 f0       	push   $0xf01065ee
f0100a6f:	e8 78 4a 00 00       	call   f01054ec <strchr>
f0100a74:	83 c4 10             	add    $0x10,%esp
f0100a77:	85 c0                	test   %eax,%eax
f0100a79:	75 d7                	jne    f0100a52 <runcmd+0x1c>
			*buf++ = 0;
		if (*buf == 0)
f0100a7b:	0f b6 03             	movzbl (%ebx),%eax
f0100a7e:	84 c0                	test   %al,%al
f0100a80:	74 4e                	je     f0100ad0 <runcmd+0x9a>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a82:	83 fe 0f             	cmp    $0xf,%esi
f0100a85:	75 1c                	jne    f0100aa3 <runcmd+0x6d>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a87:	83 ec 08             	sub    $0x8,%esp
f0100a8a:	6a 10                	push   $0x10
f0100a8c:	68 f3 65 10 f0       	push   $0xf01065f3
f0100a91:	e8 c5 2c 00 00       	call   f010375b <cprintf>
			return 0;
f0100a96:	83 c4 10             	add    $0x10,%esp
f0100a99:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a9e:	e9 ac 00 00 00       	jmp    f0100b4f <runcmd+0x119>
		}
		argv[argc++] = buf;
f0100aa3:	8d 7e 01             	lea    0x1(%esi),%edi
f0100aa6:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100aaa:	eb 0a                	jmp    f0100ab6 <runcmd+0x80>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
f0100aac:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100aaf:	0f b6 03             	movzbl (%ebx),%eax
f0100ab2:	84 c0                	test   %al,%al
f0100ab4:	74 a4                	je     f0100a5a <runcmd+0x24>
f0100ab6:	83 ec 08             	sub    $0x8,%esp
f0100ab9:	0f be c0             	movsbl %al,%eax
f0100abc:	50                   	push   %eax
f0100abd:	68 ee 65 10 f0       	push   $0xf01065ee
f0100ac2:	e8 25 4a 00 00       	call   f01054ec <strchr>
f0100ac7:	83 c4 10             	add    $0x10,%esp
f0100aca:	85 c0                	test   %eax,%eax
f0100acc:	74 de                	je     f0100aac <runcmd+0x76>
f0100ace:	eb 8a                	jmp    f0100a5a <runcmd+0x24>
			buf++;
	}
	argv[argc] = 0;
f0100ad0:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100ad7:	00 

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
f0100ad8:	b8 00 00 00 00       	mov    $0x0,%eax
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
f0100add:	85 f6                	test   %esi,%esi
f0100adf:	74 6e                	je     f0100b4f <runcmd+0x119>
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100ae1:	83 ec 08             	sub    $0x8,%esp
f0100ae4:	68 be 65 10 f0       	push   $0xf01065be
f0100ae9:	ff 75 a8             	pushl  -0x58(%ebp)
f0100aec:	e8 9d 49 00 00       	call   f010548e <strcmp>
f0100af1:	83 c4 10             	add    $0x10,%esp
f0100af4:	85 c0                	test   %eax,%eax
f0100af6:	74 1e                	je     f0100b16 <runcmd+0xe0>
f0100af8:	83 ec 08             	sub    $0x8,%esp
f0100afb:	68 cc 65 10 f0       	push   $0xf01065cc
f0100b00:	ff 75 a8             	pushl  -0x58(%ebp)
f0100b03:	e8 86 49 00 00       	call   f010548e <strcmp>
f0100b08:	83 c4 10             	add    $0x10,%esp
f0100b0b:	85 c0                	test   %eax,%eax
f0100b0d:	75 28                	jne    f0100b37 <runcmd+0x101>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100b0f:	b8 01 00 00 00       	mov    $0x1,%eax
f0100b14:	eb 05                	jmp    f0100b1b <runcmd+0xe5>
		if (strcmp(argv[0], commands[i].name) == 0)
f0100b16:	b8 00 00 00 00       	mov    $0x0,%eax
			return commands[i].func(argc, argv, tf);
f0100b1b:	83 ec 04             	sub    $0x4,%esp
f0100b1e:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0100b21:	01 d0                	add    %edx,%eax
f0100b23:	ff 75 a4             	pushl  -0x5c(%ebp)
f0100b26:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100b29:	52                   	push   %edx
f0100b2a:	56                   	push   %esi
f0100b2b:	ff 14 85 8c 67 10 f0 	call   *-0xfef9874(,%eax,4)
f0100b32:	83 c4 10             	add    $0x10,%esp
f0100b35:	eb 18                	jmp    f0100b4f <runcmd+0x119>
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100b37:	83 ec 08             	sub    $0x8,%esp
f0100b3a:	ff 75 a8             	pushl  -0x58(%ebp)
f0100b3d:	68 10 66 10 f0       	push   $0xf0106610
f0100b42:	e8 14 2c 00 00       	call   f010375b <cprintf>
	return 0;
f0100b47:	83 c4 10             	add    $0x10,%esp
f0100b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100b4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b52:	5b                   	pop    %ebx
f0100b53:	5e                   	pop    %esi
f0100b54:	5f                   	pop    %edi
f0100b55:	5d                   	pop    %ebp
f0100b56:	c3                   	ret    

f0100b57 <mon_backtrace>:
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100b57:	55                   	push   %ebp
f0100b58:	89 e5                	mov    %esp,%ebp
	// Your code here.
	return 0;
}
f0100b5a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b5f:	5d                   	pop    %ebp
f0100b60:	c3                   	ret    

f0100b61 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100b61:	55                   	push   %ebp
f0100b62:	89 e5                	mov    %esp,%ebp
f0100b64:	53                   	push   %ebx
f0100b65:	83 ec 10             	sub    $0x10,%esp
f0100b68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100b6b:	68 38 67 10 f0       	push   $0xf0106738
f0100b70:	e8 e6 2b 00 00       	call   f010375b <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100b75:	c7 04 24 5c 67 10 f0 	movl   $0xf010675c,(%esp)
f0100b7c:	e8 da 2b 00 00       	call   f010375b <cprintf>

	if (tf != NULL)
f0100b81:	83 c4 10             	add    $0x10,%esp
f0100b84:	85 db                	test   %ebx,%ebx
f0100b86:	74 0c                	je     f0100b94 <monitor+0x33>
		print_trapframe(tf);
f0100b88:	83 ec 0c             	sub    $0xc,%esp
f0100b8b:	53                   	push   %ebx
f0100b8c:	e8 a0 30 00 00       	call   f0103c31 <print_trapframe>
f0100b91:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100b94:	83 ec 0c             	sub    $0xc,%esp
f0100b97:	68 26 66 10 f0       	push   $0xf0106626
f0100b9c:	e8 19 47 00 00       	call   f01052ba <readline>
		if (buf != NULL)
f0100ba1:	83 c4 10             	add    $0x10,%esp
f0100ba4:	85 c0                	test   %eax,%eax
f0100ba6:	74 ec                	je     f0100b94 <monitor+0x33>
			if (runcmd(buf, tf) < 0)
f0100ba8:	89 da                	mov    %ebx,%edx
f0100baa:	e8 87 fe ff ff       	call   f0100a36 <runcmd>
f0100baf:	85 c0                	test   %eax,%eax
f0100bb1:	79 e1                	jns    f0100b94 <monitor+0x33>
				break;
	}
}
f0100bb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100bb6:	c9                   	leave  
f0100bb7:	c3                   	ret    

f0100bb8 <invlpg>:
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
}

static inline void
invlpg(void *addr)
{
f0100bb8:	55                   	push   %ebp
f0100bb9:	89 e5                	mov    %esp,%ebp
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100bbb:	0f 01 38             	invlpg (%eax)
}
f0100bbe:	5d                   	pop    %ebp
f0100bbf:	c3                   	ret    

f0100bc0 <lcr0>:
	asm volatile("ltr %0" : : "r" (sel));
}

static inline void
lcr0(uint32_t val)
{
f0100bc0:	55                   	push   %ebp
f0100bc1:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0100bc3:	0f 22 c0             	mov    %eax,%cr0
}
f0100bc6:	5d                   	pop    %ebp
f0100bc7:	c3                   	ret    

f0100bc8 <rcr0>:

static inline uint32_t
rcr0(void)
{
f0100bc8:	55                   	push   %ebp
f0100bc9:	89 e5                	mov    %esp,%ebp
	uint32_t val;
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0100bcb:	0f 20 c0             	mov    %cr0,%eax
	return val;
}
f0100bce:	5d                   	pop    %ebp
f0100bcf:	c3                   	ret    

f0100bd0 <lcr3>:
	return val;
}

static inline void
lcr3(uint32_t val)
{
f0100bd0:	55                   	push   %ebp
f0100bd1:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100bd3:	0f 22 d8             	mov    %eax,%cr3
}
f0100bd6:	5d                   	pop    %ebp
f0100bd7:	c3                   	ret    

f0100bd8 <page2pa>:
int	user_mem_check(struct Env *env, const void *va, size_t len, int perm);
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
f0100bd8:	55                   	push   %ebp
f0100bd9:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
f0100bdb:	2b 05 90 ae 21 f0    	sub    0xf021ae90,%eax
f0100be1:	c1 f8 03             	sar    $0x3,%eax
f0100be4:	c1 e0 0c             	shl    $0xc,%eax
}
f0100be7:	5d                   	pop    %ebp
f0100be8:	c3                   	ret    

f0100be9 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100be9:	55                   	push   %ebp
f0100bea:	89 e5                	mov    %esp,%ebp
f0100bec:	56                   	push   %esi
f0100bed:	53                   	push   %ebx
f0100bee:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100bf0:	83 ec 0c             	sub    $0xc,%esp
f0100bf3:	50                   	push   %eax
f0100bf4:	e8 52 29 00 00       	call   f010354b <mc146818_read>
f0100bf9:	89 c6                	mov    %eax,%esi
f0100bfb:	83 c3 01             	add    $0x1,%ebx
f0100bfe:	89 1c 24             	mov    %ebx,(%esp)
f0100c01:	e8 45 29 00 00       	call   f010354b <mc146818_read>
f0100c06:	c1 e0 08             	shl    $0x8,%eax
f0100c09:	09 f0                	or     %esi,%eax
}
f0100c0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100c0e:	5b                   	pop    %ebx
f0100c0f:	5e                   	pop    %esi
f0100c10:	5d                   	pop    %ebp
f0100c11:	c3                   	ret    

f0100c12 <i386_detect_memory>:

static void
i386_detect_memory(void)
{
f0100c12:	55                   	push   %ebp
f0100c13:	89 e5                	mov    %esp,%ebp
f0100c15:	56                   	push   %esi
f0100c16:	53                   	push   %ebx
	size_t basemem, extmem, ext16mem, totalmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	basemem = nvram_read(NVRAM_BASELO);
f0100c17:	b8 15 00 00 00       	mov    $0x15,%eax
f0100c1c:	e8 c8 ff ff ff       	call   f0100be9 <nvram_read>
f0100c21:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0100c23:	b8 17 00 00 00       	mov    $0x17,%eax
f0100c28:	e8 bc ff ff ff       	call   f0100be9 <nvram_read>
f0100c2d:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0100c2f:	b8 34 00 00 00       	mov    $0x34,%eax
f0100c34:	e8 b0 ff ff ff       	call   f0100be9 <nvram_read>
f0100c39:	c1 e0 06             	shl    $0x6,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (ext16mem)
f0100c3c:	85 c0                	test   %eax,%eax
f0100c3e:	74 07                	je     f0100c47 <i386_detect_memory+0x35>
		totalmem = 16 * 1024 + ext16mem;
f0100c40:	05 00 40 00 00       	add    $0x4000,%eax
f0100c45:	eb 0b                	jmp    f0100c52 <i386_detect_memory+0x40>
	else if (extmem)
		totalmem = 1 * 1024 + extmem;
f0100c47:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0100c4d:	85 f6                	test   %esi,%esi
f0100c4f:	0f 44 c3             	cmove  %ebx,%eax
	else
		totalmem = basemem;

	npages = totalmem / (PGSIZE / 1024);
f0100c52:	89 c2                	mov    %eax,%edx
f0100c54:	c1 ea 02             	shr    $0x2,%edx
f0100c57:	89 15 88 ae 21 f0    	mov    %edx,0xf021ae88
	npages_basemem = basemem / (PGSIZE / 1024);
f0100c5d:	89 da                	mov    %ebx,%edx
f0100c5f:	c1 ea 02             	shr    $0x2,%edx
f0100c62:	89 15 44 a2 21 f0    	mov    %edx,0xf021a244

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0100c68:	89 c2                	mov    %eax,%edx
f0100c6a:	29 da                	sub    %ebx,%edx
f0100c6c:	52                   	push   %edx
f0100c6d:	53                   	push   %ebx
f0100c6e:	50                   	push   %eax
f0100c6f:	68 9c 67 10 f0       	push   $0xf010679c
f0100c74:	e8 e2 2a 00 00       	call   f010375b <cprintf>
	        totalmem,
	        basemem,
	        totalmem - basemem);
}
f0100c79:	83 c4 10             	add    $0x10,%esp
f0100c7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100c7f:	5b                   	pop    %ebx
f0100c80:	5e                   	pop    %esi
f0100c81:	5d                   	pop    %ebp
f0100c82:	c3                   	ret    

f0100c83 <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100c83:	55                   	push   %ebp
f0100c84:	89 e5                	mov    %esp,%ebp
f0100c86:	53                   	push   %ebx
f0100c87:	83 ec 04             	sub    $0x4,%esp
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100c8a:	83 3d 38 a2 21 f0 00 	cmpl   $0x0,0xf021a238
f0100c91:	75 67                	jne    f0100cfa <boot_alloc+0x77>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100c93:	ba 07 d0 25 f0       	mov    $0xf025d007,%edx
f0100c98:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100c9e:	89 15 38 a2 21 f0    	mov    %edx,0xf021a238
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	if(n==0){
f0100ca4:	85 c0                	test   %eax,%eax
f0100ca6:	75 07                	jne    f0100caf <boot_alloc+0x2c>
		return nextfree;
f0100ca8:	a1 38 a2 21 f0       	mov    0xf021a238,%eax
f0100cad:	eb 51                	jmp    f0100d00 <boot_alloc+0x7d>
	}

	if(n > 0){
		int max_mem = npages* PGSIZE;
f0100caf:	8b 0d 88 ae 21 f0    	mov    0xf021ae88,%ecx
f0100cb5:	c1 e1 0c             	shl    $0xc,%ecx
		result = ROUNDUP(nextfree, PGSIZE); // Devuelvo la posicion del primer byte libre
f0100cb8:	8b 1d 38 a2 21 f0    	mov    0xf021a238,%ebx
f0100cbe:	8d 93 ff 0f 00 00    	lea    0xfff(%ebx),%edx
f0100cc4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		nextfree+= n;		// Sumo la cantidad de bytes al puntero de nextfree
		nextfree = ROUNDUP(nextfree,PGSIZE);
f0100cca:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
f0100cd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100cd6:	a3 38 a2 21 f0       	mov    %eax,0xf021a238
		if((int)nextfree> max_mem){
f0100cdb:	39 c1                	cmp    %eax,%ecx
f0100cdd:	7d 17                	jge    f0100cf6 <boot_alloc+0x73>
			panic("boot_alloc: Se ha excedido el maximo de memoria");
f0100cdf:	83 ec 04             	sub    $0x4,%esp
f0100ce2:	68 d8 67 10 f0       	push   $0xf01067d8
f0100ce7:	68 80 00 00 00       	push   $0x80
f0100cec:	68 81 71 10 f0       	push   $0xf0107181
f0100cf1:	e8 7c f3 ff ff       	call   f0100072 <_panic>
		return nextfree;
	}

	if(n > 0){
		int max_mem = npages* PGSIZE;
		result = ROUNDUP(nextfree, PGSIZE); // Devuelvo la posicion del primer byte libre
f0100cf6:	89 d0                	mov    %edx,%eax
f0100cf8:	eb 06                	jmp    f0100d00 <boot_alloc+0x7d>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	if(n==0){
f0100cfa:	85 c0                	test   %eax,%eax
f0100cfc:	74 aa                	je     f0100ca8 <boot_alloc+0x25>
f0100cfe:	eb af                	jmp    f0100caf <boot_alloc+0x2c>
		if((int)nextfree> max_mem){
			panic("boot_alloc: Se ha excedido el maximo de memoria");
		}
	}
	return result;
}
f0100d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100d03:	c9                   	leave  
f0100d04:	c3                   	ret    

f0100d05 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0100d05:	55                   	push   %ebp
f0100d06:	89 e5                	mov    %esp,%ebp
f0100d08:	53                   	push   %ebx
f0100d09:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0100d0c:	89 cb                	mov    %ecx,%ebx
f0100d0e:	c1 eb 0c             	shr    $0xc,%ebx
f0100d11:	3b 1d 88 ae 21 f0    	cmp    0xf021ae88,%ebx
f0100d17:	72 0d                	jb     f0100d26 <_kaddr+0x21>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d19:	51                   	push   %ecx
f0100d1a:	68 ac 62 10 f0       	push   $0xf01062ac
f0100d1f:	52                   	push   %edx
f0100d20:	50                   	push   %eax
f0100d21:	e8 4c f3 ff ff       	call   f0100072 <_panic>
	return (void *)(pa + KERNBASE);
f0100d26:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0100d2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100d2f:	c9                   	leave  
f0100d30:	c3                   	ret    

f0100d31 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0100d31:	55                   	push   %ebp
f0100d32:	89 e5                	mov    %esp,%ebp
f0100d34:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
f0100d37:	e8 9c fe ff ff       	call   f0100bd8 <page2pa>
f0100d3c:	89 c1                	mov    %eax,%ecx
f0100d3e:	ba 58 00 00 00       	mov    $0x58,%edx
f0100d43:	b8 8d 71 10 f0       	mov    $0xf010718d,%eax
f0100d48:	e8 b8 ff ff ff       	call   f0100d05 <_kaddr>
}
f0100d4d:	c9                   	leave  
f0100d4e:	c3                   	ret    

f0100d4f <check_va2pa>:
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
f0100d4f:	89 d1                	mov    %edx,%ecx
f0100d51:	c1 e9 16             	shr    $0x16,%ecx
f0100d54:	8b 0c 88             	mov    (%eax,%ecx,4),%ecx
f0100d57:	f6 c1 01             	test   $0x1,%cl
f0100d5a:	74 57                	je     f0100db3 <check_va2pa+0x64>
		return ~0;
	if (*pgdir & PTE_PS)
f0100d5c:	f6 c1 80             	test   $0x80,%cl
f0100d5f:	74 10                	je     f0100d71 <check_va2pa+0x22>
		return (physaddr_t) PGADDR(PDX(*pgdir), PTX(va), PGOFF(va));
f0100d61:	89 d0                	mov    %edx,%eax
f0100d63:	25 ff ff 3f 00       	and    $0x3fffff,%eax
f0100d68:	81 e1 00 00 c0 ff    	and    $0xffc00000,%ecx
f0100d6e:	09 c8                	or     %ecx,%eax
f0100d70:	c3                   	ret    
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100d71:	55                   	push   %ebp
f0100d72:	89 e5                	mov    %esp,%ebp
f0100d74:	53                   	push   %ebx
f0100d75:	83 ec 04             	sub    $0x4,%esp
f0100d78:	89 d3                	mov    %edx,%ebx
	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
	if (*pgdir & PTE_PS)
		return (physaddr_t) PGADDR(PDX(*pgdir), PTX(va), PGOFF(va));
	p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
f0100d7a:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0100d80:	ba e2 03 00 00       	mov    $0x3e2,%edx
f0100d85:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0100d8a:	e8 76 ff ff ff       	call   f0100d05 <_kaddr>
	if (!(p[PTX(va)] & PTE_P))
f0100d8f:	c1 eb 0c             	shr    $0xc,%ebx
f0100d92:	89 da                	mov    %ebx,%edx
f0100d94:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100d9a:	8b 04 90             	mov    (%eax,%edx,4),%eax
f0100d9d:	89 c2                	mov    %eax,%edx
f0100d9f:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100da2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100da7:	85 d2                	test   %edx,%edx
f0100da9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0100dae:	0f 44 c1             	cmove  %ecx,%eax
f0100db1:	eb 06                	jmp    f0100db9 <check_va2pa+0x6a>
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0100db3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100db8:	c3                   	ret    
		return (physaddr_t) PGADDR(PDX(*pgdir), PTX(va), PGOFF(va));
	p = (pte_t *) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0100db9:	83 c4 04             	add    $0x4,%esp
f0100dbc:	5b                   	pop    %ebx
f0100dbd:	5d                   	pop    %ebp
f0100dbe:	c3                   	ret    

f0100dbf <_paddr>:
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0100dbf:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0100dc5:	77 13                	ja     f0100dda <_paddr+0x1b>
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
f0100dc7:	55                   	push   %ebp
f0100dc8:	89 e5                	mov    %esp,%ebp
f0100dca:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100dcd:	51                   	push   %ecx
f0100dce:	68 d0 62 10 f0       	push   $0xf01062d0
f0100dd3:	52                   	push   %edx
f0100dd4:	50                   	push   %eax
f0100dd5:	e8 98 f2 ff ff       	call   f0100072 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0100dda:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0100de0:	c3                   	ret    

f0100de1 <check_kern_pgdir>:
// but it is a pretty good sanity check.
//

static void
check_kern_pgdir(void)
{
f0100de1:	55                   	push   %ebp
f0100de2:	89 e5                	mov    %esp,%ebp
f0100de4:	57                   	push   %edi
f0100de5:	56                   	push   %esi
f0100de6:	53                   	push   %ebx
f0100de7:	83 ec 1c             	sub    $0x1c,%esp
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0100dea:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi

	// check pages array
	n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f0100df0:	a1 88 ae 21 f0       	mov    0xf021ae88,%eax
f0100df5:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0100df8:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0100dff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100e04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0100e07:	a1 90 ae 21 f0       	mov    0xf021ae90,%eax
f0100e0c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0100e0f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100e14:	eb 46                	jmp    f0100e5c <check_kern_pgdir+0x7b>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0100e16:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0100e1c:	89 f8                	mov    %edi,%eax
f0100e1e:	e8 2c ff ff ff       	call   f0100d4f <check_va2pa>
f0100e23:	89 c6                	mov    %eax,%esi
f0100e25:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100e28:	ba 9e 03 00 00       	mov    $0x39e,%edx
f0100e2d:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0100e32:	e8 88 ff ff ff       	call   f0100dbf <_paddr>
f0100e37:	01 d8                	add    %ebx,%eax
f0100e39:	39 c6                	cmp    %eax,%esi
f0100e3b:	74 19                	je     f0100e56 <check_kern_pgdir+0x75>
f0100e3d:	68 08 68 10 f0       	push   $0xf0106808
f0100e42:	68 9b 71 10 f0       	push   $0xf010719b
f0100e47:	68 9e 03 00 00       	push   $0x39e
f0100e4c:	68 81 71 10 f0       	push   $0xf0107181
f0100e51:	e8 1c f2 ff ff       	call   f0100072 <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0100e56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100e5c:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0100e5f:	72 b5                	jb     f0100e16 <check_kern_pgdir+0x35>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV * sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0100e61:	a1 48 a2 21 f0       	mov    0xf021a248,%eax
f0100e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100e69:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100e6e:	8d 93 00 00 c0 ee    	lea    -0x11400000(%ebx),%edx
f0100e74:	89 f8                	mov    %edi,%eax
f0100e76:	e8 d4 fe ff ff       	call   f0100d4f <check_va2pa>
f0100e7b:	89 c6                	mov    %eax,%esi
f0100e7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0100e80:	ba a3 03 00 00       	mov    $0x3a3,%edx
f0100e85:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0100e8a:	e8 30 ff ff ff       	call   f0100dbf <_paddr>
f0100e8f:	01 d8                	add    %ebx,%eax
f0100e91:	39 c6                	cmp    %eax,%esi
f0100e93:	74 19                	je     f0100eae <check_kern_pgdir+0xcd>
f0100e95:	68 3c 68 10 f0       	push   $0xf010683c
f0100e9a:	68 9b 71 10 f0       	push   $0xf010719b
f0100e9f:	68 a3 03 00 00       	push   $0x3a3
f0100ea4:	68 81 71 10 f0       	push   $0xf0107181
f0100ea9:	e8 c4 f1 ff ff       	call   f0100072 <_panic>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV * sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0100eae:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100eb4:	81 fb 00 f0 01 00    	cmp    $0x1f000,%ebx
f0100eba:	75 b2                	jne    f0100e6e <check_kern_pgdir+0x8d>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0100ebc:	8b 75 dc             	mov    -0x24(%ebp),%esi
f0100ebf:	c1 e6 0c             	shl    $0xc,%esi
f0100ec2:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100ec7:	eb 30                	jmp    f0100ef9 <check_kern_pgdir+0x118>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0100ec9:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0100ecf:	89 f8                	mov    %edi,%eax
f0100ed1:	e8 79 fe ff ff       	call   f0100d4f <check_va2pa>
f0100ed6:	39 c3                	cmp    %eax,%ebx
f0100ed8:	74 19                	je     f0100ef3 <check_kern_pgdir+0x112>
f0100eda:	68 70 68 10 f0       	push   $0xf0106870
f0100edf:	68 9b 71 10 f0       	push   $0xf010719b
f0100ee4:	68 a7 03 00 00       	push   $0x3a7
f0100ee9:	68 81 71 10 f0       	push   $0xf0107181
f0100eee:	e8 7f f1 ff ff       	call   f0100072 <_panic>
	n = ROUNDUP(NENV * sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0100ef3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100ef9:	39 f3                	cmp    %esi,%ebx
f0100efb:	72 cc                	jb     f0100ec9 <check_kern_pgdir+0xe8>
f0100efd:	c7 45 e0 00 c0 21 f0 	movl   $0xf021c000,-0x20(%ebp)
f0100f04:	be 00 80 ff ef       	mov    $0xefff8000,%esi

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0100f09:	bb 00 00 00 00       	mov    $0x0,%ebx
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
f0100f0e:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0100f11:	89 f8                	mov    %edi,%eax
f0100f13:	e8 37 fe ff ff       	call   f0100d4f <check_va2pa>
f0100f18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100f1b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100f1e:	ba af 03 00 00       	mov    $0x3af,%edx
f0100f23:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0100f28:	e8 92 fe ff ff       	call   f0100dbf <_paddr>
f0100f2d:	01 d8                	add    %ebx,%eax
f0100f2f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0100f32:	74 19                	je     f0100f4d <check_kern_pgdir+0x16c>
f0100f34:	68 98 68 10 f0       	push   $0xf0106898
f0100f39:	68 9b 71 10 f0       	push   $0xf010719b
f0100f3e:	68 af 03 00 00       	push   $0x3af
f0100f43:	68 81 71 10 f0       	push   $0xf0107181
f0100f48:	e8 25 f1 ff ff       	call   f0100072 <_panic>

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0100f4d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100f53:	81 fb 00 80 00 00    	cmp    $0x8000,%ebx
f0100f59:	75 b3                	jne    f0100f0e <check_kern_pgdir+0x12d>
f0100f5b:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
			       PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f0100f61:	89 da                	mov    %ebx,%edx
f0100f63:	89 f8                	mov    %edi,%eax
f0100f65:	e8 e5 fd ff ff       	call   f0100d4f <check_va2pa>
f0100f6a:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100f6d:	74 19                	je     f0100f88 <check_kern_pgdir+0x1a7>
f0100f6f:	68 e0 68 10 f0       	push   $0xf01068e0
f0100f74:	68 9b 71 10 f0       	push   $0xf010719b
f0100f79:	68 b1 03 00 00       	push   $0x3b1
f0100f7e:	68 81 71 10 f0       	push   $0xf0107181
f0100f83:	e8 ea f0 ff ff       	call   f0100072 <_panic>
f0100f88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i) ==
			       PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0100f8e:	39 de                	cmp    %ebx,%esi
f0100f90:	75 cf                	jne    f0100f61 <check_kern_pgdir+0x180>
f0100f92:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0100f98:	81 45 e0 00 80 00 00 	addl   $0x8000,-0x20(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f0100f9f:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f0100fa5:	0f 85 5e ff ff ff    	jne    f0100f09 <check_kern_pgdir+0x128>
f0100fab:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fb0:	eb 2a                	jmp    f0100fdc <check_kern_pgdir+0x1fb>
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0100fb2:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0100fb8:	83 fa 04             	cmp    $0x4,%edx
f0100fbb:	77 1f                	ja     f0100fdc <check_kern_pgdir+0x1fb>
		case PDX(UVPT):
		case PDX(KSTACKTOP - 1):
		case PDX(UPAGES):
		case PDX(UENVS):
		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f0100fbd:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0100fc1:	75 7e                	jne    f0101041 <check_kern_pgdir+0x260>
f0100fc3:	68 b0 71 10 f0       	push   $0xf01071b0
f0100fc8:	68 9b 71 10 f0       	push   $0xf010719b
f0100fcd:	68 bc 03 00 00       	push   $0x3bc
f0100fd2:	68 81 71 10 f0       	push   $0xf0107181
f0100fd7:	e8 96 f0 ff ff       	call   f0100072 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f0100fdc:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0100fe1:	76 3f                	jbe    f0101022 <check_kern_pgdir+0x241>
				assert(pgdir[i] & PTE_P);
f0100fe3:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0100fe6:	f6 c2 01             	test   $0x1,%dl
f0100fe9:	75 19                	jne    f0101004 <check_kern_pgdir+0x223>
f0100feb:	68 b0 71 10 f0       	push   $0xf01071b0
f0100ff0:	68 9b 71 10 f0       	push   $0xf010719b
f0100ff5:	68 c0 03 00 00       	push   $0x3c0
f0100ffa:	68 81 71 10 f0       	push   $0xf0107181
f0100fff:	e8 6e f0 ff ff       	call   f0100072 <_panic>
				assert(pgdir[i] & PTE_W);
f0101004:	f6 c2 02             	test   $0x2,%dl
f0101007:	75 38                	jne    f0101041 <check_kern_pgdir+0x260>
f0101009:	68 c1 71 10 f0       	push   $0xf01071c1
f010100e:	68 9b 71 10 f0       	push   $0xf010719b
f0101013:	68 c1 03 00 00       	push   $0x3c1
f0101018:	68 81 71 10 f0       	push   $0xf0107181
f010101d:	e8 50 f0 ff ff       	call   f0100072 <_panic>
			} else
				assert(pgdir[i] == 0);
f0101022:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0101026:	74 19                	je     f0101041 <check_kern_pgdir+0x260>
f0101028:	68 d2 71 10 f0       	push   $0xf01071d2
f010102d:	68 9b 71 10 f0       	push   $0xf010719b
f0101032:	68 c3 03 00 00       	push   $0x3c3
f0101037:	68 81 71 10 f0       	push   $0xf0107181
f010103c:	e8 31 f0 ff ff       	call   f0100072 <_panic>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f0101041:	83 c0 01             	add    $0x1,%eax
f0101044:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0101049:	0f 86 63 ff ff ff    	jbe    f0100fb2 <check_kern_pgdir+0x1d1>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f010104f:	83 ec 0c             	sub    $0xc,%esp
f0101052:	68 04 69 10 f0       	push   $0xf0106904
f0101057:	e8 ff 26 00 00       	call   f010375b <cprintf>
		assert(pgdir[i] & PTE_PS);
		assert(PTE_ADDR(pgdir[i]) == (i - kern_pdx) << PDXSHIFT);
	}
	cprintf("check_kern_pgdir_pse() succeeded!\n");
#endif
}
f010105c:	83 c4 10             	add    $0x10,%esp
f010105f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101062:	5b                   	pop    %ebx
f0101063:	5e                   	pop    %esi
f0101064:	5f                   	pop    %edi
f0101065:	5d                   	pop    %ebp
f0101066:	c3                   	ret    

f0101067 <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f0101067:	55                   	push   %ebp
f0101068:	89 e5                	mov    %esp,%ebp
f010106a:	57                   	push   %edi
f010106b:	56                   	push   %esi
f010106c:	53                   	push   %ebx
f010106d:	83 ec 3c             	sub    $0x3c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101070:	84 c0                	test   %al,%al
f0101072:	0f 85 6c 02 00 00    	jne    f01012e4 <check_page_free_list+0x27d>
f0101078:	e9 7a 02 00 00       	jmp    f01012f7 <check_page_free_list+0x290>
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
		panic("'page_free_list' is a null pointer!");
f010107d:	83 ec 04             	sub    $0x4,%esp
f0101080:	68 24 69 10 f0       	push   $0xf0106924
f0101085:	68 09 03 00 00       	push   $0x309
f010108a:	68 81 71 10 f0       	push   $0xf0107181
f010108f:	e8 de ef ff ff       	call   f0100072 <_panic>

	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0101094:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0101097:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010109a:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010109d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f01010a0:	89 d8                	mov    %ebx,%eax
f01010a2:	e8 31 fb ff ff       	call   f0100bd8 <page2pa>
f01010a7:	c1 e8 16             	shr    $0x16,%eax
f01010aa:	85 c0                	test   %eax,%eax
f01010ac:	0f 95 c0             	setne  %al
f01010af:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f01010b2:	8b 54 85 e0          	mov    -0x20(%ebp,%eax,4),%edx
f01010b6:	89 1a                	mov    %ebx,(%edx)
			tp[pagetype] = &pp->pp_link;
f01010b8:	89 5c 85 e0          	mov    %ebx,-0x20(%ebp,%eax,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f01010bc:	8b 1b                	mov    (%ebx),%ebx
f01010be:	85 db                	test   %ebx,%ebx
f01010c0:	75 de                	jne    f01010a0 <check_page_free_list+0x39>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f01010c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f01010cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01010ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01010d1:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f01010d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01010d6:	a3 40 a2 21 f0       	mov    %eax,0xf021a240
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01010db:	be 01 00 00 00       	mov    $0x1,%esi
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01010e0:	8b 1d 40 a2 21 f0    	mov    0xf021a240,%ebx
f01010e6:	eb 2d                	jmp    f0101115 <check_page_free_list+0xae>
		if (PDX(page2pa(pp)) < pdx_limit)
f01010e8:	89 d8                	mov    %ebx,%eax
f01010ea:	e8 e9 fa ff ff       	call   f0100bd8 <page2pa>
f01010ef:	c1 e8 16             	shr    $0x16,%eax
f01010f2:	39 f0                	cmp    %esi,%eax
f01010f4:	73 1d                	jae    f0101113 <check_page_free_list+0xac>
			memset(page2kva(pp), 0x97, 128);
f01010f6:	89 d8                	mov    %ebx,%eax
f01010f8:	e8 34 fc ff ff       	call   f0100d31 <page2kva>
f01010fd:	83 ec 04             	sub    $0x4,%esp
f0101100:	68 80 00 00 00       	push   $0x80
f0101105:	68 97 00 00 00       	push   $0x97
f010110a:	50                   	push   %eax
f010110b:	e8 19 44 00 00       	call   f0105529 <memset>
f0101110:	83 c4 10             	add    $0x10,%esp
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101113:	8b 1b                	mov    (%ebx),%ebx
f0101115:	85 db                	test   %ebx,%ebx
f0101117:	75 cf                	jne    f01010e8 <check_page_free_list+0x81>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0101119:	b8 00 00 00 00       	mov    $0x0,%eax
f010111e:	e8 60 fb ff ff       	call   f0100c83 <boot_alloc>
f0101123:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101126:	8b 1d 40 a2 21 f0    	mov    0xf021a240,%ebx
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f010112c:	8b 3d 90 ae 21 f0    	mov    0xf021ae90,%edi
		assert(pp < pages + npages);
f0101132:	a1 88 ae 21 f0       	mov    0xf021ae88,%eax
f0101137:	8d 04 c7             	lea    (%edi,%eax,8),%eax
f010113a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010113d:	89 7d d0             	mov    %edi,-0x30(%ebp)
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0101140:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
f0101147:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f010114e:	e9 3c 01 00 00       	jmp    f010128f <check_page_free_list+0x228>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101153:	39 fb                	cmp    %edi,%ebx
f0101155:	73 19                	jae    f0101170 <check_page_free_list+0x109>
f0101157:	68 e0 71 10 f0       	push   $0xf01071e0
f010115c:	68 9b 71 10 f0       	push   $0xf010719b
f0101161:	68 23 03 00 00       	push   $0x323
f0101166:	68 81 71 10 f0       	push   $0xf0107181
f010116b:	e8 02 ef ff ff       	call   f0100072 <_panic>
		assert(pp < pages + npages);
f0101170:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0101173:	72 19                	jb     f010118e <check_page_free_list+0x127>
f0101175:	68 ec 71 10 f0       	push   $0xf01071ec
f010117a:	68 9b 71 10 f0       	push   $0xf010719b
f010117f:	68 24 03 00 00       	push   $0x324
f0101184:	68 81 71 10 f0       	push   $0xf0107181
f0101189:	e8 e4 ee ff ff       	call   f0100072 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010118e:	89 d8                	mov    %ebx,%eax
f0101190:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0101193:	a8 07                	test   $0x7,%al
f0101195:	74 19                	je     f01011b0 <check_page_free_list+0x149>
f0101197:	68 48 69 10 f0       	push   $0xf0106948
f010119c:	68 9b 71 10 f0       	push   $0xf010719b
f01011a1:	68 25 03 00 00       	push   $0x325
f01011a6:	68 81 71 10 f0       	push   $0xf0107181
f01011ab:	e8 c2 ee ff ff       	call   f0100072 <_panic>

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f01011b0:	89 d8                	mov    %ebx,%eax
f01011b2:	e8 21 fa ff ff       	call   f0100bd8 <page2pa>
f01011b7:	89 c6                	mov    %eax,%esi
f01011b9:	85 c0                	test   %eax,%eax
f01011bb:	75 19                	jne    f01011d6 <check_page_free_list+0x16f>
f01011bd:	68 00 72 10 f0       	push   $0xf0107200
f01011c2:	68 9b 71 10 f0       	push   $0xf010719b
f01011c7:	68 28 03 00 00       	push   $0x328
f01011cc:	68 81 71 10 f0       	push   $0xf0107181
f01011d1:	e8 9c ee ff ff       	call   f0100072 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f01011d6:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f01011db:	75 19                	jne    f01011f6 <check_page_free_list+0x18f>
f01011dd:	68 11 72 10 f0       	push   $0xf0107211
f01011e2:	68 9b 71 10 f0       	push   $0xf010719b
f01011e7:	68 29 03 00 00       	push   $0x329
f01011ec:	68 81 71 10 f0       	push   $0xf0107181
f01011f1:	e8 7c ee ff ff       	call   f0100072 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f01011f6:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01011fb:	75 19                	jne    f0101216 <check_page_free_list+0x1af>
f01011fd:	68 7c 69 10 f0       	push   $0xf010697c
f0101202:	68 9b 71 10 f0       	push   $0xf010719b
f0101207:	68 2a 03 00 00       	push   $0x32a
f010120c:	68 81 71 10 f0       	push   $0xf0107181
f0101211:	e8 5c ee ff ff       	call   f0100072 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101216:	3d 00 00 10 00       	cmp    $0x100000,%eax
f010121b:	75 19                	jne    f0101236 <check_page_free_list+0x1cf>
f010121d:	68 2a 72 10 f0       	push   $0xf010722a
f0101222:	68 9b 71 10 f0       	push   $0xf010719b
f0101227:	68 2b 03 00 00       	push   $0x32b
f010122c:	68 81 71 10 f0       	push   $0xf0107181
f0101231:	e8 3c ee ff ff       	call   f0100072 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM ||
f0101236:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f010123b:	0f 86 cd 00 00 00    	jbe    f010130e <check_page_free_list+0x2a7>
f0101241:	89 d8                	mov    %ebx,%eax
f0101243:	e8 e9 fa ff ff       	call   f0100d31 <page2kva>
f0101248:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
f010124b:	0f 86 cd 00 00 00    	jbe    f010131e <check_page_free_list+0x2b7>
f0101251:	68 a0 69 10 f0       	push   $0xf01069a0
f0101256:	68 9b 71 10 f0       	push   $0xf010719b
f010125b:	68 2d 03 00 00       	push   $0x32d
f0101260:	68 81 71 10 f0       	push   $0xf0107181
f0101265:	e8 08 ee ff ff       	call   f0100072 <_panic>
		       (char *) page2kva(pp) >= first_free_page);
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f010126a:	68 44 72 10 f0       	push   $0xf0107244
f010126f:	68 9b 71 10 f0       	push   $0xf010719b
f0101274:	68 2f 03 00 00       	push   $0x32f
f0101279:	68 81 71 10 f0       	push   $0xf0107181
f010127e:	e8 ef ed ff ff       	call   f0100072 <_panic>

		if (page2pa(pp) < EXTPHYSMEM)
			++nfree_basemem;
f0101283:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
f0101287:	eb 04                	jmp    f010128d <check_page_free_list+0x226>
		else
			++nfree_extmem;
f0101289:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f010128d:	8b 1b                	mov    (%ebx),%ebx
f010128f:	85 db                	test   %ebx,%ebx
f0101291:	0f 85 bc fe ff ff    	jne    f0101153 <check_page_free_list+0xec>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f0101297:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f010129b:	7f 19                	jg     f01012b6 <check_page_free_list+0x24f>
f010129d:	68 61 72 10 f0       	push   $0xf0107261
f01012a2:	68 9b 71 10 f0       	push   $0xf010719b
f01012a7:	68 37 03 00 00       	push   $0x337
f01012ac:	68 81 71 10 f0       	push   $0xf0107181
f01012b1:	e8 bc ed ff ff       	call   f0100072 <_panic>
	assert(nfree_extmem > 0);
f01012b6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
f01012ba:	7f 19                	jg     f01012d5 <check_page_free_list+0x26e>
f01012bc:	68 73 72 10 f0       	push   $0xf0107273
f01012c1:	68 9b 71 10 f0       	push   $0xf010719b
f01012c6:	68 38 03 00 00       	push   $0x338
f01012cb:	68 81 71 10 f0       	push   $0xf0107181
f01012d0:	e8 9d ed ff ff       	call   f0100072 <_panic>

	cprintf("check_page_free_list() succeeded!\n");
f01012d5:	83 ec 0c             	sub    $0xc,%esp
f01012d8:	68 e8 69 10 f0       	push   $0xf01069e8
f01012dd:	e8 79 24 00 00       	call   f010375b <cprintf>
}
f01012e2:	eb 4b                	jmp    f010132f <check_page_free_list+0x2c8>
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f01012e4:	8b 1d 40 a2 21 f0    	mov    0xf021a240,%ebx
f01012ea:	85 db                	test   %ebx,%ebx
f01012ec:	0f 85 a2 fd ff ff    	jne    f0101094 <check_page_free_list+0x2d>
f01012f2:	e9 86 fd ff ff       	jmp    f010107d <check_page_free_list+0x16>
f01012f7:	83 3d 40 a2 21 f0 00 	cmpl   $0x0,0xf021a240
f01012fe:	0f 84 79 fd ff ff    	je     f010107d <check_page_free_list+0x16>
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101304:	be 00 04 00 00       	mov    $0x400,%esi
f0101309:	e9 d2 fd ff ff       	jmp    f01010e0 <check_page_free_list+0x79>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
		assert(page2pa(pp) != EXTPHYSMEM);
		assert(page2pa(pp) < EXTPHYSMEM ||
		       (char *) page2kva(pp) >= first_free_page);
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f010130e:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0101313:	0f 85 6a ff ff ff    	jne    f0101283 <check_page_free_list+0x21c>
f0101319:	e9 4c ff ff ff       	jmp    f010126a <check_page_free_list+0x203>
f010131e:	81 fe 00 70 00 00    	cmp    $0x7000,%esi
f0101324:	0f 85 5f ff ff ff    	jne    f0101289 <check_page_free_list+0x222>
f010132a:	e9 3b ff ff ff       	jmp    f010126a <check_page_free_list+0x203>

	assert(nfree_basemem > 0);
	assert(nfree_extmem > 0);

	cprintf("check_page_free_list() succeeded!\n");
}
f010132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101332:	5b                   	pop    %ebx
f0101333:	5e                   	pop    %esi
f0101334:	5f                   	pop    %edi
f0101335:	5d                   	pop    %ebp
f0101336:	c3                   	ret    

f0101337 <pa2page>:
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101337:	c1 e8 0c             	shr    $0xc,%eax
f010133a:	3b 05 88 ae 21 f0    	cmp    0xf021ae88,%eax
f0101340:	72 17                	jb     f0101359 <pa2page+0x22>
	return (pp - pages) << PGSHIFT;
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
f0101342:	55                   	push   %ebp
f0101343:	89 e5                	mov    %esp,%ebp
f0101345:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
		panic("pa2page called with invalid pa");
f0101348:	68 0c 6a 10 f0       	push   $0xf0106a0c
f010134d:	6a 51                	push   $0x51
f010134f:	68 8d 71 10 f0       	push   $0xf010718d
f0101354:	e8 19 ed ff ff       	call   f0100072 <_panic>
	return &pages[PGNUM(pa)];
f0101359:	8b 15 90 ae 21 f0    	mov    0xf021ae90,%edx
f010135f:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101362:	c3                   	ret    

f0101363 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0101363:	55                   	push   %ebp
f0101364:	89 e5                	mov    %esp,%ebp
f0101366:	56                   	push   %esi
f0101367:	53                   	push   %ebx
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;

	
	for (i = 1; i < npages_basemem; i++) {
f0101368:	8b 35 44 a2 21 f0    	mov    0xf021a244,%esi
f010136e:	8b 1d 40 a2 21 f0    	mov    0xf021a240,%ebx
f0101374:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101379:	b8 01 00 00 00       	mov    $0x1,%eax
f010137e:	eb 34                	jmp    f01013b4 <page_init+0x51>
		if(i*PGSIZE == MPENTRY_PADDR){
f0101380:	89 c2                	mov    %eax,%edx
f0101382:	c1 e2 0c             	shl    $0xc,%edx
f0101385:	81 fa 00 70 00 00    	cmp    $0x7000,%edx
f010138b:	74 24                	je     f01013b1 <page_init+0x4e>
			continue;
		}
		pages[i].pp_ref = 0;
f010138d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0101394:	89 d1                	mov    %edx,%ecx
f0101396:	03 0d 90 ae 21 f0    	add    0xf021ae90,%ecx
f010139c:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f01013a2:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f01013a4:	89 d3                	mov    %edx,%ebx
f01013a6:	03 1d 90 ae 21 f0    	add    0xf021ae90,%ebx
f01013ac:	b9 01 00 00 00       	mov    $0x1,%ecx
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;

	
	for (i = 1; i < npages_basemem; i++) {
f01013b1:	83 c0 01             	add    $0x1,%eax
f01013b4:	39 f0                	cmp    %esi,%eax
f01013b6:	72 c8                	jb     f0101380 <page_init+0x1d>
f01013b8:	84 c9                	test   %cl,%cl
f01013ba:	74 06                	je     f01013c2 <page_init+0x5f>
f01013bc:	89 1d 40 a2 21 f0    	mov    %ebx,0xf021a240
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}	
	
	i = PADDR(boot_alloc(0))/PGSIZE; // Obtengo la direccion de pagina fisica libre despues de haber asignado lo correspondiente en boot alloc REVISAR!!
f01013c2:	b8 00 00 00 00       	mov    $0x0,%eax
f01013c7:	e8 b7 f8 ff ff       	call   f0100c83 <boot_alloc>
f01013cc:	89 c1                	mov    %eax,%ecx
f01013ce:	ba 7a 01 00 00       	mov    $0x17a,%edx
f01013d3:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f01013d8:	e8 e2 f9 ff ff       	call   f0100dbf <_paddr>
f01013dd:	c1 e8 0c             	shr    $0xc,%eax
f01013e0:	8b 1d 40 a2 21 f0    	mov    0xf021a240,%ebx
f01013e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
	for (i; i < npages; ++i){
f01013ed:	b9 00 00 00 00       	mov    $0x0,%ecx
f01013f2:	eb 23                	jmp    f0101417 <page_init+0xb4>
		pages[i].pp_ref = 0;
f01013f4:	89 d1                	mov    %edx,%ecx
f01013f6:	03 0d 90 ae 21 f0    	add    0xf021ae90,%ecx
f01013fc:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0101402:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];		
f0101404:	89 d3                	mov    %edx,%ebx
f0101406:	03 1d 90 ae 21 f0    	add    0xf021ae90,%ebx
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}	
	
	i = PADDR(boot_alloc(0))/PGSIZE; // Obtengo la direccion de pagina fisica libre despues de haber asignado lo correspondiente en boot alloc REVISAR!!
	for (i; i < npages; ++i){
f010140c:	83 c0 01             	add    $0x1,%eax
f010140f:	83 c2 08             	add    $0x8,%edx
f0101412:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101417:	3b 05 88 ae 21 f0    	cmp    0xf021ae88,%eax
f010141d:	72 d5                	jb     f01013f4 <page_init+0x91>
f010141f:	84 c9                	test   %cl,%cl
f0101421:	74 06                	je     f0101429 <page_init+0xc6>
f0101423:	89 1d 40 a2 21 f0    	mov    %ebx,0xf021a240

	_Static_assert(MPENTRY_PADDR % PGSIZE == 0,
               "MPENTRY_PADDR is not page-aligned");

		
}
f0101429:	5b                   	pop    %ebx
f010142a:	5e                   	pop    %esi
f010142b:	5d                   	pop    %ebp
f010142c:	c3                   	ret    

f010142d <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f010142d:	55                   	push   %ebp
f010142e:	89 e5                	mov    %esp,%ebp
f0101430:	53                   	push   %ebx
f0101431:	83 ec 04             	sub    $0x4,%esp
	struct PageInfo * result;
	if(page_free_list==NULL){
f0101434:	8b 1d 40 a2 21 f0    	mov    0xf021a240,%ebx
f010143a:	85 db                	test   %ebx,%ebx
f010143c:	74 2d                	je     f010146b <page_alloc+0x3e>
		return NULL;
	}
	result = page_free_list;
	page_free_list = result->pp_link;
f010143e:	8b 03                	mov    (%ebx),%eax
f0101440:	a3 40 a2 21 f0       	mov    %eax,0xf021a240
	result->pp_link = NULL;
f0101445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f010144b:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f010144f:	74 1a                	je     f010146b <page_alloc+0x3e>
		memset(page2kva(result),0,PGSIZE);
f0101451:	89 d8                	mov    %ebx,%eax
f0101453:	e8 d9 f8 ff ff       	call   f0100d31 <page2kva>
f0101458:	83 ec 04             	sub    $0x4,%esp
f010145b:	68 00 10 00 00       	push   $0x1000
f0101460:	6a 00                	push   $0x0
f0101462:	50                   	push   %eax
f0101463:	e8 c1 40 00 00       	call   f0105529 <memset>
f0101468:	83 c4 10             	add    $0x10,%esp
	}
	return result;
}
f010146b:	89 d8                	mov    %ebx,%eax
f010146d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101470:	c9                   	leave  
f0101471:	c3                   	ret    

f0101472 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f0101472:	55                   	push   %ebp
f0101473:	89 e5                	mov    %esp,%ebp
f0101475:	83 ec 08             	sub    $0x8,%esp
f0101478:	8b 45 08             	mov    0x8(%ebp),%eax
	if(pp->pp_ref != 0 || pp->pp_link != NULL){
f010147b:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101480:	75 05                	jne    f0101487 <page_free+0x15>
f0101482:	83 38 00             	cmpl   $0x0,(%eax)
f0101485:	74 17                	je     f010149e <page_free+0x2c>
		panic("page_free: la pagina no esta libre");
f0101487:	83 ec 04             	sub    $0x4,%esp
f010148a:	68 2c 6a 10 f0       	push   $0xf0106a2c
f010148f:	68 ab 01 00 00       	push   $0x1ab
f0101494:	68 81 71 10 f0       	push   $0xf0107181
f0101499:	e8 d4 eb ff ff       	call   f0100072 <_panic>
	}
	struct PageInfo *paux;
	paux= page_free_list;
f010149e:	8b 15 40 a2 21 f0    	mov    0xf021a240,%edx
	page_free_list = pp;
f01014a4:	a3 40 a2 21 f0       	mov    %eax,0xf021a240
	page_free_list->pp_link = paux;
f01014a9:	89 10                	mov    %edx,(%eax)
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
}
f01014ab:	c9                   	leave  
f01014ac:	c3                   	ret    

f01014ad <check_page_alloc>:
// Check the physical page allocator (page_alloc(), page_free(),
// and page_init()).
//
static void
check_page_alloc(void)
{
f01014ad:	55                   	push   %ebp
f01014ae:	89 e5                	mov    %esp,%ebp
f01014b0:	57                   	push   %edi
f01014b1:	56                   	push   %esi
f01014b2:	53                   	push   %ebx
f01014b3:	83 ec 1c             	sub    $0x1c,%esp
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f01014b6:	83 3d 90 ae 21 f0 00 	cmpl   $0x0,0xf021ae90
f01014bd:	75 17                	jne    f01014d6 <check_page_alloc+0x29>
		panic("'pages' is a null pointer!");
f01014bf:	83 ec 04             	sub    $0x4,%esp
f01014c2:	68 84 72 10 f0       	push   $0xf0107284
f01014c7:	68 4b 03 00 00       	push   $0x34b
f01014cc:	68 81 71 10 f0       	push   $0xf0107181
f01014d1:	e8 9c eb ff ff       	call   f0100072 <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01014d6:	a1 40 a2 21 f0       	mov    0xf021a240,%eax
f01014db:	be 00 00 00 00       	mov    $0x0,%esi
f01014e0:	eb 05                	jmp    f01014e7 <check_page_alloc+0x3a>
		++nfree;
f01014e2:	83 c6 01             	add    $0x1,%esi

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01014e5:	8b 00                	mov    (%eax),%eax
f01014e7:	85 c0                	test   %eax,%eax
f01014e9:	75 f7                	jne    f01014e2 <check_page_alloc+0x35>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01014eb:	83 ec 0c             	sub    $0xc,%esp
f01014ee:	6a 00                	push   $0x0
f01014f0:	e8 38 ff ff ff       	call   f010142d <page_alloc>
f01014f5:	89 c7                	mov    %eax,%edi
f01014f7:	83 c4 10             	add    $0x10,%esp
f01014fa:	85 c0                	test   %eax,%eax
f01014fc:	75 19                	jne    f0101517 <check_page_alloc+0x6a>
f01014fe:	68 9f 72 10 f0       	push   $0xf010729f
f0101503:	68 9b 71 10 f0       	push   $0xf010719b
f0101508:	68 53 03 00 00       	push   $0x353
f010150d:	68 81 71 10 f0       	push   $0xf0107181
f0101512:	e8 5b eb ff ff       	call   f0100072 <_panic>
	assert((pp1 = page_alloc(0)));
f0101517:	83 ec 0c             	sub    $0xc,%esp
f010151a:	6a 00                	push   $0x0
f010151c:	e8 0c ff ff ff       	call   f010142d <page_alloc>
f0101521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101524:	83 c4 10             	add    $0x10,%esp
f0101527:	85 c0                	test   %eax,%eax
f0101529:	75 19                	jne    f0101544 <check_page_alloc+0x97>
f010152b:	68 b5 72 10 f0       	push   $0xf01072b5
f0101530:	68 9b 71 10 f0       	push   $0xf010719b
f0101535:	68 54 03 00 00       	push   $0x354
f010153a:	68 81 71 10 f0       	push   $0xf0107181
f010153f:	e8 2e eb ff ff       	call   f0100072 <_panic>
	assert((pp2 = page_alloc(0)));
f0101544:	83 ec 0c             	sub    $0xc,%esp
f0101547:	6a 00                	push   $0x0
f0101549:	e8 df fe ff ff       	call   f010142d <page_alloc>
f010154e:	89 c3                	mov    %eax,%ebx
f0101550:	83 c4 10             	add    $0x10,%esp
f0101553:	85 c0                	test   %eax,%eax
f0101555:	75 19                	jne    f0101570 <check_page_alloc+0xc3>
f0101557:	68 cb 72 10 f0       	push   $0xf01072cb
f010155c:	68 9b 71 10 f0       	push   $0xf010719b
f0101561:	68 55 03 00 00       	push   $0x355
f0101566:	68 81 71 10 f0       	push   $0xf0107181
f010156b:	e8 02 eb ff ff       	call   f0100072 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101570:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f0101573:	75 19                	jne    f010158e <check_page_alloc+0xe1>
f0101575:	68 e1 72 10 f0       	push   $0xf01072e1
f010157a:	68 9b 71 10 f0       	push   $0xf010719b
f010157f:	68 58 03 00 00       	push   $0x358
f0101584:	68 81 71 10 f0       	push   $0xf0107181
f0101589:	e8 e4 ea ff ff       	call   f0100072 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010158e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0101591:	74 04                	je     f0101597 <check_page_alloc+0xea>
f0101593:	39 c7                	cmp    %eax,%edi
f0101595:	75 19                	jne    f01015b0 <check_page_alloc+0x103>
f0101597:	68 50 6a 10 f0       	push   $0xf0106a50
f010159c:	68 9b 71 10 f0       	push   $0xf010719b
f01015a1:	68 59 03 00 00       	push   $0x359
f01015a6:	68 81 71 10 f0       	push   $0xf0107181
f01015ab:	e8 c2 ea ff ff       	call   f0100072 <_panic>
	assert(page2pa(pp0) < npages * PGSIZE);
f01015b0:	89 f8                	mov    %edi,%eax
f01015b2:	e8 21 f6 ff ff       	call   f0100bd8 <page2pa>
f01015b7:	8b 0d 88 ae 21 f0    	mov    0xf021ae88,%ecx
f01015bd:	c1 e1 0c             	shl    $0xc,%ecx
f01015c0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01015c3:	39 c8                	cmp    %ecx,%eax
f01015c5:	72 19                	jb     f01015e0 <check_page_alloc+0x133>
f01015c7:	68 70 6a 10 f0       	push   $0xf0106a70
f01015cc:	68 9b 71 10 f0       	push   $0xf010719b
f01015d1:	68 5a 03 00 00       	push   $0x35a
f01015d6:	68 81 71 10 f0       	push   $0xf0107181
f01015db:	e8 92 ea ff ff       	call   f0100072 <_panic>
	assert(page2pa(pp1) < npages * PGSIZE);
f01015e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01015e3:	e8 f0 f5 ff ff       	call   f0100bd8 <page2pa>
f01015e8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f01015eb:	77 19                	ja     f0101606 <check_page_alloc+0x159>
f01015ed:	68 90 6a 10 f0       	push   $0xf0106a90
f01015f2:	68 9b 71 10 f0       	push   $0xf010719b
f01015f7:	68 5b 03 00 00       	push   $0x35b
f01015fc:	68 81 71 10 f0       	push   $0xf0107181
f0101601:	e8 6c ea ff ff       	call   f0100072 <_panic>
	assert(page2pa(pp2) < npages * PGSIZE);
f0101606:	89 d8                	mov    %ebx,%eax
f0101608:	e8 cb f5 ff ff       	call   f0100bd8 <page2pa>
f010160d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f0101610:	77 19                	ja     f010162b <check_page_alloc+0x17e>
f0101612:	68 b0 6a 10 f0       	push   $0xf0106ab0
f0101617:	68 9b 71 10 f0       	push   $0xf010719b
f010161c:	68 5c 03 00 00       	push   $0x35c
f0101621:	68 81 71 10 f0       	push   $0xf0107181
f0101626:	e8 47 ea ff ff       	call   f0100072 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f010162b:	a1 40 a2 21 f0       	mov    0xf021a240,%eax
f0101630:	89 45 e0             	mov    %eax,-0x20(%ebp)
	page_free_list = 0;
f0101633:	c7 05 40 a2 21 f0 00 	movl   $0x0,0xf021a240
f010163a:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f010163d:	83 ec 0c             	sub    $0xc,%esp
f0101640:	6a 00                	push   $0x0
f0101642:	e8 e6 fd ff ff       	call   f010142d <page_alloc>
f0101647:	83 c4 10             	add    $0x10,%esp
f010164a:	85 c0                	test   %eax,%eax
f010164c:	74 19                	je     f0101667 <check_page_alloc+0x1ba>
f010164e:	68 f3 72 10 f0       	push   $0xf01072f3
f0101653:	68 9b 71 10 f0       	push   $0xf010719b
f0101658:	68 63 03 00 00       	push   $0x363
f010165d:	68 81 71 10 f0       	push   $0xf0107181
f0101662:	e8 0b ea ff ff       	call   f0100072 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101667:	83 ec 0c             	sub    $0xc,%esp
f010166a:	57                   	push   %edi
f010166b:	e8 02 fe ff ff       	call   f0101472 <page_free>
	page_free(pp1);
f0101670:	83 c4 04             	add    $0x4,%esp
f0101673:	ff 75 e4             	pushl  -0x1c(%ebp)
f0101676:	e8 f7 fd ff ff       	call   f0101472 <page_free>
	page_free(pp2);
f010167b:	89 1c 24             	mov    %ebx,(%esp)
f010167e:	e8 ef fd ff ff       	call   f0101472 <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101683:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010168a:	e8 9e fd ff ff       	call   f010142d <page_alloc>
f010168f:	89 c3                	mov    %eax,%ebx
f0101691:	83 c4 10             	add    $0x10,%esp
f0101694:	85 c0                	test   %eax,%eax
f0101696:	75 19                	jne    f01016b1 <check_page_alloc+0x204>
f0101698:	68 9f 72 10 f0       	push   $0xf010729f
f010169d:	68 9b 71 10 f0       	push   $0xf010719b
f01016a2:	68 6a 03 00 00       	push   $0x36a
f01016a7:	68 81 71 10 f0       	push   $0xf0107181
f01016ac:	e8 c1 e9 ff ff       	call   f0100072 <_panic>
	assert((pp1 = page_alloc(0)));
f01016b1:	83 ec 0c             	sub    $0xc,%esp
f01016b4:	6a 00                	push   $0x0
f01016b6:	e8 72 fd ff ff       	call   f010142d <page_alloc>
f01016bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01016be:	83 c4 10             	add    $0x10,%esp
f01016c1:	85 c0                	test   %eax,%eax
f01016c3:	75 19                	jne    f01016de <check_page_alloc+0x231>
f01016c5:	68 b5 72 10 f0       	push   $0xf01072b5
f01016ca:	68 9b 71 10 f0       	push   $0xf010719b
f01016cf:	68 6b 03 00 00       	push   $0x36b
f01016d4:	68 81 71 10 f0       	push   $0xf0107181
f01016d9:	e8 94 e9 ff ff       	call   f0100072 <_panic>
	assert((pp2 = page_alloc(0)));
f01016de:	83 ec 0c             	sub    $0xc,%esp
f01016e1:	6a 00                	push   $0x0
f01016e3:	e8 45 fd ff ff       	call   f010142d <page_alloc>
f01016e8:	89 c7                	mov    %eax,%edi
f01016ea:	83 c4 10             	add    $0x10,%esp
f01016ed:	85 c0                	test   %eax,%eax
f01016ef:	75 19                	jne    f010170a <check_page_alloc+0x25d>
f01016f1:	68 cb 72 10 f0       	push   $0xf01072cb
f01016f6:	68 9b 71 10 f0       	push   $0xf010719b
f01016fb:	68 6c 03 00 00       	push   $0x36c
f0101700:	68 81 71 10 f0       	push   $0xf0107181
f0101705:	e8 68 e9 ff ff       	call   f0100072 <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f010170a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010170d:	75 19                	jne    f0101728 <check_page_alloc+0x27b>
f010170f:	68 e1 72 10 f0       	push   $0xf01072e1
f0101714:	68 9b 71 10 f0       	push   $0xf010719b
f0101719:	68 6e 03 00 00       	push   $0x36e
f010171e:	68 81 71 10 f0       	push   $0xf0107181
f0101723:	e8 4a e9 ff ff       	call   f0100072 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101728:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f010172b:	74 04                	je     f0101731 <check_page_alloc+0x284>
f010172d:	39 c3                	cmp    %eax,%ebx
f010172f:	75 19                	jne    f010174a <check_page_alloc+0x29d>
f0101731:	68 50 6a 10 f0       	push   $0xf0106a50
f0101736:	68 9b 71 10 f0       	push   $0xf010719b
f010173b:	68 6f 03 00 00       	push   $0x36f
f0101740:	68 81 71 10 f0       	push   $0xf0107181
f0101745:	e8 28 e9 ff ff       	call   f0100072 <_panic>
	assert(!page_alloc(0));
f010174a:	83 ec 0c             	sub    $0xc,%esp
f010174d:	6a 00                	push   $0x0
f010174f:	e8 d9 fc ff ff       	call   f010142d <page_alloc>
f0101754:	83 c4 10             	add    $0x10,%esp
f0101757:	85 c0                	test   %eax,%eax
f0101759:	74 19                	je     f0101774 <check_page_alloc+0x2c7>
f010175b:	68 f3 72 10 f0       	push   $0xf01072f3
f0101760:	68 9b 71 10 f0       	push   $0xf010719b
f0101765:	68 70 03 00 00       	push   $0x370
f010176a:	68 81 71 10 f0       	push   $0xf0107181
f010176f:	e8 fe e8 ff ff       	call   f0100072 <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0101774:	89 d8                	mov    %ebx,%eax
f0101776:	e8 b6 f5 ff ff       	call   f0100d31 <page2kva>
f010177b:	83 ec 04             	sub    $0x4,%esp
f010177e:	68 00 10 00 00       	push   $0x1000
f0101783:	6a 01                	push   $0x1
f0101785:	50                   	push   %eax
f0101786:	e8 9e 3d 00 00       	call   f0105529 <memset>
	page_free(pp0);
f010178b:	89 1c 24             	mov    %ebx,(%esp)
f010178e:	e8 df fc ff ff       	call   f0101472 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101793:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010179a:	e8 8e fc ff ff       	call   f010142d <page_alloc>
f010179f:	83 c4 10             	add    $0x10,%esp
f01017a2:	85 c0                	test   %eax,%eax
f01017a4:	75 19                	jne    f01017bf <check_page_alloc+0x312>
f01017a6:	68 02 73 10 f0       	push   $0xf0107302
f01017ab:	68 9b 71 10 f0       	push   $0xf010719b
f01017b0:	68 75 03 00 00       	push   $0x375
f01017b5:	68 81 71 10 f0       	push   $0xf0107181
f01017ba:	e8 b3 e8 ff ff       	call   f0100072 <_panic>
	assert(pp && pp0 == pp);
f01017bf:	39 c3                	cmp    %eax,%ebx
f01017c1:	74 19                	je     f01017dc <check_page_alloc+0x32f>
f01017c3:	68 20 73 10 f0       	push   $0xf0107320
f01017c8:	68 9b 71 10 f0       	push   $0xf010719b
f01017cd:	68 76 03 00 00       	push   $0x376
f01017d2:	68 81 71 10 f0       	push   $0xf0107181
f01017d7:	e8 96 e8 ff ff       	call   f0100072 <_panic>
	c = page2kva(pp);
f01017dc:	89 d8                	mov    %ebx,%eax
f01017de:	e8 4e f5 ff ff       	call   f0100d31 <page2kva>
f01017e3:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f01017e9:	80 38 00             	cmpb   $0x0,(%eax)
f01017ec:	74 19                	je     f0101807 <check_page_alloc+0x35a>
f01017ee:	68 30 73 10 f0       	push   $0xf0107330
f01017f3:	68 9b 71 10 f0       	push   $0xf010719b
f01017f8:	68 79 03 00 00       	push   $0x379
f01017fd:	68 81 71 10 f0       	push   $0xf0107181
f0101802:	e8 6b e8 ff ff       	call   f0100072 <_panic>
f0101807:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f010180a:	39 d0                	cmp    %edx,%eax
f010180c:	75 db                	jne    f01017e9 <check_page_alloc+0x33c>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f010180e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101811:	a3 40 a2 21 f0       	mov    %eax,0xf021a240

	// free the pages we took
	page_free(pp0);
f0101816:	83 ec 0c             	sub    $0xc,%esp
f0101819:	53                   	push   %ebx
f010181a:	e8 53 fc ff ff       	call   f0101472 <page_free>
	page_free(pp1);
f010181f:	83 c4 04             	add    $0x4,%esp
f0101822:	ff 75 e4             	pushl  -0x1c(%ebp)
f0101825:	e8 48 fc ff ff       	call   f0101472 <page_free>
	page_free(pp2);
f010182a:	89 3c 24             	mov    %edi,(%esp)
f010182d:	e8 40 fc ff ff       	call   f0101472 <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101832:	a1 40 a2 21 f0       	mov    0xf021a240,%eax
f0101837:	83 c4 10             	add    $0x10,%esp
f010183a:	eb 05                	jmp    f0101841 <check_page_alloc+0x394>
		--nfree;
f010183c:	83 ee 01             	sub    $0x1,%esi
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010183f:	8b 00                	mov    (%eax),%eax
f0101841:	85 c0                	test   %eax,%eax
f0101843:	75 f7                	jne    f010183c <check_page_alloc+0x38f>
		--nfree;
	assert(nfree == 0);
f0101845:	85 f6                	test   %esi,%esi
f0101847:	74 19                	je     f0101862 <check_page_alloc+0x3b5>
f0101849:	68 3a 73 10 f0       	push   $0xf010733a
f010184e:	68 9b 71 10 f0       	push   $0xf010719b
f0101853:	68 86 03 00 00       	push   $0x386
f0101858:	68 81 71 10 f0       	push   $0xf0107181
f010185d:	e8 10 e8 ff ff       	call   f0100072 <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0101862:	83 ec 0c             	sub    $0xc,%esp
f0101865:	68 d0 6a 10 f0       	push   $0xf0106ad0
f010186a:	e8 ec 1e 00 00       	call   f010375b <cprintf>
}
f010186f:	83 c4 10             	add    $0x10,%esp
f0101872:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101875:	5b                   	pop    %ebx
f0101876:	5e                   	pop    %esi
f0101877:	5f                   	pop    %edi
f0101878:	5d                   	pop    %ebp
f0101879:	c3                   	ret    

f010187a <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo *pp)
{
f010187a:	55                   	push   %ebp
f010187b:	89 e5                	mov    %esp,%ebp
f010187d:	83 ec 08             	sub    $0x8,%esp
f0101880:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101883:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0101887:	83 e8 01             	sub    $0x1,%eax
f010188a:	66 89 42 04          	mov    %ax,0x4(%edx)
f010188e:	66 85 c0             	test   %ax,%ax
f0101891:	75 0c                	jne    f010189f <page_decref+0x25>
		page_free(pp);
f0101893:	83 ec 0c             	sub    $0xc,%esp
f0101896:	52                   	push   %edx
f0101897:	e8 d6 fb ff ff       	call   f0101472 <page_free>
f010189c:	83 c4 10             	add    $0x10,%esp
}
f010189f:	c9                   	leave  
f01018a0:	c3                   	ret    

f01018a1 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f01018a1:	55                   	push   %ebp
f01018a2:	89 e5                	mov    %esp,%ebp
f01018a4:	56                   	push   %esi
f01018a5:	53                   	push   %ebx
f01018a6:	8b 75 0c             	mov    0xc(%ebp),%esi

	pde_t * pde = &pgdir[PDX(va)];
f01018a9:	89 f3                	mov    %esi,%ebx
f01018ab:	c1 eb 16             	shr    $0x16,%ebx
f01018ae:	c1 e3 02             	shl    $0x2,%ebx
f01018b1:	03 5d 08             	add    0x8(%ebp),%ebx
	physaddr_t ppn;
	pte_t * pte;
	if((*pde)) {
f01018b4:	8b 0b                	mov    (%ebx),%ecx
f01018b6:	85 c9                	test   %ecx,%ecx
f01018b8:	74 22                	je     f01018dc <pgdir_walk+0x3b>
		return (pte_t *) KADDR(PTE_ADDR(*pde))+ PTX(va);
f01018ba:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01018c0:	ba df 01 00 00       	mov    $0x1df,%edx
f01018c5:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f01018ca:	e8 36 f4 ff ff       	call   f0100d05 <_kaddr>
f01018cf:	c1 ee 0a             	shr    $0xa,%esi
f01018d2:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01018d8:	01 f0                	add    %esi,%eax
f01018da:	eb 50                	jmp    f010192c <pgdir_walk+0x8b>
	}else{
		if(!create){
			return NULL;
f01018dc:	b8 00 00 00 00       	mov    $0x0,%eax
	physaddr_t ppn;
	pte_t * pte;
	if((*pde)) {
		return (pte_t *) KADDR(PTE_ADDR(*pde))+ PTX(va);
	}else{
		if(!create){
f01018e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01018e5:	74 45                	je     f010192c <pgdir_walk+0x8b>
			return NULL;
		}else{
			struct PageInfo * np = page_alloc(ALLOC_ZERO);
f01018e7:	83 ec 0c             	sub    $0xc,%esp
f01018ea:	6a 01                	push   $0x1
f01018ec:	e8 3c fb ff ff       	call   f010142d <page_alloc>
			if(np == NULL){
f01018f1:	83 c4 10             	add    $0x10,%esp
f01018f4:	85 c0                	test   %eax,%eax
f01018f6:	74 2f                	je     f0101927 <pgdir_walk+0x86>
				return NULL;
			}
			np->pp_ref+=1;
f01018f8:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
			physaddr_t ppa = page2pa(np);
f01018fd:	e8 d6 f2 ff ff       	call   f0100bd8 <page2pa>
			pgdir[PDX(va)]= (ppa | PTE_P)|PTE_U;
f0101902:	89 c2                	mov    %eax,%edx
f0101904:	83 ca 05             	or     $0x5,%edx
f0101907:	89 13                	mov    %edx,(%ebx)
			pte = KADDR(ppa);
f0101909:	89 c1                	mov    %eax,%ecx
f010190b:	ba eb 01 00 00       	mov    $0x1eb,%edx
f0101910:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0101915:	e8 eb f3 ff ff       	call   f0100d05 <_kaddr>
		}
	}
	return pte+PTX(va);
f010191a:	c1 ee 0a             	shr    $0xa,%esi
f010191d:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101923:	01 f0                	add    %esi,%eax
f0101925:	eb 05                	jmp    f010192c <pgdir_walk+0x8b>
		if(!create){
			return NULL;
		}else{
			struct PageInfo * np = page_alloc(ALLOC_ZERO);
			if(np == NULL){
				return NULL;
f0101927:	b8 00 00 00 00       	mov    $0x0,%eax
			pgdir[PDX(va)]= (ppa | PTE_P)|PTE_U;
			pte = KADDR(ppa);
		}
	}
	return pte+PTX(va);
}
f010192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010192f:	5b                   	pop    %ebx
f0101930:	5e                   	pop    %esi
f0101931:	5d                   	pop    %ebp
f0101932:	c3                   	ret    

f0101933 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f0101933:	55                   	push   %ebp
f0101934:	89 e5                	mov    %esp,%ebp
f0101936:	57                   	push   %edi
f0101937:	56                   	push   %esi
f0101938:	53                   	push   %ebx
f0101939:	83 ec 1c             	sub    $0x1c,%esp
f010193c:	89 c7                	mov    %eax,%edi
f010193e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	#ifndef TP1_PSE
    		size_t pos;
		pte_t* pte = NULL;
		for (pos = 0; pos < size; pos+=PGSIZE){
f0101941:	89 d3                	mov    %edx,%ebx
f0101943:	be 00 00 00 00       	mov    $0x0,%esi
			pte = pgdir_walk(pgdir, (void*)va + pos, 1);
			*pte = (pa + pos) | (perm | PTE_P);
f0101948:	8b 45 0c             	mov    0xc(%ebp),%eax
f010194b:	83 c8 01             	or     $0x1,%eax
f010194e:	89 45 e0             	mov    %eax,-0x20(%ebp)
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	#ifndef TP1_PSE
    		size_t pos;
		pte_t* pte = NULL;
		for (pos = 0; pos < size; pos+=PGSIZE){
f0101951:	eb 30                	jmp    f0101983 <boot_map_region+0x50>
			pte = pgdir_walk(pgdir, (void*)va + pos, 1);
f0101953:	83 ec 04             	sub    $0x4,%esp
f0101956:	6a 01                	push   $0x1
f0101958:	53                   	push   %ebx
f0101959:	57                   	push   %edi
f010195a:	e8 42 ff ff ff       	call   f01018a1 <pgdir_walk>
			*pte = (pa + pos) | (perm | PTE_P);
f010195f:	89 f2                	mov    %esi,%edx
f0101961:	03 55 08             	add    0x8(%ebp),%edx
f0101964:	0b 55 e0             	or     -0x20(%ebp),%edx
f0101967:	89 10                	mov    %edx,(%eax)
			pgdir[PDX(va + pos)] = pgdir[PDX(va + pos)] | perm;
f0101969:	89 d8                	mov    %ebx,%eax
f010196b:	c1 e8 16             	shr    $0x16,%eax
f010196e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0101971:	09 0c 87             	or     %ecx,(%edi,%eax,4)
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	#ifndef TP1_PSE
    		size_t pos;
		pte_t* pte = NULL;
		for (pos = 0; pos < size; pos+=PGSIZE){
f0101974:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010197a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101980:	83 c4 10             	add    $0x10,%esp
f0101983:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f0101986:	72 cb                	jb     f0101953 <boot_map_region+0x20>
				pgdir[PDX(va + pos)] = pgdir[PDX(va + pos)] | perm;
			}
			
		}                                                                                                                                                                                          
	#endif		
}
f0101988:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010198b:	5b                   	pop    %ebx
f010198c:	5e                   	pop    %esi
f010198d:	5f                   	pop    %edi
f010198e:	5d                   	pop    %ebp
f010198f:	c3                   	ret    

f0101990 <mem_init_mp>:
// Modify mappings in kern_pgdir to support SMP
//   - Map the per-CPU stacks in the region [KSTACKTOP-PTSIZE, KSTACKTOP)
//
static void
mem_init_mp(void)
{
f0101990:	55                   	push   %ebp
f0101991:	89 e5                	mov    %esp,%ebp
f0101993:	56                   	push   %esi
f0101994:	53                   	push   %ebx
f0101995:	be 00 c0 21 f0       	mov    $0xf021c000,%esi
f010199a:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
	physaddr_t pa;
	int perm = PTE_W;
	for(int i = 0; i<NCPU; i++){
		uintptr_t kstacktop_i = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
		va = kstacktop_i - KSTKSIZE;
		pa = PADDR(percpu_kstacks[i]);
f010199f:	89 f1                	mov    %esi,%ecx
f01019a1:	ba 44 01 00 00       	mov    $0x144,%edx
f01019a6:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f01019ab:	e8 0f f4 ff ff       	call   f0100dbf <_paddr>
		boot_map_region(kern_pgdir,va, KSTKSIZE,pa ,perm);
f01019b0:	83 ec 08             	sub    $0x8,%esp
f01019b3:	6a 02                	push   $0x2
f01019b5:	50                   	push   %eax
f01019b6:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01019bb:	89 da                	mov    %ebx,%edx
f01019bd:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f01019c2:	e8 6c ff ff ff       	call   f0101933 <boot_map_region>
f01019c7:	81 c6 00 80 00 00    	add    $0x8000,%esi
f01019cd:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
	//
	// LAB 4: Your code here:TP3: Multitarea con desalojo
	uintptr_t va;
	physaddr_t pa;
	int perm = PTE_W;
	for(int i = 0; i<NCPU; i++){
f01019d3:	83 c4 10             	add    $0x10,%esp
f01019d6:	81 fb 00 80 f7 ef    	cmp    $0xeff78000,%ebx
f01019dc:	75 c1                	jne    f010199f <mem_init_mp+0xf>
		va = kstacktop_i - KSTKSIZE;
		pa = PADDR(percpu_kstacks[i]);
		boot_map_region(kern_pgdir,va, KSTKSIZE,pa ,perm);
	}
	
}
f01019de:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01019e1:	5b                   	pop    %ebx
f01019e2:	5e                   	pop    %esi
f01019e3:	5d                   	pop    %ebp
f01019e4:	c3                   	ret    

f01019e5 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{	
f01019e5:	55                   	push   %ebp
f01019e6:	89 e5                	mov    %esp,%ebp
f01019e8:	53                   	push   %ebx
f01019e9:	83 ec 08             	sub    $0x8,%esp
f01019ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pte = pgdir_walk(pgdir, va, 0);
f01019ef:	6a 00                	push   $0x0
f01019f1:	ff 75 0c             	pushl  0xc(%ebp)
f01019f4:	ff 75 08             	pushl  0x8(%ebp)
f01019f7:	e8 a5 fe ff ff       	call   f01018a1 <pgdir_walk>
	if (pte_store){
f01019fc:	83 c4 10             	add    $0x10,%esp
f01019ff:	85 db                	test   %ebx,%ebx
f0101a01:	74 02                	je     f0101a05 <page_lookup+0x20>
		*pte_store = pte;
f0101a03:	89 03                	mov    %eax,(%ebx)
	}
	if (pte){
f0101a05:	85 c0                	test   %eax,%eax
f0101a07:	74 0e                	je     f0101a17 <page_lookup+0x32>
		return pa2page(PTE_ADDR(*pte));
f0101a09:	8b 00                	mov    (%eax),%eax
f0101a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101a10:	e8 22 f9 ff ff       	call   f0101337 <pa2page>
f0101a15:	eb 05                	jmp    f0101a1c <page_lookup+0x37>
	}
	return NULL;
f0101a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101a1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101a1f:	c9                   	leave  
f0101a20:	c3                   	ret    

f0101a21 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//n
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0101a21:	55                   	push   %ebp
f0101a22:	89 e5                	mov    %esp,%ebp
f0101a24:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0101a27:	e8 9e 41 00 00       	call   f0105bca <cpunum>
f0101a2c:	6b c0 74             	imul   $0x74,%eax,%eax
f0101a2f:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f0101a36:	74 16                	je     f0101a4e <tlb_invalidate+0x2d>
f0101a38:	e8 8d 41 00 00       	call   f0105bca <cpunum>
f0101a3d:	6b c0 74             	imul   $0x74,%eax,%eax
f0101a40:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0101a46:	8b 55 08             	mov    0x8(%ebp),%edx
f0101a49:	39 50 60             	cmp    %edx,0x60(%eax)
f0101a4c:	75 08                	jne    f0101a56 <tlb_invalidate+0x35>
		invlpg(va);
f0101a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101a51:	e8 62 f1 ff ff       	call   f0100bb8 <invlpg>
}
f0101a56:	c9                   	leave  
f0101a57:	c3                   	ret    

f0101a58 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101a58:	55                   	push   %ebp
f0101a59:	89 e5                	mov    %esp,%ebp
f0101a5b:	56                   	push   %esi
f0101a5c:	53                   	push   %ebx
f0101a5d:	83 ec 14             	sub    $0x14,%esp
f0101a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101a63:	8b 75 0c             	mov    0xc(%ebp),%esi
	pte_t *pte_store;
	struct PageInfo *pp = page_lookup(pgdir, va, &pte_store);
f0101a66:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101a69:	50                   	push   %eax
f0101a6a:	56                   	push   %esi
f0101a6b:	53                   	push   %ebx
f0101a6c:	e8 74 ff ff ff       	call   f01019e5 <page_lookup>
	if (!pp){
f0101a71:	83 c4 10             	add    $0x10,%esp
f0101a74:	85 c0                	test   %eax,%eax
f0101a76:	74 26                	je     f0101a9e <page_remove+0x46>

	}else{
		 page_decref(pp);
f0101a78:	83 ec 0c             	sub    $0xc,%esp
f0101a7b:	50                   	push   %eax
f0101a7c:	e8 f9 fd ff ff       	call   f010187a <page_decref>
		  if (pte_store) {
f0101a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101a84:	83 c4 10             	add    $0x10,%esp
f0101a87:	85 c0                	test   %eax,%eax
f0101a89:	74 13                	je     f0101a9e <page_remove+0x46>
		  	*pte_store = 0;
f0101a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		  	tlb_invalidate(pgdir, va);
f0101a91:	83 ec 08             	sub    $0x8,%esp
f0101a94:	56                   	push   %esi
f0101a95:	53                   	push   %ebx
f0101a96:	e8 86 ff ff ff       	call   f0101a21 <tlb_invalidate>
f0101a9b:	83 c4 10             	add    $0x10,%esp
		  }
	}
}
f0101a9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101aa1:	5b                   	pop    %ebx
f0101aa2:	5e                   	pop    %esi
f0101aa3:	5d                   	pop    %ebp
f0101aa4:	c3                   	ret    

f0101aa5 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f0101aa5:	55                   	push   %ebp
f0101aa6:	89 e5                	mov    %esp,%ebp
f0101aa8:	57                   	push   %edi
f0101aa9:	56                   	push   %esi
f0101aaa:	53                   	push   %ebx
f0101aab:	83 ec 10             	sub    $0x10,%esp
f0101aae:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101ab1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	pte_t *pte = pgdir_walk(pgdir, va, 1);
f0101ab4:	6a 01                	push   $0x1
f0101ab6:	ff 75 10             	pushl  0x10(%ebp)
f0101ab9:	53                   	push   %ebx
f0101aba:	e8 e2 fd ff ff       	call   f01018a1 <pgdir_walk>
	if (!pte) {
f0101abf:	83 c4 10             	add    $0x10,%esp
f0101ac2:	85 c0                	test   %eax,%eax
f0101ac4:	74 3f                	je     f0101b05 <page_insert+0x60>
f0101ac6:	89 c6                	mov    %eax,%esi
		return -E_NO_MEM;
	}
	pp->pp_ref++;
f0101ac8:	66 83 47 04 01       	addw   $0x1,0x4(%edi)
	if (pte && (*pte & PTE_P)){
f0101acd:	f6 00 01             	testb  $0x1,(%eax)
f0101ad0:	74 0f                	je     f0101ae1 <page_insert+0x3c>
		page_remove(pgdir, va);
f0101ad2:	83 ec 08             	sub    $0x8,%esp
f0101ad5:	ff 75 10             	pushl  0x10(%ebp)
f0101ad8:	53                   	push   %ebx
f0101ad9:	e8 7a ff ff ff       	call   f0101a58 <page_remove>
f0101ade:	83 c4 10             	add    $0x10,%esp
	}
	physaddr_t pa = page2pa(pp);
f0101ae1:	89 f8                	mov    %edi,%eax
f0101ae3:	e8 f0 f0 ff ff       	call   f0100bd8 <page2pa>
	*pte = pa | (perm | PTE_P);
f0101ae8:	8b 55 14             	mov    0x14(%ebp),%edx
f0101aeb:	83 ca 01             	or     $0x1,%edx
f0101aee:	09 d0                	or     %edx,%eax
f0101af0:	89 06                	mov    %eax,(%esi)
	pgdir[PDX(va)] = pgdir[PDX(va)] | perm;
f0101af2:	8b 45 10             	mov    0x10(%ebp),%eax
f0101af5:	c1 e8 16             	shr    $0x16,%eax
f0101af8:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0101afb:	09 0c 83             	or     %ecx,(%ebx,%eax,4)
	return 0;
f0101afe:	b8 00 00 00 00       	mov    $0x0,%eax
f0101b03:	eb 05                	jmp    f0101b0a <page_insert+0x65>
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	pte_t *pte = pgdir_walk(pgdir, va, 1);
	if (!pte) {
		return -E_NO_MEM;
f0101b05:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	}
	physaddr_t pa = page2pa(pp);
	*pte = pa | (perm | PTE_P);
	pgdir[PDX(va)] = pgdir[PDX(va)] | perm;
	return 0;
}
f0101b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101b0d:	5b                   	pop    %ebx
f0101b0e:	5e                   	pop    %esi
f0101b0f:	5f                   	pop    %edi
f0101b10:	5d                   	pop    %ebp
f0101b11:	c3                   	ret    

f0101b12 <check_page_installed_pgdir>:
}

// check page_insert, page_remove, &c, with an installed kern_pgdir
static void
check_page_installed_pgdir(void)
{
f0101b12:	55                   	push   %ebp
f0101b13:	89 e5                	mov    %esp,%ebp
f0101b15:	57                   	push   %edi
f0101b16:	56                   	push   %esi
f0101b17:	53                   	push   %ebx
f0101b18:	83 ec 18             	sub    $0x18,%esp
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101b1b:	6a 00                	push   $0x0
f0101b1d:	e8 0b f9 ff ff       	call   f010142d <page_alloc>
f0101b22:	83 c4 10             	add    $0x10,%esp
f0101b25:	85 c0                	test   %eax,%eax
f0101b27:	75 19                	jne    f0101b42 <check_page_installed_pgdir+0x30>
f0101b29:	68 9f 72 10 f0       	push   $0xf010729f
f0101b2e:	68 9b 71 10 f0       	push   $0xf010719b
f0101b33:	68 ac 04 00 00       	push   $0x4ac
f0101b38:	68 81 71 10 f0       	push   $0xf0107181
f0101b3d:	e8 30 e5 ff ff       	call   f0100072 <_panic>
f0101b42:	89 c6                	mov    %eax,%esi
	assert((pp1 = page_alloc(0)));
f0101b44:	83 ec 0c             	sub    $0xc,%esp
f0101b47:	6a 00                	push   $0x0
f0101b49:	e8 df f8 ff ff       	call   f010142d <page_alloc>
f0101b4e:	89 c7                	mov    %eax,%edi
f0101b50:	83 c4 10             	add    $0x10,%esp
f0101b53:	85 c0                	test   %eax,%eax
f0101b55:	75 19                	jne    f0101b70 <check_page_installed_pgdir+0x5e>
f0101b57:	68 b5 72 10 f0       	push   $0xf01072b5
f0101b5c:	68 9b 71 10 f0       	push   $0xf010719b
f0101b61:	68 ad 04 00 00       	push   $0x4ad
f0101b66:	68 81 71 10 f0       	push   $0xf0107181
f0101b6b:	e8 02 e5 ff ff       	call   f0100072 <_panic>
	assert((pp2 = page_alloc(0)));
f0101b70:	83 ec 0c             	sub    $0xc,%esp
f0101b73:	6a 00                	push   $0x0
f0101b75:	e8 b3 f8 ff ff       	call   f010142d <page_alloc>
f0101b7a:	89 c3                	mov    %eax,%ebx
f0101b7c:	83 c4 10             	add    $0x10,%esp
f0101b7f:	85 c0                	test   %eax,%eax
f0101b81:	75 19                	jne    f0101b9c <check_page_installed_pgdir+0x8a>
f0101b83:	68 cb 72 10 f0       	push   $0xf01072cb
f0101b88:	68 9b 71 10 f0       	push   $0xf010719b
f0101b8d:	68 ae 04 00 00       	push   $0x4ae
f0101b92:	68 81 71 10 f0       	push   $0xf0107181
f0101b97:	e8 d6 e4 ff ff       	call   f0100072 <_panic>
	page_free(pp0);
f0101b9c:	83 ec 0c             	sub    $0xc,%esp
f0101b9f:	56                   	push   %esi
f0101ba0:	e8 cd f8 ff ff       	call   f0101472 <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f0101ba5:	89 f8                	mov    %edi,%eax
f0101ba7:	e8 85 f1 ff ff       	call   f0100d31 <page2kva>
f0101bac:	83 c4 0c             	add    $0xc,%esp
f0101baf:	68 00 10 00 00       	push   $0x1000
f0101bb4:	6a 01                	push   $0x1
f0101bb6:	50                   	push   %eax
f0101bb7:	e8 6d 39 00 00       	call   f0105529 <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f0101bbc:	89 d8                	mov    %ebx,%eax
f0101bbe:	e8 6e f1 ff ff       	call   f0100d31 <page2kva>
f0101bc3:	83 c4 0c             	add    $0xc,%esp
f0101bc6:	68 00 10 00 00       	push   $0x1000
f0101bcb:	6a 02                	push   $0x2
f0101bcd:	50                   	push   %eax
f0101bce:	e8 56 39 00 00       	call   f0105529 <memset>
	page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W);
f0101bd3:	6a 02                	push   $0x2
f0101bd5:	68 00 10 00 00       	push   $0x1000
f0101bda:	57                   	push   %edi
f0101bdb:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0101be1:	e8 bf fe ff ff       	call   f0101aa5 <page_insert>
	assert(pp1->pp_ref == 1);
f0101be6:	83 c4 20             	add    $0x20,%esp
f0101be9:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101bee:	74 19                	je     f0101c09 <check_page_installed_pgdir+0xf7>
f0101bf0:	68 45 73 10 f0       	push   $0xf0107345
f0101bf5:	68 9b 71 10 f0       	push   $0xf010719b
f0101bfa:	68 b3 04 00 00       	push   $0x4b3
f0101bff:	68 81 71 10 f0       	push   $0xf0107181
f0101c04:	e8 69 e4 ff ff       	call   f0100072 <_panic>
	assert(*(uint32_t *) PGSIZE == 0x01010101U);
f0101c09:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0101c10:	01 01 01 
f0101c13:	74 19                	je     f0101c2e <check_page_installed_pgdir+0x11c>
f0101c15:	68 f0 6a 10 f0       	push   $0xf0106af0
f0101c1a:	68 9b 71 10 f0       	push   $0xf010719b
f0101c1f:	68 b4 04 00 00       	push   $0x4b4
f0101c24:	68 81 71 10 f0       	push   $0xf0107181
f0101c29:	e8 44 e4 ff ff       	call   f0100072 <_panic>
	page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W);
f0101c2e:	6a 02                	push   $0x2
f0101c30:	68 00 10 00 00       	push   $0x1000
f0101c35:	53                   	push   %ebx
f0101c36:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0101c3c:	e8 64 fe ff ff       	call   f0101aa5 <page_insert>
	assert(*(uint32_t *) PGSIZE == 0x02020202U);
f0101c41:	83 c4 10             	add    $0x10,%esp
f0101c44:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0101c4b:	02 02 02 
f0101c4e:	74 19                	je     f0101c69 <check_page_installed_pgdir+0x157>
f0101c50:	68 14 6b 10 f0       	push   $0xf0106b14
f0101c55:	68 9b 71 10 f0       	push   $0xf010719b
f0101c5a:	68 b6 04 00 00       	push   $0x4b6
f0101c5f:	68 81 71 10 f0       	push   $0xf0107181
f0101c64:	e8 09 e4 ff ff       	call   f0100072 <_panic>
	assert(pp2->pp_ref == 1);
f0101c69:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101c6e:	74 19                	je     f0101c89 <check_page_installed_pgdir+0x177>
f0101c70:	68 56 73 10 f0       	push   $0xf0107356
f0101c75:	68 9b 71 10 f0       	push   $0xf010719b
f0101c7a:	68 b7 04 00 00       	push   $0x4b7
f0101c7f:	68 81 71 10 f0       	push   $0xf0107181
f0101c84:	e8 e9 e3 ff ff       	call   f0100072 <_panic>
	assert(pp1->pp_ref == 0);
f0101c89:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101c8e:	74 19                	je     f0101ca9 <check_page_installed_pgdir+0x197>
f0101c90:	68 67 73 10 f0       	push   $0xf0107367
f0101c95:	68 9b 71 10 f0       	push   $0xf010719b
f0101c9a:	68 b8 04 00 00       	push   $0x4b8
f0101c9f:	68 81 71 10 f0       	push   $0xf0107181
f0101ca4:	e8 c9 e3 ff ff       	call   f0100072 <_panic>
	*(uint32_t *) PGSIZE = 0x03030303U;
f0101ca9:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0101cb0:	03 03 03 
	assert(*(uint32_t *) page2kva(pp2) == 0x03030303U);
f0101cb3:	89 d8                	mov    %ebx,%eax
f0101cb5:	e8 77 f0 ff ff       	call   f0100d31 <page2kva>
f0101cba:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f0101cc0:	74 19                	je     f0101cdb <check_page_installed_pgdir+0x1c9>
f0101cc2:	68 38 6b 10 f0       	push   $0xf0106b38
f0101cc7:	68 9b 71 10 f0       	push   $0xf010719b
f0101ccc:	68 ba 04 00 00       	push   $0x4ba
f0101cd1:	68 81 71 10 f0       	push   $0xf0107181
f0101cd6:	e8 97 e3 ff ff       	call   f0100072 <_panic>
	page_remove(kern_pgdir, (void *) PGSIZE);
f0101cdb:	83 ec 08             	sub    $0x8,%esp
f0101cde:	68 00 10 00 00       	push   $0x1000
f0101ce3:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0101ce9:	e8 6a fd ff ff       	call   f0101a58 <page_remove>
	assert(pp2->pp_ref == 0);
f0101cee:	83 c4 10             	add    $0x10,%esp
f0101cf1:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101cf6:	74 19                	je     f0101d11 <check_page_installed_pgdir+0x1ff>
f0101cf8:	68 78 73 10 f0       	push   $0xf0107378
f0101cfd:	68 9b 71 10 f0       	push   $0xf010719b
f0101d02:	68 bc 04 00 00       	push   $0x4bc
f0101d07:	68 81 71 10 f0       	push   $0xf0107181
f0101d0c:	e8 61 e3 ff ff       	call   f0100072 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d11:	8b 1d 8c ae 21 f0    	mov    0xf021ae8c,%ebx
f0101d17:	89 f0                	mov    %esi,%eax
f0101d19:	e8 ba ee ff ff       	call   f0100bd8 <page2pa>
f0101d1e:	8b 13                	mov    (%ebx),%edx
f0101d20:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101d26:	39 c2                	cmp    %eax,%edx
f0101d28:	74 19                	je     f0101d43 <check_page_installed_pgdir+0x231>
f0101d2a:	68 64 6b 10 f0       	push   $0xf0106b64
f0101d2f:	68 9b 71 10 f0       	push   $0xf010719b
f0101d34:	68 bf 04 00 00       	push   $0x4bf
f0101d39:	68 81 71 10 f0       	push   $0xf0107181
f0101d3e:	e8 2f e3 ff ff       	call   f0100072 <_panic>
	kern_pgdir[0] = 0;
f0101d43:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	assert(pp0->pp_ref == 1);
f0101d49:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101d4e:	74 19                	je     f0101d69 <check_page_installed_pgdir+0x257>
f0101d50:	68 89 73 10 f0       	push   $0xf0107389
f0101d55:	68 9b 71 10 f0       	push   $0xf010719b
f0101d5a:	68 c1 04 00 00       	push   $0x4c1
f0101d5f:	68 81 71 10 f0       	push   $0xf0107181
f0101d64:	e8 09 e3 ff ff       	call   f0100072 <_panic>
	pp0->pp_ref = 0;
f0101d69:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0101d6f:	83 ec 0c             	sub    $0xc,%esp
f0101d72:	56                   	push   %esi
f0101d73:	e8 fa f6 ff ff       	call   f0101472 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0101d78:	c7 04 24 8c 6b 10 f0 	movl   $0xf0106b8c,(%esp)
f0101d7f:	e8 d7 19 00 00       	call   f010375b <cprintf>
}
f0101d84:	83 c4 10             	add    $0x10,%esp
f0101d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101d8a:	5b                   	pop    %ebx
f0101d8b:	5e                   	pop    %esi
f0101d8c:	5f                   	pop    %edi
f0101d8d:	5d                   	pop    %ebp
f0101d8e:	c3                   	ret    

f0101d8f <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f0101d8f:	55                   	push   %ebp
f0101d90:	89 e5                	mov    %esp,%ebp
f0101d92:	53                   	push   %ebx
f0101d93:	83 ec 04             	sub    $0x4,%esp
	// okay to simply panic if this happens).
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:	
	size_t sizeR = ROUNDUP(size,PGSIZE);
f0101d96:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101d99:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f0101d9f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	physaddr_t paR = ROUNDDOWN(pa,PGSIZE);
f0101da5:	8b 45 08             	mov    0x8(%ebp),%eax
f0101da8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	int perm = PTE_PCD|PTE_PWT|PTE_W;
	uintptr_t ret;

	if(base+sizeR >= MMIOLIM){
f0101dad:	8b 15 00 13 12 f0    	mov    0xf0121300,%edx
f0101db3:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
f0101db6:	81 f9 ff ff bf ef    	cmp    $0xefbfffff,%ecx
f0101dbc:	76 17                	jbe    f0101dd5 <mmio_map_region+0x46>
		panic("No hay memoria suficiente");
f0101dbe:	83 ec 04             	sub    $0x4,%esp
f0101dc1:	68 9a 73 10 f0       	push   $0xf010739a
f0101dc6:	68 b0 02 00 00       	push   $0x2b0
f0101dcb:	68 81 71 10 f0       	push   $0xf0107181
f0101dd0:	e8 9d e2 ff ff       	call   f0100072 <_panic>
	}
	boot_map_region(kern_pgdir,base,sizeR,paR,perm);
f0101dd5:	83 ec 08             	sub    $0x8,%esp
f0101dd8:	6a 1a                	push   $0x1a
f0101dda:	50                   	push   %eax
f0101ddb:	89 d9                	mov    %ebx,%ecx
f0101ddd:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0101de2:	e8 4c fb ff ff       	call   f0101933 <boot_map_region>
	ret = base;
f0101de7:	a1 00 13 12 f0       	mov    0xf0121300,%eax
	base+= sizeR;
f0101dec:	01 c3                	add    %eax,%ebx
f0101dee:	89 1d 00 13 12 f0    	mov    %ebx,0xf0121300
	return (void *) ret;	

	//panic("mmio_map_region not implemented");
}
f0101df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101df7:	c9                   	leave  
f0101df8:	c3                   	ret    

f0101df9 <check_page>:


// check page_insert, page_remove, &c
static void
check_page(void)
{
f0101df9:	55                   	push   %ebp
f0101dfa:	89 e5                	mov    %esp,%ebp
f0101dfc:	57                   	push   %edi
f0101dfd:	56                   	push   %esi
f0101dfe:	53                   	push   %ebx
f0101dff:	83 ec 38             	sub    $0x38,%esp
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101e02:	6a 00                	push   $0x0
f0101e04:	e8 24 f6 ff ff       	call   f010142d <page_alloc>
f0101e09:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101e0c:	83 c4 10             	add    $0x10,%esp
f0101e0f:	85 c0                	test   %eax,%eax
f0101e11:	75 19                	jne    f0101e2c <check_page+0x33>
f0101e13:	68 9f 72 10 f0       	push   $0xf010729f
f0101e18:	68 9b 71 10 f0       	push   $0xf010719b
f0101e1d:	68 f7 03 00 00       	push   $0x3f7
f0101e22:	68 81 71 10 f0       	push   $0xf0107181
f0101e27:	e8 46 e2 ff ff       	call   f0100072 <_panic>
	assert((pp1 = page_alloc(0)));
f0101e2c:	83 ec 0c             	sub    $0xc,%esp
f0101e2f:	6a 00                	push   $0x0
f0101e31:	e8 f7 f5 ff ff       	call   f010142d <page_alloc>
f0101e36:	89 c6                	mov    %eax,%esi
f0101e38:	83 c4 10             	add    $0x10,%esp
f0101e3b:	85 c0                	test   %eax,%eax
f0101e3d:	75 19                	jne    f0101e58 <check_page+0x5f>
f0101e3f:	68 b5 72 10 f0       	push   $0xf01072b5
f0101e44:	68 9b 71 10 f0       	push   $0xf010719b
f0101e49:	68 f8 03 00 00       	push   $0x3f8
f0101e4e:	68 81 71 10 f0       	push   $0xf0107181
f0101e53:	e8 1a e2 ff ff       	call   f0100072 <_panic>
	assert((pp2 = page_alloc(0)));
f0101e58:	83 ec 0c             	sub    $0xc,%esp
f0101e5b:	6a 00                	push   $0x0
f0101e5d:	e8 cb f5 ff ff       	call   f010142d <page_alloc>
f0101e62:	89 c3                	mov    %eax,%ebx
f0101e64:	83 c4 10             	add    $0x10,%esp
f0101e67:	85 c0                	test   %eax,%eax
f0101e69:	75 19                	jne    f0101e84 <check_page+0x8b>
f0101e6b:	68 cb 72 10 f0       	push   $0xf01072cb
f0101e70:	68 9b 71 10 f0       	push   $0xf010719b
f0101e75:	68 f9 03 00 00       	push   $0x3f9
f0101e7a:	68 81 71 10 f0       	push   $0xf0107181
f0101e7f:	e8 ee e1 ff ff       	call   f0100072 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101e84:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f0101e87:	75 19                	jne    f0101ea2 <check_page+0xa9>
f0101e89:	68 e1 72 10 f0       	push   $0xf01072e1
f0101e8e:	68 9b 71 10 f0       	push   $0xf010719b
f0101e93:	68 fc 03 00 00       	push   $0x3fc
f0101e98:	68 81 71 10 f0       	push   $0xf0107181
f0101e9d:	e8 d0 e1 ff ff       	call   f0100072 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101ea2:	39 c6                	cmp    %eax,%esi
f0101ea4:	74 05                	je     f0101eab <check_page+0xb2>
f0101ea6:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101ea9:	75 19                	jne    f0101ec4 <check_page+0xcb>
f0101eab:	68 50 6a 10 f0       	push   $0xf0106a50
f0101eb0:	68 9b 71 10 f0       	push   $0xf010719b
f0101eb5:	68 fd 03 00 00       	push   $0x3fd
f0101eba:	68 81 71 10 f0       	push   $0xf0107181
f0101ebf:	e8 ae e1 ff ff       	call   f0100072 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101ec4:	a1 40 a2 21 f0       	mov    0xf021a240,%eax
f0101ec9:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101ecc:	c7 05 40 a2 21 f0 00 	movl   $0x0,0xf021a240
f0101ed3:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101ed6:	83 ec 0c             	sub    $0xc,%esp
f0101ed9:	6a 00                	push   $0x0
f0101edb:	e8 4d f5 ff ff       	call   f010142d <page_alloc>
f0101ee0:	83 c4 10             	add    $0x10,%esp
f0101ee3:	85 c0                	test   %eax,%eax
f0101ee5:	74 19                	je     f0101f00 <check_page+0x107>
f0101ee7:	68 f3 72 10 f0       	push   $0xf01072f3
f0101eec:	68 9b 71 10 f0       	push   $0xf010719b
f0101ef1:	68 04 04 00 00       	push   $0x404
f0101ef6:	68 81 71 10 f0       	push   $0xf0107181
f0101efb:	e8 72 e1 ff ff       	call   f0100072 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101f00:	83 ec 04             	sub    $0x4,%esp
f0101f03:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101f06:	50                   	push   %eax
f0101f07:	6a 00                	push   $0x0
f0101f09:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0101f0f:	e8 d1 fa ff ff       	call   f01019e5 <page_lookup>
f0101f14:	83 c4 10             	add    $0x10,%esp
f0101f17:	85 c0                	test   %eax,%eax
f0101f19:	74 19                	je     f0101f34 <check_page+0x13b>
f0101f1b:	68 b8 6b 10 f0       	push   $0xf0106bb8
f0101f20:	68 9b 71 10 f0       	push   $0xf010719b
f0101f25:	68 07 04 00 00       	push   $0x407
f0101f2a:	68 81 71 10 f0       	push   $0xf0107181
f0101f2f:	e8 3e e1 ff ff       	call   f0100072 <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101f34:	6a 02                	push   $0x2
f0101f36:	6a 00                	push   $0x0
f0101f38:	56                   	push   %esi
f0101f39:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0101f3f:	e8 61 fb ff ff       	call   f0101aa5 <page_insert>
f0101f44:	83 c4 10             	add    $0x10,%esp
f0101f47:	85 c0                	test   %eax,%eax
f0101f49:	78 19                	js     f0101f64 <check_page+0x16b>
f0101f4b:	68 f0 6b 10 f0       	push   $0xf0106bf0
f0101f50:	68 9b 71 10 f0       	push   $0xf010719b
f0101f55:	68 0a 04 00 00       	push   $0x40a
f0101f5a:	68 81 71 10 f0       	push   $0xf0107181
f0101f5f:	e8 0e e1 ff ff       	call   f0100072 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101f64:	83 ec 0c             	sub    $0xc,%esp
f0101f67:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101f6a:	e8 03 f5 ff ff       	call   f0101472 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101f6f:	6a 02                	push   $0x2
f0101f71:	6a 00                	push   $0x0
f0101f73:	56                   	push   %esi
f0101f74:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0101f7a:	e8 26 fb ff ff       	call   f0101aa5 <page_insert>
f0101f7f:	83 c4 20             	add    $0x20,%esp
f0101f82:	85 c0                	test   %eax,%eax
f0101f84:	74 19                	je     f0101f9f <check_page+0x1a6>
f0101f86:	68 20 6c 10 f0       	push   $0xf0106c20
f0101f8b:	68 9b 71 10 f0       	push   $0xf010719b
f0101f90:	68 0e 04 00 00       	push   $0x40e
f0101f95:	68 81 71 10 f0       	push   $0xf0107181
f0101f9a:	e8 d3 e0 ff ff       	call   f0100072 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101f9f:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f0101fa5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fa8:	e8 2b ec ff ff       	call   f0100bd8 <page2pa>
f0101fad:	8b 17                	mov    (%edi),%edx
f0101faf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101fb5:	39 c2                	cmp    %eax,%edx
f0101fb7:	74 19                	je     f0101fd2 <check_page+0x1d9>
f0101fb9:	68 64 6b 10 f0       	push   $0xf0106b64
f0101fbe:	68 9b 71 10 f0       	push   $0xf010719b
f0101fc3:	68 0f 04 00 00       	push   $0x40f
f0101fc8:	68 81 71 10 f0       	push   $0xf0107181
f0101fcd:	e8 a0 e0 ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101fd2:	ba 00 00 00 00       	mov    $0x0,%edx
f0101fd7:	89 f8                	mov    %edi,%eax
f0101fd9:	e8 71 ed ff ff       	call   f0100d4f <check_va2pa>
f0101fde:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101fe1:	89 f0                	mov    %esi,%eax
f0101fe3:	e8 f0 eb ff ff       	call   f0100bd8 <page2pa>
f0101fe8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101feb:	74 19                	je     f0102006 <check_page+0x20d>
f0101fed:	68 50 6c 10 f0       	push   $0xf0106c50
f0101ff2:	68 9b 71 10 f0       	push   $0xf010719b
f0101ff7:	68 10 04 00 00       	push   $0x410
f0101ffc:	68 81 71 10 f0       	push   $0xf0107181
f0102001:	e8 6c e0 ff ff       	call   f0100072 <_panic>
	assert(pp1->pp_ref == 1);
f0102006:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010200b:	74 19                	je     f0102026 <check_page+0x22d>
f010200d:	68 45 73 10 f0       	push   $0xf0107345
f0102012:	68 9b 71 10 f0       	push   $0xf010719b
f0102017:	68 11 04 00 00       	push   $0x411
f010201c:	68 81 71 10 f0       	push   $0xf0107181
f0102021:	e8 4c e0 ff ff       	call   f0100072 <_panic>
	assert(pp0->pp_ref == 1);
f0102026:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102029:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f010202e:	74 19                	je     f0102049 <check_page+0x250>
f0102030:	68 89 73 10 f0       	push   $0xf0107389
f0102035:	68 9b 71 10 f0       	push   $0xf010719b
f010203a:	68 12 04 00 00       	push   $0x412
f010203f:	68 81 71 10 f0       	push   $0xf0107181
f0102044:	e8 29 e0 ff ff       	call   f0100072 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated
	// for page table
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f0102049:	6a 02                	push   $0x2
f010204b:	68 00 10 00 00       	push   $0x1000
f0102050:	53                   	push   %ebx
f0102051:	57                   	push   %edi
f0102052:	e8 4e fa ff ff       	call   f0101aa5 <page_insert>
f0102057:	83 c4 10             	add    $0x10,%esp
f010205a:	85 c0                	test   %eax,%eax
f010205c:	74 19                	je     f0102077 <check_page+0x27e>
f010205e:	68 80 6c 10 f0       	push   $0xf0106c80
f0102063:	68 9b 71 10 f0       	push   $0xf010719b
f0102068:	68 16 04 00 00       	push   $0x416
f010206d:	68 81 71 10 f0       	push   $0xf0107181
f0102072:	e8 fb df ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102077:	ba 00 10 00 00       	mov    $0x1000,%edx
f010207c:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102081:	e8 c9 ec ff ff       	call   f0100d4f <check_va2pa>
f0102086:	89 c7                	mov    %eax,%edi
f0102088:	89 d8                	mov    %ebx,%eax
f010208a:	e8 49 eb ff ff       	call   f0100bd8 <page2pa>
f010208f:	39 c7                	cmp    %eax,%edi
f0102091:	74 19                	je     f01020ac <check_page+0x2b3>
f0102093:	68 bc 6c 10 f0       	push   $0xf0106cbc
f0102098:	68 9b 71 10 f0       	push   $0xf010719b
f010209d:	68 17 04 00 00       	push   $0x417
f01020a2:	68 81 71 10 f0       	push   $0xf0107181
f01020a7:	e8 c6 df ff ff       	call   f0100072 <_panic>
	assert(pp2->pp_ref == 1);
f01020ac:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01020b1:	74 19                	je     f01020cc <check_page+0x2d3>
f01020b3:	68 56 73 10 f0       	push   $0xf0107356
f01020b8:	68 9b 71 10 f0       	push   $0xf010719b
f01020bd:	68 18 04 00 00       	push   $0x418
f01020c2:	68 81 71 10 f0       	push   $0xf0107181
f01020c7:	e8 a6 df ff ff       	call   f0100072 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01020cc:	83 ec 0c             	sub    $0xc,%esp
f01020cf:	6a 00                	push   $0x0
f01020d1:	e8 57 f3 ff ff       	call   f010142d <page_alloc>
f01020d6:	83 c4 10             	add    $0x10,%esp
f01020d9:	85 c0                	test   %eax,%eax
f01020db:	74 19                	je     f01020f6 <check_page+0x2fd>
f01020dd:	68 f3 72 10 f0       	push   $0xf01072f3
f01020e2:	68 9b 71 10 f0       	push   $0xf010719b
f01020e7:	68 1b 04 00 00       	push   $0x41b
f01020ec:	68 81 71 10 f0       	push   $0xf0107181
f01020f1:	e8 7c df ff ff       	call   f0100072 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01020f6:	6a 02                	push   $0x2
f01020f8:	68 00 10 00 00       	push   $0x1000
f01020fd:	53                   	push   %ebx
f01020fe:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102104:	e8 9c f9 ff ff       	call   f0101aa5 <page_insert>
f0102109:	83 c4 10             	add    $0x10,%esp
f010210c:	85 c0                	test   %eax,%eax
f010210e:	74 19                	je     f0102129 <check_page+0x330>
f0102110:	68 80 6c 10 f0       	push   $0xf0106c80
f0102115:	68 9b 71 10 f0       	push   $0xf010719b
f010211a:	68 1e 04 00 00       	push   $0x41e
f010211f:	68 81 71 10 f0       	push   $0xf0107181
f0102124:	e8 49 df ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102129:	ba 00 10 00 00       	mov    $0x1000,%edx
f010212e:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102133:	e8 17 ec ff ff       	call   f0100d4f <check_va2pa>
f0102138:	89 c7                	mov    %eax,%edi
f010213a:	89 d8                	mov    %ebx,%eax
f010213c:	e8 97 ea ff ff       	call   f0100bd8 <page2pa>
f0102141:	39 c7                	cmp    %eax,%edi
f0102143:	74 19                	je     f010215e <check_page+0x365>
f0102145:	68 bc 6c 10 f0       	push   $0xf0106cbc
f010214a:	68 9b 71 10 f0       	push   $0xf010719b
f010214f:	68 1f 04 00 00       	push   $0x41f
f0102154:	68 81 71 10 f0       	push   $0xf0107181
f0102159:	e8 14 df ff ff       	call   f0100072 <_panic>
	assert(pp2->pp_ref == 1);
f010215e:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102163:	74 19                	je     f010217e <check_page+0x385>
f0102165:	68 56 73 10 f0       	push   $0xf0107356
f010216a:	68 9b 71 10 f0       	push   $0xf010719b
f010216f:	68 20 04 00 00       	push   $0x420
f0102174:	68 81 71 10 f0       	push   $0xf0107181
f0102179:	e8 f4 de ff ff       	call   f0100072 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f010217e:	83 ec 0c             	sub    $0xc,%esp
f0102181:	6a 00                	push   $0x0
f0102183:	e8 a5 f2 ff ff       	call   f010142d <page_alloc>
f0102188:	83 c4 10             	add    $0x10,%esp
f010218b:	85 c0                	test   %eax,%eax
f010218d:	74 19                	je     f01021a8 <check_page+0x3af>
f010218f:	68 f3 72 10 f0       	push   $0xf01072f3
f0102194:	68 9b 71 10 f0       	push   $0xf010719b
f0102199:	68 24 04 00 00       	push   $0x424
f010219e:	68 81 71 10 f0       	push   $0xf0107181
f01021a3:	e8 ca de ff ff       	call   f0100072 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f01021a8:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f01021ae:	8b 0f                	mov    (%edi),%ecx
f01021b0:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01021b6:	ba 27 04 00 00       	mov    $0x427,%edx
f01021bb:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f01021c0:	e8 40 eb ff ff       	call   f0100d05 <_kaddr>
f01021c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) == ptep + PTX(PGSIZE));
f01021c8:	83 ec 04             	sub    $0x4,%esp
f01021cb:	6a 00                	push   $0x0
f01021cd:	68 00 10 00 00       	push   $0x1000
f01021d2:	57                   	push   %edi
f01021d3:	e8 c9 f6 ff ff       	call   f01018a1 <pgdir_walk>
f01021d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01021db:	8d 51 04             	lea    0x4(%ecx),%edx
f01021de:	83 c4 10             	add    $0x10,%esp
f01021e1:	39 d0                	cmp    %edx,%eax
f01021e3:	74 19                	je     f01021fe <check_page+0x405>
f01021e5:	68 ec 6c 10 f0       	push   $0xf0106cec
f01021ea:	68 9b 71 10 f0       	push   $0xf010719b
f01021ef:	68 28 04 00 00       	push   $0x428
f01021f4:	68 81 71 10 f0       	push   $0xf0107181
f01021f9:	e8 74 de ff ff       	call   f0100072 <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W | PTE_U) == 0);
f01021fe:	6a 06                	push   $0x6
f0102200:	68 00 10 00 00       	push   $0x1000
f0102205:	53                   	push   %ebx
f0102206:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f010220c:	e8 94 f8 ff ff       	call   f0101aa5 <page_insert>
f0102211:	83 c4 10             	add    $0x10,%esp
f0102214:	85 c0                	test   %eax,%eax
f0102216:	74 19                	je     f0102231 <check_page+0x438>
f0102218:	68 30 6d 10 f0       	push   $0xf0106d30
f010221d:	68 9b 71 10 f0       	push   $0xf010719b
f0102222:	68 2b 04 00 00       	push   $0x42b
f0102227:	68 81 71 10 f0       	push   $0xf0107181
f010222c:	e8 41 de ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102231:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f0102237:	ba 00 10 00 00       	mov    $0x1000,%edx
f010223c:	89 f8                	mov    %edi,%eax
f010223e:	e8 0c eb ff ff       	call   f0100d4f <check_va2pa>
f0102243:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102246:	89 d8                	mov    %ebx,%eax
f0102248:	e8 8b e9 ff ff       	call   f0100bd8 <page2pa>
f010224d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102250:	74 19                	je     f010226b <check_page+0x472>
f0102252:	68 bc 6c 10 f0       	push   $0xf0106cbc
f0102257:	68 9b 71 10 f0       	push   $0xf010719b
f010225c:	68 2c 04 00 00       	push   $0x42c
f0102261:	68 81 71 10 f0       	push   $0xf0107181
f0102266:	e8 07 de ff ff       	call   f0100072 <_panic>
	assert(pp2->pp_ref == 1);
f010226b:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102270:	74 19                	je     f010228b <check_page+0x492>
f0102272:	68 56 73 10 f0       	push   $0xf0107356
f0102277:	68 9b 71 10 f0       	push   $0xf010719b
f010227c:	68 2d 04 00 00       	push   $0x42d
f0102281:	68 81 71 10 f0       	push   $0xf0107181
f0102286:	e8 e7 dd ff ff       	call   f0100072 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U);
f010228b:	83 ec 04             	sub    $0x4,%esp
f010228e:	6a 00                	push   $0x0
f0102290:	68 00 10 00 00       	push   $0x1000
f0102295:	57                   	push   %edi
f0102296:	e8 06 f6 ff ff       	call   f01018a1 <pgdir_walk>
f010229b:	83 c4 10             	add    $0x10,%esp
f010229e:	f6 00 04             	testb  $0x4,(%eax)
f01022a1:	75 19                	jne    f01022bc <check_page+0x4c3>
f01022a3:	68 74 6d 10 f0       	push   $0xf0106d74
f01022a8:	68 9b 71 10 f0       	push   $0xf010719b
f01022ad:	68 2e 04 00 00       	push   $0x42e
f01022b2:	68 81 71 10 f0       	push   $0xf0107181
f01022b7:	e8 b6 dd ff ff       	call   f0100072 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01022bc:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f01022c1:	f6 00 04             	testb  $0x4,(%eax)
f01022c4:	75 19                	jne    f01022df <check_page+0x4e6>
f01022c6:	68 b4 73 10 f0       	push   $0xf01073b4
f01022cb:	68 9b 71 10 f0       	push   $0xf010719b
f01022d0:	68 2f 04 00 00       	push   $0x42f
f01022d5:	68 81 71 10 f0       	push   $0xf0107181
f01022da:	e8 93 dd ff ff       	call   f0100072 <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void *) PGSIZE, PTE_W) == 0);
f01022df:	6a 02                	push   $0x2
f01022e1:	68 00 10 00 00       	push   $0x1000
f01022e6:	53                   	push   %ebx
f01022e7:	50                   	push   %eax
f01022e8:	e8 b8 f7 ff ff       	call   f0101aa5 <page_insert>
f01022ed:	83 c4 10             	add    $0x10,%esp
f01022f0:	85 c0                	test   %eax,%eax
f01022f2:	74 19                	je     f010230d <check_page+0x514>
f01022f4:	68 80 6c 10 f0       	push   $0xf0106c80
f01022f9:	68 9b 71 10 f0       	push   $0xf010719b
f01022fe:	68 32 04 00 00       	push   $0x432
f0102303:	68 81 71 10 f0       	push   $0xf0107181
f0102308:	e8 65 dd ff ff       	call   f0100072 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_W);
f010230d:	83 ec 04             	sub    $0x4,%esp
f0102310:	6a 00                	push   $0x0
f0102312:	68 00 10 00 00       	push   $0x1000
f0102317:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f010231d:	e8 7f f5 ff ff       	call   f01018a1 <pgdir_walk>
f0102322:	83 c4 10             	add    $0x10,%esp
f0102325:	f6 00 02             	testb  $0x2,(%eax)
f0102328:	75 19                	jne    f0102343 <check_page+0x54a>
f010232a:	68 a8 6d 10 f0       	push   $0xf0106da8
f010232f:	68 9b 71 10 f0       	push   $0xf010719b
f0102334:	68 33 04 00 00       	push   $0x433
f0102339:	68 81 71 10 f0       	push   $0xf0107181
f010233e:	e8 2f dd ff ff       	call   f0100072 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f0102343:	83 ec 04             	sub    $0x4,%esp
f0102346:	6a 00                	push   $0x0
f0102348:	68 00 10 00 00       	push   $0x1000
f010234d:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102353:	e8 49 f5 ff ff       	call   f01018a1 <pgdir_walk>
f0102358:	83 c4 10             	add    $0x10,%esp
f010235b:	f6 00 04             	testb  $0x4,(%eax)
f010235e:	74 19                	je     f0102379 <check_page+0x580>
f0102360:	68 dc 6d 10 f0       	push   $0xf0106ddc
f0102365:	68 9b 71 10 f0       	push   $0xf010719b
f010236a:	68 34 04 00 00       	push   $0x434
f010236f:	68 81 71 10 f0       	push   $0xf0107181
f0102374:	e8 f9 dc ff ff       	call   f0100072 <_panic>

	// should not be able to map at PTSIZE because need free page for page
	// table
	assert(page_insert(kern_pgdir, pp0, (void *) PTSIZE, PTE_W) < 0);
f0102379:	6a 02                	push   $0x2
f010237b:	68 00 00 40 00       	push   $0x400000
f0102380:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102383:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102389:	e8 17 f7 ff ff       	call   f0101aa5 <page_insert>
f010238e:	83 c4 10             	add    $0x10,%esp
f0102391:	85 c0                	test   %eax,%eax
f0102393:	78 19                	js     f01023ae <check_page+0x5b5>
f0102395:	68 14 6e 10 f0       	push   $0xf0106e14
f010239a:	68 9b 71 10 f0       	push   $0xf010719b
f010239f:	68 38 04 00 00       	push   $0x438
f01023a4:	68 81 71 10 f0       	push   $0xf0107181
f01023a9:	e8 c4 dc ff ff       	call   f0100072 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, PTE_W) == 0);
f01023ae:	6a 02                	push   $0x2
f01023b0:	68 00 10 00 00       	push   $0x1000
f01023b5:	56                   	push   %esi
f01023b6:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f01023bc:	e8 e4 f6 ff ff       	call   f0101aa5 <page_insert>
f01023c1:	83 c4 10             	add    $0x10,%esp
f01023c4:	85 c0                	test   %eax,%eax
f01023c6:	74 19                	je     f01023e1 <check_page+0x5e8>
f01023c8:	68 50 6e 10 f0       	push   $0xf0106e50
f01023cd:	68 9b 71 10 f0       	push   $0xf010719b
f01023d2:	68 3b 04 00 00       	push   $0x43b
f01023d7:	68 81 71 10 f0       	push   $0xf0107181
f01023dc:	e8 91 dc ff ff       	call   f0100072 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *) PGSIZE, 0) & PTE_U));
f01023e1:	83 ec 04             	sub    $0x4,%esp
f01023e4:	6a 00                	push   $0x0
f01023e6:	68 00 10 00 00       	push   $0x1000
f01023eb:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f01023f1:	e8 ab f4 ff ff       	call   f01018a1 <pgdir_walk>
f01023f6:	83 c4 10             	add    $0x10,%esp
f01023f9:	f6 00 04             	testb  $0x4,(%eax)
f01023fc:	74 19                	je     f0102417 <check_page+0x61e>
f01023fe:	68 dc 6d 10 f0       	push   $0xf0106ddc
f0102403:	68 9b 71 10 f0       	push   $0xf010719b
f0102408:	68 3c 04 00 00       	push   $0x43c
f010240d:	68 81 71 10 f0       	push   $0xf0107181
f0102412:	e8 5b dc ff ff       	call   f0100072 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102417:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f010241d:	ba 00 00 00 00       	mov    $0x0,%edx
f0102422:	89 f8                	mov    %edi,%eax
f0102424:	e8 26 e9 ff ff       	call   f0100d4f <check_va2pa>
f0102429:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010242c:	89 f0                	mov    %esi,%eax
f010242e:	e8 a5 e7 ff ff       	call   f0100bd8 <page2pa>
f0102433:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102436:	74 19                	je     f0102451 <check_page+0x658>
f0102438:	68 8c 6e 10 f0       	push   $0xf0106e8c
f010243d:	68 9b 71 10 f0       	push   $0xf010719b
f0102442:	68 3f 04 00 00       	push   $0x43f
f0102447:	68 81 71 10 f0       	push   $0xf0107181
f010244c:	e8 21 dc ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102451:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102456:	89 f8                	mov    %edi,%eax
f0102458:	e8 f2 e8 ff ff       	call   f0100d4f <check_va2pa>
f010245d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102460:	74 19                	je     f010247b <check_page+0x682>
f0102462:	68 b8 6e 10 f0       	push   $0xf0106eb8
f0102467:	68 9b 71 10 f0       	push   $0xf010719b
f010246c:	68 40 04 00 00       	push   $0x440
f0102471:	68 81 71 10 f0       	push   $0xf0107181
f0102476:	e8 f7 db ff ff       	call   f0100072 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f010247b:	66 83 7e 04 02       	cmpw   $0x2,0x4(%esi)
f0102480:	74 19                	je     f010249b <check_page+0x6a2>
f0102482:	68 ca 73 10 f0       	push   $0xf01073ca
f0102487:	68 9b 71 10 f0       	push   $0xf010719b
f010248c:	68 42 04 00 00       	push   $0x442
f0102491:	68 81 71 10 f0       	push   $0xf0107181
f0102496:	e8 d7 db ff ff       	call   f0100072 <_panic>
	assert(pp2->pp_ref == 0);
f010249b:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01024a0:	74 19                	je     f01024bb <check_page+0x6c2>
f01024a2:	68 78 73 10 f0       	push   $0xf0107378
f01024a7:	68 9b 71 10 f0       	push   $0xf010719b
f01024ac:	68 43 04 00 00       	push   $0x443
f01024b1:	68 81 71 10 f0       	push   $0xf0107181
f01024b6:	e8 b7 db ff ff       	call   f0100072 <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f01024bb:	83 ec 0c             	sub    $0xc,%esp
f01024be:	6a 00                	push   $0x0
f01024c0:	e8 68 ef ff ff       	call   f010142d <page_alloc>
f01024c5:	83 c4 10             	add    $0x10,%esp
f01024c8:	39 c3                	cmp    %eax,%ebx
f01024ca:	75 04                	jne    f01024d0 <check_page+0x6d7>
f01024cc:	85 c0                	test   %eax,%eax
f01024ce:	75 19                	jne    f01024e9 <check_page+0x6f0>
f01024d0:	68 e8 6e 10 f0       	push   $0xf0106ee8
f01024d5:	68 9b 71 10 f0       	push   $0xf010719b
f01024da:	68 46 04 00 00       	push   $0x446
f01024df:	68 81 71 10 f0       	push   $0xf0107181
f01024e4:	e8 89 db ff ff       	call   f0100072 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f01024e9:	83 ec 08             	sub    $0x8,%esp
f01024ec:	6a 00                	push   $0x0
f01024ee:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f01024f4:	e8 5f f5 ff ff       	call   f0101a58 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01024f9:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f01024ff:	ba 00 00 00 00       	mov    $0x0,%edx
f0102504:	89 f8                	mov    %edi,%eax
f0102506:	e8 44 e8 ff ff       	call   f0100d4f <check_va2pa>
f010250b:	83 c4 10             	add    $0x10,%esp
f010250e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102511:	74 19                	je     f010252c <check_page+0x733>
f0102513:	68 0c 6f 10 f0       	push   $0xf0106f0c
f0102518:	68 9b 71 10 f0       	push   $0xf010719b
f010251d:	68 4a 04 00 00       	push   $0x44a
f0102522:	68 81 71 10 f0       	push   $0xf0107181
f0102527:	e8 46 db ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010252c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102531:	89 f8                	mov    %edi,%eax
f0102533:	e8 17 e8 ff ff       	call   f0100d4f <check_va2pa>
f0102538:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010253b:	89 f0                	mov    %esi,%eax
f010253d:	e8 96 e6 ff ff       	call   f0100bd8 <page2pa>
f0102542:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0102545:	74 19                	je     f0102560 <check_page+0x767>
f0102547:	68 b8 6e 10 f0       	push   $0xf0106eb8
f010254c:	68 9b 71 10 f0       	push   $0xf010719b
f0102551:	68 4b 04 00 00       	push   $0x44b
f0102556:	68 81 71 10 f0       	push   $0xf0107181
f010255b:	e8 12 db ff ff       	call   f0100072 <_panic>
	assert(pp1->pp_ref == 1);
f0102560:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102565:	74 19                	je     f0102580 <check_page+0x787>
f0102567:	68 45 73 10 f0       	push   $0xf0107345
f010256c:	68 9b 71 10 f0       	push   $0xf010719b
f0102571:	68 4c 04 00 00       	push   $0x44c
f0102576:	68 81 71 10 f0       	push   $0xf0107181
f010257b:	e8 f2 da ff ff       	call   f0100072 <_panic>
	assert(pp2->pp_ref == 0);
f0102580:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102585:	74 19                	je     f01025a0 <check_page+0x7a7>
f0102587:	68 78 73 10 f0       	push   $0xf0107378
f010258c:	68 9b 71 10 f0       	push   $0xf010719b
f0102591:	68 4d 04 00 00       	push   $0x44d
f0102596:	68 81 71 10 f0       	push   $0xf0107181
f010259b:	e8 d2 da ff ff       	call   f0100072 <_panic>


	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void *) PGSIZE, 0) == 0);
f01025a0:	6a 00                	push   $0x0
f01025a2:	68 00 10 00 00       	push   $0x1000
f01025a7:	56                   	push   %esi
f01025a8:	57                   	push   %edi
f01025a9:	e8 f7 f4 ff ff       	call   f0101aa5 <page_insert>
f01025ae:	83 c4 10             	add    $0x10,%esp
f01025b1:	85 c0                	test   %eax,%eax
f01025b3:	74 19                	je     f01025ce <check_page+0x7d5>
f01025b5:	68 30 6f 10 f0       	push   $0xf0106f30
f01025ba:	68 9b 71 10 f0       	push   $0xf010719b
f01025bf:	68 51 04 00 00       	push   $0x451
f01025c4:	68 81 71 10 f0       	push   $0xf0107181
f01025c9:	e8 a4 da ff ff       	call   f0100072 <_panic>
	assert(pp1->pp_ref);
f01025ce:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01025d3:	75 19                	jne    f01025ee <check_page+0x7f5>
f01025d5:	68 db 73 10 f0       	push   $0xf01073db
f01025da:	68 9b 71 10 f0       	push   $0xf010719b
f01025df:	68 52 04 00 00       	push   $0x452
f01025e4:	68 81 71 10 f0       	push   $0xf0107181
f01025e9:	e8 84 da ff ff       	call   f0100072 <_panic>
	assert(pp1->pp_link == NULL);
f01025ee:	83 3e 00             	cmpl   $0x0,(%esi)
f01025f1:	74 19                	je     f010260c <check_page+0x813>
f01025f3:	68 e7 73 10 f0       	push   $0xf01073e7
f01025f8:	68 9b 71 10 f0       	push   $0xf010719b
f01025fd:	68 53 04 00 00       	push   $0x453
f0102602:	68 81 71 10 f0       	push   $0xf0107181
f0102607:	e8 66 da ff ff       	call   f0100072 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void *) PGSIZE);
f010260c:	83 ec 08             	sub    $0x8,%esp
f010260f:	68 00 10 00 00       	push   $0x1000
f0102614:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f010261a:	e8 39 f4 ff ff       	call   f0101a58 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010261f:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f0102625:	ba 00 00 00 00       	mov    $0x0,%edx
f010262a:	89 f8                	mov    %edi,%eax
f010262c:	e8 1e e7 ff ff       	call   f0100d4f <check_va2pa>
f0102631:	83 c4 10             	add    $0x10,%esp
f0102634:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102637:	74 19                	je     f0102652 <check_page+0x859>
f0102639:	68 0c 6f 10 f0       	push   $0xf0106f0c
f010263e:	68 9b 71 10 f0       	push   $0xf010719b
f0102643:	68 57 04 00 00       	push   $0x457
f0102648:	68 81 71 10 f0       	push   $0xf0107181
f010264d:	e8 20 da ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102652:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102657:	89 f8                	mov    %edi,%eax
f0102659:	e8 f1 e6 ff ff       	call   f0100d4f <check_va2pa>
f010265e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102661:	74 19                	je     f010267c <check_page+0x883>
f0102663:	68 68 6f 10 f0       	push   $0xf0106f68
f0102668:	68 9b 71 10 f0       	push   $0xf010719b
f010266d:	68 58 04 00 00       	push   $0x458
f0102672:	68 81 71 10 f0       	push   $0xf0107181
f0102677:	e8 f6 d9 ff ff       	call   f0100072 <_panic>
	
	assert(pp1->pp_ref == 0);
f010267c:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102681:	74 19                	je     f010269c <check_page+0x8a3>
f0102683:	68 67 73 10 f0       	push   $0xf0107367
f0102688:	68 9b 71 10 f0       	push   $0xf010719b
f010268d:	68 5a 04 00 00       	push   $0x45a
f0102692:	68 81 71 10 f0       	push   $0xf0107181
f0102697:	e8 d6 d9 ff ff       	call   f0100072 <_panic>
	assert(pp2->pp_ref == 0);
f010269c:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01026a1:	74 19                	je     f01026bc <check_page+0x8c3>
f01026a3:	68 78 73 10 f0       	push   $0xf0107378
f01026a8:	68 9b 71 10 f0       	push   $0xf010719b
f01026ad:	68 5b 04 00 00       	push   $0x45b
f01026b2:	68 81 71 10 f0       	push   $0xf0107181
f01026b7:	e8 b6 d9 ff ff       	call   f0100072 <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f01026bc:	83 ec 0c             	sub    $0xc,%esp
f01026bf:	6a 00                	push   $0x0
f01026c1:	e8 67 ed ff ff       	call   f010142d <page_alloc>
f01026c6:	83 c4 10             	add    $0x10,%esp
f01026c9:	39 c6                	cmp    %eax,%esi
f01026cb:	75 04                	jne    f01026d1 <check_page+0x8d8>
f01026cd:	85 c0                	test   %eax,%eax
f01026cf:	75 19                	jne    f01026ea <check_page+0x8f1>
f01026d1:	68 90 6f 10 f0       	push   $0xf0106f90
f01026d6:	68 9b 71 10 f0       	push   $0xf010719b
f01026db:	68 5e 04 00 00       	push   $0x45e
f01026e0:	68 81 71 10 f0       	push   $0xf0107181
f01026e5:	e8 88 d9 ff ff       	call   f0100072 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01026ea:	83 ec 0c             	sub    $0xc,%esp
f01026ed:	6a 00                	push   $0x0
f01026ef:	e8 39 ed ff ff       	call   f010142d <page_alloc>
f01026f4:	83 c4 10             	add    $0x10,%esp
f01026f7:	85 c0                	test   %eax,%eax
f01026f9:	74 19                	je     f0102714 <check_page+0x91b>
f01026fb:	68 f3 72 10 f0       	push   $0xf01072f3
f0102700:	68 9b 71 10 f0       	push   $0xf010719b
f0102705:	68 61 04 00 00       	push   $0x461
f010270a:	68 81 71 10 f0       	push   $0xf0107181
f010270f:	e8 5e d9 ff ff       	call   f0100072 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102714:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f010271a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010271d:	e8 b6 e4 ff ff       	call   f0100bd8 <page2pa>
f0102722:	8b 17                	mov    (%edi),%edx
f0102724:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010272a:	39 c2                	cmp    %eax,%edx
f010272c:	74 19                	je     f0102747 <check_page+0x94e>
f010272e:	68 64 6b 10 f0       	push   $0xf0106b64
f0102733:	68 9b 71 10 f0       	push   $0xf010719b
f0102738:	68 64 04 00 00       	push   $0x464
f010273d:	68 81 71 10 f0       	push   $0xf0107181
f0102742:	e8 2b d9 ff ff       	call   f0100072 <_panic>
	kern_pgdir[0] = 0;
f0102747:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	assert(pp0->pp_ref == 1);
f010274d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102750:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102755:	74 19                	je     f0102770 <check_page+0x977>
f0102757:	68 89 73 10 f0       	push   $0xf0107389
f010275c:	68 9b 71 10 f0       	push   $0xf010719b
f0102761:	68 66 04 00 00       	push   $0x466
f0102766:	68 81 71 10 f0       	push   $0xf0107181
f010276b:	e8 02 d9 ff ff       	call   f0100072 <_panic>
	pp0->pp_ref = 0;
f0102770:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102773:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102779:	83 ec 0c             	sub    $0xc,%esp
f010277c:	50                   	push   %eax
f010277d:	e8 f0 ec ff ff       	call   f0101472 <page_free>
	va = (void *) (PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102782:	83 c4 0c             	add    $0xc,%esp
f0102785:	6a 01                	push   $0x1
f0102787:	68 00 10 40 00       	push   $0x401000
f010278c:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102792:	e8 0a f1 ff ff       	call   f01018a1 <pgdir_walk>
f0102797:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010279a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010279d:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f01027a3:	8b 4f 04             	mov    0x4(%edi),%ecx
f01027a6:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01027ac:	ba 6d 04 00 00       	mov    $0x46d,%edx
f01027b1:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f01027b6:	e8 4a e5 ff ff       	call   f0100d05 <_kaddr>
	assert(ptep == ptep1 + PTX(va));
f01027bb:	83 c0 04             	add    $0x4,%eax
f01027be:	83 c4 10             	add    $0x10,%esp
f01027c1:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f01027c4:	74 19                	je     f01027df <check_page+0x9e6>
f01027c6:	68 fc 73 10 f0       	push   $0xf01073fc
f01027cb:	68 9b 71 10 f0       	push   $0xf010719b
f01027d0:	68 6e 04 00 00       	push   $0x46e
f01027d5:	68 81 71 10 f0       	push   $0xf0107181
f01027da:	e8 93 d8 ff ff       	call   f0100072 <_panic>
	kern_pgdir[PDX(va)] = 0;
f01027df:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	pp0->pp_ref = 0;
f01027e6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01027e9:	89 f8                	mov    %edi,%eax
f01027eb:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01027f1:	e8 3b e5 ff ff       	call   f0100d31 <page2kva>
f01027f6:	83 ec 04             	sub    $0x4,%esp
f01027f9:	68 00 10 00 00       	push   $0x1000
f01027fe:	68 ff 00 00 00       	push   $0xff
f0102803:	50                   	push   %eax
f0102804:	e8 20 2d 00 00       	call   f0105529 <memset>
	page_free(pp0);
f0102809:	89 3c 24             	mov    %edi,(%esp)
f010280c:	e8 61 ec ff ff       	call   f0101472 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102811:	83 c4 0c             	add    $0xc,%esp
f0102814:	6a 01                	push   $0x1
f0102816:	6a 00                	push   $0x0
f0102818:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f010281e:	e8 7e f0 ff ff       	call   f01018a1 <pgdir_walk>
	ptep = (pte_t *) page2kva(pp0);
f0102823:	89 f8                	mov    %edi,%eax
f0102825:	e8 07 e5 ff ff       	call   f0100d31 <page2kva>
f010282a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010282d:	89 c2                	mov    %eax,%edx
f010282f:	05 00 10 00 00       	add    $0x1000,%eax
f0102834:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102837:	f6 02 01             	testb  $0x1,(%edx)
f010283a:	74 19                	je     f0102855 <check_page+0xa5c>
f010283c:	68 14 74 10 f0       	push   $0xf0107414
f0102841:	68 9b 71 10 f0       	push   $0xf010719b
f0102846:	68 78 04 00 00       	push   $0x478
f010284b:	68 81 71 10 f0       	push   $0xf0107181
f0102850:	e8 1d d8 ff ff       	call   f0100072 <_panic>
f0102855:	83 c2 04             	add    $0x4,%edx
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for (i = 0; i < NPTENTRIES; i++)
f0102858:	39 d0                	cmp    %edx,%eax
f010285a:	75 db                	jne    f0102837 <check_page+0xa3e>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f010285c:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102861:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102867:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010286a:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102870:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102873:	89 0d 40 a2 21 f0    	mov    %ecx,0xf021a240

	// free the pages we took
	page_free(pp0);
f0102879:	83 ec 0c             	sub    $0xc,%esp
f010287c:	50                   	push   %eax
f010287d:	e8 f0 eb ff ff       	call   f0101472 <page_free>
	page_free(pp1);
f0102882:	89 34 24             	mov    %esi,(%esp)
f0102885:	e8 e8 eb ff ff       	call   f0101472 <page_free>
	page_free(pp2);
f010288a:	89 1c 24             	mov    %ebx,(%esp)
f010288d:	e8 e0 eb ff ff       	call   f0101472 <page_free>
	

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102892:	83 c4 08             	add    $0x8,%esp
f0102895:	68 01 10 00 00       	push   $0x1001
f010289a:	6a 00                	push   $0x0
f010289c:	e8 ee f4 ff ff       	call   f0101d8f <mmio_map_region>
f01028a1:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f01028a3:	83 c4 08             	add    $0x8,%esp
f01028a6:	68 00 10 00 00       	push   $0x1000
f01028ab:	6a 00                	push   $0x0
f01028ad:	e8 dd f4 ff ff       	call   f0101d8f <mmio_map_region>
f01028b2:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f01028b4:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f01028ba:	83 c4 10             	add    $0x10,%esp
f01028bd:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01028c3:	76 07                	jbe    f01028cc <check_page+0xad3>
f01028c5:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01028ca:	76 19                	jbe    f01028e5 <check_page+0xaec>
f01028cc:	68 b4 6f 10 f0       	push   $0xf0106fb4
f01028d1:	68 9b 71 10 f0       	push   $0xf010719b
f01028d6:	68 89 04 00 00       	push   $0x489
f01028db:	68 81 71 10 f0       	push   $0xf0107181
f01028e0:	e8 8d d7 ff ff       	call   f0100072 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f01028e5:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f01028eb:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f01028f1:	77 08                	ja     f01028fb <check_page+0xb02>
f01028f3:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01028f9:	77 19                	ja     f0102914 <check_page+0xb1b>
f01028fb:	68 dc 6f 10 f0       	push   $0xf0106fdc
f0102900:	68 9b 71 10 f0       	push   $0xf010719b
f0102905:	68 8a 04 00 00       	push   $0x48a
f010290a:	68 81 71 10 f0       	push   $0xf0107181
f010290f:	e8 5e d7 ff ff       	call   f0100072 <_panic>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102914:	89 da                	mov    %ebx,%edx
f0102916:	09 f2                	or     %esi,%edx
f0102918:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010291e:	74 19                	je     f0102939 <check_page+0xb40>
f0102920:	68 04 70 10 f0       	push   $0xf0107004
f0102925:	68 9b 71 10 f0       	push   $0xf010719b
f010292a:	68 8c 04 00 00       	push   $0x48c
f010292f:	68 81 71 10 f0       	push   $0xf0107181
f0102934:	e8 39 d7 ff ff       	call   f0100072 <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f0102939:	39 c6                	cmp    %eax,%esi
f010293b:	73 19                	jae    f0102956 <check_page+0xb5d>
f010293d:	68 2b 74 10 f0       	push   $0xf010742b
f0102942:	68 9b 71 10 f0       	push   $0xf010719b
f0102947:	68 8e 04 00 00       	push   $0x48e
f010294c:	68 81 71 10 f0       	push   $0xf0107181
f0102951:	e8 1c d7 ff ff       	call   f0100072 <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102956:	8b 3d 8c ae 21 f0    	mov    0xf021ae8c,%edi
f010295c:	89 da                	mov    %ebx,%edx
f010295e:	89 f8                	mov    %edi,%eax
f0102960:	e8 ea e3 ff ff       	call   f0100d4f <check_va2pa>
f0102965:	85 c0                	test   %eax,%eax
f0102967:	74 19                	je     f0102982 <check_page+0xb89>
f0102969:	68 2c 70 10 f0       	push   $0xf010702c
f010296e:	68 9b 71 10 f0       	push   $0xf010719b
f0102973:	68 90 04 00 00       	push   $0x490
f0102978:	68 81 71 10 f0       	push   $0xf0107181
f010297d:	e8 f0 d6 ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, mm1 + PGSIZE) == PGSIZE);
f0102982:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102988:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010298b:	89 c2                	mov    %eax,%edx
f010298d:	89 f8                	mov    %edi,%eax
f010298f:	e8 bb e3 ff ff       	call   f0100d4f <check_va2pa>
f0102994:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102999:	74 19                	je     f01029b4 <check_page+0xbbb>
f010299b:	68 50 70 10 f0       	push   $0xf0107050
f01029a0:	68 9b 71 10 f0       	push   $0xf010719b
f01029a5:	68 91 04 00 00       	push   $0x491
f01029aa:	68 81 71 10 f0       	push   $0xf0107181
f01029af:	e8 be d6 ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f01029b4:	89 f2                	mov    %esi,%edx
f01029b6:	89 f8                	mov    %edi,%eax
f01029b8:	e8 92 e3 ff ff       	call   f0100d4f <check_va2pa>
f01029bd:	85 c0                	test   %eax,%eax
f01029bf:	74 19                	je     f01029da <check_page+0xbe1>
f01029c1:	68 80 70 10 f0       	push   $0xf0107080
f01029c6:	68 9b 71 10 f0       	push   $0xf010719b
f01029cb:	68 92 04 00 00       	push   $0x492
f01029d0:	68 81 71 10 f0       	push   $0xf0107181
f01029d5:	e8 98 d6 ff ff       	call   f0100072 <_panic>
	assert(check_va2pa(kern_pgdir, mm2 + PGSIZE) == ~0);
f01029da:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f01029e0:	89 f8                	mov    %edi,%eax
f01029e2:	e8 68 e3 ff ff       	call   f0100d4f <check_va2pa>
f01029e7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01029ea:	74 19                	je     f0102a05 <check_page+0xc0c>
f01029ec:	68 a4 70 10 f0       	push   $0xf01070a4
f01029f1:	68 9b 71 10 f0       	push   $0xf010719b
f01029f6:	68 93 04 00 00       	push   $0x493
f01029fb:	68 81 71 10 f0       	push   $0xf0107181
f0102a00:	e8 6d d6 ff ff       	call   f0100072 <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void *) mm1, 0) &
f0102a05:	83 ec 04             	sub    $0x4,%esp
f0102a08:	6a 00                	push   $0x0
f0102a0a:	53                   	push   %ebx
f0102a0b:	57                   	push   %edi
f0102a0c:	e8 90 ee ff ff       	call   f01018a1 <pgdir_walk>
f0102a11:	83 c4 10             	add    $0x10,%esp
f0102a14:	f6 00 1a             	testb  $0x1a,(%eax)
f0102a17:	75 19                	jne    f0102a32 <check_page+0xc39>
f0102a19:	68 d0 70 10 f0       	push   $0xf01070d0
f0102a1e:	68 9b 71 10 f0       	push   $0xf010719b
f0102a23:	68 96 04 00 00       	push   $0x496
f0102a28:	68 81 71 10 f0       	push   $0xf0107181
f0102a2d:	e8 40 d6 ff ff       	call   f0100072 <_panic>
	       (PTE_W | PTE_PWT | PTE_PCD));
	assert(!(*pgdir_walk(kern_pgdir, (void *) mm1, 0) & PTE_U));
f0102a32:	83 ec 04             	sub    $0x4,%esp
f0102a35:	6a 00                	push   $0x0
f0102a37:	53                   	push   %ebx
f0102a38:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102a3e:	e8 5e ee ff ff       	call   f01018a1 <pgdir_walk>
f0102a43:	83 c4 10             	add    $0x10,%esp
f0102a46:	f6 00 04             	testb  $0x4,(%eax)
f0102a49:	74 19                	je     f0102a64 <check_page+0xc6b>
f0102a4b:	68 18 71 10 f0       	push   $0xf0107118
f0102a50:	68 9b 71 10 f0       	push   $0xf010719b
f0102a55:	68 97 04 00 00       	push   $0x497
f0102a5a:	68 81 71 10 f0       	push   $0xf0107181
f0102a5f:	e8 0e d6 ff ff       	call   f0100072 <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void *) mm1, 0) = 0;
f0102a64:	83 ec 04             	sub    $0x4,%esp
f0102a67:	6a 00                	push   $0x0
f0102a69:	53                   	push   %ebx
f0102a6a:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102a70:	e8 2c ee ff ff       	call   f01018a1 <pgdir_walk>
f0102a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *) mm1 + PGSIZE, 0) = 0;
f0102a7b:	83 c4 0c             	add    $0xc,%esp
f0102a7e:	6a 00                	push   $0x0
f0102a80:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102a83:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102a89:	e8 13 ee ff ff       	call   f01018a1 <pgdir_walk>
f0102a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *) mm2, 0) = 0;
f0102a94:	83 c4 0c             	add    $0xc,%esp
f0102a97:	6a 00                	push   $0x0
f0102a99:	56                   	push   %esi
f0102a9a:	ff 35 8c ae 21 f0    	pushl  0xf021ae8c
f0102aa0:	e8 fc ed ff ff       	call   f01018a1 <pgdir_walk>
f0102aa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102aab:	c7 04 24 3d 74 10 f0 	movl   $0xf010743d,(%esp)
f0102ab2:	e8 a4 0c 00 00       	call   f010375b <cprintf>
}
f0102ab7:	83 c4 10             	add    $0x10,%esp
f0102aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102abd:	5b                   	pop    %ebx
f0102abe:	5e                   	pop    %esi
f0102abf:	5f                   	pop    %edi
f0102ac0:	5d                   	pop    %ebp
f0102ac1:	c3                   	ret    

f0102ac2 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102ac2:	55                   	push   %ebp
f0102ac3:	89 e5                	mov    %esp,%ebp
f0102ac5:	53                   	push   %ebx
f0102ac6:	83 ec 04             	sub    $0x4,%esp
	uint32_t cr0;
	size_t n;

	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();
f0102ac9:	e8 44 e1 ff ff       	call   f0100c12 <i386_detect_memory>
	// Remove this line when you're ready to test this function.
	//panic("mem_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0102ace:	b8 00 10 00 00       	mov    $0x1000,%eax
f0102ad3:	e8 ab e1 ff ff       	call   f0100c83 <boot_alloc>
f0102ad8:	a3 8c ae 21 f0       	mov    %eax,0xf021ae8c
	memset(kern_pgdir, 0, PGSIZE);
f0102add:	83 ec 04             	sub    $0x4,%esp
f0102ae0:	68 00 10 00 00       	push   $0x1000
f0102ae5:	6a 00                	push   $0x0
f0102ae7:	50                   	push   %eax
f0102ae8:	e8 3c 2a 00 00       	call   f0105529 <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0102aed:	8b 1d 8c ae 21 f0    	mov    0xf021ae8c,%ebx
f0102af3:	89 d9                	mov    %ebx,%ecx
f0102af5:	ba a7 00 00 00       	mov    $0xa7,%edx
f0102afa:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0102aff:	e8 bb e2 ff ff       	call   f0100dbf <_paddr>
f0102b04:	83 c8 05             	or     $0x5,%eax
f0102b07:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use
	// memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
	pages = boot_alloc(npages*sizeof(struct PageInfo));
f0102b0d:	a1 88 ae 21 f0       	mov    0xf021ae88,%eax
f0102b12:	c1 e0 03             	shl    $0x3,%eax
f0102b15:	e8 69 e1 ff ff       	call   f0100c83 <boot_alloc>
f0102b1a:	a3 90 ae 21 f0       	mov    %eax,0xf021ae90
	memset(pages, 0,npages*sizeof(struct PageInfo));
f0102b1f:	83 c4 0c             	add    $0xc,%esp
f0102b22:	8b 1d 88 ae 21 f0    	mov    0xf021ae88,%ebx
f0102b28:	8d 14 dd 00 00 00 00 	lea    0x0(,%ebx,8),%edx
f0102b2f:	52                   	push   %edx
f0102b30:	6a 00                	push   $0x0
f0102b32:	50                   	push   %eax
f0102b33:	e8 f1 29 00 00       	call   f0105529 <memset>


	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	envs = boot_alloc(NENV*sizeof(struct Env));
f0102b38:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0102b3d:	e8 41 e1 ff ff       	call   f0100c83 <boot_alloc>
f0102b42:	a3 48 a2 21 f0       	mov    %eax,0xf021a248
	memset(envs,0,NENV*sizeof(struct Env));
f0102b47:	83 c4 0c             	add    $0xc,%esp
f0102b4a:	68 00 f0 01 00       	push   $0x1f000
f0102b4f:	6a 00                	push   $0x0
f0102b51:	50                   	push   %eax
f0102b52:	e8 d2 29 00 00       	call   f0105529 <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0102b57:	e8 07 e8 ff ff       	call   f0101363 <page_init>

	check_page_free_list(1);
f0102b5c:	b8 01 00 00 00       	mov    $0x1,%eax
f0102b61:	e8 01 e5 ff ff       	call   f0101067 <check_page_free_list>
	check_page_alloc();
f0102b66:	e8 42 e9 ff ff       	call   f01014ad <check_page_alloc>
	check_page();
f0102b6b:	e8 89 f2 ff ff       	call   f0101df9 <check_page>
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	uintptr_t va = UPAGES;
	physaddr_t pa = PADDR(pages);
f0102b70:	8b 0d 90 ae 21 f0    	mov    0xf021ae90,%ecx
f0102b76:	ba d3 00 00 00       	mov    $0xd3,%edx
f0102b7b:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0102b80:	e8 3a e2 ff ff       	call   f0100dbf <_paddr>
	int perm = PTE_U | PTE_P ;
	boot_map_region(kern_pgdir, va, PTSIZE, pa, perm);
f0102b85:	83 c4 08             	add    $0x8,%esp
f0102b88:	6a 05                	push   $0x5
f0102b8a:	50                   	push   %eax
f0102b8b:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102b90:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102b95:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102b9a:	e8 94 ed ff ff       	call   f0101933 <boot_map_region>
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	va = UENVS;
	pa = PADDR(envs);
f0102b9f:	8b 0d 48 a2 21 f0    	mov    0xf021a248,%ecx
f0102ba5:	ba df 00 00 00       	mov    $0xdf,%edx
f0102baa:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0102baf:	e8 0b e2 ff ff       	call   f0100dbf <_paddr>
	perm = PTE_U | PTE_P ;
	boot_map_region(kern_pgdir, va,NENV*sizeof(struct Env), pa, perm);
f0102bb4:	83 c4 08             	add    $0x8,%esp
f0102bb7:	6a 05                	push   $0x5
f0102bb9:	50                   	push   %eax
f0102bba:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f0102bbf:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102bc4:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102bc9:	e8 65 ed ff ff       	call   f0101933 <boot_map_region>

	va = (uintptr_t) envs;
	pa = PADDR(pages);
f0102bce:	8b 0d 90 ae 21 f0    	mov    0xf021ae90,%ecx
f0102bd4:	ba e4 00 00 00       	mov    $0xe4,%edx
f0102bd9:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0102bde:	e8 dc e1 ff ff       	call   f0100dbf <_paddr>
	perm = PTE_W;
	boot_map_region(kern_pgdir, va,NENV*sizeof(struct Env), pa, perm);
f0102be3:	83 c4 08             	add    $0x8,%esp
f0102be6:	6a 02                	push   $0x2
f0102be8:	50                   	push   %eax
f0102be9:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f0102bee:	8b 15 48 a2 21 f0    	mov    0xf021a248,%edx
f0102bf4:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102bf9:	e8 35 ed ff ff       	call   f0101933 <boot_map_region>
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
	
	va = KSTACKTOP - KSTKSIZE;
	pa = PADDR(bootstack); //Obtengo la direccion fisica del kernel stack
f0102bfe:	b9 00 80 11 f0       	mov    $0xf0118000,%ecx
f0102c03:	ba f6 00 00 00       	mov    $0xf6,%edx
f0102c08:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0102c0d:	e8 ad e1 ff ff       	call   f0100dbf <_paddr>
	perm = PTE_P | PTE_W;
	boot_map_region(kern_pgdir, va, KSTKSIZE, pa, perm); 
f0102c12:	83 c4 08             	add    $0x8,%esp
f0102c15:	6a 03                	push   $0x3
f0102c17:	50                   	push   %eax
f0102c18:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102c1d:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102c22:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102c27:	e8 07 ed ff ff       	call   f0101933 <boot_map_region>
f0102c2c:	83 c4 10             	add    $0x10,%esp
f0102c2f:	b8 1b 00 00 00       	mov    $0x1b,%eax
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
	
	va = KERNBASE;
	size_t size = 2;
f0102c34:	b9 02 00 00 00       	mov    $0x2,%ecx
	int i;
	for (i = 1; i<28; ++i) //Obtengo los 256MiB (2^28)
		size = size*2;
f0102c39:	01 c9                	add    %ecx,%ecx
	// Your code goes here:
	
	va = KERNBASE;
	size_t size = 2;
	int i;
	for (i = 1; i<28; ++i) //Obtengo los 256MiB (2^28)
f0102c3b:	83 e8 01             	sub    $0x1,%eax
f0102c3e:	75 f9                	jne    f0102c39 <mem_init+0x177>
		size = size*2;
	perm = PTE_P | PTE_W;
	boot_map_region(kern_pgdir, va, size, 0, perm);
f0102c40:	83 ec 08             	sub    $0x8,%esp
f0102c43:	6a 03                	push   $0x3
f0102c45:	6a 00                	push   $0x0
f0102c47:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102c4c:	a1 8c ae 21 f0       	mov    0xf021ae8c,%eax
f0102c51:	e8 dd ec ff ff       	call   f0101933 <boot_map_region>

	// Initialize the SMP-related parts of the memory map
	mem_init_mp();
f0102c56:	e8 35 ed ff ff       	call   f0101990 <mem_init_mp>

	// Check that the initial page directory has been set up correctly.
	check_kern_pgdir();
f0102c5b:	e8 81 e1 ff ff       	call   f0100de1 <check_kern_pgdir>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f0102c60:	8b 0d 8c ae 21 f0    	mov    0xf021ae8c,%ecx
f0102c66:	ba 19 01 00 00       	mov    $0x119,%edx
f0102c6b:	b8 81 71 10 f0       	mov    $0xf0107181,%eax
f0102c70:	e8 4a e1 ff ff       	call   f0100dbf <_paddr>
f0102c75:	e8 56 df ff ff       	call   f0100bd0 <lcr3>

	check_page_free_list(0);
f0102c7a:	b8 00 00 00 00       	mov    $0x0,%eax
f0102c7f:	e8 e3 e3 ff ff       	call   f0101067 <check_page_free_list>

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
f0102c84:	e8 3f df ff ff       	call   f0100bc8 <rcr0>
f0102c89:	83 e0 f3             	and    $0xfffffff3,%eax
	cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_MP;
	cr0 &= ~(CR0_TS | CR0_EM);
	lcr0(cr0);
f0102c8c:	0d 23 00 05 80       	or     $0x80050023,%eax
f0102c91:	e8 2a df ff ff       	call   f0100bc0 <lcr0>

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
f0102c96:	e8 77 ee ff ff       	call   f0101b12 <check_page_installed_pgdir>
}
f0102c9b:	83 c4 10             	add    $0x10,%esp
f0102c9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102ca1:	c9                   	leave  
f0102ca2:	c3                   	ret    

f0102ca3 <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0102ca3:	55                   	push   %ebp
f0102ca4:	89 e5                	mov    %esp,%ebp
f0102ca6:	57                   	push   %edi
f0102ca7:	56                   	push   %esi
f0102ca8:	53                   	push   %ebx
f0102ca9:	83 ec 1c             	sub    $0x1c,%esp
f0102cac:	8b 7d 08             	mov    0x8(%ebp),%edi
f0102caf:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 3: Your code here.
	uint32_t cur_addr = (uint32_t) ROUNDDOWN(va, PGSIZE); 
f0102cb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102cb5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    uint32_t end_addr = (uint32_t) ROUNDUP(va+len, PGSIZE);
f0102cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102cbe:	03 45 10             	add    0x10(%ebp),%eax
f0102cc1:	05 ff 0f 00 00       	add    $0xfff,%eax
f0102cc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102ccb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pte_t* pte_ptr = NULL;
	while(cur_addr < end_addr) {
f0102cce:	eb 4e                	jmp    f0102d1e <user_mem_check+0x7b>
		pte_ptr = pgdir_walk(env->env_pgdir, (void*)cur_addr, 0);
f0102cd0:	83 ec 04             	sub    $0x4,%esp
f0102cd3:	6a 00                	push   $0x0
f0102cd5:	53                   	push   %ebx
f0102cd6:	ff 77 60             	pushl  0x60(%edi)
f0102cd9:	e8 c3 eb ff ff       	call   f01018a1 <pgdir_walk>
		if ((cur_addr < ULIM) && pte_ptr && ((*pte_ptr & perm) == perm)) {
f0102cde:	83 c4 10             	add    $0x10,%esp
f0102ce1:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102ce7:	77 14                	ja     f0102cfd <user_mem_check+0x5a>
f0102ce9:	85 c0                	test   %eax,%eax
f0102ceb:	74 10                	je     f0102cfd <user_mem_check+0x5a>
f0102ced:	89 f2                	mov    %esi,%edx
f0102cef:	23 10                	and    (%eax),%edx
f0102cf1:	39 d6                	cmp    %edx,%esi
f0102cf3:	75 08                	jne    f0102cfd <user_mem_check+0x5a>
			cur_addr += PGSIZE;
f0102cf5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102cfb:	eb 21                	jmp    f0102d1e <user_mem_check+0x7b>
		} 
		else{
			if (cur_addr < (uint32_t)va)
f0102cfd:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0102d00:	73 0f                	jae    f0102d11 <user_mem_check+0x6e>
				user_mem_check_addr = (uintptr_t)va;
f0102d02:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102d05:	a3 3c a2 21 f0       	mov    %eax,0xf021a23c
			else
				user_mem_check_addr = (uintptr_t)cur_addr;
			return -E_FAULT;
f0102d0a:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0102d0f:	eb 17                	jmp    f0102d28 <user_mem_check+0x85>
		} 
		else{
			if (cur_addr < (uint32_t)va)
				user_mem_check_addr = (uintptr_t)va;
			else
				user_mem_check_addr = (uintptr_t)cur_addr;
f0102d11:	89 1d 3c a2 21 f0    	mov    %ebx,0xf021a23c
			return -E_FAULT;
f0102d17:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0102d1c:	eb 0a                	jmp    f0102d28 <user_mem_check+0x85>
{
	// LAB 3: Your code here.
	uint32_t cur_addr = (uint32_t) ROUNDDOWN(va, PGSIZE); 
    uint32_t end_addr = (uint32_t) ROUNDUP(va+len, PGSIZE);
	pte_t* pte_ptr = NULL;
	while(cur_addr < end_addr) {
f0102d1e:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0102d21:	72 ad                	jb     f0102cd0 <user_mem_check+0x2d>
			else
				user_mem_check_addr = (uintptr_t)cur_addr;
			return -E_FAULT;
		}
	}
	return 0;
f0102d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0102d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102d2b:	5b                   	pop    %ebx
f0102d2c:	5e                   	pop    %esi
f0102d2d:	5f                   	pop    %edi
f0102d2e:	5d                   	pop    %ebp
f0102d2f:	c3                   	ret    

f0102d30 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0102d30:	55                   	push   %ebp
f0102d31:	89 e5                	mov    %esp,%ebp
f0102d33:	53                   	push   %ebx
f0102d34:	83 ec 04             	sub    $0x4,%esp
f0102d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0102d3a:	8b 45 14             	mov    0x14(%ebp),%eax
f0102d3d:	83 c8 04             	or     $0x4,%eax
f0102d40:	50                   	push   %eax
f0102d41:	ff 75 10             	pushl  0x10(%ebp)
f0102d44:	ff 75 0c             	pushl  0xc(%ebp)
f0102d47:	53                   	push   %ebx
f0102d48:	e8 56 ff ff ff       	call   f0102ca3 <user_mem_check>
f0102d4d:	83 c4 10             	add    $0x10,%esp
f0102d50:	85 c0                	test   %eax,%eax
f0102d52:	79 21                	jns    f0102d75 <user_mem_assert+0x45>
		cprintf("[%08x] user_mem_check assertion failure for "
f0102d54:	83 ec 04             	sub    $0x4,%esp
f0102d57:	ff 35 3c a2 21 f0    	pushl  0xf021a23c
f0102d5d:	ff 73 48             	pushl  0x48(%ebx)
f0102d60:	68 4c 71 10 f0       	push   $0xf010714c
f0102d65:	e8 f1 09 00 00       	call   f010375b <cprintf>
		        "va %08x\n",
		        env->env_id,
		        user_mem_check_addr);
		env_destroy(env);  // may not return
f0102d6a:	89 1c 24             	mov    %ebx,(%esp)
f0102d6d:	e8 96 06 00 00       	call   f0103408 <env_destroy>
f0102d72:	83 c4 10             	add    $0x10,%esp
	}
}
f0102d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102d78:	c9                   	leave  
f0102d79:	c3                   	ret    

f0102d7a <lgdt>:
	asm volatile("lidt (%0)" : : "r" (p));
}

static inline void
lgdt(void *p)
{
f0102d7a:	55                   	push   %ebp
f0102d7b:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f0102d7d:	0f 01 10             	lgdtl  (%eax)
}
f0102d80:	5d                   	pop    %ebp
f0102d81:	c3                   	ret    

f0102d82 <lldt>:

static inline void
lldt(uint16_t sel)
{
f0102d82:	55                   	push   %ebp
f0102d83:	89 e5                	mov    %esp,%ebp
	asm volatile("lldt %0" : : "r" (sel));
f0102d85:	0f 00 d0             	lldt   %ax
}
f0102d88:	5d                   	pop    %ebp
f0102d89:	c3                   	ret    

f0102d8a <lcr3>:
	return val;
}

static inline void
lcr3(uint32_t val)
{
f0102d8a:	55                   	push   %ebp
f0102d8b:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102d8d:	0f 22 d8             	mov    %eax,%cr3
}
f0102d90:	5d                   	pop    %ebp
f0102d91:	c3                   	ret    

f0102d92 <page2pa>:
int	user_mem_check(struct Env *env, const void *va, size_t len, int perm);
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
f0102d92:	55                   	push   %ebp
f0102d93:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
f0102d95:	2b 05 90 ae 21 f0    	sub    0xf021ae90,%eax
f0102d9b:	c1 f8 03             	sar    $0x3,%eax
f0102d9e:	c1 e0 0c             	shl    $0xc,%eax
}
f0102da1:	5d                   	pop    %ebp
f0102da2:	c3                   	ret    

f0102da3 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0102da3:	55                   	push   %ebp
f0102da4:	89 e5                	mov    %esp,%ebp
f0102da6:	53                   	push   %ebx
f0102da7:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0102daa:	89 cb                	mov    %ecx,%ebx
f0102dac:	c1 eb 0c             	shr    $0xc,%ebx
f0102daf:	3b 1d 88 ae 21 f0    	cmp    0xf021ae88,%ebx
f0102db5:	72 0d                	jb     f0102dc4 <_kaddr+0x21>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102db7:	51                   	push   %ecx
f0102db8:	68 ac 62 10 f0       	push   $0xf01062ac
f0102dbd:	52                   	push   %edx
f0102dbe:	50                   	push   %eax
f0102dbf:	e8 ae d2 ff ff       	call   f0100072 <_panic>
	return (void *)(pa + KERNBASE);
f0102dc4:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0102dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102dcd:	c9                   	leave  
f0102dce:	c3                   	ret    

f0102dcf <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0102dcf:	55                   	push   %ebp
f0102dd0:	89 e5                	mov    %esp,%ebp
f0102dd2:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
f0102dd5:	e8 b8 ff ff ff       	call   f0102d92 <page2pa>
f0102dda:	89 c1                	mov    %eax,%ecx
f0102ddc:	ba 58 00 00 00       	mov    $0x58,%edx
f0102de1:	b8 8d 71 10 f0       	mov    $0xf010718d,%eax
f0102de6:	e8 b8 ff ff ff       	call   f0102da3 <_kaddr>
}
f0102deb:	c9                   	leave  
f0102dec:	c3                   	ret    

f0102ded <_paddr>:
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102ded:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0102df3:	77 13                	ja     f0102e08 <_paddr+0x1b>
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
f0102df5:	55                   	push   %ebp
f0102df6:	89 e5                	mov    %esp,%ebp
f0102df8:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102dfb:	51                   	push   %ecx
f0102dfc:	68 d0 62 10 f0       	push   $0xf01062d0
f0102e01:	52                   	push   %edx
f0102e02:	50                   	push   %eax
f0102e03:	e8 6a d2 ff ff       	call   f0100072 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0102e08:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0102e0e:	c3                   	ret    

f0102e0f <env_setup_vm>:
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
static int
env_setup_vm(struct Env *e)
{
f0102e0f:	55                   	push   %ebp
f0102e10:	89 e5                	mov    %esp,%ebp
f0102e12:	56                   	push   %esi
f0102e13:	53                   	push   %ebx
f0102e14:	89 c3                	mov    %eax,%ebx
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0102e16:	83 ec 0c             	sub    $0xc,%esp
f0102e19:	6a 01                	push   $0x1
f0102e1b:	e8 0d e6 ff ff       	call   f010142d <page_alloc>
f0102e20:	83 c4 10             	add    $0x10,%esp
f0102e23:	85 c0                	test   %eax,%eax
f0102e25:	74 51                	je     f0102e78 <env_setup_vm+0x69>
f0102e27:	89 c6                	mov    %eax,%esi
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.ADDR(
	e->env_pgdir = page2kva(p);
f0102e29:	e8 a1 ff ff ff       	call   f0102dcf <page2kva>
f0102e2e:	89 43 60             	mov    %eax,0x60(%ebx)
f0102e31:	b8 ec 0e 00 00       	mov    $0xeec,%eax
	for (i = PDX(UTOP); i < NPDENTRIES; i++){
		e->env_pgdir[i] = kern_pgdir[i];
f0102e36:	8b 15 8c ae 21 f0    	mov    0xf021ae8c,%edx
f0102e3c:	8b 0c 02             	mov    (%edx,%eax,1),%ecx
f0102e3f:	8b 53 60             	mov    0x60(%ebx),%edx
f0102e42:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f0102e45:	83 c0 04             	add    $0x4,%eax
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.ADDR(
	e->env_pgdir = page2kva(p);
	for (i = PDX(UTOP); i < NPDENTRIES; i++){
f0102e48:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102e4d:	75 e7                	jne    f0102e36 <env_setup_vm+0x27>
		e->env_pgdir[i] = kern_pgdir[i];

	}

	//memcpy(e->env_pgdir, kern_pgdir,NPDENTRIES);
	p->pp_ref++;
f0102e4f:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0102e54:	8b 5b 60             	mov    0x60(%ebx),%ebx
f0102e57:	89 d9                	mov    %ebx,%ecx
f0102e59:	ba c9 00 00 00       	mov    $0xc9,%edx
f0102e5e:	b8 86 74 10 f0       	mov    $0xf0107486,%eax
f0102e63:	e8 85 ff ff ff       	call   f0102ded <_paddr>
f0102e68:	83 c8 05             	or     $0x5,%eax
f0102e6b:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)

	return 0;
f0102e71:	b8 00 00 00 00       	mov    $0x0,%eax
f0102e76:	eb 05                	jmp    f0102e7d <env_setup_vm+0x6e>
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;
f0102e78:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;

	return 0;
}
f0102e7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0102e80:	5b                   	pop    %ebx
f0102e81:	5e                   	pop    %esi
f0102e82:	5d                   	pop    %ebp
f0102e83:	c3                   	ret    

f0102e84 <pa2page>:
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102e84:	c1 e8 0c             	shr    $0xc,%eax
f0102e87:	3b 05 88 ae 21 f0    	cmp    0xf021ae88,%eax
f0102e8d:	72 17                	jb     f0102ea6 <pa2page+0x22>
	return (pp - pages) << PGSHIFT;
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
f0102e8f:	55                   	push   %ebp
f0102e90:	89 e5                	mov    %esp,%ebp
f0102e92:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
		panic("pa2page called with invalid pa");
f0102e95:	68 0c 6a 10 f0       	push   $0xf0106a0c
f0102e9a:	6a 51                	push   $0x51
f0102e9c:	68 8d 71 10 f0       	push   $0xf010718d
f0102ea1:	e8 cc d1 ff ff       	call   f0100072 <_panic>
	return &pages[PGNUM(pa)];
f0102ea6:	8b 15 90 ae 21 f0    	mov    0xf021ae90,%edx
f0102eac:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0102eaf:	c3                   	ret    

f0102eb0 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0102eb0:	55                   	push   %ebp
f0102eb1:	89 e5                	mov    %esp,%ebp
f0102eb3:	57                   	push   %edi
f0102eb4:	56                   	push   %esi
f0102eb5:	53                   	push   %ebx
f0102eb6:	83 ec 0c             	sub    $0xc,%esp
f0102eb9:	89 c7                	mov    %eax,%edi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	
	char *va_align = ROUNDDOWN(va,PGSIZE); // alineo el va
f0102ebb:	89 d3                	mov    %edx,%ebx
f0102ebd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Usamos char* por que nos desplazaremos byte a byte
	char* len_align = ROUNDUP(va+len,PGSIZE); // alineo el tamanio
f0102ec3:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0102eca:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	while (va_align < len_align)
f0102ed0:	eb 59                	jmp    f0102f2b <region_alloc+0x7b>
	{
		struct PageInfo * page = page_alloc(0);
f0102ed2:	83 ec 0c             	sub    $0xc,%esp
f0102ed5:	6a 00                	push   $0x0
f0102ed7:	e8 51 e5 ff ff       	call   f010142d <page_alloc>
		if(page == NULL){
f0102edc:	83 c4 10             	add    $0x10,%esp
f0102edf:	85 c0                	test   %eax,%eax
f0102ee1:	75 17                	jne    f0102efa <region_alloc+0x4a>
			panic("ERROR EN REGION_ALLOC");
f0102ee3:	83 ec 04             	sub    $0x4,%esp
f0102ee6:	68 91 74 10 f0       	push   $0xf0107491
f0102eeb:	68 30 01 00 00       	push   $0x130
f0102ef0:	68 86 74 10 f0       	push   $0xf0107486
f0102ef5:	e8 78 d1 ff ff       	call   f0100072 <_panic>
		}
		int result = page_insert(e->env_pgdir,page,va_align,PTE_U| PTE_W);
f0102efa:	6a 06                	push   $0x6
f0102efc:	53                   	push   %ebx
f0102efd:	50                   	push   %eax
f0102efe:	ff 77 60             	pushl  0x60(%edi)
f0102f01:	e8 9f eb ff ff       	call   f0101aa5 <page_insert>
		if(result == -E_NO_MEM){
f0102f06:	83 c4 10             	add    $0x10,%esp
f0102f09:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0102f0c:	75 17                	jne    f0102f25 <region_alloc+0x75>
			panic("ERROR EN REGION_ALLOC");
f0102f0e:	83 ec 04             	sub    $0x4,%esp
f0102f11:	68 91 74 10 f0       	push   $0xf0107491
f0102f16:	68 34 01 00 00       	push   $0x134
f0102f1b:	68 86 74 10 f0       	push   $0xf0107486
f0102f20:	e8 4d d1 ff ff       	call   f0100072 <_panic>
		}
		va_align += PGSIZE;
f0102f25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	//   (Watch out for corner-cases!)
	
	char *va_align = ROUNDDOWN(va,PGSIZE); // alineo el va
	// Usamos char* por que nos desplazaremos byte a byte
	char* len_align = ROUNDUP(va+len,PGSIZE); // alineo el tamanio
	while (va_align < len_align)
f0102f2b:	39 f3                	cmp    %esi,%ebx
f0102f2d:	72 a3                	jb     f0102ed2 <region_alloc+0x22>
		if(result == -E_NO_MEM){
			panic("ERROR EN REGION_ALLOC");
		}
		va_align += PGSIZE;
	}
}
f0102f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f32:	5b                   	pop    %ebx
f0102f33:	5e                   	pop    %esi
f0102f34:	5f                   	pop    %edi
f0102f35:	5d                   	pop    %ebp
f0102f36:	c3                   	ret    

f0102f37 <load_icode>:
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary)
{
f0102f37:	55                   	push   %ebp
f0102f38:	89 e5                	mov    %esp,%ebp
f0102f3a:	57                   	push   %edi
f0102f3b:	56                   	push   %esi
f0102f3c:	53                   	push   %ebx
f0102f3d:	83 ec 1c             	sub    $0x1c,%esp
f0102f40:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 3: Your code here.
	struct Proghdr *ph, *eph;
	struct Elf *bin = (struct Elf *)binary;

	 if (bin->e_magic != ELF_MAGIC){
f0102f43:	81 3a 7f 45 4c 46    	cmpl   $0x464c457f,(%edx)
f0102f49:	74 17                	je     f0102f62 <load_icode+0x2b>
	 	panic("load_icode: Binario Invalido.");
f0102f4b:	83 ec 04             	sub    $0x4,%esp
f0102f4e:	68 a7 74 10 f0       	push   $0xf01074a7
f0102f53:	68 74 01 00 00       	push   $0x174
f0102f58:	68 86 74 10 f0       	push   $0xf0107486
f0102f5d:	e8 10 d1 ff ff       	call   f0100072 <_panic>
f0102f62:	89 d7                	mov    %edx,%edi
	 }

	 ph = (struct Proghdr *) ((uint8_t *) bin + bin->e_phoff);
f0102f64:	89 d3                	mov    %edx,%ebx
f0102f66:	03 5a 1c             	add    0x1c(%edx),%ebx
	 eph = ph + bin->e_phnum;
f0102f69:	0f b7 72 2c          	movzwl 0x2c(%edx),%esi
f0102f6d:	c1 e6 05             	shl    $0x5,%esi
f0102f70:	01 de                	add    %ebx,%esi

	 lcr3(PADDR(e->env_pgdir));
f0102f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102f75:	8b 48 60             	mov    0x60(%eax),%ecx
f0102f78:	ba 7a 01 00 00       	mov    $0x17a,%edx
f0102f7d:	b8 86 74 10 f0       	mov    $0xf0107486,%eax
f0102f82:	e8 66 fe ff ff       	call   f0102ded <_paddr>
f0102f87:	e8 fe fd ff ff       	call   f0102d8a <lcr3>
	 for (; ph < eph; ph++) {
f0102f8c:	eb 60                	jmp    f0102fee <load_icode+0xb7>
	 	if (ph->p_type != ELF_PROG_LOAD){
f0102f8e:	83 3b 01             	cmpl   $0x1,(%ebx)
f0102f91:	75 58                	jne    f0102feb <load_icode+0xb4>

	 	}else{
	 		 if (ph->p_filesz > ph->p_memsz){
f0102f93:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0102f96:	39 4b 10             	cmp    %ecx,0x10(%ebx)
f0102f99:	76 17                	jbe    f0102fb2 <load_icode+0x7b>
	 		 	panic("load_icode: Archivo mas grande que la memoria");
f0102f9b:	83 ec 04             	sub    $0x4,%esp
f0102f9e:	68 58 74 10 f0       	push   $0xf0107458
f0102fa3:	68 80 01 00 00       	push   $0x180
f0102fa8:	68 86 74 10 f0       	push   $0xf0107486
f0102fad:	e8 c0 d0 ff ff       	call   f0100072 <_panic>
	 		 }
	 		 region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f0102fb2:	8b 53 08             	mov    0x8(%ebx),%edx
f0102fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102fb8:	e8 f3 fe ff ff       	call   f0102eb0 <region_alloc>
	 		 memcpy((void *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
f0102fbd:	83 ec 04             	sub    $0x4,%esp
f0102fc0:	ff 73 10             	pushl  0x10(%ebx)
f0102fc3:	89 f8                	mov    %edi,%eax
f0102fc5:	03 43 04             	add    0x4(%ebx),%eax
f0102fc8:	50                   	push   %eax
f0102fc9:	ff 73 08             	pushl  0x8(%ebx)
f0102fcc:	e8 0e 26 00 00       	call   f01055df <memcpy>
	 		 memset((void *) ph->p_va + ph->p_filesz, 0, ph->p_memsz - ph->p_filesz);
f0102fd1:	8b 43 10             	mov    0x10(%ebx),%eax
f0102fd4:	83 c4 0c             	add    $0xc,%esp
f0102fd7:	8b 53 14             	mov    0x14(%ebx),%edx
f0102fda:	29 c2                	sub    %eax,%edx
f0102fdc:	52                   	push   %edx
f0102fdd:	6a 00                	push   $0x0
f0102fdf:	03 43 08             	add    0x8(%ebx),%eax
f0102fe2:	50                   	push   %eax
f0102fe3:	e8 41 25 00 00       	call   f0105529 <memset>
f0102fe8:	83 c4 10             	add    $0x10,%esp

	 ph = (struct Proghdr *) ((uint8_t *) bin + bin->e_phoff);
	 eph = ph + bin->e_phnum;

	 lcr3(PADDR(e->env_pgdir));
	 for (; ph < eph; ph++) {
f0102feb:	83 c3 20             	add    $0x20,%ebx
f0102fee:	39 f3                	cmp    %esi,%ebx
f0102ff0:	72 9c                	jb     f0102f8e <load_icode+0x57>
	 		 memcpy((void *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
	 		 memset((void *) ph->p_va + ph->p_filesz, 0, ph->p_memsz - ph->p_filesz);
	 	}

	 }
	 lcr3(PADDR(kern_pgdir));
f0102ff2:	8b 0d 8c ae 21 f0    	mov    0xf021ae8c,%ecx
f0102ff8:	ba 88 01 00 00       	mov    $0x188,%edx
f0102ffd:	b8 86 74 10 f0       	mov    $0xf0107486,%eax
f0103002:	e8 e6 fd ff ff       	call   f0102ded <_paddr>
f0103007:	e8 7e fd ff ff       	call   f0102d8a <lcr3>
	 e->env_tf.tf_eip = bin->e_entry;
f010300c:	8b 47 18             	mov    0x18(%edi),%eax
f010300f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103012:	89 47 30             	mov    %eax,0x30(%edi)

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
	region_alloc(e, (void *)USTACKTOP - PGSIZE, PGSIZE);
f0103015:	b9 00 10 00 00       	mov    $0x1000,%ecx
f010301a:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f010301f:	89 f8                	mov    %edi,%eax
f0103021:	e8 8a fe ff ff       	call   f0102eb0 <region_alloc>



}
f0103026:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103029:	5b                   	pop    %ebx
f010302a:	5e                   	pop    %esi
f010302b:	5f                   	pop    %edi
f010302c:	5d                   	pop    %ebp
f010302d:	c3                   	ret    

f010302e <unlock_kernel>:

static inline void
unlock_kernel(void)
{
f010302e:	55                   	push   %ebp
f010302f:	89 e5                	mov    %esp,%ebp
f0103031:	83 ec 14             	sub    $0x14,%esp
	spin_unlock(&kernel_lock);
f0103034:	68 c0 13 12 f0       	push   $0xf01213c0
f0103039:	e8 c4 2e 00 00       	call   f0105f02 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f010303e:	f3 90                	pause  
}
f0103040:	83 c4 10             	add    $0x10,%esp
f0103043:	c9                   	leave  
f0103044:	c3                   	ret    

f0103045 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103045:	55                   	push   %ebp
f0103046:	89 e5                	mov    %esp,%ebp
f0103048:	56                   	push   %esi
f0103049:	53                   	push   %ebx
f010304a:	8b 45 08             	mov    0x8(%ebp),%eax
f010304d:	8b 55 10             	mov    0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103050:	85 c0                	test   %eax,%eax
f0103052:	75 1a                	jne    f010306e <envid2env+0x29>
		*env_store = curenv;
f0103054:	e8 71 2b 00 00       	call   f0105bca <cpunum>
f0103059:	6b c0 74             	imul   $0x74,%eax,%eax
f010305c:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0103062:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103065:	89 01                	mov    %eax,(%ecx)
		return 0;
f0103067:	b8 00 00 00 00       	mov    $0x0,%eax
f010306c:	eb 70                	jmp    f01030de <envid2env+0x99>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f010306e:	89 c3                	mov    %eax,%ebx
f0103070:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103076:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103079:	03 1d 48 a2 21 f0    	add    0xf021a248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010307f:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103083:	74 05                	je     f010308a <envid2env+0x45>
f0103085:	3b 43 48             	cmp    0x48(%ebx),%eax
f0103088:	74 10                	je     f010309a <envid2env+0x55>
		*env_store = 0;
f010308a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010308d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103093:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103098:	eb 44                	jmp    f01030de <envid2env+0x99>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010309a:	84 d2                	test   %dl,%dl
f010309c:	74 36                	je     f01030d4 <envid2env+0x8f>
f010309e:	e8 27 2b 00 00       	call   f0105bca <cpunum>
f01030a3:	6b c0 74             	imul   $0x74,%eax,%eax
f01030a6:	3b 98 28 b0 21 f0    	cmp    -0xfde4fd8(%eax),%ebx
f01030ac:	74 26                	je     f01030d4 <envid2env+0x8f>
f01030ae:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01030b1:	e8 14 2b 00 00       	call   f0105bca <cpunum>
f01030b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01030b9:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01030bf:	3b 70 48             	cmp    0x48(%eax),%esi
f01030c2:	74 10                	je     f01030d4 <envid2env+0x8f>
		*env_store = 0;
f01030c4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01030c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01030cd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01030d2:	eb 0a                	jmp    f01030de <envid2env+0x99>
	}

	*env_store = e;
f01030d4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01030d7:	89 18                	mov    %ebx,(%eax)
	return 0;
f01030d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01030de:	5b                   	pop    %ebx
f01030df:	5e                   	pop    %esi
f01030e0:	5d                   	pop    %ebp
f01030e1:	c3                   	ret    

f01030e2 <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f01030e2:	55                   	push   %ebp
f01030e3:	89 e5                	mov    %esp,%ebp
	lgdt(&gdt_pd);
f01030e5:	b8 20 13 12 f0       	mov    $0xf0121320,%eax
f01030ea:	e8 8b fc ff ff       	call   f0102d7a <lgdt>
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a"(GD_UD | 3));
f01030ef:	b8 23 00 00 00       	mov    $0x23,%eax
f01030f4:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a"(GD_UD | 3));
f01030f6:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a"(GD_KD));
f01030f8:	b8 10 00 00 00       	mov    $0x10,%eax
f01030fd:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a"(GD_KD));
f01030ff:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a"(GD_KD));
f0103101:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i"(GD_KT));
f0103103:	ea 0a 31 10 f0 08 00 	ljmp   $0x8,$0xf010310a
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
f010310a:	b8 00 00 00 00       	mov    $0x0,%eax
f010310f:	e8 6e fc ff ff       	call   f0102d82 <lldt>
}
f0103114:	5d                   	pop    %ebp
f0103115:	c3                   	ret    

f0103116 <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103116:	a1 48 a2 21 f0       	mov    0xf021a248,%eax
f010311b:	83 c0 7c             	add    $0x7c,%eax
	// Set up envs array
	// LAB 3: Your code here.
	for(int i = 0; i <NENV; i++){
f010311e:	ba 00 00 00 00       	mov    $0x0,%edx
		envs[i].env_id = 0;
f0103123:	c7 40 cc 00 00 00 00 	movl   $0x0,-0x34(%eax)
		if(i+1 <NENV){
f010312a:	83 c2 01             	add    $0x1,%edx
f010312d:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
f0103133:	7f 03                	jg     f0103138 <env_init+0x22>
			envs[i].env_link = &envs[i+1];
f0103135:	89 40 c8             	mov    %eax,-0x38(%eax)
f0103138:	83 c0 7c             	add    $0x7c,%eax
void
env_init(void)
{
	// Set up envs array
	// LAB 3: Your code here.
	for(int i = 0; i <NENV; i++){
f010313b:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f0103141:	75 e0                	jne    f0103123 <env_init+0xd>
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103143:	55                   	push   %ebp
f0103144:	89 e5                	mov    %esp,%ebp
		envs[i].env_id = 0;
		if(i+1 <NENV){
			envs[i].env_link = &envs[i+1];
		}
	}
	env_free_list = &envs[0];
f0103146:	a1 48 a2 21 f0       	mov    0xf021a248,%eax
f010314b:	a3 4c a2 21 f0       	mov    %eax,0xf021a24c

	// Per-CPU part of the initialization
	env_init_percpu();
f0103150:	e8 8d ff ff ff       	call   f01030e2 <env_init_percpu>
}
f0103155:	5d                   	pop    %ebp
f0103156:	c3                   	ret    

f0103157 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103157:	55                   	push   %ebp
f0103158:	89 e5                	mov    %esp,%ebp
f010315a:	53                   	push   %ebx
f010315b:	83 ec 04             	sub    $0x4,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f010315e:	8b 1d 4c a2 21 f0    	mov    0xf021a24c,%ebx
f0103164:	85 db                	test   %ebx,%ebx
f0103166:	0f 84 e6 00 00 00    	je     f0103252 <env_alloc+0xfb>
		return -E_NO_FREE_ENV;

	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
f010316c:	89 d8                	mov    %ebx,%eax
f010316e:	e8 9c fc ff ff       	call   f0102e0f <env_setup_vm>
f0103173:	85 c0                	test   %eax,%eax
f0103175:	0f 88 dc 00 00 00    	js     f0103257 <env_alloc+0x100>
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f010317b:	8b 43 48             	mov    0x48(%ebx),%eax
f010317e:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)  // Don't create a negative env_id.
f0103183:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103188:	ba 00 10 00 00       	mov    $0x1000,%edx
f010318d:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103190:	89 da                	mov    %ebx,%edx
f0103192:	2b 15 48 a2 21 f0    	sub    0xf021a248,%edx
f0103198:	c1 fa 02             	sar    $0x2,%edx
f010319b:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01031a1:	09 d0                	or     %edx,%eax
f01031a3:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f01031a6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01031a9:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01031ac:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01031b3:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01031ba:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01031c1:	83 ec 04             	sub    $0x4,%esp
f01031c4:	6a 44                	push   $0x44
f01031c6:	6a 00                	push   $0x0
f01031c8:	53                   	push   %ebx
f01031c9:	e8 5b 23 00 00       	call   f0105529 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f01031ce:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01031d4:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01031da:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01031e0:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01031e7:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
f01031ed:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f01031f4:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f01031fb:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f01031ff:	8b 43 44             	mov    0x44(%ebx),%eax
f0103202:	a3 4c a2 21 f0       	mov    %eax,0xf021a24c
	*newenv_store = e;
f0103207:	8b 45 08             	mov    0x8(%ebp),%eax
f010320a:	89 18                	mov    %ebx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010320c:	8b 5b 48             	mov    0x48(%ebx),%ebx
f010320f:	e8 b6 29 00 00       	call   f0105bca <cpunum>
f0103214:	6b c0 74             	imul   $0x74,%eax,%eax
f0103217:	83 c4 10             	add    $0x10,%esp
f010321a:	ba 00 00 00 00       	mov    $0x0,%edx
f010321f:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f0103226:	74 11                	je     f0103239 <env_alloc+0xe2>
f0103228:	e8 9d 29 00 00       	call   f0105bca <cpunum>
f010322d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103230:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0103236:	8b 50 48             	mov    0x48(%eax),%edx
f0103239:	83 ec 04             	sub    $0x4,%esp
f010323c:	53                   	push   %ebx
f010323d:	52                   	push   %edx
f010323e:	68 c5 74 10 f0       	push   $0xf01074c5
f0103243:	e8 13 05 00 00       	call   f010375b <cprintf>
	return 0;
f0103248:	83 c4 10             	add    $0x10,%esp
f010324b:	b8 00 00 00 00       	mov    $0x0,%eax
f0103250:	eb 05                	jmp    f0103257 <env_alloc+0x100>
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
		return -E_NO_FREE_ENV;
f0103252:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
	env_free_list = e->env_link;
	*newenv_store = e;

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}
f0103257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010325a:	c9                   	leave  
f010325b:	c3                   	ret    

f010325c <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f010325c:	55                   	push   %ebp
f010325d:	89 e5                	mov    %esp,%ebp
f010325f:	53                   	push   %ebx
f0103260:	83 ec 1c             	sub    $0x1c,%esp
f0103263:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.

	
	struct Env *new_env;
	int error = env_alloc(&new_env, 0);
f0103266:	6a 00                	push   $0x0
f0103268:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010326b:	50                   	push   %eax
f010326c:	e8 e6 fe ff ff       	call   f0103157 <env_alloc>
	if(error < 0 ){
f0103271:	83 c4 10             	add    $0x10,%esp
f0103274:	85 c0                	test   %eax,%eax
f0103276:	79 15                	jns    f010328d <env_create+0x31>
		panic("env_create: %e", error);
f0103278:	50                   	push   %eax
f0103279:	68 da 74 10 f0       	push   $0xf01074da
f010327e:	68 a5 01 00 00       	push   $0x1a5
f0103283:	68 86 74 10 f0       	push   $0xf0107486
f0103288:	e8 e5 cd ff ff       	call   f0100072 <_panic>
	}
	new_env->env_type = type;
f010328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103290:	89 58 50             	mov    %ebx,0x50(%eax)
	load_icode(new_env, binary);
f0103293:	8b 55 08             	mov    0x8(%ebp),%edx
f0103296:	e8 9c fc ff ff       	call   f0102f37 <load_icode>
	
	// If this is the file server (type == ENV_TYPE_FS) give it I/O
	// privileges.
	// LAB 5: Your code here.
	if(type == ENV_TYPE_FS){
f010329b:	83 fb 01             	cmp    $0x1,%ebx
f010329e:	75 0a                	jne    f01032aa <env_create+0x4e>
		new_env->env_tf.tf_eflags|= FL_IOPL_MASK;
f01032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01032a3:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
	}

}
f01032aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01032ad:	c9                   	leave  
f01032ae:	c3                   	ret    

f01032af <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f01032af:	55                   	push   %ebp
f01032b0:	89 e5                	mov    %esp,%ebp
f01032b2:	57                   	push   %edi
f01032b3:	56                   	push   %esi
f01032b4:	53                   	push   %ebx
f01032b5:	83 ec 1c             	sub    $0x1c,%esp
f01032b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f01032bb:	e8 0a 29 00 00       	call   f0105bca <cpunum>
f01032c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01032c3:	39 b8 28 b0 21 f0    	cmp    %edi,-0xfde4fd8(%eax)
f01032c9:	75 1a                	jne    f01032e5 <env_free+0x36>
		lcr3(PADDR(kern_pgdir));
f01032cb:	8b 0d 8c ae 21 f0    	mov    0xf021ae8c,%ecx
f01032d1:	ba c1 01 00 00       	mov    $0x1c1,%edx
f01032d6:	b8 86 74 10 f0       	mov    $0xf0107486,%eax
f01032db:	e8 0d fb ff ff       	call   f0102ded <_paddr>
f01032e0:	e8 a5 fa ff ff       	call   f0102d8a <lcr3>

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01032e5:	8b 5f 48             	mov    0x48(%edi),%ebx
f01032e8:	e8 dd 28 00 00       	call   f0105bca <cpunum>
f01032ed:	6b c0 74             	imul   $0x74,%eax,%eax
f01032f0:	ba 00 00 00 00       	mov    $0x0,%edx
f01032f5:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f01032fc:	74 11                	je     f010330f <env_free+0x60>
f01032fe:	e8 c7 28 00 00       	call   f0105bca <cpunum>
f0103303:	6b c0 74             	imul   $0x74,%eax,%eax
f0103306:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f010330c:	8b 50 48             	mov    0x48(%eax),%edx
f010330f:	83 ec 04             	sub    $0x4,%esp
f0103312:	53                   	push   %ebx
f0103313:	52                   	push   %edx
f0103314:	68 e9 74 10 f0       	push   $0xf01074e9
f0103319:	e8 3d 04 00 00       	call   f010375b <cprintf>
f010331e:	83 c4 10             	add    $0x10,%esp

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103321:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103328:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010332b:	89 d0                	mov    %edx,%eax
f010332d:	c1 e0 02             	shl    $0x2,%eax
f0103330:	89 45 dc             	mov    %eax,-0x24(%ebp)
		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103333:	8b 47 60             	mov    0x60(%edi),%eax
f0103336:	8b 04 90             	mov    (%eax,%edx,4),%eax
f0103339:	a8 01                	test   $0x1,%al
f010333b:	74 72                	je     f01033af <env_free+0x100>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010333d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103342:	89 45 d8             	mov    %eax,-0x28(%ebp)
		pt = (pte_t *) KADDR(pa);
f0103345:	89 c1                	mov    %eax,%ecx
f0103347:	ba cf 01 00 00       	mov    $0x1cf,%edx
f010334c:	b8 86 74 10 f0       	mov    $0xf0107486,%eax
f0103351:	e8 4d fa ff ff       	call   f0102da3 <_kaddr>
f0103356:	89 c6                	mov    %eax,%esi

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103358:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010335b:	c1 e0 16             	shl    $0x16,%eax
f010335e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t *) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103361:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0103366:	f6 04 9e 01          	testb  $0x1,(%esi,%ebx,4)
f010336a:	74 17                	je     f0103383 <env_free+0xd4>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010336c:	83 ec 08             	sub    $0x8,%esp
f010336f:	89 d8                	mov    %ebx,%eax
f0103371:	c1 e0 0c             	shl    $0xc,%eax
f0103374:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103377:	50                   	push   %eax
f0103378:	ff 77 60             	pushl  0x60(%edi)
f010337b:	e8 d8 e6 ff ff       	call   f0101a58 <page_remove>
f0103380:	83 c4 10             	add    $0x10,%esp
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t *) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103383:	83 c3 01             	add    $0x1,%ebx
f0103386:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f010338c:	75 d8                	jne    f0103366 <env_free+0xb7>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f010338e:	8b 47 60             	mov    0x60(%edi),%eax
f0103391:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103394:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
		page_decref(pa2page(pa));
f010339b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010339e:	e8 e1 fa ff ff       	call   f0102e84 <pa2page>
f01033a3:	83 ec 0c             	sub    $0xc,%esp
f01033a6:	50                   	push   %eax
f01033a7:	e8 ce e4 ff ff       	call   f010187a <page_decref>
f01033ac:	83 c4 10             	add    $0x10,%esp
	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01033af:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f01033b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01033b6:	3d bb 03 00 00       	cmp    $0x3bb,%eax
f01033bb:	0f 85 67 ff ff ff    	jne    f0103328 <env_free+0x79>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01033c1:	8b 4f 60             	mov    0x60(%edi),%ecx
f01033c4:	ba dd 01 00 00       	mov    $0x1dd,%edx
f01033c9:	b8 86 74 10 f0       	mov    $0xf0107486,%eax
f01033ce:	e8 1a fa ff ff       	call   f0102ded <_paddr>
	e->env_pgdir = 0;
f01033d3:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	page_decref(pa2page(pa));
f01033da:	e8 a5 fa ff ff       	call   f0102e84 <pa2page>
f01033df:	83 ec 0c             	sub    $0xc,%esp
f01033e2:	50                   	push   %eax
f01033e3:	e8 92 e4 ff ff       	call   f010187a <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01033e8:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01033ef:	a1 4c a2 21 f0       	mov    0xf021a24c,%eax
f01033f4:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f01033f7:	89 3d 4c a2 21 f0    	mov    %edi,0xf021a24c
}
f01033fd:	83 c4 10             	add    $0x10,%esp
f0103400:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103403:	5b                   	pop    %ebx
f0103404:	5e                   	pop    %esi
f0103405:	5f                   	pop    %edi
f0103406:	5d                   	pop    %ebp
f0103407:	c3                   	ret    

f0103408 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103408:	55                   	push   %ebp
f0103409:	89 e5                	mov    %esp,%ebp
f010340b:	53                   	push   %ebx
f010340c:	83 ec 04             	sub    $0x4,%esp
f010340f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103412:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103416:	75 19                	jne    f0103431 <env_destroy+0x29>
f0103418:	e8 ad 27 00 00       	call   f0105bca <cpunum>
f010341d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103420:	3b 98 28 b0 21 f0    	cmp    -0xfde4fd8(%eax),%ebx
f0103426:	74 09                	je     f0103431 <env_destroy+0x29>
		e->env_status = ENV_DYING;
f0103428:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f010342f:	eb 33                	jmp    f0103464 <env_destroy+0x5c>
	}

	env_free(e);
f0103431:	83 ec 0c             	sub    $0xc,%esp
f0103434:	53                   	push   %ebx
f0103435:	e8 75 fe ff ff       	call   f01032af <env_free>

	if (curenv == e) {
f010343a:	e8 8b 27 00 00       	call   f0105bca <cpunum>
f010343f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103442:	83 c4 10             	add    $0x10,%esp
f0103445:	3b 98 28 b0 21 f0    	cmp    -0xfde4fd8(%eax),%ebx
f010344b:	75 17                	jne    f0103464 <env_destroy+0x5c>
		curenv = NULL;
f010344d:	e8 78 27 00 00       	call   f0105bca <cpunum>
f0103452:	6b c0 74             	imul   $0x74,%eax,%eax
f0103455:	c7 80 28 b0 21 f0 00 	movl   $0x0,-0xfde4fd8(%eax)
f010345c:	00 00 00 
		sched_yield();
f010345f:	e8 07 0e 00 00       	call   f010426b <sched_yield>
	}
}
f0103464:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103467:	c9                   	leave  
f0103468:	c3                   	ret    

f0103469 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103469:	55                   	push   %ebp
f010346a:	89 e5                	mov    %esp,%ebp
f010346c:	53                   	push   %ebx
f010346d:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103470:	e8 55 27 00 00       	call   f0105bca <cpunum>
f0103475:	6b c0 74             	imul   $0x74,%eax,%eax
f0103478:	8b 98 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%ebx
f010347e:	e8 47 27 00 00       	call   f0105bca <cpunum>
f0103483:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile("\tmovl %0,%%esp\n"
f0103486:	8b 65 08             	mov    0x8(%ebp),%esp
f0103489:	61                   	popa   
f010348a:	07                   	pop    %es
f010348b:	1f                   	pop    %ds
f010348c:	83 c4 08             	add    $0x8,%esp
f010348f:	cf                   	iret   
	             "\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
	             "\tiret\n"
	             :
	             : "g"(tf)
	             : "memory");
	panic("iret failed"); /* mostly to placate the compiler */
f0103490:	83 ec 04             	sub    $0x4,%esp
f0103493:	68 ff 74 10 f0       	push   $0xf01074ff
f0103498:	68 15 02 00 00       	push   $0x215
f010349d:	68 86 74 10 f0       	push   $0xf0107486
f01034a2:	e8 cb cb ff ff       	call   f0100072 <_panic>

f01034a7 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01034a7:	55                   	push   %ebp
f01034a8:	89 e5                	mov    %esp,%ebp
f01034aa:	53                   	push   %ebx
f01034ab:	83 ec 04             	sub    $0x4,%esp
f01034ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	//Paso 1
	if(curenv && (curenv->env_status == ENV_RUNNING)){
f01034b1:	e8 14 27 00 00       	call   f0105bca <cpunum>
f01034b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01034b9:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f01034c0:	74 29                	je     f01034eb <env_run+0x44>
f01034c2:	e8 03 27 00 00       	call   f0105bca <cpunum>
f01034c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01034ca:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01034d0:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01034d4:	75 15                	jne    f01034eb <env_run+0x44>
		curenv->env_status = ENV_RUNNABLE;
f01034d6:	e8 ef 26 00 00       	call   f0105bca <cpunum>
f01034db:	6b c0 74             	imul   $0x74,%eax,%eax
f01034de:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01034e4:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	}
	curenv = e;
f01034eb:	e8 da 26 00 00       	call   f0105bca <cpunum>
f01034f0:	6b c0 74             	imul   $0x74,%eax,%eax
f01034f3:	89 98 28 b0 21 f0    	mov    %ebx,-0xfde4fd8(%eax)
	curenv->env_status = ENV_RUNNING;
f01034f9:	e8 cc 26 00 00       	call   f0105bca <cpunum>
f01034fe:	6b c0 74             	imul   $0x74,%eax,%eax
f0103501:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0103507:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	e->env_runs++;
f010350e:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	lcr3(PADDR(e->env_pgdir));
f0103512:	8b 4b 60             	mov    0x60(%ebx),%ecx
f0103515:	ba 3b 02 00 00       	mov    $0x23b,%edx
f010351a:	b8 86 74 10 f0       	mov    $0xf0107486,%eax
f010351f:	e8 c9 f8 ff ff       	call   f0102ded <_paddr>
f0103524:	e8 61 f8 ff ff       	call   f0102d8a <lcr3>
	
	//Paso 2
	unlock_kernel();
f0103529:	e8 00 fb ff ff       	call   f010302e <unlock_kernel>
	env_pop_tf(&e->env_tf);
f010352e:	83 ec 0c             	sub    $0xc,%esp
f0103531:	53                   	push   %ebx
f0103532:	e8 32 ff ff ff       	call   f0103469 <env_pop_tf>

f0103537 <inb>:
	asm volatile("int3");
}

static inline uint8_t
inb(int port)
{
f0103537:	55                   	push   %ebp
f0103538:	89 e5                	mov    %esp,%ebp
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010353a:	89 c2                	mov    %eax,%edx
f010353c:	ec                   	in     (%dx),%al
	return data;
}
f010353d:	5d                   	pop    %ebp
f010353e:	c3                   	ret    

f010353f <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
f010353f:	55                   	push   %ebp
f0103540:	89 e5                	mov    %esp,%ebp
f0103542:	89 c1                	mov    %eax,%ecx
f0103544:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103546:	89 ca                	mov    %ecx,%edx
f0103548:	ee                   	out    %al,(%dx)
}
f0103549:	5d                   	pop    %ebp
f010354a:	c3                   	ret    

f010354b <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010354b:	55                   	push   %ebp
f010354c:	89 e5                	mov    %esp,%ebp
	outb(IO_RTC, reg);
f010354e:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
f0103552:	b8 70 00 00 00       	mov    $0x70,%eax
f0103557:	e8 e3 ff ff ff       	call   f010353f <outb>
	return inb(IO_RTC+1);
f010355c:	b8 71 00 00 00       	mov    $0x71,%eax
f0103561:	e8 d1 ff ff ff       	call   f0103537 <inb>
f0103566:	0f b6 c0             	movzbl %al,%eax
}
f0103569:	5d                   	pop    %ebp
f010356a:	c3                   	ret    

f010356b <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f010356b:	55                   	push   %ebp
f010356c:	89 e5                	mov    %esp,%ebp
	outb(IO_RTC, reg);
f010356e:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
f0103572:	b8 70 00 00 00       	mov    $0x70,%eax
f0103577:	e8 c3 ff ff ff       	call   f010353f <outb>
	outb(IO_RTC+1, datum);
f010357c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
f0103580:	b8 71 00 00 00       	mov    $0x71,%eax
f0103585:	e8 b5 ff ff ff       	call   f010353f <outb>
}
f010358a:	5d                   	pop    %ebp
f010358b:	c3                   	ret    

f010358c <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
f010358c:	55                   	push   %ebp
f010358d:	89 e5                	mov    %esp,%ebp
f010358f:	89 c1                	mov    %eax,%ecx
f0103591:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103593:	89 ca                	mov    %ecx,%edx
f0103595:	ee                   	out    %al,(%dx)
}
f0103596:	5d                   	pop    %ebp
f0103597:	c3                   	ret    

f0103598 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103598:	55                   	push   %ebp
f0103599:	89 e5                	mov    %esp,%ebp
f010359b:	56                   	push   %esi
f010359c:	53                   	push   %ebx
f010359d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	irq_mask_8259A = mask;
f01035a0:	66 89 1d a8 13 12 f0 	mov    %bx,0xf01213a8
	if (!didinit)
f01035a7:	80 3d 50 a2 21 f0 00 	cmpb   $0x0,0xf021a250
f01035ae:	74 64                	je     f0103614 <irq_setmask_8259A+0x7c>
f01035b0:	89 de                	mov    %ebx,%esi
		return;
	outb(IO_PIC1+1, (char)mask);
f01035b2:	0f b6 d3             	movzbl %bl,%edx
f01035b5:	b8 21 00 00 00       	mov    $0x21,%eax
f01035ba:	e8 cd ff ff ff       	call   f010358c <outb>
	outb(IO_PIC2+1, (char)(mask >> 8));
f01035bf:	0f b6 d7             	movzbl %bh,%edx
f01035c2:	b8 a1 00 00 00       	mov    $0xa1,%eax
f01035c7:	e8 c0 ff ff ff       	call   f010358c <outb>
	cprintf("enabled interrupts:");
f01035cc:	83 ec 0c             	sub    $0xc,%esp
f01035cf:	68 0b 75 10 f0       	push   $0xf010750b
f01035d4:	e8 82 01 00 00       	call   f010375b <cprintf>
f01035d9:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01035dc:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01035e1:	0f b7 f6             	movzwl %si,%esi
f01035e4:	f7 d6                	not    %esi
f01035e6:	0f a3 de             	bt     %ebx,%esi
f01035e9:	73 11                	jae    f01035fc <irq_setmask_8259A+0x64>
			cprintf(" %d", i);
f01035eb:	83 ec 08             	sub    $0x8,%esp
f01035ee:	53                   	push   %ebx
f01035ef:	68 df 79 10 f0       	push   $0xf01079df
f01035f4:	e8 62 01 00 00       	call   f010375b <cprintf>
f01035f9:	83 c4 10             	add    $0x10,%esp
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f01035fc:	83 c3 01             	add    $0x1,%ebx
f01035ff:	83 fb 10             	cmp    $0x10,%ebx
f0103602:	75 e2                	jne    f01035e6 <irq_setmask_8259A+0x4e>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f0103604:	83 ec 0c             	sub    $0xc,%esp
f0103607:	68 54 74 10 f0       	push   $0xf0107454
f010360c:	e8 4a 01 00 00       	call   f010375b <cprintf>
f0103611:	83 c4 10             	add    $0x10,%esp
}
f0103614:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103617:	5b                   	pop    %ebx
f0103618:	5e                   	pop    %esi
f0103619:	5d                   	pop    %ebp
f010361a:	c3                   	ret    

f010361b <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f010361b:	55                   	push   %ebp
f010361c:	89 e5                	mov    %esp,%ebp
f010361e:	83 ec 08             	sub    $0x8,%esp
	didinit = 1;
f0103621:	c6 05 50 a2 21 f0 01 	movb   $0x1,0xf021a250

	// mask all interrupts
	outb(IO_PIC1+1, 0xFF);
f0103628:	ba ff 00 00 00       	mov    $0xff,%edx
f010362d:	b8 21 00 00 00       	mov    $0x21,%eax
f0103632:	e8 55 ff ff ff       	call   f010358c <outb>
	outb(IO_PIC2+1, 0xFF);
f0103637:	ba ff 00 00 00       	mov    $0xff,%edx
f010363c:	b8 a1 00 00 00       	mov    $0xa1,%eax
f0103641:	e8 46 ff ff ff       	call   f010358c <outb>

	// ICW1:  0001g0hi
	//    g:  0 = edge triggering, 1 = level triggering
	//    h:  0 = cascaded PICs, 1 = master only
	//    i:  0 = no ICW4, 1 = ICW4 required
	outb(IO_PIC1, 0x11);
f0103646:	ba 11 00 00 00       	mov    $0x11,%edx
f010364b:	b8 20 00 00 00       	mov    $0x20,%eax
f0103650:	e8 37 ff ff ff       	call   f010358c <outb>

	// ICW2:  Vector offset
	outb(IO_PIC1+1, IRQ_OFFSET);
f0103655:	ba 20 00 00 00       	mov    $0x20,%edx
f010365a:	b8 21 00 00 00       	mov    $0x21,%eax
f010365f:	e8 28 ff ff ff       	call   f010358c <outb>

	// ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
	//        3-bit No of IR line at which slave connects to master(slave PIC).
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);
f0103664:	ba 04 00 00 00       	mov    $0x4,%edx
f0103669:	b8 21 00 00 00       	mov    $0x21,%eax
f010366e:	e8 19 ff ff ff       	call   f010358c <outb>
	//    m:  0 = slave PIC, 1 = master PIC
	//	  (ignored when b is 0, as the master/slave role
	//	  can be hardwired).
	//    a:  1 = Automatic EOI mode
	//    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
	outb(IO_PIC1+1, 0x3);
f0103673:	ba 03 00 00 00       	mov    $0x3,%edx
f0103678:	b8 21 00 00 00       	mov    $0x21,%eax
f010367d:	e8 0a ff ff ff       	call   f010358c <outb>

	// Set up slave (8259A-2)
	outb(IO_PIC2, 0x11);			// ICW1
f0103682:	ba 11 00 00 00       	mov    $0x11,%edx
f0103687:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010368c:	e8 fb fe ff ff       	call   f010358c <outb>
	outb(IO_PIC2+1, IRQ_OFFSET + 8);	// ICW2
f0103691:	ba 28 00 00 00       	mov    $0x28,%edx
f0103696:	b8 a1 00 00 00       	mov    $0xa1,%eax
f010369b:	e8 ec fe ff ff       	call   f010358c <outb>
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
f01036a0:	ba 02 00 00 00       	mov    $0x2,%edx
f01036a5:	b8 a1 00 00 00       	mov    $0xa1,%eax
f01036aa:	e8 dd fe ff ff       	call   f010358c <outb>
	// NB Automatic EOI mode doesn't tend to work on the slave.
	// Linux source code says it's "to be investigated".
	outb(IO_PIC2+1, 0x01);			// ICW4
f01036af:	ba 01 00 00 00       	mov    $0x1,%edx
f01036b4:	b8 a1 00 00 00       	mov    $0xa1,%eax
f01036b9:	e8 ce fe ff ff       	call   f010358c <outb>

	// OCW3:  0ef01prs
	//   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
	//    p:  0 = no polling, 1 = polling mode
	//   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
	outb(IO_PIC1, 0x68);             /* clear specific mask */
f01036be:	ba 68 00 00 00       	mov    $0x68,%edx
f01036c3:	b8 20 00 00 00       	mov    $0x20,%eax
f01036c8:	e8 bf fe ff ff       	call   f010358c <outb>
	outb(IO_PIC1, 0x0a);             /* read IRR by default */
f01036cd:	ba 0a 00 00 00       	mov    $0xa,%edx
f01036d2:	b8 20 00 00 00       	mov    $0x20,%eax
f01036d7:	e8 b0 fe ff ff       	call   f010358c <outb>

	outb(IO_PIC2, 0x68);               /* OCW3 */
f01036dc:	ba 68 00 00 00       	mov    $0x68,%edx
f01036e1:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01036e6:	e8 a1 fe ff ff       	call   f010358c <outb>
	outb(IO_PIC2, 0x0a);               /* OCW3 */
f01036eb:	ba 0a 00 00 00       	mov    $0xa,%edx
f01036f0:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01036f5:	e8 92 fe ff ff       	call   f010358c <outb>

	if (irq_mask_8259A != 0xFFFF)
f01036fa:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f0103701:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103705:	74 0f                	je     f0103716 <pic_init+0xfb>
		irq_setmask_8259A(irq_mask_8259A);
f0103707:	83 ec 0c             	sub    $0xc,%esp
f010370a:	0f b7 c0             	movzwl %ax,%eax
f010370d:	50                   	push   %eax
f010370e:	e8 85 fe ff ff       	call   f0103598 <irq_setmask_8259A>
f0103713:	83 c4 10             	add    $0x10,%esp
}
f0103716:	c9                   	leave  
f0103717:	c3                   	ret    

f0103718 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103718:	55                   	push   %ebp
f0103719:	89 e5                	mov    %esp,%ebp
f010371b:	53                   	push   %ebx
f010371c:	83 ec 10             	sub    $0x10,%esp
f010371f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cputchar(ch);
f0103722:	ff 75 08             	pushl  0x8(%ebp)
f0103725:	e8 f9 d1 ff ff       	call   f0100923 <cputchar>
	(*cnt)++;
f010372a:	83 03 01             	addl   $0x1,(%ebx)
}
f010372d:	83 c4 10             	add    $0x10,%esp
f0103730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103733:	c9                   	leave  
f0103734:	c3                   	ret    

f0103735 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103735:	55                   	push   %ebp
f0103736:	89 e5                	mov    %esp,%ebp
f0103738:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f010373b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103742:	ff 75 0c             	pushl  0xc(%ebp)
f0103745:	ff 75 08             	pushl  0x8(%ebp)
f0103748:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010374b:	50                   	push   %eax
f010374c:	68 18 37 10 f0       	push   $0xf0103718
f0103751:	e8 94 17 00 00       	call   f0104eea <vprintfmt>
	return cnt;
}
f0103756:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103759:	c9                   	leave  
f010375a:	c3                   	ret    

f010375b <cprintf>:

int
cprintf(const char *fmt, ...)
{
f010375b:	55                   	push   %ebp
f010375c:	89 e5                	mov    %esp,%ebp
f010375e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103761:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103764:	50                   	push   %eax
f0103765:	ff 75 08             	pushl  0x8(%ebp)
f0103768:	e8 c8 ff ff ff       	call   f0103735 <vcprintf>
	va_end(ap);

	return cnt;
}
f010376d:	c9                   	leave  
f010376e:	c3                   	ret    

f010376f <lidt>:
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
}

static inline void
lidt(void *p)
{
f010376f:	55                   	push   %ebp
f0103770:	89 e5                	mov    %esp,%ebp
	asm volatile("lidt (%0)" : : "r" (p));
f0103772:	0f 01 18             	lidtl  (%eax)
}
f0103775:	5d                   	pop    %ebp
f0103776:	c3                   	ret    

f0103777 <ltr>:
	asm volatile("lldt %0" : : "r" (sel));
}

static inline void
ltr(uint16_t sel)
{
f0103777:	55                   	push   %ebp
f0103778:	89 e5                	mov    %esp,%ebp
	asm volatile("ltr %0" : : "r" (sel));
f010377a:	0f 00 d8             	ltr    %ax
}
f010377d:	5d                   	pop    %ebp
f010377e:	c3                   	ret    

f010377f <rcr2>:
	return val;
}

static inline uint32_t
rcr2(void)
{
f010377f:	55                   	push   %ebp
f0103780:	89 e5                	mov    %esp,%ebp
	uint32_t val;
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103782:	0f 20 d0             	mov    %cr2,%eax
	return val;
}
f0103785:	5d                   	pop    %ebp
f0103786:	c3                   	ret    

f0103787 <read_eflags>:
	asm volatile("movl %0,%%cr3" : : "r" (cr3));
}

static inline uint32_t
read_eflags(void)
{
f0103787:	55                   	push   %ebp
f0103788:	89 e5                	mov    %esp,%ebp
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010378a:	9c                   	pushf  
f010378b:	58                   	pop    %eax
	return eflags;
}
f010378c:	5d                   	pop    %ebp
f010378d:	c3                   	ret    

f010378e <xchg>:
	return tsc;
}

static inline uint32_t
xchg(volatile uint32_t *addr, uint32_t newval)
{
f010378e:	55                   	push   %ebp
f010378f:	89 e5                	mov    %esp,%ebp
f0103791:	89 c1                	mov    %eax,%ecx
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0103793:	89 d0                	mov    %edx,%eax
f0103795:	f0 87 01             	lock xchg %eax,(%ecx)
		     : "+m" (*addr), "=a" (result)
		     : "1" (newval)
		     : "cc");
	return result;
}
f0103798:	5d                   	pop    %ebp
f0103799:	c3                   	ret    

f010379a <trapname>:
struct Pseudodesc idt_pd = { sizeof(idt) - 1, (uint32_t) idt };


static const char *
trapname(int trapno)
{
f010379a:	55                   	push   %ebp
f010379b:	89 e5                	mov    %esp,%ebp
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < ARRAY_SIZE(excnames))
f010379d:	83 f8 13             	cmp    $0x13,%eax
f01037a0:	77 09                	ja     f01037ab <trapname+0x11>
		return excnames[trapno];
f01037a2:	8b 04 85 c0 78 10 f0 	mov    -0xfef8740(,%eax,4),%eax
f01037a9:	eb 1f                	jmp    f01037ca <trapname+0x30>
	if (trapno == T_SYSCALL)
f01037ab:	83 f8 30             	cmp    $0x30,%eax
f01037ae:	74 15                	je     f01037c5 <trapname+0x2b>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01037b0:	83 e8 20             	sub    $0x20,%eax
		return "Hardware Interrupt";
	return "(unknown trap)";
f01037b3:	83 f8 10             	cmp    $0x10,%eax
f01037b6:	ba 3e 75 10 f0       	mov    $0xf010753e,%edx
f01037bb:	b8 2b 75 10 f0       	mov    $0xf010752b,%eax
f01037c0:	0f 43 c2             	cmovae %edx,%eax
f01037c3:	eb 05                	jmp    f01037ca <trapname+0x30>
	};

	if (trapno < ARRAY_SIZE(excnames))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f01037c5:	b8 1f 75 10 f0       	mov    $0xf010751f,%eax
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}
f01037ca:	5d                   	pop    %ebp
f01037cb:	c3                   	ret    

f01037cc <lock_kernel>:

extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
f01037cc:	55                   	push   %ebp
f01037cd:	89 e5                	mov    %esp,%ebp
f01037cf:	83 ec 14             	sub    $0x14,%esp
	spin_lock(&kernel_lock);
f01037d2:	68 c0 13 12 f0       	push   $0xf01213c0
f01037d7:	e8 c4 26 00 00       	call   f0105ea0 <spin_lock>
}
f01037dc:	83 c4 10             	add    $0x10,%esp
f01037df:	c9                   	leave  
f01037e0:	c3                   	ret    

f01037e1 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f01037e1:	55                   	push   %ebp
f01037e2:	89 e5                	mov    %esp,%ebp
f01037e4:	56                   	push   %esi
f01037e5:	53                   	push   %ebx
	//



	// LAB 4: Your code here:
	int id = cpunum();
f01037e6:	e8 df 23 00 00       	call   f0105bca <cpunum>
	struct CpuInfo *cpu = &cpus[id];
	struct Taskstate *ts = &cpu->cpu_ts;
f01037eb:	6b d0 74             	imul   $0x74,%eax,%edx
f01037ee:	8d 8a 2c b0 21 f0    	lea    -0xfde4fd4(%edx),%ecx

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts->ts_esp0 = KSTACKTOP - id*(KSTKGAP + KSTKSIZE);
f01037f4:	89 c6                	mov    %eax,%esi
f01037f6:	c1 e6 10             	shl    $0x10,%esi
f01037f9:	bb 00 00 00 f0       	mov    $0xf0000000,%ebx
f01037fe:	29 f3                	sub    %esi,%ebx
f0103800:	89 9a 30 b0 21 f0    	mov    %ebx,-0xfde4fd0(%edx)
	ts->ts_ss0 = GD_KD;
f0103806:	66 c7 82 34 b0 21 f0 	movw   $0x10,-0xfde4fcc(%edx)
f010380d:	10 00 
	//ts->ts_iomb = sizeof(struct Taskstate);

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + id] =
f010380f:	8d 50 05             	lea    0x5(%eax),%edx
f0103812:	66 c7 04 d5 40 13 12 	movw   $0x67,-0xfedecc0(,%edx,8)
f0103819:	f0 67 00 
f010381c:	66 89 0c d5 42 13 12 	mov    %cx,-0xfedecbe(,%edx,8)
f0103823:	f0 
f0103824:	89 cb                	mov    %ecx,%ebx
f0103826:	c1 eb 10             	shr    $0x10,%ebx
f0103829:	88 1c d5 44 13 12 f0 	mov    %bl,-0xfedecbc(,%edx,8)
f0103830:	c6 04 d5 46 13 12 f0 	movb   $0x40,-0xfedecba(,%edx,8)
f0103837:	40 
f0103838:	c1 e9 18             	shr    $0x18,%ecx
f010383b:	88 0c d5 47 13 12 f0 	mov    %cl,-0xfedecb9(,%edx,8)
	        SEG16(STS_T32A, (uint32_t)(ts), sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + id].sd_s = 0;
f0103842:	c6 04 d5 45 13 12 f0 	movb   $0x89,-0xfedecbb(,%edx,8)
f0103849:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (id << 3));
f010384a:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
f0103851:	0f b7 c0             	movzwl %ax,%eax
f0103854:	e8 1e ff ff ff       	call   f0103777 <ltr>

	// Load the IDT
	lidt(&idt_pd);
f0103859:	b8 ac 13 12 f0       	mov    $0xf01213ac,%eax
f010385e:	e8 0c ff ff ff       	call   f010376f <lidt>
}
f0103863:	5b                   	pop    %ebx
f0103864:	5e                   	pop    %esi
f0103865:	5d                   	pop    %ebp
f0103866:	c3                   	ret    

f0103867 <trap_init>:



void
trap_init(void)
{
f0103867:	55                   	push   %ebp
f0103868:	89 e5                	mov    %esp,%ebp
f010386a:	83 ec 08             	sub    $0x8,%esp
	void t_syscall();
	void t_irqtimer();
	void t_irqkbd();
	void t_irqserial();

	SETGATE(idt[T_DIVIDE], 0, GD_KT, t_divide, 0);
f010386d:	b8 ee 40 10 f0       	mov    $0xf01040ee,%eax
f0103872:	66 a3 60 a2 21 f0    	mov    %ax,0xf021a260
f0103878:	66 c7 05 62 a2 21 f0 	movw   $0x8,0xf021a262
f010387f:	08 00 
f0103881:	c6 05 64 a2 21 f0 00 	movb   $0x0,0xf021a264
f0103888:	c6 05 65 a2 21 f0 8e 	movb   $0x8e,0xf021a265
f010388f:	c1 e8 10             	shr    $0x10,%eax
f0103892:	66 a3 66 a2 21 f0    	mov    %ax,0xf021a266
	SETGATE(idt[T_DEBUG], 0, GD_KT, t_debug, 0);
f0103898:	b8 f4 40 10 f0       	mov    $0xf01040f4,%eax
f010389d:	66 a3 68 a2 21 f0    	mov    %ax,0xf021a268
f01038a3:	66 c7 05 6a a2 21 f0 	movw   $0x8,0xf021a26a
f01038aa:	08 00 
f01038ac:	c6 05 6c a2 21 f0 00 	movb   $0x0,0xf021a26c
f01038b3:	c6 05 6d a2 21 f0 8e 	movb   $0x8e,0xf021a26d
f01038ba:	c1 e8 10             	shr    $0x10,%eax
f01038bd:	66 a3 6e a2 21 f0    	mov    %ax,0xf021a26e
	SETGATE(idt[T_NMI], 0, GD_KT, t_nmi, 0);
f01038c3:	b8 fa 40 10 f0       	mov    $0xf01040fa,%eax
f01038c8:	66 a3 70 a2 21 f0    	mov    %ax,0xf021a270
f01038ce:	66 c7 05 72 a2 21 f0 	movw   $0x8,0xf021a272
f01038d5:	08 00 
f01038d7:	c6 05 74 a2 21 f0 00 	movb   $0x0,0xf021a274
f01038de:	c6 05 75 a2 21 f0 8e 	movb   $0x8e,0xf021a275
f01038e5:	c1 e8 10             	shr    $0x10,%eax
f01038e8:	66 a3 76 a2 21 f0    	mov    %ax,0xf021a276
	SETGATE(idt[T_BRKPT], 0, GD_KT, t_brkpt, 3); //3 para darle privilegio a los programas de usuario para invocar esta excepcion.
f01038ee:	b8 00 41 10 f0       	mov    $0xf0104100,%eax
f01038f3:	66 a3 78 a2 21 f0    	mov    %ax,0xf021a278
f01038f9:	66 c7 05 7a a2 21 f0 	movw   $0x8,0xf021a27a
f0103900:	08 00 
f0103902:	c6 05 7c a2 21 f0 00 	movb   $0x0,0xf021a27c
f0103909:	c6 05 7d a2 21 f0 ee 	movb   $0xee,0xf021a27d
f0103910:	c1 e8 10             	shr    $0x10,%eax
f0103913:	66 a3 7e a2 21 f0    	mov    %ax,0xf021a27e
	SETGATE(idt[T_OFLOW], 0, GD_KT, t_oflow, 0);
f0103919:	b8 06 41 10 f0       	mov    $0xf0104106,%eax
f010391e:	66 a3 80 a2 21 f0    	mov    %ax,0xf021a280
f0103924:	66 c7 05 82 a2 21 f0 	movw   $0x8,0xf021a282
f010392b:	08 00 
f010392d:	c6 05 84 a2 21 f0 00 	movb   $0x0,0xf021a284
f0103934:	c6 05 85 a2 21 f0 8e 	movb   $0x8e,0xf021a285
f010393b:	c1 e8 10             	shr    $0x10,%eax
f010393e:	66 a3 86 a2 21 f0    	mov    %ax,0xf021a286
	SETGATE(idt[T_BOUND], 0, GD_KT, t_bound, 0);
f0103944:	b8 0c 41 10 f0       	mov    $0xf010410c,%eax
f0103949:	66 a3 88 a2 21 f0    	mov    %ax,0xf021a288
f010394f:	66 c7 05 8a a2 21 f0 	movw   $0x8,0xf021a28a
f0103956:	08 00 
f0103958:	c6 05 8c a2 21 f0 00 	movb   $0x0,0xf021a28c
f010395f:	c6 05 8d a2 21 f0 8e 	movb   $0x8e,0xf021a28d
f0103966:	c1 e8 10             	shr    $0x10,%eax
f0103969:	66 a3 8e a2 21 f0    	mov    %ax,0xf021a28e
	SETGATE(idt[T_ILLOP], 0, GD_KT, t_illop, 0);
f010396f:	b8 12 41 10 f0       	mov    $0xf0104112,%eax
f0103974:	66 a3 90 a2 21 f0    	mov    %ax,0xf021a290
f010397a:	66 c7 05 92 a2 21 f0 	movw   $0x8,0xf021a292
f0103981:	08 00 
f0103983:	c6 05 94 a2 21 f0 00 	movb   $0x0,0xf021a294
f010398a:	c6 05 95 a2 21 f0 8e 	movb   $0x8e,0xf021a295
f0103991:	c1 e8 10             	shr    $0x10,%eax
f0103994:	66 a3 96 a2 21 f0    	mov    %ax,0xf021a296
	SETGATE(idt[T_DEVICE], 0, GD_KT, t_device, 0);
f010399a:	b8 18 41 10 f0       	mov    $0xf0104118,%eax
f010399f:	66 a3 98 a2 21 f0    	mov    %ax,0xf021a298
f01039a5:	66 c7 05 9a a2 21 f0 	movw   $0x8,0xf021a29a
f01039ac:	08 00 
f01039ae:	c6 05 9c a2 21 f0 00 	movb   $0x0,0xf021a29c
f01039b5:	c6 05 9d a2 21 f0 8e 	movb   $0x8e,0xf021a29d
f01039bc:	c1 e8 10             	shr    $0x10,%eax
f01039bf:	66 a3 9e a2 21 f0    	mov    %ax,0xf021a29e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, t_dblflt, 0);
f01039c5:	ba 1e 41 10 f0       	mov    $0xf010411e,%edx
f01039ca:	66 89 15 a0 a2 21 f0 	mov    %dx,0xf021a2a0
f01039d1:	66 c7 05 a2 a2 21 f0 	movw   $0x8,0xf021a2a2
f01039d8:	08 00 
f01039da:	c6 05 a4 a2 21 f0 00 	movb   $0x0,0xf021a2a4
f01039e1:	c6 05 a5 a2 21 f0 8e 	movb   $0x8e,0xf021a2a5
f01039e8:	89 d1                	mov    %edx,%ecx
f01039ea:	c1 e9 10             	shr    $0x10,%ecx
f01039ed:	66 89 0d a6 a2 21 f0 	mov    %cx,0xf021a2a6
	SETGATE(idt[T_TSS], 0, GD_KT, t_tss, 0);
f01039f4:	b8 22 41 10 f0       	mov    $0xf0104122,%eax
f01039f9:	66 a3 b0 a2 21 f0    	mov    %ax,0xf021a2b0
f01039ff:	66 c7 05 b2 a2 21 f0 	movw   $0x8,0xf021a2b2
f0103a06:	08 00 
f0103a08:	c6 05 b4 a2 21 f0 00 	movb   $0x0,0xf021a2b4
f0103a0f:	c6 05 b5 a2 21 f0 8e 	movb   $0x8e,0xf021a2b5
f0103a16:	c1 e8 10             	shr    $0x10,%eax
f0103a19:	66 a3 b6 a2 21 f0    	mov    %ax,0xf021a2b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, t_segnp, 0);
f0103a1f:	b8 28 41 10 f0       	mov    $0xf0104128,%eax
f0103a24:	66 a3 b8 a2 21 f0    	mov    %ax,0xf021a2b8
f0103a2a:	66 c7 05 ba a2 21 f0 	movw   $0x8,0xf021a2ba
f0103a31:	08 00 
f0103a33:	c6 05 bc a2 21 f0 00 	movb   $0x0,0xf021a2bc
f0103a3a:	c6 05 bd a2 21 f0 8e 	movb   $0x8e,0xf021a2bd
f0103a41:	c1 e8 10             	shr    $0x10,%eax
f0103a44:	66 a3 be a2 21 f0    	mov    %ax,0xf021a2be
	SETGATE(idt[T_STACK], 0, GD_KT, t_dblflt, 0);
f0103a4a:	66 89 15 c0 a2 21 f0 	mov    %dx,0xf021a2c0
f0103a51:	66 c7 05 c2 a2 21 f0 	movw   $0x8,0xf021a2c2
f0103a58:	08 00 
f0103a5a:	c6 05 c4 a2 21 f0 00 	movb   $0x0,0xf021a2c4
f0103a61:	c6 05 c5 a2 21 f0 8e 	movb   $0x8e,0xf021a2c5
f0103a68:	66 89 0d c6 a2 21 f0 	mov    %cx,0xf021a2c6

	SETGATE(idt[T_GPFLT], 0, GD_KT, t_gpflt, 0);
f0103a6f:	b8 30 41 10 f0       	mov    $0xf0104130,%eax
f0103a74:	66 a3 c8 a2 21 f0    	mov    %ax,0xf021a2c8
f0103a7a:	66 c7 05 ca a2 21 f0 	movw   $0x8,0xf021a2ca
f0103a81:	08 00 
f0103a83:	c6 05 cc a2 21 f0 00 	movb   $0x0,0xf021a2cc
f0103a8a:	c6 05 cd a2 21 f0 8e 	movb   $0x8e,0xf021a2cd
f0103a91:	c1 e8 10             	shr    $0x10,%eax
f0103a94:	66 a3 ce a2 21 f0    	mov    %ax,0xf021a2ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, t_pgflt, 0);
f0103a9a:	b8 34 41 10 f0       	mov    $0xf0104134,%eax
f0103a9f:	66 a3 d0 a2 21 f0    	mov    %ax,0xf021a2d0
f0103aa5:	66 c7 05 d2 a2 21 f0 	movw   $0x8,0xf021a2d2
f0103aac:	08 00 
f0103aae:	c6 05 d4 a2 21 f0 00 	movb   $0x0,0xf021a2d4
f0103ab5:	c6 05 d5 a2 21 f0 8e 	movb   $0x8e,0xf021a2d5
f0103abc:	c1 e8 10             	shr    $0x10,%eax
f0103abf:	66 a3 d6 a2 21 f0    	mov    %ax,0xf021a2d6
	SETGATE(idt[T_FPERR], 0, GD_KT, t_fperr, 0);
f0103ac5:	b8 38 41 10 f0       	mov    $0xf0104138,%eax
f0103aca:	66 a3 e0 a2 21 f0    	mov    %ax,0xf021a2e0
f0103ad0:	66 c7 05 e2 a2 21 f0 	movw   $0x8,0xf021a2e2
f0103ad7:	08 00 
f0103ad9:	c6 05 e4 a2 21 f0 00 	movb   $0x0,0xf021a2e4
f0103ae0:	c6 05 e5 a2 21 f0 8e 	movb   $0x8e,0xf021a2e5
f0103ae7:	c1 e8 10             	shr    $0x10,%eax
f0103aea:	66 a3 e6 a2 21 f0    	mov    %ax,0xf021a2e6

	SETGATE(idt[T_SYSCALL], 0, GD_KT, t_syscall, 3);//Pongo 3 en el ultimo argumento, por que tiene sentido que se las invoque desde procesos de usuario.
f0103af0:	b8 3c 41 10 f0       	mov    $0xf010413c,%eax
f0103af5:	66 a3 e0 a3 21 f0    	mov    %ax,0xf021a3e0
f0103afb:	66 c7 05 e2 a3 21 f0 	movw   $0x8,0xf021a3e2
f0103b02:	08 00 
f0103b04:	c6 05 e4 a3 21 f0 00 	movb   $0x0,0xf021a3e4
f0103b0b:	c6 05 e5 a3 21 f0 ee 	movb   $0xee,0xf021a3e5
f0103b12:	c1 e8 10             	shr    $0x10,%eax
f0103b15:	66 a3 e6 a3 21 f0    	mov    %ax,0xf021a3e6

	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER], 0, GD_KT, t_irqtimer, 0);
f0103b1b:	b8 42 41 10 f0       	mov    $0xf0104142,%eax
f0103b20:	66 a3 60 a3 21 f0    	mov    %ax,0xf021a360
f0103b26:	66 c7 05 62 a3 21 f0 	movw   $0x8,0xf021a362
f0103b2d:	08 00 
f0103b2f:	c6 05 64 a3 21 f0 00 	movb   $0x0,0xf021a364
f0103b36:	c6 05 65 a3 21 f0 8e 	movb   $0x8e,0xf021a365
f0103b3d:	c1 e8 10             	shr    $0x10,%eax
f0103b40:	66 a3 66 a3 21 f0    	mov    %ax,0xf021a366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, t_irqkbd, 0);
f0103b46:	b8 48 41 10 f0       	mov    $0xf0104148,%eax
f0103b4b:	66 a3 68 a3 21 f0    	mov    %ax,0xf021a368
f0103b51:	66 c7 05 6a a3 21 f0 	movw   $0x8,0xf021a36a
f0103b58:	08 00 
f0103b5a:	c6 05 6c a3 21 f0 00 	movb   $0x0,0xf021a36c
f0103b61:	c6 05 6d a3 21 f0 8e 	movb   $0x8e,0xf021a36d
f0103b68:	c1 e8 10             	shr    $0x10,%eax
f0103b6b:	66 a3 6e a3 21 f0    	mov    %ax,0xf021a36e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL], 0, GD_KT, t_irqserial, 0);
f0103b71:	b8 4e 41 10 f0       	mov    $0xf010414e,%eax
f0103b76:	66 a3 80 a3 21 f0    	mov    %ax,0xf021a380
f0103b7c:	66 c7 05 82 a3 21 f0 	movw   $0x8,0xf021a382
f0103b83:	08 00 
f0103b85:	c6 05 84 a3 21 f0 00 	movb   $0x0,0xf021a384
f0103b8c:	c6 05 85 a3 21 f0 8e 	movb   $0x8e,0xf021a385
f0103b93:	c1 e8 10             	shr    $0x10,%eax
f0103b96:	66 a3 86 a3 21 f0    	mov    %ax,0xf021a386


	// Per-CPU setup
	trap_init_percpu();
f0103b9c:	e8 40 fc ff ff       	call   f01037e1 <trap_init_percpu>
}
f0103ba1:	c9                   	leave  
f0103ba2:	c3                   	ret    

f0103ba3 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103ba3:	55                   	push   %ebp
f0103ba4:	89 e5                	mov    %esp,%ebp
f0103ba6:	53                   	push   %ebx
f0103ba7:	83 ec 0c             	sub    $0xc,%esp
f0103baa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103bad:	ff 33                	pushl  (%ebx)
f0103baf:	68 4d 75 10 f0       	push   $0xf010754d
f0103bb4:	e8 a2 fb ff ff       	call   f010375b <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103bb9:	83 c4 08             	add    $0x8,%esp
f0103bbc:	ff 73 04             	pushl  0x4(%ebx)
f0103bbf:	68 5c 75 10 f0       	push   $0xf010755c
f0103bc4:	e8 92 fb ff ff       	call   f010375b <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103bc9:	83 c4 08             	add    $0x8,%esp
f0103bcc:	ff 73 08             	pushl  0x8(%ebx)
f0103bcf:	68 6b 75 10 f0       	push   $0xf010756b
f0103bd4:	e8 82 fb ff ff       	call   f010375b <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103bd9:	83 c4 08             	add    $0x8,%esp
f0103bdc:	ff 73 0c             	pushl  0xc(%ebx)
f0103bdf:	68 7a 75 10 f0       	push   $0xf010757a
f0103be4:	e8 72 fb ff ff       	call   f010375b <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103be9:	83 c4 08             	add    $0x8,%esp
f0103bec:	ff 73 10             	pushl  0x10(%ebx)
f0103bef:	68 89 75 10 f0       	push   $0xf0107589
f0103bf4:	e8 62 fb ff ff       	call   f010375b <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103bf9:	83 c4 08             	add    $0x8,%esp
f0103bfc:	ff 73 14             	pushl  0x14(%ebx)
f0103bff:	68 98 75 10 f0       	push   $0xf0107598
f0103c04:	e8 52 fb ff ff       	call   f010375b <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103c09:	83 c4 08             	add    $0x8,%esp
f0103c0c:	ff 73 18             	pushl  0x18(%ebx)
f0103c0f:	68 a7 75 10 f0       	push   $0xf01075a7
f0103c14:	e8 42 fb ff ff       	call   f010375b <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103c19:	83 c4 08             	add    $0x8,%esp
f0103c1c:	ff 73 1c             	pushl  0x1c(%ebx)
f0103c1f:	68 b6 75 10 f0       	push   $0xf01075b6
f0103c24:	e8 32 fb ff ff       	call   f010375b <cprintf>
}
f0103c29:	83 c4 10             	add    $0x10,%esp
f0103c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103c2f:	c9                   	leave  
f0103c30:	c3                   	ret    

f0103c31 <print_trapframe>:
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
f0103c31:	55                   	push   %ebp
f0103c32:	89 e5                	mov    %esp,%ebp
f0103c34:	56                   	push   %esi
f0103c35:	53                   	push   %ebx
f0103c36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103c39:	e8 8c 1f 00 00       	call   f0105bca <cpunum>
f0103c3e:	83 ec 04             	sub    $0x4,%esp
f0103c41:	50                   	push   %eax
f0103c42:	53                   	push   %ebx
f0103c43:	68 ec 75 10 f0       	push   $0xf01075ec
f0103c48:	e8 0e fb ff ff       	call   f010375b <cprintf>
	print_regs(&tf->tf_regs);
f0103c4d:	89 1c 24             	mov    %ebx,(%esp)
f0103c50:	e8 4e ff ff ff       	call   f0103ba3 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103c55:	83 c4 08             	add    $0x8,%esp
f0103c58:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103c5c:	50                   	push   %eax
f0103c5d:	68 0a 76 10 f0       	push   $0xf010760a
f0103c62:	e8 f4 fa ff ff       	call   f010375b <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103c67:	83 c4 08             	add    $0x8,%esp
f0103c6a:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103c6e:	50                   	push   %eax
f0103c6f:	68 1d 76 10 f0       	push   $0xf010761d
f0103c74:	e8 e2 fa ff ff       	call   f010375b <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103c79:	8b 73 28             	mov    0x28(%ebx),%esi
f0103c7c:	89 f0                	mov    %esi,%eax
f0103c7e:	e8 17 fb ff ff       	call   f010379a <trapname>
f0103c83:	83 c4 0c             	add    $0xc,%esp
f0103c86:	50                   	push   %eax
f0103c87:	56                   	push   %esi
f0103c88:	68 30 76 10 f0       	push   $0xf0107630
f0103c8d:	e8 c9 fa ff ff       	call   f010375b <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103c92:	83 c4 10             	add    $0x10,%esp
f0103c95:	3b 1d 60 aa 21 f0    	cmp    0xf021aa60,%ebx
f0103c9b:	75 1c                	jne    f0103cb9 <print_trapframe+0x88>
f0103c9d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103ca1:	75 16                	jne    f0103cb9 <print_trapframe+0x88>
		cprintf("  cr2  0x%08x\n", rcr2());
f0103ca3:	e8 d7 fa ff ff       	call   f010377f <rcr2>
f0103ca8:	83 ec 08             	sub    $0x8,%esp
f0103cab:	50                   	push   %eax
f0103cac:	68 42 76 10 f0       	push   $0xf0107642
f0103cb1:	e8 a5 fa ff ff       	call   f010375b <cprintf>
f0103cb6:	83 c4 10             	add    $0x10,%esp
	cprintf("  err  0x%08x", tf->tf_err);
f0103cb9:	83 ec 08             	sub    $0x8,%esp
f0103cbc:	ff 73 2c             	pushl  0x2c(%ebx)
f0103cbf:	68 51 76 10 f0       	push   $0xf0107651
f0103cc4:	e8 92 fa ff ff       	call   f010375b <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0103cc9:	83 c4 10             	add    $0x10,%esp
f0103ccc:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103cd0:	75 49                	jne    f0103d1b <print_trapframe+0xea>
		cprintf(" [%s, %s, %s]\n",
		        tf->tf_err & 4 ? "user" : "kernel",
		        tf->tf_err & 2 ? "write" : "read",
		        tf->tf_err & 1 ? "protection" : "not-present");
f0103cd2:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f0103cd5:	89 c2                	mov    %eax,%edx
f0103cd7:	83 e2 01             	and    $0x1,%edx
f0103cda:	ba d0 75 10 f0       	mov    $0xf01075d0,%edx
f0103cdf:	b9 c5 75 10 f0       	mov    $0xf01075c5,%ecx
f0103ce4:	0f 44 ca             	cmove  %edx,%ecx
f0103ce7:	89 c2                	mov    %eax,%edx
f0103ce9:	83 e2 02             	and    $0x2,%edx
f0103cec:	ba e2 75 10 f0       	mov    $0xf01075e2,%edx
f0103cf1:	be dc 75 10 f0       	mov    $0xf01075dc,%esi
f0103cf6:	0f 45 d6             	cmovne %esi,%edx
f0103cf9:	83 e0 04             	and    $0x4,%eax
f0103cfc:	be 13 77 10 f0       	mov    $0xf0107713,%esi
f0103d01:	b8 e7 75 10 f0       	mov    $0xf01075e7,%eax
f0103d06:	0f 44 c6             	cmove  %esi,%eax
f0103d09:	51                   	push   %ecx
f0103d0a:	52                   	push   %edx
f0103d0b:	50                   	push   %eax
f0103d0c:	68 5f 76 10 f0       	push   $0xf010765f
f0103d11:	e8 45 fa ff ff       	call   f010375b <cprintf>
f0103d16:	83 c4 10             	add    $0x10,%esp
f0103d19:	eb 10                	jmp    f0103d2b <print_trapframe+0xfa>
		        tf->tf_err & 4 ? "user" : "kernel",
		        tf->tf_err & 2 ? "write" : "read",
		        tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f0103d1b:	83 ec 0c             	sub    $0xc,%esp
f0103d1e:	68 54 74 10 f0       	push   $0xf0107454
f0103d23:	e8 33 fa ff ff       	call   f010375b <cprintf>
f0103d28:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103d2b:	83 ec 08             	sub    $0x8,%esp
f0103d2e:	ff 73 30             	pushl  0x30(%ebx)
f0103d31:	68 6e 76 10 f0       	push   $0xf010766e
f0103d36:	e8 20 fa ff ff       	call   f010375b <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103d3b:	83 c4 08             	add    $0x8,%esp
f0103d3e:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103d42:	50                   	push   %eax
f0103d43:	68 7d 76 10 f0       	push   $0xf010767d
f0103d48:	e8 0e fa ff ff       	call   f010375b <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103d4d:	83 c4 08             	add    $0x8,%esp
f0103d50:	ff 73 38             	pushl  0x38(%ebx)
f0103d53:	68 90 76 10 f0       	push   $0xf0107690
f0103d58:	e8 fe f9 ff ff       	call   f010375b <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0103d5d:	83 c4 10             	add    $0x10,%esp
f0103d60:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103d64:	74 25                	je     f0103d8b <print_trapframe+0x15a>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103d66:	83 ec 08             	sub    $0x8,%esp
f0103d69:	ff 73 3c             	pushl  0x3c(%ebx)
f0103d6c:	68 9f 76 10 f0       	push   $0xf010769f
f0103d71:	e8 e5 f9 ff ff       	call   f010375b <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103d76:	83 c4 08             	add    $0x8,%esp
f0103d79:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103d7d:	50                   	push   %eax
f0103d7e:	68 ae 76 10 f0       	push   $0xf01076ae
f0103d83:	e8 d3 f9 ff ff       	call   f010375b <cprintf>
f0103d88:	83 c4 10             	add    $0x10,%esp
	}
}
f0103d8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103d8e:	5b                   	pop    %ebx
f0103d8f:	5e                   	pop    %esi
f0103d90:	5d                   	pop    %ebp
f0103d91:	c3                   	ret    

f0103d92 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0103d92:	55                   	push   %ebp
f0103d93:	89 e5                	mov    %esp,%ebp
f0103d95:	57                   	push   %edi
f0103d96:	56                   	push   %esi
f0103d97:	53                   	push   %ebx
f0103d98:	83 ec 1c             	sub    $0x1c,%esp
f0103d9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();
f0103d9e:	e8 dc f9 ff ff       	call   f010377f <rcr2>

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	//Chequeo si estan seteados los bits mas bajos de tf_cs
	if (!(tf->tf_cs & 1))
f0103da3:	f6 43 34 01          	testb  $0x1,0x34(%ebx)
f0103da7:	75 17                	jne    f0103dc0 <page_fault_handler+0x2e>
		panic ("Kernel-mode page fault");
f0103da9:	83 ec 04             	sub    $0x4,%esp
f0103dac:	68 c1 76 10 f0       	push   $0xf01076c1
f0103db1:	68 67 01 00 00       	push   $0x167
f0103db6:	68 d8 76 10 f0       	push   $0xf01076d8
f0103dbb:	e8 b2 c2 ff ff       	call   f0100072 <_panic>
f0103dc0:	89 c6                	mov    %eax,%esi
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if (curenv->env_pgfault_upcall) {
f0103dc2:	e8 03 1e 00 00       	call   f0105bca <cpunum>
f0103dc7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dca:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0103dd0:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0103dd4:	0f 84 91 00 00 00    	je     f0103e6b <page_fault_handler+0xd9>
		struct UTrapframe* utf;
		size_t utf_size = sizeof(struct UTrapframe); 
		uintptr_t utf_addr_ptr;

		if ((tf->tf_esp < UXSTACKTOP) && (tf->tf_esp >= UXSTACKTOP-PGSIZE)){
f0103dda:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103ddd:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			//La consigna del MIT sugiere primero pushear una palabra vacia (por eso le resto un sizeof(uint32_t))
			utf_addr_ptr = tf->tf_esp - sizeof(uint32_t);
f0103de3:	83 e8 04             	sub    $0x4,%eax
f0103de6:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f0103dec:	bf 00 00 c0 ee       	mov    $0xeec00000,%edi
f0103df1:	0f 46 f8             	cmovbe %eax,%edi
		}
		else 
			utf_addr_ptr = UXSTACKTOP;
		utf_addr_ptr -= utf_size;
f0103df4:	8d 47 cc             	lea    -0x34(%edi),%eax
f0103df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		user_mem_assert(curenv, (void*)utf_addr_ptr, utf_size, PTE_W);
f0103dfa:	e8 cb 1d 00 00       	call   f0105bca <cpunum>
f0103dff:	6a 02                	push   $0x2
f0103e01:	6a 34                	push   $0x34
f0103e03:	ff 75 e4             	pushl  -0x1c(%ebp)
f0103e06:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e09:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f0103e0f:	e8 1c ef ff ff       	call   f0102d30 <user_mem_assert>
		utf = (struct UTrapframe *) utf_addr_ptr;

		utf->utf_fault_va = fault_va;
f0103e14:	89 77 cc             	mov    %esi,-0x34(%edi)
		utf->utf_err = tf->tf_err;
f0103e17:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0103e1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103e1d:	89 42 04             	mov    %eax,0x4(%edx)
		utf->utf_regs = tf->tf_regs;
f0103e20:	83 ef 2c             	sub    $0x2c,%edi
f0103e23:	b9 08 00 00 00       	mov    $0x8,%ecx
f0103e28:	89 de                	mov    %ebx,%esi
f0103e2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0103e2c:	8b 43 30             	mov    0x30(%ebx),%eax
f0103e2f:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0103e32:	8b 43 38             	mov    0x38(%ebx),%eax
f0103e35:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f0103e38:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103e3b:	89 42 30             	mov    %eax,0x30(%edx)
		tf->tf_esp = utf_addr_ptr;
f0103e3e:	89 53 3c             	mov    %edx,0x3c(%ebx)
		tf->tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0103e41:	e8 84 1d 00 00       	call   f0105bca <cpunum>
f0103e46:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e49:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0103e4f:	8b 40 64             	mov    0x64(%eax),%eax
f0103e52:	89 43 30             	mov    %eax,0x30(%ebx)
		env_run(curenv);
f0103e55:	e8 70 1d 00 00       	call   f0105bca <cpunum>
f0103e5a:	83 c4 04             	add    $0x4,%esp
f0103e5d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e60:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f0103e66:	e8 3c f6 ff ff       	call   f01034a7 <env_run>
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103e6b:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, 
f0103e6e:	e8 57 1d 00 00       	call   f0105bca <cpunum>
		tf->tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103e73:	57                   	push   %edi
f0103e74:	56                   	push   %esi
		curenv->env_id, 
f0103e75:	6b c0 74             	imul   $0x74,%eax,%eax
		tf->tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103e78:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0103e7e:	ff 70 48             	pushl  0x48(%eax)
f0103e81:	68 80 78 10 f0       	push   $0xf0107880
f0103e86:	e8 d0 f8 ff ff       	call   f010375b <cprintf>
		curenv->env_id, 
		fault_va, 
		tf->tf_eip);
	print_trapframe(tf);
f0103e8b:	89 1c 24             	mov    %ebx,(%esp)
f0103e8e:	e8 9e fd ff ff       	call   f0103c31 <print_trapframe>
	env_destroy(curenv);
f0103e93:	e8 32 1d 00 00       	call   f0105bca <cpunum>
f0103e98:	83 c4 04             	add    $0x4,%esp
f0103e9b:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e9e:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f0103ea4:	e8 5f f5 ff ff       	call   f0103408 <env_destroy>
}
f0103ea9:	83 c4 10             	add    $0x10,%esp
f0103eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103eaf:	5b                   	pop    %ebx
f0103eb0:	5e                   	pop    %esi
f0103eb1:	5f                   	pop    %edi
f0103eb2:	5d                   	pop    %ebp
f0103eb3:	c3                   	ret    

f0103eb4 <trap_dispatch>:
	cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
f0103eb4:	55                   	push   %ebp
f0103eb5:	89 e5                	mov    %esp,%ebp
f0103eb7:	53                   	push   %ebx
f0103eb8:	83 ec 04             	sub    $0x4,%esp
f0103ebb:	89 c3                	mov    %eax,%ebx
	// Handle processor exceptions.
	// LAB 3: Your code here.
//<<<<<<< HEAD
	if (tf->tf_trapno == T_BRKPT){
f0103ebd:	8b 40 28             	mov    0x28(%eax),%eax
f0103ec0:	83 f8 03             	cmp    $0x3,%eax
f0103ec3:	75 11                	jne    f0103ed6 <trap_dispatch+0x22>
		monitor(tf);
f0103ec5:	83 ec 0c             	sub    $0xc,%esp
f0103ec8:	53                   	push   %ebx
f0103ec9:	e8 93 cc ff ff       	call   f0100b61 <monitor>
		return;
f0103ece:	83 c4 10             	add    $0x10,%esp
f0103ed1:	e9 c8 00 00 00       	jmp    f0103f9e <trap_dispatch+0xea>
	}
	if (tf->tf_trapno == T_PGFLT){
f0103ed6:	83 f8 0e             	cmp    $0xe,%eax
f0103ed9:	75 11                	jne    f0103eec <trap_dispatch+0x38>
		page_fault_handler(tf);
f0103edb:	83 ec 0c             	sub    $0xc,%esp
f0103ede:	53                   	push   %ebx
f0103edf:	e8 ae fe ff ff       	call   f0103d92 <page_fault_handler>
		return;
f0103ee4:	83 c4 10             	add    $0x10,%esp
f0103ee7:	e9 b2 00 00 00       	jmp    f0103f9e <trap_dispatch+0xea>
	}
		
	if (tf->tf_trapno == T_SYSCALL){
f0103eec:	83 f8 30             	cmp    $0x30,%eax
f0103eef:	75 24                	jne    f0103f15 <trap_dispatch+0x61>
		int32_t ret_val = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
f0103ef1:	83 ec 08             	sub    $0x8,%esp
f0103ef4:	ff 73 04             	pushl  0x4(%ebx)
f0103ef7:	ff 33                	pushl  (%ebx)
f0103ef9:	ff 73 10             	pushl  0x10(%ebx)
f0103efc:	ff 73 18             	pushl  0x18(%ebx)
f0103eff:	ff 73 14             	pushl  0x14(%ebx)
f0103f02:	ff 73 1c             	pushl  0x1c(%ebx)
f0103f05:	e8 cc 09 00 00       	call   f01048d6 <syscall>
					  tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);
		tf->tf_regs.reg_eax = ret_val; // Guardo el resultado en eax (es por convencion, como ya vimos en el tp de x86)
f0103f0a:	89 43 1c             	mov    %eax,0x1c(%ebx)
		return;
f0103f0d:	83 c4 20             	add    $0x20,%esp
f0103f10:	e9 89 00 00 00       	jmp    f0103f9e <trap_dispatch+0xea>
//=======

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0103f15:	83 f8 27             	cmp    $0x27,%eax
f0103f18:	75 1a                	jne    f0103f34 <trap_dispatch+0x80>
		cprintf("Spurious interrupt on irq 7\n");
f0103f1a:	83 ec 0c             	sub    $0xc,%esp
f0103f1d:	68 e4 76 10 f0       	push   $0xf01076e4
f0103f22:	e8 34 f8 ff ff       	call   f010375b <cprintf>
		print_trapframe(tf);
f0103f27:	89 1c 24             	mov    %ebx,(%esp)
f0103f2a:	e8 02 fd ff ff       	call   f0103c31 <print_trapframe>
		return;
f0103f2f:	83 c4 10             	add    $0x10,%esp
f0103f32:	eb 6a                	jmp    f0103f9e <trap_dispatch+0xea>
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET+IRQ_TIMER) {
f0103f34:	83 f8 20             	cmp    $0x20,%eax
f0103f37:	75 0a                	jne    f0103f43 <trap_dispatch+0x8f>
		lapic_eoi();
f0103f39:	e8 d7 1d 00 00       	call   f0105d15 <lapic_eoi>
		sched_yield();
f0103f3e:	e8 28 03 00 00       	call   f010426b <sched_yield>
		return;
}

	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET+IRQ_KBD) {
f0103f43:	83 f8 21             	cmp    $0x21,%eax
f0103f46:	75 07                	jne    f0103f4f <trap_dispatch+0x9b>
		kbd_intr();
f0103f48:	e8 25 c9 ff ff       	call   f0100872 <kbd_intr>
		return;
f0103f4d:	eb 4f                	jmp    f0103f9e <trap_dispatch+0xea>
	}
	if (tf->tf_trapno == IRQ_OFFSET+IRQ_SERIAL) {
f0103f4f:	83 f8 24             	cmp    $0x24,%eax
f0103f52:	75 07                	jne    f0103f5b <trap_dispatch+0xa7>
		serial_intr();
f0103f54:	e8 fd c8 ff ff       	call   f0100856 <serial_intr>
		return;
f0103f59:	eb 43                	jmp    f0103f9e <trap_dispatch+0xea>
	}
	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0103f5b:	83 ec 0c             	sub    $0xc,%esp
f0103f5e:	53                   	push   %ebx
f0103f5f:	e8 cd fc ff ff       	call   f0103c31 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0103f64:	83 c4 10             	add    $0x10,%esp
f0103f67:	66 83 7b 34 08       	cmpw   $0x8,0x34(%ebx)
f0103f6c:	75 17                	jne    f0103f85 <trap_dispatch+0xd1>
		panic("unhandled trap in kernel");
f0103f6e:	83 ec 04             	sub    $0x4,%esp
f0103f71:	68 01 77 10 f0       	push   $0xf0107701
f0103f76:	68 16 01 00 00       	push   $0x116
f0103f7b:	68 d8 76 10 f0       	push   $0xf01076d8
f0103f80:	e8 ed c0 ff ff       	call   f0100072 <_panic>
	else {
		env_destroy(curenv);
f0103f85:	e8 40 1c 00 00       	call   f0105bca <cpunum>
f0103f8a:	83 ec 0c             	sub    $0xc,%esp
f0103f8d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f90:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f0103f96:	e8 6d f4 ff ff       	call   f0103408 <env_destroy>
		return;
f0103f9b:	83 c4 10             	add    $0x10,%esp
	}
}
f0103f9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103fa1:	c9                   	leave  
f0103fa2:	c3                   	ret    

f0103fa3 <trap>:

void
trap(struct Trapframe *tf)
{
f0103fa3:	55                   	push   %ebp
f0103fa4:	89 e5                	mov    %esp,%ebp
f0103fa6:	57                   	push   %edi
f0103fa7:	56                   	push   %esi
f0103fa8:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f0103fab:	fc                   	cld    

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f0103fac:	83 3d 80 ae 21 f0 00 	cmpl   $0x0,0xf021ae80
f0103fb3:	74 01                	je     f0103fb6 <trap+0x13>
		asm volatile("hlt");
f0103fb5:	f4                   	hlt    

	// Re-acquire the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0103fb6:	e8 0f 1c 00 00       	call   f0105bca <cpunum>
f0103fbb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103fbe:	05 24 b0 21 f0       	add    $0xf021b024,%eax
f0103fc3:	ba 01 00 00 00       	mov    $0x1,%edx
f0103fc8:	e8 c1 f7 ff ff       	call   f010378e <xchg>
f0103fcd:	83 f8 02             	cmp    $0x2,%eax
f0103fd0:	75 05                	jne    f0103fd7 <trap+0x34>
		lock_kernel();
f0103fd2:	e8 f5 f7 ff ff       	call   f01037cc <lock_kernel>
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0103fd7:	e8 ab f7 ff ff       	call   f0103787 <read_eflags>
f0103fdc:	f6 c4 02             	test   $0x2,%ah
f0103fdf:	74 19                	je     f0103ffa <trap+0x57>
f0103fe1:	68 1a 77 10 f0       	push   $0xf010771a
f0103fe6:	68 9b 71 10 f0       	push   $0xf010719b
f0103feb:	68 30 01 00 00       	push   $0x130
f0103ff0:	68 d8 76 10 f0       	push   $0xf01076d8
f0103ff5:	e8 78 c0 ff ff       	call   f0100072 <_panic>

	if ((tf->tf_cs & 3) == 3) {
f0103ffa:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0103ffe:	83 e0 03             	and    $0x3,%eax
f0104001:	66 83 f8 03          	cmp    $0x3,%ax
f0104005:	0f 85 95 00 00 00    	jne    f01040a0 <trap+0xfd>
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		lock_kernel();
f010400b:	e8 bc f7 ff ff       	call   f01037cc <lock_kernel>
		assert(curenv);
f0104010:	e8 b5 1b 00 00       	call   f0105bca <cpunum>
f0104015:	6b c0 74             	imul   $0x74,%eax,%eax
f0104018:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f010401f:	75 19                	jne    f010403a <trap+0x97>
f0104021:	68 33 77 10 f0       	push   $0xf0107733
f0104026:	68 9b 71 10 f0       	push   $0xf010719b
f010402b:	68 38 01 00 00       	push   $0x138
f0104030:	68 d8 76 10 f0       	push   $0xf01076d8
f0104035:	e8 38 c0 ff ff       	call   f0100072 <_panic>

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f010403a:	e8 8b 1b 00 00       	call   f0105bca <cpunum>
f010403f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104042:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0104048:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010404c:	75 2d                	jne    f010407b <trap+0xd8>
			env_free(curenv);
f010404e:	e8 77 1b 00 00       	call   f0105bca <cpunum>
f0104053:	83 ec 0c             	sub    $0xc,%esp
f0104056:	6b c0 74             	imul   $0x74,%eax,%eax
f0104059:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f010405f:	e8 4b f2 ff ff       	call   f01032af <env_free>
			curenv = NULL;
f0104064:	e8 61 1b 00 00       	call   f0105bca <cpunum>
f0104069:	6b c0 74             	imul   $0x74,%eax,%eax
f010406c:	c7 80 28 b0 21 f0 00 	movl   $0x0,-0xfde4fd8(%eax)
f0104073:	00 00 00 
			sched_yield();
f0104076:	e8 f0 01 00 00       	call   f010426b <sched_yield>
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f010407b:	e8 4a 1b 00 00       	call   f0105bca <cpunum>
f0104080:	6b c0 74             	imul   $0x74,%eax,%eax
f0104083:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0104089:	b9 11 00 00 00       	mov    $0x11,%ecx
f010408e:	89 c7                	mov    %eax,%edi
f0104090:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0104092:	e8 33 1b 00 00       	call   f0105bca <cpunum>
f0104097:	6b c0 74             	imul   $0x74,%eax,%eax
f010409a:	8b b0 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f01040a0:	89 35 60 aa 21 f0    	mov    %esi,0xf021aa60

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
f01040a6:	89 f0                	mov    %esi,%eax
f01040a8:	e8 07 fe ff ff       	call   f0103eb4 <trap_dispatch>

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense
	if (curenv && curenv->env_status == ENV_RUNNING)
f01040ad:	e8 18 1b 00 00       	call   f0105bca <cpunum>
f01040b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01040b5:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f01040bc:	74 2a                	je     f01040e8 <trap+0x145>
f01040be:	e8 07 1b 00 00       	call   f0105bca <cpunum>
f01040c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01040c6:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01040cc:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01040d0:	75 16                	jne    f01040e8 <trap+0x145>
		env_run(curenv);
f01040d2:	e8 f3 1a 00 00       	call   f0105bca <cpunum>
f01040d7:	83 ec 0c             	sub    $0xc,%esp
f01040da:	6b c0 74             	imul   $0x74,%eax,%eax
f01040dd:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f01040e3:	e8 bf f3 ff ff       	call   f01034a7 <env_run>
	else
		sched_yield();
f01040e8:	e8 7e 01 00 00       	call   f010426b <sched_yield>
f01040ed:	90                   	nop

f01040ee <t_divide>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	
	TRAPHANDLER_NOEC(t_divide,T_DIVIDE)
f01040ee:	6a 00                	push   $0x0
f01040f0:	6a 00                	push   $0x0
f01040f2:	eb 60                	jmp    f0104154 <_alltraps>

f01040f4 <t_debug>:
	TRAPHANDLER_NOEC(t_debug,T_DEBUG)
f01040f4:	6a 00                	push   $0x0
f01040f6:	6a 01                	push   $0x1
f01040f8:	eb 5a                	jmp    f0104154 <_alltraps>

f01040fa <t_nmi>:
	TRAPHANDLER_NOEC(t_nmi,T_NMI)
f01040fa:	6a 00                	push   $0x0
f01040fc:	6a 02                	push   $0x2
f01040fe:	eb 54                	jmp    f0104154 <_alltraps>

f0104100 <t_brkpt>:
	TRAPHANDLER_NOEC(t_brkpt,T_BRKPT)
f0104100:	6a 00                	push   $0x0
f0104102:	6a 03                	push   $0x3
f0104104:	eb 4e                	jmp    f0104154 <_alltraps>

f0104106 <t_oflow>:
	TRAPHANDLER_NOEC(t_oflow,T_OFLOW)
f0104106:	6a 00                	push   $0x0
f0104108:	6a 04                	push   $0x4
f010410a:	eb 48                	jmp    f0104154 <_alltraps>

f010410c <t_bound>:
	TRAPHANDLER_NOEC(t_bound,T_BOUND)
f010410c:	6a 00                	push   $0x0
f010410e:	6a 05                	push   $0x5
f0104110:	eb 42                	jmp    f0104154 <_alltraps>

f0104112 <t_illop>:
	TRAPHANDLER_NOEC(t_illop,T_ILLOP)
f0104112:	6a 00                	push   $0x0
f0104114:	6a 06                	push   $0x6
f0104116:	eb 3c                	jmp    f0104154 <_alltraps>

f0104118 <t_device>:
	TRAPHANDLER_NOEC(t_device,T_DEVICE)
f0104118:	6a 00                	push   $0x0
f010411a:	6a 07                	push   $0x7
f010411c:	eb 36                	jmp    f0104154 <_alltraps>

f010411e <t_dblflt>:
	TRAPHANDLER(t_dblflt,T_DBLFLT)
f010411e:	6a 08                	push   $0x8
f0104120:	eb 32                	jmp    f0104154 <_alltraps>

f0104122 <t_tss>:
	TRAPHANDLER_NOEC(t_tss,T_TSS)
f0104122:	6a 00                	push   $0x0
f0104124:	6a 0a                	push   $0xa
f0104126:	eb 2c                	jmp    f0104154 <_alltraps>

f0104128 <t_segnp>:
	TRAPHANDLER(t_segnp,T_SEGNP)
f0104128:	6a 0b                	push   $0xb
f010412a:	eb 28                	jmp    f0104154 <_alltraps>

f010412c <t_stack>:
	TRAPHANDLER(t_stack,T_STACK)
f010412c:	6a 0c                	push   $0xc
f010412e:	eb 24                	jmp    f0104154 <_alltraps>

f0104130 <t_gpflt>:
	TRAPHANDLER(t_gpflt,T_GPFLT)
f0104130:	6a 0d                	push   $0xd
f0104132:	eb 20                	jmp    f0104154 <_alltraps>

f0104134 <t_pgflt>:
	TRAPHANDLER(t_pgflt,T_PGFLT)
f0104134:	6a 0e                	push   $0xe
f0104136:	eb 1c                	jmp    f0104154 <_alltraps>

f0104138 <t_fperr>:
	TRAPHANDLER(t_fperr,T_FPERR)
f0104138:	6a 10                	push   $0x10
f010413a:	eb 18                	jmp    f0104154 <_alltraps>

f010413c <t_syscall>:
	//Para la parte de kern_syscalls
	TRAPHANDLER_NOEC(t_syscall,T_SYSCALL)
f010413c:	6a 00                	push   $0x0
f010413e:	6a 30                	push   $0x30
f0104140:	eb 12                	jmp    f0104154 <_alltraps>

f0104142 <t_irqtimer>:

	TRAPHANDLER_NOEC(t_irqtimer,IRQ_OFFSET+IRQ_TIMER)
f0104142:	6a 00                	push   $0x0
f0104144:	6a 20                	push   $0x20
f0104146:	eb 0c                	jmp    f0104154 <_alltraps>

f0104148 <t_irqkbd>:
	TRAPHANDLER_NOEC(t_irqkbd, IRQ_OFFSET + IRQ_KBD)
f0104148:	6a 00                	push   $0x0
f010414a:	6a 21                	push   $0x21
f010414c:	eb 06                	jmp    f0104154 <_alltraps>

f010414e <t_irqserial>:
	TRAPHANDLER_NOEC(t_irqserial, IRQ_OFFSET + IRQ_SERIAL)
f010414e:	6a 00                	push   $0x0
f0104150:	6a 24                	push   $0x24
f0104152:	eb 00                	jmp    f0104154 <_alltraps>

f0104154 <_alltraps>:
/*
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
	pushl %ds
f0104154:	1e                   	push   %ds
	pushl %es
f0104155:	06                   	push   %es
	pushal
f0104156:	60                   	pusha  
	pushl $GD_KD
f0104157:	6a 10                	push   $0x10
	popl %ds
f0104159:	1f                   	pop    %ds
	pushl $GD_KD
f010415a:	6a 10                	push   $0x10
	popl %es
f010415c:	07                   	pop    %es
	pushl %esp
f010415d:	54                   	push   %esp
	call trap
f010415e:	e8 40 fe ff ff       	call   f0103fa3 <trap>

f0104163 <lcr3>:
	return val;
}

static inline void
lcr3(uint32_t val)
{
f0104163:	55                   	push   %ebp
f0104164:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104166:	0f 22 d8             	mov    %eax,%cr3
}
f0104169:	5d                   	pop    %ebp
f010416a:	c3                   	ret    

f010416b <xchg>:
	return tsc;
}

static inline uint32_t
xchg(volatile uint32_t *addr, uint32_t newval)
{
f010416b:	55                   	push   %ebp
f010416c:	89 e5                	mov    %esp,%ebp
f010416e:	89 c1                	mov    %eax,%ecx
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0104170:	89 d0                	mov    %edx,%eax
f0104172:	f0 87 01             	lock xchg %eax,(%ecx)
		     : "+m" (*addr), "=a" (result)
		     : "1" (newval)
		     : "cc");
	return result;
}
f0104175:	5d                   	pop    %ebp
f0104176:	c3                   	ret    

f0104177 <_paddr>:
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0104177:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f010417d:	77 13                	ja     f0104192 <_paddr+0x1b>
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
f010417f:	55                   	push   %ebp
f0104180:	89 e5                	mov    %esp,%ebp
f0104182:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104185:	51                   	push   %ecx
f0104186:	68 d0 62 10 f0       	push   $0xf01062d0
f010418b:	52                   	push   %edx
f010418c:	50                   	push   %eax
f010418d:	e8 e0 be ff ff       	call   f0100072 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104192:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
}
f0104198:	c3                   	ret    

f0104199 <unlock_kernel>:

static inline void
unlock_kernel(void)
{
f0104199:	55                   	push   %ebp
f010419a:	89 e5                	mov    %esp,%ebp
f010419c:	83 ec 14             	sub    $0x14,%esp
	spin_unlock(&kernel_lock);
f010419f:	68 c0 13 12 f0       	push   $0xf01213c0
f01041a4:	e8 59 1d 00 00       	call   f0105f02 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01041a9:	f3 90                	pause  
}
f01041ab:	83 c4 10             	add    $0x10,%esp
f01041ae:	c9                   	leave  
f01041af:	c3                   	ret    

f01041b0 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01041b0:	55                   	push   %ebp
f01041b1:	89 e5                	mov    %esp,%ebp
f01041b3:	83 ec 08             	sub    $0x8,%esp
f01041b6:	a1 48 a2 21 f0       	mov    0xf021a248,%eax
f01041bb:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01041be:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01041c3:	8b 02                	mov    (%edx),%eax
f01041c5:	83 e8 01             	sub    $0x1,%eax
f01041c8:	83 f8 02             	cmp    $0x2,%eax
f01041cb:	76 10                	jbe    f01041dd <sched_halt+0x2d>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01041cd:	83 c1 01             	add    $0x1,%ecx
f01041d0:	83 c2 7c             	add    $0x7c,%edx
f01041d3:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01041d9:	75 e8                	jne    f01041c3 <sched_halt+0x13>
f01041db:	eb 08                	jmp    f01041e5 <sched_halt+0x35>
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
f01041dd:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01041e3:	75 1f                	jne    f0104204 <sched_halt+0x54>
		cprintf("No runnable environments in the system!\n");
f01041e5:	83 ec 0c             	sub    $0xc,%esp
f01041e8:	68 10 79 10 f0       	push   $0xf0107910
f01041ed:	e8 69 f5 ff ff       	call   f010375b <cprintf>
f01041f2:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01041f5:	83 ec 0c             	sub    $0xc,%esp
f01041f8:	6a 00                	push   $0x0
f01041fa:	e8 62 c9 ff ff       	call   f0100b61 <monitor>
f01041ff:	83 c4 10             	add    $0x10,%esp
f0104202:	eb f1                	jmp    f01041f5 <sched_halt+0x45>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104204:	e8 c1 19 00 00       	call   f0105bca <cpunum>
f0104209:	6b c0 74             	imul   $0x74,%eax,%eax
f010420c:	c7 80 28 b0 21 f0 00 	movl   $0x0,-0xfde4fd8(%eax)
f0104213:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104216:	8b 0d 8c ae 21 f0    	mov    0xf021ae8c,%ecx
f010421c:	ba 52 00 00 00       	mov    $0x52,%edx
f0104221:	b8 39 79 10 f0       	mov    $0xf0107939,%eax
f0104226:	e8 4c ff ff ff       	call   f0104177 <_paddr>
f010422b:	e8 33 ff ff ff       	call   f0104163 <lcr3>

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104230:	e8 95 19 00 00       	call   f0105bca <cpunum>
f0104235:	6b c0 74             	imul   $0x74,%eax,%eax
f0104238:	05 24 b0 21 f0       	add    $0xf021b024,%eax
f010423d:	ba 02 00 00 00       	mov    $0x2,%edx
f0104242:	e8 24 ff ff ff       	call   f010416b <xchg>

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();
f0104247:	e8 4d ff ff ff       	call   f0104199 <unlock_kernel>
	             "sti\n"
	             "1:\n"
	             "hlt\n"
	             "jmp 1b\n"
	             :
	             : "a"(thiscpu->cpu_ts.ts_esp0));
f010424c:	e8 79 19 00 00       	call   f0105bca <cpunum>
f0104251:	6b c0 74             	imul   $0x74,%eax,%eax

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile("movl $0, %%ebp\n"
f0104254:	8b 80 30 b0 21 f0    	mov    -0xfde4fd0(%eax),%eax
f010425a:	bd 00 00 00 00       	mov    $0x0,%ebp
f010425f:	89 c4                	mov    %eax,%esp
f0104261:	6a 00                	push   $0x0
f0104263:	6a 00                	push   $0x0
f0104265:	fb                   	sti    
f0104266:	f4                   	hlt    
f0104267:	eb fd                	jmp    f0104266 <sched_halt+0xb6>
	             "1:\n"
	             "hlt\n"
	             "jmp 1b\n"
	             :
	             : "a"(thiscpu->cpu_ts.ts_esp0));
}
f0104269:	c9                   	leave  
f010426a:	c3                   	ret    

f010426b <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f010426b:	55                   	push   %ebp
f010426c:	89 e5                	mov    %esp,%ebp
f010426e:	56                   	push   %esi
f010426f:	53                   	push   %ebx
	// LAB 4: Your code here.	
	
	struct Env *e;
	int currentPos;	

	if (curenv){
f0104270:	e8 55 19 00 00       	call   f0105bca <cpunum>
f0104275:	6b c0 74             	imul   $0x74,%eax,%eax
		currentPos = ENVX(curenv->env_id);
	}else{
		currentPos = 0;
f0104278:	b9 00 00 00 00       	mov    $0x0,%ecx
	// LAB 4: Your code here.	
	
	struct Env *e;
	int currentPos;	

	if (curenv){
f010427d:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f0104284:	74 17                	je     f010429d <sched_yield+0x32>
		currentPos = ENVX(curenv->env_id);
f0104286:	e8 3f 19 00 00       	call   f0105bca <cpunum>
f010428b:	6b c0 74             	imul   $0x74,%eax,%eax
f010428e:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0104294:	8b 48 48             	mov    0x48(%eax),%ecx
f0104297:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
	} 
	for (int i = 0; i < NENV; ++i) {

		//env pos en la tabla de envirometns
		int newEnvPos = (currentPos+i) %NENV;		
		if (envs[newEnvPos].env_status == ENV_RUNNABLE) {			
f010429d:	8b 1d 48 a2 21 f0    	mov    0xf021a248,%ebx
f01042a3:	89 ca                	mov    %ecx,%edx
f01042a5:	81 c1 00 04 00 00    	add    $0x400,%ecx
f01042ab:	89 d6                	mov    %edx,%esi
f01042ad:	c1 fe 1f             	sar    $0x1f,%esi
f01042b0:	c1 ee 16             	shr    $0x16,%esi
f01042b3:	8d 04 32             	lea    (%edx,%esi,1),%eax
f01042b6:	25 ff 03 00 00       	and    $0x3ff,%eax
f01042bb:	29 f0                	sub    %esi,%eax
f01042bd:	6b c0 7c             	imul   $0x7c,%eax,%eax
f01042c0:	01 d8                	add    %ebx,%eax
f01042c2:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01042c6:	75 09                	jne    f01042d1 <sched_yield+0x66>
			env_run(envs+newEnvPos);
f01042c8:	83 ec 0c             	sub    $0xc,%esp
f01042cb:	50                   	push   %eax
f01042cc:	e8 d6 f1 ff ff       	call   f01034a7 <env_run>
f01042d1:	83 c2 01             	add    $0x1,%edx
	if (curenv){
		currentPos = ENVX(curenv->env_id);
	}else{
		currentPos = 0;
	} 
	for (int i = 0; i < NENV; ++i) {
f01042d4:	39 ca                	cmp    %ecx,%edx
f01042d6:	75 d3                	jne    f01042ab <sched_yield+0x40>
		int newEnvPos = (currentPos+i) %NENV;		
		if (envs[newEnvPos].env_status == ENV_RUNNABLE) {			
			env_run(envs+newEnvPos);
		}
	}
	if (curenv && curenv->env_status == ENV_RUNNING)
f01042d8:	e8 ed 18 00 00       	call   f0105bca <cpunum>
f01042dd:	6b c0 74             	imul   $0x74,%eax,%eax
f01042e0:	83 b8 28 b0 21 f0 00 	cmpl   $0x0,-0xfde4fd8(%eax)
f01042e7:	74 2a                	je     f0104313 <sched_yield+0xa8>
f01042e9:	e8 dc 18 00 00       	call   f0105bca <cpunum>
f01042ee:	6b c0 74             	imul   $0x74,%eax,%eax
f01042f1:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01042f7:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01042fb:	75 16                	jne    f0104313 <sched_yield+0xa8>
		env_run(curenv);
f01042fd:	e8 c8 18 00 00       	call   f0105bca <cpunum>
f0104302:	83 ec 0c             	sub    $0xc,%esp
f0104305:	6b c0 74             	imul   $0x74,%eax,%eax
f0104308:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f010430e:	e8 94 f1 ff ff       	call   f01034a7 <env_run>

	// sched_halt never returns
	sched_halt();
f0104313:	e8 98 fe ff ff       	call   f01041b0 <sched_halt>
	
	
}
f0104318:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010431b:	5b                   	pop    %ebx
f010431c:	5e                   	pop    %esi
f010431d:	5d                   	pop    %ebp
f010431e:	c3                   	ret    

f010431f <sys_env_set_status>:
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE){
f010431f:	8d 4a fe             	lea    -0x2(%edx),%ecx
f0104322:	f7 c1 fd ff ff ff    	test   $0xfffffffd,%ecx
f0104328:	75 2a                	jne    f0104354 <sys_env_set_status+0x35>
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
f010432a:	55                   	push   %ebp
f010432b:	89 e5                	mov    %esp,%ebp
f010432d:	53                   	push   %ebx
f010432e:	83 ec 18             	sub    $0x18,%esp
f0104331:	89 d3                	mov    %edx,%ebx
	// LAB 4: Your code here.
	if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE){
		return -E_INVAL;
	}
	struct Env *env; 
	int result = envid2env(envid, &env, 1);
f0104333:	6a 01                	push   $0x1
f0104335:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104338:	52                   	push   %edx
f0104339:	50                   	push   %eax
f010433a:	e8 06 ed ff ff       	call   f0103045 <envid2env>
	if (result == -E_BAD_ENV){
f010433f:	83 c4 10             	add    $0x10,%esp
f0104342:	83 f8 fe             	cmp    $0xfffffffe,%eax
f0104345:	74 13                	je     f010435a <sys_env_set_status+0x3b>
		return result;
	} 	
	env->env_status = status;
f0104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010434a:	89 58 54             	mov    %ebx,0x54(%eax)
	return 0;
f010434d:	b8 00 00 00 00       	mov    $0x0,%eax
f0104352:	eb 0b                	jmp    f010435f <sys_env_set_status+0x40>
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	if (status != ENV_NOT_RUNNABLE && status != ENV_RUNNABLE){
		return -E_INVAL;
f0104354:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return result;
	} 	
	env->env_status = status;
	return 0;
	
}
f0104359:	c3                   	ret    
		return -E_INVAL;
	}
	struct Env *env; 
	int result = envid2env(envid, &env, 1);
	if (result == -E_BAD_ENV){
		return result;
f010435a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	} 	
	env->env_status = status;
	return 0;
	
}
f010435f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104362:	c9                   	leave  
f0104363:	c3                   	ret    

f0104364 <sys_env_set_pgfault_upcall>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
f0104364:	55                   	push   %ebp
f0104365:	89 e5                	mov    %esp,%ebp
f0104367:	53                   	push   %ebx
f0104368:	83 ec 18             	sub    $0x18,%esp
f010436b:	89 d3                	mov    %edx,%ebx
	// LAB 4: Your code here.
	struct Env *env; 
	if (envid2env(envid, &env, 1)) 
f010436d:	6a 01                	push   $0x1
f010436f:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104372:	52                   	push   %edx
f0104373:	50                   	push   %eax
f0104374:	e8 cc ec ff ff       	call   f0103045 <envid2env>
f0104379:	83 c4 10             	add    $0x10,%esp
f010437c:	85 c0                	test   %eax,%eax
f010437e:	75 08                	jne    f0104388 <sys_env_set_pgfault_upcall+0x24>
		return -E_BAD_ENV;	
	env->env_pgfault_upcall = func;
f0104380:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104383:	89 5a 64             	mov    %ebx,0x64(%edx)
	return 0;
f0104386:	eb 05                	jmp    f010438d <sys_env_set_pgfault_upcall+0x29>
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	struct Env *env; 
	if (envid2env(envid, &env, 1)) 
		return -E_BAD_ENV;	
f0104388:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	env->env_pgfault_upcall = func;
	return 0;
}
f010438d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104390:	c9                   	leave  
f0104391:	c3                   	ret    

f0104392 <sys_getenvid>:
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f0104392:	55                   	push   %ebp
f0104393:	89 e5                	mov    %esp,%ebp
f0104395:	83 ec 08             	sub    $0x8,%esp
	return curenv->env_id;
f0104398:	e8 2d 18 00 00       	call   f0105bca <cpunum>
f010439d:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a0:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01043a6:	8b 40 48             	mov    0x48(%eax),%eax
}
f01043a9:	c9                   	leave  
f01043aa:	c3                   	ret    

f01043ab <sys_ipc_recv>:
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
f01043ab:	55                   	push   %ebp
f01043ac:	89 e5                	mov    %esp,%ebp
f01043ae:	53                   	push   %ebx
f01043af:	83 ec 04             	sub    $0x4,%esp
	// LAB 4: Your code here.
	if ((uint32_t)dstva < UTOP){
f01043b2:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
f01043b7:	77 07                	ja     f01043c0 <sys_ipc_recv+0x15>

		if (((uint32_t)dstva % PGSIZE))
f01043b9:	a9 ff 0f 00 00       	test   $0xfff,%eax
f01043be:	75 41                	jne    f0104401 <sys_ipc_recv+0x56>
f01043c0:	89 c3                	mov    %eax,%ebx
			return -E_INVAL;
	}

	curenv->env_ipc_recving = 1;
f01043c2:	e8 03 18 00 00       	call   f0105bca <cpunum>
f01043c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01043ca:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01043d0:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f01043d4:	e8 f1 17 00 00       	call   f0105bca <cpunum>
f01043d9:	6b c0 74             	imul   $0x74,%eax,%eax
f01043dc:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01043e2:	89 58 6c             	mov    %ebx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f01043e5:	e8 e0 17 00 00       	call   f0105bca <cpunum>
f01043ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01043ed:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01043f3:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	//sched_yield();
	return 0;
f01043fa:	b8 00 00 00 00       	mov    $0x0,%eax
f01043ff:	eb 05                	jmp    f0104406 <sys_ipc_recv+0x5b>
{
	// LAB 4: Your code here.
	if ((uint32_t)dstva < UTOP){

		if (((uint32_t)dstva % PGSIZE))
			return -E_INVAL;
f0104401:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	curenv->env_ipc_recving = 1;
	curenv->env_ipc_dstva = dstva;
	curenv->env_status = ENV_NOT_RUNNABLE;
	//sched_yield();
	return 0;
}
f0104406:	83 c4 04             	add    $0x4,%esp
f0104409:	5b                   	pop    %ebx
f010440a:	5d                   	pop    %ebp
f010440b:	c3                   	ret    

f010440c <sys_env_destroy>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
f010440c:	55                   	push   %ebp
f010440d:	89 e5                	mov    %esp,%ebp
f010440f:	53                   	push   %ebx
f0104410:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0104413:	6a 01                	push   $0x1
f0104415:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104418:	52                   	push   %edx
f0104419:	50                   	push   %eax
f010441a:	e8 26 ec ff ff       	call   f0103045 <envid2env>
f010441f:	83 c4 10             	add    $0x10,%esp
f0104422:	85 c0                	test   %eax,%eax
f0104424:	78 6e                	js     f0104494 <sys_env_destroy+0x88>
		return r;
	if (e == curenv)
f0104426:	e8 9f 17 00 00       	call   f0105bca <cpunum>
f010442b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010442e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104431:	39 90 28 b0 21 f0    	cmp    %edx,-0xfde4fd8(%eax)
f0104437:	75 23                	jne    f010445c <sys_env_destroy+0x50>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104439:	e8 8c 17 00 00       	call   f0105bca <cpunum>
f010443e:	83 ec 08             	sub    $0x8,%esp
f0104441:	6b c0 74             	imul   $0x74,%eax,%eax
f0104444:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f010444a:	ff 70 48             	pushl  0x48(%eax)
f010444d:	68 46 79 10 f0       	push   $0xf0107946
f0104452:	e8 04 f3 ff ff       	call   f010375b <cprintf>
f0104457:	83 c4 10             	add    $0x10,%esp
f010445a:	eb 25                	jmp    f0104481 <sys_env_destroy+0x75>
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f010445c:	8b 5a 48             	mov    0x48(%edx),%ebx
f010445f:	e8 66 17 00 00       	call   f0105bca <cpunum>
f0104464:	83 ec 04             	sub    $0x4,%esp
f0104467:	53                   	push   %ebx
f0104468:	6b c0 74             	imul   $0x74,%eax,%eax
f010446b:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0104471:	ff 70 48             	pushl  0x48(%eax)
f0104474:	68 61 79 10 f0       	push   $0xf0107961
f0104479:	e8 dd f2 ff ff       	call   f010375b <cprintf>
f010447e:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0104481:	83 ec 0c             	sub    $0xc,%esp
f0104484:	ff 75 f4             	pushl  -0xc(%ebp)
f0104487:	e8 7c ef ff ff       	call   f0103408 <env_destroy>
	return 0;
f010448c:	83 c4 10             	add    $0x10,%esp
f010448f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104494:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104497:	c9                   	leave  
f0104498:	c3                   	ret    

f0104499 <sys_cputs>:
// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
f0104499:	55                   	push   %ebp
f010449a:	89 e5                	mov    %esp,%ebp
f010449c:	56                   	push   %esi
f010449d:	53                   	push   %ebx
f010449e:	89 c6                	mov    %eax,%esi
f01044a0:	89 d3                	mov    %edx,%ebx
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
	
	// LAB 3: Your code here.
	user_mem_assert(curenv, s, len, 0);
f01044a2:	e8 23 17 00 00       	call   f0105bca <cpunum>
f01044a7:	6a 00                	push   $0x0
f01044a9:	53                   	push   %ebx
f01044aa:	56                   	push   %esi
f01044ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01044ae:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f01044b4:	e8 77 e8 ff ff       	call   f0102d30 <user_mem_assert>
	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f01044b9:	83 c4 0c             	add    $0xc,%esp
f01044bc:	56                   	push   %esi
f01044bd:	53                   	push   %ebx
f01044be:	68 79 79 10 f0       	push   $0xf0107979
f01044c3:	e8 93 f2 ff ff       	call   f010375b <cprintf>
}
f01044c8:	83 c4 10             	add    $0x10,%esp
f01044cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01044ce:	5b                   	pop    %ebx
f01044cf:	5e                   	pop    %esi
f01044d0:	5d                   	pop    %ebp
f01044d1:	c3                   	ret    

f01044d2 <sys_cgetc>:

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
f01044d2:	55                   	push   %ebp
f01044d3:	89 e5                	mov    %esp,%ebp
f01044d5:	83 ec 08             	sub    $0x8,%esp
	return cons_getc();
f01044d8:	e8 cc c3 ff ff       	call   f01008a9 <cons_getc>
}
f01044dd:	c9                   	leave  
f01044de:	c3                   	ret    

f01044df <sys_yield>:
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
f01044df:	55                   	push   %ebp
f01044e0:	89 e5                	mov    %esp,%ebp
f01044e2:	83 ec 08             	sub    $0x8,%esp
	sched_yield();
f01044e5:	e8 81 fd ff ff       	call   f010426b <sched_yield>

f01044ea <sys_exofork>:
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
f01044ea:	55                   	push   %ebp
f01044eb:	89 e5                	mov    %esp,%ebp
f01044ed:	57                   	push   %edi
f01044ee:	56                   	push   %esi
f01044ef:	53                   	push   %ebx
f01044f0:	83 ec 1c             	sub    $0x1c,%esp
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	struct Env *newEnv;
	int result = env_alloc(&newEnv, curenv->env_id);
f01044f3:	e8 d2 16 00 00       	call   f0105bca <cpunum>
f01044f8:	83 ec 08             	sub    $0x8,%esp
f01044fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01044fe:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0104504:	ff 70 48             	pushl  0x48(%eax)
f0104507:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010450a:	50                   	push   %eax
f010450b:	e8 47 ec ff ff       	call   f0103157 <env_alloc>
	if(result<0){
f0104510:	83 c4 10             	add    $0x10,%esp
f0104513:	85 c0                	test   %eax,%eax
f0104515:	78 2e                	js     f0104545 <sys_exofork+0x5b>
		return result;
	}	
	newEnv->env_tf = curenv->env_tf;
f0104517:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f010451a:	e8 ab 16 00 00       	call   f0105bca <cpunum>
f010451f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104522:	8b b0 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%esi
f0104528:	b9 11 00 00 00       	mov    $0x11,%ecx
f010452d:	89 df                	mov    %ebx,%edi
f010452f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	newEnv->env_status = ENV_NOT_RUNNABLE;
f0104531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104534:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	newEnv->env_tf.tf_regs.reg_eax = 0;
f010453b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	return newEnv->env_id;
f0104542:	8b 40 48             	mov    0x48(%eax),%eax
	
}
f0104545:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104548:	5b                   	pop    %ebx
f0104549:	5e                   	pop    %esi
f010454a:	5f                   	pop    %edi
f010454b:	5d                   	pop    %ebp
f010454c:	c3                   	ret    

f010454d <sys_page_alloc>:
	//   allocated!

	// LAB 4: Your code here.
	struct Env *env; 
	int result;
	if (va >= (void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){
f010454d:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0104553:	77 7c                	ja     f01045d1 <sys_page_alloc+0x84>
f0104555:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010455b:	75 7c                	jne    f01045d9 <sys_page_alloc+0x8c>
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
f010455d:	55                   	push   %ebp
f010455e:	89 e5                	mov    %esp,%ebp
f0104560:	57                   	push   %edi
f0104561:	56                   	push   %esi
f0104562:	53                   	push   %ebx
f0104563:	83 ec 1c             	sub    $0x1c,%esp
		return -E_INVAL;
	}
	//Va correcto

	int flag = PTE_U|PTE_P;
	if ((perm & flag) != flag){
f0104566:	89 cb                	mov    %ecx,%ebx
f0104568:	83 e3 05             	and    $0x5,%ebx
f010456b:	83 fb 05             	cmp    $0x5,%ebx
f010456e:	75 70                	jne    f01045e0 <sys_page_alloc+0x93>
f0104570:	89 ce                	mov    %ecx,%esi
f0104572:	89 d3                	mov    %edx,%ebx
		return -E_INVAL;
	}
	//FLAG CORRECTOS 

	result = envid2env(envid, &env, 1);
f0104574:	83 ec 04             	sub    $0x4,%esp
f0104577:	6a 01                	push   $0x1
f0104579:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010457c:	52                   	push   %edx
f010457d:	50                   	push   %eax
f010457e:	e8 c2 ea ff ff       	call   f0103045 <envid2env>
	if(result == -E_BAD_ENV){
f0104583:	83 c4 10             	add    $0x10,%esp
		return result;
f0104586:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
		return -E_INVAL;
	}
	//FLAG CORRECTOS 

	result = envid2env(envid, &env, 1);
	if(result == -E_BAD_ENV){
f010458b:	83 f8 fe             	cmp    $0xfffffffe,%eax
f010458e:	74 5c                	je     f01045ec <sys_page_alloc+0x9f>
		return result;
	}
	//El enviroment existe	
	
	struct PageInfo *page = page_alloc(ALLOC_ZERO);
f0104590:	83 ec 0c             	sub    $0xc,%esp
f0104593:	6a 01                	push   $0x1
f0104595:	e8 93 ce ff ff       	call   f010142d <page_alloc>
f010459a:	89 c7                	mov    %eax,%edi
	if (!page){
f010459c:	83 c4 10             	add    $0x10,%esp
f010459f:	85 c0                	test   %eax,%eax
f01045a1:	74 44                	je     f01045e7 <sys_page_alloc+0x9a>
		return -E_NO_MEM;
	}
	//page->pp_ref++;

	result = page_insert(env->env_pgdir, page, va, perm);
f01045a3:	56                   	push   %esi
f01045a4:	53                   	push   %ebx
f01045a5:	50                   	push   %eax
f01045a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01045a9:	ff 70 60             	pushl  0x60(%eax)
f01045ac:	e8 f4 d4 ff ff       	call   f0101aa5 <page_insert>
	if (result == -E_NO_MEM) {
f01045b1:	83 c4 10             	add    $0x10,%esp
		page_free(page);
		return result;
	}
	return 0;
f01045b4:	ba 00 00 00 00       	mov    $0x0,%edx
		return -E_NO_MEM;
	}
	//page->pp_ref++;

	result = page_insert(env->env_pgdir, page, va, perm);
	if (result == -E_NO_MEM) {
f01045b9:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01045bc:	75 2e                	jne    f01045ec <sys_page_alloc+0x9f>
		page_free(page);
f01045be:	83 ec 0c             	sub    $0xc,%esp
f01045c1:	57                   	push   %edi
f01045c2:	e8 ab ce ff ff       	call   f0101472 <page_free>
		return result;
f01045c7:	83 c4 10             	add    $0x10,%esp
f01045ca:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
f01045cf:	eb 1b                	jmp    f01045ec <sys_page_alloc+0x9f>

	// LAB 4: Your code here.
	struct Env *env; 
	int result;
	if (va >= (void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){
		return -E_INVAL;
f01045d1:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
		return result;
	}
	return 0;

	
}
f01045d6:	89 d0                	mov    %edx,%eax
f01045d8:	c3                   	ret    

	// LAB 4: Your code here.
	struct Env *env; 
	int result;
	if (va >= (void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){
		return -E_INVAL;
f01045d9:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f01045de:	eb f6                	jmp    f01045d6 <sys_page_alloc+0x89>
	}
	//Va correcto

	int flag = PTE_U|PTE_P;
	if ((perm & flag) != flag){
		return -E_INVAL;
f01045e0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f01045e5:	eb 05                	jmp    f01045ec <sys_page_alloc+0x9f>
	}
	//El enviroment existe	
	
	struct PageInfo *page = page_alloc(ALLOC_ZERO);
	if (!page){
		return -E_NO_MEM;
f01045e7:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
		return result;
	}
	return 0;

	
}
f01045ec:	89 d0                	mov    %edx,%eax
f01045ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01045f1:	5b                   	pop    %ebx
f01045f2:	5e                   	pop    %esi
f01045f3:	5f                   	pop    %edi
f01045f4:	5d                   	pop    %ebp
f01045f5:	c3                   	ret    

f01045f6 <sys_page_map>:
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva, envid_t dstenvid, void *dstva, int perm)
{
f01045f6:	55                   	push   %ebp
f01045f7:	89 e5                	mov    %esp,%ebp
f01045f9:	56                   	push   %esi
f01045fa:	53                   	push   %ebx
f01045fb:	83 ec 14             	sub    $0x14,%esp
f01045fe:	89 d3                	mov    %edx,%ebx
f0104600:	89 ce                	mov    %ecx,%esi

	// LAB 4: Your code here.
	struct Env *srcenv, *dstenv;
	int result;

	result = envid2env(srcenvid, &srcenv, 1);
f0104602:	6a 01                	push   $0x1
f0104604:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104607:	52                   	push   %edx
f0104608:	50                   	push   %eax
f0104609:	e8 37 ea ff ff       	call   f0103045 <envid2env>
	if (result == -E_BAD_ENV){
f010460e:	83 c4 10             	add    $0x10,%esp
f0104611:	83 f8 fe             	cmp    $0xfffffffe,%eax
f0104614:	0f 84 ac 00 00 00    	je     f01046c6 <sys_page_map+0xd0>
		return result;
	} 

	result = envid2env(dstenvid, &dstenv, 1);
f010461a:	83 ec 04             	sub    $0x4,%esp
f010461d:	6a 01                	push   $0x1
f010461f:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0104622:	50                   	push   %eax
f0104623:	56                   	push   %esi
f0104624:	e8 1c ea ff ff       	call   f0103045 <envid2env>
	if (result == -E_BAD_ENV){
f0104629:	83 c4 10             	add    $0x10,%esp
f010462c:	83 f8 fe             	cmp    $0xfffffffe,%eax
f010462f:	0f 84 98 00 00 00    	je     f01046cd <sys_page_map+0xd7>
		return result;
	} 
	//Existen los dos enviroments	

	if (srcva>=(void*)UTOP ||ROUNDDOWN(srcva,PGSIZE)!=srcva || 
f0104635:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f010463b:	0f 87 93 00 00 00    	ja     f01046d4 <sys_page_map+0xde>
f0104641:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f0104647:	0f 85 8e 00 00 00    	jne    f01046db <sys_page_map+0xe5>
f010464d:	81 7d 08 ff ff bf ee 	cmpl   $0xeebfffff,0x8(%ebp)
f0104654:	0f 87 81 00 00 00    	ja     f01046db <sys_page_map+0xe5>
		dstva>=(void*)UTOP ||ROUNDDOWN(dstva,PGSIZE)!=dstva){
				return -E_INVAL;
f010465a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return result;
	} 
	//Existen los dos enviroments	

	if (srcva>=(void*)UTOP ||ROUNDDOWN(srcva,PGSIZE)!=srcva || 
		dstva>=(void*)UTOP ||ROUNDDOWN(dstva,PGSIZE)!=dstva){
f010465f:	f7 45 08 ff 0f 00 00 	testl  $0xfff,0x8(%ebp)
f0104666:	0f 85 89 00 00 00    	jne    f01046f5 <sys_page_map+0xff>
				return -E_INVAL;
	} 
	// Los va son validos
	
	pte_t *pte;
	struct PageInfo *page = page_lookup(srcenv->env_pgdir, srcva, &pte);
f010466c:	83 ec 04             	sub    $0x4,%esp
f010466f:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0104672:	50                   	push   %eax
f0104673:	53                   	push   %ebx
f0104674:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104677:	ff 70 60             	pushl  0x60(%eax)
f010467a:	e8 66 d3 ff ff       	call   f01019e5 <page_lookup>
	if (!page){
f010467f:	83 c4 10             	add    $0x10,%esp
f0104682:	85 c0                	test   %eax,%eax
f0104684:	74 5c                	je     f01046e2 <sys_page_map+0xec>
	} 
	// Existe la pagina en va

	
	int flag = PTE_U|PTE_P;
	if ((perm & flag) != flag){
f0104686:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104689:	83 e2 05             	and    $0x5,%edx
f010468c:	83 fa 05             	cmp    $0x5,%edx
f010468f:	75 58                	jne    f01046e9 <sys_page_map+0xf3>
		return -E_INVAL;
	}
	
	if (((*pte&PTE_W) == 0) && (perm&PTE_W)){
f0104691:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0104694:	f6 02 02             	testb  $0x2,(%edx)
f0104697:	75 06                	jne    f010469f <sys_page_map+0xa9>
f0104699:	f6 45 0c 02          	testb  $0x2,0xc(%ebp)
f010469d:	75 51                	jne    f01046f0 <sys_page_map+0xfa>
		return -E_INVAL;
	} 
	// Flags correctos 

	result = page_insert(dstenv->env_pgdir, page, dstva, perm);
f010469f:	ff 75 0c             	pushl  0xc(%ebp)
f01046a2:	ff 75 08             	pushl  0x8(%ebp)
f01046a5:	50                   	push   %eax
f01046a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01046a9:	ff 70 60             	pushl  0x60(%eax)
f01046ac:	e8 f4 d3 ff ff       	call   f0101aa5 <page_insert>
	if(result == -E_NO_MEM){
f01046b1:	83 c4 10             	add    $0x10,%esp
		return result;
f01046b4:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01046b7:	0f 95 c0             	setne  %al
f01046ba:	0f b6 c0             	movzbl %al,%eax
f01046bd:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
f01046c4:	eb 2f                	jmp    f01046f5 <sys_page_map+0xff>
	struct Env *srcenv, *dstenv;
	int result;

	result = envid2env(srcenvid, &srcenv, 1);
	if (result == -E_BAD_ENV){
		return result;
f01046c6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01046cb:	eb 28                	jmp    f01046f5 <sys_page_map+0xff>
	} 

	result = envid2env(dstenvid, &dstenv, 1);
	if (result == -E_BAD_ENV){
		return result;
f01046cd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01046d2:	eb 21                	jmp    f01046f5 <sys_page_map+0xff>
	} 
	//Existen los dos enviroments	

	if (srcva>=(void*)UTOP ||ROUNDDOWN(srcva,PGSIZE)!=srcva || 
		dstva>=(void*)UTOP ||ROUNDDOWN(dstva,PGSIZE)!=dstva){
				return -E_INVAL;
f01046d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01046d9:	eb 1a                	jmp    f01046f5 <sys_page_map+0xff>
f01046db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01046e0:	eb 13                	jmp    f01046f5 <sys_page_map+0xff>
	// Los va son validos
	
	pte_t *pte;
	struct PageInfo *page = page_lookup(srcenv->env_pgdir, srcva, &pte);
	if (!page){
		return -E_INVAL;
f01046e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01046e7:	eb 0c                	jmp    f01046f5 <sys_page_map+0xff>
	// Existe la pagina en va

	
	int flag = PTE_U|PTE_P;
	if ((perm & flag) != flag){
		return -E_INVAL;
f01046e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01046ee:	eb 05                	jmp    f01046f5 <sys_page_map+0xff>
	}
	
	if (((*pte&PTE_W) == 0) && (perm&PTE_W)){
		return -E_INVAL;
f01046f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	// Hay memoria

	return 0;

}
f01046f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01046f8:	5b                   	pop    %ebx
f01046f9:	5e                   	pop    %esi
f01046fa:	5d                   	pop    %ebp
f01046fb:	c3                   	ret    

f01046fc <sys_ipc_try_send>:
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
f01046fc:	55                   	push   %ebp
f01046fd:	89 e5                	mov    %esp,%ebp
f01046ff:	57                   	push   %edi
f0104700:	56                   	push   %esi
f0104701:	53                   	push   %ebx
f0104702:	83 ec 20             	sub    $0x20,%esp
f0104705:	89 d7                	mov    %edx,%edi
f0104707:	89 cb                	mov    %ecx,%ebx
	// LAB 4: Your code here.
	struct Env* env;
	if (envid2env(envid, &env,0)) // No existe el proceso
f0104709:	6a 00                	push   $0x0
f010470b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010470e:	52                   	push   %edx
f010470f:	50                   	push   %eax
f0104710:	e8 30 e9 ff ff       	call   f0103045 <envid2env>
f0104715:	83 c4 10             	add    $0x10,%esp
f0104718:	85 c0                	test   %eax,%eax
f010471a:	0f 85 cf 00 00 00    	jne    f01047ef <sys_ipc_try_send+0xf3>
f0104720:	89 c6                	mov    %eax,%esi
		return -E_BAD_ENV;
	if (!env->env_ipc_recving)
f0104722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104725:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104729:	0f 84 c7 00 00 00    	je     f01047f6 <sys_ipc_try_send+0xfa>
		return -E_IPC_NOT_RECV;

	if ((uint32_t)srcva < UTOP){
f010472f:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0104735:	0f 87 8a 00 00 00    	ja     f01047c5 <sys_ipc_try_send+0xc9>
		uint32_t p_align,right_perm ,rdnly;
		pte_t* pte;
		struct PageInfo* pg = page_lookup(curenv->env_pgdir, srcva, &pte);
f010473b:	e8 8a 14 00 00       	call   f0105bca <cpunum>
f0104740:	83 ec 04             	sub    $0x4,%esp
f0104743:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104746:	52                   	push   %edx
f0104747:	53                   	push   %ebx
f0104748:	6b c0 74             	imul   $0x74,%eax,%eax
f010474b:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f0104751:	ff 70 60             	pushl  0x60(%eax)
f0104754:	e8 8c d2 ff ff       	call   f01019e5 <page_lookup>

		p_align = ((uint32_t)srcva % PGSIZE);
f0104759:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
		int flag =  ~PTE_SYSCALL | PTE_U | PTE_P;
		right_perm = ((perm && flag) != flag);//((*pte & perm) != perm); 
		rdnly = (!(*pte & PTE_W) && (perm & PTE_W));
f010475f:	83 c4 10             	add    $0x10,%esp
f0104762:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104765:	f6 02 02             	testb  $0x2,(%edx)
f0104768:	75 06                	jne    f0104770 <sys_ipc_try_send+0x74>
f010476a:	f6 45 08 02          	testb  $0x2,0x8(%ebp)
f010476e:	75 3c                	jne    f01047ac <sys_ipc_try_send+0xb0>

		if (p_align || !right_perm || !pg || rdnly) 
f0104770:	85 db                	test   %ebx,%ebx
f0104772:	75 3f                	jne    f01047b3 <sys_ipc_try_send+0xb7>
f0104774:	85 c0                	test   %eax,%eax
f0104776:	74 42                	je     f01047ba <sys_ipc_try_send+0xbe>
			return -E_INVAL;
		
		env->env_ipc_perm = 0;	
f0104778:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010477b:	c7 42 78 00 00 00 00 	movl   $0x0,0x78(%edx)
		if ((uint32_t)env->env_ipc_dstva < UTOP){
f0104782:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0104785:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010478b:	77 38                	ja     f01047c5 <sys_ipc_try_send+0xc9>
			int result = page_insert(env->env_pgdir, pg, env->env_ipc_dstva, perm);
f010478d:	ff 75 08             	pushl  0x8(%ebp)
f0104790:	51                   	push   %ecx
f0104791:	50                   	push   %eax
f0104792:	ff 72 60             	pushl  0x60(%edx)
f0104795:	e8 0b d3 ff ff       	call   f0101aa5 <page_insert>
			if (result < 0){
f010479a:	83 c4 10             	add    $0x10,%esp
f010479d:	85 c0                	test   %eax,%eax
f010479f:	78 20                	js     f01047c1 <sys_ipc_try_send+0xc5>
				return result; // -E_NO_MEM por como funciona page_insert
			}
			env->env_ipc_perm = perm;	
f01047a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01047a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01047a7:	89 48 78             	mov    %ecx,0x78(%eax)
f01047aa:	eb 19                	jmp    f01047c5 <sys_ipc_try_send+0xc9>
		int flag =  ~PTE_SYSCALL | PTE_U | PTE_P;
		right_perm = ((perm && flag) != flag);//((*pte & perm) != perm); 
		rdnly = (!(*pte & PTE_W) && (perm & PTE_W));

		if (p_align || !right_perm || !pg || rdnly) 
			return -E_INVAL;
f01047ac:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f01047b1:	eb 48                	jmp    f01047fb <sys_ipc_try_send+0xff>
f01047b3:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f01047b8:	eb 41                	jmp    f01047fb <sys_ipc_try_send+0xff>
f01047ba:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f01047bf:	eb 3a                	jmp    f01047fb <sys_ipc_try_send+0xff>
		
		env->env_ipc_perm = 0;	
		if ((uint32_t)env->env_ipc_dstva < UTOP){
			int result = page_insert(env->env_pgdir, pg, env->env_ipc_dstva, perm);
			if (result < 0){
				return result; // -E_NO_MEM por como funciona page_insert
f01047c1:	89 c6                	mov    %eax,%esi
f01047c3:	eb 36                	jmp    f01047fb <sys_ipc_try_send+0xff>
			}
			env->env_ipc_perm = perm;	
		}	
	} 
	env->env_ipc_recving = 0;
f01047c5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01047c8:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env->env_ipc_from = curenv->env_id;
f01047cc:	e8 f9 13 00 00       	call   f0105bca <cpunum>
f01047d1:	6b c0 74             	imul   $0x74,%eax,%eax
f01047d4:	8b 80 28 b0 21 f0    	mov    -0xfde4fd8(%eax),%eax
f01047da:	8b 40 48             	mov    0x48(%eax),%eax
f01047dd:	89 43 74             	mov    %eax,0x74(%ebx)
	env->env_ipc_value = value;
f01047e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01047e3:	89 78 70             	mov    %edi,0x70(%eax)
	env->env_status = ENV_RUNNABLE;
f01047e6:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	//env->env_tf.tf_regs.reg_eax = 0;
	return 0;
f01047ed:	eb 0c                	jmp    f01047fb <sys_ipc_try_send+0xff>
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
	struct Env* env;
	if (envid2env(envid, &env,0)) // No existe el proceso
		return -E_BAD_ENV;
f01047ef:	be fe ff ff ff       	mov    $0xfffffffe,%esi
f01047f4:	eb 05                	jmp    f01047fb <sys_ipc_try_send+0xff>
	if (!env->env_ipc_recving)
		return -E_IPC_NOT_RECV;
f01047f6:	be f9 ff ff ff       	mov    $0xfffffff9,%esi
	env->env_ipc_from = curenv->env_id;
	env->env_ipc_value = value;
	env->env_status = ENV_RUNNABLE;
	//env->env_tf.tf_regs.reg_eax = 0;
	return 0;
}
f01047fb:	89 f0                	mov    %esi,%eax
f01047fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104800:	5b                   	pop    %ebx
f0104801:	5e                   	pop    %esi
f0104802:	5f                   	pop    %edi
f0104803:	5d                   	pop    %ebp
f0104804:	c3                   	ret    

f0104805 <sys_page_unmap>:
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	struct Env *env;
	int result;
	if (va>=(void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){		
f0104805:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f010480b:	77 48                	ja     f0104855 <sys_page_unmap+0x50>
		return -E_INVAL;
f010480d:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	struct Env *env;
	int result;
	if (va>=(void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){		
f0104812:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0104818:	75 40                	jne    f010485a <sys_page_unmap+0x55>
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
f010481a:	55                   	push   %ebp
f010481b:	89 e5                	mov    %esp,%ebp
f010481d:	53                   	push   %ebx
f010481e:	83 ec 18             	sub    $0x18,%esp
f0104821:	89 d3                	mov    %edx,%ebx
	int result;
	if (va>=(void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){		
		return -E_INVAL;
	}

	result = envid2env(envid, &env, 1);
f0104823:	6a 01                	push   $0x1
f0104825:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104828:	52                   	push   %edx
f0104829:	50                   	push   %eax
f010482a:	e8 16 e8 ff ff       	call   f0103045 <envid2env>
	if (result == -E_BAD_ENV){
f010482f:	83 c4 10             	add    $0x10,%esp
		return result;
f0104832:	b9 fe ff ff ff       	mov    $0xfffffffe,%ecx
	if (va>=(void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){		
		return -E_INVAL;
	}

	result = envid2env(envid, &env, 1);
	if (result == -E_BAD_ENV){
f0104837:	83 f8 fe             	cmp    $0xfffffffe,%eax
f010483a:	74 21                	je     f010485d <sys_page_unmap+0x58>
		return result;
	} 	
	
	page_remove(env->env_pgdir, va);
f010483c:	83 ec 08             	sub    $0x8,%esp
f010483f:	53                   	push   %ebx
f0104840:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104843:	ff 70 60             	pushl  0x60(%eax)
f0104846:	e8 0d d2 ff ff       	call   f0101a58 <page_remove>
	return 0;
f010484b:	83 c4 10             	add    $0x10,%esp
f010484e:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104853:	eb 08                	jmp    f010485d <sys_page_unmap+0x58>

	// LAB 4: Your code here.
	struct Env *env;
	int result;
	if (va>=(void*)UTOP || ROUNDDOWN(va,PGSIZE)!=va){		
		return -E_INVAL;
f0104855:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
		return result;
	} 	
	
	page_remove(env->env_pgdir, va);
	return 0;
}
f010485a:	89 c8                	mov    %ecx,%eax
f010485c:	c3                   	ret    
f010485d:	89 c8                	mov    %ecx,%eax
f010485f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104862:	c9                   	leave  
f0104863:	c3                   	ret    

f0104864 <sys_env_set_trapframe>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
f0104864:	55                   	push   %ebp
f0104865:	89 e5                	mov    %esp,%ebp
f0104867:	57                   	push   %edi
f0104868:	56                   	push   %esi
f0104869:	83 ec 14             	sub    $0x14,%esp
f010486c:	89 d6                	mov    %edx,%esi
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env* env;
	size_t tf_size =  sizeof(struct Trapframe);
	if (envid2env(envid, &env, 1) < 0 || user_mem_check(env, tf, tf_size, PTE_U | PTE_P) < 0)
f010486e:	6a 01                	push   $0x1
f0104870:	8d 55 f4             	lea    -0xc(%ebp),%edx
f0104873:	52                   	push   %edx
f0104874:	50                   	push   %eax
f0104875:	e8 cb e7 ff ff       	call   f0103045 <envid2env>
f010487a:	83 c4 10             	add    $0x10,%esp
f010487d:	85 c0                	test   %eax,%eax
f010487f:	78 42                	js     f01048c3 <sys_env_set_trapframe+0x5f>
f0104881:	6a 05                	push   $0x5
f0104883:	6a 44                	push   $0x44
f0104885:	56                   	push   %esi
f0104886:	ff 75 f4             	pushl  -0xc(%ebp)
f0104889:	e8 15 e4 ff ff       	call   f0102ca3 <user_mem_check>
f010488e:	83 c4 10             	add    $0x10,%esp
f0104891:	85 c0                	test   %eax,%eax
f0104893:	78 35                	js     f01048ca <sys_env_set_trapframe+0x66>
		return -E_BAD_ENV;
	
	
	//El cpl de todos los segmentos es 3
	env->env_tf.tf_cs |= 3;
f0104895:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104898:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
	env->env_tf.tf_ds |= 3;
f010489d:	66 83 48 24 03       	orw    $0x3,0x24(%eax)
	env->env_tf.tf_es |= 3;
f01048a2:	66 83 48 20 03       	orw    $0x3,0x20(%eax)
	env->env_tf.tf_ss |= 3;
f01048a7:	66 83 48 40 03       	orw    $0x3,0x40(%eax)
	
	env->env_tf.tf_eflags |= FL_IF;
	env->env_tf.tf_eflags = 0;
f01048ac:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	env->env_tf = *tf;
f01048b3:	b9 11 00 00 00       	mov    $0x11,%ecx
f01048b8:	89 c7                	mov    %eax,%edi
f01048ba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	return 0;
f01048bc:	b8 00 00 00 00       	mov    $0x0,%eax
f01048c1:	eb 0c                	jmp    f01048cf <sys_env_set_trapframe+0x6b>
	// Remember to check whether the user has supplied us with a good
	// address!
	struct Env* env;
	size_t tf_size =  sizeof(struct Trapframe);
	if (envid2env(envid, &env, 1) < 0 || user_mem_check(env, tf, tf_size, PTE_U | PTE_P) < 0)
		return -E_BAD_ENV;
f01048c3:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01048c8:	eb 05                	jmp    f01048cf <sys_env_set_trapframe+0x6b>
f01048ca:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	env->env_tf.tf_eflags = 0;
	env->env_tf = *tf;

	return 0;

}
f01048cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01048d2:	5e                   	pop    %esi
f01048d3:	5f                   	pop    %edi
f01048d4:	5d                   	pop    %ebp
f01048d5:	c3                   	ret    

f01048d6 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01048d6:	55                   	push   %ebp
f01048d7:	89 e5                	mov    %esp,%ebp
f01048d9:	83 ec 08             	sub    $0x8,%esp
f01048dc:	8b 45 08             	mov    0x8(%ebp),%eax
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

	switch (syscallno) {
f01048df:	83 f8 0d             	cmp    $0xd,%eax
f01048e2:	0f 87 cf 00 00 00    	ja     f01049b7 <syscall+0xe1>
f01048e8:	ff 24 85 80 79 10 f0 	jmp    *-0xfef8680(,%eax,4)

		case SYS_env_destroy:
			return sys_env_destroy(a1);
f01048ef:	8b 45 0c             	mov    0xc(%ebp),%eax
f01048f2:	e8 15 fb ff ff       	call   f010440c <sys_env_destroy>
f01048f7:	e9 c0 00 00 00       	jmp    f01049bc <syscall+0xe6>
	
		case SYS_cputs:
			sys_cputs((const char*)a1,a2);
f01048fc:	8b 55 10             	mov    0x10(%ebp),%edx
f01048ff:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104902:	e8 92 fb ff ff       	call   f0104499 <sys_cputs>
			return 0;
f0104907:	b8 00 00 00 00       	mov    $0x0,%eax
f010490c:	e9 ab 00 00 00       	jmp    f01049bc <syscall+0xe6>

		case SYS_cgetc:
			return sys_cgetc();
f0104911:	e8 bc fb ff ff       	call   f01044d2 <sys_cgetc>
f0104916:	e9 a1 00 00 00       	jmp    f01049bc <syscall+0xe6>

		case SYS_getenvid:
			return sys_getenvid();
f010491b:	e8 72 fa ff ff       	call   f0104392 <sys_getenvid>
f0104920:	e9 97 00 00 00       	jmp    f01049bc <syscall+0xe6>
		
		case SYS_yield:
			sys_yield();			
f0104925:	e8 b5 fb ff ff       	call   f01044df <sys_yield>
		
		case SYS_exofork:
			return sys_exofork();
f010492a:	e8 bb fb ff ff       	call   f01044ea <sys_exofork>
f010492f:	e9 88 00 00 00       	jmp    f01049bc <syscall+0xe6>

		case SYS_page_alloc:
			return sys_page_alloc(a1, (void*)a2, a3);
f0104934:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104937:	8b 55 10             	mov    0x10(%ebp),%edx
f010493a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010493d:	e8 0b fc ff ff       	call   f010454d <sys_page_alloc>
f0104942:	eb 78                	jmp    f01049bc <syscall+0xe6>

		case SYS_page_map:
			return sys_page_map(a1, (void*)a2, a3, (void*)a4, a5);
f0104944:	83 ec 08             	sub    $0x8,%esp
f0104947:	ff 75 1c             	pushl  0x1c(%ebp)
f010494a:	ff 75 18             	pushl  0x18(%ebp)
f010494d:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0104950:	8b 55 10             	mov    0x10(%ebp),%edx
f0104953:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104956:	e8 9b fc ff ff       	call   f01045f6 <sys_page_map>
f010495b:	83 c4 10             	add    $0x10,%esp
f010495e:	eb 5c                	jmp    f01049bc <syscall+0xe6>

		case SYS_page_unmap:
			return sys_page_unmap(a1, (void*)a2);
f0104960:	8b 55 10             	mov    0x10(%ebp),%edx
f0104963:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104966:	e8 9a fe ff ff       	call   f0104805 <sys_page_unmap>
f010496b:	eb 4f                	jmp    f01049bc <syscall+0xe6>

		case SYS_env_set_status:
			return sys_env_set_status(a1, a2);
f010496d:	8b 55 10             	mov    0x10(%ebp),%edx
f0104970:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104973:	e8 a7 f9 ff ff       	call   f010431f <sys_env_set_status>
f0104978:	eb 42                	jmp    f01049bc <syscall+0xe6>

		case SYS_env_set_pgfault_upcall:
			return sys_env_set_pgfault_upcall(a1, (void*)a2);
f010497a:	8b 55 10             	mov    0x10(%ebp),%edx
f010497d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104980:	e8 df f9 ff ff       	call   f0104364 <sys_env_set_pgfault_upcall>
f0104985:	eb 35                	jmp    f01049bc <syscall+0xe6>
	
		case SYS_ipc_recv:
			return sys_ipc_recv((void*)a1);
f0104987:	8b 45 0c             	mov    0xc(%ebp),%eax
f010498a:	e8 1c fa ff ff       	call   f01043ab <sys_ipc_recv>
f010498f:	eb 2b                	jmp    f01049bc <syscall+0xe6>

		case SYS_ipc_try_send:
			return sys_ipc_try_send(a1,a2, (void*)a3, a4);		
f0104991:	83 ec 0c             	sub    $0xc,%esp
f0104994:	ff 75 18             	pushl  0x18(%ebp)
f0104997:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010499a:	8b 55 10             	mov    0x10(%ebp),%edx
f010499d:	8b 45 0c             	mov    0xc(%ebp),%eax
f01049a0:	e8 57 fd ff ff       	call   f01046fc <sys_ipc_try_send>
f01049a5:	83 c4 10             	add    $0x10,%esp
f01049a8:	eb 12                	jmp    f01049bc <syscall+0xe6>

		case SYS_env_set_trapframe:
			return  sys_env_set_trapframe(a1,(struct Trapframe*) a2);
f01049aa:	8b 55 10             	mov    0x10(%ebp),%edx
f01049ad:	8b 45 0c             	mov    0xc(%ebp),%eax
f01049b0:	e8 af fe ff ff       	call   f0104864 <sys_env_set_trapframe>
f01049b5:	eb 05                	jmp    f01049bc <syscall+0xe6>
		
		default:
			return -E_INVAL;
f01049b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
}
f01049bc:	c9                   	leave  
f01049bd:	c3                   	ret    

f01049be <stab_binsearch>:
stab_binsearch(const struct Stab *stabs,
               int *region_left,
               int *region_right,
               int type,
               uintptr_t addr)
{
f01049be:	55                   	push   %ebp
f01049bf:	89 e5                	mov    %esp,%ebp
f01049c1:	57                   	push   %edi
f01049c2:	56                   	push   %esi
f01049c3:	53                   	push   %ebx
f01049c4:	83 ec 14             	sub    $0x14,%esp
f01049c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01049ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01049cd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01049d0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f01049d3:	8b 1a                	mov    (%edx),%ebx
f01049d5:	8b 01                	mov    (%ecx),%eax
f01049d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01049da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f01049e1:	eb 7f                	jmp    f0104a62 <stab_binsearch+0xa4>
		int true_m = (l + r) / 2, m = true_m;
f01049e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01049e6:	01 d8                	add    %ebx,%eax
f01049e8:	89 c6                	mov    %eax,%esi
f01049ea:	c1 ee 1f             	shr    $0x1f,%esi
f01049ed:	01 c6                	add    %eax,%esi
f01049ef:	d1 fe                	sar    %esi
f01049f1:	8d 04 76             	lea    (%esi,%esi,2),%eax
f01049f4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01049f7:	8d 14 81             	lea    (%ecx,%eax,4),%edx
f01049fa:	89 f0                	mov    %esi,%eax

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f01049fc:	eb 03                	jmp    f0104a01 <stab_binsearch+0x43>
			m--;
f01049fe:	83 e8 01             	sub    $0x1,%eax

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0104a01:	39 c3                	cmp    %eax,%ebx
f0104a03:	7f 0d                	jg     f0104a12 <stab_binsearch+0x54>
f0104a05:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0104a09:	83 ea 0c             	sub    $0xc,%edx
f0104a0c:	39 f9                	cmp    %edi,%ecx
f0104a0e:	75 ee                	jne    f01049fe <stab_binsearch+0x40>
f0104a10:	eb 05                	jmp    f0104a17 <stab_binsearch+0x59>
			m--;
		if (m < l) {  // no match in [l, m]
			l = true_m + 1;
f0104a12:	8d 5e 01             	lea    0x1(%esi),%ebx
			continue;
f0104a15:	eb 4b                	jmp    f0104a62 <stab_binsearch+0xa4>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104a17:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104a1a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104a1d:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104a21:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0104a24:	76 11                	jbe    f0104a37 <stab_binsearch+0x79>
			*region_left = m;
f0104a26:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104a29:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104a2b:	8d 5e 01             	lea    0x1(%esi),%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0104a2e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104a35:	eb 2b                	jmp    f0104a62 <stab_binsearch+0xa4>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f0104a37:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0104a3a:	73 14                	jae    f0104a50 <stab_binsearch+0x92>
			*region_right = m - 1;
f0104a3c:	83 e8 01             	sub    $0x1,%eax
f0104a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104a42:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0104a45:	89 06                	mov    %eax,(%esi)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0104a47:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104a4e:	eb 12                	jmp    f0104a62 <stab_binsearch+0xa4>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104a50:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a53:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f0104a55:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104a59:	89 c3                	mov    %eax,%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0104a5b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
               int type,
               uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f0104a62:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104a65:	0f 8e 78 ff ff ff    	jle    f01049e3 <stab_binsearch+0x25>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0104a6b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104a6f:	75 0f                	jne    f0104a80 <stab_binsearch+0xc2>
		*region_right = *region_left - 1;
f0104a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a74:	8b 00                	mov    (%eax),%eax
f0104a76:	83 e8 01             	sub    $0x1,%eax
f0104a79:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0104a7c:	89 06                	mov    %eax,(%esi)
f0104a7e:	eb 2c                	jmp    f0104aac <stab_binsearch+0xee>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0104a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a83:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104a85:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a88:	8b 0e                	mov    (%esi),%ecx
f0104a8a:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104a8d:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104a90:	8d 14 96             	lea    (%esi,%edx,4),%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0104a93:	eb 03                	jmp    f0104a98 <stab_binsearch+0xda>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f0104a95:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0104a98:	39 c8                	cmp    %ecx,%eax
f0104a9a:	7e 0b                	jle    f0104aa7 <stab_binsearch+0xe9>
		     l > *region_left && stabs[l].n_type != type;
f0104a9c:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f0104aa0:	83 ea 0c             	sub    $0xc,%edx
f0104aa3:	39 df                	cmp    %ebx,%edi
f0104aa5:	75 ee                	jne    f0104a95 <stab_binsearch+0xd7>
		     l--)
			/* do nothing */;
		*region_left = l;
f0104aa7:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104aaa:	89 06                	mov    %eax,(%esi)
	}
}
f0104aac:	83 c4 14             	add    $0x14,%esp
f0104aaf:	5b                   	pop    %ebx
f0104ab0:	5e                   	pop    %esi
f0104ab1:	5f                   	pop    %edi
f0104ab2:	5d                   	pop    %ebp
f0104ab3:	c3                   	ret    

f0104ab4 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104ab4:	55                   	push   %ebp
f0104ab5:	89 e5                	mov    %esp,%ebp
f0104ab7:	57                   	push   %edi
f0104ab8:	56                   	push   %esi
f0104ab9:	53                   	push   %ebx
f0104aba:	83 ec 3c             	sub    $0x3c,%esp
f0104abd:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104ac0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104ac3:	c7 03 b8 79 10 f0    	movl   $0xf01079b8,(%ebx)
	info->eip_line = 0;
f0104ac9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104ad0:	c7 43 08 b8 79 10 f0 	movl   $0xf01079b8,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104ad7:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104ade:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104ae1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104ae8:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104aee:	0f 87 a3 00 00 00    	ja     f0104b97 <debuginfo_eip+0xe3>
		        (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, usd, sizeof(struct UserStabData), 0))
f0104af4:	e8 d1 10 00 00       	call   f0105bca <cpunum>
f0104af9:	6a 00                	push   $0x0
f0104afb:	6a 10                	push   $0x10
f0104afd:	68 00 00 20 00       	push   $0x200000
f0104b02:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b05:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f0104b0b:	e8 93 e1 ff ff       	call   f0102ca3 <user_mem_check>
f0104b10:	83 c4 10             	add    $0x10,%esp
f0104b13:	85 c0                	test   %eax,%eax
f0104b15:	0f 85 43 02 00 00    	jne    f0104d5e <debuginfo_eip+0x2aa>
			return -1;

		stabs = usd->stabs;
f0104b1b:	a1 00 00 20 00       	mov    0x200000,%eax
f0104b20:	89 45 c0             	mov    %eax,-0x40(%ebp)
		stab_end = usd->stab_end;
f0104b23:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0104b29:	8b 15 08 00 20 00    	mov    0x200008,%edx
f0104b2f:	89 55 b8             	mov    %edx,-0x48(%ebp)
		stabstr_end = usd->stabstr_end;
f0104b32:	a1 0c 00 20 00       	mov    0x20000c,%eax
f0104b37:	89 45 bc             	mov    %eax,-0x44(%ebp)

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, stabs, stab_end - stabs, 0) ||
f0104b3a:	e8 8b 10 00 00       	call   f0105bca <cpunum>
f0104b3f:	6a 00                	push   $0x0
f0104b41:	89 f2                	mov    %esi,%edx
f0104b43:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0104b46:	29 ca                	sub    %ecx,%edx
f0104b48:	c1 fa 02             	sar    $0x2,%edx
f0104b4b:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0104b51:	52                   	push   %edx
f0104b52:	51                   	push   %ecx
f0104b53:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b56:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f0104b5c:	e8 42 e1 ff ff       	call   f0102ca3 <user_mem_check>
f0104b61:	83 c4 10             	add    $0x10,%esp
f0104b64:	85 c0                	test   %eax,%eax
f0104b66:	0f 85 f9 01 00 00    	jne    f0104d65 <debuginfo_eip+0x2b1>
		    user_mem_check(curenv, stabstr, stabstr_end - stabstr, 0))
f0104b6c:	e8 59 10 00 00       	call   f0105bca <cpunum>
f0104b71:	6a 00                	push   $0x0
f0104b73:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0104b76:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104b79:	29 ca                	sub    %ecx,%edx
f0104b7b:	52                   	push   %edx
f0104b7c:	51                   	push   %ecx
f0104b7d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b80:	ff b0 28 b0 21 f0    	pushl  -0xfde4fd8(%eax)
f0104b86:	e8 18 e1 ff ff       	call   f0102ca3 <user_mem_check>
		stabstr = usd->stabstr;
		stabstr_end = usd->stabstr_end;

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, stabs, stab_end - stabs, 0) ||
f0104b8b:	83 c4 10             	add    $0x10,%esp
f0104b8e:	85 c0                	test   %eax,%eax
f0104b90:	74 1f                	je     f0104bb1 <debuginfo_eip+0xfd>
f0104b92:	e9 d5 01 00 00       	jmp    f0104d6c <debuginfo_eip+0x2b8>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104b97:	c7 45 bc d0 72 11 f0 	movl   $0xf01172d0,-0x44(%ebp)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
f0104b9e:	c7 45 b8 e5 32 11 f0 	movl   $0xf01132e5,-0x48(%ebp)
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
f0104ba5:	be e4 32 11 f0       	mov    $0xf01132e4,%esi
	info->eip_fn_addr = addr;
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
f0104baa:	c7 45 c0 50 7f 10 f0 	movl   $0xf0107f50,-0x40(%ebp)
		    user_mem_check(curenv, stabstr, stabstr_end - stabstr, 0))
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104bb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0104bb4:	39 45 b8             	cmp    %eax,-0x48(%ebp)
f0104bb7:	0f 83 b6 01 00 00    	jae    f0104d73 <debuginfo_eip+0x2bf>
f0104bbd:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f0104bc1:	0f 85 b3 01 00 00    	jne    f0104d7a <debuginfo_eip+0x2c6>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104bc7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104bce:	2b 75 c0             	sub    -0x40(%ebp),%esi
f0104bd1:	c1 fe 02             	sar    $0x2,%esi
f0104bd4:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0104bda:	83 e8 01             	sub    $0x1,%eax
f0104bdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104be0:	83 ec 08             	sub    $0x8,%esp
f0104be3:	57                   	push   %edi
f0104be4:	6a 64                	push   $0x64
f0104be6:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104be9:	89 d1                	mov    %edx,%ecx
f0104beb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104bee:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0104bf1:	89 f0                	mov    %esi,%eax
f0104bf3:	e8 c6 fd ff ff       	call   f01049be <stab_binsearch>
	if (lfile == 0)
f0104bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104bfb:	83 c4 10             	add    $0x10,%esp
f0104bfe:	85 c0                	test   %eax,%eax
f0104c00:	0f 84 7b 01 00 00    	je     f0104d81 <debuginfo_eip+0x2cd>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104c06:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c0c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104c0f:	83 ec 08             	sub    $0x8,%esp
f0104c12:	57                   	push   %edi
f0104c13:	6a 24                	push   $0x24
f0104c15:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104c18:	89 d1                	mov    %edx,%ecx
f0104c1a:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104c1d:	89 f0                	mov    %esi,%eax
f0104c1f:	e8 9a fd ff ff       	call   f01049be <stab_binsearch>

	if (lfun <= rfun) {
f0104c24:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104c27:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104c2a:	83 c4 10             	add    $0x10,%esp
f0104c2d:	39 d0                	cmp    %edx,%eax
f0104c2f:	7f 2e                	jg     f0104c5f <debuginfo_eip+0x1ab>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104c31:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104c34:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0104c37:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0104c3a:	8b 36                	mov    (%esi),%esi
f0104c3c:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0104c3f:	2b 4d b8             	sub    -0x48(%ebp),%ecx
f0104c42:	39 ce                	cmp    %ecx,%esi
f0104c44:	73 06                	jae    f0104c4c <debuginfo_eip+0x198>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104c46:	03 75 b8             	add    -0x48(%ebp),%esi
f0104c49:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104c4c:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0104c4f:	8b 4e 08             	mov    0x8(%esi),%ecx
f0104c52:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0104c55:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0104c57:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104c5a:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0104c5d:	eb 0f                	jmp    f0104c6e <debuginfo_eip+0x1ba>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0104c5f:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0104c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0104c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104c6e:	83 ec 08             	sub    $0x8,%esp
f0104c71:	6a 3a                	push   $0x3a
f0104c73:	ff 73 08             	pushl  0x8(%ebx)
f0104c76:	e8 92 08 00 00       	call   f010550d <strfind>
f0104c7b:	2b 43 08             	sub    0x8(%ebx),%eax
f0104c7e:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104c81:	83 c4 08             	add    $0x8,%esp
f0104c84:	57                   	push   %edi
f0104c85:	6a 44                	push   $0x44
f0104c87:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104c8a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104c8d:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104c90:	89 f8                	mov    %edi,%eax
f0104c92:	e8 27 fd ff ff       	call   f01049be <stab_binsearch>
	if (lline <= rline) {
f0104c97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104c9a:	83 c4 10             	add    $0x10,%esp
f0104c9d:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0104ca0:	7f 0b                	jg     f0104cad <debuginfo_eip+0x1f9>
		info->eip_line = stabs[lline].n_desc;
f0104ca2:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104ca5:	0f b7 44 87 06       	movzwl 0x6(%edi,%eax,4),%eax
f0104caa:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile && stabs[lline].n_type != N_SOL &&
f0104cad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104cb0:	89 d0                	mov    %edx,%eax
f0104cb2:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104cb5:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0104cb8:	8d 14 96             	lea    (%esi,%edx,4),%edx
f0104cbb:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104cbf:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0104cc2:	eb 0a                	jmp    f0104cce <debuginfo_eip+0x21a>
f0104cc4:	83 e8 01             	sub    $0x1,%eax
f0104cc7:	83 ea 0c             	sub    $0xc,%edx
f0104cca:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0104cce:	39 c7                	cmp    %eax,%edi
f0104cd0:	7e 05                	jle    f0104cd7 <debuginfo_eip+0x223>
f0104cd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104cd5:	eb 47                	jmp    f0104d1e <debuginfo_eip+0x26a>
f0104cd7:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0104cdb:	80 f9 84             	cmp    $0x84,%cl
f0104cde:	75 0e                	jne    f0104cee <debuginfo_eip+0x23a>
f0104ce0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104ce3:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104ce7:	74 1c                	je     f0104d05 <debuginfo_eip+0x251>
f0104ce9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0104cec:	eb 17                	jmp    f0104d05 <debuginfo_eip+0x251>
f0104cee:	80 f9 64             	cmp    $0x64,%cl
f0104cf1:	75 d1                	jne    f0104cc4 <debuginfo_eip+0x210>
	       (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104cf3:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f0104cf7:	74 cb                	je     f0104cc4 <debuginfo_eip+0x210>
f0104cf9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104cfc:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104d00:	74 03                	je     f0104d05 <debuginfo_eip+0x251>
f0104d02:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104d05:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104d08:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104d0b:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104d0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0104d11:	8b 7d b8             	mov    -0x48(%ebp),%edi
f0104d14:	29 f8                	sub    %edi,%eax
f0104d16:	39 c2                	cmp    %eax,%edx
f0104d18:	73 04                	jae    f0104d1e <debuginfo_eip+0x26a>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104d1a:	01 fa                	add    %edi,%edx
f0104d1c:	89 13                	mov    %edx,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104d1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104d21:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104d24:	b8 00 00 00 00       	mov    $0x0,%eax
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104d29:	39 f2                	cmp    %esi,%edx
f0104d2b:	7d 60                	jge    f0104d8d <debuginfo_eip+0x2d9>
		for (lline = lfun + 1;
f0104d2d:	83 c2 01             	add    $0x1,%edx
f0104d30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104d33:	89 d0                	mov    %edx,%eax
f0104d35:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104d38:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104d3b:	8d 14 97             	lea    (%edi,%edx,4),%edx
f0104d3e:	eb 04                	jmp    f0104d44 <debuginfo_eip+0x290>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0104d40:	83 43 14 01          	addl   $0x1,0x14(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0104d44:	39 c6                	cmp    %eax,%esi
f0104d46:	7e 40                	jle    f0104d88 <debuginfo_eip+0x2d4>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104d48:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0104d4c:	83 c0 01             	add    $0x1,%eax
f0104d4f:	83 c2 0c             	add    $0xc,%edx
f0104d52:	80 f9 a0             	cmp    $0xa0,%cl
f0104d55:	74 e9                	je     f0104d40 <debuginfo_eip+0x28c>
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104d57:	b8 00 00 00 00       	mov    $0x0,%eax
f0104d5c:	eb 2f                	jmp    f0104d8d <debuginfo_eip+0x2d9>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, usd, sizeof(struct UserStabData), 0))
			return -1;
f0104d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d63:	eb 28                	jmp    f0104d8d <debuginfo_eip+0x2d9>

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, stabs, stab_end - stabs, 0) ||
		    user_mem_check(curenv, stabstr, stabstr_end - stabstr, 0))
			return -1;
f0104d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d6a:	eb 21                	jmp    f0104d8d <debuginfo_eip+0x2d9>
f0104d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d71:	eb 1a                	jmp    f0104d8d <debuginfo_eip+0x2d9>
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f0104d73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d78:	eb 13                	jmp    f0104d8d <debuginfo_eip+0x2d9>
f0104d7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d7f:	eb 0c                	jmp    f0104d8d <debuginfo_eip+0x2d9>
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
		return -1;
f0104d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d86:	eb 05                	jmp    f0104d8d <debuginfo_eip+0x2d9>
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104d90:	5b                   	pop    %ebx
f0104d91:	5e                   	pop    %esi
f0104d92:	5f                   	pop    %edi
f0104d93:	5d                   	pop    %ebp
f0104d94:	c3                   	ret    

f0104d95 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104d95:	55                   	push   %ebp
f0104d96:	89 e5                	mov    %esp,%ebp
f0104d98:	57                   	push   %edi
f0104d99:	56                   	push   %esi
f0104d9a:	53                   	push   %ebx
f0104d9b:	83 ec 1c             	sub    $0x1c,%esp
f0104d9e:	89 c7                	mov    %eax,%edi
f0104da0:	89 d6                	mov    %edx,%esi
f0104da2:	8b 45 08             	mov    0x8(%ebp),%eax
f0104da5:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104da8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104dab:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0104dae:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104db1:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104db6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104db9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0104dbc:	39 d3                	cmp    %edx,%ebx
f0104dbe:	72 05                	jb     f0104dc5 <printnum+0x30>
f0104dc0:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104dc3:	77 45                	ja     f0104e0a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104dc5:	83 ec 0c             	sub    $0xc,%esp
f0104dc8:	ff 75 18             	pushl  0x18(%ebp)
f0104dcb:	8b 45 14             	mov    0x14(%ebp),%eax
f0104dce:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104dd1:	53                   	push   %ebx
f0104dd2:	ff 75 10             	pushl  0x10(%ebp)
f0104dd5:	83 ec 08             	sub    $0x8,%esp
f0104dd8:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104ddb:	ff 75 e0             	pushl  -0x20(%ebp)
f0104dde:	ff 75 dc             	pushl  -0x24(%ebp)
f0104de1:	ff 75 d8             	pushl  -0x28(%ebp)
f0104de4:	e8 07 12 00 00       	call   f0105ff0 <__udivdi3>
f0104de9:	83 c4 18             	add    $0x18,%esp
f0104dec:	52                   	push   %edx
f0104ded:	50                   	push   %eax
f0104dee:	89 f2                	mov    %esi,%edx
f0104df0:	89 f8                	mov    %edi,%eax
f0104df2:	e8 9e ff ff ff       	call   f0104d95 <printnum>
f0104df7:	83 c4 20             	add    $0x20,%esp
f0104dfa:	eb 18                	jmp    f0104e14 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104dfc:	83 ec 08             	sub    $0x8,%esp
f0104dff:	56                   	push   %esi
f0104e00:	ff 75 18             	pushl  0x18(%ebp)
f0104e03:	ff d7                	call   *%edi
f0104e05:	83 c4 10             	add    $0x10,%esp
f0104e08:	eb 03                	jmp    f0104e0d <printnum+0x78>
f0104e0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0104e0d:	83 eb 01             	sub    $0x1,%ebx
f0104e10:	85 db                	test   %ebx,%ebx
f0104e12:	7f e8                	jg     f0104dfc <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104e14:	83 ec 08             	sub    $0x8,%esp
f0104e17:	56                   	push   %esi
f0104e18:	83 ec 04             	sub    $0x4,%esp
f0104e1b:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104e1e:	ff 75 e0             	pushl  -0x20(%ebp)
f0104e21:	ff 75 dc             	pushl  -0x24(%ebp)
f0104e24:	ff 75 d8             	pushl  -0x28(%ebp)
f0104e27:	e8 f4 12 00 00       	call   f0106120 <__umoddi3>
f0104e2c:	83 c4 14             	add    $0x14,%esp
f0104e2f:	0f be 80 c2 79 10 f0 	movsbl -0xfef863e(%eax),%eax
f0104e36:	50                   	push   %eax
f0104e37:	ff d7                	call   *%edi
}
f0104e39:	83 c4 10             	add    $0x10,%esp
f0104e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104e3f:	5b                   	pop    %ebx
f0104e40:	5e                   	pop    %esi
f0104e41:	5f                   	pop    %edi
f0104e42:	5d                   	pop    %ebp
f0104e43:	c3                   	ret    

f0104e44 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0104e44:	55                   	push   %ebp
f0104e45:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0104e47:	83 fa 01             	cmp    $0x1,%edx
f0104e4a:	7e 0e                	jle    f0104e5a <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f0104e4c:	8b 10                	mov    (%eax),%edx
f0104e4e:	8d 4a 08             	lea    0x8(%edx),%ecx
f0104e51:	89 08                	mov    %ecx,(%eax)
f0104e53:	8b 02                	mov    (%edx),%eax
f0104e55:	8b 52 04             	mov    0x4(%edx),%edx
f0104e58:	eb 22                	jmp    f0104e7c <getuint+0x38>
	else if (lflag)
f0104e5a:	85 d2                	test   %edx,%edx
f0104e5c:	74 10                	je     f0104e6e <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0104e5e:	8b 10                	mov    (%eax),%edx
f0104e60:	8d 4a 04             	lea    0x4(%edx),%ecx
f0104e63:	89 08                	mov    %ecx,(%eax)
f0104e65:	8b 02                	mov    (%edx),%eax
f0104e67:	ba 00 00 00 00       	mov    $0x0,%edx
f0104e6c:	eb 0e                	jmp    f0104e7c <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0104e6e:	8b 10                	mov    (%eax),%edx
f0104e70:	8d 4a 04             	lea    0x4(%edx),%ecx
f0104e73:	89 08                	mov    %ecx,(%eax)
f0104e75:	8b 02                	mov    (%edx),%eax
f0104e77:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0104e7c:	5d                   	pop    %ebp
f0104e7d:	c3                   	ret    

f0104e7e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f0104e7e:	55                   	push   %ebp
f0104e7f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0104e81:	83 fa 01             	cmp    $0x1,%edx
f0104e84:	7e 0e                	jle    f0104e94 <getint+0x16>
		return va_arg(*ap, long long);
f0104e86:	8b 10                	mov    (%eax),%edx
f0104e88:	8d 4a 08             	lea    0x8(%edx),%ecx
f0104e8b:	89 08                	mov    %ecx,(%eax)
f0104e8d:	8b 02                	mov    (%edx),%eax
f0104e8f:	8b 52 04             	mov    0x4(%edx),%edx
f0104e92:	eb 1a                	jmp    f0104eae <getint+0x30>
	else if (lflag)
f0104e94:	85 d2                	test   %edx,%edx
f0104e96:	74 0c                	je     f0104ea4 <getint+0x26>
		return va_arg(*ap, long);
f0104e98:	8b 10                	mov    (%eax),%edx
f0104e9a:	8d 4a 04             	lea    0x4(%edx),%ecx
f0104e9d:	89 08                	mov    %ecx,(%eax)
f0104e9f:	8b 02                	mov    (%edx),%eax
f0104ea1:	99                   	cltd   
f0104ea2:	eb 0a                	jmp    f0104eae <getint+0x30>
	else
		return va_arg(*ap, int);
f0104ea4:	8b 10                	mov    (%eax),%edx
f0104ea6:	8d 4a 04             	lea    0x4(%edx),%ecx
f0104ea9:	89 08                	mov    %ecx,(%eax)
f0104eab:	8b 02                	mov    (%edx),%eax
f0104ead:	99                   	cltd   
}
f0104eae:	5d                   	pop    %ebp
f0104eaf:	c3                   	ret    

f0104eb0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0104eb0:	55                   	push   %ebp
f0104eb1:	89 e5                	mov    %esp,%ebp
f0104eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0104eb6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0104eba:	8b 10                	mov    (%eax),%edx
f0104ebc:	3b 50 04             	cmp    0x4(%eax),%edx
f0104ebf:	73 0a                	jae    f0104ecb <sprintputch+0x1b>
		*b->buf++ = ch;
f0104ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
f0104ec4:	89 08                	mov    %ecx,(%eax)
f0104ec6:	8b 45 08             	mov    0x8(%ebp),%eax
f0104ec9:	88 02                	mov    %al,(%edx)
}
f0104ecb:	5d                   	pop    %ebp
f0104ecc:	c3                   	ret    

f0104ecd <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0104ecd:	55                   	push   %ebp
f0104ece:	89 e5                	mov    %esp,%ebp
f0104ed0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0104ed3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104ed6:	50                   	push   %eax
f0104ed7:	ff 75 10             	pushl  0x10(%ebp)
f0104eda:	ff 75 0c             	pushl  0xc(%ebp)
f0104edd:	ff 75 08             	pushl  0x8(%ebp)
f0104ee0:	e8 05 00 00 00       	call   f0104eea <vprintfmt>
	va_end(ap);
}
f0104ee5:	83 c4 10             	add    $0x10,%esp
f0104ee8:	c9                   	leave  
f0104ee9:	c3                   	ret    

f0104eea <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0104eea:	55                   	push   %ebp
f0104eeb:	89 e5                	mov    %esp,%ebp
f0104eed:	57                   	push   %edi
f0104eee:	56                   	push   %esi
f0104eef:	53                   	push   %ebx
f0104ef0:	83 ec 2c             	sub    $0x2c,%esp
f0104ef3:	8b 75 08             	mov    0x8(%ebp),%esi
f0104ef6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104ef9:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104efc:	eb 12                	jmp    f0104f10 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0104efe:	85 c0                	test   %eax,%eax
f0104f00:	0f 84 44 03 00 00    	je     f010524a <vprintfmt+0x360>
				return;
			putch(ch, putdat);
f0104f06:	83 ec 08             	sub    $0x8,%esp
f0104f09:	53                   	push   %ebx
f0104f0a:	50                   	push   %eax
f0104f0b:	ff d6                	call   *%esi
f0104f0d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0104f10:	83 c7 01             	add    $0x1,%edi
f0104f13:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0104f17:	83 f8 25             	cmp    $0x25,%eax
f0104f1a:	75 e2                	jne    f0104efe <vprintfmt+0x14>
f0104f1c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
f0104f20:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0104f27:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0104f2e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
f0104f35:	ba 00 00 00 00       	mov    $0x0,%edx
f0104f3a:	eb 07                	jmp    f0104f43 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104f3c:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
f0104f3f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104f43:	8d 47 01             	lea    0x1(%edi),%eax
f0104f46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104f49:	0f b6 07             	movzbl (%edi),%eax
f0104f4c:	0f b6 c8             	movzbl %al,%ecx
f0104f4f:	83 e8 23             	sub    $0x23,%eax
f0104f52:	3c 55                	cmp    $0x55,%al
f0104f54:	0f 87 d5 02 00 00    	ja     f010522f <vprintfmt+0x345>
f0104f5a:	0f b6 c0             	movzbl %al,%eax
f0104f5d:	ff 24 85 00 7b 10 f0 	jmp    *-0xfef8500(,%eax,4)
f0104f64:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f0104f67:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0104f6b:	eb d6                	jmp    f0104f43 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104f6d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f70:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0104f78:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104f7b:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
f0104f7f:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
f0104f82:	8d 51 d0             	lea    -0x30(%ecx),%edx
f0104f85:	83 fa 09             	cmp    $0x9,%edx
f0104f88:	77 39                	ja     f0104fc3 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0104f8a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
f0104f8d:	eb e9                	jmp    f0104f78 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0104f8f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f92:	8d 48 04             	lea    0x4(%eax),%ecx
f0104f95:	89 4d 14             	mov    %ecx,0x14(%ebp)
f0104f98:	8b 00                	mov    (%eax),%eax
f0104f9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104f9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0104fa0:	eb 27                	jmp    f0104fc9 <vprintfmt+0xdf>
f0104fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104fa5:	85 c0                	test   %eax,%eax
f0104fa7:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104fac:	0f 49 c8             	cmovns %eax,%ecx
f0104faf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104fb2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104fb5:	eb 8c                	jmp    f0104f43 <vprintfmt+0x59>
f0104fb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0104fba:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0104fc1:	eb 80                	jmp    f0104f43 <vprintfmt+0x59>
f0104fc3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104fc6:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
f0104fc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104fcd:	0f 89 70 ff ff ff    	jns    f0104f43 <vprintfmt+0x59>
				width = precision, precision = -1;
f0104fd3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104fd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104fd9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0104fe0:	e9 5e ff ff ff       	jmp    f0104f43 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0104fe5:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104fe8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
f0104feb:	e9 53 ff ff ff       	jmp    f0104f43 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0104ff0:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ff3:	8d 50 04             	lea    0x4(%eax),%edx
f0104ff6:	89 55 14             	mov    %edx,0x14(%ebp)
f0104ff9:	83 ec 08             	sub    $0x8,%esp
f0104ffc:	53                   	push   %ebx
f0104ffd:	ff 30                	pushl  (%eax)
f0104fff:	ff d6                	call   *%esi
			break;
f0105001:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105004:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
f0105007:	e9 04 ff ff ff       	jmp    f0104f10 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
f010500c:	8b 45 14             	mov    0x14(%ebp),%eax
f010500f:	8d 50 04             	lea    0x4(%eax),%edx
f0105012:	89 55 14             	mov    %edx,0x14(%ebp)
f0105015:	8b 00                	mov    (%eax),%eax
f0105017:	99                   	cltd   
f0105018:	31 d0                	xor    %edx,%eax
f010501a:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010501c:	83 f8 0f             	cmp    $0xf,%eax
f010501f:	7f 0b                	jg     f010502c <vprintfmt+0x142>
f0105021:	8b 14 85 60 7c 10 f0 	mov    -0xfef83a0(,%eax,4),%edx
f0105028:	85 d2                	test   %edx,%edx
f010502a:	75 18                	jne    f0105044 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
f010502c:	50                   	push   %eax
f010502d:	68 da 79 10 f0       	push   $0xf01079da
f0105032:	53                   	push   %ebx
f0105033:	56                   	push   %esi
f0105034:	e8 94 fe ff ff       	call   f0104ecd <printfmt>
f0105039:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010503c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
f010503f:	e9 cc fe ff ff       	jmp    f0104f10 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
f0105044:	52                   	push   %edx
f0105045:	68 ad 71 10 f0       	push   $0xf01071ad
f010504a:	53                   	push   %ebx
f010504b:	56                   	push   %esi
f010504c:	e8 7c fe ff ff       	call   f0104ecd <printfmt>
f0105051:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105054:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105057:	e9 b4 fe ff ff       	jmp    f0104f10 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f010505c:	8b 45 14             	mov    0x14(%ebp),%eax
f010505f:	8d 50 04             	lea    0x4(%eax),%edx
f0105062:	89 55 14             	mov    %edx,0x14(%ebp)
f0105065:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0105067:	85 ff                	test   %edi,%edi
f0105069:	b8 d3 79 10 f0       	mov    $0xf01079d3,%eax
f010506e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f0105071:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105075:	0f 8e 94 00 00 00    	jle    f010510f <vprintfmt+0x225>
f010507b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f010507f:	0f 84 98 00 00 00    	je     f010511d <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105085:	83 ec 08             	sub    $0x8,%esp
f0105088:	ff 75 d0             	pushl  -0x30(%ebp)
f010508b:	57                   	push   %edi
f010508c:	e8 32 03 00 00       	call   f01053c3 <strnlen>
f0105091:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105094:	29 c1                	sub    %eax,%ecx
f0105096:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0105099:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f010509c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f01050a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01050a3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01050a6:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01050a8:	eb 0f                	jmp    f01050b9 <vprintfmt+0x1cf>
					putch(padc, putdat);
f01050aa:	83 ec 08             	sub    $0x8,%esp
f01050ad:	53                   	push   %ebx
f01050ae:	ff 75 e0             	pushl  -0x20(%ebp)
f01050b1:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01050b3:	83 ef 01             	sub    $0x1,%edi
f01050b6:	83 c4 10             	add    $0x10,%esp
f01050b9:	85 ff                	test   %edi,%edi
f01050bb:	7f ed                	jg     f01050aa <vprintfmt+0x1c0>
f01050bd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01050c0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f01050c3:	85 c9                	test   %ecx,%ecx
f01050c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01050ca:	0f 49 c1             	cmovns %ecx,%eax
f01050cd:	29 c1                	sub    %eax,%ecx
f01050cf:	89 75 08             	mov    %esi,0x8(%ebp)
f01050d2:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01050d5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f01050d8:	89 cb                	mov    %ecx,%ebx
f01050da:	eb 4d                	jmp    f0105129 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01050dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01050e0:	74 1b                	je     f01050fd <vprintfmt+0x213>
f01050e2:	0f be c0             	movsbl %al,%eax
f01050e5:	83 e8 20             	sub    $0x20,%eax
f01050e8:	83 f8 5e             	cmp    $0x5e,%eax
f01050eb:	76 10                	jbe    f01050fd <vprintfmt+0x213>
					putch('?', putdat);
f01050ed:	83 ec 08             	sub    $0x8,%esp
f01050f0:	ff 75 0c             	pushl  0xc(%ebp)
f01050f3:	6a 3f                	push   $0x3f
f01050f5:	ff 55 08             	call   *0x8(%ebp)
f01050f8:	83 c4 10             	add    $0x10,%esp
f01050fb:	eb 0d                	jmp    f010510a <vprintfmt+0x220>
				else
					putch(ch, putdat);
f01050fd:	83 ec 08             	sub    $0x8,%esp
f0105100:	ff 75 0c             	pushl  0xc(%ebp)
f0105103:	52                   	push   %edx
f0105104:	ff 55 08             	call   *0x8(%ebp)
f0105107:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010510a:	83 eb 01             	sub    $0x1,%ebx
f010510d:	eb 1a                	jmp    f0105129 <vprintfmt+0x23f>
f010510f:	89 75 08             	mov    %esi,0x8(%ebp)
f0105112:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105115:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105118:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010511b:	eb 0c                	jmp    f0105129 <vprintfmt+0x23f>
f010511d:	89 75 08             	mov    %esi,0x8(%ebp)
f0105120:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105123:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105126:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0105129:	83 c7 01             	add    $0x1,%edi
f010512c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105130:	0f be d0             	movsbl %al,%edx
f0105133:	85 d2                	test   %edx,%edx
f0105135:	74 23                	je     f010515a <vprintfmt+0x270>
f0105137:	85 f6                	test   %esi,%esi
f0105139:	78 a1                	js     f01050dc <vprintfmt+0x1f2>
f010513b:	83 ee 01             	sub    $0x1,%esi
f010513e:	79 9c                	jns    f01050dc <vprintfmt+0x1f2>
f0105140:	89 df                	mov    %ebx,%edi
f0105142:	8b 75 08             	mov    0x8(%ebp),%esi
f0105145:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105148:	eb 18                	jmp    f0105162 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f010514a:	83 ec 08             	sub    $0x8,%esp
f010514d:	53                   	push   %ebx
f010514e:	6a 20                	push   $0x20
f0105150:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0105152:	83 ef 01             	sub    $0x1,%edi
f0105155:	83 c4 10             	add    $0x10,%esp
f0105158:	eb 08                	jmp    f0105162 <vprintfmt+0x278>
f010515a:	89 df                	mov    %ebx,%edi
f010515c:	8b 75 08             	mov    0x8(%ebp),%esi
f010515f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105162:	85 ff                	test   %edi,%edi
f0105164:	7f e4                	jg     f010514a <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105166:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105169:	e9 a2 fd ff ff       	jmp    f0104f10 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f010516e:	8d 45 14             	lea    0x14(%ebp),%eax
f0105171:	e8 08 fd ff ff       	call   f0104e7e <getint>
f0105176:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105179:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f010517c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f0105181:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105185:	79 74                	jns    f01051fb <vprintfmt+0x311>
				putch('-', putdat);
f0105187:	83 ec 08             	sub    $0x8,%esp
f010518a:	53                   	push   %ebx
f010518b:	6a 2d                	push   $0x2d
f010518d:	ff d6                	call   *%esi
				num = -(long long) num;
f010518f:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105192:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105195:	f7 d8                	neg    %eax
f0105197:	83 d2 00             	adc    $0x0,%edx
f010519a:	f7 da                	neg    %edx
f010519c:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
f010519f:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01051a4:	eb 55                	jmp    f01051fb <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01051a6:	8d 45 14             	lea    0x14(%ebp),%eax
f01051a9:	e8 96 fc ff ff       	call   f0104e44 <getuint>
			base = 10;
f01051ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
f01051b3:	eb 46                	jmp    f01051fb <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
f01051b5:	8d 45 14             	lea    0x14(%ebp),%eax
f01051b8:	e8 87 fc ff ff       	call   f0104e44 <getuint>
			base = 8;
f01051bd:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
f01051c2:	eb 37                	jmp    f01051fb <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
f01051c4:	83 ec 08             	sub    $0x8,%esp
f01051c7:	53                   	push   %ebx
f01051c8:	6a 30                	push   $0x30
f01051ca:	ff d6                	call   *%esi
			putch('x', putdat);
f01051cc:	83 c4 08             	add    $0x8,%esp
f01051cf:	53                   	push   %ebx
f01051d0:	6a 78                	push   $0x78
f01051d2:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f01051d4:	8b 45 14             	mov    0x14(%ebp),%eax
f01051d7:	8d 50 04             	lea    0x4(%eax),%edx
f01051da:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f01051dd:	8b 00                	mov    (%eax),%eax
f01051df:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f01051e4:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f01051e7:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
f01051ec:	eb 0d                	jmp    f01051fb <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f01051ee:	8d 45 14             	lea    0x14(%ebp),%eax
f01051f1:	e8 4e fc ff ff       	call   f0104e44 <getuint>
			base = 16;
f01051f6:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
f01051fb:	83 ec 0c             	sub    $0xc,%esp
f01051fe:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f0105202:	57                   	push   %edi
f0105203:	ff 75 e0             	pushl  -0x20(%ebp)
f0105206:	51                   	push   %ecx
f0105207:	52                   	push   %edx
f0105208:	50                   	push   %eax
f0105209:	89 da                	mov    %ebx,%edx
f010520b:	89 f0                	mov    %esi,%eax
f010520d:	e8 83 fb ff ff       	call   f0104d95 <printnum>
			break;
f0105212:	83 c4 20             	add    $0x20,%esp
f0105215:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105218:	e9 f3 fc ff ff       	jmp    f0104f10 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010521d:	83 ec 08             	sub    $0x8,%esp
f0105220:	53                   	push   %ebx
f0105221:	51                   	push   %ecx
f0105222:	ff d6                	call   *%esi
			break;
f0105224:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105227:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
f010522a:	e9 e1 fc ff ff       	jmp    f0104f10 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f010522f:	83 ec 08             	sub    $0x8,%esp
f0105232:	53                   	push   %ebx
f0105233:	6a 25                	push   $0x25
f0105235:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105237:	83 c4 10             	add    $0x10,%esp
f010523a:	eb 03                	jmp    f010523f <vprintfmt+0x355>
f010523c:	83 ef 01             	sub    $0x1,%edi
f010523f:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
f0105243:	75 f7                	jne    f010523c <vprintfmt+0x352>
f0105245:	e9 c6 fc ff ff       	jmp    f0104f10 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
f010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010524d:	5b                   	pop    %ebx
f010524e:	5e                   	pop    %esi
f010524f:	5f                   	pop    %edi
f0105250:	5d                   	pop    %ebp
f0105251:	c3                   	ret    

f0105252 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105252:	55                   	push   %ebp
f0105253:	89 e5                	mov    %esp,%ebp
f0105255:	83 ec 18             	sub    $0x18,%esp
f0105258:	8b 45 08             	mov    0x8(%ebp),%eax
f010525b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f010525e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105261:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105265:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0105268:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010526f:	85 c0                	test   %eax,%eax
f0105271:	74 26                	je     f0105299 <vsnprintf+0x47>
f0105273:	85 d2                	test   %edx,%edx
f0105275:	7e 22                	jle    f0105299 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105277:	ff 75 14             	pushl  0x14(%ebp)
f010527a:	ff 75 10             	pushl  0x10(%ebp)
f010527d:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105280:	50                   	push   %eax
f0105281:	68 b0 4e 10 f0       	push   $0xf0104eb0
f0105286:	e8 5f fc ff ff       	call   f0104eea <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010528b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010528e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105291:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105294:	83 c4 10             	add    $0x10,%esp
f0105297:	eb 05                	jmp    f010529e <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0105299:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f010529e:	c9                   	leave  
f010529f:	c3                   	ret    

f01052a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01052a0:	55                   	push   %ebp
f01052a1:	89 e5                	mov    %esp,%ebp
f01052a3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01052a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01052a9:	50                   	push   %eax
f01052aa:	ff 75 10             	pushl  0x10(%ebp)
f01052ad:	ff 75 0c             	pushl  0xc(%ebp)
f01052b0:	ff 75 08             	pushl  0x8(%ebp)
f01052b3:	e8 9a ff ff ff       	call   f0105252 <vsnprintf>
	va_end(ap);

	return rc;
}
f01052b8:	c9                   	leave  
f01052b9:	c3                   	ret    

f01052ba <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01052ba:	55                   	push   %ebp
f01052bb:	89 e5                	mov    %esp,%ebp
f01052bd:	57                   	push   %edi
f01052be:	56                   	push   %esi
f01052bf:	53                   	push   %ebx
f01052c0:	83 ec 0c             	sub    $0xc,%esp
f01052c3:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f01052c6:	85 c0                	test   %eax,%eax
f01052c8:	74 11                	je     f01052db <readline+0x21>
		cprintf("%s", prompt);
f01052ca:	83 ec 08             	sub    $0x8,%esp
f01052cd:	50                   	push   %eax
f01052ce:	68 ad 71 10 f0       	push   $0xf01071ad
f01052d3:	e8 83 e4 ff ff       	call   f010375b <cprintf>
f01052d8:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f01052db:	83 ec 0c             	sub    $0xc,%esp
f01052de:	6a 00                	push   $0x0
f01052e0:	e8 5f b6 ff ff       	call   f0100944 <iscons>
f01052e5:	89 c7                	mov    %eax,%edi
f01052e7:	83 c4 10             	add    $0x10,%esp
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f01052ea:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
f01052ef:	e8 3f b6 ff ff       	call   f0100933 <getchar>
f01052f4:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01052f6:	85 c0                	test   %eax,%eax
f01052f8:	79 29                	jns    f0105323 <readline+0x69>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f01052fa:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f01052ff:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105302:	0f 84 9b 00 00 00    	je     f01053a3 <readline+0xe9>
				cprintf("read error: %e\n", c);
f0105308:	83 ec 08             	sub    $0x8,%esp
f010530b:	53                   	push   %ebx
f010530c:	68 bf 7c 10 f0       	push   $0xf0107cbf
f0105311:	e8 45 e4 ff ff       	call   f010375b <cprintf>
f0105316:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0105319:	b8 00 00 00 00       	mov    $0x0,%eax
f010531e:	e9 80 00 00 00       	jmp    f01053a3 <readline+0xe9>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105323:	83 f8 08             	cmp    $0x8,%eax
f0105326:	0f 94 c2             	sete   %dl
f0105329:	83 f8 7f             	cmp    $0x7f,%eax
f010532c:	0f 94 c0             	sete   %al
f010532f:	08 c2                	or     %al,%dl
f0105331:	74 1a                	je     f010534d <readline+0x93>
f0105333:	85 f6                	test   %esi,%esi
f0105335:	7e 16                	jle    f010534d <readline+0x93>
			if (echoing)
f0105337:	85 ff                	test   %edi,%edi
f0105339:	74 0d                	je     f0105348 <readline+0x8e>
				cputchar('\b');
f010533b:	83 ec 0c             	sub    $0xc,%esp
f010533e:	6a 08                	push   $0x8
f0105340:	e8 de b5 ff ff       	call   f0100923 <cputchar>
f0105345:	83 c4 10             	add    $0x10,%esp
			i--;
f0105348:	83 ee 01             	sub    $0x1,%esi
f010534b:	eb a2                	jmp    f01052ef <readline+0x35>
		} else if (c >= ' ' && i < BUFLEN-1) {
f010534d:	83 fb 1f             	cmp    $0x1f,%ebx
f0105350:	7e 26                	jle    f0105378 <readline+0xbe>
f0105352:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0105358:	7f 1e                	jg     f0105378 <readline+0xbe>
			if (echoing)
f010535a:	85 ff                	test   %edi,%edi
f010535c:	74 0c                	je     f010536a <readline+0xb0>
				cputchar(c);
f010535e:	83 ec 0c             	sub    $0xc,%esp
f0105361:	53                   	push   %ebx
f0105362:	e8 bc b5 ff ff       	call   f0100923 <cputchar>
f0105367:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f010536a:	88 9e 80 aa 21 f0    	mov    %bl,-0xfde5580(%esi)
f0105370:	8d 76 01             	lea    0x1(%esi),%esi
f0105373:	e9 77 ff ff ff       	jmp    f01052ef <readline+0x35>
		} else if (c == '\n' || c == '\r') {
f0105378:	83 fb 0a             	cmp    $0xa,%ebx
f010537b:	74 09                	je     f0105386 <readline+0xcc>
f010537d:	83 fb 0d             	cmp    $0xd,%ebx
f0105380:	0f 85 69 ff ff ff    	jne    f01052ef <readline+0x35>
			if (echoing)
f0105386:	85 ff                	test   %edi,%edi
f0105388:	74 0d                	je     f0105397 <readline+0xdd>
				cputchar('\n');
f010538a:	83 ec 0c             	sub    $0xc,%esp
f010538d:	6a 0a                	push   $0xa
f010538f:	e8 8f b5 ff ff       	call   f0100923 <cputchar>
f0105394:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
f0105397:	c6 86 80 aa 21 f0 00 	movb   $0x0,-0xfde5580(%esi)
			return buf;
f010539e:	b8 80 aa 21 f0       	mov    $0xf021aa80,%eax
		}
	}
}
f01053a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01053a6:	5b                   	pop    %ebx
f01053a7:	5e                   	pop    %esi
f01053a8:	5f                   	pop    %edi
f01053a9:	5d                   	pop    %ebp
f01053aa:	c3                   	ret    

f01053ab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01053ab:	55                   	push   %ebp
f01053ac:	89 e5                	mov    %esp,%ebp
f01053ae:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01053b1:	b8 00 00 00 00       	mov    $0x0,%eax
f01053b6:	eb 03                	jmp    f01053bb <strlen+0x10>
		n++;
f01053b8:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f01053bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01053bf:	75 f7                	jne    f01053b8 <strlen+0xd>
		n++;
	return n;
}
f01053c1:	5d                   	pop    %ebp
f01053c2:	c3                   	ret    

f01053c3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01053c3:	55                   	push   %ebp
f01053c4:	89 e5                	mov    %esp,%ebp
f01053c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01053c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01053cc:	ba 00 00 00 00       	mov    $0x0,%edx
f01053d1:	eb 03                	jmp    f01053d6 <strnlen+0x13>
		n++;
f01053d3:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01053d6:	39 c2                	cmp    %eax,%edx
f01053d8:	74 08                	je     f01053e2 <strnlen+0x1f>
f01053da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
f01053de:	75 f3                	jne    f01053d3 <strnlen+0x10>
f01053e0:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
f01053e2:	5d                   	pop    %ebp
f01053e3:	c3                   	ret    

f01053e4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01053e4:	55                   	push   %ebp
f01053e5:	89 e5                	mov    %esp,%ebp
f01053e7:	53                   	push   %ebx
f01053e8:	8b 45 08             	mov    0x8(%ebp),%eax
f01053eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01053ee:	89 c2                	mov    %eax,%edx
f01053f0:	83 c2 01             	add    $0x1,%edx
f01053f3:	83 c1 01             	add    $0x1,%ecx
f01053f6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f01053fa:	88 5a ff             	mov    %bl,-0x1(%edx)
f01053fd:	84 db                	test   %bl,%bl
f01053ff:	75 ef                	jne    f01053f0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0105401:	5b                   	pop    %ebx
f0105402:	5d                   	pop    %ebp
f0105403:	c3                   	ret    

f0105404 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105404:	55                   	push   %ebp
f0105405:	89 e5                	mov    %esp,%ebp
f0105407:	53                   	push   %ebx
f0105408:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f010540b:	53                   	push   %ebx
f010540c:	e8 9a ff ff ff       	call   f01053ab <strlen>
f0105411:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f0105414:	ff 75 0c             	pushl  0xc(%ebp)
f0105417:	01 d8                	add    %ebx,%eax
f0105419:	50                   	push   %eax
f010541a:	e8 c5 ff ff ff       	call   f01053e4 <strcpy>
	return dst;
}
f010541f:	89 d8                	mov    %ebx,%eax
f0105421:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105424:	c9                   	leave  
f0105425:	c3                   	ret    

f0105426 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105426:	55                   	push   %ebp
f0105427:	89 e5                	mov    %esp,%ebp
f0105429:	56                   	push   %esi
f010542a:	53                   	push   %ebx
f010542b:	8b 75 08             	mov    0x8(%ebp),%esi
f010542e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105431:	89 f3                	mov    %esi,%ebx
f0105433:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105436:	89 f2                	mov    %esi,%edx
f0105438:	eb 0f                	jmp    f0105449 <strncpy+0x23>
		*dst++ = *src;
f010543a:	83 c2 01             	add    $0x1,%edx
f010543d:	0f b6 01             	movzbl (%ecx),%eax
f0105440:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105443:	80 39 01             	cmpb   $0x1,(%ecx)
f0105446:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105449:	39 da                	cmp    %ebx,%edx
f010544b:	75 ed                	jne    f010543a <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f010544d:	89 f0                	mov    %esi,%eax
f010544f:	5b                   	pop    %ebx
f0105450:	5e                   	pop    %esi
f0105451:	5d                   	pop    %ebp
f0105452:	c3                   	ret    

f0105453 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105453:	55                   	push   %ebp
f0105454:	89 e5                	mov    %esp,%ebp
f0105456:	56                   	push   %esi
f0105457:	53                   	push   %ebx
f0105458:	8b 75 08             	mov    0x8(%ebp),%esi
f010545b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010545e:	8b 55 10             	mov    0x10(%ebp),%edx
f0105461:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105463:	85 d2                	test   %edx,%edx
f0105465:	74 21                	je     f0105488 <strlcpy+0x35>
f0105467:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f010546b:	89 f2                	mov    %esi,%edx
f010546d:	eb 09                	jmp    f0105478 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f010546f:	83 c2 01             	add    $0x1,%edx
f0105472:	83 c1 01             	add    $0x1,%ecx
f0105475:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0105478:	39 c2                	cmp    %eax,%edx
f010547a:	74 09                	je     f0105485 <strlcpy+0x32>
f010547c:	0f b6 19             	movzbl (%ecx),%ebx
f010547f:	84 db                	test   %bl,%bl
f0105481:	75 ec                	jne    f010546f <strlcpy+0x1c>
f0105483:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
f0105485:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105488:	29 f0                	sub    %esi,%eax
}
f010548a:	5b                   	pop    %ebx
f010548b:	5e                   	pop    %esi
f010548c:	5d                   	pop    %ebp
f010548d:	c3                   	ret    

f010548e <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010548e:	55                   	push   %ebp
f010548f:	89 e5                	mov    %esp,%ebp
f0105491:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105494:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105497:	eb 06                	jmp    f010549f <strcmp+0x11>
		p++, q++;
f0105499:	83 c1 01             	add    $0x1,%ecx
f010549c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f010549f:	0f b6 01             	movzbl (%ecx),%eax
f01054a2:	84 c0                	test   %al,%al
f01054a4:	74 04                	je     f01054aa <strcmp+0x1c>
f01054a6:	3a 02                	cmp    (%edx),%al
f01054a8:	74 ef                	je     f0105499 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f01054aa:	0f b6 c0             	movzbl %al,%eax
f01054ad:	0f b6 12             	movzbl (%edx),%edx
f01054b0:	29 d0                	sub    %edx,%eax
}
f01054b2:	5d                   	pop    %ebp
f01054b3:	c3                   	ret    

f01054b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01054b4:	55                   	push   %ebp
f01054b5:	89 e5                	mov    %esp,%ebp
f01054b7:	53                   	push   %ebx
f01054b8:	8b 45 08             	mov    0x8(%ebp),%eax
f01054bb:	8b 55 0c             	mov    0xc(%ebp),%edx
f01054be:	89 c3                	mov    %eax,%ebx
f01054c0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f01054c3:	eb 06                	jmp    f01054cb <strncmp+0x17>
		n--, p++, q++;
f01054c5:	83 c0 01             	add    $0x1,%eax
f01054c8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f01054cb:	39 d8                	cmp    %ebx,%eax
f01054cd:	74 15                	je     f01054e4 <strncmp+0x30>
f01054cf:	0f b6 08             	movzbl (%eax),%ecx
f01054d2:	84 c9                	test   %cl,%cl
f01054d4:	74 04                	je     f01054da <strncmp+0x26>
f01054d6:	3a 0a                	cmp    (%edx),%cl
f01054d8:	74 eb                	je     f01054c5 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01054da:	0f b6 00             	movzbl (%eax),%eax
f01054dd:	0f b6 12             	movzbl (%edx),%edx
f01054e0:	29 d0                	sub    %edx,%eax
f01054e2:	eb 05                	jmp    f01054e9 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f01054e4:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01054e9:	5b                   	pop    %ebx
f01054ea:	5d                   	pop    %ebp
f01054eb:	c3                   	ret    

f01054ec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01054ec:	55                   	push   %ebp
f01054ed:	89 e5                	mov    %esp,%ebp
f01054ef:	8b 45 08             	mov    0x8(%ebp),%eax
f01054f2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01054f6:	eb 07                	jmp    f01054ff <strchr+0x13>
		if (*s == c)
f01054f8:	38 ca                	cmp    %cl,%dl
f01054fa:	74 0f                	je     f010550b <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f01054fc:	83 c0 01             	add    $0x1,%eax
f01054ff:	0f b6 10             	movzbl (%eax),%edx
f0105502:	84 d2                	test   %dl,%dl
f0105504:	75 f2                	jne    f01054f8 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
f0105506:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010550b:	5d                   	pop    %ebp
f010550c:	c3                   	ret    

f010550d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010550d:	55                   	push   %ebp
f010550e:	89 e5                	mov    %esp,%ebp
f0105510:	8b 45 08             	mov    0x8(%ebp),%eax
f0105513:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105517:	eb 03                	jmp    f010551c <strfind+0xf>
f0105519:	83 c0 01             	add    $0x1,%eax
f010551c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f010551f:	38 ca                	cmp    %cl,%dl
f0105521:	74 04                	je     f0105527 <strfind+0x1a>
f0105523:	84 d2                	test   %dl,%dl
f0105525:	75 f2                	jne    f0105519 <strfind+0xc>
			break;
	return (char *) s;
}
f0105527:	5d                   	pop    %ebp
f0105528:	c3                   	ret    

f0105529 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105529:	55                   	push   %ebp
f010552a:	89 e5                	mov    %esp,%ebp
f010552c:	57                   	push   %edi
f010552d:	56                   	push   %esi
f010552e:	53                   	push   %ebx
f010552f:	8b 55 08             	mov    0x8(%ebp),%edx
f0105532:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
f0105535:	85 c9                	test   %ecx,%ecx
f0105537:	74 37                	je     f0105570 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105539:	f6 c2 03             	test   $0x3,%dl
f010553c:	75 2a                	jne    f0105568 <memset+0x3f>
f010553e:	f6 c1 03             	test   $0x3,%cl
f0105541:	75 25                	jne    f0105568 <memset+0x3f>
		c &= 0xFF;
f0105543:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105547:	89 df                	mov    %ebx,%edi
f0105549:	c1 e7 08             	shl    $0x8,%edi
f010554c:	89 de                	mov    %ebx,%esi
f010554e:	c1 e6 18             	shl    $0x18,%esi
f0105551:	89 d8                	mov    %ebx,%eax
f0105553:	c1 e0 10             	shl    $0x10,%eax
f0105556:	09 f0                	or     %esi,%eax
f0105558:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
f010555a:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f010555d:	89 f8                	mov    %edi,%eax
f010555f:	09 d8                	or     %ebx,%eax
f0105561:	89 d7                	mov    %edx,%edi
f0105563:	fc                   	cld    
f0105564:	f3 ab                	rep stos %eax,%es:(%edi)
f0105566:	eb 08                	jmp    f0105570 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105568:	89 d7                	mov    %edx,%edi
f010556a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010556d:	fc                   	cld    
f010556e:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
f0105570:	89 d0                	mov    %edx,%eax
f0105572:	5b                   	pop    %ebx
f0105573:	5e                   	pop    %esi
f0105574:	5f                   	pop    %edi
f0105575:	5d                   	pop    %ebp
f0105576:	c3                   	ret    

f0105577 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105577:	55                   	push   %ebp
f0105578:	89 e5                	mov    %esp,%ebp
f010557a:	57                   	push   %edi
f010557b:	56                   	push   %esi
f010557c:	8b 45 08             	mov    0x8(%ebp),%eax
f010557f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105582:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105585:	39 c6                	cmp    %eax,%esi
f0105587:	73 35                	jae    f01055be <memmove+0x47>
f0105589:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010558c:	39 d0                	cmp    %edx,%eax
f010558e:	73 2e                	jae    f01055be <memmove+0x47>
		s += n;
		d += n;
f0105590:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105593:	89 d6                	mov    %edx,%esi
f0105595:	09 fe                	or     %edi,%esi
f0105597:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010559d:	75 13                	jne    f01055b2 <memmove+0x3b>
f010559f:	f6 c1 03             	test   $0x3,%cl
f01055a2:	75 0e                	jne    f01055b2 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
f01055a4:	83 ef 04             	sub    $0x4,%edi
f01055a7:	8d 72 fc             	lea    -0x4(%edx),%esi
f01055aa:	c1 e9 02             	shr    $0x2,%ecx
f01055ad:	fd                   	std    
f01055ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01055b0:	eb 09                	jmp    f01055bb <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f01055b2:	83 ef 01             	sub    $0x1,%edi
f01055b5:	8d 72 ff             	lea    -0x1(%edx),%esi
f01055b8:	fd                   	std    
f01055b9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01055bb:	fc                   	cld    
f01055bc:	eb 1d                	jmp    f01055db <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01055be:	89 f2                	mov    %esi,%edx
f01055c0:	09 c2                	or     %eax,%edx
f01055c2:	f6 c2 03             	test   $0x3,%dl
f01055c5:	75 0f                	jne    f01055d6 <memmove+0x5f>
f01055c7:	f6 c1 03             	test   $0x3,%cl
f01055ca:	75 0a                	jne    f01055d6 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
f01055cc:	c1 e9 02             	shr    $0x2,%ecx
f01055cf:	89 c7                	mov    %eax,%edi
f01055d1:	fc                   	cld    
f01055d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01055d4:	eb 05                	jmp    f01055db <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f01055d6:	89 c7                	mov    %eax,%edi
f01055d8:	fc                   	cld    
f01055d9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f01055db:	5e                   	pop    %esi
f01055dc:	5f                   	pop    %edi
f01055dd:	5d                   	pop    %ebp
f01055de:	c3                   	ret    

f01055df <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01055df:	55                   	push   %ebp
f01055e0:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f01055e2:	ff 75 10             	pushl  0x10(%ebp)
f01055e5:	ff 75 0c             	pushl  0xc(%ebp)
f01055e8:	ff 75 08             	pushl  0x8(%ebp)
f01055eb:	e8 87 ff ff ff       	call   f0105577 <memmove>
}
f01055f0:	c9                   	leave  
f01055f1:	c3                   	ret    

f01055f2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01055f2:	55                   	push   %ebp
f01055f3:	89 e5                	mov    %esp,%ebp
f01055f5:	56                   	push   %esi
f01055f6:	53                   	push   %ebx
f01055f7:	8b 45 08             	mov    0x8(%ebp),%eax
f01055fa:	8b 55 0c             	mov    0xc(%ebp),%edx
f01055fd:	89 c6                	mov    %eax,%esi
f01055ff:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105602:	eb 1a                	jmp    f010561e <memcmp+0x2c>
		if (*s1 != *s2)
f0105604:	0f b6 08             	movzbl (%eax),%ecx
f0105607:	0f b6 1a             	movzbl (%edx),%ebx
f010560a:	38 d9                	cmp    %bl,%cl
f010560c:	74 0a                	je     f0105618 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
f010560e:	0f b6 c1             	movzbl %cl,%eax
f0105611:	0f b6 db             	movzbl %bl,%ebx
f0105614:	29 d8                	sub    %ebx,%eax
f0105616:	eb 0f                	jmp    f0105627 <memcmp+0x35>
		s1++, s2++;
f0105618:	83 c0 01             	add    $0x1,%eax
f010561b:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010561e:	39 f0                	cmp    %esi,%eax
f0105620:	75 e2                	jne    f0105604 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f0105622:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105627:	5b                   	pop    %ebx
f0105628:	5e                   	pop    %esi
f0105629:	5d                   	pop    %ebp
f010562a:	c3                   	ret    

f010562b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f010562b:	55                   	push   %ebp
f010562c:	89 e5                	mov    %esp,%ebp
f010562e:	53                   	push   %ebx
f010562f:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f0105632:	89 c1                	mov    %eax,%ecx
f0105634:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
f0105637:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f010563b:	eb 0a                	jmp    f0105647 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
f010563d:	0f b6 10             	movzbl (%eax),%edx
f0105640:	39 da                	cmp    %ebx,%edx
f0105642:	74 07                	je     f010564b <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f0105644:	83 c0 01             	add    $0x1,%eax
f0105647:	39 c8                	cmp    %ecx,%eax
f0105649:	72 f2                	jb     f010563d <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f010564b:	5b                   	pop    %ebx
f010564c:	5d                   	pop    %ebp
f010564d:	c3                   	ret    

f010564e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f010564e:	55                   	push   %ebp
f010564f:	89 e5                	mov    %esp,%ebp
f0105651:	57                   	push   %edi
f0105652:	56                   	push   %esi
f0105653:	53                   	push   %ebx
f0105654:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105657:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010565a:	eb 03                	jmp    f010565f <strtol+0x11>
		s++;
f010565c:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010565f:	0f b6 01             	movzbl (%ecx),%eax
f0105662:	3c 20                	cmp    $0x20,%al
f0105664:	74 f6                	je     f010565c <strtol+0xe>
f0105666:	3c 09                	cmp    $0x9,%al
f0105668:	74 f2                	je     f010565c <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
f010566a:	3c 2b                	cmp    $0x2b,%al
f010566c:	75 0a                	jne    f0105678 <strtol+0x2a>
		s++;
f010566e:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0105671:	bf 00 00 00 00       	mov    $0x0,%edi
f0105676:	eb 11                	jmp    f0105689 <strtol+0x3b>
f0105678:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f010567d:	3c 2d                	cmp    $0x2d,%al
f010567f:	75 08                	jne    f0105689 <strtol+0x3b>
		s++, neg = 1;
f0105681:	83 c1 01             	add    $0x1,%ecx
f0105684:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105689:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f010568f:	75 15                	jne    f01056a6 <strtol+0x58>
f0105691:	80 39 30             	cmpb   $0x30,(%ecx)
f0105694:	75 10                	jne    f01056a6 <strtol+0x58>
f0105696:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010569a:	75 7c                	jne    f0105718 <strtol+0xca>
		s += 2, base = 16;
f010569c:	83 c1 02             	add    $0x2,%ecx
f010569f:	bb 10 00 00 00       	mov    $0x10,%ebx
f01056a4:	eb 16                	jmp    f01056bc <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
f01056a6:	85 db                	test   %ebx,%ebx
f01056a8:	75 12                	jne    f01056bc <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01056aa:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f01056af:	80 39 30             	cmpb   $0x30,(%ecx)
f01056b2:	75 08                	jne    f01056bc <strtol+0x6e>
		s++, base = 8;
f01056b4:	83 c1 01             	add    $0x1,%ecx
f01056b7:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
f01056bc:	b8 00 00 00 00       	mov    $0x0,%eax
f01056c1:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f01056c4:	0f b6 11             	movzbl (%ecx),%edx
f01056c7:	8d 72 d0             	lea    -0x30(%edx),%esi
f01056ca:	89 f3                	mov    %esi,%ebx
f01056cc:	80 fb 09             	cmp    $0x9,%bl
f01056cf:	77 08                	ja     f01056d9 <strtol+0x8b>
			dig = *s - '0';
f01056d1:	0f be d2             	movsbl %dl,%edx
f01056d4:	83 ea 30             	sub    $0x30,%edx
f01056d7:	eb 22                	jmp    f01056fb <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
f01056d9:	8d 72 9f             	lea    -0x61(%edx),%esi
f01056dc:	89 f3                	mov    %esi,%ebx
f01056de:	80 fb 19             	cmp    $0x19,%bl
f01056e1:	77 08                	ja     f01056eb <strtol+0x9d>
			dig = *s - 'a' + 10;
f01056e3:	0f be d2             	movsbl %dl,%edx
f01056e6:	83 ea 57             	sub    $0x57,%edx
f01056e9:	eb 10                	jmp    f01056fb <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
f01056eb:	8d 72 bf             	lea    -0x41(%edx),%esi
f01056ee:	89 f3                	mov    %esi,%ebx
f01056f0:	80 fb 19             	cmp    $0x19,%bl
f01056f3:	77 16                	ja     f010570b <strtol+0xbd>
			dig = *s - 'A' + 10;
f01056f5:	0f be d2             	movsbl %dl,%edx
f01056f8:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
f01056fb:	3b 55 10             	cmp    0x10(%ebp),%edx
f01056fe:	7d 0b                	jge    f010570b <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
f0105700:	83 c1 01             	add    $0x1,%ecx
f0105703:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105707:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
f0105709:	eb b9                	jmp    f01056c4 <strtol+0x76>

	if (endptr)
f010570b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010570f:	74 0d                	je     f010571e <strtol+0xd0>
		*endptr = (char *) s;
f0105711:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105714:	89 0e                	mov    %ecx,(%esi)
f0105716:	eb 06                	jmp    f010571e <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0105718:	85 db                	test   %ebx,%ebx
f010571a:	74 98                	je     f01056b4 <strtol+0x66>
f010571c:	eb 9e                	jmp    f01056bc <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
f010571e:	89 c2                	mov    %eax,%edx
f0105720:	f7 da                	neg    %edx
f0105722:	85 ff                	test   %edi,%edi
f0105724:	0f 45 c2             	cmovne %edx,%eax
}
f0105727:	5b                   	pop    %ebx
f0105728:	5e                   	pop    %esi
f0105729:	5f                   	pop    %edi
f010572a:	5d                   	pop    %ebp
f010572b:	c3                   	ret    

f010572c <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f010572c:	fa                   	cli    

	xorw    %ax, %ax
f010572d:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f010572f:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105731:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105733:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105735:	0f 01 16             	lgdtl  (%esi)
f0105738:	7c 70                	jl     f01057aa <gdtdesc+0x2>
	movl    %cr0, %eax
f010573a:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f010573d:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105741:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105744:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f010574a:	08 00                	or     %al,(%eax)

f010574c <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f010574c:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105750:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105752:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105754:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105756:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f010575a:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f010575c:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f010575e:	b8 00 00 12 00       	mov    $0x120000,%eax
	movl    %eax, %cr3
f0105763:	0f 22 d8             	mov    %eax,%cr3

	# Habilito el soporte para large pages
	movl	%cr4, %ecx
f0105766:	0f 20 e1             	mov    %cr4,%ecx
	orl	$(CR4_PSE), %ecx
f0105769:	83 c9 10             	or     $0x10,%ecx
	movl	%ecx, %cr4
f010576c:	0f 22 e1             	mov    %ecx,%cr4

	# Turn on paging.
	movl    %cr0, %eax
f010576f:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105772:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105777:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f010577a:	8b 25 84 ae 21 f0    	mov    0xf021ae84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105780:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105785:	b8 4d 02 10 f0       	mov    $0xf010024d,%eax
	call    *%eax
f010578a:	ff d0                	call   *%eax

f010578c <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f010578c:	eb fe                	jmp    f010578c <spin>
f010578e:	66 90                	xchg   %ax,%ax

f0105790 <gdt>:
	...
f0105798:	ff                   	(bad)  
f0105799:	ff 00                	incl   (%eax)
f010579b:	00 00                	add    %al,(%eax)
f010579d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f01057a4:	00                   	.byte 0x0
f01057a5:	92                   	xchg   %eax,%edx
f01057a6:	cf                   	iret   
	...

f01057a8 <gdtdesc>:
f01057a8:	17                   	pop    %ss
f01057a9:	00 64 70 00          	add    %ah,0x0(%eax,%esi,2)
	...

f01057ae <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f01057ae:	90                   	nop

f01057af <inb>:
	asm volatile("int3");
}

static inline uint8_t
inb(int port)
{
f01057af:	55                   	push   %ebp
f01057b0:	89 e5                	mov    %esp,%ebp
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01057b2:	89 c2                	mov    %eax,%edx
f01057b4:	ec                   	in     (%dx),%al
	return data;
}
f01057b5:	5d                   	pop    %ebp
f01057b6:	c3                   	ret    

f01057b7 <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
f01057b7:	55                   	push   %ebp
f01057b8:	89 e5                	mov    %esp,%ebp
f01057ba:	89 c1                	mov    %eax,%ecx
f01057bc:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01057be:	89 ca                	mov    %ecx,%edx
f01057c0:	ee                   	out    %al,(%dx)
}
f01057c1:	5d                   	pop    %ebp
f01057c2:	c3                   	ret    

f01057c3 <sum>:
#define MPIOINTR  0x03  // One per bus interrupt source
#define MPLINTR   0x04  // One per system interrupt source

static uint8_t
sum(void *addr, int len)
{
f01057c3:	55                   	push   %ebp
f01057c4:	89 e5                	mov    %esp,%ebp
f01057c6:	56                   	push   %esi
f01057c7:	53                   	push   %ebx
	int i, sum;

	sum = 0;
f01057c8:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++)
f01057cd:	b9 00 00 00 00       	mov    $0x0,%ecx
f01057d2:	eb 09                	jmp    f01057dd <sum+0x1a>
		sum += ((uint8_t *)addr)[i];
f01057d4:	0f b6 34 08          	movzbl (%eax,%ecx,1),%esi
f01057d8:	01 f3                	add    %esi,%ebx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f01057da:	83 c1 01             	add    $0x1,%ecx
f01057dd:	39 d1                	cmp    %edx,%ecx
f01057df:	7c f3                	jl     f01057d4 <sum+0x11>
		sum += ((uint8_t *)addr)[i];
	return sum;
}
f01057e1:	89 d8                	mov    %ebx,%eax
f01057e3:	5b                   	pop    %ebx
f01057e4:	5e                   	pop    %esi
f01057e5:	5d                   	pop    %ebp
f01057e6:	c3                   	ret    

f01057e7 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f01057e7:	55                   	push   %ebp
f01057e8:	89 e5                	mov    %esp,%ebp
f01057ea:	53                   	push   %ebx
f01057eb:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f01057ee:	89 cb                	mov    %ecx,%ebx
f01057f0:	c1 eb 0c             	shr    $0xc,%ebx
f01057f3:	3b 1d 88 ae 21 f0    	cmp    0xf021ae88,%ebx
f01057f9:	72 0d                	jb     f0105808 <_kaddr+0x21>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01057fb:	51                   	push   %ecx
f01057fc:	68 ac 62 10 f0       	push   $0xf01062ac
f0105801:	52                   	push   %edx
f0105802:	50                   	push   %eax
f0105803:	e8 6a a8 ff ff       	call   f0100072 <_panic>
	return (void *)(pa + KERNBASE);
f0105808:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f010580e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105811:	c9                   	leave  
f0105812:	c3                   	ret    

f0105813 <mpsearch1>:

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105813:	55                   	push   %ebp
f0105814:	89 e5                	mov    %esp,%ebp
f0105816:	57                   	push   %edi
f0105817:	56                   	push   %esi
f0105818:	53                   	push   %ebx
f0105819:	83 ec 0c             	sub    $0xc,%esp
f010581c:	89 c6                	mov    %eax,%esi
f010581e:	89 d7                	mov    %edx,%edi
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105820:	89 c1                	mov    %eax,%ecx
f0105822:	ba 57 00 00 00       	mov    $0x57,%edx
f0105827:	b8 5d 7e 10 f0       	mov    $0xf0107e5d,%eax
f010582c:	e8 b6 ff ff ff       	call   f01057e7 <_kaddr>
f0105831:	89 c3                	mov    %eax,%ebx
f0105833:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
f0105836:	ba 57 00 00 00       	mov    $0x57,%edx
f010583b:	b8 5d 7e 10 f0       	mov    $0xf0107e5d,%eax
f0105840:	e8 a2 ff ff ff       	call   f01057e7 <_kaddr>
f0105845:	89 c6                	mov    %eax,%esi

	for (; mp < end; mp++)
f0105847:	eb 2a                	jmp    f0105873 <mpsearch1+0x60>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105849:	83 ec 04             	sub    $0x4,%esp
f010584c:	6a 04                	push   $0x4
f010584e:	68 6d 7e 10 f0       	push   $0xf0107e6d
f0105853:	53                   	push   %ebx
f0105854:	e8 99 fd ff ff       	call   f01055f2 <memcmp>
f0105859:	83 c4 10             	add    $0x10,%esp
f010585c:	85 c0                	test   %eax,%eax
f010585e:	75 10                	jne    f0105870 <mpsearch1+0x5d>
		    sum(mp, sizeof(*mp)) == 0)
f0105860:	ba 10 00 00 00       	mov    $0x10,%edx
f0105865:	89 d8                	mov    %ebx,%eax
f0105867:	e8 57 ff ff ff       	call   f01057c3 <sum>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010586c:	84 c0                	test   %al,%al
f010586e:	74 0e                	je     f010587e <mpsearch1+0x6b>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0105870:	83 c3 10             	add    $0x10,%ebx
f0105873:	39 f3                	cmp    %esi,%ebx
f0105875:	72 d2                	jb     f0105849 <mpsearch1+0x36>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105877:	b8 00 00 00 00       	mov    $0x0,%eax
f010587c:	eb 02                	jmp    f0105880 <mpsearch1+0x6d>
f010587e:	89 d8                	mov    %ebx,%eax
}
f0105880:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105883:	5b                   	pop    %ebx
f0105884:	5e                   	pop    %esi
f0105885:	5f                   	pop    %edi
f0105886:	5d                   	pop    %ebp
f0105887:	c3                   	ret    

f0105888 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) if there is no EBDA, in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp *
mpsearch(void)
{
f0105888:	55                   	push   %ebp
f0105889:	89 e5                	mov    %esp,%ebp
f010588b:	83 ec 08             	sub    $0x8,%esp
	struct mp *mp;

	static_assert(sizeof(*mp) == 16);

	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);
f010588e:	b9 00 04 00 00       	mov    $0x400,%ecx
f0105893:	ba 6f 00 00 00       	mov    $0x6f,%edx
f0105898:	b8 5d 7e 10 f0       	mov    $0xf0107e5d,%eax
f010589d:	e8 45 ff ff ff       	call   f01057e7 <_kaddr>

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01058a2:	0f b7 50 0e          	movzwl 0xe(%eax),%edx
f01058a6:	85 d2                	test   %edx,%edx
f01058a8:	74 17                	je     f01058c1 <mpsearch+0x39>
		p <<= 4;	// Translate from segment to PA
		if ((mp = mpsearch1(p, 1024)))
f01058aa:	89 d0                	mov    %edx,%eax
f01058ac:	c1 e0 04             	shl    $0x4,%eax
f01058af:	ba 00 04 00 00       	mov    $0x400,%edx
f01058b4:	e8 5a ff ff ff       	call   f0105813 <mpsearch1>
			return mp;
f01058b9:	89 c2                	mov    %eax,%edx

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
		p <<= 4;	// Translate from segment to PA
		if ((mp = mpsearch1(p, 1024)))
f01058bb:	85 c0                	test   %eax,%eax
f01058bd:	75 2f                	jne    f01058ee <mpsearch+0x66>
f01058bf:	eb 1c                	jmp    f01058dd <mpsearch+0x55>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
		if ((mp = mpsearch1(p - 1024, 1024)))
f01058c1:	0f b7 40 13          	movzwl 0x13(%eax),%eax
f01058c5:	c1 e0 0a             	shl    $0xa,%eax
f01058c8:	2d 00 04 00 00       	sub    $0x400,%eax
f01058cd:	ba 00 04 00 00       	mov    $0x400,%edx
f01058d2:	e8 3c ff ff ff       	call   f0105813 <mpsearch1>
			return mp;
f01058d7:	89 c2                	mov    %eax,%edx
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
		if ((mp = mpsearch1(p - 1024, 1024)))
f01058d9:	85 c0                	test   %eax,%eax
f01058db:	75 11                	jne    f01058ee <mpsearch+0x66>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f01058dd:	ba 00 00 01 00       	mov    $0x10000,%edx
f01058e2:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f01058e7:	e8 27 ff ff ff       	call   f0105813 <mpsearch1>
f01058ec:	89 c2                	mov    %eax,%edx
}
f01058ee:	89 d0                	mov    %edx,%eax
f01058f0:	c9                   	leave  
f01058f1:	c3                   	ret    

f01058f2 <mpconfig>:
// Search for an MP configuration table.  For now, don't accept the
// default configurations (physaddr == 0).
// Check for the correct signature, checksum, and version.
static struct mpconf *
mpconfig(struct mp **pmp)
{
f01058f2:	55                   	push   %ebp
f01058f3:	89 e5                	mov    %esp,%ebp
f01058f5:	57                   	push   %edi
f01058f6:	56                   	push   %esi
f01058f7:	53                   	push   %ebx
f01058f8:	83 ec 1c             	sub    $0x1c,%esp
f01058fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f01058fe:	e8 85 ff ff ff       	call   f0105888 <mpsearch>
f0105903:	85 c0                	test   %eax,%eax
f0105905:	0f 84 ee 00 00 00    	je     f01059f9 <mpconfig+0x107>
f010590b:	89 c7                	mov    %eax,%edi
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f010590d:	8b 48 04             	mov    0x4(%eax),%ecx
f0105910:	85 c9                	test   %ecx,%ecx
f0105912:	74 06                	je     f010591a <mpconfig+0x28>
f0105914:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105918:	74 1a                	je     f0105934 <mpconfig+0x42>
		cprintf("SMP: Default configurations not implemented\n");
f010591a:	83 ec 0c             	sub    $0xc,%esp
f010591d:	68 d0 7c 10 f0       	push   $0xf0107cd0
f0105922:	e8 34 de ff ff       	call   f010375b <cprintf>
		return NULL;
f0105927:	83 c4 10             	add    $0x10,%esp
f010592a:	b8 00 00 00 00       	mov    $0x0,%eax
f010592f:	e9 ca 00 00 00       	jmp    f01059fe <mpconfig+0x10c>
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
f0105934:	ba 90 00 00 00       	mov    $0x90,%edx
f0105939:	b8 5d 7e 10 f0       	mov    $0xf0107e5d,%eax
f010593e:	e8 a4 fe ff ff       	call   f01057e7 <_kaddr>
f0105943:	89 c3                	mov    %eax,%ebx
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105945:	83 ec 04             	sub    $0x4,%esp
f0105948:	6a 04                	push   $0x4
f010594a:	68 72 7e 10 f0       	push   $0xf0107e72
f010594f:	50                   	push   %eax
f0105950:	e8 9d fc ff ff       	call   f01055f2 <memcmp>
f0105955:	83 c4 10             	add    $0x10,%esp
f0105958:	85 c0                	test   %eax,%eax
f010595a:	74 1a                	je     f0105976 <mpconfig+0x84>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f010595c:	83 ec 0c             	sub    $0xc,%esp
f010595f:	68 00 7d 10 f0       	push   $0xf0107d00
f0105964:	e8 f2 dd ff ff       	call   f010375b <cprintf>
		return NULL;
f0105969:	83 c4 10             	add    $0x10,%esp
f010596c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105971:	e9 88 00 00 00       	jmp    f01059fe <mpconfig+0x10c>
	}
	if (sum(conf, conf->length) != 0) {
f0105976:	0f b7 73 04          	movzwl 0x4(%ebx),%esi
f010597a:	0f b7 d6             	movzwl %si,%edx
f010597d:	89 d8                	mov    %ebx,%eax
f010597f:	e8 3f fe ff ff       	call   f01057c3 <sum>
f0105984:	84 c0                	test   %al,%al
f0105986:	74 17                	je     f010599f <mpconfig+0xad>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105988:	83 ec 0c             	sub    $0xc,%esp
f010598b:	68 34 7d 10 f0       	push   $0xf0107d34
f0105990:	e8 c6 dd ff ff       	call   f010375b <cprintf>
		return NULL;
f0105995:	83 c4 10             	add    $0x10,%esp
f0105998:	b8 00 00 00 00       	mov    $0x0,%eax
f010599d:	eb 5f                	jmp    f01059fe <mpconfig+0x10c>
	}
	if (conf->version != 1 && conf->version != 4) {
f010599f:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f01059a3:	3c 01                	cmp    $0x1,%al
f01059a5:	74 1f                	je     f01059c6 <mpconfig+0xd4>
f01059a7:	3c 04                	cmp    $0x4,%al
f01059a9:	74 1b                	je     f01059c6 <mpconfig+0xd4>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f01059ab:	83 ec 08             	sub    $0x8,%esp
f01059ae:	0f b6 c0             	movzbl %al,%eax
f01059b1:	50                   	push   %eax
f01059b2:	68 58 7d 10 f0       	push   $0xf0107d58
f01059b7:	e8 9f dd ff ff       	call   f010375b <cprintf>
		return NULL;
f01059bc:	83 c4 10             	add    $0x10,%esp
f01059bf:	b8 00 00 00 00       	mov    $0x0,%eax
f01059c4:	eb 38                	jmp    f01059fe <mpconfig+0x10c>
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f01059c6:	0f b7 53 28          	movzwl 0x28(%ebx),%edx
f01059ca:	0f b7 c6             	movzwl %si,%eax
f01059cd:	01 d8                	add    %ebx,%eax
f01059cf:	e8 ef fd ff ff       	call   f01057c3 <sum>
f01059d4:	02 43 2a             	add    0x2a(%ebx),%al
f01059d7:	74 17                	je     f01059f0 <mpconfig+0xfe>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f01059d9:	83 ec 0c             	sub    $0xc,%esp
f01059dc:	68 78 7d 10 f0       	push   $0xf0107d78
f01059e1:	e8 75 dd ff ff       	call   f010375b <cprintf>
		return NULL;
f01059e6:	83 c4 10             	add    $0x10,%esp
f01059e9:	b8 00 00 00 00       	mov    $0x0,%eax
f01059ee:	eb 0e                	jmp    f01059fe <mpconfig+0x10c>
	}
	*pmp = mp;
f01059f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01059f3:	89 38                	mov    %edi,(%eax)
	return conf;
f01059f5:	89 d8                	mov    %ebx,%eax
f01059f7:	eb 05                	jmp    f01059fe <mpconfig+0x10c>
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
		return NULL;
f01059f9:	b8 00 00 00 00       	mov    $0x0,%eax
		cprintf("SMP: Bad MP configuration extended checksum\n");
		return NULL;
	}
	*pmp = mp;
	return conf;
}
f01059fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105a01:	5b                   	pop    %ebx
f0105a02:	5e                   	pop    %esi
f0105a03:	5f                   	pop    %edi
f0105a04:	5d                   	pop    %ebp
f0105a05:	c3                   	ret    

f0105a06 <mp_init>:

void
mp_init(void)
{
f0105a06:	55                   	push   %ebp
f0105a07:	89 e5                	mov    %esp,%ebp
f0105a09:	57                   	push   %edi
f0105a0a:	56                   	push   %esi
f0105a0b:	53                   	push   %ebx
f0105a0c:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105a0f:	c7 05 c0 b3 21 f0 20 	movl   $0xf021b020,0xf021b3c0
f0105a16:	b0 21 f0 
	if ((conf = mpconfig(&mp)) == 0)
f0105a19:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105a1c:	e8 d1 fe ff ff       	call   f01058f2 <mpconfig>
f0105a21:	85 c0                	test   %eax,%eax
f0105a23:	0f 84 49 01 00 00    	je     f0105b72 <mp_init+0x16c>
f0105a29:	89 c7                	mov    %eax,%edi
		return;
	ismp = 1;
f0105a2b:	c7 05 00 b0 21 f0 01 	movl   $0x1,0xf021b000
f0105a32:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105a35:	8b 40 24             	mov    0x24(%eax),%eax
f0105a38:	a3 00 c0 25 f0       	mov    %eax,0xf025c000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105a3d:	8d 77 2c             	lea    0x2c(%edi),%esi
f0105a40:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105a45:	e9 85 00 00 00       	jmp    f0105acf <mp_init+0xc9>
		switch (*p) {
f0105a4a:	0f b6 06             	movzbl (%esi),%eax
f0105a4d:	84 c0                	test   %al,%al
f0105a4f:	74 06                	je     f0105a57 <mp_init+0x51>
f0105a51:	3c 04                	cmp    $0x4,%al
f0105a53:	77 55                	ja     f0105aaa <mp_init+0xa4>
f0105a55:	eb 4e                	jmp    f0105aa5 <mp_init+0x9f>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105a57:	f6 46 03 02          	testb  $0x2,0x3(%esi)
f0105a5b:	74 11                	je     f0105a6e <mp_init+0x68>
				bootcpu = &cpus[ncpu];
f0105a5d:	6b 05 c4 b3 21 f0 74 	imul   $0x74,0xf021b3c4,%eax
f0105a64:	05 20 b0 21 f0       	add    $0xf021b020,%eax
f0105a69:	a3 c0 b3 21 f0       	mov    %eax,0xf021b3c0
			if (ncpu < NCPU) {
f0105a6e:	a1 c4 b3 21 f0       	mov    0xf021b3c4,%eax
f0105a73:	83 f8 07             	cmp    $0x7,%eax
f0105a76:	7f 13                	jg     f0105a8b <mp_init+0x85>
				cpus[ncpu].cpu_id = ncpu;
f0105a78:	6b d0 74             	imul   $0x74,%eax,%edx
f0105a7b:	88 82 20 b0 21 f0    	mov    %al,-0xfde4fe0(%edx)
				ncpu++;
f0105a81:	83 c0 01             	add    $0x1,%eax
f0105a84:	a3 c4 b3 21 f0       	mov    %eax,0xf021b3c4
f0105a89:	eb 15                	jmp    f0105aa0 <mp_init+0x9a>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105a8b:	83 ec 08             	sub    $0x8,%esp
f0105a8e:	0f b6 46 01          	movzbl 0x1(%esi),%eax
f0105a92:	50                   	push   %eax
f0105a93:	68 a8 7d 10 f0       	push   $0xf0107da8
f0105a98:	e8 be dc ff ff       	call   f010375b <cprintf>
f0105a9d:	83 c4 10             	add    $0x10,%esp
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105aa0:	83 c6 14             	add    $0x14,%esi
			continue;
f0105aa3:	eb 27                	jmp    f0105acc <mp_init+0xc6>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105aa5:	83 c6 08             	add    $0x8,%esi
			continue;
f0105aa8:	eb 22                	jmp    f0105acc <mp_init+0xc6>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105aaa:	83 ec 08             	sub    $0x8,%esp
f0105aad:	0f b6 c0             	movzbl %al,%eax
f0105ab0:	50                   	push   %eax
f0105ab1:	68 d0 7d 10 f0       	push   $0xf0107dd0
f0105ab6:	e8 a0 dc ff ff       	call   f010375b <cprintf>
			ismp = 0;
f0105abb:	c7 05 00 b0 21 f0 00 	movl   $0x0,0xf021b000
f0105ac2:	00 00 00 
			i = conf->entry;
f0105ac5:	0f b7 5f 22          	movzwl 0x22(%edi),%ebx
f0105ac9:	83 c4 10             	add    $0x10,%esp
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105acc:	83 c3 01             	add    $0x1,%ebx
f0105acf:	0f b7 47 22          	movzwl 0x22(%edi),%eax
f0105ad3:	39 c3                	cmp    %eax,%ebx
f0105ad5:	0f 82 6f ff ff ff    	jb     f0105a4a <mp_init+0x44>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105adb:	a1 c0 b3 21 f0       	mov    0xf021b3c0,%eax
f0105ae0:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105ae7:	83 3d 00 b0 21 f0 00 	cmpl   $0x0,0xf021b000
f0105aee:	75 26                	jne    f0105b16 <mp_init+0x110>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0105af0:	c7 05 c4 b3 21 f0 01 	movl   $0x1,0xf021b3c4
f0105af7:	00 00 00 
		lapicaddr = 0;
f0105afa:	c7 05 00 c0 25 f0 00 	movl   $0x0,0xf025c000
f0105b01:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105b04:	83 ec 0c             	sub    $0xc,%esp
f0105b07:	68 f0 7d 10 f0       	push   $0xf0107df0
f0105b0c:	e8 4a dc ff ff       	call   f010375b <cprintf>
		return;
f0105b11:	83 c4 10             	add    $0x10,%esp
f0105b14:	eb 5c                	jmp    f0105b72 <mp_init+0x16c>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105b16:	83 ec 04             	sub    $0x4,%esp
f0105b19:	ff 35 c4 b3 21 f0    	pushl  0xf021b3c4
f0105b1f:	0f b6 00             	movzbl (%eax),%eax
f0105b22:	50                   	push   %eax
f0105b23:	68 77 7e 10 f0       	push   $0xf0107e77
f0105b28:	e8 2e dc ff ff       	call   f010375b <cprintf>

	if (mp->imcrp) {
f0105b2d:	83 c4 10             	add    $0x10,%esp
f0105b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b33:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105b37:	74 39                	je     f0105b72 <mp_init+0x16c>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105b39:	83 ec 0c             	sub    $0xc,%esp
f0105b3c:	68 1c 7e 10 f0       	push   $0xf0107e1c
f0105b41:	e8 15 dc ff ff       	call   f010375b <cprintf>
		outb(0x22, 0x70);   // Select IMCR
f0105b46:	ba 70 00 00 00       	mov    $0x70,%edx
f0105b4b:	b8 22 00 00 00       	mov    $0x22,%eax
f0105b50:	e8 62 fc ff ff       	call   f01057b7 <outb>
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105b55:	b8 23 00 00 00       	mov    $0x23,%eax
f0105b5a:	e8 50 fc ff ff       	call   f01057af <inb>
f0105b5f:	83 c8 01             	or     $0x1,%eax
f0105b62:	0f b6 d0             	movzbl %al,%edx
f0105b65:	b8 23 00 00 00       	mov    $0x23,%eax
f0105b6a:	e8 48 fc ff ff       	call   f01057b7 <outb>
f0105b6f:	83 c4 10             	add    $0x10,%esp
	}
}
f0105b72:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b75:	5b                   	pop    %ebx
f0105b76:	5e                   	pop    %esi
f0105b77:	5f                   	pop    %edi
f0105b78:	5d                   	pop    %ebp
f0105b79:	c3                   	ret    

f0105b7a <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
f0105b7a:	55                   	push   %ebp
f0105b7b:	89 e5                	mov    %esp,%ebp
f0105b7d:	89 c1                	mov    %eax,%ecx
f0105b7f:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105b81:	89 ca                	mov    %ecx,%edx
f0105b83:	ee                   	out    %al,(%dx)
}
f0105b84:	5d                   	pop    %ebp
f0105b85:	c3                   	ret    

f0105b86 <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0105b86:	55                   	push   %ebp
f0105b87:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0105b89:	8b 0d 04 c0 25 f0    	mov    0xf025c004,%ecx
f0105b8f:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105b92:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105b94:	a1 04 c0 25 f0       	mov    0xf025c004,%eax
f0105b99:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105b9c:	5d                   	pop    %ebp
f0105b9d:	c3                   	ret    

f0105b9e <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0105b9e:	55                   	push   %ebp
f0105b9f:	89 e5                	mov    %esp,%ebp
f0105ba1:	53                   	push   %ebx
f0105ba2:	83 ec 04             	sub    $0x4,%esp
	if (PGNUM(pa) >= npages)
f0105ba5:	89 cb                	mov    %ecx,%ebx
f0105ba7:	c1 eb 0c             	shr    $0xc,%ebx
f0105baa:	3b 1d 88 ae 21 f0    	cmp    0xf021ae88,%ebx
f0105bb0:	72 0d                	jb     f0105bbf <_kaddr+0x21>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105bb2:	51                   	push   %ecx
f0105bb3:	68 ac 62 10 f0       	push   $0xf01062ac
f0105bb8:	52                   	push   %edx
f0105bb9:	50                   	push   %eax
f0105bba:	e8 b3 a4 ff ff       	call   f0100072 <_panic>
	return (void *)(pa + KERNBASE);
f0105bbf:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0105bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105bc8:	c9                   	leave  
f0105bc9:	c3                   	ret    

f0105bca <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105bca:	55                   	push   %ebp
f0105bcb:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0105bcd:	a1 04 c0 25 f0       	mov    0xf025c004,%eax
f0105bd2:	85 c0                	test   %eax,%eax
f0105bd4:	74 08                	je     f0105bde <cpunum+0x14>
		return lapic[ID] >> 24;
f0105bd6:	8b 40 20             	mov    0x20(%eax),%eax
f0105bd9:	c1 e8 18             	shr    $0x18,%eax
f0105bdc:	eb 05                	jmp    f0105be3 <cpunum+0x19>
	return 0;
f0105bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105be3:	5d                   	pop    %ebp
f0105be4:	c3                   	ret    

f0105be5 <lapic_init>:
}

void
lapic_init(void)
{
	if (!lapicaddr)
f0105be5:	a1 00 c0 25 f0       	mov    0xf025c000,%eax
f0105bea:	85 c0                	test   %eax,%eax
f0105bec:	0f 84 21 01 00 00    	je     f0105d13 <lapic_init+0x12e>
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f0105bf2:	55                   	push   %ebp
f0105bf3:	89 e5                	mov    %esp,%ebp
f0105bf5:	83 ec 10             	sub    $0x10,%esp
	if (!lapicaddr)
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	lapic = mmio_map_region(lapicaddr, 4096);
f0105bf8:	68 00 10 00 00       	push   $0x1000
f0105bfd:	50                   	push   %eax
f0105bfe:	e8 8c c1 ff ff       	call   f0101d8f <mmio_map_region>
f0105c03:	a3 04 c0 25 f0       	mov    %eax,0xf025c004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105c08:	ba 27 01 00 00       	mov    $0x127,%edx
f0105c0d:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105c12:	e8 6f ff ff ff       	call   f0105b86 <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f0105c17:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105c1c:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105c21:	e8 60 ff ff ff       	call   f0105b86 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105c26:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105c2b:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105c30:	e8 51 ff ff ff       	call   f0105b86 <lapicw>
	lapicw(TICR, 10000000); 
f0105c35:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105c3a:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105c3f:	e8 42 ff ff ff       	call   f0105b86 <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f0105c44:	e8 81 ff ff ff       	call   f0105bca <cpunum>
f0105c49:	6b c0 74             	imul   $0x74,%eax,%eax
f0105c4c:	05 20 b0 21 f0       	add    $0xf021b020,%eax
f0105c51:	83 c4 10             	add    $0x10,%esp
f0105c54:	39 05 c0 b3 21 f0    	cmp    %eax,0xf021b3c0
f0105c5a:	74 0f                	je     f0105c6b <lapic_init+0x86>
		lapicw(LINT0, MASKED);
f0105c5c:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c61:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105c66:	e8 1b ff ff ff       	call   f0105b86 <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f0105c6b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c70:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105c75:	e8 0c ff ff ff       	call   f0105b86 <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105c7a:	a1 04 c0 25 f0       	mov    0xf025c004,%eax
f0105c7f:	8b 40 30             	mov    0x30(%eax),%eax
f0105c82:	c1 e8 10             	shr    $0x10,%eax
f0105c85:	3c 03                	cmp    $0x3,%al
f0105c87:	76 0f                	jbe    f0105c98 <lapic_init+0xb3>
		lapicw(PCINT, MASKED);
f0105c89:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c8e:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105c93:	e8 ee fe ff ff       	call   f0105b86 <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105c98:	ba 33 00 00 00       	mov    $0x33,%edx
f0105c9d:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105ca2:	e8 df fe ff ff       	call   f0105b86 <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f0105ca7:	ba 00 00 00 00       	mov    $0x0,%edx
f0105cac:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105cb1:	e8 d0 fe ff ff       	call   f0105b86 <lapicw>
	lapicw(ESR, 0);
f0105cb6:	ba 00 00 00 00       	mov    $0x0,%edx
f0105cbb:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105cc0:	e8 c1 fe ff ff       	call   f0105b86 <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f0105cc5:	ba 00 00 00 00       	mov    $0x0,%edx
f0105cca:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105ccf:	e8 b2 fe ff ff       	call   f0105b86 <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f0105cd4:	ba 00 00 00 00       	mov    $0x0,%edx
f0105cd9:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105cde:	e8 a3 fe ff ff       	call   f0105b86 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105ce3:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105ce8:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ced:	e8 94 fe ff ff       	call   f0105b86 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105cf2:	8b 15 04 c0 25 f0    	mov    0xf025c004,%edx
f0105cf8:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105cfe:	f6 c4 10             	test   $0x10,%ah
f0105d01:	75 f5                	jne    f0105cf8 <lapic_init+0x113>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f0105d03:	ba 00 00 00 00       	mov    $0x0,%edx
f0105d08:	b8 20 00 00 00       	mov    $0x20,%eax
f0105d0d:	e8 74 fe ff ff       	call   f0105b86 <lapicw>
}
f0105d12:	c9                   	leave  
f0105d13:	f3 c3                	repz ret 

f0105d15 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0105d15:	83 3d 04 c0 25 f0 00 	cmpl   $0x0,0xf025c004
f0105d1c:	74 13                	je     f0105d31 <lapic_eoi+0x1c>
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0105d1e:	55                   	push   %ebp
f0105d1f:	89 e5                	mov    %esp,%ebp
	if (lapic)
		lapicw(EOI, 0);
f0105d21:	ba 00 00 00 00       	mov    $0x0,%edx
f0105d26:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105d2b:	e8 56 fe ff ff       	call   f0105b86 <lapicw>
}
f0105d30:	5d                   	pop    %ebp
f0105d31:	f3 c3                	repz ret 

f0105d33 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105d33:	55                   	push   %ebp
f0105d34:	89 e5                	mov    %esp,%ebp
f0105d36:	56                   	push   %esi
f0105d37:	53                   	push   %ebx
f0105d38:	8b 75 08             	mov    0x8(%ebp),%esi
f0105d3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	uint16_t *wrv;

	// "The BSP must initialize CMOS shutdown code to 0AH
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
f0105d3e:	ba 0f 00 00 00       	mov    $0xf,%edx
f0105d43:	b8 70 00 00 00       	mov    $0x70,%eax
f0105d48:	e8 2d fe ff ff       	call   f0105b7a <outb>
	outb(IO_RTC+1, 0x0A);
f0105d4d:	ba 0a 00 00 00       	mov    $0xa,%edx
f0105d52:	b8 71 00 00 00       	mov    $0x71,%eax
f0105d57:	e8 1e fe ff ff       	call   f0105b7a <outb>
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
f0105d5c:	b9 67 04 00 00       	mov    $0x467,%ecx
f0105d61:	ba 98 00 00 00       	mov    $0x98,%edx
f0105d66:	b8 94 7e 10 f0       	mov    $0xf0107e94,%eax
f0105d6b:	e8 2e fe ff ff       	call   f0105b9e <_kaddr>
	wrv[0] = 0;
f0105d70:	66 c7 00 00 00       	movw   $0x0,(%eax)
	wrv[1] = addr >> 4;
f0105d75:	89 da                	mov    %ebx,%edx
f0105d77:	c1 ea 04             	shr    $0x4,%edx
f0105d7a:	66 89 50 02          	mov    %dx,0x2(%eax)

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0105d7e:	c1 e6 18             	shl    $0x18,%esi
f0105d81:	89 f2                	mov    %esi,%edx
f0105d83:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105d88:	e8 f9 fd ff ff       	call   f0105b86 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105d8d:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0105d92:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105d97:	e8 ea fd ff ff       	call   f0105b86 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0105d9c:	ba 00 85 00 00       	mov    $0x8500,%edx
f0105da1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105da6:	e8 db fd ff ff       	call   f0105b86 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105dab:	c1 eb 0c             	shr    $0xc,%ebx
f0105dae:	80 cf 06             	or     $0x6,%bh
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0105db1:	89 f2                	mov    %esi,%edx
f0105db3:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105db8:	e8 c9 fd ff ff       	call   f0105b86 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105dbd:	89 da                	mov    %ebx,%edx
f0105dbf:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105dc4:	e8 bd fd ff ff       	call   f0105b86 <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0105dc9:	89 f2                	mov    %esi,%edx
f0105dcb:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105dd0:	e8 b1 fd ff ff       	call   f0105b86 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105dd5:	89 da                	mov    %ebx,%edx
f0105dd7:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ddc:	e8 a5 fd ff ff       	call   f0105b86 <lapicw>
		microdelay(200);
	}
}
f0105de1:	5b                   	pop    %ebx
f0105de2:	5e                   	pop    %esi
f0105de3:	5d                   	pop    %ebp
f0105de4:	c3                   	ret    

f0105de5 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0105de5:	55                   	push   %ebp
f0105de6:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0105de8:	8b 55 08             	mov    0x8(%ebp),%edx
f0105deb:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0105df1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105df6:	e8 8b fd ff ff       	call   f0105b86 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0105dfb:	8b 15 04 c0 25 f0    	mov    0xf025c004,%edx
f0105e01:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105e07:	f6 c4 10             	test   $0x10,%ah
f0105e0a:	75 f5                	jne    f0105e01 <lapic_ipi+0x1c>
		;
}
f0105e0c:	5d                   	pop    %ebp
f0105e0d:	c3                   	ret    

f0105e0e <xchg>:
	return tsc;
}

static inline uint32_t
xchg(volatile uint32_t *addr, uint32_t newval)
{
f0105e0e:	55                   	push   %ebp
f0105e0f:	89 e5                	mov    %esp,%ebp
f0105e11:	89 c1                	mov    %eax,%ecx
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0105e13:	89 d0                	mov    %edx,%eax
f0105e15:	f0 87 01             	lock xchg %eax,(%ecx)
		     : "+m" (*addr), "=a" (result)
		     : "1" (newval)
		     : "cc");
	return result;
}
f0105e18:	5d                   	pop    %ebp
f0105e19:	c3                   	ret    

f0105e1a <get_caller_pcs>:

#ifdef DEBUG_SPINLOCK
// Record the current call stack in pcs[] by following the %ebp chain.
static void
get_caller_pcs(uint32_t pcs[])
{
f0105e1a:	55                   	push   %ebp
f0105e1b:	89 e5                	mov    %esp,%ebp
f0105e1d:	53                   	push   %ebx

static inline uint32_t __attribute__((always_inline))
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0105e1e:	89 e9                	mov    %ebp,%ecx
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0105e20:	ba 00 00 00 00       	mov    $0x0,%edx
f0105e25:	eb 0b                	jmp    f0105e32 <get_caller_pcs+0x18>
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
f0105e27:	8b 59 04             	mov    0x4(%ecx),%ebx
f0105e2a:	89 1c 90             	mov    %ebx,(%eax,%edx,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0105e2d:	8b 09                	mov    (%ecx),%ecx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0105e2f:	83 c2 01             	add    $0x1,%edx
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0105e32:	81 f9 ff ff 7f ef    	cmp    $0xef7fffff,%ecx
f0105e38:	76 11                	jbe    f0105e4b <get_caller_pcs+0x31>
f0105e3a:	83 fa 09             	cmp    $0x9,%edx
f0105e3d:	7e e8                	jle    f0105e27 <get_caller_pcs+0xd>
f0105e3f:	eb 0a                	jmp    f0105e4b <get_caller_pcs+0x31>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f0105e41:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0105e48:	83 c2 01             	add    $0x1,%edx
f0105e4b:	83 fa 09             	cmp    $0x9,%edx
f0105e4e:	7e f1                	jle    f0105e41 <get_caller_pcs+0x27>
		pcs[i] = 0;
}
f0105e50:	5b                   	pop    %ebx
f0105e51:	5d                   	pop    %ebp
f0105e52:	c3                   	ret    

f0105e53 <holding>:

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0105e53:	83 38 00             	cmpl   $0x0,(%eax)
f0105e56:	74 21                	je     f0105e79 <holding+0x26>
}

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
f0105e58:	55                   	push   %ebp
f0105e59:	89 e5                	mov    %esp,%ebp
f0105e5b:	53                   	push   %ebx
f0105e5c:	83 ec 04             	sub    $0x4,%esp
	return lock->locked && lock->cpu == thiscpu;
f0105e5f:	8b 58 08             	mov    0x8(%eax),%ebx
f0105e62:	e8 63 fd ff ff       	call   f0105bca <cpunum>
f0105e67:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e6a:	05 20 b0 21 f0       	add    $0xf021b020,%eax
f0105e6f:	39 c3                	cmp    %eax,%ebx
f0105e71:	0f 94 c0             	sete   %al
f0105e74:	0f b6 c0             	movzbl %al,%eax
f0105e77:	eb 06                	jmp    f0105e7f <holding+0x2c>
f0105e79:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e7e:	c3                   	ret    
}
f0105e7f:	83 c4 04             	add    $0x4,%esp
f0105e82:	5b                   	pop    %ebx
f0105e83:	5d                   	pop    %ebp
f0105e84:	c3                   	ret    

f0105e85 <__spin_initlock>:
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0105e85:	55                   	push   %ebp
f0105e86:	89 e5                	mov    %esp,%ebp
f0105e88:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0105e8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0105e91:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105e94:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0105e97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0105e9e:	5d                   	pop    %ebp
f0105e9f:	c3                   	ret    

f0105ea0 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0105ea0:	55                   	push   %ebp
f0105ea1:	89 e5                	mov    %esp,%ebp
f0105ea3:	53                   	push   %ebx
f0105ea4:	83 ec 04             	sub    $0x4,%esp
f0105ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0105eaa:	89 d8                	mov    %ebx,%eax
f0105eac:	e8 a2 ff ff ff       	call   f0105e53 <holding>
f0105eb1:	85 c0                	test   %eax,%eax
f0105eb3:	74 20                	je     f0105ed5 <spin_lock+0x35>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0105eb5:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0105eb8:	e8 0d fd ff ff       	call   f0105bca <cpunum>
f0105ebd:	83 ec 0c             	sub    $0xc,%esp
f0105ec0:	53                   	push   %ebx
f0105ec1:	50                   	push   %eax
f0105ec2:	68 a4 7e 10 f0       	push   $0xf0107ea4
f0105ec7:	6a 41                	push   $0x41
f0105ec9:	68 08 7f 10 f0       	push   $0xf0107f08
f0105ece:	e8 9f a1 ff ff       	call   f0100072 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0105ed3:	f3 90                	pause  
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0105ed5:	ba 01 00 00 00       	mov    $0x1,%edx
f0105eda:	89 d8                	mov    %ebx,%eax
f0105edc:	e8 2d ff ff ff       	call   f0105e0e <xchg>
f0105ee1:	85 c0                	test   %eax,%eax
f0105ee3:	75 ee                	jne    f0105ed3 <spin_lock+0x33>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0105ee5:	e8 e0 fc ff ff       	call   f0105bca <cpunum>
f0105eea:	6b c0 74             	imul   $0x74,%eax,%eax
f0105eed:	05 20 b0 21 f0       	add    $0xf021b020,%eax
f0105ef2:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0105ef5:	8d 43 0c             	lea    0xc(%ebx),%eax
f0105ef8:	e8 1d ff ff ff       	call   f0105e1a <get_caller_pcs>
#endif
}
f0105efd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105f00:	c9                   	leave  
f0105f01:	c3                   	ret    

f0105f02 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0105f02:	55                   	push   %ebp
f0105f03:	89 e5                	mov    %esp,%ebp
f0105f05:	57                   	push   %edi
f0105f06:	56                   	push   %esi
f0105f07:	53                   	push   %ebx
f0105f08:	83 ec 4c             	sub    $0x4c,%esp
f0105f0b:	8b 75 08             	mov    0x8(%ebp),%esi
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f0105f0e:	89 f0                	mov    %esi,%eax
f0105f10:	e8 3e ff ff ff       	call   f0105e53 <holding>
f0105f15:	85 c0                	test   %eax,%eax
f0105f17:	0f 85 a5 00 00 00    	jne    f0105fc2 <spin_unlock+0xc0>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0105f1d:	83 ec 04             	sub    $0x4,%esp
f0105f20:	6a 28                	push   $0x28
f0105f22:	8d 46 0c             	lea    0xc(%esi),%eax
f0105f25:	50                   	push   %eax
f0105f26:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0105f29:	53                   	push   %ebx
f0105f2a:	e8 48 f6 ff ff       	call   f0105577 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0105f2f:	8b 46 08             	mov    0x8(%esi),%eax
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0105f32:	0f b6 38             	movzbl (%eax),%edi
f0105f35:	8b 76 04             	mov    0x4(%esi),%esi
f0105f38:	e8 8d fc ff ff       	call   f0105bca <cpunum>
f0105f3d:	57                   	push   %edi
f0105f3e:	56                   	push   %esi
f0105f3f:	50                   	push   %eax
f0105f40:	68 d0 7e 10 f0       	push   $0xf0107ed0
f0105f45:	e8 11 d8 ff ff       	call   f010375b <cprintf>
f0105f4a:	83 c4 20             	add    $0x20,%esp
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0105f4d:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0105f50:	eb 54                	jmp    f0105fa6 <spin_unlock+0xa4>
f0105f52:	83 ec 08             	sub    $0x8,%esp
f0105f55:	57                   	push   %edi
f0105f56:	50                   	push   %eax
f0105f57:	e8 58 eb ff ff       	call   f0104ab4 <debuginfo_eip>
f0105f5c:	83 c4 10             	add    $0x10,%esp
f0105f5f:	85 c0                	test   %eax,%eax
f0105f61:	78 27                	js     f0105f8a <spin_unlock+0x88>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f0105f63:	8b 06                	mov    (%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0105f65:	83 ec 04             	sub    $0x4,%esp
f0105f68:	89 c2                	mov    %eax,%edx
f0105f6a:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0105f6d:	52                   	push   %edx
f0105f6e:	ff 75 b0             	pushl  -0x50(%ebp)
f0105f71:	ff 75 b4             	pushl  -0x4c(%ebp)
f0105f74:	ff 75 ac             	pushl  -0x54(%ebp)
f0105f77:	ff 75 a8             	pushl  -0x58(%ebp)
f0105f7a:	50                   	push   %eax
f0105f7b:	68 18 7f 10 f0       	push   $0xf0107f18
f0105f80:	e8 d6 d7 ff ff       	call   f010375b <cprintf>
f0105f85:	83 c4 20             	add    $0x20,%esp
f0105f88:	eb 12                	jmp    f0105f9c <spin_unlock+0x9a>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f0105f8a:	83 ec 08             	sub    $0x8,%esp
f0105f8d:	ff 36                	pushl  (%esi)
f0105f8f:	68 2f 7f 10 f0       	push   $0xf0107f2f
f0105f94:	e8 c2 d7 ff ff       	call   f010375b <cprintf>
f0105f99:	83 c4 10             	add    $0x10,%esp
f0105f9c:	83 c3 04             	add    $0x4,%ebx
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0105f9f:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0105fa2:	39 c3                	cmp    %eax,%ebx
f0105fa4:	74 08                	je     f0105fae <spin_unlock+0xac>
f0105fa6:	89 de                	mov    %ebx,%esi
f0105fa8:	8b 03                	mov    (%ebx),%eax
f0105faa:	85 c0                	test   %eax,%eax
f0105fac:	75 a4                	jne    f0105f52 <spin_unlock+0x50>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f0105fae:	83 ec 04             	sub    $0x4,%esp
f0105fb1:	68 37 7f 10 f0       	push   $0xf0107f37
f0105fb6:	6a 67                	push   $0x67
f0105fb8:	68 08 7f 10 f0       	push   $0xf0107f08
f0105fbd:	e8 b0 a0 ff ff       	call   f0100072 <_panic>
	}

	lk->pcs[0] = 0;
f0105fc2:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0105fc9:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	// The xchg instruction is atomic (i.e. uses the "lock" prefix) with
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
f0105fd0:	ba 00 00 00 00       	mov    $0x0,%edx
f0105fd5:	89 f0                	mov    %esi,%eax
f0105fd7:	e8 32 fe ff ff       	call   f0105e0e <xchg>
}
f0105fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105fdf:	5b                   	pop    %ebx
f0105fe0:	5e                   	pop    %esi
f0105fe1:	5f                   	pop    %edi
f0105fe2:	5d                   	pop    %ebp
f0105fe3:	c3                   	ret    
f0105fe4:	66 90                	xchg   %ax,%ax
f0105fe6:	66 90                	xchg   %ax,%ax
f0105fe8:	66 90                	xchg   %ax,%ax
f0105fea:	66 90                	xchg   %ax,%ax
f0105fec:	66 90                	xchg   %ax,%ax
f0105fee:	66 90                	xchg   %ax,%ax

f0105ff0 <__udivdi3>:
f0105ff0:	55                   	push   %ebp
f0105ff1:	57                   	push   %edi
f0105ff2:	56                   	push   %esi
f0105ff3:	53                   	push   %ebx
f0105ff4:	83 ec 1c             	sub    $0x1c,%esp
f0105ff7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
f0105ffb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
f0105fff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
f0106003:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106007:	85 f6                	test   %esi,%esi
f0106009:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010600d:	89 ca                	mov    %ecx,%edx
f010600f:	89 f8                	mov    %edi,%eax
f0106011:	75 3d                	jne    f0106050 <__udivdi3+0x60>
f0106013:	39 cf                	cmp    %ecx,%edi
f0106015:	0f 87 c5 00 00 00    	ja     f01060e0 <__udivdi3+0xf0>
f010601b:	85 ff                	test   %edi,%edi
f010601d:	89 fd                	mov    %edi,%ebp
f010601f:	75 0b                	jne    f010602c <__udivdi3+0x3c>
f0106021:	b8 01 00 00 00       	mov    $0x1,%eax
f0106026:	31 d2                	xor    %edx,%edx
f0106028:	f7 f7                	div    %edi
f010602a:	89 c5                	mov    %eax,%ebp
f010602c:	89 c8                	mov    %ecx,%eax
f010602e:	31 d2                	xor    %edx,%edx
f0106030:	f7 f5                	div    %ebp
f0106032:	89 c1                	mov    %eax,%ecx
f0106034:	89 d8                	mov    %ebx,%eax
f0106036:	89 cf                	mov    %ecx,%edi
f0106038:	f7 f5                	div    %ebp
f010603a:	89 c3                	mov    %eax,%ebx
f010603c:	89 d8                	mov    %ebx,%eax
f010603e:	89 fa                	mov    %edi,%edx
f0106040:	83 c4 1c             	add    $0x1c,%esp
f0106043:	5b                   	pop    %ebx
f0106044:	5e                   	pop    %esi
f0106045:	5f                   	pop    %edi
f0106046:	5d                   	pop    %ebp
f0106047:	c3                   	ret    
f0106048:	90                   	nop
f0106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106050:	39 ce                	cmp    %ecx,%esi
f0106052:	77 74                	ja     f01060c8 <__udivdi3+0xd8>
f0106054:	0f bd fe             	bsr    %esi,%edi
f0106057:	83 f7 1f             	xor    $0x1f,%edi
f010605a:	0f 84 98 00 00 00    	je     f01060f8 <__udivdi3+0x108>
f0106060:	bb 20 00 00 00       	mov    $0x20,%ebx
f0106065:	89 f9                	mov    %edi,%ecx
f0106067:	89 c5                	mov    %eax,%ebp
f0106069:	29 fb                	sub    %edi,%ebx
f010606b:	d3 e6                	shl    %cl,%esi
f010606d:	89 d9                	mov    %ebx,%ecx
f010606f:	d3 ed                	shr    %cl,%ebp
f0106071:	89 f9                	mov    %edi,%ecx
f0106073:	d3 e0                	shl    %cl,%eax
f0106075:	09 ee                	or     %ebp,%esi
f0106077:	89 d9                	mov    %ebx,%ecx
f0106079:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010607d:	89 d5                	mov    %edx,%ebp
f010607f:	8b 44 24 08          	mov    0x8(%esp),%eax
f0106083:	d3 ed                	shr    %cl,%ebp
f0106085:	89 f9                	mov    %edi,%ecx
f0106087:	d3 e2                	shl    %cl,%edx
f0106089:	89 d9                	mov    %ebx,%ecx
f010608b:	d3 e8                	shr    %cl,%eax
f010608d:	09 c2                	or     %eax,%edx
f010608f:	89 d0                	mov    %edx,%eax
f0106091:	89 ea                	mov    %ebp,%edx
f0106093:	f7 f6                	div    %esi
f0106095:	89 d5                	mov    %edx,%ebp
f0106097:	89 c3                	mov    %eax,%ebx
f0106099:	f7 64 24 0c          	mull   0xc(%esp)
f010609d:	39 d5                	cmp    %edx,%ebp
f010609f:	72 10                	jb     f01060b1 <__udivdi3+0xc1>
f01060a1:	8b 74 24 08          	mov    0x8(%esp),%esi
f01060a5:	89 f9                	mov    %edi,%ecx
f01060a7:	d3 e6                	shl    %cl,%esi
f01060a9:	39 c6                	cmp    %eax,%esi
f01060ab:	73 07                	jae    f01060b4 <__udivdi3+0xc4>
f01060ad:	39 d5                	cmp    %edx,%ebp
f01060af:	75 03                	jne    f01060b4 <__udivdi3+0xc4>
f01060b1:	83 eb 01             	sub    $0x1,%ebx
f01060b4:	31 ff                	xor    %edi,%edi
f01060b6:	89 d8                	mov    %ebx,%eax
f01060b8:	89 fa                	mov    %edi,%edx
f01060ba:	83 c4 1c             	add    $0x1c,%esp
f01060bd:	5b                   	pop    %ebx
f01060be:	5e                   	pop    %esi
f01060bf:	5f                   	pop    %edi
f01060c0:	5d                   	pop    %ebp
f01060c1:	c3                   	ret    
f01060c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01060c8:	31 ff                	xor    %edi,%edi
f01060ca:	31 db                	xor    %ebx,%ebx
f01060cc:	89 d8                	mov    %ebx,%eax
f01060ce:	89 fa                	mov    %edi,%edx
f01060d0:	83 c4 1c             	add    $0x1c,%esp
f01060d3:	5b                   	pop    %ebx
f01060d4:	5e                   	pop    %esi
f01060d5:	5f                   	pop    %edi
f01060d6:	5d                   	pop    %ebp
f01060d7:	c3                   	ret    
f01060d8:	90                   	nop
f01060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01060e0:	89 d8                	mov    %ebx,%eax
f01060e2:	f7 f7                	div    %edi
f01060e4:	31 ff                	xor    %edi,%edi
f01060e6:	89 c3                	mov    %eax,%ebx
f01060e8:	89 d8                	mov    %ebx,%eax
f01060ea:	89 fa                	mov    %edi,%edx
f01060ec:	83 c4 1c             	add    $0x1c,%esp
f01060ef:	5b                   	pop    %ebx
f01060f0:	5e                   	pop    %esi
f01060f1:	5f                   	pop    %edi
f01060f2:	5d                   	pop    %ebp
f01060f3:	c3                   	ret    
f01060f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01060f8:	39 ce                	cmp    %ecx,%esi
f01060fa:	72 0c                	jb     f0106108 <__udivdi3+0x118>
f01060fc:	31 db                	xor    %ebx,%ebx
f01060fe:	3b 44 24 08          	cmp    0x8(%esp),%eax
f0106102:	0f 87 34 ff ff ff    	ja     f010603c <__udivdi3+0x4c>
f0106108:	bb 01 00 00 00       	mov    $0x1,%ebx
f010610d:	e9 2a ff ff ff       	jmp    f010603c <__udivdi3+0x4c>
f0106112:	66 90                	xchg   %ax,%ax
f0106114:	66 90                	xchg   %ax,%ax
f0106116:	66 90                	xchg   %ax,%ax
f0106118:	66 90                	xchg   %ax,%ax
f010611a:	66 90                	xchg   %ax,%ax
f010611c:	66 90                	xchg   %ax,%ax
f010611e:	66 90                	xchg   %ax,%ax

f0106120 <__umoddi3>:
f0106120:	55                   	push   %ebp
f0106121:	57                   	push   %edi
f0106122:	56                   	push   %esi
f0106123:	53                   	push   %ebx
f0106124:	83 ec 1c             	sub    $0x1c,%esp
f0106127:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010612b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
f010612f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106133:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106137:	85 d2                	test   %edx,%edx
f0106139:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f010613d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106141:	89 f3                	mov    %esi,%ebx
f0106143:	89 3c 24             	mov    %edi,(%esp)
f0106146:	89 74 24 04          	mov    %esi,0x4(%esp)
f010614a:	75 1c                	jne    f0106168 <__umoddi3+0x48>
f010614c:	39 f7                	cmp    %esi,%edi
f010614e:	76 50                	jbe    f01061a0 <__umoddi3+0x80>
f0106150:	89 c8                	mov    %ecx,%eax
f0106152:	89 f2                	mov    %esi,%edx
f0106154:	f7 f7                	div    %edi
f0106156:	89 d0                	mov    %edx,%eax
f0106158:	31 d2                	xor    %edx,%edx
f010615a:	83 c4 1c             	add    $0x1c,%esp
f010615d:	5b                   	pop    %ebx
f010615e:	5e                   	pop    %esi
f010615f:	5f                   	pop    %edi
f0106160:	5d                   	pop    %ebp
f0106161:	c3                   	ret    
f0106162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106168:	39 f2                	cmp    %esi,%edx
f010616a:	89 d0                	mov    %edx,%eax
f010616c:	77 52                	ja     f01061c0 <__umoddi3+0xa0>
f010616e:	0f bd ea             	bsr    %edx,%ebp
f0106171:	83 f5 1f             	xor    $0x1f,%ebp
f0106174:	75 5a                	jne    f01061d0 <__umoddi3+0xb0>
f0106176:	3b 54 24 04          	cmp    0x4(%esp),%edx
f010617a:	0f 82 e0 00 00 00    	jb     f0106260 <__umoddi3+0x140>
f0106180:	39 0c 24             	cmp    %ecx,(%esp)
f0106183:	0f 86 d7 00 00 00    	jbe    f0106260 <__umoddi3+0x140>
f0106189:	8b 44 24 08          	mov    0x8(%esp),%eax
f010618d:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106191:	83 c4 1c             	add    $0x1c,%esp
f0106194:	5b                   	pop    %ebx
f0106195:	5e                   	pop    %esi
f0106196:	5f                   	pop    %edi
f0106197:	5d                   	pop    %ebp
f0106198:	c3                   	ret    
f0106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01061a0:	85 ff                	test   %edi,%edi
f01061a2:	89 fd                	mov    %edi,%ebp
f01061a4:	75 0b                	jne    f01061b1 <__umoddi3+0x91>
f01061a6:	b8 01 00 00 00       	mov    $0x1,%eax
f01061ab:	31 d2                	xor    %edx,%edx
f01061ad:	f7 f7                	div    %edi
f01061af:	89 c5                	mov    %eax,%ebp
f01061b1:	89 f0                	mov    %esi,%eax
f01061b3:	31 d2                	xor    %edx,%edx
f01061b5:	f7 f5                	div    %ebp
f01061b7:	89 c8                	mov    %ecx,%eax
f01061b9:	f7 f5                	div    %ebp
f01061bb:	89 d0                	mov    %edx,%eax
f01061bd:	eb 99                	jmp    f0106158 <__umoddi3+0x38>
f01061bf:	90                   	nop
f01061c0:	89 c8                	mov    %ecx,%eax
f01061c2:	89 f2                	mov    %esi,%edx
f01061c4:	83 c4 1c             	add    $0x1c,%esp
f01061c7:	5b                   	pop    %ebx
f01061c8:	5e                   	pop    %esi
f01061c9:	5f                   	pop    %edi
f01061ca:	5d                   	pop    %ebp
f01061cb:	c3                   	ret    
f01061cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01061d0:	8b 34 24             	mov    (%esp),%esi
f01061d3:	bf 20 00 00 00       	mov    $0x20,%edi
f01061d8:	89 e9                	mov    %ebp,%ecx
f01061da:	29 ef                	sub    %ebp,%edi
f01061dc:	d3 e0                	shl    %cl,%eax
f01061de:	89 f9                	mov    %edi,%ecx
f01061e0:	89 f2                	mov    %esi,%edx
f01061e2:	d3 ea                	shr    %cl,%edx
f01061e4:	89 e9                	mov    %ebp,%ecx
f01061e6:	09 c2                	or     %eax,%edx
f01061e8:	89 d8                	mov    %ebx,%eax
f01061ea:	89 14 24             	mov    %edx,(%esp)
f01061ed:	89 f2                	mov    %esi,%edx
f01061ef:	d3 e2                	shl    %cl,%edx
f01061f1:	89 f9                	mov    %edi,%ecx
f01061f3:	89 54 24 04          	mov    %edx,0x4(%esp)
f01061f7:	8b 54 24 0c          	mov    0xc(%esp),%edx
f01061fb:	d3 e8                	shr    %cl,%eax
f01061fd:	89 e9                	mov    %ebp,%ecx
f01061ff:	89 c6                	mov    %eax,%esi
f0106201:	d3 e3                	shl    %cl,%ebx
f0106203:	89 f9                	mov    %edi,%ecx
f0106205:	89 d0                	mov    %edx,%eax
f0106207:	d3 e8                	shr    %cl,%eax
f0106209:	89 e9                	mov    %ebp,%ecx
f010620b:	09 d8                	or     %ebx,%eax
f010620d:	89 d3                	mov    %edx,%ebx
f010620f:	89 f2                	mov    %esi,%edx
f0106211:	f7 34 24             	divl   (%esp)
f0106214:	89 d6                	mov    %edx,%esi
f0106216:	d3 e3                	shl    %cl,%ebx
f0106218:	f7 64 24 04          	mull   0x4(%esp)
f010621c:	39 d6                	cmp    %edx,%esi
f010621e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0106222:	89 d1                	mov    %edx,%ecx
f0106224:	89 c3                	mov    %eax,%ebx
f0106226:	72 08                	jb     f0106230 <__umoddi3+0x110>
f0106228:	75 11                	jne    f010623b <__umoddi3+0x11b>
f010622a:	39 44 24 08          	cmp    %eax,0x8(%esp)
f010622e:	73 0b                	jae    f010623b <__umoddi3+0x11b>
f0106230:	2b 44 24 04          	sub    0x4(%esp),%eax
f0106234:	1b 14 24             	sbb    (%esp),%edx
f0106237:	89 d1                	mov    %edx,%ecx
f0106239:	89 c3                	mov    %eax,%ebx
f010623b:	8b 54 24 08          	mov    0x8(%esp),%edx
f010623f:	29 da                	sub    %ebx,%edx
f0106241:	19 ce                	sbb    %ecx,%esi
f0106243:	89 f9                	mov    %edi,%ecx
f0106245:	89 f0                	mov    %esi,%eax
f0106247:	d3 e0                	shl    %cl,%eax
f0106249:	89 e9                	mov    %ebp,%ecx
f010624b:	d3 ea                	shr    %cl,%edx
f010624d:	89 e9                	mov    %ebp,%ecx
f010624f:	d3 ee                	shr    %cl,%esi
f0106251:	09 d0                	or     %edx,%eax
f0106253:	89 f2                	mov    %esi,%edx
f0106255:	83 c4 1c             	add    $0x1c,%esp
f0106258:	5b                   	pop    %ebx
f0106259:	5e                   	pop    %esi
f010625a:	5f                   	pop    %edi
f010625b:	5d                   	pop    %ebp
f010625c:	c3                   	ret    
f010625d:	8d 76 00             	lea    0x0(%esi),%esi
f0106260:	29 f9                	sub    %edi,%ecx
f0106262:	19 d6                	sbb    %edx,%esi
f0106264:	89 74 24 04          	mov    %esi,0x4(%esp)
f0106268:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010626c:	e9 18 ff ff ff       	jmp    f0106189 <__umoddi3+0x69>
