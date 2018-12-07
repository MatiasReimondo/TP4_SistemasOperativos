
obj/fs/fs:     formato del fichero elf32-i386


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
  80002c:	e8 4e 1b 00 00       	call   801b7f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <inb>:
	asm volatile("int3");
}

static inline uint8_t
inb(int port)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800036:	89 c2                	mov    %eax,%edx
  800038:	ec                   	in     (%dx),%al
	return data;
}
  800039:	5d                   	pop    %ebp
  80003a:	c3                   	ret    

0080003b <insl>:
	return data;
}

static inline void
insl(int port, void *addr, int cnt)
{
  80003b:	55                   	push   %ebp
  80003c:	89 e5                	mov    %esp,%ebp
  80003e:	57                   	push   %edi
	asm volatile("cld\n\trepne\n\tinsl"
  80003f:	89 d7                	mov    %edx,%edi
  800041:	89 c2                	mov    %eax,%edx
  800043:	fc                   	cld    
  800044:	f2 6d                	repnz insl (%dx),%es:(%edi)
		     : "=D" (addr), "=c" (cnt)
		     : "d" (port), "0" (addr), "1" (cnt)
		     : "memory", "cc");
}
  800046:	5f                   	pop    %edi
  800047:	5d                   	pop    %ebp
  800048:	c3                   	ret    

00800049 <outb>:

static inline void
outb(int port, uint8_t data)
{
  800049:	55                   	push   %ebp
  80004a:	89 e5                	mov    %esp,%ebp
  80004c:	89 c1                	mov    %eax,%ecx
  80004e:	89 d0                	mov    %edx,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800050:	89 ca                	mov    %ecx,%edx
  800052:	ee                   	out    %al,(%dx)
}
  800053:	5d                   	pop    %ebp
  800054:	c3                   	ret    

00800055 <outsl>:
		     : "cc");
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	56                   	push   %esi
	asm volatile("cld\n\trepne\n\toutsl"
  800059:	89 d6                	mov    %edx,%esi
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	fc                   	cld    
  80005e:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
		     : "=S" (addr), "=c" (cnt)
		     : "d" (port), "0" (addr), "1" (cnt)
		     : "cc");
}
  800060:	5e                   	pop    %esi
  800061:	5d                   	pop    %ebp
  800062:	c3                   	ret    

00800063 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800063:	55                   	push   %ebp
  800064:	89 e5                	mov    %esp,%ebp
  800066:	53                   	push   %ebx
  800067:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800069:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  80006e:	e8 c0 ff ff ff       	call   800033 <inb>
  800073:	89 c2                	mov    %eax,%edx
  800075:	83 e2 c0             	and    $0xffffffc0,%edx
  800078:	80 fa 40             	cmp    $0x40,%dl
  80007b:	75 ec                	jne    800069 <ide_wait_ready+0x6>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  80007d:	ba 00 00 00 00       	mov    $0x0,%edx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800082:	84 db                	test   %bl,%bl
  800084:	74 0a                	je     800090 <ide_wait_ready+0x2d>
  800086:	a8 21                	test   $0x21,%al
  800088:	0f 95 c2             	setne  %dl
  80008b:	0f b6 d2             	movzbl %dl,%edx
  80008e:	f7 da                	neg    %edx
		return -1;
	return 0;
}
  800090:	89 d0                	mov    %edx,%eax
  800092:	5b                   	pop    %ebx
  800093:	5d                   	pop    %ebp
  800094:	c3                   	ret    

00800095 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800095:	55                   	push   %ebp
  800096:	89 e5                	mov    %esp,%ebp
  800098:	53                   	push   %ebx
  800099:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	e8 bd ff ff ff       	call   800063 <ide_wait_ready>

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));
  8000a6:	ba f0 00 00 00       	mov    $0xf0,%edx
  8000ab:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8000b0:	e8 94 ff ff ff       	call   800049 <outb>

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8000ba:	eb 0b                	jmp    8000c7 <ide_probe_disk1+0x32>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000bc:	83 c3 01             	add    $0x1,%ebx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000bf:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  8000c5:	74 0e                	je     8000d5 <ide_probe_disk1+0x40>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000c7:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  8000cc:	e8 62 ff ff ff       	call   800033 <inb>
  8000d1:	a8 a1                	test   $0xa1,%al
  8000d3:	75 e7                	jne    8000bc <ide_probe_disk1+0x27>
	     x++)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));
  8000d5:	ba e0 00 00 00       	mov    $0xe0,%edx
  8000da:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8000df:	e8 65 ff ff ff       	call   800049 <outb>

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000e4:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  8000ea:	0f 9e c3             	setle  %bl
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	0f b6 c3             	movzbl %bl,%eax
  8000f3:	50                   	push   %eax
  8000f4:	68 00 39 80 00       	push   $0x803900
  8000f9:	e8 be 1b 00 00       	call   801cbc <cprintf>
	return (x < 1000);
}
  8000fe:	89 d8                	mov    %ebx,%eax
  800100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800103:	c9                   	leave  
  800104:	c3                   	ret    

00800105 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800105:	55                   	push   %ebp
  800106:	89 e5                	mov    %esp,%ebp
  800108:	83 ec 08             	sub    $0x8,%esp
  80010b:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  80010e:	83 f8 01             	cmp    $0x1,%eax
  800111:	76 14                	jbe    800127 <ide_set_disk+0x22>
		panic("bad disk number");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 17 39 80 00       	push   $0x803917
  80011b:	6a 3a                	push   $0x3a
  80011d:	68 27 39 80 00       	push   $0x803927
  800122:	e8 bc 1a 00 00       	call   801be3 <_panic>
	diskno = d;
  800127:	a3 00 50 80 00       	mov    %eax,0x805000
}
  80012c:	c9                   	leave  
  80012d:	c3                   	ret    

0080012e <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	57                   	push   %edi
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	8b 7d 08             	mov    0x8(%ebp),%edi
  80013a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80013d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800140:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800146:	76 16                	jbe    80015e <ide_read+0x30>
  800148:	68 30 39 80 00       	push   $0x803930
  80014d:	68 3d 39 80 00       	push   $0x80393d
  800152:	6a 44                	push   $0x44
  800154:	68 27 39 80 00       	push   $0x803927
  800159:	e8 85 1a 00 00       	call   801be3 <_panic>

	ide_wait_ready(0);
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	e8 fb fe ff ff       	call   800063 <ide_wait_ready>

	outb(0x1F2, nsecs);
  800168:	89 f0                	mov    %esi,%eax
  80016a:	0f b6 d0             	movzbl %al,%edx
  80016d:	b8 f2 01 00 00       	mov    $0x1f2,%eax
  800172:	e8 d2 fe ff ff       	call   800049 <outb>
	outb(0x1F3, secno & 0xFF);
  800177:	89 f8                	mov    %edi,%eax
  800179:	0f b6 d0             	movzbl %al,%edx
  80017c:	b8 f3 01 00 00       	mov    $0x1f3,%eax
  800181:	e8 c3 fe ff ff       	call   800049 <outb>
	outb(0x1F4, (secno >> 8) & 0xFF);
  800186:	89 f8                	mov    %edi,%eax
  800188:	0f b6 d4             	movzbl %ah,%edx
  80018b:	b8 f4 01 00 00       	mov    $0x1f4,%eax
  800190:	e8 b4 fe ff ff       	call   800049 <outb>
	outb(0x1F5, (secno >> 16) & 0xFF);
  800195:	89 fa                	mov    %edi,%edx
  800197:	c1 ea 10             	shr    $0x10,%edx
  80019a:	0f b6 d2             	movzbl %dl,%edx
  80019d:	b8 f5 01 00 00       	mov    $0x1f5,%eax
  8001a2:	e8 a2 fe ff ff       	call   800049 <outb>
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8001a7:	0f b6 15 00 50 80 00 	movzbl 0x805000,%edx
  8001ae:	83 e2 01             	and    $0x1,%edx
  8001b1:	c1 e2 04             	shl    $0x4,%edx
  8001b4:	83 ca e0             	or     $0xffffffe0,%edx
  8001b7:	c1 ef 18             	shr    $0x18,%edi
  8001ba:	83 e7 0f             	and    $0xf,%edi
  8001bd:	09 fa                	or     %edi,%edx
  8001bf:	0f b6 d2             	movzbl %dl,%edx
  8001c2:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8001c7:	e8 7d fe ff ff       	call   800049 <outb>
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector
  8001cc:	ba 20 00 00 00       	mov    $0x20,%edx
  8001d1:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  8001d6:	e8 6e fe ff ff       	call   800049 <outb>
  8001db:	c1 e6 09             	shl    $0x9,%esi
  8001de:	01 de                	add    %ebx,%esi

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001e0:	eb 25                	jmp    800207 <ide_read+0xd9>
		if ((r = ide_wait_ready(1)) < 0)
  8001e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8001e7:	e8 77 fe ff ff       	call   800063 <ide_wait_ready>
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	78 20                	js     800210 <ide_read+0xe2>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
  8001f0:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001f5:	89 da                	mov    %ebx,%edx
  8001f7:	b8 f0 01 00 00       	mov    $0x1f0,%eax
  8001fc:	e8 3a fe ff ff       	call   80003b <insl>
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800201:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800207:	39 f3                	cmp    %esi,%ebx
  800209:	75 d7                	jne    8001e2 <ide_read+0xb4>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  80020b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	8b 7d 08             	mov    0x8(%ebp),%edi
  800224:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800227:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  80022a:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800230:	76 16                	jbe    800248 <ide_write+0x30>
  800232:	68 30 39 80 00       	push   $0x803930
  800237:	68 3d 39 80 00       	push   $0x80393d
  80023c:	6a 5d                	push   $0x5d
  80023e:	68 27 39 80 00       	push   $0x803927
  800243:	e8 9b 19 00 00       	call   801be3 <_panic>

	ide_wait_ready(0);
  800248:	b8 00 00 00 00       	mov    $0x0,%eax
  80024d:	e8 11 fe ff ff       	call   800063 <ide_wait_ready>

	outb(0x1F2, nsecs);
  800252:	89 f0                	mov    %esi,%eax
  800254:	0f b6 d0             	movzbl %al,%edx
  800257:	b8 f2 01 00 00       	mov    $0x1f2,%eax
  80025c:	e8 e8 fd ff ff       	call   800049 <outb>
	outb(0x1F3, secno & 0xFF);
  800261:	89 f8                	mov    %edi,%eax
  800263:	0f b6 d0             	movzbl %al,%edx
  800266:	b8 f3 01 00 00       	mov    $0x1f3,%eax
  80026b:	e8 d9 fd ff ff       	call   800049 <outb>
	outb(0x1F4, (secno >> 8) & 0xFF);
  800270:	89 f8                	mov    %edi,%eax
  800272:	0f b6 d4             	movzbl %ah,%edx
  800275:	b8 f4 01 00 00       	mov    $0x1f4,%eax
  80027a:	e8 ca fd ff ff       	call   800049 <outb>
	outb(0x1F5, (secno >> 16) & 0xFF);
  80027f:	89 fa                	mov    %edi,%edx
  800281:	c1 ea 10             	shr    $0x10,%edx
  800284:	0f b6 d2             	movzbl %dl,%edx
  800287:	b8 f5 01 00 00       	mov    $0x1f5,%eax
  80028c:	e8 b8 fd ff ff       	call   800049 <outb>
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800291:	0f b6 15 00 50 80 00 	movzbl 0x805000,%edx
  800298:	83 e2 01             	and    $0x1,%edx
  80029b:	c1 e2 04             	shl    $0x4,%edx
  80029e:	83 ca e0             	or     $0xffffffe0,%edx
  8002a1:	c1 ef 18             	shr    $0x18,%edi
  8002a4:	83 e7 0f             	and    $0xf,%edi
  8002a7:	09 fa                	or     %edi,%edx
  8002a9:	0f b6 d2             	movzbl %dl,%edx
  8002ac:	b8 f6 01 00 00       	mov    $0x1f6,%eax
  8002b1:	e8 93 fd ff ff       	call   800049 <outb>
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector
  8002b6:	ba 30 00 00 00       	mov    $0x30,%edx
  8002bb:	b8 f7 01 00 00       	mov    $0x1f7,%eax
  8002c0:	e8 84 fd ff ff       	call   800049 <outb>
  8002c5:	c1 e6 09             	shl    $0x9,%esi
  8002c8:	01 de                	add    %ebx,%esi

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8002ca:	eb 25                	jmp    8002f1 <ide_write+0xd9>
		if ((r = ide_wait_ready(1)) < 0)
  8002cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8002d1:	e8 8d fd ff ff       	call   800063 <ide_wait_ready>
  8002d6:	85 c0                	test   %eax,%eax
  8002d8:	78 20                	js     8002fa <ide_write+0xe2>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
  8002da:	b9 80 00 00 00       	mov    $0x80,%ecx
  8002df:	89 da                	mov    %ebx,%edx
  8002e1:	b8 f0 01 00 00       	mov    $0x1f0,%eax
  8002e6:	e8 6a fd ff ff       	call   800055 <outsl>
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8002eb:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8002f1:	39 f3                	cmp    %esi,%ebx
  8002f3:	75 d7                	jne    8002cc <ide_write+0xb4>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  8002f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fd:	5b                   	pop    %ebx
  8002fe:	5e                   	pop    %esi
  8002ff:	5f                   	pop    %edi
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80030a:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t) addr - DISKMAP) / BLKSIZE;
  80030c:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800312:	89 c6                	mov    %eax,%esi
  800314:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void *) DISKMAP || addr >= (void *) (DISKMAP + DISKSIZE))
  800317:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  80031c:	76 1b                	jbe    800339 <bc_pgfault+0x37>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	ff 72 04             	pushl  0x4(%edx)
  800324:	53                   	push   %ebx
  800325:	ff 72 28             	pushl  0x28(%edx)
  800328:	68 54 39 80 00       	push   $0x803954
  80032d:	6a 29                	push   $0x29
  80032f:	68 10 3a 80 00       	push   $0x803a10
  800334:	e8 aa 18 00 00       	call   801be3 <_panic>
		      utf->utf_eip,
		      addr,
		      utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  800339:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	74 17                	je     800359 <bc_pgfault+0x57>
  800342:	3b 70 04             	cmp    0x4(%eax),%esi
  800345:	72 12                	jb     800359 <bc_pgfault+0x57>
		panic("reading non-existent block %08x\n", blockno);
  800347:	56                   	push   %esi
  800348:	68 84 39 80 00       	push   $0x803984
  80034d:	6a 2d                	push   $0x2d
  80034f:	68 10 3a 80 00       	push   $0x803a10
  800354:	e8 8a 18 00 00       	call   801be3 <_panic>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);  //Round del addres
  800359:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	sys_page_alloc(0,addr,PTE_U|PTE_P|PTE_W); //Se alloca la pagina
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 07                	push   $0x7
  800364:	53                   	push   %ebx
  800365:	6a 00                	push   $0x0
  800367:	e8 0b 23 00 00       	call   802677 <sys_page_alloc>
	
	//ide_read(uint32_t secno, void *dst, size_t nsecs)
	//BLKSECTS	(BLKSIZE / SECTSIZE) sectors per block
	r = ide_read(blockno*BLKSECTS, addr, BLKSECTS);
  80036c:	83 c4 0c             	add    $0xc,%esp
  80036f:	6a 08                	push   $0x8
  800371:	53                   	push   %ebx
  800372:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  800379:	50                   	push   %eax
  80037a:	e8 af fd ff ff       	call   80012e <ide_read>
	if (r < 0) {
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	85 c0                	test   %eax,%eax
  800384:	79 12                	jns    800398 <bc_pgfault+0x96>
		panic("Error leyendo de disco: %e", r);
  800386:	50                   	push   %eax
  800387:	68 18 3a 80 00       	push   $0x803a18
  80038c:	6a 3c                	push   $0x3c
  80038e:	68 10 3a 80 00       	push   $0x803a10
  800393:	e8 4b 18 00 00       	call   801be3 <_panic>



	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) <
  800398:	89 d8                	mov    %ebx,%eax
  80039a:	c1 e8 0c             	shr    $0xc,%eax
  80039d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8003a4:	83 ec 0c             	sub    $0xc,%esp
  8003a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8003ac:	50                   	push   %eax
  8003ad:	53                   	push   %ebx
  8003ae:	6a 00                	push   $0x0
  8003b0:	53                   	push   %ebx
  8003b1:	6a 00                	push   $0x0
  8003b3:	e8 e3 22 00 00       	call   80269b <sys_page_map>
  8003b8:	83 c4 20             	add    $0x20,%esp
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	79 12                	jns    8003d1 <bc_pgfault+0xcf>
	    0)
		panic("in bc_pgfault, sys_page_map: %e", r);
  8003bf:	50                   	push   %eax
  8003c0:	68 a8 39 80 00       	push   $0x8039a8
  8003c5:	6a 45                	push   $0x45
  8003c7:	68 10 3a 80 00       	push   $0x803a10
  8003cc:	e8 12 18 00 00       	call   801be3 <_panic>

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8003d1:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  8003d8:	74 22                	je     8003fc <bc_pgfault+0xfa>
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	56                   	push   %esi
  8003de:	e8 ba 04 00 00       	call   80089d <block_is_free>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	84 c0                	test   %al,%al
  8003e8:	74 12                	je     8003fc <bc_pgfault+0xfa>
		panic("reading free block %08x\n", blockno);
  8003ea:	56                   	push   %esi
  8003eb:	68 33 3a 80 00       	push   $0x803a33
  8003f0:	6a 4b                	push   $0x4b
  8003f2:	68 10 3a 80 00       	push   $0x803a10
  8003f7:	e8 e7 17 00 00       	call   801be3 <_panic>
}
  8003fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003ff:	5b                   	pop    %ebx
  800400:	5e                   	pop    %esi
  800401:	5d                   	pop    %ebp
  800402:	c3                   	ret    

00800403 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void *
diskaddr(uint32_t blockno)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  80040c:	85 c0                	test   %eax,%eax
  80040e:	74 0f                	je     80041f <diskaddr+0x1c>
  800410:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  800416:	85 d2                	test   %edx,%edx
  800418:	74 17                	je     800431 <diskaddr+0x2e>
  80041a:	3b 42 04             	cmp    0x4(%edx),%eax
  80041d:	72 12                	jb     800431 <diskaddr+0x2e>
		panic("bad block number %08x in diskaddr", blockno);
  80041f:	50                   	push   %eax
  800420:	68 c8 39 80 00       	push   $0x8039c8
  800425:	6a 09                	push   $0x9
  800427:	68 10 3a 80 00       	push   $0x803a10
  80042c:	e8 b2 17 00 00       	call   801be3 <_panic>
	return (char *) (DISKMAP + blockno * BLKSIZE);
  800431:	05 00 00 01 00       	add    $0x10000,%eax
  800436:	c1 e0 0c             	shl    $0xc,%eax
}
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800441:	89 d0                	mov    %edx,%eax
  800443:	c1 e8 16             	shr    $0x16,%eax
  800446:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  80044d:	b8 00 00 00 00       	mov    $0x0,%eax
  800452:	f6 c1 01             	test   $0x1,%cl
  800455:	74 0d                	je     800464 <va_is_mapped+0x29>
  800457:	c1 ea 0c             	shr    $0xc,%edx
  80045a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800461:	83 e0 01             	and    $0x1,%eax
  800464:	83 e0 01             	and    $0x1,%eax
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	c1 e8 0c             	shr    $0xc,%eax
  800472:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800479:	c1 e8 06             	shr    $0x6,%eax
  80047c:	83 e0 01             	and    $0x1,%eax
}
  80047f:	5d                   	pop    %ebp
  800480:	c3                   	ret    

00800481 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	56                   	push   %esi
  800485:	53                   	push   %ebx
  800486:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t) addr - DISKMAP) / BLKSIZE;

	if (addr < (void *) DISKMAP || addr >= (void *) (DISKMAP + DISKSIZE))
  800489:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80048f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800494:	76 12                	jbe    8004a8 <flush_block+0x27>
		panic("flush_block of bad va %08x", addr);
  800496:	53                   	push   %ebx
  800497:	68 4c 3a 80 00       	push   $0x803a4c
  80049c:	6a 5b                	push   $0x5b
  80049e:	68 10 3a 80 00       	push   $0x803a10
  8004a3:	e8 3b 17 00 00       	call   801be3 <_panic>

	// LAB 5: Your code here.
	int err;
	int r;
	if (!va_is_mapped(addr) || !va_is_dirty(addr)){
  8004a8:	83 ec 0c             	sub    $0xc,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	e8 8a ff ff ff       	call   80043b <va_is_mapped>
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	84 c0                	test   %al,%al
  8004b6:	0f 84 84 00 00 00    	je     800540 <flush_block+0xbf>
  8004bc:	83 ec 0c             	sub    $0xc,%esp
  8004bf:	53                   	push   %ebx
  8004c0:	e8 a4 ff ff ff       	call   800469 <va_is_dirty>
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	84 c0                	test   %al,%al
  8004ca:	74 74                	je     800540 <flush_block+0xbf>
		return;
	}
	addr = ROUNDDOWN(addr, PGSIZE);
  8004cc:	89 de                	mov    %ebx,%esi
  8004ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	err = ide_write(blockno*BLKSECTS, addr, BLKSECTS);
  8004d4:	83 ec 04             	sub    $0x4,%esp
  8004d7:	6a 08                	push   $0x8
  8004d9:	56                   	push   %esi
  8004da:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  8004e0:	c1 eb 0c             	shr    $0xc,%ebx
  8004e3:	c1 e3 03             	shl    $0x3,%ebx
  8004e6:	53                   	push   %ebx
  8004e7:	e8 2c fd ff ff       	call   800218 <ide_write>
	if ( err < 0){
  8004ec:	83 c4 10             	add    $0x10,%esp
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	79 14                	jns    800507 <flush_block+0x86>
		panic("Error escribiendo en disco \n");
  8004f3:	83 ec 04             	sub    $0x4,%esp
  8004f6:	68 67 3a 80 00       	push   $0x803a67
  8004fb:	6a 66                	push   $0x66
  8004fd:	68 10 3a 80 00       	push   $0x803a10
  800502:	e8 dc 16 00 00       	call   801be3 <_panic>
	}

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800507:	89 f0                	mov    %esi,%eax
  800509:	c1 e8 0c             	shr    $0xc,%eax
  80050c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800513:	83 ec 0c             	sub    $0xc,%esp
  800516:	25 07 0e 00 00       	and    $0xe07,%eax
  80051b:	50                   	push   %eax
  80051c:	56                   	push   %esi
  80051d:	6a 00                	push   $0x0
  80051f:	56                   	push   %esi
  800520:	6a 00                	push   $0x0
  800522:	e8 74 21 00 00       	call   80269b <sys_page_map>
  800527:	83 c4 20             	add    $0x20,%esp
  80052a:	85 c0                	test   %eax,%eax
  80052c:	79 12                	jns    800540 <flush_block+0xbf>
		panic("in bc_pgfault, sys_page_map: %e", r);
  80052e:	50                   	push   %eax
  80052f:	68 a8 39 80 00       	push   $0x8039a8
  800534:	6a 6c                	push   $0x6c
  800536:	68 10 3a 80 00       	push   $0x803a10
  80053b:	e8 a3 16 00 00       	call   801be3 <_panic>


	
}
  800540:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800543:	5b                   	pop    %ebx
  800544:	5e                   	pop    %esi
  800545:	5d                   	pop    %ebp
  800546:	c3                   	ret    

00800547 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	53                   	push   %ebx
  80054b:	81 ec 20 01 00 00    	sub    $0x120,%esp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800551:	6a 01                	push   $0x1
  800553:	e8 ab fe ff ff       	call   800403 <diskaddr>
  800558:	83 c4 0c             	add    $0xc,%esp
  80055b:	68 08 01 00 00       	push   $0x108
  800560:	50                   	push   %eax
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	50                   	push   %eax
  800568:	e8 54 1e 00 00       	call   8023c1 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  80056d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800574:	e8 8a fe ff ff       	call   800403 <diskaddr>
  800579:	83 c4 08             	add    $0x8,%esp
  80057c:	68 84 3a 80 00       	push   $0x803a84
  800581:	50                   	push   %eax
  800582:	e8 a7 1c 00 00       	call   80222e <strcpy>
	flush_block(diskaddr(1));
  800587:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80058e:	e8 70 fe ff ff       	call   800403 <diskaddr>
  800593:	89 04 24             	mov    %eax,(%esp)
  800596:	e8 e6 fe ff ff       	call   800481 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  80059b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005a2:	e8 5c fe ff ff       	call   800403 <diskaddr>
  8005a7:	89 04 24             	mov    %eax,(%esp)
  8005aa:	e8 8c fe ff ff       	call   80043b <va_is_mapped>
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 16                	jne    8005cc <check_bc+0x85>
  8005b6:	68 a6 3a 80 00       	push   $0x803aa6
  8005bb:	68 3d 39 80 00       	push   $0x80393d
  8005c0:	6a 7f                	push   $0x7f
  8005c2:	68 10 3a 80 00       	push   $0x803a10
  8005c7:	e8 17 16 00 00       	call   801be3 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  8005cc:	83 ec 0c             	sub    $0xc,%esp
  8005cf:	6a 01                	push   $0x1
  8005d1:	e8 2d fe ff ff       	call   800403 <diskaddr>
  8005d6:	89 04 24             	mov    %eax,(%esp)
  8005d9:	e8 8b fe ff ff       	call   800469 <va_is_dirty>
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	84 c0                	test   %al,%al
  8005e3:	74 19                	je     8005fe <check_bc+0xb7>
  8005e5:	68 8b 3a 80 00       	push   $0x803a8b
  8005ea:	68 3d 39 80 00       	push   $0x80393d
  8005ef:	68 80 00 00 00       	push   $0x80
  8005f4:	68 10 3a 80 00       	push   $0x803a10
  8005f9:	e8 e5 15 00 00       	call   801be3 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  8005fe:	83 ec 0c             	sub    $0xc,%esp
  800601:	6a 01                	push   $0x1
  800603:	e8 fb fd ff ff       	call   800403 <diskaddr>
  800608:	83 c4 08             	add    $0x8,%esp
  80060b:	50                   	push   %eax
  80060c:	6a 00                	push   $0x0
  80060e:	e8 ae 20 00 00       	call   8026c1 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800613:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80061a:	e8 e4 fd ff ff       	call   800403 <diskaddr>
  80061f:	89 04 24             	mov    %eax,(%esp)
  800622:	e8 14 fe ff ff       	call   80043b <va_is_mapped>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	84 c0                	test   %al,%al
  80062c:	74 19                	je     800647 <check_bc+0x100>
  80062e:	68 a5 3a 80 00       	push   $0x803aa5
  800633:	68 3d 39 80 00       	push   $0x80393d
  800638:	68 84 00 00 00       	push   $0x84
  80063d:	68 10 3a 80 00       	push   $0x803a10
  800642:	e8 9c 15 00 00       	call   801be3 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	6a 01                	push   $0x1
  80064c:	e8 b2 fd ff ff       	call   800403 <diskaddr>
  800651:	83 c4 08             	add    $0x8,%esp
  800654:	68 84 3a 80 00       	push   $0x803a84
  800659:	50                   	push   %eax
  80065a:	e8 79 1c 00 00       	call   8022d8 <strcmp>
  80065f:	83 c4 10             	add    $0x10,%esp
  800662:	85 c0                	test   %eax,%eax
  800664:	74 19                	je     80067f <check_bc+0x138>
  800666:	68 ec 39 80 00       	push   $0x8039ec
  80066b:	68 3d 39 80 00       	push   $0x80393d
  800670:	68 87 00 00 00       	push   $0x87
  800675:	68 10 3a 80 00       	push   $0x803a10
  80067a:	e8 64 15 00 00       	call   801be3 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  80067f:	83 ec 0c             	sub    $0xc,%esp
  800682:	6a 01                	push   $0x1
  800684:	e8 7a fd ff ff       	call   800403 <diskaddr>
  800689:	83 c4 0c             	add    $0xc,%esp
  80068c:	68 08 01 00 00       	push   $0x108
  800691:	8d 9d f0 fe ff ff    	lea    -0x110(%ebp),%ebx
  800697:	53                   	push   %ebx
  800698:	50                   	push   %eax
  800699:	e8 23 1d 00 00       	call   8023c1 <memmove>
	flush_block(diskaddr(1));
  80069e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006a5:	e8 59 fd ff ff       	call   800403 <diskaddr>
  8006aa:	89 04 24             	mov    %eax,(%esp)
  8006ad:	e8 cf fd ff ff       	call   800481 <flush_block>

	// Now repeat the same experiment, but pass an unaligned address to
	// flush_block.

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8006b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006b9:	e8 45 fd ff ff       	call   800403 <diskaddr>
  8006be:	83 c4 0c             	add    $0xc,%esp
  8006c1:	68 08 01 00 00       	push   $0x108
  8006c6:	50                   	push   %eax
  8006c7:	53                   	push   %ebx
  8006c8:	e8 f4 1c 00 00       	call   8023c1 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8006cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006d4:	e8 2a fd ff ff       	call   800403 <diskaddr>
  8006d9:	83 c4 08             	add    $0x8,%esp
  8006dc:	68 84 3a 80 00       	push   $0x803a84
  8006e1:	50                   	push   %eax
  8006e2:	e8 47 1b 00 00       	call   80222e <strcpy>

	// Pass an unaligned address to flush_block.
	flush_block(diskaddr(1) + 20);
  8006e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006ee:	e8 10 fd ff ff       	call   800403 <diskaddr>
  8006f3:	83 c0 14             	add    $0x14,%eax
  8006f6:	89 04 24             	mov    %eax,(%esp)
  8006f9:	e8 83 fd ff ff       	call   800481 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  8006fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800705:	e8 f9 fc ff ff       	call   800403 <diskaddr>
  80070a:	89 04 24             	mov    %eax,(%esp)
  80070d:	e8 29 fd ff ff       	call   80043b <va_is_mapped>
  800712:	83 c4 10             	add    $0x10,%esp
  800715:	84 c0                	test   %al,%al
  800717:	75 19                	jne    800732 <check_bc+0x1eb>
  800719:	68 a6 3a 80 00       	push   $0x803aa6
  80071e:	68 3d 39 80 00       	push   $0x80393d
  800723:	68 98 00 00 00       	push   $0x98
  800728:	68 10 3a 80 00       	push   $0x803a10
  80072d:	e8 b1 14 00 00       	call   801be3 <_panic>
	// Skip the !va_is_dirty() check because it makes the bug somewhat
	// obscure and hence harder to debug.
	// assert(!va_is_dirty(diskaddr(1)));

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800732:	83 ec 0c             	sub    $0xc,%esp
  800735:	6a 01                	push   $0x1
  800737:	e8 c7 fc ff ff       	call   800403 <diskaddr>
  80073c:	83 c4 08             	add    $0x8,%esp
  80073f:	50                   	push   %eax
  800740:	6a 00                	push   $0x0
  800742:	e8 7a 1f 00 00       	call   8026c1 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800747:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80074e:	e8 b0 fc ff ff       	call   800403 <diskaddr>
  800753:	89 04 24             	mov    %eax,(%esp)
  800756:	e8 e0 fc ff ff       	call   80043b <va_is_mapped>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	84 c0                	test   %al,%al
  800760:	74 19                	je     80077b <check_bc+0x234>
  800762:	68 a5 3a 80 00       	push   $0x803aa5
  800767:	68 3d 39 80 00       	push   $0x80393d
  80076c:	68 a0 00 00 00       	push   $0xa0
  800771:	68 10 3a 80 00       	push   $0x803a10
  800776:	e8 68 14 00 00       	call   801be3 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	6a 01                	push   $0x1
  800780:	e8 7e fc ff ff       	call   800403 <diskaddr>
  800785:	83 c4 08             	add    $0x8,%esp
  800788:	68 84 3a 80 00       	push   $0x803a84
  80078d:	50                   	push   %eax
  80078e:	e8 45 1b 00 00       	call   8022d8 <strcmp>
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	85 c0                	test   %eax,%eax
  800798:	74 19                	je     8007b3 <check_bc+0x26c>
  80079a:	68 ec 39 80 00       	push   $0x8039ec
  80079f:	68 3d 39 80 00       	push   $0x80393d
  8007a4:	68 a3 00 00 00       	push   $0xa3
  8007a9:	68 10 3a 80 00       	push   $0x803a10
  8007ae:	e8 30 14 00 00       	call   801be3 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  8007b3:	83 ec 0c             	sub    $0xc,%esp
  8007b6:	6a 01                	push   $0x1
  8007b8:	e8 46 fc ff ff       	call   800403 <diskaddr>
  8007bd:	83 c4 0c             	add    $0xc,%esp
  8007c0:	68 08 01 00 00       	push   $0x108
  8007c5:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	e8 ef 1b 00 00       	call   8023c1 <memmove>
	flush_block(diskaddr(1));
  8007d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8007d9:	e8 25 fc ff ff       	call   800403 <diskaddr>
  8007de:	89 04 24             	mov    %eax,(%esp)
  8007e1:	e8 9b fc ff ff       	call   800481 <flush_block>

	cprintf("block cache is good\n");
  8007e6:	c7 04 24 c0 3a 80 00 	movl   $0x803ac0,(%esp)
  8007ed:	e8 ca 14 00 00       	call   801cbc <cprintf>
}
  8007f2:	83 c4 10             	add    $0x10,%esp
  8007f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <bc_init>:

void
bc_init(void)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	81 ec 24 01 00 00    	sub    $0x124,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800803:	68 02 03 80 00       	push   $0x800302
  800808:	e8 87 1f 00 00       	call   802794 <set_pgfault_handler>
	check_bc();
  80080d:	e8 35 fd ff ff       	call   800547 <check_bc>

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800812:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800819:	e8 e5 fb ff ff       	call   800403 <diskaddr>
  80081e:	83 c4 0c             	add    $0xc,%esp
  800821:	68 08 01 00 00       	push   $0x108
  800826:	50                   	push   %eax
  800827:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80082d:	50                   	push   %eax
  80082e:	e8 8e 1b 00 00       	call   8023c1 <memmove>
}
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <skip_slash>:
}

// Skip over slashes.
static const char *
skip_slash(const char *p)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
	while (*p == '/')
  80083b:	eb 03                	jmp    800840 <skip_slash+0x8>
		p++;
  80083d:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char *
skip_slash(const char *p)
{
	while (*p == '/')
  800840:	80 38 2f             	cmpb   $0x2f,(%eax)
  800843:	74 f8                	je     80083d <skip_slash+0x5>
		p++;
	return p;
}
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  80084d:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800852:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800858:	74 14                	je     80086e <check_super+0x27>
		panic("bad file system magic number");
  80085a:	83 ec 04             	sub    $0x4,%esp
  80085d:	68 d5 3a 80 00       	push   $0x803ad5
  800862:	6a 0f                	push   $0xf
  800864:	68 f2 3a 80 00       	push   $0x803af2
  800869:	e8 75 13 00 00       	call   801be3 <_panic>

	if (super->s_nblocks > DISKSIZE / BLKSIZE)
  80086e:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800875:	76 14                	jbe    80088b <check_super+0x44>
		panic("file system is too large");
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 fa 3a 80 00       	push   $0x803afa
  80087f:	6a 12                	push   $0x12
  800881:	68 f2 3a 80 00       	push   $0x803af2
  800886:	e8 58 13 00 00       	call   801be3 <_panic>

	cprintf("superblock is good\n");
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	68 13 3b 80 00       	push   $0x803b13
  800893:	e8 24 14 00 00       	call   801cbc <cprintf>
}
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	53                   	push   %ebx
  8008a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  8008a4:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	74 24                	je     8008d2 <block_is_free+0x35>
		return 0;
  8008ae:	b8 00 00 00 00       	mov    $0x0,%eax
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
  8008b3:	39 4a 04             	cmp    %ecx,0x4(%edx)
  8008b6:	76 1f                	jbe    8008d7 <block_is_free+0x3a>
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  8008b8:	89 cb                	mov    %ecx,%ebx
  8008ba:	c1 eb 05             	shr    $0x5,%ebx
  8008bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8008c2:	d3 e0                	shl    %cl,%eax
  8008c4:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  8008ca:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  8008cd:	0f 95 c0             	setne  %al
  8008d0:	eb 05                	jmp    8008d7 <block_is_free+0x3a>
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  8008d7:	5b                   	pop    %ebx
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	53                   	push   %ebx
  8008de:	83 ec 04             	sub    $0x4,%esp
  8008e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8008e4:	85 c9                	test   %ecx,%ecx
  8008e6:	75 14                	jne    8008fc <free_block+0x22>
		panic("attempt to free zero block");
  8008e8:	83 ec 04             	sub    $0x4,%esp
  8008eb:	68 27 3b 80 00       	push   $0x803b27
  8008f0:	6a 2d                	push   $0x2d
  8008f2:	68 f2 3a 80 00       	push   $0x803af2
  8008f7:	e8 e7 12 00 00       	call   801be3 <_panic>
	bitmap[blockno / 32] |= 1 << (blockno % 32);
  8008fc:	89 cb                	mov    %ecx,%ebx
  8008fe:	c1 eb 05             	shr    $0x5,%ebx
  800901:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  800907:	b8 01 00 00 00       	mov    $0x1,%eax
  80090c:	d3 e0                	shl    %cl,%eax
  80090e:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	//me ubico en el comienzo del bitmap le sumo BLKBITSIZE para "saltear" el bloque 0
	int bitmap_base = (super->s_nblocks + BLKBITSIZE - 1)/ BLKBITSIZE; 
  80091b:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800920:	8b 70 04             	mov    0x4(%eax),%esi
	for (int blockno = 2 + bitmap_base; blockno < super->s_nblocks; blockno++) {
  800923:	8d 9e ff 7f 00 00    	lea    0x7fff(%esi),%ebx
  800929:	c1 eb 0f             	shr    $0xf,%ebx
  80092c:	83 c3 02             	add    $0x2,%ebx
  80092f:	eb 50                	jmp    800981 <alloc_block+0x6b>
		if (block_is_free(blockno)) {
  800931:	53                   	push   %ebx
  800932:	e8 66 ff ff ff       	call   80089d <block_is_free>
  800937:	83 c4 04             	add    $0x4,%esp
  80093a:	84 c0                	test   %al,%al
  80093c:	74 40                	je     80097e <alloc_block+0x68>
			//Uso lo mismo que en free block pero negado!!!
			bitmap[blockno/32] &= ~(1<<(blockno%32));
  80093e:	8d 43 1f             	lea    0x1f(%ebx),%eax
  800941:	85 db                	test   %ebx,%ebx
  800943:	0f 49 c3             	cmovns %ebx,%eax
  800946:	c1 f8 05             	sar    $0x5,%eax
  800949:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  80094f:	89 de                	mov    %ebx,%esi
  800951:	c1 fe 1f             	sar    $0x1f,%esi
  800954:	c1 ee 1b             	shr    $0x1b,%esi
  800957:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
  80095a:	83 e1 1f             	and    $0x1f,%ecx
  80095d:	29 f1                	sub    %esi,%ecx
  80095f:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  800964:	d3 c6                	rol    %cl,%esi
  800966:	21 34 82             	and    %esi,(%edx,%eax,4)
			flush_block(bitmap);
  800969:	83 ec 0c             	sub    $0xc,%esp
  80096c:	ff 35 04 a0 80 00    	pushl  0x80a004
  800972:	e8 0a fb ff ff       	call   800481 <flush_block>
			return blockno;
  800977:	83 c4 10             	add    $0x10,%esp
  80097a:	89 d8                	mov    %ebx,%eax
  80097c:	eb 0c                	jmp    80098a <alloc_block+0x74>
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	//me ubico en el comienzo del bitmap le sumo BLKBITSIZE para "saltear" el bloque 0
	int bitmap_base = (super->s_nblocks + BLKBITSIZE - 1)/ BLKBITSIZE; 
	for (int blockno = 2 + bitmap_base; blockno < super->s_nblocks; blockno++) {
  80097e:	83 c3 01             	add    $0x1,%ebx
  800981:	39 de                	cmp    %ebx,%esi
  800983:	77 ac                	ja     800931 <alloc_block+0x1b>
			bitmap[blockno/32] &= ~(1<<(blockno%32));
			flush_block(bitmap);
			return blockno;
		}
	}
	return -E_NO_DISK;
  800985:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
	
}
  80098a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80098d:	5b                   	pop    %ebx
  80098e:	5e                   	pop    %esi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	57                   	push   %edi
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	83 ec 1c             	sub    $0x1c,%esp
  80099a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 5: Your code here.
	if(filebno >= NDIRECT + NINDIRECT){
  80099d:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  8009a3:	0f 87 9f 00 00 00    	ja     800a48 <file_block_walk+0xb7>
		return -E_INVAL;
	}

	//Block number directo
	if (filebno < NDIRECT) {
  8009a9:	83 fa 09             	cmp    $0x9,%edx
  8009ac:	77 1b                	ja     8009c9 <file_block_walk+0x38>
		if (ppdiskbno){
  8009ae:	85 c9                	test   %ecx,%ecx
  8009b0:	0f 84 99 00 00 00    	je     800a4f <file_block_walk+0xbe>
	 		*ppdiskbno = f->f_direct + filebno;
  8009b6:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  8009bd:	89 01                	mov    %eax,(%ecx)
		}
		return 0;
  8009bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c4:	e9 99 00 00 00       	jmp    800a62 <file_block_walk+0xd1>
	}

	//Si llega a este punto necesita ubicar un bloque indirecto
	if(!alloc){
  8009c9:	84 db                	test   %bl,%bl
  8009cb:	0f 84 85 00 00 00    	je     800a56 <file_block_walk+0xc5>
  8009d1:	89 cb                	mov    %ecx,%ebx
  8009d3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8009d6:	89 c6                	mov    %eax,%esi
		return -E_NOT_FOUND;
	}

	//Block number indirecto
	if (!f->f_indirect) {
  8009d8:	83 b8 b0 00 00 00 00 	cmpl   $0x0,0xb0(%eax)
  8009df:	75 3d                	jne    800a1e <file_block_walk+0x8d>
		int block_number = alloc_block();
  8009e1:	e8 30 ff ff ff       	call   800916 <alloc_block>
  8009e6:	89 c7                	mov    %eax,%edi
		if (block_number < 0){
  8009e8:	85 c0                	test   %eax,%eax
  8009ea:	78 71                	js     800a5d <file_block_walk+0xcc>
			return -E_NO_DISK;
		}
		f->f_indirect = block_number;
  8009ec:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
		memset(diskaddr(block_number), 0, BLKSIZE);
  8009f2:	83 ec 0c             	sub    $0xc,%esp
  8009f5:	50                   	push   %eax
  8009f6:	e8 08 fa ff ff       	call   800403 <diskaddr>
  8009fb:	83 c4 0c             	add    $0xc,%esp
  8009fe:	68 00 10 00 00       	push   $0x1000
  800a03:	6a 00                	push   $0x0
  800a05:	50                   	push   %eax
  800a06:	e8 68 19 00 00       	call   802373 <memset>
		flush_block(diskaddr(block_number));
  800a0b:	89 3c 24             	mov    %edi,(%esp)
  800a0e:	e8 f0 f9 ff ff       	call   800403 <diskaddr>
  800a13:	89 04 24             	mov    %eax,(%esp)
  800a16:	e8 66 fa ff ff       	call   800481 <flush_block>
  800a1b:	83 c4 10             	add    $0x10,%esp
	}

	if (ppdiskbno){
		*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	}
	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
		f->f_indirect = block_number;
		memset(diskaddr(block_number), 0, BLKSIZE);
		flush_block(diskaddr(block_number));
	}

	if (ppdiskbno){
  800a23:	85 db                	test   %ebx,%ebx
  800a25:	74 3b                	je     800a62 <file_block_walk+0xd1>
		*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  800a27:	83 ec 0c             	sub    $0xc,%esp
  800a2a:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  800a30:	e8 ce f9 ff ff       	call   800403 <diskaddr>
  800a35:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a38:	8d 44 b8 d8          	lea    -0x28(%eax,%edi,4),%eax
  800a3c:	89 03                	mov    %eax,(%ebx)
  800a3e:	83 c4 10             	add    $0x10,%esp
	}
	return 0;
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
  800a46:	eb 1a                	jmp    800a62 <file_block_walk+0xd1>
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
	// LAB 5: Your code here.
	if(filebno >= NDIRECT + NINDIRECT){
		return -E_INVAL;
  800a48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a4d:	eb 13                	jmp    800a62 <file_block_walk+0xd1>
	//Block number directo
	if (filebno < NDIRECT) {
		if (ppdiskbno){
	 		*ppdiskbno = f->f_direct + filebno;
		}
		return 0;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a54:	eb 0c                	jmp    800a62 <file_block_walk+0xd1>
	}

	//Si llega a este punto necesita ubicar un bloque indirecto
	if(!alloc){
		return -E_NOT_FOUND;
  800a56:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800a5b:	eb 05                	jmp    800a62 <file_block_walk+0xd1>

	//Block number indirecto
	if (!f->f_indirect) {
		int block_number = alloc_block();
		if (block_number < 0){
			return -E_NO_DISK;
  800a5d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax

	if (ppdiskbno){
		*ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	}
	return 0;
}
  800a62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5f                   	pop    %edi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 24             	sub    $0x24,%esp
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800a70:	6a 00                	push   $0x0
  800a72:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800a75:	e8 17 ff ff ff       	call   800991 <file_block_walk>
  800a7a:	83 c4 10             	add    $0x10,%esp
  800a7d:	85 c0                	test   %eax,%eax
  800a7f:	78 28                	js     800aa9 <file_free_block+0x3f>
		return r;
	if (*ptr) {
  800a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a84:	8b 10                	mov    (%eax),%edx
		free_block(*ptr);
		*ptr = 0;
	}
	return 0;
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
		return r;
	if (*ptr) {
  800a8b:	85 d2                	test   %edx,%edx
  800a8d:	74 1a                	je     800aa9 <file_free_block+0x3f>
		free_block(*ptr);
  800a8f:	83 ec 0c             	sub    $0xc,%esp
  800a92:	52                   	push   %edx
  800a93:	e8 42 fe ff ff       	call   8008da <free_block>
		*ptr = 0;
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800aa1:	83 c4 10             	add    $0x10,%esp
	}
	return 0;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	57                   	push   %edi
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	83 ec 1c             	sub    $0x1c,%esp
  800ab4:	89 c7                	mov    %eax,%edi
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800ab6:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800abc:	8d b0 fe 1f 00 00    	lea    0x1ffe(%eax),%esi
  800ac2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ac7:	0f 49 f0             	cmovns %eax,%esi
  800aca:	c1 fe 0c             	sar    $0xc,%esi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800acd:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800ad3:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800ad9:	0f 48 d0             	cmovs  %eax,%edx
  800adc:	c1 fa 0c             	sar    $0xc,%edx
  800adf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ae2:	89 d3                	mov    %edx,%ebx
  800ae4:	eb 21                	jmp    800b07 <file_truncate_blocks+0x5c>
		if ((r = file_free_block(f, bno)) < 0)
  800ae6:	89 da                	mov    %ebx,%edx
  800ae8:	89 f8                	mov    %edi,%eax
  800aea:	e8 7b ff ff ff       	call   800a6a <file_free_block>
  800aef:	85 c0                	test   %eax,%eax
  800af1:	79 11                	jns    800b04 <file_truncate_blocks+0x59>
			cprintf("warning: file_free_block: %e", r);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	50                   	push   %eax
  800af7:	68 42 3b 80 00       	push   $0x803b42
  800afc:	e8 bb 11 00 00       	call   801cbc <cprintf>
  800b01:	83 c4 10             	add    $0x10,%esp
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800b04:	83 c3 01             	add    $0x1,%ebx
  800b07:	39 f3                	cmp    %esi,%ebx
  800b09:	72 db                	jb     800ae6 <file_truncate_blocks+0x3b>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800b0b:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%ebp)
  800b0f:	77 20                	ja     800b31 <file_truncate_blocks+0x86>
  800b11:	8b 87 b0 00 00 00    	mov    0xb0(%edi),%eax
  800b17:	85 c0                	test   %eax,%eax
  800b19:	74 16                	je     800b31 <file_truncate_blocks+0x86>
		free_block(f->f_indirect);
  800b1b:	83 ec 0c             	sub    $0xc,%esp
  800b1e:	50                   	push   %eax
  800b1f:	e8 b6 fd ff ff       	call   8008da <free_block>
		f->f_indirect = 0;
  800b24:	c7 87 b0 00 00 00 00 	movl   $0x0,0xb0(%edi)
  800b2b:	00 00 00 
  800b2e:	83 c4 10             	add    $0x10,%esp
	}
}
  800b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800b3e:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800b43:	8b 70 04             	mov    0x4(%eax),%esi
  800b46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b4b:	eb 29                	jmp    800b76 <check_bitmap+0x3d>
		assert(!block_is_free(2 + i));
  800b4d:	8d 43 02             	lea    0x2(%ebx),%eax
  800b50:	50                   	push   %eax
  800b51:	e8 47 fd ff ff       	call   80089d <block_is_free>
  800b56:	83 c4 04             	add    $0x4,%esp
  800b59:	84 c0                	test   %al,%al
  800b5b:	74 16                	je     800b73 <check_bitmap+0x3a>
  800b5d:	68 5f 3b 80 00       	push   $0x803b5f
  800b62:	68 3d 39 80 00       	push   $0x80393d
  800b67:	6a 5a                	push   $0x5a
  800b69:	68 f2 3a 80 00       	push   $0x803af2
  800b6e:	e8 70 10 00 00       	call   801be3 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800b73:	83 c3 01             	add    $0x1,%ebx
  800b76:	89 d8                	mov    %ebx,%eax
  800b78:	c1 e0 0f             	shl    $0xf,%eax
  800b7b:	39 f0                	cmp    %esi,%eax
  800b7d:	72 ce                	jb     800b4d <check_bitmap+0x14>
		assert(!block_is_free(2 + i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800b7f:	83 ec 0c             	sub    $0xc,%esp
  800b82:	6a 00                	push   $0x0
  800b84:	e8 14 fd ff ff       	call   80089d <block_is_free>
  800b89:	83 c4 10             	add    $0x10,%esp
  800b8c:	84 c0                	test   %al,%al
  800b8e:	74 16                	je     800ba6 <check_bitmap+0x6d>
  800b90:	68 75 3b 80 00       	push   $0x803b75
  800b95:	68 3d 39 80 00       	push   $0x80393d
  800b9a:	6a 5d                	push   $0x5d
  800b9c:	68 f2 3a 80 00       	push   $0x803af2
  800ba1:	e8 3d 10 00 00       	call   801be3 <_panic>
	assert(!block_is_free(1));
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	6a 01                	push   $0x1
  800bab:	e8 ed fc ff ff       	call   80089d <block_is_free>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	84 c0                	test   %al,%al
  800bb5:	74 16                	je     800bcd <check_bitmap+0x94>
  800bb7:	68 87 3b 80 00       	push   $0x803b87
  800bbc:	68 3d 39 80 00       	push   $0x80393d
  800bc1:	6a 5e                	push   $0x5e
  800bc3:	68 f2 3a 80 00       	push   $0x803af2
  800bc8:	e8 16 10 00 00       	call   801be3 <_panic>

	cprintf("bitmap is good\n");
  800bcd:	83 ec 0c             	sub    $0xc,%esp
  800bd0:	68 99 3b 80 00       	push   $0x803b99
  800bd5:	e8 e2 10 00 00       	call   801cbc <cprintf>
}
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	83 ec 08             	sub    $0x8,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available
	if (ide_probe_disk1())
  800bea:	e8 a6 f4 ff ff       	call   800095 <ide_probe_disk1>
  800bef:	84 c0                	test   %al,%al
  800bf1:	74 0f                	je     800c02 <fs_init+0x1e>
		ide_set_disk(1);
  800bf3:	83 ec 0c             	sub    $0xc,%esp
  800bf6:	6a 01                	push   $0x1
  800bf8:	e8 08 f5 ff ff       	call   800105 <ide_set_disk>
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	eb 0d                	jmp    800c0f <fs_init+0x2b>
	else
		ide_set_disk(0);
  800c02:	83 ec 0c             	sub    $0xc,%esp
  800c05:	6a 00                	push   $0x0
  800c07:	e8 f9 f4 ff ff       	call   800105 <ide_set_disk>
  800c0c:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800c0f:	e8 e6 fb ff ff       	call   8007fa <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  800c14:	83 ec 0c             	sub    $0xc,%esp
  800c17:	6a 01                	push   $0x1
  800c19:	e8 e5 f7 ff ff       	call   800403 <diskaddr>
  800c1e:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  800c23:	e8 1f fc ff ff       	call   800847 <check_super>

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800c28:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800c2f:	e8 cf f7 ff ff       	call   800403 <diskaddr>
  800c34:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_bitmap();
  800c39:	e8 fb fe ff ff       	call   800b39 <check_bitmap>
}
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	53                   	push   %ebx
  800c47:	83 ec 20             	sub    $0x20,%esp
	// LAB 5: Your code here.
	int result;
	uint32_t *pdiskno;

	result = file_block_walk(f, filebno, &pdiskno, 1);
  800c4a:	6a 01                	push   $0x1
  800c4c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	e8 37 fd ff ff       	call   800991 <file_block_walk>
	if (result < 0){
  800c5a:	83 c4 10             	add    $0x10,%esp
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	78 65                	js     800cc6 <file_get_block+0x83>
	    return result;
	}

	if (*pdiskno == 0) {
  800c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c64:	83 38 00             	cmpl   $0x0,(%eax)
  800c67:	75 3c                	jne    800ca5 <file_get_block+0x62>
		int block_number = alloc_block();
  800c69:	e8 a8 fc ff ff       	call   800916 <alloc_block>
  800c6e:	89 c3                	mov    %eax,%ebx
	    if (block_number< 0){
  800c70:	85 c0                	test   %eax,%eax
  800c72:	78 4d                	js     800cc1 <file_get_block+0x7e>
	        return -E_NO_DISK;
	    }
	    *pdiskno = block_number;
  800c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c77:	89 18                	mov    %ebx,(%eax)
		memset(diskaddr(block_number), 0, BLKSIZE);
  800c79:	83 ec 0c             	sub    $0xc,%esp
  800c7c:	53                   	push   %ebx
  800c7d:	e8 81 f7 ff ff       	call   800403 <diskaddr>
  800c82:	83 c4 0c             	add    $0xc,%esp
  800c85:	68 00 10 00 00       	push   $0x1000
  800c8a:	6a 00                	push   $0x0
  800c8c:	50                   	push   %eax
  800c8d:	e8 e1 16 00 00       	call   802373 <memset>
		flush_block(diskaddr(block_number));
  800c92:	89 1c 24             	mov    %ebx,(%esp)
  800c95:	e8 69 f7 ff ff       	call   800403 <diskaddr>
  800c9a:	89 04 24             	mov    %eax,(%esp)
  800c9d:	e8 df f7 ff ff       	call   800481 <flush_block>
  800ca2:	83 c4 10             	add    $0x10,%esp
	}

	*blk = diskaddr(*pdiskno);
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cab:	ff 30                	pushl  (%eax)
  800cad:	e8 51 f7 ff ff       	call   800403 <diskaddr>
  800cb2:	8b 55 10             	mov    0x10(%ebp),%edx
  800cb5:	89 02                	mov    %eax,(%edx)
	return 0;
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbf:	eb 05                	jmp    800cc6 <file_get_block+0x83>
	}

	if (*pdiskno == 0) {
		int block_number = alloc_block();
	    if (block_number< 0){
	        return -E_NO_DISK;
  800cc1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
	}

	*blk = diskaddr(*pdiskno);
	return 0;
	
}
  800cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    

00800ccb <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 3c             	sub    $0x3c,%esp
  800cd4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800cd7:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800cda:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800ce0:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800ce5:	74 19                	je     800d00 <dir_lookup+0x35>
  800ce7:	68 a9 3b 80 00       	push   $0x803ba9
  800cec:	68 3d 39 80 00       	push   $0x80393d
  800cf1:	68 e6 00 00 00       	push   $0xe6
  800cf6:	68 f2 3a 80 00       	push   $0x803af2
  800cfb:	e8 e3 0e 00 00       	call   801be3 <_panic>
  800d00:	89 d7                	mov    %edx,%edi
	nblock = dir->f_size / BLKSIZE;
  800d02:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800d08:	85 c0                	test   %eax,%eax
  800d0a:	0f 48 c2             	cmovs  %edx,%eax
  800d0d:	c1 f8 0c             	sar    $0xc,%eax
  800d10:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (i = 0; i < nblock; i++) {
  800d13:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800d1a:	eb 4e                	jmp    800d6a <dir_lookup+0x9f>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800d1c:	83 ec 04             	sub    $0x4,%esp
  800d1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800d22:	50                   	push   %eax
  800d23:	ff 75 d0             	pushl  -0x30(%ebp)
  800d26:	ff 75 c8             	pushl  -0x38(%ebp)
  800d29:	e8 15 ff ff ff       	call   800c43 <file_get_block>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	85 c0                	test   %eax,%eax
  800d33:	78 42                	js     800d77 <dir_lookup+0xac>
			return r;
		f = (struct File *) blk;
  800d35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800d38:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800d3e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800d41:	83 ec 08             	sub    $0x8,%esp
  800d44:	57                   	push   %edi
  800d45:	53                   	push   %ebx
  800d46:	e8 8d 15 00 00       	call   8022d8 <strcmp>
  800d4b:	83 c4 10             	add    $0x10,%esp
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	75 0a                	jne    800d5c <dir_lookup+0x91>
				*file = &f[j];
  800d52:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800d55:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800d58:	89 0a                	mov    %ecx,(%edx)
				return 0;
  800d5a:	eb 1b                	jmp    800d77 <dir_lookup+0xac>
  800d5c:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File *) blk;
		for (j = 0; j < BLKFILES; j++)
  800d62:	39 f3                	cmp    %esi,%ebx
  800d64:	75 d8                	jne    800d3e <dir_lookup+0x73>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800d66:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
  800d6a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800d6d:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
  800d70:	75 aa                	jne    800d1c <dir_lookup+0x51>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  800d72:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	57                   	push   %edi
  800d83:	56                   	push   %esi
  800d84:	53                   	push   %ebx
  800d85:	81 ec ac 00 00 00    	sub    $0xac,%esp
  800d8b:	89 d7                	mov    %edx,%edi
  800d8d:	89 95 4c ff ff ff    	mov    %edx,-0xb4(%ebp)
  800d93:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  800d99:	e8 9a fa ff ff       	call   800838 <skip_slash>
  800d9e:	89 c6                	mov    %eax,%esi
	f = &super->s_root;
  800da0:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800da5:	83 c0 08             	add    $0x8,%eax
  800da8:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
	dir = 0;
	name[0] = 0;
  800dae:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800db5:	85 ff                	test   %edi,%edi
  800db7:	74 06                	je     800dbf <walk_path+0x40>
		*pdir = 0;
  800db9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*pf = 0;
  800dbf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800dc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
	dir = 0;
  800dcb:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  800dd2:	00 00 00 
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800dd5:	e9 cd 00 00 00       	jmp    800ea7 <walk_path+0x128>
		dir = f;
  800dda:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800de0:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		p = path;
		while (*path != '/' && *path != '\0')
  800de6:	89 f3                	mov    %esi,%ebx
  800de8:	eb 03                	jmp    800ded <walk_path+0x6e>
			path++;
  800dea:	83 c3 01             	add    $0x1,%ebx
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800ded:	0f b6 03             	movzbl (%ebx),%eax
  800df0:	3c 2f                	cmp    $0x2f,%al
  800df2:	74 04                	je     800df8 <walk_path+0x79>
  800df4:	84 c0                	test   %al,%al
  800df6:	75 f2                	jne    800dea <walk_path+0x6b>
			path++;
		if (path - p >= MAXNAMELEN)
  800df8:	89 df                	mov    %ebx,%edi
  800dfa:	29 f7                	sub    %esi,%edi
  800dfc:	83 ff 7f             	cmp    $0x7f,%edi
  800dff:	0f 8f d2 00 00 00    	jg     800ed7 <walk_path+0x158>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800e05:	83 ec 04             	sub    $0x4,%esp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800e10:	50                   	push   %eax
  800e11:	e8 ab 15 00 00       	call   8023c1 <memmove>
		name[path - p] = '\0';
  800e16:	c6 84 3d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%edi,1)
  800e1d:	00 
		path = skip_slash(path);
  800e1e:	89 d8                	mov    %ebx,%eax
  800e20:	e8 13 fa ff ff       	call   800838 <skip_slash>
  800e25:	89 c6                	mov    %eax,%esi

		if (dir->f_type != FTYPE_DIR)
  800e27:	83 c4 10             	add    $0x10,%esp
  800e2a:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800e30:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800e37:	0f 85 a1 00 00 00    	jne    800ede <walk_path+0x15f>
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  800e3d:	8d 8d 64 ff ff ff    	lea    -0x9c(%ebp),%ecx
  800e43:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800e49:	e8 7d fe ff ff       	call   800ccb <dir_lookup>
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	79 55                	jns    800ea7 <walk_path+0x128>
  800e52:	89 c2                	mov    %eax,%edx
			if (r == -E_NOT_FOUND && *path == '\0') {
  800e54:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800e57:	0f 85 86 00 00 00    	jne    800ee3 <walk_path+0x164>
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800e5d:	ba f5 ff ff ff       	mov    $0xfffffff5,%edx

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800e62:	80 3e 00             	cmpb   $0x0,(%esi)
  800e65:	75 7c                	jne    800ee3 <walk_path+0x164>
				if (pdir)
  800e67:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	74 08                	je     800e79 <walk_path+0xfa>
					*pdir = dir;
  800e71:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800e77:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800e79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e7d:	74 15                	je     800e94 <walk_path+0x115>
					strcpy(lastelem, name);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	ff 75 08             	pushl  0x8(%ebp)
  800e8c:	e8 9d 13 00 00       	call   80222e <strcpy>
  800e91:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800e94:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800e9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  800ea0:	ba f5 ff ff ff       	mov    $0xfffffff5,%edx
  800ea5:	eb 3c                	jmp    800ee3 <walk_path+0x164>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800ea7:	80 3e 00             	cmpb   $0x0,(%esi)
  800eaa:	0f 85 2a ff ff ff    	jne    800dda <walk_path+0x5b>
			}
			return r;
		}
	}

	if (pdir)
  800eb0:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	74 08                	je     800ec2 <walk_path+0x143>
		*pdir = dir;
  800eba:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800ec0:	89 08                	mov    %ecx,(%eax)
	*pf = f;
  800ec2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800ec8:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800ece:	89 01                	mov    %eax,(%ecx)
	return 0;
  800ed0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed5:	eb 0c                	jmp    800ee3 <walk_path+0x164>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  800ed7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  800edc:	eb 05                	jmp    800ee3 <walk_path+0x164>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  800ede:	ba f5 ff ff ff       	mov    $0xfffffff5,%edx

	if (pdir)
		*pdir = dir;
	*pf = f;
	return 0;
}
  800ee3:	89 d0                	mov    %edx,%eax
  800ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 2c             	sub    $0x2c,%esp
  800ef6:	89 c6                	mov    %eax,%esi
  800ef8:	89 55 d0             	mov    %edx,-0x30(%ebp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  800efb:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800f01:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800f06:	74 19                	je     800f21 <dir_alloc_file+0x34>
  800f08:	68 a9 3b 80 00       	push   $0x803ba9
  800f0d:	68 3d 39 80 00       	push   $0x80393d
  800f12:	68 ff 00 00 00       	push   $0xff
  800f17:	68 f2 3a 80 00       	push   $0x803af2
  800f1c:	e8 c2 0c 00 00       	call   801be3 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800f21:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800f27:	85 c0                	test   %eax,%eax
  800f29:	0f 48 c2             	cmovs  %edx,%eax
  800f2c:	c1 f8 0c             	sar    $0xc,%eax
  800f2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800f32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (i = 0; i < nblock; i++) {
  800f35:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800f3a:	8d 7d e4             	lea    -0x1c(%ebp),%edi
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800f3d:	eb 3a                	jmp    800f79 <dir_alloc_file+0x8c>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800f3f:	83 ec 04             	sub    $0x4,%esp
  800f42:	57                   	push   %edi
  800f43:	53                   	push   %ebx
  800f44:	56                   	push   %esi
  800f45:	e8 f9 fc ff ff       	call   800c43 <file_get_block>
  800f4a:	83 c4 10             	add    $0x10,%esp
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	78 5b                	js     800fac <dir_alloc_file+0xbf>
			return r;
		f = (struct File *) blk;
  800f51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f54:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  800f5a:	89 c1                	mov    %eax,%ecx
  800f5c:	80 38 00             	cmpb   $0x0,(%eax)
  800f5f:	75 0c                	jne    800f6d <dir_alloc_file+0x80>
				*file = &f[j];
  800f61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f64:	89 08                	mov    %ecx,(%eax)
				return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 3f                	jmp    800fac <dir_alloc_file+0xbf>
  800f6d:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File *) blk;
		for (j = 0; j < BLKFILES; j++)
  800f72:	39 d0                	cmp    %edx,%eax
  800f74:	75 e4                	jne    800f5a <dir_alloc_file+0x6d>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800f76:	83 c3 01             	add    $0x1,%ebx
  800f79:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  800f7c:	75 c1                	jne    800f3f <dir_alloc_file+0x52>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  800f7e:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  800f85:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  800f88:	83 ec 04             	sub    $0x4,%esp
  800f8b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 cc             	pushl  -0x34(%ebp)
  800f92:	56                   	push   %esi
  800f93:	e8 ab fc ff ff       	call   800c43 <file_get_block>
  800f98:	83 c4 10             	add    $0x10,%esp
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	78 0d                	js     800fac <dir_alloc_file+0xbf>
		return r;
	f = (struct File *) blk;
	*file = &f[0];
  800f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fa2:	8b 7d d0             	mov    -0x30(%ebp),%edi
  800fa5:	89 07                	mov    %eax,(%edi)
	return 0;
  800fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    

00800fb4 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800fba:	6a 00                	push   $0x0
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	e8 b3 fd ff ff       	call   800d7f <walk_path>
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 2c             	sub    $0x2c,%esp
  800fd7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800fda:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800fe6:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800feb:	39 ca                	cmp    %ecx,%edx
  800fed:	7e 7c                	jle    80106b <file_read+0x9d>
		return 0;

	count = MIN(count, f->f_size - offset);
  800fef:	29 ca                	sub    %ecx,%edx
  800ff1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ff4:	0f 47 55 10          	cmova  0x10(%ebp),%edx
  800ff8:	89 55 d0             	mov    %edx,-0x30(%ebp)

	for (pos = offset; pos < offset + count;) {
  800ffb:	89 ce                	mov    %ecx,%esi
  800ffd:	01 d1                	add    %edx,%ecx
  800fff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801002:	eb 5d                	jmp    801061 <file_read+0x93>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80100a:	50                   	push   %eax
  80100b:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  801011:	85 f6                	test   %esi,%esi
  801013:	0f 49 c6             	cmovns %esi,%eax
  801016:	c1 f8 0c             	sar    $0xc,%eax
  801019:	50                   	push   %eax
  80101a:	ff 75 08             	pushl  0x8(%ebp)
  80101d:	e8 21 fc ff ff       	call   800c43 <file_get_block>
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	85 c0                	test   %eax,%eax
  801027:	78 42                	js     80106b <file_read+0x9d>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801029:	89 f2                	mov    %esi,%edx
  80102b:	c1 fa 1f             	sar    $0x1f,%edx
  80102e:	c1 ea 14             	shr    $0x14,%edx
  801031:	8d 04 16             	lea    (%esi,%edx,1),%eax
  801034:	25 ff 0f 00 00       	and    $0xfff,%eax
  801039:	29 d0                	sub    %edx,%eax
  80103b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80103e:	29 da                	sub    %ebx,%edx
  801040:	bb 00 10 00 00       	mov    $0x1000,%ebx
  801045:	29 c3                	sub    %eax,%ebx
  801047:	39 da                	cmp    %ebx,%edx
  801049:	0f 46 da             	cmovbe %edx,%ebx
		memmove(buf, blk + pos % BLKSIZE, bn);
  80104c:	83 ec 04             	sub    $0x4,%esp
  80104f:	53                   	push   %ebx
  801050:	03 45 e4             	add    -0x1c(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	57                   	push   %edi
  801055:	e8 67 13 00 00       	call   8023c1 <memmove>
		pos += bn;
  80105a:	01 de                	add    %ebx,%esi
		buf += bn;
  80105c:	01 df                	add    %ebx,%edi
  80105e:	83 c4 10             	add    $0x10,%esp
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count;) {
  801061:	89 f3                	mov    %esi,%ebx
  801063:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  801066:	77 9c                	ja     801004 <file_read+0x36>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801068:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  80106b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
  801078:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80107b:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (f->f_size > newsize)
  80107e:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
  801084:	7e 09                	jle    80108f <file_set_size+0x1c>
		file_truncate_blocks(f, newsize);
  801086:	89 f2                	mov    %esi,%edx
  801088:	89 d8                	mov    %ebx,%eax
  80108a:	e8 1c fa ff ff       	call   800aab <file_truncate_blocks>
	f->f_size = newsize;
  80108f:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
	flush_block(f);
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	53                   	push   %ebx
  801099:	e8 e3 f3 ff ff       	call   800481 <flush_block>
	return 0;
}
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a6:	5b                   	pop    %ebx
  8010a7:	5e                   	pop    %esi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	57                   	push   %edi
  8010ae:	56                   	push   %esi
  8010af:	53                   	push   %ebx
  8010b0:	83 ec 2c             	sub    $0x2c,%esp
  8010b3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8010b6:	8b 75 14             	mov    0x14(%ebp),%esi
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  8010b9:	89 f0                	mov    %esi,%eax
  8010bb:	03 45 10             	add    0x10(%ebp),%eax
  8010be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8010c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c4:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  8010ca:	76 72                	jbe    80113e <file_write+0x94>
		if ((r = file_set_size(f, offset + count)) < 0)
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	50                   	push   %eax
  8010d0:	51                   	push   %ecx
  8010d1:	e8 9d ff ff ff       	call   801073 <file_set_size>
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	79 61                	jns    80113e <file_write+0x94>
  8010dd:	eb 69                	jmp    801148 <file_write+0x9e>
			return r;

	for (pos = offset; pos < offset + count;) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e5:	50                   	push   %eax
  8010e6:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  8010ec:	85 f6                	test   %esi,%esi
  8010ee:	0f 49 c6             	cmovns %esi,%eax
  8010f1:	c1 f8 0c             	sar    $0xc,%eax
  8010f4:	50                   	push   %eax
  8010f5:	ff 75 08             	pushl  0x8(%ebp)
  8010f8:	e8 46 fb ff ff       	call   800c43 <file_get_block>
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	78 44                	js     801148 <file_write+0x9e>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801104:	89 f2                	mov    %esi,%edx
  801106:	c1 fa 1f             	sar    $0x1f,%edx
  801109:	c1 ea 14             	shr    $0x14,%edx
  80110c:	8d 04 16             	lea    (%esi,%edx,1),%eax
  80110f:	25 ff 0f 00 00       	and    $0xfff,%eax
  801114:	29 d0                	sub    %edx,%eax
  801116:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801119:	29 d9                	sub    %ebx,%ecx
  80111b:	89 cb                	mov    %ecx,%ebx
  80111d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	39 d1                	cmp    %edx,%ecx
  801126:	0f 47 da             	cmova  %edx,%ebx
		memmove(blk + pos % BLKSIZE, buf, bn);
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	53                   	push   %ebx
  80112d:	57                   	push   %edi
  80112e:	03 45 e4             	add    -0x1c(%ebp),%eax
  801131:	50                   	push   %eax
  801132:	e8 8a 12 00 00       	call   8023c1 <memmove>
		pos += bn;
  801137:	01 de                	add    %ebx,%esi
		buf += bn;
  801139:	01 df                	add    %ebx,%edi
  80113b:	83 c4 10             	add    $0x10,%esp
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count;) {
  80113e:	89 f3                	mov    %esi,%ebx
  801140:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  801143:	77 9a                	ja     8010df <file_write+0x35>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5f                   	pop    %edi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	56                   	push   %esi
  801154:	53                   	push   %ebx
  801155:	83 ec 10             	sub    $0x10,%esp
  801158:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  80115b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801160:	eb 3c                	jmp    80119e <file_flush+0x4e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	6a 00                	push   $0x0
  801167:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  80116a:	89 da                	mov    %ebx,%edx
  80116c:	89 f0                	mov    %esi,%eax
  80116e:	e8 1e f8 ff ff       	call   800991 <file_block_walk>
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	85 c0                	test   %eax,%eax
  801178:	78 21                	js     80119b <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  80117a:	8b 45 f4             	mov    -0xc(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80117d:	85 c0                	test   %eax,%eax
  80117f:	74 1a                	je     80119b <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801181:	8b 00                	mov    (%eax),%eax
  801183:	85 c0                	test   %eax,%eax
  801185:	74 14                	je     80119b <file_flush+0x4b>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801187:	83 ec 0c             	sub    $0xc,%esp
  80118a:	50                   	push   %eax
  80118b:	e8 73 f2 ff ff       	call   800403 <diskaddr>
  801190:	89 04 24             	mov    %eax,(%esp)
  801193:	e8 e9 f2 ff ff       	call   800481 <flush_block>
  801198:	83 c4 10             	add    $0x10,%esp
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  80119b:	83 c3 01             	add    $0x1,%ebx
  80119e:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  8011a4:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8011aa:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  8011b0:	85 c9                	test   %ecx,%ecx
  8011b2:	0f 49 c1             	cmovns %ecx,%eax
  8011b5:	c1 f8 0c             	sar    $0xc,%eax
  8011b8:	39 c3                	cmp    %eax,%ebx
  8011ba:	7c a6                	jl     801162 <file_flush+0x12>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  8011bc:	83 ec 0c             	sub    $0xc,%esp
  8011bf:	56                   	push   %esi
  8011c0:	e8 bc f2 ff ff       	call   800481 <flush_block>
	if (f->f_indirect)
  8011c5:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	74 14                	je     8011e6 <file_flush+0x96>
		flush_block(diskaddr(f->f_indirect));
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	50                   	push   %eax
  8011d6:	e8 28 f2 ff ff       	call   800403 <diskaddr>
  8011db:	89 04 24             	mov    %eax,(%esp)
  8011de:	e8 9e f2 ff ff       	call   800481 <flush_block>
  8011e3:	83 c4 10             	add    $0x10,%esp
}
  8011e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e9:	5b                   	pop    %ebx
  8011ea:	5e                   	pop    %esi
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8011f6:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  8011fc:	50                   	push   %eax
  8011fd:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  801203:	8d 95 74 ff ff ff    	lea    -0x8c(%ebp),%edx
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	e8 6e fb ff ff       	call   800d7f <walk_path>
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	85 c0                	test   %eax,%eax
  801216:	74 5d                	je     801275 <file_create+0x88>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  801218:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80121b:	75 5d                	jne    80127a <file_create+0x8d>
  80121d:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
		return r;
  801223:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  801228:	85 c9                	test   %ecx,%ecx
  80122a:	74 4e                	je     80127a <file_create+0x8d>
		return r;
	if ((r = dir_alloc_file(dir, &f)) < 0)
  80122c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  801232:	89 c8                	mov    %ecx,%eax
  801234:	e8 b4 fc ff ff       	call   800eed <dir_alloc_file>
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 3d                	js     80127a <file_create+0x8d>
		return r;

	strcpy(f->f_name, name);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  801246:	50                   	push   %eax
  801247:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  80124d:	e8 dc 0f 00 00       	call   80222e <strcpy>
	*pf = f;
  801252:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  80125d:	83 c4 04             	add    $0x4,%esp
  801260:	ff b5 74 ff ff ff    	pushl  -0x8c(%ebp)
  801266:	e8 e5 fe ff ff       	call   801150 <file_flush>
	return 0;
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
  801273:	eb 05                	jmp    80127a <file_create+0x8d>
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
		return -E_FILE_EXISTS;
  801275:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax

	strcpy(f->f_name, name);
	*pf = f;
	file_flush(dir);
	return 0;
}
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	53                   	push   %ebx
  801280:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801283:	bb 01 00 00 00       	mov    $0x1,%ebx
  801288:	eb 17                	jmp    8012a1 <fs_sync+0x25>
		flush_block(diskaddr(i));
  80128a:	83 ec 0c             	sub    $0xc,%esp
  80128d:	53                   	push   %ebx
  80128e:	e8 70 f1 ff ff       	call   800403 <diskaddr>
  801293:	89 04 24             	mov    %eax,(%esp)
  801296:	e8 e6 f1 ff ff       	call   800481 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80129b:	83 c3 01             	add    $0x1,%ebx
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8012a6:	39 58 04             	cmp    %ebx,0x4(%eax)
  8012a9:	77 df                	ja     80128a <fs_sync+0xe>
		flush_block(diskaddr(i));
}
  8012ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <outw>:
		     : "cc");
}

static inline void
outw(int port, uint16_t data)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	89 c1                	mov    %eax,%ecx
  8012b5:	89 d0                	mov    %edx,%eax
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8012b7:	89 ca                	mov    %ecx,%edx
  8012b9:	66 ef                	out    %ax,(%dx)
}
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8012c3:	e8 b4 ff ff ff       	call   80127c <fs_sync>
	return 0;
}
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *) 0x0ffff000;

void
serve_init(void)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	ba 60 50 80 00       	mov    $0x805060,%edx
	int i;
	uintptr_t va = FILEVA;
  8012d7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8012dc:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  8012e1:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd *) va;
  8012e3:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  8012e6:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  8012ec:	83 c0 01             	add    $0x1,%eax
  8012ef:	83 c2 10             	add    $0x10,%edx
  8012f2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012f7:	75 e8                	jne    8012e1 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd *) va;
		va += PGSIZE;
	}
}
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	56                   	push   %esi
  8012ff:	53                   	push   %ebx
  801300:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801303:	bb 00 00 00 00       	mov    $0x0,%ebx
		switch (pageref(opentab[i].o_fd)) {
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	89 d8                	mov    %ebx,%eax
  80130d:	c1 e0 04             	shl    $0x4,%eax
  801310:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  801316:	e8 32 1e 00 00       	call   80314d <pageref>
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	74 07                	je     801329 <openfile_alloc+0x2e>
  801322:	83 f8 01             	cmp    $0x1,%eax
  801325:	74 20                	je     801347 <openfile_alloc+0x4c>
  801327:	eb 51                	jmp    80137a <openfile_alloc+0x7f>
		case 0:
			if ((r = sys_page_alloc(0,
  801329:	83 ec 04             	sub    $0x4,%esp
  80132c:	6a 07                	push   $0x7
			                        opentab[i].o_fd,
  80132e:	89 d8                	mov    %ebx,%eax
  801330:	c1 e0 04             	shl    $0x4,%eax

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
		switch (pageref(opentab[i].o_fd)) {
		case 0:
			if ((r = sys_page_alloc(0,
  801333:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  801339:	6a 00                	push   $0x0
  80133b:	e8 37 13 00 00       	call   802677 <sys_page_alloc>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	78 43                	js     80138a <openfile_alloc+0x8f>
			                        opentab[i].o_fd,
			                        PTE_P | PTE_U | PTE_W)) < 0)
				return r;
		/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  801347:	c1 e3 04             	shl    $0x4,%ebx
  80134a:	8d 83 60 50 80 00    	lea    0x805060(%ebx),%eax
  801350:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  801357:	04 00 00 
			*o = &opentab[i];
  80135a:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	68 00 10 00 00       	push   $0x1000
  801364:	6a 00                	push   $0x0
  801366:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  80136c:	e8 02 10 00 00       	call   802373 <memset>
			return (*o)->o_fileid;
  801371:	8b 06                	mov    (%esi),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	eb 10                	jmp    80138a <openfile_alloc+0x8f>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  80137a:	83 c3 01             	add    $0x1,%ebx
  80137d:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801383:	75 83                	jne    801308 <openfile_alloc+0xd>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  801385:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80138a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138d:	5b                   	pop    %ebx
  80138e:	5e                   	pop    %esi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    

00801391 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	57                   	push   %edi
  801395:	56                   	push   %esi
  801396:	53                   	push   %ebx
  801397:	83 ec 18             	sub    $0x18,%esp
  80139a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80139d:	89 fb                	mov    %edi,%ebx
  80139f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8013a5:	89 de                	mov    %ebx,%esi
  8013a7:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8013aa:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8013b0:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8013b6:	e8 92 1d 00 00       	call   80314d <pageref>
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	83 f8 01             	cmp    $0x1,%eax
  8013c1:	7e 17                	jle    8013da <openfile_lookup+0x49>
  8013c3:	c1 e3 04             	shl    $0x4,%ebx
  8013c6:	3b bb 60 50 80 00    	cmp    0x805060(%ebx),%edi
  8013cc:	75 13                	jne    8013e1 <openfile_lookup+0x50>
		return -E_INVAL;
	*po = o;
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	89 30                	mov    %esi,(%eax)
	return 0;
  8013d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d8:	eb 0c                	jmp    8013e6 <openfile_lookup+0x55>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
		return -E_INVAL;
  8013da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013df:	eb 05                	jmp    8013e6 <openfile_lookup+0x55>
  8013e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  8013e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5f                   	pop    %edi
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 18             	sub    $0x18,%esp
  8013f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fb:	50                   	push   %eax
  8013fc:	ff 33                	pushl  (%ebx)
  8013fe:	ff 75 08             	pushl  0x8(%ebp)
  801401:	e8 8b ff ff ff       	call   801391 <openfile_lookup>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 14                	js     801421 <serve_set_size+0x33>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	ff 73 04             	pushl  0x4(%ebx)
  801413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801416:	ff 70 04             	pushl  0x4(%eax)
  801419:	e8 55 fc ff ff       	call   801073 <file_set_size>
  80141e:	83 c4 10             	add    $0x10,%esp
}
  801421:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	53                   	push   %ebx
  80142a:	83 ec 18             	sub    $0x18,%esp
  80142d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		        req->req_fileid,
		        req->req_n);

	// Lab 5: Your code here:
	struct OpenFile* open_file;
    int result = openfile_lookup(envid, req->req_fileid, &open_file);
  801430:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801433:	50                   	push   %eax
  801434:	ff 33                	pushl  (%ebx)
  801436:	ff 75 08             	pushl  0x8(%ebp)
  801439:	e8 53 ff ff ff       	call   801391 <openfile_lookup>
	if (result < 0)
  80143e:	83 c4 10             	add    $0x10,%esp
		return result;
  801441:	89 c2                	mov    %eax,%edx
		        req->req_n);

	// Lab 5: Your code here:
	struct OpenFile* open_file;
    int result = openfile_lookup(envid, req->req_fileid, &open_file);
	if (result < 0)
  801443:	85 c0                	test   %eax,%eax
  801445:	78 2b                	js     801472 <serve_read+0x4c>
		return result;
	result = file_read(open_file->o_file, ret->ret_buf,req->req_n, open_file->o_fd->fd_offset);
  801447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144a:	8b 50 0c             	mov    0xc(%eax),%edx
  80144d:	ff 72 04             	pushl  0x4(%edx)
  801450:	ff 73 04             	pushl  0x4(%ebx)
  801453:	53                   	push   %ebx
  801454:	ff 70 04             	pushl  0x4(%eax)
  801457:	e8 72 fb ff ff       	call   800fce <file_read>
	if (result < 0)
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	78 0d                	js     801470 <serve_read+0x4a>
		return result;

	open_file->o_fd->fd_offset += result;
  801463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801466:	8b 52 0c             	mov    0xc(%edx),%edx
  801469:	01 42 04             	add    %eax,0x4(%edx)
	return result;	
  80146c:	89 c2                	mov    %eax,%edx
  80146e:	eb 02                	jmp    801472 <serve_read+0x4c>
    int result = openfile_lookup(envid, req->req_fileid, &open_file);
	if (result < 0)
		return result;
	result = file_read(open_file->o_file, ret->ret_buf,req->req_n, open_file->o_fd->fd_offset);
	if (result < 0)
		return result;
  801470:	89 c2                	mov    %eax,%edx

	open_file->o_fd->fd_offset += result;
	return result;	
}
  801472:	89 d0                	mov    %edx,%eax
  801474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	53                   	push   %ebx
  80147d:	83 ec 18             	sub    $0x18,%esp
  801480:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		        req->req_fileid,
		        req->req_n);

	// LAB 5: Your code here.
	struct OpenFile* open_file;
	int result = openfile_lookup(envid,req->req_fileid, &open_file);
  801483:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801486:	50                   	push   %eax
  801487:	ff 33                	pushl  (%ebx)
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 00 ff ff ff       	call   801391 <openfile_lookup>
	if (result < 0)
  801491:	83 c4 10             	add    $0x10,%esp
		return result;
  801494:	89 c2                	mov    %eax,%edx
		        req->req_n);

	// LAB 5: Your code here.
	struct OpenFile* open_file;
	int result = openfile_lookup(envid,req->req_fileid, &open_file);
	if (result < 0)
  801496:	85 c0                	test   %eax,%eax
  801498:	78 2e                	js     8014c8 <serve_write+0x4f>
		return result;

	result = file_write(open_file->o_file, req->req_buf, req->req_n, open_file->o_fd->fd_offset);
  80149a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149d:	8b 50 0c             	mov    0xc(%eax),%edx
  8014a0:	ff 72 04             	pushl  0x4(%edx)
  8014a3:	ff 73 04             	pushl  0x4(%ebx)
  8014a6:	83 c3 08             	add    $0x8,%ebx
  8014a9:	53                   	push   %ebx
  8014aa:	ff 70 04             	pushl  0x4(%eax)
  8014ad:	e8 f8 fb ff ff       	call   8010aa <file_write>
	if (result < 0)
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 0d                	js     8014c6 <serve_write+0x4d>
		return result;

	open_file->o_fd->fd_offset += result;
  8014b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8014bf:	01 42 04             	add    %eax,0x4(%edx)
	return result;
  8014c2:	89 c2                	mov    %eax,%edx
  8014c4:	eb 02                	jmp    8014c8 <serve_write+0x4f>
	if (result < 0)
		return result;

	result = file_write(open_file->o_file, req->req_buf, req->req_n, open_file->o_fd->fd_offset);
	if (result < 0)
		return result;
  8014c6:	89 c2                	mov    %eax,%edx

	open_file->o_fd->fd_offset += result;
	return result;
}
  8014c8:	89 d0                	mov    %edx,%eax
  8014ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	53                   	push   %ebx
  8014d3:	83 ec 18             	sub    $0x18,%esp
  8014d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014dc:	50                   	push   %eax
  8014dd:	ff 33                	pushl  (%ebx)
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	e8 aa fe ff ff       	call   801391 <openfile_lookup>
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 3f                	js     80152d <serve_stat+0x5e>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f4:	ff 70 04             	pushl  0x4(%eax)
  8014f7:	53                   	push   %ebx
  8014f8:	e8 31 0d 00 00       	call   80222e <strcpy>
	ret->ret_size = o->o_file->f_size;
  8014fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801500:	8b 50 04             	mov    0x4(%eax),%edx
  801503:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  801509:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80150f:	8b 40 04             	mov    0x4(%eax),%eax
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80151c:	0f 94 c0             	sete   %al
  80151f:	0f b6 c0             	movzbl %al,%eax
  801522:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801528:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801538:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	ff 30                	pushl  (%eax)
  801541:	ff 75 08             	pushl  0x8(%ebp)
  801544:	e8 48 fe ff ff       	call   801391 <openfile_lookup>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 16                	js     801566 <serve_flush+0x34>
		return r;
	file_flush(o->o_file);
  801550:	83 ec 0c             	sub    $0xc,%esp
  801553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801556:	ff 70 04             	pushl  0x4(%eax)
  801559:	e8 f2 fb ff ff       	call   801150 <file_flush>
	return 0;
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <serve_open>:
// Open req->req_path in mode req->req_omode, storing the Fd page and
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req, void **pg_store, int *perm_store)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	53                   	push   %ebx
  80156c:	81 ec 18 04 00 00    	sub    $0x418,%esp
  801572:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		        envid,
		        req->req_path,
		        req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  801575:	68 00 04 00 00       	push   $0x400
  80157a:	53                   	push   %ebx
  80157b:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	e8 3a 0e 00 00       	call   8023c1 <memmove>
	path[MAXPATHLEN - 1] = 0;
  801587:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  80158b:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801591:	89 04 24             	mov    %eax,(%esp)
  801594:	e8 62 fd ff ff       	call   8012fb <openfile_alloc>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	0f 88 f0 00 00 00    	js     801694 <serve_open+0x12c>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  8015a4:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8015ab:	74 33                	je     8015e0 <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8015ad:	83 ec 08             	sub    $0x8,%esp
  8015b0:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015bd:	50                   	push   %eax
  8015be:	e8 2a fc ff ff       	call   8011ed <file_create>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	79 37                	jns    801601 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8015ca:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  8015d1:	0f 85 bd 00 00 00    	jne    801694 <serve_open+0x12c>
  8015d7:	83 f8 f3             	cmp    $0xfffffff3,%eax
  8015da:	0f 85 b4 00 00 00    	jne    801694 <serve_open+0x12c>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
	try_open:
		if ((r = file_open(path, &f)) < 0) {
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015e9:	50                   	push   %eax
  8015ea:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015f0:	50                   	push   %eax
  8015f1:	e8 be f9 ff ff       	call   800fb4 <file_open>
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	0f 88 93 00 00 00    	js     801694 <serve_open+0x12c>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  801601:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  801608:	74 17                	je     801621 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	6a 00                	push   $0x0
  80160f:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  801615:	e8 59 fa ff ff       	call   801073 <file_set_size>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 73                	js     801694 <serve_open+0x12c>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
		}
	}
	if ((r = file_open(path, &f)) < 0) {
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80162a:	50                   	push   %eax
  80162b:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801631:	50                   	push   %eax
  801632:	e8 7d f9 ff ff       	call   800fb4 <file_open>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 56                	js     801694 <serve_open+0x12c>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  80163e:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801644:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  80164a:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  80164d:	8b 50 0c             	mov    0xc(%eax),%edx
  801650:	8b 08                	mov    (%eax),%ecx
  801652:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801655:	8b 48 0c             	mov    0xc(%eax),%ecx
  801658:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80165e:	83 e2 03             	and    $0x3,%edx
  801661:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801664:	8b 40 0c             	mov    0xc(%eax),%eax
  801667:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80166d:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  80166f:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801675:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80167b:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80167e:	8b 50 0c             	mov    0xc(%eax),%edx
  801681:	8b 45 10             	mov    0x10(%ebp),%eax
  801684:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P | PTE_U | PTE_W | PTE_SHARE;
  801686:	8b 45 14             	mov    0x14(%ebp),%eax
  801689:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <serve>:
	[FSREQ_SYNC] = serve_sync
};

void
serve(void)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	56                   	push   %esi
  80169d:	53                   	push   %ebx
  80169e:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016a1:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8016a4:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  8016a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	53                   	push   %ebx
  8016b2:	ff 35 44 50 80 00    	pushl  0x805044
  8016b8:	56                   	push   %esi
  8016b9:	e8 69 11 00 00       	call   802827 <ipc_recv>
			        whom,
			        uvpt[PGNUM(fsreq)],
			        fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  8016c5:	75 15                	jne    8016dc <serve+0x43>
			cprintf("Invalid request from %08x: no argument page\n",
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8016cd:	68 c8 3b 80 00       	push   $0x803bc8
  8016d2:	e8 e5 05 00 00       	call   801cbc <cprintf>
			        whom);
			continue;  // just leave it hanging...
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	eb cb                	jmp    8016a7 <serve+0xe>
		}

		pg = NULL;
  8016dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8016e3:	83 f8 01             	cmp    $0x1,%eax
  8016e6:	75 18                	jne    801700 <serve+0x67>
			r = serve_open(whom, (struct Fsreq_open *) fsreq, &pg, &perm);
  8016e8:	53                   	push   %ebx
  8016e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016ec:	50                   	push   %eax
  8016ed:	ff 35 44 50 80 00    	pushl  0x805044
  8016f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f6:	e8 6d fe ff ff       	call   801568 <serve_open>
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	eb 3c                	jmp    80173c <serve+0xa3>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  801700:	83 f8 08             	cmp    $0x8,%eax
  801703:	77 1e                	ja     801723 <serve+0x8a>
  801705:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  80170c:	85 d2                	test   %edx,%edx
  80170e:	74 13                	je     801723 <serve+0x8a>
			r = handlers[req](whom, fsreq);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	ff 35 44 50 80 00    	pushl  0x805044
  801719:	ff 75 f4             	pushl  -0xc(%ebp)
  80171c:	ff d2                	call   *%edx
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	eb 19                	jmp    80173c <serve+0xa3>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	ff 75 f4             	pushl  -0xc(%ebp)
  801729:	50                   	push   %eax
  80172a:	68 f8 3b 80 00       	push   $0x803bf8
  80172f:	e8 88 05 00 00       	call   801cbc <cprintf>
  801734:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801737:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80173c:	ff 75 f0             	pushl  -0x10(%ebp)
  80173f:	ff 75 ec             	pushl  -0x14(%ebp)
  801742:	50                   	push   %eax
  801743:	ff 75 f4             	pushl  -0xc(%ebp)
  801746:	e8 47 11 00 00       	call   802892 <ipc_send>
		sys_page_unmap(0, fsreq);
  80174b:	83 c4 08             	add    $0x8,%esp
  80174e:	ff 35 44 50 80 00    	pushl  0x805044
  801754:	6a 00                	push   $0x0
  801756:	e8 66 0f 00 00       	call   8026c1 <sys_page_unmap>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	e9 44 ff ff ff       	jmp    8016a7 <serve+0xe>

00801763 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801769:	c7 05 60 90 80 00 1b 	movl   $0x803c1b,0x809060
  801770:	3c 80 00 
	cprintf("FS is running\n");
  801773:	68 1e 3c 80 00       	push   $0x803c1e
  801778:	e8 3f 05 00 00       	call   801cbc <cprintf>

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
  80177d:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801782:	b8 00 8a 00 00       	mov    $0x8a00,%eax
  801787:	e8 24 fb ff ff       	call   8012b0 <outw>
	cprintf("FS can do I/O\n");
  80178c:	c7 04 24 2d 3c 80 00 	movl   $0x803c2d,(%esp)
  801793:	e8 24 05 00 00       	call   801cbc <cprintf>

	serve_init();
  801798:	e8 32 fb ff ff       	call   8012cf <serve_init>
	fs_init();
  80179d:	e8 42 f4 ff ff       	call   800be4 <fs_init>
	fs_test();
  8017a2:	e8 05 00 00 00       	call   8017ac <fs_test>
	serve();
  8017a7:	e8 ed fe ff ff       	call   801699 <serve>

008017ac <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8017b3:	6a 07                	push   $0x7
  8017b5:	68 00 10 00 00       	push   $0x1000
  8017ba:	6a 00                	push   $0x0
  8017bc:	e8 b6 0e 00 00       	call   802677 <sys_page_alloc>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	79 12                	jns    8017da <fs_test+0x2e>
		panic("sys_page_alloc: %e", r);
  8017c8:	50                   	push   %eax
  8017c9:	68 3c 3c 80 00       	push   $0x803c3c
  8017ce:	6a 12                	push   $0x12
  8017d0:	68 4f 3c 80 00       	push   $0x803c4f
  8017d5:	e8 09 04 00 00       	call   801be3 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 00 10 00 00       	push   $0x1000
  8017e2:	ff 35 04 a0 80 00    	pushl  0x80a004
  8017e8:	68 00 10 00 00       	push   $0x1000
  8017ed:	e8 cf 0b 00 00       	call   8023c1 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8017f2:	e8 1f f1 ff ff       	call   800916 <alloc_block>
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	79 12                	jns    801810 <fs_test+0x64>
		panic("alloc_block: %e", r);
  8017fe:	50                   	push   %eax
  8017ff:	68 59 3c 80 00       	push   $0x803c59
  801804:	6a 17                	push   $0x17
  801806:	68 4f 3c 80 00       	push   $0x803c4f
  80180b:	e8 d3 03 00 00       	call   801be3 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801810:	8d 50 1f             	lea    0x1f(%eax),%edx
  801813:	85 c0                	test   %eax,%eax
  801815:	0f 49 d0             	cmovns %eax,%edx
  801818:	c1 fa 05             	sar    $0x5,%edx
  80181b:	89 c3                	mov    %eax,%ebx
  80181d:	c1 fb 1f             	sar    $0x1f,%ebx
  801820:	c1 eb 1b             	shr    $0x1b,%ebx
  801823:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  801826:	83 e1 1f             	and    $0x1f,%ecx
  801829:	29 d9                	sub    %ebx,%ecx
  80182b:	b8 01 00 00 00       	mov    $0x1,%eax
  801830:	d3 e0                	shl    %cl,%eax
  801832:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  801839:	75 16                	jne    801851 <fs_test+0xa5>
  80183b:	68 69 3c 80 00       	push   $0x803c69
  801840:	68 3d 39 80 00       	push   $0x80393d
  801845:	6a 19                	push   $0x19
  801847:	68 4f 3c 80 00       	push   $0x803c4f
  80184c:	e8 92 03 00 00       	call   801be3 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801851:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  801857:	85 04 91             	test   %eax,(%ecx,%edx,4)
  80185a:	74 16                	je     801872 <fs_test+0xc6>
  80185c:	68 e4 3d 80 00       	push   $0x803de4
  801861:	68 3d 39 80 00       	push   $0x80393d
  801866:	6a 1b                	push   $0x1b
  801868:	68 4f 3c 80 00       	push   $0x803c4f
  80186d:	e8 71 03 00 00       	call   801be3 <_panic>
	cprintf("alloc_block is good\n");
  801872:	83 ec 0c             	sub    $0xc,%esp
  801875:	68 84 3c 80 00       	push   $0x803c84
  80187a:	e8 3d 04 00 00       	call   801cbc <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  80187f:	83 c4 08             	add    $0x8,%esp
  801882:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801885:	50                   	push   %eax
  801886:	68 99 3c 80 00       	push   $0x803c99
  80188b:	e8 24 f7 ff ff       	call   800fb4 <file_open>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801896:	74 1b                	je     8018b3 <fs_test+0x107>
  801898:	89 c2                	mov    %eax,%edx
  80189a:	c1 ea 1f             	shr    $0x1f,%edx
  80189d:	84 d2                	test   %dl,%dl
  80189f:	74 12                	je     8018b3 <fs_test+0x107>
		panic("file_open /not-found: %e", r);
  8018a1:	50                   	push   %eax
  8018a2:	68 a4 3c 80 00       	push   $0x803ca4
  8018a7:	6a 1f                	push   $0x1f
  8018a9:	68 4f 3c 80 00       	push   $0x803c4f
  8018ae:	e8 30 03 00 00       	call   801be3 <_panic>
	else if (r == 0)
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	75 14                	jne    8018cb <fs_test+0x11f>
		panic("file_open /not-found succeeded!");
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	68 04 3e 80 00       	push   $0x803e04
  8018bf:	6a 21                	push   $0x21
  8018c1:	68 4f 3c 80 00       	push   $0x803c4f
  8018c6:	e8 18 03 00 00       	call   801be3 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d1:	50                   	push   %eax
  8018d2:	68 bd 3c 80 00       	push   $0x803cbd
  8018d7:	e8 d8 f6 ff ff       	call   800fb4 <file_open>
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	79 12                	jns    8018f5 <fs_test+0x149>
		panic("file_open /newmotd: %e", r);
  8018e3:	50                   	push   %eax
  8018e4:	68 c6 3c 80 00       	push   $0x803cc6
  8018e9:	6a 23                	push   $0x23
  8018eb:	68 4f 3c 80 00       	push   $0x803c4f
  8018f0:	e8 ee 02 00 00       	call   801be3 <_panic>
	cprintf("file_open is good\n");
  8018f5:	83 ec 0c             	sub    $0xc,%esp
  8018f8:	68 dd 3c 80 00       	push   $0x803cdd
  8018fd:	e8 ba 03 00 00       	call   801cbc <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801902:	83 c4 0c             	add    $0xc,%esp
  801905:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801908:	50                   	push   %eax
  801909:	6a 00                	push   $0x0
  80190b:	ff 75 f4             	pushl  -0xc(%ebp)
  80190e:	e8 30 f3 ff ff       	call   800c43 <file_get_block>
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	85 c0                	test   %eax,%eax
  801918:	79 12                	jns    80192c <fs_test+0x180>
		panic("file_get_block: %e", r);
  80191a:	50                   	push   %eax
  80191b:	68 f0 3c 80 00       	push   $0x803cf0
  801920:	6a 27                	push   $0x27
  801922:	68 4f 3c 80 00       	push   $0x803c4f
  801927:	e8 b7 02 00 00       	call   801be3 <_panic>
	if (strcmp(blk, msg) != 0)
  80192c:	83 ec 08             	sub    $0x8,%esp
  80192f:	68 24 3e 80 00       	push   $0x803e24
  801934:	ff 75 f0             	pushl  -0x10(%ebp)
  801937:	e8 9c 09 00 00       	call   8022d8 <strcmp>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	85 c0                	test   %eax,%eax
  801941:	74 14                	je     801957 <fs_test+0x1ab>
		panic("file_get_block returned wrong data");
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	68 4c 3e 80 00       	push   $0x803e4c
  80194b:	6a 29                	push   $0x29
  80194d:	68 4f 3c 80 00       	push   $0x803c4f
  801952:	e8 8c 02 00 00       	call   801be3 <_panic>
	cprintf("file_get_block is good\n");
  801957:	83 ec 0c             	sub    $0xc,%esp
  80195a:	68 03 3d 80 00       	push   $0x803d03
  80195f:	e8 58 03 00 00       	call   801cbc <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801967:	0f b6 10             	movzbl (%eax),%edx
  80196a:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196f:	c1 e8 0c             	shr    $0xc,%eax
  801972:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	a8 40                	test   $0x40,%al
  80197e:	75 16                	jne    801996 <fs_test+0x1ea>
  801980:	68 1c 3d 80 00       	push   $0x803d1c
  801985:	68 3d 39 80 00       	push   $0x80393d
  80198a:	6a 2d                	push   $0x2d
  80198c:	68 4f 3c 80 00       	push   $0x803c4f
  801991:	e8 4d 02 00 00       	call   801be3 <_panic>
	file_flush(f);
  801996:	83 ec 0c             	sub    $0xc,%esp
  801999:	ff 75 f4             	pushl  -0xc(%ebp)
  80199c:	e8 af f7 ff ff       	call   801150 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a4:	c1 e8 0c             	shr    $0xc,%eax
  8019a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	a8 40                	test   $0x40,%al
  8019b3:	74 16                	je     8019cb <fs_test+0x21f>
  8019b5:	68 1b 3d 80 00       	push   $0x803d1b
  8019ba:	68 3d 39 80 00       	push   $0x80393d
  8019bf:	6a 2f                	push   $0x2f
  8019c1:	68 4f 3c 80 00       	push   $0x803c4f
  8019c6:	e8 18 02 00 00       	call   801be3 <_panic>
	cprintf("file_flush is good\n");
  8019cb:	83 ec 0c             	sub    $0xc,%esp
  8019ce:	68 37 3d 80 00       	push   $0x803d37
  8019d3:	e8 e4 02 00 00       	call   801cbc <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8019d8:	83 c4 08             	add    $0x8,%esp
  8019db:	6a 00                	push   $0x0
  8019dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e0:	e8 8e f6 ff ff       	call   801073 <file_set_size>
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	79 12                	jns    8019fe <fs_test+0x252>
		panic("file_set_size: %e", r);
  8019ec:	50                   	push   %eax
  8019ed:	68 4b 3d 80 00       	push   $0x803d4b
  8019f2:	6a 33                	push   $0x33
  8019f4:	68 4f 3c 80 00       	push   $0x803c4f
  8019f9:	e8 e5 01 00 00       	call   801be3 <_panic>
	assert(f->f_direct[0] == 0);
  8019fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a01:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801a08:	74 16                	je     801a20 <fs_test+0x274>
  801a0a:	68 5d 3d 80 00       	push   $0x803d5d
  801a0f:	68 3d 39 80 00       	push   $0x80393d
  801a14:	6a 34                	push   $0x34
  801a16:	68 4f 3c 80 00       	push   $0x803c4f
  801a1b:	e8 c3 01 00 00       	call   801be3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a20:	c1 e8 0c             	shr    $0xc,%eax
  801a23:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a2a:	a8 40                	test   $0x40,%al
  801a2c:	74 16                	je     801a44 <fs_test+0x298>
  801a2e:	68 71 3d 80 00       	push   $0x803d71
  801a33:	68 3d 39 80 00       	push   $0x80393d
  801a38:	6a 35                	push   $0x35
  801a3a:	68 4f 3c 80 00       	push   $0x803c4f
  801a3f:	e8 9f 01 00 00       	call   801be3 <_panic>
	cprintf("file_truncate is good\n");
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	68 8b 3d 80 00       	push   $0x803d8b
  801a4c:	e8 6b 02 00 00       	call   801cbc <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801a51:	c7 04 24 24 3e 80 00 	movl   $0x803e24,(%esp)
  801a58:	e8 98 07 00 00       	call   8021f5 <strlen>
  801a5d:	83 c4 08             	add    $0x8,%esp
  801a60:	50                   	push   %eax
  801a61:	ff 75 f4             	pushl  -0xc(%ebp)
  801a64:	e8 0a f6 ff ff       	call   801073 <file_set_size>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	79 12                	jns    801a82 <fs_test+0x2d6>
		panic("file_set_size 2: %e", r);
  801a70:	50                   	push   %eax
  801a71:	68 a2 3d 80 00       	push   $0x803da2
  801a76:	6a 39                	push   $0x39
  801a78:	68 4f 3c 80 00       	push   $0x803c4f
  801a7d:	e8 61 01 00 00       	call   801be3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a85:	89 c2                	mov    %eax,%edx
  801a87:	c1 ea 0c             	shr    $0xc,%edx
  801a8a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a91:	f6 c2 40             	test   $0x40,%dl
  801a94:	74 16                	je     801aac <fs_test+0x300>
  801a96:	68 71 3d 80 00       	push   $0x803d71
  801a9b:	68 3d 39 80 00       	push   $0x80393d
  801aa0:	6a 3a                	push   $0x3a
  801aa2:	68 4f 3c 80 00       	push   $0x803c4f
  801aa7:	e8 37 01 00 00       	call   801be3 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801ab2:	52                   	push   %edx
  801ab3:	6a 00                	push   $0x0
  801ab5:	50                   	push   %eax
  801ab6:	e8 88 f1 ff ff       	call   800c43 <file_get_block>
  801abb:	83 c4 10             	add    $0x10,%esp
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	79 12                	jns    801ad4 <fs_test+0x328>
		panic("file_get_block 2: %e", r);
  801ac2:	50                   	push   %eax
  801ac3:	68 b6 3d 80 00       	push   $0x803db6
  801ac8:	6a 3c                	push   $0x3c
  801aca:	68 4f 3c 80 00       	push   $0x803c4f
  801acf:	e8 0f 01 00 00       	call   801be3 <_panic>
	strcpy(blk, msg);
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	68 24 3e 80 00       	push   $0x803e24
  801adc:	ff 75 f0             	pushl  -0x10(%ebp)
  801adf:	e8 4a 07 00 00       	call   80222e <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae7:	c1 e8 0c             	shr    $0xc,%eax
  801aea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	a8 40                	test   $0x40,%al
  801af6:	75 16                	jne    801b0e <fs_test+0x362>
  801af8:	68 1c 3d 80 00       	push   $0x803d1c
  801afd:	68 3d 39 80 00       	push   $0x80393d
  801b02:	6a 3e                	push   $0x3e
  801b04:	68 4f 3c 80 00       	push   $0x803c4f
  801b09:	e8 d5 00 00 00       	call   801be3 <_panic>
	file_flush(f);
  801b0e:	83 ec 0c             	sub    $0xc,%esp
  801b11:	ff 75 f4             	pushl  -0xc(%ebp)
  801b14:	e8 37 f6 ff ff       	call   801150 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1c:	c1 e8 0c             	shr    $0xc,%eax
  801b1f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	a8 40                	test   $0x40,%al
  801b2b:	74 16                	je     801b43 <fs_test+0x397>
  801b2d:	68 1b 3d 80 00       	push   $0x803d1b
  801b32:	68 3d 39 80 00       	push   $0x80393d
  801b37:	6a 40                	push   $0x40
  801b39:	68 4f 3c 80 00       	push   $0x803c4f
  801b3e:	e8 a0 00 00 00       	call   801be3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	c1 e8 0c             	shr    $0xc,%eax
  801b49:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b50:	a8 40                	test   $0x40,%al
  801b52:	74 16                	je     801b6a <fs_test+0x3be>
  801b54:	68 71 3d 80 00       	push   $0x803d71
  801b59:	68 3d 39 80 00       	push   $0x80393d
  801b5e:	6a 41                	push   $0x41
  801b60:	68 4f 3c 80 00       	push   $0x803c4f
  801b65:	e8 79 00 00 00       	call   801be3 <_panic>
	cprintf("file rewrite is good\n");
  801b6a:	83 ec 0c             	sub    $0xc,%esp
  801b6d:	68 cb 3d 80 00       	push   $0x803dcb
  801b72:	e8 45 01 00 00       	call   801cbc <cprintf>
}
  801b77:	83 c4 10             	add    $0x10,%esp
  801b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	56                   	push   %esi
  801b83:	53                   	push   %ebx
  801b84:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b87:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  801b8a:	e8 9d 0a 00 00       	call   80262c <sys_getenvid>
	if (id >= 0)
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 12                	js     801ba5 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  801b93:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b98:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b9b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ba0:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801ba5:	85 db                	test   %ebx,%ebx
  801ba7:	7e 07                	jle    801bb0 <libmain+0x31>
		binaryname = argv[0];
  801ba9:	8b 06                	mov    (%esi),%eax
  801bab:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	e8 a9 fb ff ff       	call   801763 <umain>

	// exit gracefully
	exit();
  801bba:	e8 0a 00 00 00       	call   801bc9 <exit>
}
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc5:	5b                   	pop    %ebx
  801bc6:	5e                   	pop    %esi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    

00801bc9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801bcf:	e8 16 0f 00 00       	call   802aea <close_all>
	sys_env_destroy(0);
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	6a 00                	push   $0x0
  801bd9:	e8 2c 0a 00 00       	call   80260a <sys_env_destroy>
}
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801be8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801beb:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801bf1:	e8 36 0a 00 00       	call   80262c <sys_getenvid>
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	56                   	push   %esi
  801c00:	50                   	push   %eax
  801c01:	68 7c 3e 80 00       	push   $0x803e7c
  801c06:	e8 b1 00 00 00       	call   801cbc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c0b:	83 c4 18             	add    $0x18,%esp
  801c0e:	53                   	push   %ebx
  801c0f:	ff 75 10             	pushl  0x10(%ebp)
  801c12:	e8 54 00 00 00       	call   801c6b <vcprintf>
	cprintf("\n");
  801c17:	c7 04 24 82 3a 80 00 	movl   $0x803a82,(%esp)
  801c1e:	e8 99 00 00 00       	call   801cbc <cprintf>
  801c23:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c26:	cc                   	int3   
  801c27:	eb fd                	jmp    801c26 <_panic+0x43>

00801c29 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	53                   	push   %ebx
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c33:	8b 13                	mov    (%ebx),%edx
  801c35:	8d 42 01             	lea    0x1(%edx),%eax
  801c38:	89 03                	mov    %eax,(%ebx)
  801c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801c41:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c46:	75 1a                	jne    801c62 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	68 ff 00 00 00       	push   $0xff
  801c50:	8d 43 08             	lea    0x8(%ebx),%eax
  801c53:	50                   	push   %eax
  801c54:	e8 67 09 00 00       	call   8025c0 <sys_cputs>
		b->idx = 0;
  801c59:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c5f:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801c62:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801c66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c74:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c7b:	00 00 00 
	b.cnt = 0;
  801c7e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801c85:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c94:	50                   	push   %eax
  801c95:	68 29 1c 80 00       	push   $0x801c29
  801c9a:	e8 86 01 00 00       	call   801e25 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801c9f:	83 c4 08             	add    $0x8,%esp
  801ca2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801ca8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801cae:	50                   	push   %eax
  801caf:	e8 0c 09 00 00       	call   8025c0 <sys_cputs>

	return b.cnt;
}
  801cb4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cc2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801cc5:	50                   	push   %eax
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	e8 9d ff ff ff       	call   801c6b <vcprintf>
	va_end(ap);

	return cnt;
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	57                   	push   %edi
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 1c             	sub    $0x1c,%esp
  801cd9:	89 c7                	mov    %eax,%edi
  801cdb:	89 d6                	mov    %edx,%esi
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ce6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801ce9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cec:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cf1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801cf4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801cf7:	39 d3                	cmp    %edx,%ebx
  801cf9:	72 05                	jb     801d00 <printnum+0x30>
  801cfb:	39 45 10             	cmp    %eax,0x10(%ebp)
  801cfe:	77 45                	ja     801d45 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	ff 75 18             	pushl  0x18(%ebp)
  801d06:	8b 45 14             	mov    0x14(%ebp),%eax
  801d09:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801d0c:	53                   	push   %ebx
  801d0d:	ff 75 10             	pushl  0x10(%ebp)
  801d10:	83 ec 08             	sub    $0x8,%esp
  801d13:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d16:	ff 75 e0             	pushl  -0x20(%ebp)
  801d19:	ff 75 dc             	pushl  -0x24(%ebp)
  801d1c:	ff 75 d8             	pushl  -0x28(%ebp)
  801d1f:	e8 4c 19 00 00       	call   803670 <__udivdi3>
  801d24:	83 c4 18             	add    $0x18,%esp
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	89 f2                	mov    %esi,%edx
  801d2b:	89 f8                	mov    %edi,%eax
  801d2d:	e8 9e ff ff ff       	call   801cd0 <printnum>
  801d32:	83 c4 20             	add    $0x20,%esp
  801d35:	eb 18                	jmp    801d4f <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d37:	83 ec 08             	sub    $0x8,%esp
  801d3a:	56                   	push   %esi
  801d3b:	ff 75 18             	pushl  0x18(%ebp)
  801d3e:	ff d7                	call   *%edi
  801d40:	83 c4 10             	add    $0x10,%esp
  801d43:	eb 03                	jmp    801d48 <printnum+0x78>
  801d45:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801d48:	83 eb 01             	sub    $0x1,%ebx
  801d4b:	85 db                	test   %ebx,%ebx
  801d4d:	7f e8                	jg     801d37 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d4f:	83 ec 08             	sub    $0x8,%esp
  801d52:	56                   	push   %esi
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d59:	ff 75 e0             	pushl  -0x20(%ebp)
  801d5c:	ff 75 dc             	pushl  -0x24(%ebp)
  801d5f:	ff 75 d8             	pushl  -0x28(%ebp)
  801d62:	e8 39 1a 00 00       	call   8037a0 <__umoddi3>
  801d67:	83 c4 14             	add    $0x14,%esp
  801d6a:	0f be 80 9f 3e 80 00 	movsbl 0x803e9f(%eax),%eax
  801d71:	50                   	push   %eax
  801d72:	ff d7                	call   *%edi
}
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7a:	5b                   	pop    %ebx
  801d7b:	5e                   	pop    %esi
  801d7c:	5f                   	pop    %edi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    

00801d7f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d82:	83 fa 01             	cmp    $0x1,%edx
  801d85:	7e 0e                	jle    801d95 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801d87:	8b 10                	mov    (%eax),%edx
  801d89:	8d 4a 08             	lea    0x8(%edx),%ecx
  801d8c:	89 08                	mov    %ecx,(%eax)
  801d8e:	8b 02                	mov    (%edx),%eax
  801d90:	8b 52 04             	mov    0x4(%edx),%edx
  801d93:	eb 22                	jmp    801db7 <getuint+0x38>
	else if (lflag)
  801d95:	85 d2                	test   %edx,%edx
  801d97:	74 10                	je     801da9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801d99:	8b 10                	mov    (%eax),%edx
  801d9b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801d9e:	89 08                	mov    %ecx,(%eax)
  801da0:	8b 02                	mov    (%edx),%eax
  801da2:	ba 00 00 00 00       	mov    $0x0,%edx
  801da7:	eb 0e                	jmp    801db7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801da9:	8b 10                	mov    (%eax),%edx
  801dab:	8d 4a 04             	lea    0x4(%edx),%ecx
  801dae:	89 08                	mov    %ecx,(%eax)
  801db0:	8b 02                	mov    (%edx),%eax
  801db2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801dbc:	83 fa 01             	cmp    $0x1,%edx
  801dbf:	7e 0e                	jle    801dcf <getint+0x16>
		return va_arg(*ap, long long);
  801dc1:	8b 10                	mov    (%eax),%edx
  801dc3:	8d 4a 08             	lea    0x8(%edx),%ecx
  801dc6:	89 08                	mov    %ecx,(%eax)
  801dc8:	8b 02                	mov    (%edx),%eax
  801dca:	8b 52 04             	mov    0x4(%edx),%edx
  801dcd:	eb 1a                	jmp    801de9 <getint+0x30>
	else if (lflag)
  801dcf:	85 d2                	test   %edx,%edx
  801dd1:	74 0c                	je     801ddf <getint+0x26>
		return va_arg(*ap, long);
  801dd3:	8b 10                	mov    (%eax),%edx
  801dd5:	8d 4a 04             	lea    0x4(%edx),%ecx
  801dd8:	89 08                	mov    %ecx,(%eax)
  801dda:	8b 02                	mov    (%edx),%eax
  801ddc:	99                   	cltd   
  801ddd:	eb 0a                	jmp    801de9 <getint+0x30>
	else
		return va_arg(*ap, int);
  801ddf:	8b 10                	mov    (%eax),%edx
  801de1:	8d 4a 04             	lea    0x4(%edx),%ecx
  801de4:	89 08                	mov    %ecx,(%eax)
  801de6:	8b 02                	mov    (%edx),%eax
  801de8:	99                   	cltd   
}
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801df1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801df5:	8b 10                	mov    (%eax),%edx
  801df7:	3b 50 04             	cmp    0x4(%eax),%edx
  801dfa:	73 0a                	jae    801e06 <sprintputch+0x1b>
		*b->buf++ = ch;
  801dfc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dff:	89 08                	mov    %ecx,(%eax)
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	88 02                	mov    %al,(%edx)
}
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    

00801e08 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  801e0e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801e11:	50                   	push   %eax
  801e12:	ff 75 10             	pushl  0x10(%ebp)
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	e8 05 00 00 00       	call   801e25 <vprintfmt>
	va_end(ap);
}
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	57                   	push   %edi
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 2c             	sub    $0x2c,%esp
  801e2e:	8b 75 08             	mov    0x8(%ebp),%esi
  801e31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801e34:	8b 7d 10             	mov    0x10(%ebp),%edi
  801e37:	eb 12                	jmp    801e4b <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	0f 84 44 03 00 00    	je     802185 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	53                   	push   %ebx
  801e45:	50                   	push   %eax
  801e46:	ff d6                	call   *%esi
  801e48:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e4b:	83 c7 01             	add    $0x1,%edi
  801e4e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801e52:	83 f8 25             	cmp    $0x25,%eax
  801e55:	75 e2                	jne    801e39 <vprintfmt+0x14>
  801e57:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801e5b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e62:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801e69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801e70:	ba 00 00 00 00       	mov    $0x0,%edx
  801e75:	eb 07                	jmp    801e7e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e77:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801e7a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e7e:	8d 47 01             	lea    0x1(%edi),%eax
  801e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e84:	0f b6 07             	movzbl (%edi),%eax
  801e87:	0f b6 c8             	movzbl %al,%ecx
  801e8a:	83 e8 23             	sub    $0x23,%eax
  801e8d:	3c 55                	cmp    $0x55,%al
  801e8f:	0f 87 d5 02 00 00    	ja     80216a <vprintfmt+0x345>
  801e95:	0f b6 c0             	movzbl %al,%eax
  801e98:	ff 24 85 e0 3f 80 00 	jmp    *0x803fe0(,%eax,4)
  801e9f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ea2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801ea6:	eb d6                	jmp    801e7e <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ea8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801eb3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801eb6:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  801eba:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  801ebd:	8d 51 d0             	lea    -0x30(%ecx),%edx
  801ec0:	83 fa 09             	cmp    $0x9,%edx
  801ec3:	77 39                	ja     801efe <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ec5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ec8:	eb e9                	jmp    801eb3 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801eca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecd:	8d 48 04             	lea    0x4(%eax),%ecx
  801ed0:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801ed3:	8b 00                	mov    (%eax),%eax
  801ed5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ed8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801edb:	eb 27                	jmp    801f04 <vprintfmt+0xdf>
  801edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ee7:	0f 49 c8             	cmovns %eax,%ecx
  801eea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801eed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801ef0:	eb 8c                	jmp    801e7e <vprintfmt+0x59>
  801ef2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801ef5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801efc:	eb 80                	jmp    801e7e <vprintfmt+0x59>
  801efe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f01:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  801f04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f08:	0f 89 70 ff ff ff    	jns    801e7e <vprintfmt+0x59>
				width = precision, precision = -1;
  801f0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f14:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801f1b:	e9 5e ff ff ff       	jmp    801e7e <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801f20:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f23:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801f26:	e9 53 ff ff ff       	jmp    801e7e <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801f2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2e:	8d 50 04             	lea    0x4(%eax),%edx
  801f31:	89 55 14             	mov    %edx,0x14(%ebp)
  801f34:	83 ec 08             	sub    $0x8,%esp
  801f37:	53                   	push   %ebx
  801f38:	ff 30                	pushl  (%eax)
  801f3a:	ff d6                	call   *%esi
			break;
  801f3c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  801f42:	e9 04 ff ff ff       	jmp    801e4b <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801f47:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4a:	8d 50 04             	lea    0x4(%eax),%edx
  801f4d:	89 55 14             	mov    %edx,0x14(%ebp)
  801f50:	8b 00                	mov    (%eax),%eax
  801f52:	99                   	cltd   
  801f53:	31 d0                	xor    %edx,%eax
  801f55:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801f57:	83 f8 0f             	cmp    $0xf,%eax
  801f5a:	7f 0b                	jg     801f67 <vprintfmt+0x142>
  801f5c:	8b 14 85 40 41 80 00 	mov    0x804140(,%eax,4),%edx
  801f63:	85 d2                	test   %edx,%edx
  801f65:	75 18                	jne    801f7f <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  801f67:	50                   	push   %eax
  801f68:	68 b7 3e 80 00       	push   $0x803eb7
  801f6d:	53                   	push   %ebx
  801f6e:	56                   	push   %esi
  801f6f:	e8 94 fe ff ff       	call   801e08 <printfmt>
  801f74:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801f7a:	e9 cc fe ff ff       	jmp    801e4b <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  801f7f:	52                   	push   %edx
  801f80:	68 4f 39 80 00       	push   $0x80394f
  801f85:	53                   	push   %ebx
  801f86:	56                   	push   %esi
  801f87:	e8 7c fe ff ff       	call   801e08 <printfmt>
  801f8c:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801f92:	e9 b4 fe ff ff       	jmp    801e4b <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f97:	8b 45 14             	mov    0x14(%ebp),%eax
  801f9a:	8d 50 04             	lea    0x4(%eax),%edx
  801f9d:	89 55 14             	mov    %edx,0x14(%ebp)
  801fa0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801fa2:	85 ff                	test   %edi,%edi
  801fa4:	b8 b0 3e 80 00       	mov    $0x803eb0,%eax
  801fa9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801fac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fb0:	0f 8e 94 00 00 00    	jle    80204a <vprintfmt+0x225>
  801fb6:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801fba:	0f 84 98 00 00 00    	je     802058 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  801fc0:	83 ec 08             	sub    $0x8,%esp
  801fc3:	ff 75 d0             	pushl  -0x30(%ebp)
  801fc6:	57                   	push   %edi
  801fc7:	e8 41 02 00 00       	call   80220d <strnlen>
  801fcc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801fcf:	29 c1                	sub    %eax,%ecx
  801fd1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  801fd4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801fd7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801fdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fde:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801fe1:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801fe3:	eb 0f                	jmp    801ff4 <vprintfmt+0x1cf>
					putch(padc, putdat);
  801fe5:	83 ec 08             	sub    $0x8,%esp
  801fe8:	53                   	push   %ebx
  801fe9:	ff 75 e0             	pushl  -0x20(%ebp)
  801fec:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801fee:	83 ef 01             	sub    $0x1,%edi
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	85 ff                	test   %edi,%edi
  801ff6:	7f ed                	jg     801fe5 <vprintfmt+0x1c0>
  801ff8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801ffb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801ffe:	85 c9                	test   %ecx,%ecx
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	0f 49 c1             	cmovns %ecx,%eax
  802008:	29 c1                	sub    %eax,%ecx
  80200a:	89 75 08             	mov    %esi,0x8(%ebp)
  80200d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  802010:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  802013:	89 cb                	mov    %ecx,%ebx
  802015:	eb 4d                	jmp    802064 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802017:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80201b:	74 1b                	je     802038 <vprintfmt+0x213>
  80201d:	0f be c0             	movsbl %al,%eax
  802020:	83 e8 20             	sub    $0x20,%eax
  802023:	83 f8 5e             	cmp    $0x5e,%eax
  802026:	76 10                	jbe    802038 <vprintfmt+0x213>
					putch('?', putdat);
  802028:	83 ec 08             	sub    $0x8,%esp
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	6a 3f                	push   $0x3f
  802030:	ff 55 08             	call   *0x8(%ebp)
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	eb 0d                	jmp    802045 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  802038:	83 ec 08             	sub    $0x8,%esp
  80203b:	ff 75 0c             	pushl  0xc(%ebp)
  80203e:	52                   	push   %edx
  80203f:	ff 55 08             	call   *0x8(%ebp)
  802042:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802045:	83 eb 01             	sub    $0x1,%ebx
  802048:	eb 1a                	jmp    802064 <vprintfmt+0x23f>
  80204a:	89 75 08             	mov    %esi,0x8(%ebp)
  80204d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  802050:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  802053:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  802056:	eb 0c                	jmp    802064 <vprintfmt+0x23f>
  802058:	89 75 08             	mov    %esi,0x8(%ebp)
  80205b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80205e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  802061:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  802064:	83 c7 01             	add    $0x1,%edi
  802067:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80206b:	0f be d0             	movsbl %al,%edx
  80206e:	85 d2                	test   %edx,%edx
  802070:	74 23                	je     802095 <vprintfmt+0x270>
  802072:	85 f6                	test   %esi,%esi
  802074:	78 a1                	js     802017 <vprintfmt+0x1f2>
  802076:	83 ee 01             	sub    $0x1,%esi
  802079:	79 9c                	jns    802017 <vprintfmt+0x1f2>
  80207b:	89 df                	mov    %ebx,%edi
  80207d:	8b 75 08             	mov    0x8(%ebp),%esi
  802080:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802083:	eb 18                	jmp    80209d <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802085:	83 ec 08             	sub    $0x8,%esp
  802088:	53                   	push   %ebx
  802089:	6a 20                	push   $0x20
  80208b:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80208d:	83 ef 01             	sub    $0x1,%edi
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	eb 08                	jmp    80209d <vprintfmt+0x278>
  802095:	89 df                	mov    %ebx,%edi
  802097:	8b 75 08             	mov    0x8(%ebp),%esi
  80209a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80209d:	85 ff                	test   %edi,%edi
  80209f:	7f e4                	jg     802085 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8020a4:	e9 a2 fd ff ff       	jmp    801e4b <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8020a9:	8d 45 14             	lea    0x14(%ebp),%eax
  8020ac:	e8 08 fd ff ff       	call   801db9 <getint>
  8020b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8020b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8020b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8020bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8020c0:	79 74                	jns    802136 <vprintfmt+0x311>
				putch('-', putdat);
  8020c2:	83 ec 08             	sub    $0x8,%esp
  8020c5:	53                   	push   %ebx
  8020c6:	6a 2d                	push   $0x2d
  8020c8:	ff d6                	call   *%esi
				num = -(long long) num;
  8020ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8020d0:	f7 d8                	neg    %eax
  8020d2:	83 d2 00             	adc    $0x0,%edx
  8020d5:	f7 da                	neg    %edx
  8020d7:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8020da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020df:	eb 55                	jmp    802136 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8020e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8020e4:	e8 96 fc ff ff       	call   801d7f <getuint>
			base = 10;
  8020e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8020ee:	eb 46                	jmp    802136 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8020f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8020f3:	e8 87 fc ff ff       	call   801d7f <getuint>
			base = 8;
  8020f8:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8020fd:	eb 37                	jmp    802136 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  8020ff:	83 ec 08             	sub    $0x8,%esp
  802102:	53                   	push   %ebx
  802103:	6a 30                	push   $0x30
  802105:	ff d6                	call   *%esi
			putch('x', putdat);
  802107:	83 c4 08             	add    $0x8,%esp
  80210a:	53                   	push   %ebx
  80210b:	6a 78                	push   $0x78
  80210d:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80210f:	8b 45 14             	mov    0x14(%ebp),%eax
  802112:	8d 50 04             	lea    0x4(%eax),%edx
  802115:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802118:	8b 00                	mov    (%eax),%eax
  80211a:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80211f:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  802122:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  802127:	eb 0d                	jmp    802136 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802129:	8d 45 14             	lea    0x14(%ebp),%eax
  80212c:	e8 4e fc ff ff       	call   801d7f <getuint>
			base = 16;
  802131:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  802136:	83 ec 0c             	sub    $0xc,%esp
  802139:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80213d:	57                   	push   %edi
  80213e:	ff 75 e0             	pushl  -0x20(%ebp)
  802141:	51                   	push   %ecx
  802142:	52                   	push   %edx
  802143:	50                   	push   %eax
  802144:	89 da                	mov    %ebx,%edx
  802146:	89 f0                	mov    %esi,%eax
  802148:	e8 83 fb ff ff       	call   801cd0 <printnum>
			break;
  80214d:	83 c4 20             	add    $0x20,%esp
  802150:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  802153:	e9 f3 fc ff ff       	jmp    801e4b <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802158:	83 ec 08             	sub    $0x8,%esp
  80215b:	53                   	push   %ebx
  80215c:	51                   	push   %ecx
  80215d:	ff d6                	call   *%esi
			break;
  80215f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802162:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  802165:	e9 e1 fc ff ff       	jmp    801e4b <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80216a:	83 ec 08             	sub    $0x8,%esp
  80216d:	53                   	push   %ebx
  80216e:	6a 25                	push   $0x25
  802170:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	eb 03                	jmp    80217a <vprintfmt+0x355>
  802177:	83 ef 01             	sub    $0x1,%edi
  80217a:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  80217e:	75 f7                	jne    802177 <vprintfmt+0x352>
  802180:	e9 c6 fc ff ff       	jmp    801e4b <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  802185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802188:	5b                   	pop    %ebx
  802189:	5e                   	pop    %esi
  80218a:	5f                   	pop    %edi
  80218b:	5d                   	pop    %ebp
  80218c:	c3                   	ret    

0080218d <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 18             	sub    $0x18,%esp
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802199:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80219c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8021a0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8021a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	74 26                	je     8021d4 <vsnprintf+0x47>
  8021ae:	85 d2                	test   %edx,%edx
  8021b0:	7e 22                	jle    8021d4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8021b2:	ff 75 14             	pushl  0x14(%ebp)
  8021b5:	ff 75 10             	pushl  0x10(%ebp)
  8021b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021bb:	50                   	push   %eax
  8021bc:	68 eb 1d 80 00       	push   $0x801deb
  8021c1:	e8 5f fc ff ff       	call   801e25 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8021c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	83 c4 10             	add    $0x10,%esp
  8021d2:	eb 05                	jmp    8021d9 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8021d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8021e1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8021e4:	50                   	push   %eax
  8021e5:	ff 75 10             	pushl  0x10(%ebp)
  8021e8:	ff 75 0c             	pushl  0xc(%ebp)
  8021eb:	ff 75 08             	pushl  0x8(%ebp)
  8021ee:	e8 9a ff ff ff       	call   80218d <vsnprintf>
	va_end(ap);

	return rc;
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	eb 03                	jmp    802205 <strlen+0x10>
		n++;
  802202:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802205:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802209:	75 f7                	jne    802202 <strlen+0xd>
		n++;
	return n;
}
  80220b:	5d                   	pop    %ebp
  80220c:	c3                   	ret    

0080220d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802213:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802216:	ba 00 00 00 00       	mov    $0x0,%edx
  80221b:	eb 03                	jmp    802220 <strnlen+0x13>
		n++;
  80221d:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802220:	39 c2                	cmp    %eax,%edx
  802222:	74 08                	je     80222c <strnlen+0x1f>
  802224:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  802228:	75 f3                	jne    80221d <strnlen+0x10>
  80222a:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	53                   	push   %ebx
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802238:	89 c2                	mov    %eax,%edx
  80223a:	83 c2 01             	add    $0x1,%edx
  80223d:	83 c1 01             	add    $0x1,%ecx
  802240:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  802244:	88 5a ff             	mov    %bl,-0x1(%edx)
  802247:	84 db                	test   %bl,%bl
  802249:	75 ef                	jne    80223a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80224b:	5b                   	pop    %ebx
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    

0080224e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	53                   	push   %ebx
  802252:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802255:	53                   	push   %ebx
  802256:	e8 9a ff ff ff       	call   8021f5 <strlen>
  80225b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80225e:	ff 75 0c             	pushl  0xc(%ebp)
  802261:	01 d8                	add    %ebx,%eax
  802263:	50                   	push   %eax
  802264:	e8 c5 ff ff ff       	call   80222e <strcpy>
	return dst;
}
  802269:	89 d8                	mov    %ebx,%eax
  80226b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
  802275:	8b 75 08             	mov    0x8(%ebp),%esi
  802278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80227b:	89 f3                	mov    %esi,%ebx
  80227d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802280:	89 f2                	mov    %esi,%edx
  802282:	eb 0f                	jmp    802293 <strncpy+0x23>
		*dst++ = *src;
  802284:	83 c2 01             	add    $0x1,%edx
  802287:	0f b6 01             	movzbl (%ecx),%eax
  80228a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80228d:	80 39 01             	cmpb   $0x1,(%ecx)
  802290:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802293:	39 da                	cmp    %ebx,%edx
  802295:	75 ed                	jne    802284 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802297:	89 f0                	mov    %esi,%eax
  802299:	5b                   	pop    %ebx
  80229a:	5e                   	pop    %esi
  80229b:	5d                   	pop    %ebp
  80229c:	c3                   	ret    

0080229d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	56                   	push   %esi
  8022a1:	53                   	push   %ebx
  8022a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8022a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022a8:	8b 55 10             	mov    0x10(%ebp),%edx
  8022ab:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8022ad:	85 d2                	test   %edx,%edx
  8022af:	74 21                	je     8022d2 <strlcpy+0x35>
  8022b1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8022b5:	89 f2                	mov    %esi,%edx
  8022b7:	eb 09                	jmp    8022c2 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8022b9:	83 c2 01             	add    $0x1,%edx
  8022bc:	83 c1 01             	add    $0x1,%ecx
  8022bf:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022c2:	39 c2                	cmp    %eax,%edx
  8022c4:	74 09                	je     8022cf <strlcpy+0x32>
  8022c6:	0f b6 19             	movzbl (%ecx),%ebx
  8022c9:	84 db                	test   %bl,%bl
  8022cb:	75 ec                	jne    8022b9 <strlcpy+0x1c>
  8022cd:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  8022cf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8022d2:	29 f0                	sub    %esi,%eax
}
  8022d4:	5b                   	pop    %ebx
  8022d5:	5e                   	pop    %esi
  8022d6:	5d                   	pop    %ebp
  8022d7:	c3                   	ret    

008022d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022de:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8022e1:	eb 06                	jmp    8022e9 <strcmp+0x11>
		p++, q++;
  8022e3:	83 c1 01             	add    $0x1,%ecx
  8022e6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8022e9:	0f b6 01             	movzbl (%ecx),%eax
  8022ec:	84 c0                	test   %al,%al
  8022ee:	74 04                	je     8022f4 <strcmp+0x1c>
  8022f0:	3a 02                	cmp    (%edx),%al
  8022f2:	74 ef                	je     8022e3 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8022f4:	0f b6 c0             	movzbl %al,%eax
  8022f7:	0f b6 12             	movzbl (%edx),%edx
  8022fa:	29 d0                	sub    %edx,%eax
}
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	53                   	push   %ebx
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	8b 55 0c             	mov    0xc(%ebp),%edx
  802308:	89 c3                	mov    %eax,%ebx
  80230a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80230d:	eb 06                	jmp    802315 <strncmp+0x17>
		n--, p++, q++;
  80230f:	83 c0 01             	add    $0x1,%eax
  802312:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802315:	39 d8                	cmp    %ebx,%eax
  802317:	74 15                	je     80232e <strncmp+0x30>
  802319:	0f b6 08             	movzbl (%eax),%ecx
  80231c:	84 c9                	test   %cl,%cl
  80231e:	74 04                	je     802324 <strncmp+0x26>
  802320:	3a 0a                	cmp    (%edx),%cl
  802322:	74 eb                	je     80230f <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802324:	0f b6 00             	movzbl (%eax),%eax
  802327:	0f b6 12             	movzbl (%edx),%edx
  80232a:	29 d0                	sub    %edx,%eax
  80232c:	eb 05                	jmp    802333 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80232e:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802333:	5b                   	pop    %ebx
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802340:	eb 07                	jmp    802349 <strchr+0x13>
		if (*s == c)
  802342:	38 ca                	cmp    %cl,%dl
  802344:	74 0f                	je     802355 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802346:	83 c0 01             	add    $0x1,%eax
  802349:	0f b6 10             	movzbl (%eax),%edx
  80234c:	84 d2                	test   %dl,%dl
  80234e:	75 f2                	jne    802342 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802350:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802355:	5d                   	pop    %ebp
  802356:	c3                   	ret    

00802357 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802361:	eb 03                	jmp    802366 <strfind+0xf>
  802363:	83 c0 01             	add    $0x1,%eax
  802366:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  802369:	38 ca                	cmp    %cl,%dl
  80236b:	74 04                	je     802371 <strfind+0x1a>
  80236d:	84 d2                	test   %dl,%dl
  80236f:	75 f2                	jne    802363 <strfind+0xc>
			break;
	return (char *) s;
}
  802371:	5d                   	pop    %ebp
  802372:	c3                   	ret    

00802373 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	57                   	push   %edi
  802377:	56                   	push   %esi
  802378:	53                   	push   %ebx
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  80237f:	85 c9                	test   %ecx,%ecx
  802381:	74 37                	je     8023ba <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802383:	f6 c2 03             	test   $0x3,%dl
  802386:	75 2a                	jne    8023b2 <memset+0x3f>
  802388:	f6 c1 03             	test   $0x3,%cl
  80238b:	75 25                	jne    8023b2 <memset+0x3f>
		c &= 0xFF;
  80238d:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802391:	89 df                	mov    %ebx,%edi
  802393:	c1 e7 08             	shl    $0x8,%edi
  802396:	89 de                	mov    %ebx,%esi
  802398:	c1 e6 18             	shl    $0x18,%esi
  80239b:	89 d8                	mov    %ebx,%eax
  80239d:	c1 e0 10             	shl    $0x10,%eax
  8023a0:	09 f0                	or     %esi,%eax
  8023a2:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8023a4:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8023a7:	89 f8                	mov    %edi,%eax
  8023a9:	09 d8                	or     %ebx,%eax
  8023ab:	89 d7                	mov    %edx,%edi
  8023ad:	fc                   	cld    
  8023ae:	f3 ab                	rep stos %eax,%es:(%edi)
  8023b0:	eb 08                	jmp    8023ba <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8023b2:	89 d7                	mov    %edx,%edi
  8023b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b7:	fc                   	cld    
  8023b8:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  8023ba:	89 d0                	mov    %edx,%eax
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    

008023c1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	57                   	push   %edi
  8023c5:	56                   	push   %esi
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8023cf:	39 c6                	cmp    %eax,%esi
  8023d1:	73 35                	jae    802408 <memmove+0x47>
  8023d3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8023d6:	39 d0                	cmp    %edx,%eax
  8023d8:	73 2e                	jae    802408 <memmove+0x47>
		s += n;
		d += n;
  8023da:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8023dd:	89 d6                	mov    %edx,%esi
  8023df:	09 fe                	or     %edi,%esi
  8023e1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8023e7:	75 13                	jne    8023fc <memmove+0x3b>
  8023e9:	f6 c1 03             	test   $0x3,%cl
  8023ec:	75 0e                	jne    8023fc <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  8023ee:	83 ef 04             	sub    $0x4,%edi
  8023f1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8023f4:	c1 e9 02             	shr    $0x2,%ecx
  8023f7:	fd                   	std    
  8023f8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8023fa:	eb 09                	jmp    802405 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8023fc:	83 ef 01             	sub    $0x1,%edi
  8023ff:	8d 72 ff             	lea    -0x1(%edx),%esi
  802402:	fd                   	std    
  802403:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802405:	fc                   	cld    
  802406:	eb 1d                	jmp    802425 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802408:	89 f2                	mov    %esi,%edx
  80240a:	09 c2                	or     %eax,%edx
  80240c:	f6 c2 03             	test   $0x3,%dl
  80240f:	75 0f                	jne    802420 <memmove+0x5f>
  802411:	f6 c1 03             	test   $0x3,%cl
  802414:	75 0a                	jne    802420 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  802416:	c1 e9 02             	shr    $0x2,%ecx
  802419:	89 c7                	mov    %eax,%edi
  80241b:	fc                   	cld    
  80241c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80241e:	eb 05                	jmp    802425 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802420:	89 c7                	mov    %eax,%edi
  802422:	fc                   	cld    
  802423:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802425:	5e                   	pop    %esi
  802426:	5f                   	pop    %edi
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    

00802429 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80242c:	ff 75 10             	pushl  0x10(%ebp)
  80242f:	ff 75 0c             	pushl  0xc(%ebp)
  802432:	ff 75 08             	pushl  0x8(%ebp)
  802435:	e8 87 ff ff ff       	call   8023c1 <memmove>
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	56                   	push   %esi
  802440:	53                   	push   %ebx
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	8b 55 0c             	mov    0xc(%ebp),%edx
  802447:	89 c6                	mov    %eax,%esi
  802449:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80244c:	eb 1a                	jmp    802468 <memcmp+0x2c>
		if (*s1 != *s2)
  80244e:	0f b6 08             	movzbl (%eax),%ecx
  802451:	0f b6 1a             	movzbl (%edx),%ebx
  802454:	38 d9                	cmp    %bl,%cl
  802456:	74 0a                	je     802462 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802458:	0f b6 c1             	movzbl %cl,%eax
  80245b:	0f b6 db             	movzbl %bl,%ebx
  80245e:	29 d8                	sub    %ebx,%eax
  802460:	eb 0f                	jmp    802471 <memcmp+0x35>
		s1++, s2++;
  802462:	83 c0 01             	add    $0x1,%eax
  802465:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802468:	39 f0                	cmp    %esi,%eax
  80246a:	75 e2                	jne    80244e <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5d                   	pop    %ebp
  802474:	c3                   	ret    

00802475 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	53                   	push   %ebx
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80247c:	89 c1                	mov    %eax,%ecx
  80247e:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  802481:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802485:	eb 0a                	jmp    802491 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  802487:	0f b6 10             	movzbl (%eax),%edx
  80248a:	39 da                	cmp    %ebx,%edx
  80248c:	74 07                	je     802495 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80248e:	83 c0 01             	add    $0x1,%eax
  802491:	39 c8                	cmp    %ecx,%eax
  802493:	72 f2                	jb     802487 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802495:	5b                   	pop    %ebx
  802496:	5d                   	pop    %ebp
  802497:	c3                   	ret    

00802498 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	57                   	push   %edi
  80249c:	56                   	push   %esi
  80249d:	53                   	push   %ebx
  80249e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024a4:	eb 03                	jmp    8024a9 <strtol+0x11>
		s++;
  8024a6:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024a9:	0f b6 01             	movzbl (%ecx),%eax
  8024ac:	3c 20                	cmp    $0x20,%al
  8024ae:	74 f6                	je     8024a6 <strtol+0xe>
  8024b0:	3c 09                	cmp    $0x9,%al
  8024b2:	74 f2                	je     8024a6 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8024b4:	3c 2b                	cmp    $0x2b,%al
  8024b6:	75 0a                	jne    8024c2 <strtol+0x2a>
		s++;
  8024b8:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8024bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c0:	eb 11                	jmp    8024d3 <strtol+0x3b>
  8024c2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8024c7:	3c 2d                	cmp    $0x2d,%al
  8024c9:	75 08                	jne    8024d3 <strtol+0x3b>
		s++, neg = 1;
  8024cb:	83 c1 01             	add    $0x1,%ecx
  8024ce:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024d3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8024d9:	75 15                	jne    8024f0 <strtol+0x58>
  8024db:	80 39 30             	cmpb   $0x30,(%ecx)
  8024de:	75 10                	jne    8024f0 <strtol+0x58>
  8024e0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8024e4:	75 7c                	jne    802562 <strtol+0xca>
		s += 2, base = 16;
  8024e6:	83 c1 02             	add    $0x2,%ecx
  8024e9:	bb 10 00 00 00       	mov    $0x10,%ebx
  8024ee:	eb 16                	jmp    802506 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  8024f0:	85 db                	test   %ebx,%ebx
  8024f2:	75 12                	jne    802506 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8024f4:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8024f9:	80 39 30             	cmpb   $0x30,(%ecx)
  8024fc:	75 08                	jne    802506 <strtol+0x6e>
		s++, base = 8;
  8024fe:	83 c1 01             	add    $0x1,%ecx
  802501:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  802506:	b8 00 00 00 00       	mov    $0x0,%eax
  80250b:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80250e:	0f b6 11             	movzbl (%ecx),%edx
  802511:	8d 72 d0             	lea    -0x30(%edx),%esi
  802514:	89 f3                	mov    %esi,%ebx
  802516:	80 fb 09             	cmp    $0x9,%bl
  802519:	77 08                	ja     802523 <strtol+0x8b>
			dig = *s - '0';
  80251b:	0f be d2             	movsbl %dl,%edx
  80251e:	83 ea 30             	sub    $0x30,%edx
  802521:	eb 22                	jmp    802545 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  802523:	8d 72 9f             	lea    -0x61(%edx),%esi
  802526:	89 f3                	mov    %esi,%ebx
  802528:	80 fb 19             	cmp    $0x19,%bl
  80252b:	77 08                	ja     802535 <strtol+0x9d>
			dig = *s - 'a' + 10;
  80252d:	0f be d2             	movsbl %dl,%edx
  802530:	83 ea 57             	sub    $0x57,%edx
  802533:	eb 10                	jmp    802545 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  802535:	8d 72 bf             	lea    -0x41(%edx),%esi
  802538:	89 f3                	mov    %esi,%ebx
  80253a:	80 fb 19             	cmp    $0x19,%bl
  80253d:	77 16                	ja     802555 <strtol+0xbd>
			dig = *s - 'A' + 10;
  80253f:	0f be d2             	movsbl %dl,%edx
  802542:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  802545:	3b 55 10             	cmp    0x10(%ebp),%edx
  802548:	7d 0b                	jge    802555 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  80254a:	83 c1 01             	add    $0x1,%ecx
  80254d:	0f af 45 10          	imul   0x10(%ebp),%eax
  802551:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  802553:	eb b9                	jmp    80250e <strtol+0x76>

	if (endptr)
  802555:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802559:	74 0d                	je     802568 <strtol+0xd0>
		*endptr = (char *) s;
  80255b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80255e:	89 0e                	mov    %ecx,(%esi)
  802560:	eb 06                	jmp    802568 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802562:	85 db                	test   %ebx,%ebx
  802564:	74 98                	je     8024fe <strtol+0x66>
  802566:	eb 9e                	jmp    802506 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  802568:	89 c2                	mov    %eax,%edx
  80256a:	f7 da                	neg    %edx
  80256c:	85 ff                	test   %edi,%edi
  80256e:	0f 45 c2             	cmovne %edx,%eax
}
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    

00802576 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	57                   	push   %edi
  80257a:	56                   	push   %esi
  80257b:	53                   	push   %ebx
  80257c:	83 ec 1c             	sub    $0x1c,%esp
  80257f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802582:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802585:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802587:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80258a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80258d:	8b 7d 10             	mov    0x10(%ebp),%edi
  802590:	8b 75 14             	mov    0x14(%ebp),%esi
  802593:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802595:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802599:	74 1d                	je     8025b8 <syscall+0x42>
  80259b:	85 c0                	test   %eax,%eax
  80259d:	7e 19                	jle    8025b8 <syscall+0x42>
  80259f:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8025a2:	83 ec 0c             	sub    $0xc,%esp
  8025a5:	50                   	push   %eax
  8025a6:	52                   	push   %edx
  8025a7:	68 9f 41 80 00       	push   $0x80419f
  8025ac:	6a 23                	push   $0x23
  8025ae:	68 bc 41 80 00       	push   $0x8041bc
  8025b3:	e8 2b f6 ff ff       	call   801be3 <_panic>

	return ret;
}
  8025b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025bb:	5b                   	pop    %ebx
  8025bc:	5e                   	pop    %esi
  8025bd:	5f                   	pop    %edi
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    

008025c0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	ff 75 0c             	pushl  0xc(%ebp)
  8025cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dc:	e8 95 ff ff ff       	call   802576 <syscall>
}
  8025e1:	83 c4 10             	add    $0x10,%esp
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	e8 6e ff ff ff       	call   802576 <syscall>
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261b:	ba 01 00 00 00       	mov    $0x1,%edx
  802620:	b8 03 00 00 00       	mov    $0x3,%eax
  802625:	e8 4c ff ff ff       	call   802576 <syscall>
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80263f:	ba 00 00 00 00       	mov    $0x0,%edx
  802644:	b8 02 00 00 00       	mov    $0x2,%eax
  802649:	e8 28 ff ff ff       	call   802576 <syscall>
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <sys_yield>:

void
sys_yield(void)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802663:	ba 00 00 00 00       	mov    $0x0,%edx
  802668:	b8 0b 00 00 00       	mov    $0xb,%eax
  80266d:	e8 04 ff ff ff       	call   802576 <syscall>
}
  802672:	83 c4 10             	add    $0x10,%esp
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	ff 75 10             	pushl  0x10(%ebp)
  802684:	ff 75 0c             	pushl  0xc(%ebp)
  802687:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268a:	ba 01 00 00 00       	mov    $0x1,%edx
  80268f:	b8 04 00 00 00       	mov    $0x4,%eax
  802694:	e8 dd fe ff ff       	call   802576 <syscall>
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8026a1:	ff 75 18             	pushl  0x18(%ebp)
  8026a4:	ff 75 14             	pushl  0x14(%ebp)
  8026a7:	ff 75 10             	pushl  0x10(%ebp)
  8026aa:	ff 75 0c             	pushl  0xc(%ebp)
  8026ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026b0:	ba 01 00 00 00       	mov    $0x1,%edx
  8026b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8026ba:	e8 b7 fe ff ff       	call   802576 <syscall>
}
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
  8026c4:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	ff 75 0c             	pushl  0xc(%ebp)
  8026d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d3:	ba 01 00 00 00       	mov    $0x1,%edx
  8026d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8026dd:	e8 94 fe ff ff       	call   802576 <syscall>
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	ff 75 0c             	pushl  0xc(%ebp)
  8026f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026f6:	ba 01 00 00 00       	mov    $0x1,%edx
  8026fb:	b8 08 00 00 00       	mov    $0x8,%eax
  802700:	e8 71 fe ff ff       	call   802576 <syscall>
}
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
  80270a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	ff 75 0c             	pushl  0xc(%ebp)
  802716:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802719:	ba 01 00 00 00       	mov    $0x1,%edx
  80271e:	b8 09 00 00 00       	mov    $0x9,%eax
  802723:	e8 4e fe ff ff       	call   802576 <syscall>
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	ff 75 0c             	pushl  0xc(%ebp)
  802739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80273c:	ba 01 00 00 00       	mov    $0x1,%edx
  802741:	b8 0a 00 00 00       	mov    $0xa,%eax
  802746:	e8 2b fe ff ff       	call   802576 <syscall>
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  802753:	6a 00                	push   $0x0
  802755:	ff 75 14             	pushl  0x14(%ebp)
  802758:	ff 75 10             	pushl  0x10(%ebp)
  80275b:	ff 75 0c             	pushl  0xc(%ebp)
  80275e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802761:	ba 00 00 00 00       	mov    $0x0,%edx
  802766:	b8 0c 00 00 00       	mov    $0xc,%eax
  80276b:	e8 06 fe ff ff       	call   802576 <syscall>
}
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
  802775:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  802778:	6a 00                	push   $0x0
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802783:	ba 01 00 00 00       	mov    $0x1,%edx
  802788:	b8 0d 00 00 00       	mov    $0xd,%eax
  80278d:	e8 e4 fd ff ff       	call   802576 <syscall>
}
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80279a:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  8027a1:	75 2c                	jne    8027cf <set_pgfault_handler+0x3b>
		// First time through!
		// LAB 4: Your code here.
		r = sys_page_alloc(0,(void *)(UXSTACKTOP - PGSIZE),PTE_P | PTE_U | PTE_W);
  8027a3:	83 ec 04             	sub    $0x4,%esp
  8027a6:	6a 07                	push   $0x7
  8027a8:	68 00 f0 bf ee       	push   $0xeebff000
  8027ad:	6a 00                	push   $0x0
  8027af:	e8 c3 fe ff ff       	call   802677 <sys_page_alloc>
		if(r < 0)
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	79 14                	jns    8027cf <set_pgfault_handler+0x3b>
			panic("set_pgfault_handler: error in sys_page_alloc\n");	
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 cc 41 80 00       	push   $0x8041cc
  8027c3:	6a 22                	push   $0x22
  8027c5:	68 35 42 80 00       	push   $0x804235
  8027ca:	e8 14 f4 ff ff       	call   801be3 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	a3 10 a0 80 00       	mov    %eax,0x80a010
	r = sys_env_set_pgfault_upcall(0, _pgfault_upcall); 
  8027d7:	83 ec 08             	sub    $0x8,%esp
  8027da:	68 03 28 80 00       	push   $0x802803
  8027df:	6a 00                	push   $0x0
  8027e1:	e8 44 ff ff ff       	call   80272a <sys_env_set_pgfault_upcall>
	if (r < 0)
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	79 14                	jns    802801 <set_pgfault_handler+0x6d>
		panic("set_pgfault_handler: error in sys_env_set_pgfault_upcall");
  8027ed:	83 ec 04             	sub    $0x4,%esp
  8027f0:	68 fc 41 80 00       	push   $0x8041fc
  8027f5:	6a 29                	push   $0x29
  8027f7:	68 35 42 80 00       	push   $0x804235
  8027fc:	e8 e2 f3 ff ff       	call   801be3 <_panic>
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802803:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802804:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax
  802809:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80280b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	subl $0x4, 0x30(%esp)
  80280e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
	movl 0x30(%esp), %eax 
  802813:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 0x28(%esp), %ebx 	
  802817:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx, (%eax)
  80281b:	89 18                	mov    %ebx,(%eax)
	addl $0x8, %esp
  80281d:	83 c4 08             	add    $0x8,%esp


	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802820:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp 
  802821:	83 c4 04             	add    $0x4,%esp
	popfl
  802824:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802825:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802826:	c3                   	ret    

00802827 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
  80282a:	56                   	push   %esi
  80282b:	53                   	push   %ebx
  80282c:	8b 75 08             	mov    0x8(%ebp),%esi
  80282f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802832:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  802835:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  802837:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80283c:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	50                   	push   %eax
  802843:	e8 2a ff ff ff       	call   802772 <sys_ipc_recv>
	if (from_env_store)
  802848:	83 c4 10             	add    $0x10,%esp
  80284b:	85 f6                	test   %esi,%esi
  80284d:	74 0b                	je     80285a <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  80284f:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  802855:	8b 52 74             	mov    0x74(%edx),%edx
  802858:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80285a:	85 db                	test   %ebx,%ebx
  80285c:	74 0b                	je     802869 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  80285e:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  802864:	8b 52 78             	mov    0x78(%edx),%edx
  802867:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  802869:	85 c0                	test   %eax,%eax
  80286b:	79 16                	jns    802883 <ipc_recv+0x5c>
		if (from_env_store)
  80286d:	85 f6                	test   %esi,%esi
  80286f:	74 06                	je     802877 <ipc_recv+0x50>
			*from_env_store = 0;
  802871:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  802877:	85 db                	test   %ebx,%ebx
  802879:	74 10                	je     80288b <ipc_recv+0x64>
			*perm_store = 0;
  80287b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802881:	eb 08                	jmp    80288b <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  802883:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802888:	8b 40 70             	mov    0x70(%eax),%eax
}
  80288b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80288e:	5b                   	pop    %ebx
  80288f:	5e                   	pop    %esi
  802890:	5d                   	pop    %ebp
  802891:	c3                   	ret    

00802892 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	57                   	push   %edi
  802896:	56                   	push   %esi
  802897:	53                   	push   %ebx
  802898:	83 ec 0c             	sub    $0xc,%esp
  80289b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80289e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8028a4:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8028a6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028ab:	0f 44 d8             	cmove  %eax,%ebx
  8028ae:	eb 1c                	jmp    8028cc <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8028b0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028b3:	74 12                	je     8028c7 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8028b5:	50                   	push   %eax
  8028b6:	68 43 42 80 00       	push   $0x804243
  8028bb:	6a 42                	push   $0x42
  8028bd:	68 59 42 80 00       	push   $0x804259
  8028c2:	e8 1c f3 ff ff       	call   801be3 <_panic>
		sys_yield();
  8028c7:	e8 84 fd ff ff       	call   802650 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8028cc:	ff 75 14             	pushl  0x14(%ebp)
  8028cf:	53                   	push   %ebx
  8028d0:	56                   	push   %esi
  8028d1:	57                   	push   %edi
  8028d2:	e8 76 fe ff ff       	call   80274d <sys_ipc_try_send>
  8028d7:	83 c4 10             	add    $0x10,%esp
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	75 d2                	jne    8028b0 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8028de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028e1:	5b                   	pop    %ebx
  8028e2:	5e                   	pop    %esi
  8028e3:	5f                   	pop    %edi
  8028e4:	5d                   	pop    %ebp
  8028e5:	c3                   	ret    

008028e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028ec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028f1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8028f4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028fa:	8b 52 50             	mov    0x50(%edx),%edx
  8028fd:	39 ca                	cmp    %ecx,%edx
  8028ff:	75 0d                	jne    80290e <ipc_find_env+0x28>
			return envs[i].env_id;
  802901:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802904:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802909:	8b 40 48             	mov    0x48(%eax),%eax
  80290c:	eb 0f                	jmp    80291d <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80290e:	83 c0 01             	add    $0x1,%eax
  802911:	3d 00 04 00 00       	cmp    $0x400,%eax
  802916:	75 d9                	jne    8028f1 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802918:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80291d:	5d                   	pop    %ebp
  80291e:	c3                   	ret    

0080291f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	05 00 00 00 30       	add    $0x30000000,%eax
  80292a:	c1 e8 0c             	shr    $0xc,%eax
}
  80292d:	5d                   	pop    %ebp
  80292e:	c3                   	ret    

0080292f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  802932:	ff 75 08             	pushl  0x8(%ebp)
  802935:	e8 e5 ff ff ff       	call   80291f <fd2num>
  80293a:	83 c4 04             	add    $0x4,%esp
  80293d:	c1 e0 0c             	shl    $0xc,%eax
  802940:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802945:	c9                   	leave  
  802946:	c3                   	ret    

00802947 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802947:	55                   	push   %ebp
  802948:	89 e5                	mov    %esp,%ebp
  80294a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80294d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802952:	89 c2                	mov    %eax,%edx
  802954:	c1 ea 16             	shr    $0x16,%edx
  802957:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80295e:	f6 c2 01             	test   $0x1,%dl
  802961:	74 11                	je     802974 <fd_alloc+0x2d>
  802963:	89 c2                	mov    %eax,%edx
  802965:	c1 ea 0c             	shr    $0xc,%edx
  802968:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80296f:	f6 c2 01             	test   $0x1,%dl
  802972:	75 09                	jne    80297d <fd_alloc+0x36>
			*fd_store = fd;
  802974:	89 01                	mov    %eax,(%ecx)
			return 0;
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	eb 17                	jmp    802994 <fd_alloc+0x4d>
  80297d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802982:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802987:	75 c9                	jne    802952 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802989:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80298f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  802994:	5d                   	pop    %ebp
  802995:	c3                   	ret    

00802996 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80299c:	83 f8 1f             	cmp    $0x1f,%eax
  80299f:	77 36                	ja     8029d7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8029a1:	c1 e0 0c             	shl    $0xc,%eax
  8029a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8029a9:	89 c2                	mov    %eax,%edx
  8029ab:	c1 ea 16             	shr    $0x16,%edx
  8029ae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029b5:	f6 c2 01             	test   $0x1,%dl
  8029b8:	74 24                	je     8029de <fd_lookup+0x48>
  8029ba:	89 c2                	mov    %eax,%edx
  8029bc:	c1 ea 0c             	shr    $0xc,%edx
  8029bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8029c6:	f6 c2 01             	test   $0x1,%dl
  8029c9:	74 1a                	je     8029e5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8029cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ce:	89 02                	mov    %eax,(%edx)
	return 0;
  8029d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d5:	eb 13                	jmp    8029ea <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029dc:	eb 0c                	jmp    8029ea <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8029de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e3:	eb 05                	jmp    8029ea <fd_lookup+0x54>
  8029e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8029ea:	5d                   	pop    %ebp
  8029eb:	c3                   	ret    

008029ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029ec:	55                   	push   %ebp
  8029ed:	89 e5                	mov    %esp,%ebp
  8029ef:	83 ec 08             	sub    $0x8,%esp
  8029f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029f5:	ba e4 42 80 00       	mov    $0x8042e4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8029fa:	eb 13                	jmp    802a0f <dev_lookup+0x23>
  8029fc:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8029ff:	39 08                	cmp    %ecx,(%eax)
  802a01:	75 0c                	jne    802a0f <dev_lookup+0x23>
			*dev = devtab[i];
  802a03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a06:	89 01                	mov    %eax,(%ecx)
			return 0;
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0d:	eb 2e                	jmp    802a3d <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a0f:	8b 02                	mov    (%edx),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	75 e7                	jne    8029fc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a15:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a1a:	8b 40 48             	mov    0x48(%eax),%eax
  802a1d:	83 ec 04             	sub    $0x4,%esp
  802a20:	51                   	push   %ecx
  802a21:	50                   	push   %eax
  802a22:	68 64 42 80 00       	push   $0x804264
  802a27:	e8 90 f2 ff ff       	call   801cbc <cprintf>
	*dev = 0;
  802a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802a35:	83 c4 10             	add    $0x10,%esp
  802a38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
  802a42:	56                   	push   %esi
  802a43:	53                   	push   %ebx
  802a44:	83 ec 10             	sub    $0x10,%esp
  802a47:	8b 75 08             	mov    0x8(%ebp),%esi
  802a4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a4d:	56                   	push   %esi
  802a4e:	e8 cc fe ff ff       	call   80291f <fd2num>
  802a53:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802a56:	89 14 24             	mov    %edx,(%esp)
  802a59:	50                   	push   %eax
  802a5a:	e8 37 ff ff ff       	call   802996 <fd_lookup>
  802a5f:	83 c4 08             	add    $0x8,%esp
  802a62:	85 c0                	test   %eax,%eax
  802a64:	78 05                	js     802a6b <fd_close+0x2c>
	    || fd != fd2)
  802a66:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802a69:	74 0c                	je     802a77 <fd_close+0x38>
		return (must_exist ? r : 0);
  802a6b:	84 db                	test   %bl,%bl
  802a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a72:	0f 44 c2             	cmove  %edx,%eax
  802a75:	eb 41                	jmp    802ab8 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a77:	83 ec 08             	sub    $0x8,%esp
  802a7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a7d:	50                   	push   %eax
  802a7e:	ff 36                	pushl  (%esi)
  802a80:	e8 67 ff ff ff       	call   8029ec <dev_lookup>
  802a85:	89 c3                	mov    %eax,%ebx
  802a87:	83 c4 10             	add    $0x10,%esp
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	78 1a                	js     802aa8 <fd_close+0x69>
		if (dev->dev_close)
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  802a94:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	74 0b                	je     802aa8 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  802a9d:	83 ec 0c             	sub    $0xc,%esp
  802aa0:	56                   	push   %esi
  802aa1:	ff d0                	call   *%eax
  802aa3:	89 c3                	mov    %eax,%ebx
  802aa5:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802aa8:	83 ec 08             	sub    $0x8,%esp
  802aab:	56                   	push   %esi
  802aac:	6a 00                	push   $0x0
  802aae:	e8 0e fc ff ff       	call   8026c1 <sys_page_unmap>
	return r;
  802ab3:	83 c4 10             	add    $0x10,%esp
  802ab6:	89 d8                	mov    %ebx,%eax
}
  802ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802abb:	5b                   	pop    %ebx
  802abc:	5e                   	pop    %esi
  802abd:	5d                   	pop    %ebp
  802abe:	c3                   	ret    

00802abf <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
  802ac2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ac5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ac8:	50                   	push   %eax
  802ac9:	ff 75 08             	pushl  0x8(%ebp)
  802acc:	e8 c5 fe ff ff       	call   802996 <fd_lookup>
  802ad1:	83 c4 08             	add    $0x8,%esp
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	78 10                	js     802ae8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  802ad8:	83 ec 08             	sub    $0x8,%esp
  802adb:	6a 01                	push   $0x1
  802add:	ff 75 f4             	pushl  -0xc(%ebp)
  802ae0:	e8 5a ff ff ff       	call   802a3f <fd_close>
  802ae5:	83 c4 10             	add    $0x10,%esp
}
  802ae8:	c9                   	leave  
  802ae9:	c3                   	ret    

00802aea <close_all>:

void
close_all(void)
{
  802aea:	55                   	push   %ebp
  802aeb:	89 e5                	mov    %esp,%ebp
  802aed:	53                   	push   %ebx
  802aee:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802af1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802af6:	83 ec 0c             	sub    $0xc,%esp
  802af9:	53                   	push   %ebx
  802afa:	e8 c0 ff ff ff       	call   802abf <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802aff:	83 c3 01             	add    $0x1,%ebx
  802b02:	83 c4 10             	add    $0x10,%esp
  802b05:	83 fb 20             	cmp    $0x20,%ebx
  802b08:	75 ec                	jne    802af6 <close_all+0xc>
		close(i);
}
  802b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
  802b12:	57                   	push   %edi
  802b13:	56                   	push   %esi
  802b14:	53                   	push   %ebx
  802b15:	83 ec 2c             	sub    $0x2c,%esp
  802b18:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b1e:	50                   	push   %eax
  802b1f:	ff 75 08             	pushl  0x8(%ebp)
  802b22:	e8 6f fe ff ff       	call   802996 <fd_lookup>
  802b27:	83 c4 08             	add    $0x8,%esp
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	0f 88 c1 00 00 00    	js     802bf3 <dup+0xe4>
		return r;
	close(newfdnum);
  802b32:	83 ec 0c             	sub    $0xc,%esp
  802b35:	56                   	push   %esi
  802b36:	e8 84 ff ff ff       	call   802abf <close>

	newfd = INDEX2FD(newfdnum);
  802b3b:	89 f3                	mov    %esi,%ebx
  802b3d:	c1 e3 0c             	shl    $0xc,%ebx
  802b40:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802b46:	83 c4 04             	add    $0x4,%esp
  802b49:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b4c:	e8 de fd ff ff       	call   80292f <fd2data>
  802b51:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  802b53:	89 1c 24             	mov    %ebx,(%esp)
  802b56:	e8 d4 fd ff ff       	call   80292f <fd2data>
  802b5b:	83 c4 10             	add    $0x10,%esp
  802b5e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b61:	89 f8                	mov    %edi,%eax
  802b63:	c1 e8 16             	shr    $0x16,%eax
  802b66:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802b6d:	a8 01                	test   $0x1,%al
  802b6f:	74 37                	je     802ba8 <dup+0x99>
  802b71:	89 f8                	mov    %edi,%eax
  802b73:	c1 e8 0c             	shr    $0xc,%eax
  802b76:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b7d:	f6 c2 01             	test   $0x1,%dl
  802b80:	74 26                	je     802ba8 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b82:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802b89:	83 ec 0c             	sub    $0xc,%esp
  802b8c:	25 07 0e 00 00       	and    $0xe07,%eax
  802b91:	50                   	push   %eax
  802b92:	ff 75 d4             	pushl  -0x2c(%ebp)
  802b95:	6a 00                	push   $0x0
  802b97:	57                   	push   %edi
  802b98:	6a 00                	push   $0x0
  802b9a:	e8 fc fa ff ff       	call   80269b <sys_page_map>
  802b9f:	89 c7                	mov    %eax,%edi
  802ba1:	83 c4 20             	add    $0x20,%esp
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	78 2e                	js     802bd6 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ba8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bab:	89 d0                	mov    %edx,%eax
  802bad:	c1 e8 0c             	shr    $0xc,%eax
  802bb0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802bb7:	83 ec 0c             	sub    $0xc,%esp
  802bba:	25 07 0e 00 00       	and    $0xe07,%eax
  802bbf:	50                   	push   %eax
  802bc0:	53                   	push   %ebx
  802bc1:	6a 00                	push   $0x0
  802bc3:	52                   	push   %edx
  802bc4:	6a 00                	push   $0x0
  802bc6:	e8 d0 fa ff ff       	call   80269b <sys_page_map>
  802bcb:	89 c7                	mov    %eax,%edi
  802bcd:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  802bd0:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802bd2:	85 ff                	test   %edi,%edi
  802bd4:	79 1d                	jns    802bf3 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802bd6:	83 ec 08             	sub    $0x8,%esp
  802bd9:	53                   	push   %ebx
  802bda:	6a 00                	push   $0x0
  802bdc:	e8 e0 fa ff ff       	call   8026c1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802be1:	83 c4 08             	add    $0x8,%esp
  802be4:	ff 75 d4             	pushl  -0x2c(%ebp)
  802be7:	6a 00                	push   $0x0
  802be9:	e8 d3 fa ff ff       	call   8026c1 <sys_page_unmap>
	return r;
  802bee:	83 c4 10             	add    $0x10,%esp
  802bf1:	89 f8                	mov    %edi,%eax
}
  802bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bf6:	5b                   	pop    %ebx
  802bf7:	5e                   	pop    %esi
  802bf8:	5f                   	pop    %edi
  802bf9:	5d                   	pop    %ebp
  802bfa:	c3                   	ret    

00802bfb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
  802bfe:	53                   	push   %ebx
  802bff:	83 ec 14             	sub    $0x14,%esp
  802c02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c05:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802c08:	50                   	push   %eax
  802c09:	53                   	push   %ebx
  802c0a:	e8 87 fd ff ff       	call   802996 <fd_lookup>
  802c0f:	83 c4 08             	add    $0x8,%esp
  802c12:	89 c2                	mov    %eax,%edx
  802c14:	85 c0                	test   %eax,%eax
  802c16:	78 6d                	js     802c85 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c18:	83 ec 08             	sub    $0x8,%esp
  802c1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c1e:	50                   	push   %eax
  802c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c22:	ff 30                	pushl  (%eax)
  802c24:	e8 c3 fd ff ff       	call   8029ec <dev_lookup>
  802c29:	83 c4 10             	add    $0x10,%esp
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	78 4c                	js     802c7c <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c33:	8b 42 08             	mov    0x8(%edx),%eax
  802c36:	83 e0 03             	and    $0x3,%eax
  802c39:	83 f8 01             	cmp    $0x1,%eax
  802c3c:	75 21                	jne    802c5f <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c3e:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802c43:	8b 40 48             	mov    0x48(%eax),%eax
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	53                   	push   %ebx
  802c4a:	50                   	push   %eax
  802c4b:	68 a8 42 80 00       	push   $0x8042a8
  802c50:	e8 67 f0 ff ff       	call   801cbc <cprintf>
		return -E_INVAL;
  802c55:	83 c4 10             	add    $0x10,%esp
  802c58:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802c5d:	eb 26                	jmp    802c85 <read+0x8a>
	}
	if (!dev->dev_read)
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 08             	mov    0x8(%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 17                	je     802c80 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	ff 75 10             	pushl  0x10(%ebp)
  802c6f:	ff 75 0c             	pushl  0xc(%ebp)
  802c72:	52                   	push   %edx
  802c73:	ff d0                	call   *%eax
  802c75:	89 c2                	mov    %eax,%edx
  802c77:	83 c4 10             	add    $0x10,%esp
  802c7a:	eb 09                	jmp    802c85 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c7c:	89 c2                	mov    %eax,%edx
  802c7e:	eb 05                	jmp    802c85 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802c80:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  802c85:	89 d0                	mov    %edx,%eax
  802c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c8a:	c9                   	leave  
  802c8b:	c3                   	ret    

00802c8c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
  802c8f:	57                   	push   %edi
  802c90:	56                   	push   %esi
  802c91:	53                   	push   %ebx
  802c92:	83 ec 0c             	sub    $0xc,%esp
  802c95:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c98:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ca0:	eb 21                	jmp    802cc3 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	89 f0                	mov    %esi,%eax
  802ca7:	29 d8                	sub    %ebx,%eax
  802ca9:	50                   	push   %eax
  802caa:	89 d8                	mov    %ebx,%eax
  802cac:	03 45 0c             	add    0xc(%ebp),%eax
  802caf:	50                   	push   %eax
  802cb0:	57                   	push   %edi
  802cb1:	e8 45 ff ff ff       	call   802bfb <read>
		if (m < 0)
  802cb6:	83 c4 10             	add    $0x10,%esp
  802cb9:	85 c0                	test   %eax,%eax
  802cbb:	78 10                	js     802ccd <readn+0x41>
			return m;
		if (m == 0)
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	74 0a                	je     802ccb <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cc1:	01 c3                	add    %eax,%ebx
  802cc3:	39 f3                	cmp    %esi,%ebx
  802cc5:	72 db                	jb     802ca2 <readn+0x16>
  802cc7:	89 d8                	mov    %ebx,%eax
  802cc9:	eb 02                	jmp    802ccd <readn+0x41>
  802ccb:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  802ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cd0:	5b                   	pop    %ebx
  802cd1:	5e                   	pop    %esi
  802cd2:	5f                   	pop    %edi
  802cd3:	5d                   	pop    %ebp
  802cd4:	c3                   	ret    

00802cd5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cd5:	55                   	push   %ebp
  802cd6:	89 e5                	mov    %esp,%ebp
  802cd8:	53                   	push   %ebx
  802cd9:	83 ec 14             	sub    $0x14,%esp
  802cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cdf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ce2:	50                   	push   %eax
  802ce3:	53                   	push   %ebx
  802ce4:	e8 ad fc ff ff       	call   802996 <fd_lookup>
  802ce9:	83 c4 08             	add    $0x8,%esp
  802cec:	89 c2                	mov    %eax,%edx
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	78 68                	js     802d5a <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cf2:	83 ec 08             	sub    $0x8,%esp
  802cf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cf8:	50                   	push   %eax
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	ff 30                	pushl  (%eax)
  802cfe:	e8 e9 fc ff ff       	call   8029ec <dev_lookup>
  802d03:	83 c4 10             	add    $0x10,%esp
  802d06:	85 c0                	test   %eax,%eax
  802d08:	78 47                	js     802d51 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802d11:	75 21                	jne    802d34 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d13:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802d18:	8b 40 48             	mov    0x48(%eax),%eax
  802d1b:	83 ec 04             	sub    $0x4,%esp
  802d1e:	53                   	push   %ebx
  802d1f:	50                   	push   %eax
  802d20:	68 c4 42 80 00       	push   $0x8042c4
  802d25:	e8 92 ef ff ff       	call   801cbc <cprintf>
		return -E_INVAL;
  802d2a:	83 c4 10             	add    $0x10,%esp
  802d2d:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802d32:	eb 26                	jmp    802d5a <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d37:	8b 52 0c             	mov    0xc(%edx),%edx
  802d3a:	85 d2                	test   %edx,%edx
  802d3c:	74 17                	je     802d55 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	ff 75 10             	pushl  0x10(%ebp)
  802d44:	ff 75 0c             	pushl  0xc(%ebp)
  802d47:	50                   	push   %eax
  802d48:	ff d2                	call   *%edx
  802d4a:	89 c2                	mov    %eax,%edx
  802d4c:	83 c4 10             	add    $0x10,%esp
  802d4f:	eb 09                	jmp    802d5a <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d51:	89 c2                	mov    %eax,%edx
  802d53:	eb 05                	jmp    802d5a <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  802d55:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  802d5a:	89 d0                	mov    %edx,%eax
  802d5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d5f:	c9                   	leave  
  802d60:	c3                   	ret    

00802d61 <seek>:

int
seek(int fdnum, off_t offset)
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
  802d64:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d67:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802d6a:	50                   	push   %eax
  802d6b:	ff 75 08             	pushl  0x8(%ebp)
  802d6e:	e8 23 fc ff ff       	call   802996 <fd_lookup>
  802d73:	83 c4 08             	add    $0x8,%esp
  802d76:	85 c0                	test   %eax,%eax
  802d78:	78 0e                	js     802d88 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
  802d8d:	53                   	push   %ebx
  802d8e:	83 ec 14             	sub    $0x14,%esp
  802d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d94:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d97:	50                   	push   %eax
  802d98:	53                   	push   %ebx
  802d99:	e8 f8 fb ff ff       	call   802996 <fd_lookup>
  802d9e:	83 c4 08             	add    $0x8,%esp
  802da1:	89 c2                	mov    %eax,%edx
  802da3:	85 c0                	test   %eax,%eax
  802da5:	78 65                	js     802e0c <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802da7:	83 ec 08             	sub    $0x8,%esp
  802daa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802dad:	50                   	push   %eax
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	ff 30                	pushl  (%eax)
  802db3:	e8 34 fc ff ff       	call   8029ec <dev_lookup>
  802db8:	83 c4 10             	add    $0x10,%esp
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	78 44                	js     802e03 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802dc6:	75 21                	jne    802de9 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802dc8:	a1 0c a0 80 00       	mov    0x80a00c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dcd:	8b 40 48             	mov    0x48(%eax),%eax
  802dd0:	83 ec 04             	sub    $0x4,%esp
  802dd3:	53                   	push   %ebx
  802dd4:	50                   	push   %eax
  802dd5:	68 84 42 80 00       	push   $0x804284
  802dda:	e8 dd ee ff ff       	call   801cbc <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ddf:	83 c4 10             	add    $0x10,%esp
  802de2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802de7:	eb 23                	jmp    802e0c <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  802de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dec:	8b 52 18             	mov    0x18(%edx),%edx
  802def:	85 d2                	test   %edx,%edx
  802df1:	74 14                	je     802e07 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802df3:	83 ec 08             	sub    $0x8,%esp
  802df6:	ff 75 0c             	pushl  0xc(%ebp)
  802df9:	50                   	push   %eax
  802dfa:	ff d2                	call   *%edx
  802dfc:	89 c2                	mov    %eax,%edx
  802dfe:	83 c4 10             	add    $0x10,%esp
  802e01:	eb 09                	jmp    802e0c <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e03:	89 c2                	mov    %eax,%edx
  802e05:	eb 05                	jmp    802e0c <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  802e07:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  802e0c:	89 d0                	mov    %edx,%eax
  802e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e11:	c9                   	leave  
  802e12:	c3                   	ret    

00802e13 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
  802e16:	53                   	push   %ebx
  802e17:	83 ec 14             	sub    $0x14,%esp
  802e1a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e20:	50                   	push   %eax
  802e21:	ff 75 08             	pushl  0x8(%ebp)
  802e24:	e8 6d fb ff ff       	call   802996 <fd_lookup>
  802e29:	83 c4 08             	add    $0x8,%esp
  802e2c:	89 c2                	mov    %eax,%edx
  802e2e:	85 c0                	test   %eax,%eax
  802e30:	78 58                	js     802e8a <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e32:	83 ec 08             	sub    $0x8,%esp
  802e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e38:	50                   	push   %eax
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	ff 30                	pushl  (%eax)
  802e3e:	e8 a9 fb ff ff       	call   8029ec <dev_lookup>
  802e43:	83 c4 10             	add    $0x10,%esp
  802e46:	85 c0                	test   %eax,%eax
  802e48:	78 37                	js     802e81 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802e51:	74 32                	je     802e85 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802e53:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802e56:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802e5d:	00 00 00 
	stat->st_isdir = 0;
  802e60:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802e67:	00 00 00 
	stat->st_dev = dev;
  802e6a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802e70:	83 ec 08             	sub    $0x8,%esp
  802e73:	53                   	push   %ebx
  802e74:	ff 75 f0             	pushl  -0x10(%ebp)
  802e77:	ff 50 14             	call   *0x14(%eax)
  802e7a:	89 c2                	mov    %eax,%edx
  802e7c:	83 c4 10             	add    $0x10,%esp
  802e7f:	eb 09                	jmp    802e8a <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e81:	89 c2                	mov    %eax,%edx
  802e83:	eb 05                	jmp    802e8a <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802e85:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  802e8a:	89 d0                	mov    %edx,%eax
  802e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e8f:	c9                   	leave  
  802e90:	c3                   	ret    

00802e91 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e91:	55                   	push   %ebp
  802e92:	89 e5                	mov    %esp,%ebp
  802e94:	56                   	push   %esi
  802e95:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e96:	83 ec 08             	sub    $0x8,%esp
  802e99:	6a 00                	push   $0x0
  802e9b:	ff 75 08             	pushl  0x8(%ebp)
  802e9e:	e8 06 02 00 00       	call   8030a9 <open>
  802ea3:	89 c3                	mov    %eax,%ebx
  802ea5:	83 c4 10             	add    $0x10,%esp
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	78 1b                	js     802ec7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802eac:	83 ec 08             	sub    $0x8,%esp
  802eaf:	ff 75 0c             	pushl  0xc(%ebp)
  802eb2:	50                   	push   %eax
  802eb3:	e8 5b ff ff ff       	call   802e13 <fstat>
  802eb8:	89 c6                	mov    %eax,%esi
	close(fd);
  802eba:	89 1c 24             	mov    %ebx,(%esp)
  802ebd:	e8 fd fb ff ff       	call   802abf <close>
	return r;
  802ec2:	83 c4 10             	add    $0x10,%esp
  802ec5:	89 f0                	mov    %esi,%eax
}
  802ec7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802eca:	5b                   	pop    %ebx
  802ecb:	5e                   	pop    %esi
  802ecc:	5d                   	pop    %ebp
  802ecd:	c3                   	ret    

00802ece <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ece:	55                   	push   %ebp
  802ecf:	89 e5                	mov    %esp,%ebp
  802ed1:	56                   	push   %esi
  802ed2:	53                   	push   %ebx
  802ed3:	89 c6                	mov    %eax,%esi
  802ed5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802ed7:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802ede:	75 12                	jne    802ef2 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ee0:	83 ec 0c             	sub    $0xc,%esp
  802ee3:	6a 01                	push   $0x1
  802ee5:	e8 fc f9 ff ff       	call   8028e6 <ipc_find_env>
  802eea:	a3 00 a0 80 00       	mov    %eax,0x80a000
  802eef:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ef2:	6a 07                	push   $0x7
  802ef4:	68 00 b0 80 00       	push   $0x80b000
  802ef9:	56                   	push   %esi
  802efa:	ff 35 00 a0 80 00    	pushl  0x80a000
  802f00:	e8 8d f9 ff ff       	call   802892 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802f05:	83 c4 0c             	add    $0xc,%esp
  802f08:	6a 00                	push   $0x0
  802f0a:	53                   	push   %ebx
  802f0b:	6a 00                	push   $0x0
  802f0d:	e8 15 f9 ff ff       	call   802827 <ipc_recv>
}
  802f12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f15:	5b                   	pop    %ebx
  802f16:	5e                   	pop    %esi
  802f17:	5d                   	pop    %ebp
  802f18:	c3                   	ret    

00802f19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f19:	55                   	push   %ebp
  802f1a:	89 e5                	mov    %esp,%ebp
  802f1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2d:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f32:	ba 00 00 00 00       	mov    $0x0,%edx
  802f37:	b8 02 00 00 00       	mov    $0x2,%eax
  802f3c:	e8 8d ff ff ff       	call   802ece <fsipc>
}
  802f41:	c9                   	leave  
  802f42:	c3                   	ret    

00802f43 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
  802f46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4f:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802f54:	ba 00 00 00 00       	mov    $0x0,%edx
  802f59:	b8 06 00 00 00       	mov    $0x6,%eax
  802f5e:	e8 6b ff ff ff       	call   802ece <fsipc>
}
  802f63:	c9                   	leave  
  802f64:	c3                   	ret    

00802f65 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f65:	55                   	push   %ebp
  802f66:	89 e5                	mov    %esp,%ebp
  802f68:	53                   	push   %ebx
  802f69:	83 ec 04             	sub    $0x4,%esp
  802f6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f7a:	ba 00 00 00 00       	mov    $0x0,%edx
  802f7f:	b8 05 00 00 00       	mov    $0x5,%eax
  802f84:	e8 45 ff ff ff       	call   802ece <fsipc>
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	78 2c                	js     802fb9 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f8d:	83 ec 08             	sub    $0x8,%esp
  802f90:	68 00 b0 80 00       	push   $0x80b000
  802f95:	53                   	push   %ebx
  802f96:	e8 93 f2 ff ff       	call   80222e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802f9b:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802fa0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fa6:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802fab:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802fb1:	83 c4 10             	add    $0x10,%esp
  802fb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fbc:	c9                   	leave  
  802fbd:	c3                   	ret    

00802fbe <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802fbe:	55                   	push   %ebp
  802fbf:	89 e5                	mov    %esp,%ebp
  802fc1:	83 ec 08             	sub    $0x8,%esp
  802fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc7:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fcd:	8b 49 0c             	mov    0xc(%ecx),%ecx
  802fd0:	89 0d 00 b0 80 00    	mov    %ecx,0x80b000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  802fd6:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802fdb:	76 22                	jbe    802fff <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  802fdd:	c7 05 04 b0 80 00 f8 	movl   $0xff8,0x80b004
  802fe4:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  802fe7:	83 ec 04             	sub    $0x4,%esp
  802fea:	68 f8 0f 00 00       	push   $0xff8
  802fef:	52                   	push   %edx
  802ff0:	68 08 b0 80 00       	push   $0x80b008
  802ff5:	e8 c7 f3 ff ff       	call   8023c1 <memmove>
  802ffa:	83 c4 10             	add    $0x10,%esp
  802ffd:	eb 17                	jmp    803016 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  802fff:	a3 04 b0 80 00       	mov    %eax,0x80b004
		memmove(fsipcbuf.write.req_buf, buf, n);
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	50                   	push   %eax
  803008:	52                   	push   %edx
  803009:	68 08 b0 80 00       	push   $0x80b008
  80300e:	e8 ae f3 ff ff       	call   8023c1 <memmove>
  803013:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  803016:	ba 00 00 00 00       	mov    $0x0,%edx
  80301b:	b8 04 00 00 00       	mov    $0x4,%eax
  803020:	e8 a9 fe ff ff       	call   802ece <fsipc>
	if (result < 0)
		return result;

	return result;
}
  803025:	c9                   	leave  
  803026:	c3                   	ret    

00803027 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803027:	55                   	push   %ebp
  803028:	89 e5                	mov    %esp,%ebp
  80302a:	56                   	push   %esi
  80302b:	53                   	push   %ebx
  80302c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 40 0c             	mov    0xc(%eax),%eax
  803035:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  80303a:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803040:	ba 00 00 00 00       	mov    $0x0,%edx
  803045:	b8 03 00 00 00       	mov    $0x3,%eax
  80304a:	e8 7f fe ff ff       	call   802ece <fsipc>
  80304f:	89 c3                	mov    %eax,%ebx
  803051:	85 c0                	test   %eax,%eax
  803053:	78 4b                	js     8030a0 <devfile_read+0x79>
		return r;
	assert(r <= n);
  803055:	39 c6                	cmp    %eax,%esi
  803057:	73 16                	jae    80306f <devfile_read+0x48>
  803059:	68 f4 42 80 00       	push   $0x8042f4
  80305e:	68 3d 39 80 00       	push   $0x80393d
  803063:	6a 7c                	push   $0x7c
  803065:	68 fb 42 80 00       	push   $0x8042fb
  80306a:	e8 74 eb ff ff       	call   801be3 <_panic>
	assert(r <= PGSIZE);
  80306f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803074:	7e 16                	jle    80308c <devfile_read+0x65>
  803076:	68 06 43 80 00       	push   $0x804306
  80307b:	68 3d 39 80 00       	push   $0x80393d
  803080:	6a 7d                	push   $0x7d
  803082:	68 fb 42 80 00       	push   $0x8042fb
  803087:	e8 57 eb ff ff       	call   801be3 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80308c:	83 ec 04             	sub    $0x4,%esp
  80308f:	50                   	push   %eax
  803090:	68 00 b0 80 00       	push   $0x80b000
  803095:	ff 75 0c             	pushl  0xc(%ebp)
  803098:	e8 24 f3 ff ff       	call   8023c1 <memmove>
	return r;
  80309d:	83 c4 10             	add    $0x10,%esp
}
  8030a0:	89 d8                	mov    %ebx,%eax
  8030a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030a5:	5b                   	pop    %ebx
  8030a6:	5e                   	pop    %esi
  8030a7:	5d                   	pop    %ebp
  8030a8:	c3                   	ret    

008030a9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030a9:	55                   	push   %ebp
  8030aa:	89 e5                	mov    %esp,%ebp
  8030ac:	53                   	push   %ebx
  8030ad:	83 ec 20             	sub    $0x20,%esp
  8030b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8030b3:	53                   	push   %ebx
  8030b4:	e8 3c f1 ff ff       	call   8021f5 <strlen>
  8030b9:	83 c4 10             	add    $0x10,%esp
  8030bc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030c1:	7f 67                	jg     80312a <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8030c3:	83 ec 0c             	sub    $0xc,%esp
  8030c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030c9:	50                   	push   %eax
  8030ca:	e8 78 f8 ff ff       	call   802947 <fd_alloc>
  8030cf:	83 c4 10             	add    $0x10,%esp
		return r;
  8030d2:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	78 57                	js     80312f <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8030d8:	83 ec 08             	sub    $0x8,%esp
  8030db:	53                   	push   %ebx
  8030dc:	68 00 b0 80 00       	push   $0x80b000
  8030e1:	e8 48 f1 ff ff       	call   80222e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8030e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e9:	a3 00 b4 80 00       	mov    %eax,0x80b400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8030ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030f6:	e8 d3 fd ff ff       	call   802ece <fsipc>
  8030fb:	89 c3                	mov    %eax,%ebx
  8030fd:	83 c4 10             	add    $0x10,%esp
  803100:	85 c0                	test   %eax,%eax
  803102:	79 14                	jns    803118 <open+0x6f>
		fd_close(fd, 0);
  803104:	83 ec 08             	sub    $0x8,%esp
  803107:	6a 00                	push   $0x0
  803109:	ff 75 f4             	pushl  -0xc(%ebp)
  80310c:	e8 2e f9 ff ff       	call   802a3f <fd_close>
		return r;
  803111:	83 c4 10             	add    $0x10,%esp
  803114:	89 da                	mov    %ebx,%edx
  803116:	eb 17                	jmp    80312f <open+0x86>
	}

	return fd2num(fd);
  803118:	83 ec 0c             	sub    $0xc,%esp
  80311b:	ff 75 f4             	pushl  -0xc(%ebp)
  80311e:	e8 fc f7 ff ff       	call   80291f <fd2num>
  803123:	89 c2                	mov    %eax,%edx
  803125:	83 c4 10             	add    $0x10,%esp
  803128:	eb 05                	jmp    80312f <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80312a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80312f:	89 d0                	mov    %edx,%eax
  803131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803134:	c9                   	leave  
  803135:	c3                   	ret    

00803136 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803136:	55                   	push   %ebp
  803137:	89 e5                	mov    %esp,%ebp
  803139:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80313c:	ba 00 00 00 00       	mov    $0x0,%edx
  803141:	b8 08 00 00 00       	mov    $0x8,%eax
  803146:	e8 83 fd ff ff       	call   802ece <fsipc>
}
  80314b:	c9                   	leave  
  80314c:	c3                   	ret    

0080314d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
  803150:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803153:	89 d0                	mov    %edx,%eax
  803155:	c1 e8 16             	shr    $0x16,%eax
  803158:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80315f:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803164:	f6 c1 01             	test   $0x1,%cl
  803167:	74 1d                	je     803186 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  803169:	c1 ea 0c             	shr    $0xc,%edx
  80316c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803173:	f6 c2 01             	test   $0x1,%dl
  803176:	74 0e                	je     803186 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803178:	c1 ea 0c             	shr    $0xc,%edx
  80317b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803182:	ef 
  803183:	0f b7 c0             	movzwl %ax,%eax
}
  803186:	5d                   	pop    %ebp
  803187:	c3                   	ret    

00803188 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803188:	55                   	push   %ebp
  803189:	89 e5                	mov    %esp,%ebp
  80318b:	56                   	push   %esi
  80318c:	53                   	push   %ebx
  80318d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803190:	83 ec 0c             	sub    $0xc,%esp
  803193:	ff 75 08             	pushl  0x8(%ebp)
  803196:	e8 94 f7 ff ff       	call   80292f <fd2data>
  80319b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80319d:	83 c4 08             	add    $0x8,%esp
  8031a0:	68 12 43 80 00       	push   $0x804312
  8031a5:	53                   	push   %ebx
  8031a6:	e8 83 f0 ff ff       	call   80222e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8031ab:	8b 46 04             	mov    0x4(%esi),%eax
  8031ae:	2b 06                	sub    (%esi),%eax
  8031b0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8031b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8031bd:	00 00 00 
	stat->st_dev = &devpipe;
  8031c0:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  8031c7:	90 80 00 
	return 0;
}
  8031ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031d2:	5b                   	pop    %ebx
  8031d3:	5e                   	pop    %esi
  8031d4:	5d                   	pop    %ebp
  8031d5:	c3                   	ret    

008031d6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8031d6:	55                   	push   %ebp
  8031d7:	89 e5                	mov    %esp,%ebp
  8031d9:	53                   	push   %ebx
  8031da:	83 ec 0c             	sub    $0xc,%esp
  8031dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8031e0:	53                   	push   %ebx
  8031e1:	6a 00                	push   $0x0
  8031e3:	e8 d9 f4 ff ff       	call   8026c1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8031e8:	89 1c 24             	mov    %ebx,(%esp)
  8031eb:	e8 3f f7 ff ff       	call   80292f <fd2data>
  8031f0:	83 c4 08             	add    $0x8,%esp
  8031f3:	50                   	push   %eax
  8031f4:	6a 00                	push   $0x0
  8031f6:	e8 c6 f4 ff ff       	call   8026c1 <sys_page_unmap>
}
  8031fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031fe:	c9                   	leave  
  8031ff:	c3                   	ret    

00803200 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803200:	55                   	push   %ebp
  803201:	89 e5                	mov    %esp,%ebp
  803203:	57                   	push   %edi
  803204:	56                   	push   %esi
  803205:	53                   	push   %ebx
  803206:	83 ec 1c             	sub    $0x1c,%esp
  803209:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80320c:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80320e:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  803213:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  803216:	83 ec 0c             	sub    $0xc,%esp
  803219:	ff 75 e0             	pushl  -0x20(%ebp)
  80321c:	e8 2c ff ff ff       	call   80314d <pageref>
  803221:	89 c3                	mov    %eax,%ebx
  803223:	89 3c 24             	mov    %edi,(%esp)
  803226:	e8 22 ff ff ff       	call   80314d <pageref>
  80322b:	83 c4 10             	add    $0x10,%esp
  80322e:	39 c3                	cmp    %eax,%ebx
  803230:	0f 94 c1             	sete   %cl
  803233:	0f b6 c9             	movzbl %cl,%ecx
  803236:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  803239:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80323f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803242:	39 ce                	cmp    %ecx,%esi
  803244:	74 1b                	je     803261 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803246:	39 c3                	cmp    %eax,%ebx
  803248:	75 c4                	jne    80320e <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80324a:	8b 42 58             	mov    0x58(%edx),%eax
  80324d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803250:	50                   	push   %eax
  803251:	56                   	push   %esi
  803252:	68 19 43 80 00       	push   $0x804319
  803257:	e8 60 ea ff ff       	call   801cbc <cprintf>
  80325c:	83 c4 10             	add    $0x10,%esp
  80325f:	eb ad                	jmp    80320e <_pipeisclosed+0xe>
	}
}
  803261:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803267:	5b                   	pop    %ebx
  803268:	5e                   	pop    %esi
  803269:	5f                   	pop    %edi
  80326a:	5d                   	pop    %ebp
  80326b:	c3                   	ret    

0080326c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
  80326f:	57                   	push   %edi
  803270:	56                   	push   %esi
  803271:	53                   	push   %ebx
  803272:	83 ec 28             	sub    $0x28,%esp
  803275:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803278:	56                   	push   %esi
  803279:	e8 b1 f6 ff ff       	call   80292f <fd2data>
  80327e:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803280:	83 c4 10             	add    $0x10,%esp
  803283:	bf 00 00 00 00       	mov    $0x0,%edi
  803288:	eb 4b                	jmp    8032d5 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80328a:	89 da                	mov    %ebx,%edx
  80328c:	89 f0                	mov    %esi,%eax
  80328e:	e8 6d ff ff ff       	call   803200 <_pipeisclosed>
  803293:	85 c0                	test   %eax,%eax
  803295:	75 48                	jne    8032df <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803297:	e8 b4 f3 ff ff       	call   802650 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80329c:	8b 43 04             	mov    0x4(%ebx),%eax
  80329f:	8b 0b                	mov    (%ebx),%ecx
  8032a1:	8d 51 20             	lea    0x20(%ecx),%edx
  8032a4:	39 d0                	cmp    %edx,%eax
  8032a6:	73 e2                	jae    80328a <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8032a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8032ab:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8032af:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8032b2:	89 c2                	mov    %eax,%edx
  8032b4:	c1 fa 1f             	sar    $0x1f,%edx
  8032b7:	89 d1                	mov    %edx,%ecx
  8032b9:	c1 e9 1b             	shr    $0x1b,%ecx
  8032bc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8032bf:	83 e2 1f             	and    $0x1f,%edx
  8032c2:	29 ca                	sub    %ecx,%edx
  8032c4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8032c8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8032cc:	83 c0 01             	add    $0x1,%eax
  8032cf:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032d2:	83 c7 01             	add    $0x1,%edi
  8032d5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8032d8:	75 c2                	jne    80329c <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8032da:	8b 45 10             	mov    0x10(%ebp),%eax
  8032dd:	eb 05                	jmp    8032e4 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8032df:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8032e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5f                   	pop    %edi
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    

008032ec <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
  8032ef:	57                   	push   %edi
  8032f0:	56                   	push   %esi
  8032f1:	53                   	push   %ebx
  8032f2:	83 ec 18             	sub    $0x18,%esp
  8032f5:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8032f8:	57                   	push   %edi
  8032f9:	e8 31 f6 ff ff       	call   80292f <fd2data>
  8032fe:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803300:	83 c4 10             	add    $0x10,%esp
  803303:	bb 00 00 00 00       	mov    $0x0,%ebx
  803308:	eb 3d                	jmp    803347 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80330a:	85 db                	test   %ebx,%ebx
  80330c:	74 04                	je     803312 <devpipe_read+0x26>
				return i;
  80330e:	89 d8                	mov    %ebx,%eax
  803310:	eb 44                	jmp    803356 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803312:	89 f2                	mov    %esi,%edx
  803314:	89 f8                	mov    %edi,%eax
  803316:	e8 e5 fe ff ff       	call   803200 <_pipeisclosed>
  80331b:	85 c0                	test   %eax,%eax
  80331d:	75 32                	jne    803351 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80331f:	e8 2c f3 ff ff       	call   802650 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803324:	8b 06                	mov    (%esi),%eax
  803326:	3b 46 04             	cmp    0x4(%esi),%eax
  803329:	74 df                	je     80330a <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80332b:	99                   	cltd   
  80332c:	c1 ea 1b             	shr    $0x1b,%edx
  80332f:	01 d0                	add    %edx,%eax
  803331:	83 e0 1f             	and    $0x1f,%eax
  803334:	29 d0                	sub    %edx,%eax
  803336:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  80333b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80333e:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  803341:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803344:	83 c3 01             	add    $0x1,%ebx
  803347:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80334a:	75 d8                	jne    803324 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80334c:	8b 45 10             	mov    0x10(%ebp),%eax
  80334f:	eb 05                	jmp    803356 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803351:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803356:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803359:	5b                   	pop    %ebx
  80335a:	5e                   	pop    %esi
  80335b:	5f                   	pop    %edi
  80335c:	5d                   	pop    %ebp
  80335d:	c3                   	ret    

0080335e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80335e:	55                   	push   %ebp
  80335f:	89 e5                	mov    %esp,%ebp
  803361:	56                   	push   %esi
  803362:	53                   	push   %ebx
  803363:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803366:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803369:	50                   	push   %eax
  80336a:	e8 d8 f5 ff ff       	call   802947 <fd_alloc>
  80336f:	83 c4 10             	add    $0x10,%esp
  803372:	89 c2                	mov    %eax,%edx
  803374:	85 c0                	test   %eax,%eax
  803376:	0f 88 2c 01 00 00    	js     8034a8 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80337c:	83 ec 04             	sub    $0x4,%esp
  80337f:	68 07 04 00 00       	push   $0x407
  803384:	ff 75 f4             	pushl  -0xc(%ebp)
  803387:	6a 00                	push   $0x0
  803389:	e8 e9 f2 ff ff       	call   802677 <sys_page_alloc>
  80338e:	83 c4 10             	add    $0x10,%esp
  803391:	89 c2                	mov    %eax,%edx
  803393:	85 c0                	test   %eax,%eax
  803395:	0f 88 0d 01 00 00    	js     8034a8 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80339b:	83 ec 0c             	sub    $0xc,%esp
  80339e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8033a1:	50                   	push   %eax
  8033a2:	e8 a0 f5 ff ff       	call   802947 <fd_alloc>
  8033a7:	89 c3                	mov    %eax,%ebx
  8033a9:	83 c4 10             	add    $0x10,%esp
  8033ac:	85 c0                	test   %eax,%eax
  8033ae:	0f 88 e2 00 00 00    	js     803496 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	68 07 04 00 00       	push   $0x407
  8033bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8033bf:	6a 00                	push   $0x0
  8033c1:	e8 b1 f2 ff ff       	call   802677 <sys_page_alloc>
  8033c6:	89 c3                	mov    %eax,%ebx
  8033c8:	83 c4 10             	add    $0x10,%esp
  8033cb:	85 c0                	test   %eax,%eax
  8033cd:	0f 88 c3 00 00 00    	js     803496 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8033d3:	83 ec 0c             	sub    $0xc,%esp
  8033d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8033d9:	e8 51 f5 ff ff       	call   80292f <fd2data>
  8033de:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033e0:	83 c4 0c             	add    $0xc,%esp
  8033e3:	68 07 04 00 00       	push   $0x407
  8033e8:	50                   	push   %eax
  8033e9:	6a 00                	push   $0x0
  8033eb:	e8 87 f2 ff ff       	call   802677 <sys_page_alloc>
  8033f0:	89 c3                	mov    %eax,%ebx
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	0f 88 89 00 00 00    	js     803486 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033fd:	83 ec 0c             	sub    $0xc,%esp
  803400:	ff 75 f0             	pushl  -0x10(%ebp)
  803403:	e8 27 f5 ff ff       	call   80292f <fd2data>
  803408:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80340f:	50                   	push   %eax
  803410:	6a 00                	push   $0x0
  803412:	56                   	push   %esi
  803413:	6a 00                	push   $0x0
  803415:	e8 81 f2 ff ff       	call   80269b <sys_page_map>
  80341a:	89 c3                	mov    %eax,%ebx
  80341c:	83 c4 20             	add    $0x20,%esp
  80341f:	85 c0                	test   %eax,%eax
  803421:	78 55                	js     803478 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803423:	8b 15 80 90 80 00    	mov    0x809080,%edx
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803438:	8b 15 80 90 80 00    	mov    0x809080,%edx
  80343e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803441:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803446:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80344d:	83 ec 0c             	sub    $0xc,%esp
  803450:	ff 75 f4             	pushl  -0xc(%ebp)
  803453:	e8 c7 f4 ff ff       	call   80291f <fd2num>
  803458:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80345b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80345d:	83 c4 04             	add    $0x4,%esp
  803460:	ff 75 f0             	pushl  -0x10(%ebp)
  803463:	e8 b7 f4 ff ff       	call   80291f <fd2num>
  803468:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80346b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80346e:	83 c4 10             	add    $0x10,%esp
  803471:	ba 00 00 00 00       	mov    $0x0,%edx
  803476:	eb 30                	jmp    8034a8 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  803478:	83 ec 08             	sub    $0x8,%esp
  80347b:	56                   	push   %esi
  80347c:	6a 00                	push   $0x0
  80347e:	e8 3e f2 ff ff       	call   8026c1 <sys_page_unmap>
  803483:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  803486:	83 ec 08             	sub    $0x8,%esp
  803489:	ff 75 f0             	pushl  -0x10(%ebp)
  80348c:	6a 00                	push   $0x0
  80348e:	e8 2e f2 ff ff       	call   8026c1 <sys_page_unmap>
  803493:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  803496:	83 ec 08             	sub    $0x8,%esp
  803499:	ff 75 f4             	pushl  -0xc(%ebp)
  80349c:	6a 00                	push   $0x0
  80349e:	e8 1e f2 ff ff       	call   8026c1 <sys_page_unmap>
  8034a3:	83 c4 10             	add    $0x10,%esp
  8034a6:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  8034a8:	89 d0                	mov    %edx,%eax
  8034aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034ad:	5b                   	pop    %ebx
  8034ae:	5e                   	pop    %esi
  8034af:	5d                   	pop    %ebp
  8034b0:	c3                   	ret    

008034b1 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8034b1:	55                   	push   %ebp
  8034b2:	89 e5                	mov    %esp,%ebp
  8034b4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8034ba:	50                   	push   %eax
  8034bb:	ff 75 08             	pushl  0x8(%ebp)
  8034be:	e8 d3 f4 ff ff       	call   802996 <fd_lookup>
  8034c3:	83 c4 10             	add    $0x10,%esp
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	78 18                	js     8034e2 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8034ca:	83 ec 0c             	sub    $0xc,%esp
  8034cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8034d0:	e8 5a f4 ff ff       	call   80292f <fd2data>
	return _pipeisclosed(fd, p);
  8034d5:	89 c2                	mov    %eax,%edx
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	e8 21 fd ff ff       	call   803200 <_pipeisclosed>
  8034df:	83 c4 10             	add    $0x10,%esp
}
  8034e2:	c9                   	leave  
  8034e3:	c3                   	ret    

008034e4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8034e4:	55                   	push   %ebp
  8034e5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8034e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ec:	5d                   	pop    %ebp
  8034ed:	c3                   	ret    

008034ee <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8034ee:	55                   	push   %ebp
  8034ef:	89 e5                	mov    %esp,%ebp
  8034f1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8034f4:	68 31 43 80 00       	push   $0x804331
  8034f9:	ff 75 0c             	pushl  0xc(%ebp)
  8034fc:	e8 2d ed ff ff       	call   80222e <strcpy>
	return 0;
}
  803501:	b8 00 00 00 00       	mov    $0x0,%eax
  803506:	c9                   	leave  
  803507:	c3                   	ret    

00803508 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803508:	55                   	push   %ebp
  803509:	89 e5                	mov    %esp,%ebp
  80350b:	57                   	push   %edi
  80350c:	56                   	push   %esi
  80350d:	53                   	push   %ebx
  80350e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803514:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803519:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80351f:	eb 2d                	jmp    80354e <devcons_write+0x46>
		m = n - tot;
  803521:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803524:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  803526:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803529:	ba 7f 00 00 00       	mov    $0x7f,%edx
  80352e:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803531:	83 ec 04             	sub    $0x4,%esp
  803534:	53                   	push   %ebx
  803535:	03 45 0c             	add    0xc(%ebp),%eax
  803538:	50                   	push   %eax
  803539:	57                   	push   %edi
  80353a:	e8 82 ee ff ff       	call   8023c1 <memmove>
		sys_cputs(buf, m);
  80353f:	83 c4 08             	add    $0x8,%esp
  803542:	53                   	push   %ebx
  803543:	57                   	push   %edi
  803544:	e8 77 f0 ff ff       	call   8025c0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803549:	01 de                	add    %ebx,%esi
  80354b:	83 c4 10             	add    $0x10,%esp
  80354e:	89 f0                	mov    %esi,%eax
  803550:	3b 75 10             	cmp    0x10(%ebp),%esi
  803553:	72 cc                	jb     803521 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803555:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803558:	5b                   	pop    %ebx
  803559:	5e                   	pop    %esi
  80355a:	5f                   	pop    %edi
  80355b:	5d                   	pop    %ebp
  80355c:	c3                   	ret    

0080355d <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80355d:	55                   	push   %ebp
  80355e:	89 e5                	mov    %esp,%ebp
  803560:	83 ec 08             	sub    $0x8,%esp
  803563:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  803568:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80356c:	74 2a                	je     803598 <devcons_read+0x3b>
  80356e:	eb 05                	jmp    803575 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803570:	e8 db f0 ff ff       	call   802650 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803575:	e8 6c f0 ff ff       	call   8025e6 <sys_cgetc>
  80357a:	85 c0                	test   %eax,%eax
  80357c:	74 f2                	je     803570 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  80357e:	85 c0                	test   %eax,%eax
  803580:	78 16                	js     803598 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803582:	83 f8 04             	cmp    $0x4,%eax
  803585:	74 0c                	je     803593 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  803587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358a:	88 02                	mov    %al,(%edx)
	return 1;
  80358c:	b8 01 00 00 00       	mov    $0x1,%eax
  803591:	eb 05                	jmp    803598 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803593:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803598:	c9                   	leave  
  803599:	c3                   	ret    

0080359a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80359a:	55                   	push   %ebp
  80359b:	89 e5                	mov    %esp,%ebp
  80359d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8035a6:	6a 01                	push   $0x1
  8035a8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8035ab:	50                   	push   %eax
  8035ac:	e8 0f f0 ff ff       	call   8025c0 <sys_cputs>
}
  8035b1:	83 c4 10             	add    $0x10,%esp
  8035b4:	c9                   	leave  
  8035b5:	c3                   	ret    

008035b6 <getchar>:

int
getchar(void)
{
  8035b6:	55                   	push   %ebp
  8035b7:	89 e5                	mov    %esp,%ebp
  8035b9:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8035bc:	6a 01                	push   $0x1
  8035be:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8035c1:	50                   	push   %eax
  8035c2:	6a 00                	push   $0x0
  8035c4:	e8 32 f6 ff ff       	call   802bfb <read>
	if (r < 0)
  8035c9:	83 c4 10             	add    $0x10,%esp
  8035cc:	85 c0                	test   %eax,%eax
  8035ce:	78 0f                	js     8035df <getchar+0x29>
		return r;
	if (r < 1)
  8035d0:	85 c0                	test   %eax,%eax
  8035d2:	7e 06                	jle    8035da <getchar+0x24>
		return -E_EOF;
	return c;
  8035d4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8035d8:	eb 05                	jmp    8035df <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8035da:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8035df:	c9                   	leave  
  8035e0:	c3                   	ret    

008035e1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8035e1:	55                   	push   %ebp
  8035e2:	89 e5                	mov    %esp,%ebp
  8035e4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035ea:	50                   	push   %eax
  8035eb:	ff 75 08             	pushl  0x8(%ebp)
  8035ee:	e8 a3 f3 ff ff       	call   802996 <fd_lookup>
  8035f3:	83 c4 10             	add    $0x10,%esp
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	78 11                	js     80360b <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803603:	39 10                	cmp    %edx,(%eax)
  803605:	0f 94 c0             	sete   %al
  803608:	0f b6 c0             	movzbl %al,%eax
}
  80360b:	c9                   	leave  
  80360c:	c3                   	ret    

0080360d <opencons>:

int
opencons(void)
{
  80360d:	55                   	push   %ebp
  80360e:	89 e5                	mov    %esp,%ebp
  803610:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803613:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803616:	50                   	push   %eax
  803617:	e8 2b f3 ff ff       	call   802947 <fd_alloc>
  80361c:	83 c4 10             	add    $0x10,%esp
		return r;
  80361f:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803621:	85 c0                	test   %eax,%eax
  803623:	78 3e                	js     803663 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	68 07 04 00 00       	push   $0x407
  80362d:	ff 75 f4             	pushl  -0xc(%ebp)
  803630:	6a 00                	push   $0x0
  803632:	e8 40 f0 ff ff       	call   802677 <sys_page_alloc>
  803637:	83 c4 10             	add    $0x10,%esp
		return r;
  80363a:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80363c:	85 c0                	test   %eax,%eax
  80363e:	78 23                	js     803663 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803640:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803655:	83 ec 0c             	sub    $0xc,%esp
  803658:	50                   	push   %eax
  803659:	e8 c1 f2 ff ff       	call   80291f <fd2num>
  80365e:	89 c2                	mov    %eax,%edx
  803660:	83 c4 10             	add    $0x10,%esp
}
  803663:	89 d0                	mov    %edx,%eax
  803665:	c9                   	leave  
  803666:	c3                   	ret    
  803667:	66 90                	xchg   %ax,%ax
  803669:	66 90                	xchg   %ax,%ax
  80366b:	66 90                	xchg   %ax,%ax
  80366d:	66 90                	xchg   %ax,%ax
  80366f:	90                   	nop

00803670 <__udivdi3>:
  803670:	55                   	push   %ebp
  803671:	57                   	push   %edi
  803672:	56                   	push   %esi
  803673:	53                   	push   %ebx
  803674:	83 ec 1c             	sub    $0x1c,%esp
  803677:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80367b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80367f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803683:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803687:	85 f6                	test   %esi,%esi
  803689:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80368d:	89 ca                	mov    %ecx,%edx
  80368f:	89 f8                	mov    %edi,%eax
  803691:	75 3d                	jne    8036d0 <__udivdi3+0x60>
  803693:	39 cf                	cmp    %ecx,%edi
  803695:	0f 87 c5 00 00 00    	ja     803760 <__udivdi3+0xf0>
  80369b:	85 ff                	test   %edi,%edi
  80369d:	89 fd                	mov    %edi,%ebp
  80369f:	75 0b                	jne    8036ac <__udivdi3+0x3c>
  8036a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8036a6:	31 d2                	xor    %edx,%edx
  8036a8:	f7 f7                	div    %edi
  8036aa:	89 c5                	mov    %eax,%ebp
  8036ac:	89 c8                	mov    %ecx,%eax
  8036ae:	31 d2                	xor    %edx,%edx
  8036b0:	f7 f5                	div    %ebp
  8036b2:	89 c1                	mov    %eax,%ecx
  8036b4:	89 d8                	mov    %ebx,%eax
  8036b6:	89 cf                	mov    %ecx,%edi
  8036b8:	f7 f5                	div    %ebp
  8036ba:	89 c3                	mov    %eax,%ebx
  8036bc:	89 d8                	mov    %ebx,%eax
  8036be:	89 fa                	mov    %edi,%edx
  8036c0:	83 c4 1c             	add    $0x1c,%esp
  8036c3:	5b                   	pop    %ebx
  8036c4:	5e                   	pop    %esi
  8036c5:	5f                   	pop    %edi
  8036c6:	5d                   	pop    %ebp
  8036c7:	c3                   	ret    
  8036c8:	90                   	nop
  8036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8036d0:	39 ce                	cmp    %ecx,%esi
  8036d2:	77 74                	ja     803748 <__udivdi3+0xd8>
  8036d4:	0f bd fe             	bsr    %esi,%edi
  8036d7:	83 f7 1f             	xor    $0x1f,%edi
  8036da:	0f 84 98 00 00 00    	je     803778 <__udivdi3+0x108>
  8036e0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8036e5:	89 f9                	mov    %edi,%ecx
  8036e7:	89 c5                	mov    %eax,%ebp
  8036e9:	29 fb                	sub    %edi,%ebx
  8036eb:	d3 e6                	shl    %cl,%esi
  8036ed:	89 d9                	mov    %ebx,%ecx
  8036ef:	d3 ed                	shr    %cl,%ebp
  8036f1:	89 f9                	mov    %edi,%ecx
  8036f3:	d3 e0                	shl    %cl,%eax
  8036f5:	09 ee                	or     %ebp,%esi
  8036f7:	89 d9                	mov    %ebx,%ecx
  8036f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036fd:	89 d5                	mov    %edx,%ebp
  8036ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803703:	d3 ed                	shr    %cl,%ebp
  803705:	89 f9                	mov    %edi,%ecx
  803707:	d3 e2                	shl    %cl,%edx
  803709:	89 d9                	mov    %ebx,%ecx
  80370b:	d3 e8                	shr    %cl,%eax
  80370d:	09 c2                	or     %eax,%edx
  80370f:	89 d0                	mov    %edx,%eax
  803711:	89 ea                	mov    %ebp,%edx
  803713:	f7 f6                	div    %esi
  803715:	89 d5                	mov    %edx,%ebp
  803717:	89 c3                	mov    %eax,%ebx
  803719:	f7 64 24 0c          	mull   0xc(%esp)
  80371d:	39 d5                	cmp    %edx,%ebp
  80371f:	72 10                	jb     803731 <__udivdi3+0xc1>
  803721:	8b 74 24 08          	mov    0x8(%esp),%esi
  803725:	89 f9                	mov    %edi,%ecx
  803727:	d3 e6                	shl    %cl,%esi
  803729:	39 c6                	cmp    %eax,%esi
  80372b:	73 07                	jae    803734 <__udivdi3+0xc4>
  80372d:	39 d5                	cmp    %edx,%ebp
  80372f:	75 03                	jne    803734 <__udivdi3+0xc4>
  803731:	83 eb 01             	sub    $0x1,%ebx
  803734:	31 ff                	xor    %edi,%edi
  803736:	89 d8                	mov    %ebx,%eax
  803738:	89 fa                	mov    %edi,%edx
  80373a:	83 c4 1c             	add    $0x1c,%esp
  80373d:	5b                   	pop    %ebx
  80373e:	5e                   	pop    %esi
  80373f:	5f                   	pop    %edi
  803740:	5d                   	pop    %ebp
  803741:	c3                   	ret    
  803742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803748:	31 ff                	xor    %edi,%edi
  80374a:	31 db                	xor    %ebx,%ebx
  80374c:	89 d8                	mov    %ebx,%eax
  80374e:	89 fa                	mov    %edi,%edx
  803750:	83 c4 1c             	add    $0x1c,%esp
  803753:	5b                   	pop    %ebx
  803754:	5e                   	pop    %esi
  803755:	5f                   	pop    %edi
  803756:	5d                   	pop    %ebp
  803757:	c3                   	ret    
  803758:	90                   	nop
  803759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803760:	89 d8                	mov    %ebx,%eax
  803762:	f7 f7                	div    %edi
  803764:	31 ff                	xor    %edi,%edi
  803766:	89 c3                	mov    %eax,%ebx
  803768:	89 d8                	mov    %ebx,%eax
  80376a:	89 fa                	mov    %edi,%edx
  80376c:	83 c4 1c             	add    $0x1c,%esp
  80376f:	5b                   	pop    %ebx
  803770:	5e                   	pop    %esi
  803771:	5f                   	pop    %edi
  803772:	5d                   	pop    %ebp
  803773:	c3                   	ret    
  803774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803778:	39 ce                	cmp    %ecx,%esi
  80377a:	72 0c                	jb     803788 <__udivdi3+0x118>
  80377c:	31 db                	xor    %ebx,%ebx
  80377e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803782:	0f 87 34 ff ff ff    	ja     8036bc <__udivdi3+0x4c>
  803788:	bb 01 00 00 00       	mov    $0x1,%ebx
  80378d:	e9 2a ff ff ff       	jmp    8036bc <__udivdi3+0x4c>
  803792:	66 90                	xchg   %ax,%ax
  803794:	66 90                	xchg   %ax,%ax
  803796:	66 90                	xchg   %ax,%ax
  803798:	66 90                	xchg   %ax,%ax
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	66 90                	xchg   %ax,%ax
  80379e:	66 90                	xchg   %ax,%ax

008037a0 <__umoddi3>:
  8037a0:	55                   	push   %ebp
  8037a1:	57                   	push   %edi
  8037a2:	56                   	push   %esi
  8037a3:	53                   	push   %ebx
  8037a4:	83 ec 1c             	sub    $0x1c,%esp
  8037a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8037ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037b7:	85 d2                	test   %edx,%edx
  8037b9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037c1:	89 f3                	mov    %esi,%ebx
  8037c3:	89 3c 24             	mov    %edi,(%esp)
  8037c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8037ca:	75 1c                	jne    8037e8 <__umoddi3+0x48>
  8037cc:	39 f7                	cmp    %esi,%edi
  8037ce:	76 50                	jbe    803820 <__umoddi3+0x80>
  8037d0:	89 c8                	mov    %ecx,%eax
  8037d2:	89 f2                	mov    %esi,%edx
  8037d4:	f7 f7                	div    %edi
  8037d6:	89 d0                	mov    %edx,%eax
  8037d8:	31 d2                	xor    %edx,%edx
  8037da:	83 c4 1c             	add    $0x1c,%esp
  8037dd:	5b                   	pop    %ebx
  8037de:	5e                   	pop    %esi
  8037df:	5f                   	pop    %edi
  8037e0:	5d                   	pop    %ebp
  8037e1:	c3                   	ret    
  8037e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8037e8:	39 f2                	cmp    %esi,%edx
  8037ea:	89 d0                	mov    %edx,%eax
  8037ec:	77 52                	ja     803840 <__umoddi3+0xa0>
  8037ee:	0f bd ea             	bsr    %edx,%ebp
  8037f1:	83 f5 1f             	xor    $0x1f,%ebp
  8037f4:	75 5a                	jne    803850 <__umoddi3+0xb0>
  8037f6:	3b 54 24 04          	cmp    0x4(%esp),%edx
  8037fa:	0f 82 e0 00 00 00    	jb     8038e0 <__umoddi3+0x140>
  803800:	39 0c 24             	cmp    %ecx,(%esp)
  803803:	0f 86 d7 00 00 00    	jbe    8038e0 <__umoddi3+0x140>
  803809:	8b 44 24 08          	mov    0x8(%esp),%eax
  80380d:	8b 54 24 04          	mov    0x4(%esp),%edx
  803811:	83 c4 1c             	add    $0x1c,%esp
  803814:	5b                   	pop    %ebx
  803815:	5e                   	pop    %esi
  803816:	5f                   	pop    %edi
  803817:	5d                   	pop    %ebp
  803818:	c3                   	ret    
  803819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803820:	85 ff                	test   %edi,%edi
  803822:	89 fd                	mov    %edi,%ebp
  803824:	75 0b                	jne    803831 <__umoddi3+0x91>
  803826:	b8 01 00 00 00       	mov    $0x1,%eax
  80382b:	31 d2                	xor    %edx,%edx
  80382d:	f7 f7                	div    %edi
  80382f:	89 c5                	mov    %eax,%ebp
  803831:	89 f0                	mov    %esi,%eax
  803833:	31 d2                	xor    %edx,%edx
  803835:	f7 f5                	div    %ebp
  803837:	89 c8                	mov    %ecx,%eax
  803839:	f7 f5                	div    %ebp
  80383b:	89 d0                	mov    %edx,%eax
  80383d:	eb 99                	jmp    8037d8 <__umoddi3+0x38>
  80383f:	90                   	nop
  803840:	89 c8                	mov    %ecx,%eax
  803842:	89 f2                	mov    %esi,%edx
  803844:	83 c4 1c             	add    $0x1c,%esp
  803847:	5b                   	pop    %ebx
  803848:	5e                   	pop    %esi
  803849:	5f                   	pop    %edi
  80384a:	5d                   	pop    %ebp
  80384b:	c3                   	ret    
  80384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803850:	8b 34 24             	mov    (%esp),%esi
  803853:	bf 20 00 00 00       	mov    $0x20,%edi
  803858:	89 e9                	mov    %ebp,%ecx
  80385a:	29 ef                	sub    %ebp,%edi
  80385c:	d3 e0                	shl    %cl,%eax
  80385e:	89 f9                	mov    %edi,%ecx
  803860:	89 f2                	mov    %esi,%edx
  803862:	d3 ea                	shr    %cl,%edx
  803864:	89 e9                	mov    %ebp,%ecx
  803866:	09 c2                	or     %eax,%edx
  803868:	89 d8                	mov    %ebx,%eax
  80386a:	89 14 24             	mov    %edx,(%esp)
  80386d:	89 f2                	mov    %esi,%edx
  80386f:	d3 e2                	shl    %cl,%edx
  803871:	89 f9                	mov    %edi,%ecx
  803873:	89 54 24 04          	mov    %edx,0x4(%esp)
  803877:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80387b:	d3 e8                	shr    %cl,%eax
  80387d:	89 e9                	mov    %ebp,%ecx
  80387f:	89 c6                	mov    %eax,%esi
  803881:	d3 e3                	shl    %cl,%ebx
  803883:	89 f9                	mov    %edi,%ecx
  803885:	89 d0                	mov    %edx,%eax
  803887:	d3 e8                	shr    %cl,%eax
  803889:	89 e9                	mov    %ebp,%ecx
  80388b:	09 d8                	or     %ebx,%eax
  80388d:	89 d3                	mov    %edx,%ebx
  80388f:	89 f2                	mov    %esi,%edx
  803891:	f7 34 24             	divl   (%esp)
  803894:	89 d6                	mov    %edx,%esi
  803896:	d3 e3                	shl    %cl,%ebx
  803898:	f7 64 24 04          	mull   0x4(%esp)
  80389c:	39 d6                	cmp    %edx,%esi
  80389e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038a2:	89 d1                	mov    %edx,%ecx
  8038a4:	89 c3                	mov    %eax,%ebx
  8038a6:	72 08                	jb     8038b0 <__umoddi3+0x110>
  8038a8:	75 11                	jne    8038bb <__umoddi3+0x11b>
  8038aa:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8038ae:	73 0b                	jae    8038bb <__umoddi3+0x11b>
  8038b0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8038b4:	1b 14 24             	sbb    (%esp),%edx
  8038b7:	89 d1                	mov    %edx,%ecx
  8038b9:	89 c3                	mov    %eax,%ebx
  8038bb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038bf:	29 da                	sub    %ebx,%edx
  8038c1:	19 ce                	sbb    %ecx,%esi
  8038c3:	89 f9                	mov    %edi,%ecx
  8038c5:	89 f0                	mov    %esi,%eax
  8038c7:	d3 e0                	shl    %cl,%eax
  8038c9:	89 e9                	mov    %ebp,%ecx
  8038cb:	d3 ea                	shr    %cl,%edx
  8038cd:	89 e9                	mov    %ebp,%ecx
  8038cf:	d3 ee                	shr    %cl,%esi
  8038d1:	09 d0                	or     %edx,%eax
  8038d3:	89 f2                	mov    %esi,%edx
  8038d5:	83 c4 1c             	add    $0x1c,%esp
  8038d8:	5b                   	pop    %ebx
  8038d9:	5e                   	pop    %esi
  8038da:	5f                   	pop    %edi
  8038db:	5d                   	pop    %ebp
  8038dc:	c3                   	ret    
  8038dd:	8d 76 00             	lea    0x0(%esi),%esi
  8038e0:	29 f9                	sub    %edi,%ecx
  8038e2:	19 d6                	sbb    %edx,%esi
  8038e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8038e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038ec:	e9 18 ff ff ff       	jmp    803809 <__umoddi3+0x69>
