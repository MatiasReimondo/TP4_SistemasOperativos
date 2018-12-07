
obj/user/testfile.debug:     formato del fichero elf32-i386


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
  80002c:	e8 f7 05 00 00       	call   800628 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 90 0c 00 00       	call   800cd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 a3 12 00 00       	call   8012fc <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 40 12 00 00       	call   8012a8 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 c4 11 00 00       	call   80123d <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 20 23 80 00       	mov    $0x802320,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 1b                	je     8000b9 <umain+0x3b>
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	c1 ea 1f             	shr    $0x1f,%edx
  8000a3:	84 d2                	test   %dl,%dl
  8000a5:	74 12                	je     8000b9 <umain+0x3b>
		panic("serve_open /not-found: %e", r);
  8000a7:	50                   	push   %eax
  8000a8:	68 2b 23 80 00       	push   $0x80232b
  8000ad:	6a 20                	push   $0x20
  8000af:	68 45 23 80 00       	push   $0x802345
  8000b4:	e8 d3 05 00 00       	call   80068c <_panic>
	else if (r >= 0)
  8000b9:	85 c0                	test   %eax,%eax
  8000bb:	78 14                	js     8000d1 <umain+0x53>
		panic("serve_open /not-found succeeded!");
  8000bd:	83 ec 04             	sub    $0x4,%esp
  8000c0:	68 e0 24 80 00       	push   $0x8024e0
  8000c5:	6a 22                	push   $0x22
  8000c7:	68 45 23 80 00       	push   $0x802345
  8000cc:	e8 bb 05 00 00       	call   80068c <_panic>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d6:	b8 55 23 80 00       	mov    $0x802355,%eax
  8000db:	e8 53 ff ff ff       	call   800033 <xopen>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	79 12                	jns    8000f6 <umain+0x78>
		panic("serve_open /newmotd: %e", r);
  8000e4:	50                   	push   %eax
  8000e5:	68 5e 23 80 00       	push   $0x80235e
  8000ea:	6a 25                	push   $0x25
  8000ec:	68 45 23 80 00       	push   $0x802345
  8000f1:	e8 96 05 00 00       	call   80068c <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000f6:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000fd:	75 12                	jne    800111 <umain+0x93>
  8000ff:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800106:	75 09                	jne    800111 <umain+0x93>
  800108:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80010f:	74 14                	je     800125 <umain+0xa7>
		panic("serve_open did not fill struct Fd correctly\n");
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	68 04 25 80 00       	push   $0x802504
  800119:	6a 27                	push   $0x27
  80011b:	68 45 23 80 00       	push   $0x802345
  800120:	e8 67 05 00 00       	call   80068c <_panic>
	cprintf("serve_open is good\n");
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	68 76 23 80 00       	push   $0x802376
  80012d:	e8 33 06 00 00       	call   800765 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800132:	83 c4 08             	add    $0x8,%esp
  800135:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80013b:	50                   	push   %eax
  80013c:	68 00 c0 cc cc       	push   $0xccccc000
  800141:	ff 15 1c 30 80 00    	call   *0x80301c
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	85 c0                	test   %eax,%eax
  80014c:	79 12                	jns    800160 <umain+0xe2>
		panic("file_stat: %e", r);
  80014e:	50                   	push   %eax
  80014f:	68 8a 23 80 00       	push   $0x80238a
  800154:	6a 2b                	push   $0x2b
  800156:	68 45 23 80 00       	push   $0x802345
  80015b:	e8 2c 05 00 00       	call   80068c <_panic>
	if (strlen(msg) != st.st_size)
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 35 00 30 80 00    	pushl  0x803000
  800169:	e8 30 0b 00 00       	call   800c9e <strlen>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800174:	74 25                	je     80019b <umain+0x11d>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	ff 35 00 30 80 00    	pushl  0x803000
  80017f:	e8 1a 0b 00 00       	call   800c9e <strlen>
  800184:	89 04 24             	mov    %eax,(%esp)
  800187:	ff 75 cc             	pushl  -0x34(%ebp)
  80018a:	68 34 25 80 00       	push   $0x802534
  80018f:	6a 2d                	push   $0x2d
  800191:	68 45 23 80 00       	push   $0x802345
  800196:	e8 f1 04 00 00       	call   80068c <_panic>
	cprintf("file_stat is good\n");
  80019b:	83 ec 0c             	sub    $0xc,%esp
  80019e:	68 98 23 80 00       	push   $0x802398
  8001a3:	e8 bd 05 00 00       	call   800765 <cprintf>

	memset(buf, 0, sizeof buf);
  8001a8:	83 c4 0c             	add    $0xc,%esp
  8001ab:	68 00 02 00 00       	push   $0x200
  8001b0:	6a 00                	push   $0x0
  8001b2:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8001b8:	53                   	push   %ebx
  8001b9:	e8 5e 0c 00 00       	call   800e1c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8001be:	83 c4 0c             	add    $0xc,%esp
  8001c1:	68 00 02 00 00       	push   $0x200
  8001c6:	53                   	push   %ebx
  8001c7:	68 00 c0 cc cc       	push   $0xccccc000
  8001cc:	ff 15 10 30 80 00    	call   *0x803010
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	79 12                	jns    8001eb <umain+0x16d>
		panic("file_read: %e", r);
  8001d9:	50                   	push   %eax
  8001da:	68 ab 23 80 00       	push   $0x8023ab
  8001df:	6a 32                	push   $0x32
  8001e1:	68 45 23 80 00       	push   $0x802345
  8001e6:	e8 a1 04 00 00       	call   80068c <_panic>
	if (strcmp(buf, msg) != 0)
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	ff 35 00 30 80 00    	pushl  0x803000
  8001f4:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8001fa:	50                   	push   %eax
  8001fb:	e8 81 0b 00 00       	call   800d81 <strcmp>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	85 c0                	test   %eax,%eax
  800205:	74 14                	je     80021b <umain+0x19d>
		panic("file_read returned wrong data");
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 b9 23 80 00       	push   $0x8023b9
  80020f:	6a 34                	push   $0x34
  800211:	68 45 23 80 00       	push   $0x802345
  800216:	e8 71 04 00 00       	call   80068c <_panic>
	cprintf("file_read is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 d7 23 80 00       	push   $0x8023d7
  800223:	e8 3d 05 00 00       	call   800765 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  800228:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  80022f:	ff 15 18 30 80 00    	call   *0x803018
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	85 c0                	test   %eax,%eax
  80023a:	79 12                	jns    80024e <umain+0x1d0>
		panic("file_close: %e", r);
  80023c:	50                   	push   %eax
  80023d:	68 ea 23 80 00       	push   $0x8023ea
  800242:	6a 38                	push   $0x38
  800244:	68 45 23 80 00       	push   $0x802345
  800249:	e8 3e 04 00 00       	call   80068c <_panic>
	cprintf("file_close is good\n");
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	68 f9 23 80 00       	push   $0x8023f9
  800256:	e8 0a 05 00 00       	call   800765 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  80025b:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  800260:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800263:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  800268:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80026b:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  800270:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800273:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  800278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  80027b:	83 c4 08             	add    $0x8,%esp
  80027e:	68 00 c0 cc cc       	push   $0xccccc000
  800283:	6a 00                	push   $0x0
  800285:	e8 e0 0e 00 00       	call   80116a <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  80028a:	83 c4 0c             	add    $0xc,%esp
  80028d:	68 00 02 00 00       	push   $0x200
  800292:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800298:	50                   	push   %eax
  800299:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80029c:	50                   	push   %eax
  80029d:	ff 15 10 30 80 00    	call   *0x803010
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8002a9:	74 12                	je     8002bd <umain+0x23f>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8002ab:	50                   	push   %eax
  8002ac:	68 5c 25 80 00       	push   $0x80255c
  8002b1:	6a 43                	push   $0x43
  8002b3:	68 45 23 80 00       	push   $0x802345
  8002b8:	e8 cf 03 00 00       	call   80068c <_panic>
	cprintf("stale fileid is good\n");
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	68 0d 24 80 00       	push   $0x80240d
  8002c5:	e8 9b 04 00 00       	call   800765 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  8002ca:	ba 02 01 00 00       	mov    $0x102,%edx
  8002cf:	b8 23 24 80 00       	mov    $0x802423,%eax
  8002d4:	e8 5a fd ff ff       	call   800033 <xopen>
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	79 12                	jns    8002f2 <umain+0x274>
		panic("serve_open /new-file: %e", r);
  8002e0:	50                   	push   %eax
  8002e1:	68 2d 24 80 00       	push   $0x80242d
  8002e6:	6a 48                	push   $0x48
  8002e8:	68 45 23 80 00       	push   $0x802345
  8002ed:	e8 9a 03 00 00       	call   80068c <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  8002f2:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	ff 35 00 30 80 00    	pushl  0x803000
  800301:	e8 98 09 00 00       	call   800c9e <strlen>
  800306:	83 c4 0c             	add    $0xc,%esp
  800309:	50                   	push   %eax
  80030a:	ff 35 00 30 80 00    	pushl  0x803000
  800310:	68 00 c0 cc cc       	push   $0xccccc000
  800315:	ff d3                	call   *%ebx
  800317:	89 c3                	mov    %eax,%ebx
  800319:	83 c4 04             	add    $0x4,%esp
  80031c:	ff 35 00 30 80 00    	pushl  0x803000
  800322:	e8 77 09 00 00       	call   800c9e <strlen>
  800327:	83 c4 10             	add    $0x10,%esp
  80032a:	39 c3                	cmp    %eax,%ebx
  80032c:	74 12                	je     800340 <umain+0x2c2>
		panic("file_write: %e", r);
  80032e:	53                   	push   %ebx
  80032f:	68 46 24 80 00       	push   $0x802446
  800334:	6a 4b                	push   $0x4b
  800336:	68 45 23 80 00       	push   $0x802345
  80033b:	e8 4c 03 00 00       	call   80068c <_panic>
	cprintf("file_write is good\n");
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	68 55 24 80 00       	push   $0x802455
  800348:	e8 18 04 00 00       	call   800765 <cprintf>

	FVA->fd_offset = 0;
  80034d:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800354:	00 00 00 
	memset(buf, 0, sizeof buf);
  800357:	83 c4 0c             	add    $0xc,%esp
  80035a:	68 00 02 00 00       	push   $0x200
  80035f:	6a 00                	push   $0x0
  800361:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800367:	53                   	push   %ebx
  800368:	e8 af 0a 00 00       	call   800e1c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  80036d:	83 c4 0c             	add    $0xc,%esp
  800370:	68 00 02 00 00       	push   $0x200
  800375:	53                   	push   %ebx
  800376:	68 00 c0 cc cc       	push   $0xccccc000
  80037b:	ff 15 10 30 80 00    	call   *0x803010
  800381:	89 c3                	mov    %eax,%ebx
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	85 c0                	test   %eax,%eax
  800388:	79 12                	jns    80039c <umain+0x31e>
		panic("file_read after file_write: %e", r);
  80038a:	50                   	push   %eax
  80038b:	68 94 25 80 00       	push   $0x802594
  800390:	6a 51                	push   $0x51
  800392:	68 45 23 80 00       	push   $0x802345
  800397:	e8 f0 02 00 00       	call   80068c <_panic>
	if (r != strlen(msg))
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	ff 35 00 30 80 00    	pushl  0x803000
  8003a5:	e8 f4 08 00 00       	call   800c9e <strlen>
  8003aa:	83 c4 10             	add    $0x10,%esp
  8003ad:	39 c3                	cmp    %eax,%ebx
  8003af:	74 12                	je     8003c3 <umain+0x345>
		panic("file_read after file_write returned wrong length: %d", r);
  8003b1:	53                   	push   %ebx
  8003b2:	68 b4 25 80 00       	push   $0x8025b4
  8003b7:	6a 53                	push   $0x53
  8003b9:	68 45 23 80 00       	push   $0x802345
  8003be:	e8 c9 02 00 00       	call   80068c <_panic>
	if (strcmp(buf, msg) != 0)
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	ff 35 00 30 80 00    	pushl  0x803000
  8003cc:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003d2:	50                   	push   %eax
  8003d3:	e8 a9 09 00 00       	call   800d81 <strcmp>
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	85 c0                	test   %eax,%eax
  8003dd:	74 14                	je     8003f3 <umain+0x375>
		panic("file_read after file_write returned wrong data");
  8003df:	83 ec 04             	sub    $0x4,%esp
  8003e2:	68 ec 25 80 00       	push   $0x8025ec
  8003e7:	6a 55                	push   $0x55
  8003e9:	68 45 23 80 00       	push   $0x802345
  8003ee:	e8 99 02 00 00       	call   80068c <_panic>
	cprintf("file_read after file_write is good\n");
  8003f3:	83 ec 0c             	sub    $0xc,%esp
  8003f6:	68 1c 26 80 00       	push   $0x80261c
  8003fb:	e8 65 03 00 00       	call   800765 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800400:	83 c4 08             	add    $0x8,%esp
  800403:	6a 00                	push   $0x0
  800405:	68 20 23 80 00       	push   $0x802320
  80040a:	e8 b0 16 00 00       	call   801abf <open>
  80040f:	83 c4 10             	add    $0x10,%esp
  800412:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800415:	74 1b                	je     800432 <umain+0x3b4>
  800417:	89 c2                	mov    %eax,%edx
  800419:	c1 ea 1f             	shr    $0x1f,%edx
  80041c:	84 d2                	test   %dl,%dl
  80041e:	74 12                	je     800432 <umain+0x3b4>
		panic("open /not-found: %e", r);
  800420:	50                   	push   %eax
  800421:	68 31 23 80 00       	push   $0x802331
  800426:	6a 5a                	push   $0x5a
  800428:	68 45 23 80 00       	push   $0x802345
  80042d:	e8 5a 02 00 00       	call   80068c <_panic>
	else if (r >= 0)
  800432:	85 c0                	test   %eax,%eax
  800434:	78 14                	js     80044a <umain+0x3cc>
		panic("open /not-found succeeded!");
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	68 69 24 80 00       	push   $0x802469
  80043e:	6a 5c                	push   $0x5c
  800440:	68 45 23 80 00       	push   $0x802345
  800445:	e8 42 02 00 00       	call   80068c <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80044a:	83 ec 08             	sub    $0x8,%esp
  80044d:	6a 00                	push   $0x0
  80044f:	68 55 23 80 00       	push   $0x802355
  800454:	e8 66 16 00 00       	call   801abf <open>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	85 c0                	test   %eax,%eax
  80045e:	79 12                	jns    800472 <umain+0x3f4>
		panic("open /newmotd: %e", r);
  800460:	50                   	push   %eax
  800461:	68 64 23 80 00       	push   $0x802364
  800466:	6a 5f                	push   $0x5f
  800468:	68 45 23 80 00       	push   $0x802345
  80046d:	e8 1a 02 00 00       	call   80068c <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800472:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800475:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  80047c:	75 12                	jne    800490 <umain+0x412>
  80047e:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  800485:	75 09                	jne    800490 <umain+0x412>
  800487:	83 b8 08 00 00 d0 00 	cmpl   $0x0,-0x2ffffff8(%eax)
  80048e:	74 14                	je     8004a4 <umain+0x426>
		panic("open did not fill struct Fd correctly\n");
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 40 26 80 00       	push   $0x802640
  800498:	6a 62                	push   $0x62
  80049a:	68 45 23 80 00       	push   $0x802345
  80049f:	e8 e8 01 00 00       	call   80068c <_panic>
	cprintf("open is good\n");
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	68 7c 23 80 00       	push   $0x80237c
  8004ac:	e8 b4 02 00 00       	call   800765 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8004b1:	83 c4 08             	add    $0x8,%esp
  8004b4:	68 01 01 00 00       	push   $0x101
  8004b9:	68 84 24 80 00       	push   $0x802484
  8004be:	e8 fc 15 00 00       	call   801abf <open>
  8004c3:	89 c6                	mov    %eax,%esi
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	79 12                	jns    8004de <umain+0x460>
		panic("creat /big: %e", f);
  8004cc:	50                   	push   %eax
  8004cd:	68 89 24 80 00       	push   $0x802489
  8004d2:	6a 67                	push   $0x67
  8004d4:	68 45 23 80 00       	push   $0x802345
  8004d9:	e8 ae 01 00 00       	call   80068c <_panic>
	memset(buf, 0, sizeof(buf));
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 00 02 00 00       	push   $0x200
  8004e6:	6a 00                	push   $0x0
  8004e8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004ee:	50                   	push   %eax
  8004ef:	e8 28 09 00 00       	call   800e1c <memset>
  8004f4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8004f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8004fc:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  800502:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	68 00 02 00 00       	push   $0x200
  800510:	57                   	push   %edi
  800511:	56                   	push   %esi
  800512:	e8 d4 11 00 00       	call   8016eb <write>
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	85 c0                	test   %eax,%eax
  80051c:	79 16                	jns    800534 <umain+0x4b6>
			panic("write /big@%d: %e", i, r);
  80051e:	83 ec 0c             	sub    $0xc,%esp
  800521:	50                   	push   %eax
  800522:	53                   	push   %ebx
  800523:	68 98 24 80 00       	push   $0x802498
  800528:	6a 6c                	push   $0x6c
  80052a:	68 45 23 80 00       	push   $0x802345
  80052f:	e8 58 01 00 00       	call   80068c <_panic>
  800534:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  80053a:	89 c3                	mov    %eax,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80053c:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  800541:	75 bf                	jne    800502 <umain+0x484>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800543:	83 ec 0c             	sub    $0xc,%esp
  800546:	56                   	push   %esi
  800547:	e8 89 0f 00 00       	call   8014d5 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80054c:	83 c4 08             	add    $0x8,%esp
  80054f:	6a 00                	push   $0x0
  800551:	68 84 24 80 00       	push   $0x802484
  800556:	e8 64 15 00 00       	call   801abf <open>
  80055b:	89 c6                	mov    %eax,%esi
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	85 c0                	test   %eax,%eax
  800562:	79 12                	jns    800576 <umain+0x4f8>
		panic("open /big: %e", f);
  800564:	50                   	push   %eax
  800565:	68 aa 24 80 00       	push   $0x8024aa
  80056a:	6a 71                	push   $0x71
  80056c:	68 45 23 80 00       	push   $0x802345
  800571:	e8 16 01 00 00       	call   80068c <_panic>
  800576:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80057b:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  800581:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 00 02 00 00       	push   $0x200
  80058f:	57                   	push   %edi
  800590:	56                   	push   %esi
  800591:	e8 0c 11 00 00       	call   8016a2 <readn>
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	85 c0                	test   %eax,%eax
  80059b:	79 16                	jns    8005b3 <umain+0x535>
			panic("read /big@%d: %e", i, r);
  80059d:	83 ec 0c             	sub    $0xc,%esp
  8005a0:	50                   	push   %eax
  8005a1:	53                   	push   %ebx
  8005a2:	68 b8 24 80 00       	push   $0x8024b8
  8005a7:	6a 75                	push   $0x75
  8005a9:	68 45 23 80 00       	push   $0x802345
  8005ae:	e8 d9 00 00 00       	call   80068c <_panic>
		if (r != sizeof(buf))
  8005b3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8005b8:	74 1b                	je     8005d5 <umain+0x557>
			panic("read /big from %d returned %d < %d bytes",
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	68 00 02 00 00       	push   $0x200
  8005c2:	50                   	push   %eax
  8005c3:	53                   	push   %ebx
  8005c4:	68 68 26 80 00       	push   $0x802668
  8005c9:	6a 78                	push   $0x78
  8005cb:	68 45 23 80 00       	push   $0x802345
  8005d0:	e8 b7 00 00 00       	call   80068c <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  8005d5:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  8005db:	39 d8                	cmp    %ebx,%eax
  8005dd:	74 16                	je     8005f5 <umain+0x577>
			panic("read /big from %d returned bad data %d",
  8005df:	83 ec 0c             	sub    $0xc,%esp
  8005e2:	50                   	push   %eax
  8005e3:	53                   	push   %ebx
  8005e4:	68 94 26 80 00       	push   $0x802694
  8005e9:	6a 7b                	push   $0x7b
  8005eb:	68 45 23 80 00       	push   $0x802345
  8005f0:	e8 97 00 00 00       	call   80068c <_panic>
  8005f5:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  8005fb:	89 c3                	mov    %eax,%ebx
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8005fd:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  800602:	0f 85 79 ff ff ff    	jne    800581 <umain+0x503>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800608:	83 ec 0c             	sub    $0xc,%esp
  80060b:	56                   	push   %esi
  80060c:	e8 c4 0e 00 00       	call   8014d5 <close>
	cprintf("large file is good\n");
  800611:	c7 04 24 c9 24 80 00 	movl   $0x8024c9,(%esp)
  800618:	e8 48 01 00 00       	call   800765 <cprintf>
}
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800623:	5b                   	pop    %ebx
  800624:	5e                   	pop    %esi
  800625:	5f                   	pop    %edi
  800626:	5d                   	pop    %ebp
  800627:	c3                   	ret    

00800628 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	56                   	push   %esi
  80062c:	53                   	push   %ebx
  80062d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800630:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  800633:	e8 9d 0a 00 00       	call   8010d5 <sys_getenvid>
	if (id >= 0)
  800638:	85 c0                	test   %eax,%eax
  80063a:	78 12                	js     80064e <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  80063c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800641:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800644:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800649:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80064e:	85 db                	test   %ebx,%ebx
  800650:	7e 07                	jle    800659 <libmain+0x31>
		binaryname = argv[0];
  800652:	8b 06                	mov    (%esi),%eax
  800654:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	56                   	push   %esi
  80065d:	53                   	push   %ebx
  80065e:	e8 1b fa ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  800663:	e8 0a 00 00 00       	call   800672 <exit>
}
  800668:	83 c4 10             	add    $0x10,%esp
  80066b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80066e:	5b                   	pop    %ebx
  80066f:	5e                   	pop    %esi
  800670:	5d                   	pop    %ebp
  800671:	c3                   	ret    

00800672 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800678:	e8 83 0e 00 00       	call   801500 <close_all>
	sys_env_destroy(0);
  80067d:	83 ec 0c             	sub    $0xc,%esp
  800680:	6a 00                	push   $0x0
  800682:	e8 2c 0a 00 00       	call   8010b3 <sys_env_destroy>
}
  800687:	83 c4 10             	add    $0x10,%esp
  80068a:	c9                   	leave  
  80068b:	c3                   	ret    

0080068c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80068c:	55                   	push   %ebp
  80068d:	89 e5                	mov    %esp,%ebp
  80068f:	56                   	push   %esi
  800690:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800691:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800694:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80069a:	e8 36 0a 00 00       	call   8010d5 <sys_getenvid>
  80069f:	83 ec 0c             	sub    $0xc,%esp
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	ff 75 08             	pushl  0x8(%ebp)
  8006a8:	56                   	push   %esi
  8006a9:	50                   	push   %eax
  8006aa:	68 ec 26 80 00       	push   $0x8026ec
  8006af:	e8 b1 00 00 00       	call   800765 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006b4:	83 c4 18             	add    $0x18,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	ff 75 10             	pushl  0x10(%ebp)
  8006bb:	e8 54 00 00 00       	call   800714 <vcprintf>
	cprintf("\n");
  8006c0:	c7 04 24 47 2b 80 00 	movl   $0x802b47,(%esp)
  8006c7:	e8 99 00 00 00       	call   800765 <cprintf>
  8006cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006cf:	cc                   	int3   
  8006d0:	eb fd                	jmp    8006cf <_panic+0x43>

008006d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	53                   	push   %ebx
  8006d6:	83 ec 04             	sub    $0x4,%esp
  8006d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006dc:	8b 13                	mov    (%ebx),%edx
  8006de:	8d 42 01             	lea    0x1(%edx),%eax
  8006e1:	89 03                	mov    %eax,(%ebx)
  8006e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8006ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ef:	75 1a                	jne    80070b <putch+0x39>
		sys_cputs(b->buf, b->idx);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	68 ff 00 00 00       	push   $0xff
  8006f9:	8d 43 08             	lea    0x8(%ebx),%eax
  8006fc:	50                   	push   %eax
  8006fd:	e8 67 09 00 00       	call   801069 <sys_cputs>
		b->idx = 0;
  800702:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800708:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80070b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80070f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80071d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800724:	00 00 00 
	b.cnt = 0;
  800727:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80072e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	ff 75 08             	pushl  0x8(%ebp)
  800737:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073d:	50                   	push   %eax
  80073e:	68 d2 06 80 00       	push   $0x8006d2
  800743:	e8 86 01 00 00       	call   8008ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800748:	83 c4 08             	add    $0x8,%esp
  80074b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800751:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800757:	50                   	push   %eax
  800758:	e8 0c 09 00 00       	call   801069 <sys_cputs>

	return b.cnt;
}
  80075d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80076b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80076e:	50                   	push   %eax
  80076f:	ff 75 08             	pushl  0x8(%ebp)
  800772:	e8 9d ff ff ff       	call   800714 <vcprintf>
	va_end(ap);

	return cnt;
}
  800777:	c9                   	leave  
  800778:	c3                   	ret    

00800779 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	57                   	push   %edi
  80077d:	56                   	push   %esi
  80077e:	53                   	push   %ebx
  80077f:	83 ec 1c             	sub    $0x1c,%esp
  800782:	89 c7                	mov    %eax,%edi
  800784:	89 d6                	mov    %edx,%esi
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800792:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800795:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80079d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007a0:	39 d3                	cmp    %edx,%ebx
  8007a2:	72 05                	jb     8007a9 <printnum+0x30>
  8007a4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8007a7:	77 45                	ja     8007ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007a9:	83 ec 0c             	sub    $0xc,%esp
  8007ac:	ff 75 18             	pushl  0x18(%ebp)
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007b5:	53                   	push   %ebx
  8007b6:	ff 75 10             	pushl  0x10(%ebp)
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8007c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8007c8:	e8 b3 18 00 00       	call   802080 <__udivdi3>
  8007cd:	83 c4 18             	add    $0x18,%esp
  8007d0:	52                   	push   %edx
  8007d1:	50                   	push   %eax
  8007d2:	89 f2                	mov    %esi,%edx
  8007d4:	89 f8                	mov    %edi,%eax
  8007d6:	e8 9e ff ff ff       	call   800779 <printnum>
  8007db:	83 c4 20             	add    $0x20,%esp
  8007de:	eb 18                	jmp    8007f8 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	56                   	push   %esi
  8007e4:	ff 75 18             	pushl  0x18(%ebp)
  8007e7:	ff d7                	call   *%edi
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb 03                	jmp    8007f1 <printnum+0x78>
  8007ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007f1:	83 eb 01             	sub    $0x1,%ebx
  8007f4:	85 db                	test   %ebx,%ebx
  8007f6:	7f e8                	jg     8007e0 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	56                   	push   %esi
  8007fc:	83 ec 04             	sub    $0x4,%esp
  8007ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800802:	ff 75 e0             	pushl  -0x20(%ebp)
  800805:	ff 75 dc             	pushl  -0x24(%ebp)
  800808:	ff 75 d8             	pushl  -0x28(%ebp)
  80080b:	e8 a0 19 00 00       	call   8021b0 <__umoddi3>
  800810:	83 c4 14             	add    $0x14,%esp
  800813:	0f be 80 0f 27 80 00 	movsbl 0x80270f(%eax),%eax
  80081a:	50                   	push   %eax
  80081b:	ff d7                	call   *%edi
}
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800823:	5b                   	pop    %ebx
  800824:	5e                   	pop    %esi
  800825:	5f                   	pop    %edi
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082b:	83 fa 01             	cmp    $0x1,%edx
  80082e:	7e 0e                	jle    80083e <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800830:	8b 10                	mov    (%eax),%edx
  800832:	8d 4a 08             	lea    0x8(%edx),%ecx
  800835:	89 08                	mov    %ecx,(%eax)
  800837:	8b 02                	mov    (%edx),%eax
  800839:	8b 52 04             	mov    0x4(%edx),%edx
  80083c:	eb 22                	jmp    800860 <getuint+0x38>
	else if (lflag)
  80083e:	85 d2                	test   %edx,%edx
  800840:	74 10                	je     800852 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800842:	8b 10                	mov    (%eax),%edx
  800844:	8d 4a 04             	lea    0x4(%edx),%ecx
  800847:	89 08                	mov    %ecx,(%eax)
  800849:	8b 02                	mov    (%edx),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	eb 0e                	jmp    800860 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800852:	8b 10                	mov    (%eax),%edx
  800854:	8d 4a 04             	lea    0x4(%edx),%ecx
  800857:	89 08                	mov    %ecx,(%eax)
  800859:	8b 02                	mov    (%edx),%eax
  80085b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800865:	83 fa 01             	cmp    $0x1,%edx
  800868:	7e 0e                	jle    800878 <getint+0x16>
		return va_arg(*ap, long long);
  80086a:	8b 10                	mov    (%eax),%edx
  80086c:	8d 4a 08             	lea    0x8(%edx),%ecx
  80086f:	89 08                	mov    %ecx,(%eax)
  800871:	8b 02                	mov    (%edx),%eax
  800873:	8b 52 04             	mov    0x4(%edx),%edx
  800876:	eb 1a                	jmp    800892 <getint+0x30>
	else if (lflag)
  800878:	85 d2                	test   %edx,%edx
  80087a:	74 0c                	je     800888 <getint+0x26>
		return va_arg(*ap, long);
  80087c:	8b 10                	mov    (%eax),%edx
  80087e:	8d 4a 04             	lea    0x4(%edx),%ecx
  800881:	89 08                	mov    %ecx,(%eax)
  800883:	8b 02                	mov    (%edx),%eax
  800885:	99                   	cltd   
  800886:	eb 0a                	jmp    800892 <getint+0x30>
	else
		return va_arg(*ap, int);
  800888:	8b 10                	mov    (%eax),%edx
  80088a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80088d:	89 08                	mov    %ecx,(%eax)
  80088f:	8b 02                	mov    (%edx),%eax
  800891:	99                   	cltd   
}
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80089a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	3b 50 04             	cmp    0x4(%eax),%edx
  8008a3:	73 0a                	jae    8008af <sprintputch+0x1b>
		*b->buf++ = ch;
  8008a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008a8:	89 08                	mov    %ecx,(%eax)
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	88 02                	mov    %al,(%edx)
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8008b7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008ba:	50                   	push   %eax
  8008bb:	ff 75 10             	pushl  0x10(%ebp)
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	ff 75 08             	pushl  0x8(%ebp)
  8008c4:	e8 05 00 00 00       	call   8008ce <vprintfmt>
	va_end(ap);
}
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	57                   	push   %edi
  8008d2:	56                   	push   %esi
  8008d3:	53                   	push   %ebx
  8008d4:	83 ec 2c             	sub    $0x2c,%esp
  8008d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008dd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008e0:	eb 12                	jmp    8008f4 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	0f 84 44 03 00 00    	je     800c2e <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	53                   	push   %ebx
  8008ee:	50                   	push   %eax
  8008ef:	ff d6                	call   *%esi
  8008f1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f4:	83 c7 01             	add    $0x1,%edi
  8008f7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008fb:	83 f8 25             	cmp    $0x25,%eax
  8008fe:	75 e2                	jne    8008e2 <vprintfmt+0x14>
  800900:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800904:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80090b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800912:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
  80091e:	eb 07                	jmp    800927 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800920:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  800923:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800927:	8d 47 01             	lea    0x1(%edi),%eax
  80092a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092d:	0f b6 07             	movzbl (%edi),%eax
  800930:	0f b6 c8             	movzbl %al,%ecx
  800933:	83 e8 23             	sub    $0x23,%eax
  800936:	3c 55                	cmp    $0x55,%al
  800938:	0f 87 d5 02 00 00    	ja     800c13 <vprintfmt+0x345>
  80093e:	0f b6 c0             	movzbl %al,%eax
  800941:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
  800948:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80094b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80094f:	eb d6                	jmp    800927 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800951:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
  800959:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80095c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80095f:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  800963:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800966:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800969:	83 fa 09             	cmp    $0x9,%edx
  80096c:	77 39                	ja     8009a7 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800971:	eb e9                	jmp    80095c <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8d 48 04             	lea    0x4(%eax),%ecx
  800979:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800981:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800984:	eb 27                	jmp    8009ad <vprintfmt+0xdf>
  800986:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800989:	85 c0                	test   %eax,%eax
  80098b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800990:	0f 49 c8             	cmovns %eax,%ecx
  800993:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800996:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800999:	eb 8c                	jmp    800927 <vprintfmt+0x59>
  80099b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80099e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8009a5:	eb 80                	jmp    800927 <vprintfmt+0x59>
  8009a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009aa:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  8009ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b1:	0f 89 70 ff ff ff    	jns    800927 <vprintfmt+0x59>
				width = precision, precision = -1;
  8009b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009bd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8009c4:	e9 5e ff ff ff       	jmp    800927 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c9:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8009cf:	e9 53 ff ff ff       	jmp    800927 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8d 50 04             	lea    0x4(%eax),%edx
  8009da:	89 55 14             	mov    %edx,0x14(%ebp)
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	53                   	push   %ebx
  8009e1:	ff 30                	pushl  (%eax)
  8009e3:	ff d6                	call   *%esi
			break;
  8009e5:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8009eb:	e9 04 ff ff ff       	jmp    8008f4 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	8d 50 04             	lea    0x4(%eax),%edx
  8009f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	99                   	cltd   
  8009fc:	31 d0                	xor    %edx,%eax
  8009fe:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a00:	83 f8 0f             	cmp    $0xf,%eax
  800a03:	7f 0b                	jg     800a10 <vprintfmt+0x142>
  800a05:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800a0c:	85 d2                	test   %edx,%edx
  800a0e:	75 18                	jne    800a28 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  800a10:	50                   	push   %eax
  800a11:	68 27 27 80 00       	push   $0x802727
  800a16:	53                   	push   %ebx
  800a17:	56                   	push   %esi
  800a18:	e8 94 fe ff ff       	call   8008b1 <printfmt>
  800a1d:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a20:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800a23:	e9 cc fe ff ff       	jmp    8008f4 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800a28:	52                   	push   %edx
  800a29:	68 15 2b 80 00       	push   $0x802b15
  800a2e:	53                   	push   %ebx
  800a2f:	56                   	push   %esi
  800a30:	e8 7c fe ff ff       	call   8008b1 <printfmt>
  800a35:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a3b:	e9 b4 fe ff ff       	jmp    8008f4 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8d 50 04             	lea    0x4(%eax),%edx
  800a46:	89 55 14             	mov    %edx,0x14(%ebp)
  800a49:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800a4b:	85 ff                	test   %edi,%edi
  800a4d:	b8 20 27 80 00       	mov    $0x802720,%eax
  800a52:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800a55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a59:	0f 8e 94 00 00 00    	jle    800af3 <vprintfmt+0x225>
  800a5f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800a63:	0f 84 98 00 00 00    	je     800b01 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 d0             	pushl  -0x30(%ebp)
  800a6f:	57                   	push   %edi
  800a70:	e8 41 02 00 00       	call   800cb6 <strnlen>
  800a75:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a78:	29 c1                	sub    %eax,%ecx
  800a7a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800a7d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800a80:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800a84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a87:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800a8a:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a8c:	eb 0f                	jmp    800a9d <vprintfmt+0x1cf>
					putch(padc, putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	53                   	push   %ebx
  800a92:	ff 75 e0             	pushl  -0x20(%ebp)
  800a95:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a97:	83 ef 01             	sub    $0x1,%edi
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	85 ff                	test   %edi,%edi
  800a9f:	7f ed                	jg     800a8e <vprintfmt+0x1c0>
  800aa1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800aa4:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800aa7:	85 c9                	test   %ecx,%ecx
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aae:	0f 49 c1             	cmovns %ecx,%eax
  800ab1:	29 c1                	sub    %eax,%ecx
  800ab3:	89 75 08             	mov    %esi,0x8(%ebp)
  800ab6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800ab9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800abc:	89 cb                	mov    %ecx,%ebx
  800abe:	eb 4d                	jmp    800b0d <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ac0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ac4:	74 1b                	je     800ae1 <vprintfmt+0x213>
  800ac6:	0f be c0             	movsbl %al,%eax
  800ac9:	83 e8 20             	sub    $0x20,%eax
  800acc:	83 f8 5e             	cmp    $0x5e,%eax
  800acf:	76 10                	jbe    800ae1 <vprintfmt+0x213>
					putch('?', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 3f                	push   $0x3f
  800ad9:	ff 55 08             	call   *0x8(%ebp)
  800adc:	83 c4 10             	add    $0x10,%esp
  800adf:	eb 0d                	jmp    800aee <vprintfmt+0x220>
				else
					putch(ch, putdat);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	52                   	push   %edx
  800ae8:	ff 55 08             	call   *0x8(%ebp)
  800aeb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aee:	83 eb 01             	sub    $0x1,%ebx
  800af1:	eb 1a                	jmp    800b0d <vprintfmt+0x23f>
  800af3:	89 75 08             	mov    %esi,0x8(%ebp)
  800af6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800af9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800afc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800aff:	eb 0c                	jmp    800b0d <vprintfmt+0x23f>
  800b01:	89 75 08             	mov    %esi,0x8(%ebp)
  800b04:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800b07:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800b0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800b0d:	83 c7 01             	add    $0x1,%edi
  800b10:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800b14:	0f be d0             	movsbl %al,%edx
  800b17:	85 d2                	test   %edx,%edx
  800b19:	74 23                	je     800b3e <vprintfmt+0x270>
  800b1b:	85 f6                	test   %esi,%esi
  800b1d:	78 a1                	js     800ac0 <vprintfmt+0x1f2>
  800b1f:	83 ee 01             	sub    $0x1,%esi
  800b22:	79 9c                	jns    800ac0 <vprintfmt+0x1f2>
  800b24:	89 df                	mov    %ebx,%edi
  800b26:	8b 75 08             	mov    0x8(%ebp),%esi
  800b29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b2c:	eb 18                	jmp    800b46 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	53                   	push   %ebx
  800b32:	6a 20                	push   $0x20
  800b34:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b36:	83 ef 01             	sub    $0x1,%edi
  800b39:	83 c4 10             	add    $0x10,%esp
  800b3c:	eb 08                	jmp    800b46 <vprintfmt+0x278>
  800b3e:	89 df                	mov    %ebx,%edi
  800b40:	8b 75 08             	mov    0x8(%ebp),%esi
  800b43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b46:	85 ff                	test   %edi,%edi
  800b48:	7f e4                	jg     800b2e <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b4a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800b4d:	e9 a2 fd ff ff       	jmp    8008f4 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b52:	8d 45 14             	lea    0x14(%ebp),%eax
  800b55:	e8 08 fd ff ff       	call   800862 <getint>
  800b5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b60:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	79 74                	jns    800bdf <vprintfmt+0x311>
				putch('-', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	53                   	push   %ebx
  800b6f:	6a 2d                	push   $0x2d
  800b71:	ff d6                	call   *%esi
				num = -(long long) num;
  800b73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b76:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b79:	f7 d8                	neg    %eax
  800b7b:	83 d2 00             	adc    $0x0,%edx
  800b7e:	f7 da                	neg    %edx
  800b80:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800b83:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b88:	eb 55                	jmp    800bdf <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8d:	e8 96 fc ff ff       	call   800828 <getuint>
			base = 10;
  800b92:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b97:	eb 46                	jmp    800bdf <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800b99:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9c:	e8 87 fc ff ff       	call   800828 <getuint>
			base = 8;
  800ba1:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ba6:	eb 37                	jmp    800bdf <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	53                   	push   %ebx
  800bac:	6a 30                	push   $0x30
  800bae:	ff d6                	call   *%esi
			putch('x', putdat);
  800bb0:	83 c4 08             	add    $0x8,%esp
  800bb3:	53                   	push   %ebx
  800bb4:	6a 78                	push   $0x78
  800bb6:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbb:	8d 50 04             	lea    0x4(%eax),%edx
  800bbe:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800bc8:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800bcb:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800bd0:	eb 0d                	jmp    800bdf <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	e8 4e fc ff ff       	call   800828 <getuint>
			base = 16;
  800bda:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bdf:	83 ec 0c             	sub    $0xc,%esp
  800be2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800be6:	57                   	push   %edi
  800be7:	ff 75 e0             	pushl  -0x20(%ebp)
  800bea:	51                   	push   %ecx
  800beb:	52                   	push   %edx
  800bec:	50                   	push   %eax
  800bed:	89 da                	mov    %ebx,%edx
  800bef:	89 f0                	mov    %esi,%eax
  800bf1:	e8 83 fb ff ff       	call   800779 <printnum>
			break;
  800bf6:	83 c4 20             	add    $0x20,%esp
  800bf9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800bfc:	e9 f3 fc ff ff       	jmp    8008f4 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	53                   	push   %ebx
  800c05:	51                   	push   %ecx
  800c06:	ff d6                	call   *%esi
			break;
  800c08:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c0b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  800c0e:	e9 e1 fc ff ff       	jmp    8008f4 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	53                   	push   %ebx
  800c17:	6a 25                	push   $0x25
  800c19:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c1b:	83 c4 10             	add    $0x10,%esp
  800c1e:	eb 03                	jmp    800c23 <vprintfmt+0x355>
  800c20:	83 ef 01             	sub    $0x1,%edi
  800c23:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  800c27:	75 f7                	jne    800c20 <vprintfmt+0x352>
  800c29:	e9 c6 fc ff ff       	jmp    8008f4 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 18             	sub    $0x18,%esp
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c45:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c49:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	74 26                	je     800c7d <vsnprintf+0x47>
  800c57:	85 d2                	test   %edx,%edx
  800c59:	7e 22                	jle    800c7d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c5b:	ff 75 14             	pushl  0x14(%ebp)
  800c5e:	ff 75 10             	pushl  0x10(%ebp)
  800c61:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	68 94 08 80 00       	push   $0x800894
  800c6a:	e8 5f fc ff ff       	call   8008ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c72:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	eb 05                	jmp    800c82 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 10             	pushl  0x10(%ebp)
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	ff 75 08             	pushl  0x8(%ebp)
  800c97:	e8 9a ff ff ff       	call   800c36 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca9:	eb 03                	jmp    800cae <strlen+0x10>
		n++;
  800cab:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cb2:	75 f7                	jne    800cab <strlen+0xd>
		n++;
	return n;
}
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc4:	eb 03                	jmp    800cc9 <strnlen+0x13>
		n++;
  800cc6:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	39 c2                	cmp    %eax,%edx
  800ccb:	74 08                	je     800cd5 <strnlen+0x1f>
  800ccd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800cd1:	75 f3                	jne    800cc6 <strnlen+0x10>
  800cd3:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	53                   	push   %ebx
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ce1:	89 c2                	mov    %eax,%edx
  800ce3:	83 c2 01             	add    $0x1,%edx
  800ce6:	83 c1 01             	add    $0x1,%ecx
  800ce9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800ced:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cf0:	84 db                	test   %bl,%bl
  800cf2:	75 ef                	jne    800ce3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	53                   	push   %ebx
  800cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cfe:	53                   	push   %ebx
  800cff:	e8 9a ff ff ff       	call   800c9e <strlen>
  800d04:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	01 d8                	add    %ebx,%eax
  800d0c:	50                   	push   %eax
  800d0d:	e8 c5 ff ff ff       	call   800cd7 <strcpy>
	return dst;
}
  800d12:	89 d8                	mov    %ebx,%eax
  800d14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	8b 75 08             	mov    0x8(%ebp),%esi
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d24:	89 f3                	mov    %esi,%ebx
  800d26:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d29:	89 f2                	mov    %esi,%edx
  800d2b:	eb 0f                	jmp    800d3c <strncpy+0x23>
		*dst++ = *src;
  800d2d:	83 c2 01             	add    $0x1,%edx
  800d30:	0f b6 01             	movzbl (%ecx),%eax
  800d33:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d36:	80 39 01             	cmpb   $0x1,(%ecx)
  800d39:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3c:	39 da                	cmp    %ebx,%edx
  800d3e:	75 ed                	jne    800d2d <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d40:	89 f0                	mov    %esi,%eax
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d51:	8b 55 10             	mov    0x10(%ebp),%edx
  800d54:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d56:	85 d2                	test   %edx,%edx
  800d58:	74 21                	je     800d7b <strlcpy+0x35>
  800d5a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800d5e:	89 f2                	mov    %esi,%edx
  800d60:	eb 09                	jmp    800d6b <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d62:	83 c2 01             	add    $0x1,%edx
  800d65:	83 c1 01             	add    $0x1,%ecx
  800d68:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d6b:	39 c2                	cmp    %eax,%edx
  800d6d:	74 09                	je     800d78 <strlcpy+0x32>
  800d6f:	0f b6 19             	movzbl (%ecx),%ebx
  800d72:	84 db                	test   %bl,%bl
  800d74:	75 ec                	jne    800d62 <strlcpy+0x1c>
  800d76:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800d78:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d7b:	29 f0                	sub    %esi,%eax
}
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d87:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d8a:	eb 06                	jmp    800d92 <strcmp+0x11>
		p++, q++;
  800d8c:	83 c1 01             	add    $0x1,%ecx
  800d8f:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d92:	0f b6 01             	movzbl (%ecx),%eax
  800d95:	84 c0                	test   %al,%al
  800d97:	74 04                	je     800d9d <strcmp+0x1c>
  800d99:	3a 02                	cmp    (%edx),%al
  800d9b:	74 ef                	je     800d8c <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9d:	0f b6 c0             	movzbl %al,%eax
  800da0:	0f b6 12             	movzbl (%edx),%edx
  800da3:	29 d0                	sub    %edx,%eax
}
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	53                   	push   %ebx
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	89 c3                	mov    %eax,%ebx
  800db3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800db6:	eb 06                	jmp    800dbe <strncmp+0x17>
		n--, p++, q++;
  800db8:	83 c0 01             	add    $0x1,%eax
  800dbb:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800dbe:	39 d8                	cmp    %ebx,%eax
  800dc0:	74 15                	je     800dd7 <strncmp+0x30>
  800dc2:	0f b6 08             	movzbl (%eax),%ecx
  800dc5:	84 c9                	test   %cl,%cl
  800dc7:	74 04                	je     800dcd <strncmp+0x26>
  800dc9:	3a 0a                	cmp    (%edx),%cl
  800dcb:	74 eb                	je     800db8 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dcd:	0f b6 00             	movzbl (%eax),%eax
  800dd0:	0f b6 12             	movzbl (%edx),%edx
  800dd3:	29 d0                	sub    %edx,%eax
  800dd5:	eb 05                	jmp    800ddc <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800dd7:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800de9:	eb 07                	jmp    800df2 <strchr+0x13>
		if (*s == c)
  800deb:	38 ca                	cmp    %cl,%dl
  800ded:	74 0f                	je     800dfe <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800def:	83 c0 01             	add    $0x1,%eax
  800df2:	0f b6 10             	movzbl (%eax),%edx
  800df5:	84 d2                	test   %dl,%dl
  800df7:	75 f2                	jne    800deb <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e0a:	eb 03                	jmp    800e0f <strfind+0xf>
  800e0c:	83 c0 01             	add    $0x1,%eax
  800e0f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e12:	38 ca                	cmp    %cl,%dl
  800e14:	74 04                	je     800e1a <strfind+0x1a>
  800e16:	84 d2                	test   %dl,%dl
  800e18:	75 f2                	jne    800e0c <strfind+0xc>
			break;
	return (char *) s;
}
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	56                   	push   %esi
  800e21:	53                   	push   %ebx
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800e28:	85 c9                	test   %ecx,%ecx
  800e2a:	74 37                	je     800e63 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e2c:	f6 c2 03             	test   $0x3,%dl
  800e2f:	75 2a                	jne    800e5b <memset+0x3f>
  800e31:	f6 c1 03             	test   $0x3,%cl
  800e34:	75 25                	jne    800e5b <memset+0x3f>
		c &= 0xFF;
  800e36:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e3a:	89 df                	mov    %ebx,%edi
  800e3c:	c1 e7 08             	shl    $0x8,%edi
  800e3f:	89 de                	mov    %ebx,%esi
  800e41:	c1 e6 18             	shl    $0x18,%esi
  800e44:	89 d8                	mov    %ebx,%eax
  800e46:	c1 e0 10             	shl    $0x10,%eax
  800e49:	09 f0                	or     %esi,%eax
  800e4b:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800e4d:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800e50:	89 f8                	mov    %edi,%eax
  800e52:	09 d8                	or     %ebx,%eax
  800e54:	89 d7                	mov    %edx,%edi
  800e56:	fc                   	cld    
  800e57:	f3 ab                	rep stos %eax,%es:(%edi)
  800e59:	eb 08                	jmp    800e63 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e5b:	89 d7                	mov    %edx,%edi
  800e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e60:	fc                   	cld    
  800e61:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800e63:	89 d0                	mov    %edx,%eax
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e78:	39 c6                	cmp    %eax,%esi
  800e7a:	73 35                	jae    800eb1 <memmove+0x47>
  800e7c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e7f:	39 d0                	cmp    %edx,%eax
  800e81:	73 2e                	jae    800eb1 <memmove+0x47>
		s += n;
		d += n;
  800e83:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e86:	89 d6                	mov    %edx,%esi
  800e88:	09 fe                	or     %edi,%esi
  800e8a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e90:	75 13                	jne    800ea5 <memmove+0x3b>
  800e92:	f6 c1 03             	test   $0x3,%cl
  800e95:	75 0e                	jne    800ea5 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800e97:	83 ef 04             	sub    $0x4,%edi
  800e9a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e9d:	c1 e9 02             	shr    $0x2,%ecx
  800ea0:	fd                   	std    
  800ea1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ea3:	eb 09                	jmp    800eae <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ea5:	83 ef 01             	sub    $0x1,%edi
  800ea8:	8d 72 ff             	lea    -0x1(%edx),%esi
  800eab:	fd                   	std    
  800eac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800eae:	fc                   	cld    
  800eaf:	eb 1d                	jmp    800ece <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eb1:	89 f2                	mov    %esi,%edx
  800eb3:	09 c2                	or     %eax,%edx
  800eb5:	f6 c2 03             	test   $0x3,%dl
  800eb8:	75 0f                	jne    800ec9 <memmove+0x5f>
  800eba:	f6 c1 03             	test   $0x3,%cl
  800ebd:	75 0a                	jne    800ec9 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800ebf:	c1 e9 02             	shr    $0x2,%ecx
  800ec2:	89 c7                	mov    %eax,%edi
  800ec4:	fc                   	cld    
  800ec5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ec7:	eb 05                	jmp    800ece <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ec9:	89 c7                	mov    %eax,%edi
  800ecb:	fc                   	cld    
  800ecc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ece:	5e                   	pop    %esi
  800ecf:	5f                   	pop    %edi
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ed5:	ff 75 10             	pushl  0x10(%ebp)
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	ff 75 08             	pushl  0x8(%ebp)
  800ede:	e8 87 ff ff ff       	call   800e6a <memmove>
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	56                   	push   %esi
  800ee9:	53                   	push   %ebx
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef0:	89 c6                	mov    %eax,%esi
  800ef2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ef5:	eb 1a                	jmp    800f11 <memcmp+0x2c>
		if (*s1 != *s2)
  800ef7:	0f b6 08             	movzbl (%eax),%ecx
  800efa:	0f b6 1a             	movzbl (%edx),%ebx
  800efd:	38 d9                	cmp    %bl,%cl
  800eff:	74 0a                	je     800f0b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f01:	0f b6 c1             	movzbl %cl,%eax
  800f04:	0f b6 db             	movzbl %bl,%ebx
  800f07:	29 d8                	sub    %ebx,%eax
  800f09:	eb 0f                	jmp    800f1a <memcmp+0x35>
		s1++, s2++;
  800f0b:	83 c0 01             	add    $0x1,%eax
  800f0e:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f11:	39 f0                	cmp    %esi,%eax
  800f13:	75 e2                	jne    800ef7 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    

00800f1e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	53                   	push   %ebx
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800f25:	89 c1                	mov    %eax,%ecx
  800f27:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2a:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f2e:	eb 0a                	jmp    800f3a <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f30:	0f b6 10             	movzbl (%eax),%edx
  800f33:	39 da                	cmp    %ebx,%edx
  800f35:	74 07                	je     800f3e <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f37:	83 c0 01             	add    $0x1,%eax
  800f3a:	39 c8                	cmp    %ecx,%eax
  800f3c:	72 f2                	jb     800f30 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f3e:	5b                   	pop    %ebx
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	57                   	push   %edi
  800f45:	56                   	push   %esi
  800f46:	53                   	push   %ebx
  800f47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4d:	eb 03                	jmp    800f52 <strtol+0x11>
		s++;
  800f4f:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f52:	0f b6 01             	movzbl (%ecx),%eax
  800f55:	3c 20                	cmp    $0x20,%al
  800f57:	74 f6                	je     800f4f <strtol+0xe>
  800f59:	3c 09                	cmp    $0x9,%al
  800f5b:	74 f2                	je     800f4f <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f5d:	3c 2b                	cmp    $0x2b,%al
  800f5f:	75 0a                	jne    800f6b <strtol+0x2a>
		s++;
  800f61:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f64:	bf 00 00 00 00       	mov    $0x0,%edi
  800f69:	eb 11                	jmp    800f7c <strtol+0x3b>
  800f6b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f70:	3c 2d                	cmp    $0x2d,%al
  800f72:	75 08                	jne    800f7c <strtol+0x3b>
		s++, neg = 1;
  800f74:	83 c1 01             	add    $0x1,%ecx
  800f77:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f7c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f82:	75 15                	jne    800f99 <strtol+0x58>
  800f84:	80 39 30             	cmpb   $0x30,(%ecx)
  800f87:	75 10                	jne    800f99 <strtol+0x58>
  800f89:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f8d:	75 7c                	jne    80100b <strtol+0xca>
		s += 2, base = 16;
  800f8f:	83 c1 02             	add    $0x2,%ecx
  800f92:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f97:	eb 16                	jmp    800faf <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800f99:	85 db                	test   %ebx,%ebx
  800f9b:	75 12                	jne    800faf <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f9d:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fa2:	80 39 30             	cmpb   $0x30,(%ecx)
  800fa5:	75 08                	jne    800faf <strtol+0x6e>
		s++, base = 8;
  800fa7:	83 c1 01             	add    $0x1,%ecx
  800faa:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb4:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb7:	0f b6 11             	movzbl (%ecx),%edx
  800fba:	8d 72 d0             	lea    -0x30(%edx),%esi
  800fbd:	89 f3                	mov    %esi,%ebx
  800fbf:	80 fb 09             	cmp    $0x9,%bl
  800fc2:	77 08                	ja     800fcc <strtol+0x8b>
			dig = *s - '0';
  800fc4:	0f be d2             	movsbl %dl,%edx
  800fc7:	83 ea 30             	sub    $0x30,%edx
  800fca:	eb 22                	jmp    800fee <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800fcc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fcf:	89 f3                	mov    %esi,%ebx
  800fd1:	80 fb 19             	cmp    $0x19,%bl
  800fd4:	77 08                	ja     800fde <strtol+0x9d>
			dig = *s - 'a' + 10;
  800fd6:	0f be d2             	movsbl %dl,%edx
  800fd9:	83 ea 57             	sub    $0x57,%edx
  800fdc:	eb 10                	jmp    800fee <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800fde:	8d 72 bf             	lea    -0x41(%edx),%esi
  800fe1:	89 f3                	mov    %esi,%ebx
  800fe3:	80 fb 19             	cmp    $0x19,%bl
  800fe6:	77 16                	ja     800ffe <strtol+0xbd>
			dig = *s - 'A' + 10;
  800fe8:	0f be d2             	movsbl %dl,%edx
  800feb:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800fee:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ff1:	7d 0b                	jge    800ffe <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800ff3:	83 c1 01             	add    $0x1,%ecx
  800ff6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800ffc:	eb b9                	jmp    800fb7 <strtol+0x76>

	if (endptr)
  800ffe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801002:	74 0d                	je     801011 <strtol+0xd0>
		*endptr = (char *) s;
  801004:	8b 75 0c             	mov    0xc(%ebp),%esi
  801007:	89 0e                	mov    %ecx,(%esi)
  801009:	eb 06                	jmp    801011 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80100b:	85 db                	test   %ebx,%ebx
  80100d:	74 98                	je     800fa7 <strtol+0x66>
  80100f:	eb 9e                	jmp    800faf <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  801011:	89 c2                	mov    %eax,%edx
  801013:	f7 da                	neg    %edx
  801015:	85 ff                	test   %edi,%edi
  801017:	0f 45 c2             	cmovne %edx,%eax
}
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	57                   	push   %edi
  801023:	56                   	push   %esi
  801024:	53                   	push   %ebx
  801025:	83 ec 1c             	sub    $0x1c,%esp
  801028:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80102b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80102e:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801030:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801033:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801036:	8b 7d 10             	mov    0x10(%ebp),%edi
  801039:	8b 75 14             	mov    0x14(%ebp),%esi
  80103c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80103e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801042:	74 1d                	je     801061 <syscall+0x42>
  801044:	85 c0                	test   %eax,%eax
  801046:	7e 19                	jle    801061 <syscall+0x42>
  801048:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	50                   	push   %eax
  80104f:	52                   	push   %edx
  801050:	68 1f 2a 80 00       	push   $0x802a1f
  801055:	6a 23                	push   $0x23
  801057:	68 3c 2a 80 00       	push   $0x802a3c
  80105c:	e8 2b f6 ff ff       	call   80068c <_panic>

	return ret;
}
  801061:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801064:	5b                   	pop    %ebx
  801065:	5e                   	pop    %esi
  801066:	5f                   	pop    %edi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80106f:	6a 00                	push   $0x0
  801071:	6a 00                	push   $0x0
  801073:	6a 00                	push   $0x0
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107b:	ba 00 00 00 00       	mov    $0x0,%edx
  801080:	b8 00 00 00 00       	mov    $0x0,%eax
  801085:	e8 95 ff ff ff       	call   80101f <syscall>
}
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <sys_cgetc>:

int
sys_cgetc(void)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801095:	6a 00                	push   $0x0
  801097:	6a 00                	push   $0x0
  801099:	6a 00                	push   $0x0
  80109b:	6a 00                	push   $0x0
  80109d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010ac:	e8 6e ff ff ff       	call   80101f <syscall>
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 00                	push   $0x0
  8010bf:	6a 00                	push   $0x0
  8010c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c4:	ba 01 00 00 00       	mov    $0x1,%edx
  8010c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8010ce:	e8 4c ff ff ff       	call   80101f <syscall>
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8010db:	6a 00                	push   $0x0
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 00                	push   $0x0
  8010e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ed:	b8 02 00 00 00       	mov    $0x2,%eax
  8010f2:	e8 28 ff ff ff       	call   80101f <syscall>
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <sys_yield>:

void
sys_yield(void)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8010ff:	6a 00                	push   $0x0
  801101:	6a 00                	push   $0x0
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	b9 00 00 00 00       	mov    $0x0,%ecx
  80110c:	ba 00 00 00 00       	mov    $0x0,%edx
  801111:	b8 0b 00 00 00       	mov    $0xb,%eax
  801116:	e8 04 ff ff ff       	call   80101f <syscall>
}
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	ff 75 10             	pushl  0x10(%ebp)
  80112d:	ff 75 0c             	pushl  0xc(%ebp)
  801130:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801133:	ba 01 00 00 00       	mov    $0x1,%edx
  801138:	b8 04 00 00 00       	mov    $0x4,%eax
  80113d:	e8 dd fe ff ff       	call   80101f <syscall>
}
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  80114a:	ff 75 18             	pushl  0x18(%ebp)
  80114d:	ff 75 14             	pushl  0x14(%ebp)
  801150:	ff 75 10             	pushl  0x10(%ebp)
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801159:	ba 01 00 00 00       	mov    $0x1,%edx
  80115e:	b8 05 00 00 00       	mov    $0x5,%eax
  801163:	e8 b7 fe ff ff       	call   80101f <syscall>
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  801170:	6a 00                	push   $0x0
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117c:	ba 01 00 00 00       	mov    $0x1,%edx
  801181:	b8 06 00 00 00       	mov    $0x6,%eax
  801186:	e8 94 fe ff ff       	call   80101f <syscall>
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	ff 75 0c             	pushl  0xc(%ebp)
  80119c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119f:	ba 01 00 00 00       	mov    $0x1,%edx
  8011a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8011a9:	e8 71 fe ff ff       	call   80101f <syscall>
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	ff 75 0c             	pushl  0xc(%ebp)
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	ba 01 00 00 00       	mov    $0x1,%edx
  8011c7:	b8 09 00 00 00       	mov    $0x9,%eax
  8011cc:	e8 4e fe ff ff       	call   80101f <syscall>
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  8011d9:	6a 00                	push   $0x0
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e5:	ba 01 00 00 00       	mov    $0x1,%edx
  8011ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011ef:	e8 2b fe ff ff       	call   80101f <syscall>
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8011fc:	6a 00                	push   $0x0
  8011fe:	ff 75 14             	pushl  0x14(%ebp)
  801201:	ff 75 10             	pushl  0x10(%ebp)
  801204:	ff 75 0c             	pushl  0xc(%ebp)
  801207:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120a:	ba 00 00 00 00       	mov    $0x0,%edx
  80120f:	b8 0c 00 00 00       	mov    $0xc,%eax
  801214:	e8 06 fe ff ff       	call   80101f <syscall>
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122c:	ba 01 00 00 00       	mov    $0x1,%edx
  801231:	b8 0d 00 00 00       	mov    $0xd,%eax
  801236:	e8 e4 fd ff ff       	call   80101f <syscall>
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	8b 75 08             	mov    0x8(%ebp),%esi
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  80124b:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  80124d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801252:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	50                   	push   %eax
  801259:	e8 bd ff ff ff       	call   80121b <sys_ipc_recv>
	if (from_env_store)
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 f6                	test   %esi,%esi
  801263:	74 0b                	je     801270 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801265:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80126b:	8b 52 74             	mov    0x74(%edx),%edx
  80126e:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801270:	85 db                	test   %ebx,%ebx
  801272:	74 0b                	je     80127f <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801274:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80127a:	8b 52 78             	mov    0x78(%edx),%edx
  80127d:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  80127f:	85 c0                	test   %eax,%eax
  801281:	79 16                	jns    801299 <ipc_recv+0x5c>
		if (from_env_store)
  801283:	85 f6                	test   %esi,%esi
  801285:	74 06                	je     80128d <ipc_recv+0x50>
			*from_env_store = 0;
  801287:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  80128d:	85 db                	test   %ebx,%ebx
  80128f:	74 10                	je     8012a1 <ipc_recv+0x64>
			*perm_store = 0;
  801291:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801297:	eb 08                	jmp    8012a1 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801299:	a1 04 40 80 00       	mov    0x804004,%eax
  80129e:	8b 40 70             	mov    0x70(%eax),%eax
}
  8012a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012a4:	5b                   	pop    %ebx
  8012a5:	5e                   	pop    %esi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  8012ba:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  8012bc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012c1:	0f 44 d8             	cmove  %eax,%ebx
  8012c4:	eb 1c                	jmp    8012e2 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  8012c6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012c9:	74 12                	je     8012dd <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  8012cb:	50                   	push   %eax
  8012cc:	68 4a 2a 80 00       	push   $0x802a4a
  8012d1:	6a 42                	push   $0x42
  8012d3:	68 60 2a 80 00       	push   $0x802a60
  8012d8:	e8 af f3 ff ff       	call   80068c <_panic>
		sys_yield();
  8012dd:	e8 17 fe ff ff       	call   8010f9 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  8012e2:	ff 75 14             	pushl  0x14(%ebp)
  8012e5:	53                   	push   %ebx
  8012e6:	56                   	push   %esi
  8012e7:	57                   	push   %edi
  8012e8:	e8 09 ff ff ff       	call   8011f6 <sys_ipc_try_send>
  8012ed:	83 c4 10             	add    $0x10,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	75 d2                	jne    8012c6 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  8012f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f7:	5b                   	pop    %ebx
  8012f8:	5e                   	pop    %esi
  8012f9:	5f                   	pop    %edi
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    

008012fc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801302:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801307:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80130a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801310:	8b 52 50             	mov    0x50(%edx),%edx
  801313:	39 ca                	cmp    %ecx,%edx
  801315:	75 0d                	jne    801324 <ipc_find_env+0x28>
			return envs[i].env_id;
  801317:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80131a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131f:	8b 40 48             	mov    0x48(%eax),%eax
  801322:	eb 0f                	jmp    801333 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801324:	83 c0 01             	add    $0x1,%eax
  801327:	3d 00 04 00 00       	cmp    $0x400,%eax
  80132c:	75 d9                	jne    801307 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80132e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	05 00 00 00 30       	add    $0x30000000,%eax
  801340:	c1 e8 0c             	shr    $0xc,%eax
}
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801348:	ff 75 08             	pushl  0x8(%ebp)
  80134b:	e8 e5 ff ff ff       	call   801335 <fd2num>
  801350:	83 c4 04             	add    $0x4,%esp
  801353:	c1 e0 0c             	shl    $0xc,%eax
  801356:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801363:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801368:	89 c2                	mov    %eax,%edx
  80136a:	c1 ea 16             	shr    $0x16,%edx
  80136d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801374:	f6 c2 01             	test   $0x1,%dl
  801377:	74 11                	je     80138a <fd_alloc+0x2d>
  801379:	89 c2                	mov    %eax,%edx
  80137b:	c1 ea 0c             	shr    $0xc,%edx
  80137e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801385:	f6 c2 01             	test   $0x1,%dl
  801388:	75 09                	jne    801393 <fd_alloc+0x36>
			*fd_store = fd;
  80138a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
  801391:	eb 17                	jmp    8013aa <fd_alloc+0x4d>
  801393:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801398:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80139d:	75 c9                	jne    801368 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80139f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013a5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    

008013ac <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013b2:	83 f8 1f             	cmp    $0x1f,%eax
  8013b5:	77 36                	ja     8013ed <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013b7:	c1 e0 0c             	shl    $0xc,%eax
  8013ba:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013bf:	89 c2                	mov    %eax,%edx
  8013c1:	c1 ea 16             	shr    $0x16,%edx
  8013c4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013cb:	f6 c2 01             	test   $0x1,%dl
  8013ce:	74 24                	je     8013f4 <fd_lookup+0x48>
  8013d0:	89 c2                	mov    %eax,%edx
  8013d2:	c1 ea 0c             	shr    $0xc,%edx
  8013d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013dc:	f6 c2 01             	test   $0x1,%dl
  8013df:	74 1a                	je     8013fb <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e4:	89 02                	mov    %eax,(%edx)
	return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013eb:	eb 13                	jmp    801400 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f2:	eb 0c                	jmp    801400 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f9:	eb 05                	jmp    801400 <fd_lookup+0x54>
  8013fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    

00801402 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140b:	ba ec 2a 80 00       	mov    $0x802aec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801410:	eb 13                	jmp    801425 <dev_lookup+0x23>
  801412:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  801415:	39 08                	cmp    %ecx,(%eax)
  801417:	75 0c                	jne    801425 <dev_lookup+0x23>
			*dev = devtab[i];
  801419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80141e:	b8 00 00 00 00       	mov    $0x0,%eax
  801423:	eb 2e                	jmp    801453 <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801425:	8b 02                	mov    (%edx),%eax
  801427:	85 c0                	test   %eax,%eax
  801429:	75 e7                	jne    801412 <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80142b:	a1 04 40 80 00       	mov    0x804004,%eax
  801430:	8b 40 48             	mov    0x48(%eax),%eax
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	51                   	push   %ecx
  801437:	50                   	push   %eax
  801438:	68 6c 2a 80 00       	push   $0x802a6c
  80143d:	e8 23 f3 ff ff       	call   800765 <cprintf>
	*dev = 0;
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	56                   	push   %esi
  801459:	53                   	push   %ebx
  80145a:	83 ec 10             	sub    $0x10,%esp
  80145d:	8b 75 08             	mov    0x8(%ebp),%esi
  801460:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801463:	56                   	push   %esi
  801464:	e8 cc fe ff ff       	call   801335 <fd2num>
  801469:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80146c:	89 14 24             	mov    %edx,(%esp)
  80146f:	50                   	push   %eax
  801470:	e8 37 ff ff ff       	call   8013ac <fd_lookup>
  801475:	83 c4 08             	add    $0x8,%esp
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 05                	js     801481 <fd_close+0x2c>
	    || fd != fd2)
  80147c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80147f:	74 0c                	je     80148d <fd_close+0x38>
		return (must_exist ? r : 0);
  801481:	84 db                	test   %bl,%bl
  801483:	ba 00 00 00 00       	mov    $0x0,%edx
  801488:	0f 44 c2             	cmove  %edx,%eax
  80148b:	eb 41                	jmp    8014ce <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	ff 36                	pushl  (%esi)
  801496:	e8 67 ff ff ff       	call   801402 <dev_lookup>
  80149b:	89 c3                	mov    %eax,%ebx
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 1a                	js     8014be <fd_close+0x69>
		if (dev->dev_close)
  8014a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014aa:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 0b                	je     8014be <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8014b3:	83 ec 0c             	sub    $0xc,%esp
  8014b6:	56                   	push   %esi
  8014b7:	ff d0                	call   *%eax
  8014b9:	89 c3                	mov    %eax,%ebx
  8014bb:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	56                   	push   %esi
  8014c2:	6a 00                	push   $0x0
  8014c4:	e8 a1 fc ff ff       	call   80116a <sys_page_unmap>
	return r;
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	89 d8                	mov    %ebx,%eax
}
  8014ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	e8 c5 fe ff ff       	call   8013ac <fd_lookup>
  8014e7:	83 c4 08             	add    $0x8,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 10                	js     8014fe <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	6a 01                	push   $0x1
  8014f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f6:	e8 5a ff ff ff       	call   801455 <fd_close>
  8014fb:	83 c4 10             	add    $0x10,%esp
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <close_all>:

void
close_all(void)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	53                   	push   %ebx
  801504:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801507:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	53                   	push   %ebx
  801510:	e8 c0 ff ff ff       	call   8014d5 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801515:	83 c3 01             	add    $0x1,%ebx
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	83 fb 20             	cmp    $0x20,%ebx
  80151e:	75 ec                	jne    80150c <close_all+0xc>
		close(i);
}
  801520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	57                   	push   %edi
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
  80152b:	83 ec 2c             	sub    $0x2c,%esp
  80152e:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801531:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801534:	50                   	push   %eax
  801535:	ff 75 08             	pushl  0x8(%ebp)
  801538:	e8 6f fe ff ff       	call   8013ac <fd_lookup>
  80153d:	83 c4 08             	add    $0x8,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	0f 88 c1 00 00 00    	js     801609 <dup+0xe4>
		return r;
	close(newfdnum);
  801548:	83 ec 0c             	sub    $0xc,%esp
  80154b:	56                   	push   %esi
  80154c:	e8 84 ff ff ff       	call   8014d5 <close>

	newfd = INDEX2FD(newfdnum);
  801551:	89 f3                	mov    %esi,%ebx
  801553:	c1 e3 0c             	shl    $0xc,%ebx
  801556:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  80155c:	83 c4 04             	add    $0x4,%esp
  80155f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801562:	e8 de fd ff ff       	call   801345 <fd2data>
  801567:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801569:	89 1c 24             	mov    %ebx,(%esp)
  80156c:	e8 d4 fd ff ff       	call   801345 <fd2data>
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801577:	89 f8                	mov    %edi,%eax
  801579:	c1 e8 16             	shr    $0x16,%eax
  80157c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801583:	a8 01                	test   $0x1,%al
  801585:	74 37                	je     8015be <dup+0x99>
  801587:	89 f8                	mov    %edi,%eax
  801589:	c1 e8 0c             	shr    $0xc,%eax
  80158c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801593:	f6 c2 01             	test   $0x1,%dl
  801596:	74 26                	je     8015be <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801598:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80159f:	83 ec 0c             	sub    $0xc,%esp
  8015a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8015a7:	50                   	push   %eax
  8015a8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8015ab:	6a 00                	push   $0x0
  8015ad:	57                   	push   %edi
  8015ae:	6a 00                	push   $0x0
  8015b0:	e8 8f fb ff ff       	call   801144 <sys_page_map>
  8015b5:	89 c7                	mov    %eax,%edi
  8015b7:	83 c4 20             	add    $0x20,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 2e                	js     8015ec <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c1:	89 d0                	mov    %edx,%eax
  8015c3:	c1 e8 0c             	shr    $0xc,%eax
  8015c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015cd:	83 ec 0c             	sub    $0xc,%esp
  8015d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8015d5:	50                   	push   %eax
  8015d6:	53                   	push   %ebx
  8015d7:	6a 00                	push   $0x0
  8015d9:	52                   	push   %edx
  8015da:	6a 00                	push   $0x0
  8015dc:	e8 63 fb ff ff       	call   801144 <sys_page_map>
  8015e1:	89 c7                	mov    %eax,%edi
  8015e3:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8015e6:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015e8:	85 ff                	test   %edi,%edi
  8015ea:	79 1d                	jns    801609 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015ec:	83 ec 08             	sub    $0x8,%esp
  8015ef:	53                   	push   %ebx
  8015f0:	6a 00                	push   $0x0
  8015f2:	e8 73 fb ff ff       	call   80116a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015f7:	83 c4 08             	add    $0x8,%esp
  8015fa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8015fd:	6a 00                	push   $0x0
  8015ff:	e8 66 fb ff ff       	call   80116a <sys_page_unmap>
	return r;
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	89 f8                	mov    %edi,%eax
}
  801609:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80160c:	5b                   	pop    %ebx
  80160d:	5e                   	pop    %esi
  80160e:	5f                   	pop    %edi
  80160f:	5d                   	pop    %ebp
  801610:	c3                   	ret    

00801611 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	53                   	push   %ebx
  801615:	83 ec 14             	sub    $0x14,%esp
  801618:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80161e:	50                   	push   %eax
  80161f:	53                   	push   %ebx
  801620:	e8 87 fd ff ff       	call   8013ac <fd_lookup>
  801625:	83 c4 08             	add    $0x8,%esp
  801628:	89 c2                	mov    %eax,%edx
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 6d                	js     80169b <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801634:	50                   	push   %eax
  801635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801638:	ff 30                	pushl  (%eax)
  80163a:	e8 c3 fd ff ff       	call   801402 <dev_lookup>
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	85 c0                	test   %eax,%eax
  801644:	78 4c                	js     801692 <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 42 08             	mov    0x8(%edx),%eax
  80164c:	83 e0 03             	and    $0x3,%eax
  80164f:	83 f8 01             	cmp    $0x1,%eax
  801652:	75 21                	jne    801675 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801654:	a1 04 40 80 00       	mov    0x804004,%eax
  801659:	8b 40 48             	mov    0x48(%eax),%eax
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	53                   	push   %ebx
  801660:	50                   	push   %eax
  801661:	68 b0 2a 80 00       	push   $0x802ab0
  801666:	e8 fa f0 ff ff       	call   800765 <cprintf>
		return -E_INVAL;
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801673:	eb 26                	jmp    80169b <read+0x8a>
	}
	if (!dev->dev_read)
  801675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801678:	8b 40 08             	mov    0x8(%eax),%eax
  80167b:	85 c0                	test   %eax,%eax
  80167d:	74 17                	je     801696 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	ff 75 10             	pushl  0x10(%ebp)
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	52                   	push   %edx
  801689:	ff d0                	call   *%eax
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	eb 09                	jmp    80169b <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801692:	89 c2                	mov    %eax,%edx
  801694:	eb 05                	jmp    80169b <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801696:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  80169b:	89 d0                	mov    %edx,%eax
  80169d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	57                   	push   %edi
  8016a6:	56                   	push   %esi
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 0c             	sub    $0xc,%esp
  8016ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ae:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b6:	eb 21                	jmp    8016d9 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b8:	83 ec 04             	sub    $0x4,%esp
  8016bb:	89 f0                	mov    %esi,%eax
  8016bd:	29 d8                	sub    %ebx,%eax
  8016bf:	50                   	push   %eax
  8016c0:	89 d8                	mov    %ebx,%eax
  8016c2:	03 45 0c             	add    0xc(%ebp),%eax
  8016c5:	50                   	push   %eax
  8016c6:	57                   	push   %edi
  8016c7:	e8 45 ff ff ff       	call   801611 <read>
		if (m < 0)
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 10                	js     8016e3 <readn+0x41>
			return m;
		if (m == 0)
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 0a                	je     8016e1 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016d7:	01 c3                	add    %eax,%ebx
  8016d9:	39 f3                	cmp    %esi,%ebx
  8016db:	72 db                	jb     8016b8 <readn+0x16>
  8016dd:	89 d8                	mov    %ebx,%eax
  8016df:	eb 02                	jmp    8016e3 <readn+0x41>
  8016e1:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5f                   	pop    %edi
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	53                   	push   %ebx
  8016ef:	83 ec 14             	sub    $0x14,%esp
  8016f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f8:	50                   	push   %eax
  8016f9:	53                   	push   %ebx
  8016fa:	e8 ad fc ff ff       	call   8013ac <fd_lookup>
  8016ff:	83 c4 08             	add    $0x8,%esp
  801702:	89 c2                	mov    %eax,%edx
  801704:	85 c0                	test   %eax,%eax
  801706:	78 68                	js     801770 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801708:	83 ec 08             	sub    $0x8,%esp
  80170b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170e:	50                   	push   %eax
  80170f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801712:	ff 30                	pushl  (%eax)
  801714:	e8 e9 fc ff ff       	call   801402 <dev_lookup>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 47                	js     801767 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801723:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801727:	75 21                	jne    80174a <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801729:	a1 04 40 80 00       	mov    0x804004,%eax
  80172e:	8b 40 48             	mov    0x48(%eax),%eax
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	53                   	push   %ebx
  801735:	50                   	push   %eax
  801736:	68 cc 2a 80 00       	push   $0x802acc
  80173b:	e8 25 f0 ff ff       	call   800765 <cprintf>
		return -E_INVAL;
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801748:	eb 26                	jmp    801770 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80174a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174d:	8b 52 0c             	mov    0xc(%edx),%edx
  801750:	85 d2                	test   %edx,%edx
  801752:	74 17                	je     80176b <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	ff 75 10             	pushl  0x10(%ebp)
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	50                   	push   %eax
  80175e:	ff d2                	call   *%edx
  801760:	89 c2                	mov    %eax,%edx
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	eb 09                	jmp    801770 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801767:	89 c2                	mov    %eax,%edx
  801769:	eb 05                	jmp    801770 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  80176b:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801770:	89 d0                	mov    %edx,%eax
  801772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <seek>:

int
seek(int fdnum, off_t offset)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80177d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801780:	50                   	push   %eax
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	e8 23 fc ff ff       	call   8013ac <fd_lookup>
  801789:	83 c4 08             	add    $0x8,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 0e                	js     80179e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801790:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
  801796:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 14             	sub    $0x14,%esp
  8017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ad:	50                   	push   %eax
  8017ae:	53                   	push   %ebx
  8017af:	e8 f8 fb ff ff       	call   8013ac <fd_lookup>
  8017b4:	83 c4 08             	add    $0x8,%esp
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	85 c0                	test   %eax,%eax
  8017bb:	78 65                	js     801822 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c3:	50                   	push   %eax
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c7:	ff 30                	pushl  (%eax)
  8017c9:	e8 34 fc ff ff       	call   801402 <dev_lookup>
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 44                	js     801819 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017dc:	75 21                	jne    8017ff <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017de:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017e3:	8b 40 48             	mov    0x48(%eax),%eax
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	53                   	push   %ebx
  8017ea:	50                   	push   %eax
  8017eb:	68 8c 2a 80 00       	push   $0x802a8c
  8017f0:	e8 70 ef ff ff       	call   800765 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8017fd:	eb 23                	jmp    801822 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	8b 52 18             	mov    0x18(%edx),%edx
  801805:	85 d2                	test   %edx,%edx
  801807:	74 14                	je     80181d <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	50                   	push   %eax
  801810:	ff d2                	call   *%edx
  801812:	89 c2                	mov    %eax,%edx
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	eb 09                	jmp    801822 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801819:	89 c2                	mov    %eax,%edx
  80181b:	eb 05                	jmp    801822 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80181d:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  801822:	89 d0                	mov    %edx,%eax
  801824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	53                   	push   %ebx
  80182d:	83 ec 14             	sub    $0x14,%esp
  801830:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801833:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801836:	50                   	push   %eax
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	e8 6d fb ff ff       	call   8013ac <fd_lookup>
  80183f:	83 c4 08             	add    $0x8,%esp
  801842:	89 c2                	mov    %eax,%edx
  801844:	85 c0                	test   %eax,%eax
  801846:	78 58                	js     8018a0 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801848:	83 ec 08             	sub    $0x8,%esp
  80184b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184e:	50                   	push   %eax
  80184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801852:	ff 30                	pushl  (%eax)
  801854:	e8 a9 fb ff ff       	call   801402 <dev_lookup>
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 37                	js     801897 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801863:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801867:	74 32                	je     80189b <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801869:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80186c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801873:	00 00 00 
	stat->st_isdir = 0;
  801876:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80187d:	00 00 00 
	stat->st_dev = dev;
  801880:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	53                   	push   %ebx
  80188a:	ff 75 f0             	pushl  -0x10(%ebp)
  80188d:	ff 50 14             	call   *0x14(%eax)
  801890:	89 c2                	mov    %eax,%edx
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	eb 09                	jmp    8018a0 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801897:	89 c2                	mov    %eax,%edx
  801899:	eb 05                	jmp    8018a0 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  80189b:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018a0:	89 d0                	mov    %edx,%eax
  8018a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 08             	pushl  0x8(%ebp)
  8018b4:	e8 06 02 00 00       	call   801abf <open>
  8018b9:	89 c3                	mov    %eax,%ebx
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	78 1b                	js     8018dd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	50                   	push   %eax
  8018c9:	e8 5b ff ff ff       	call   801829 <fstat>
  8018ce:	89 c6                	mov    %eax,%esi
	close(fd);
  8018d0:	89 1c 24             	mov    %ebx,(%esp)
  8018d3:	e8 fd fb ff ff       	call   8014d5 <close>
	return r;
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	89 f0                	mov    %esi,%eax
}
  8018dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    

008018e4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	56                   	push   %esi
  8018e8:	53                   	push   %ebx
  8018e9:	89 c6                	mov    %eax,%esi
  8018eb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018ed:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018f4:	75 12                	jne    801908 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	6a 01                	push   $0x1
  8018fb:	e8 fc f9 ff ff       	call   8012fc <ipc_find_env>
  801900:	a3 00 40 80 00       	mov    %eax,0x804000
  801905:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801908:	6a 07                	push   $0x7
  80190a:	68 00 50 80 00       	push   $0x805000
  80190f:	56                   	push   %esi
  801910:	ff 35 00 40 80 00    	pushl  0x804000
  801916:	e8 8d f9 ff ff       	call   8012a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80191b:	83 c4 0c             	add    $0xc,%esp
  80191e:	6a 00                	push   $0x0
  801920:	53                   	push   %ebx
  801921:	6a 00                	push   $0x0
  801923:	e8 15 f9 ff ff       	call   80123d <ipc_recv>
}
  801928:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5d                   	pop    %ebp
  80192e:	c3                   	ret    

0080192f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	8b 40 0c             	mov    0xc(%eax),%eax
  80193b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801948:	ba 00 00 00 00       	mov    $0x0,%edx
  80194d:	b8 02 00 00 00       	mov    $0x2,%eax
  801952:	e8 8d ff ff ff       	call   8018e4 <fsipc>
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	8b 40 0c             	mov    0xc(%eax),%eax
  801965:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80196a:	ba 00 00 00 00       	mov    $0x0,%edx
  80196f:	b8 06 00 00 00       	mov    $0x6,%eax
  801974:	e8 6b ff ff ff       	call   8018e4 <fsipc>
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	53                   	push   %ebx
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	8b 40 0c             	mov    0xc(%eax),%eax
  80198b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801990:	ba 00 00 00 00       	mov    $0x0,%edx
  801995:	b8 05 00 00 00       	mov    $0x5,%eax
  80199a:	e8 45 ff ff ff       	call   8018e4 <fsipc>
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 2c                	js     8019cf <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	68 00 50 80 00       	push   $0x805000
  8019ab:	53                   	push   %ebx
  8019ac:	e8 26 f3 ff ff       	call   800cd7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019b1:	a1 80 50 80 00       	mov    0x805080,%eax
  8019b6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019bc:	a1 84 50 80 00       	mov    0x805084,%eax
  8019c1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 08             	sub    $0x8,%esp
  8019da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dd:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019e3:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8019e6:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8019ec:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019f1:	76 22                	jbe    801a15 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8019f3:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8019fa:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 f8 0f 00 00       	push   $0xff8
  801a05:	52                   	push   %edx
  801a06:	68 08 50 80 00       	push   $0x805008
  801a0b:	e8 5a f4 ff ff       	call   800e6a <memmove>
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	eb 17                	jmp    801a2c <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  801a15:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	50                   	push   %eax
  801a1e:	52                   	push   %edx
  801a1f:	68 08 50 80 00       	push   $0x805008
  801a24:	e8 41 f4 ff ff       	call   800e6a <memmove>
  801a29:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801a2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a31:	b8 04 00 00 00       	mov    $0x4,%eax
  801a36:	e8 a9 fe ff ff       	call   8018e4 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a50:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	b8 03 00 00 00       	mov    $0x3,%eax
  801a60:	e8 7f fe ff ff       	call   8018e4 <fsipc>
  801a65:	89 c3                	mov    %eax,%ebx
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 4b                	js     801ab6 <devfile_read+0x79>
		return r;
	assert(r <= n);
  801a6b:	39 c6                	cmp    %eax,%esi
  801a6d:	73 16                	jae    801a85 <devfile_read+0x48>
  801a6f:	68 fc 2a 80 00       	push   $0x802afc
  801a74:	68 03 2b 80 00       	push   $0x802b03
  801a79:	6a 7c                	push   $0x7c
  801a7b:	68 18 2b 80 00       	push   $0x802b18
  801a80:	e8 07 ec ff ff       	call   80068c <_panic>
	assert(r <= PGSIZE);
  801a85:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a8a:	7e 16                	jle    801aa2 <devfile_read+0x65>
  801a8c:	68 23 2b 80 00       	push   $0x802b23
  801a91:	68 03 2b 80 00       	push   $0x802b03
  801a96:	6a 7d                	push   $0x7d
  801a98:	68 18 2b 80 00       	push   $0x802b18
  801a9d:	e8 ea eb ff ff       	call   80068c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	50                   	push   %eax
  801aa6:	68 00 50 80 00       	push   $0x805000
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	e8 b7 f3 ff ff       	call   800e6a <memmove>
	return r;
  801ab3:	83 c4 10             	add    $0x10,%esp
}
  801ab6:	89 d8                	mov    %ebx,%eax
  801ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	53                   	push   %ebx
  801ac3:	83 ec 20             	sub    $0x20,%esp
  801ac6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ac9:	53                   	push   %ebx
  801aca:	e8 cf f1 ff ff       	call   800c9e <strlen>
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad7:	7f 67                	jg     801b40 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adf:	50                   	push   %eax
  801ae0:	e8 78 f8 ff ff       	call   80135d <fd_alloc>
  801ae5:	83 c4 10             	add    $0x10,%esp
		return r;
  801ae8:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 57                	js     801b45 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	53                   	push   %ebx
  801af2:	68 00 50 80 00       	push   $0x805000
  801af7:	e8 db f1 ff ff       	call   800cd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aff:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b07:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0c:	e8 d3 fd ff ff       	call   8018e4 <fsipc>
  801b11:	89 c3                	mov    %eax,%ebx
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	85 c0                	test   %eax,%eax
  801b18:	79 14                	jns    801b2e <open+0x6f>
		fd_close(fd, 0);
  801b1a:	83 ec 08             	sub    $0x8,%esp
  801b1d:	6a 00                	push   $0x0
  801b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b22:	e8 2e f9 ff ff       	call   801455 <fd_close>
		return r;
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	89 da                	mov    %ebx,%edx
  801b2c:	eb 17                	jmp    801b45 <open+0x86>
	}

	return fd2num(fd);
  801b2e:	83 ec 0c             	sub    $0xc,%esp
  801b31:	ff 75 f4             	pushl  -0xc(%ebp)
  801b34:	e8 fc f7 ff ff       	call   801335 <fd2num>
  801b39:	89 c2                	mov    %eax,%edx
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	eb 05                	jmp    801b45 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b40:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b45:	89 d0                	mov    %edx,%eax
  801b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b52:	ba 00 00 00 00       	mov    $0x0,%edx
  801b57:	b8 08 00 00 00       	mov    $0x8,%eax
  801b5c:	e8 83 fd ff ff       	call   8018e4 <fsipc>
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b6b:	83 ec 0c             	sub    $0xc,%esp
  801b6e:	ff 75 08             	pushl  0x8(%ebp)
  801b71:	e8 cf f7 ff ff       	call   801345 <fd2data>
  801b76:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b78:	83 c4 08             	add    $0x8,%esp
  801b7b:	68 2f 2b 80 00       	push   $0x802b2f
  801b80:	53                   	push   %ebx
  801b81:	e8 51 f1 ff ff       	call   800cd7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b86:	8b 46 04             	mov    0x4(%esi),%eax
  801b89:	2b 06                	sub    (%esi),%eax
  801b8b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b91:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b98:	00 00 00 
	stat->st_dev = &devpipe;
  801b9b:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801ba2:	30 80 00 
	return 0;
}
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  801baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5e                   	pop    %esi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 0c             	sub    $0xc,%esp
  801bb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bbb:	53                   	push   %ebx
  801bbc:	6a 00                	push   $0x0
  801bbe:	e8 a7 f5 ff ff       	call   80116a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bc3:	89 1c 24             	mov    %ebx,(%esp)
  801bc6:	e8 7a f7 ff ff       	call   801345 <fd2data>
  801bcb:	83 c4 08             	add    $0x8,%esp
  801bce:	50                   	push   %eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	e8 94 f5 ff ff       	call   80116a <sys_page_unmap>
}
  801bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	57                   	push   %edi
  801bdf:	56                   	push   %esi
  801be0:	53                   	push   %ebx
  801be1:	83 ec 1c             	sub    $0x1c,%esp
  801be4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801be7:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801be9:	a1 04 40 80 00       	mov    0x804004,%eax
  801bee:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801bf1:	83 ec 0c             	sub    $0xc,%esp
  801bf4:	ff 75 e0             	pushl  -0x20(%ebp)
  801bf7:	e8 46 04 00 00       	call   802042 <pageref>
  801bfc:	89 c3                	mov    %eax,%ebx
  801bfe:	89 3c 24             	mov    %edi,(%esp)
  801c01:	e8 3c 04 00 00       	call   802042 <pageref>
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	39 c3                	cmp    %eax,%ebx
  801c0b:	0f 94 c1             	sete   %cl
  801c0e:	0f b6 c9             	movzbl %cl,%ecx
  801c11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801c14:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c1a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c1d:	39 ce                	cmp    %ecx,%esi
  801c1f:	74 1b                	je     801c3c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801c21:	39 c3                	cmp    %eax,%ebx
  801c23:	75 c4                	jne    801be9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c25:	8b 42 58             	mov    0x58(%edx),%eax
  801c28:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c2b:	50                   	push   %eax
  801c2c:	56                   	push   %esi
  801c2d:	68 36 2b 80 00       	push   $0x802b36
  801c32:	e8 2e eb ff ff       	call   800765 <cprintf>
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	eb ad                	jmp    801be9 <_pipeisclosed+0xe>
	}
}
  801c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c42:	5b                   	pop    %ebx
  801c43:	5e                   	pop    %esi
  801c44:	5f                   	pop    %edi
  801c45:	5d                   	pop    %ebp
  801c46:	c3                   	ret    

00801c47 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	57                   	push   %edi
  801c4b:	56                   	push   %esi
  801c4c:	53                   	push   %ebx
  801c4d:	83 ec 28             	sub    $0x28,%esp
  801c50:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801c53:	56                   	push   %esi
  801c54:	e8 ec f6 ff ff       	call   801345 <fd2data>
  801c59:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c63:	eb 4b                	jmp    801cb0 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801c65:	89 da                	mov    %ebx,%edx
  801c67:	89 f0                	mov    %esi,%eax
  801c69:	e8 6d ff ff ff       	call   801bdb <_pipeisclosed>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	75 48                	jne    801cba <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801c72:	e8 82 f4 ff ff       	call   8010f9 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c77:	8b 43 04             	mov    0x4(%ebx),%eax
  801c7a:	8b 0b                	mov    (%ebx),%ecx
  801c7c:	8d 51 20             	lea    0x20(%ecx),%edx
  801c7f:	39 d0                	cmp    %edx,%eax
  801c81:	73 e2                	jae    801c65 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c86:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c8a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c8d:	89 c2                	mov    %eax,%edx
  801c8f:	c1 fa 1f             	sar    $0x1f,%edx
  801c92:	89 d1                	mov    %edx,%ecx
  801c94:	c1 e9 1b             	shr    $0x1b,%ecx
  801c97:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c9a:	83 e2 1f             	and    $0x1f,%edx
  801c9d:	29 ca                	sub    %ecx,%edx
  801c9f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ca3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ca7:	83 c0 01             	add    $0x1,%eax
  801caa:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cad:	83 c7 01             	add    $0x1,%edi
  801cb0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cb3:	75 c2                	jne    801c77 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb8:	eb 05                	jmp    801cbf <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc2:	5b                   	pop    %ebx
  801cc3:	5e                   	pop    %esi
  801cc4:	5f                   	pop    %edi
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    

00801cc7 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	57                   	push   %edi
  801ccb:	56                   	push   %esi
  801ccc:	53                   	push   %ebx
  801ccd:	83 ec 18             	sub    $0x18,%esp
  801cd0:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801cd3:	57                   	push   %edi
  801cd4:	e8 6c f6 ff ff       	call   801345 <fd2data>
  801cd9:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801cdb:	83 c4 10             	add    $0x10,%esp
  801cde:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ce3:	eb 3d                	jmp    801d22 <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ce5:	85 db                	test   %ebx,%ebx
  801ce7:	74 04                	je     801ced <devpipe_read+0x26>
				return i;
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	eb 44                	jmp    801d31 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ced:	89 f2                	mov    %esi,%edx
  801cef:	89 f8                	mov    %edi,%eax
  801cf1:	e8 e5 fe ff ff       	call   801bdb <_pipeisclosed>
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	75 32                	jne    801d2c <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801cfa:	e8 fa f3 ff ff       	call   8010f9 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801cff:	8b 06                	mov    (%esi),%eax
  801d01:	3b 46 04             	cmp    0x4(%esi),%eax
  801d04:	74 df                	je     801ce5 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d06:	99                   	cltd   
  801d07:	c1 ea 1b             	shr    $0x1b,%edx
  801d0a:	01 d0                	add    %edx,%eax
  801d0c:	83 e0 1f             	and    $0x1f,%eax
  801d0f:	29 d0                	sub    %edx,%eax
  801d11:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d19:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801d1c:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801d1f:	83 c3 01             	add    $0x1,%ebx
  801d22:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d25:	75 d8                	jne    801cff <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801d27:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2a:	eb 05                	jmp    801d31 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d44:	50                   	push   %eax
  801d45:	e8 13 f6 ff ff       	call   80135d <fd_alloc>
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	89 c2                	mov    %eax,%edx
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	0f 88 2c 01 00 00    	js     801e83 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	68 07 04 00 00       	push   $0x407
  801d5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d62:	6a 00                	push   $0x0
  801d64:	e8 b7 f3 ff ff       	call   801120 <sys_page_alloc>
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	89 c2                	mov    %eax,%edx
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	0f 88 0d 01 00 00    	js     801e83 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d7c:	50                   	push   %eax
  801d7d:	e8 db f5 ff ff       	call   80135d <fd_alloc>
  801d82:	89 c3                	mov    %eax,%ebx
  801d84:	83 c4 10             	add    $0x10,%esp
  801d87:	85 c0                	test   %eax,%eax
  801d89:	0f 88 e2 00 00 00    	js     801e71 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d8f:	83 ec 04             	sub    $0x4,%esp
  801d92:	68 07 04 00 00       	push   $0x407
  801d97:	ff 75 f0             	pushl  -0x10(%ebp)
  801d9a:	6a 00                	push   $0x0
  801d9c:	e8 7f f3 ff ff       	call   801120 <sys_page_alloc>
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	85 c0                	test   %eax,%eax
  801da8:	0f 88 c3 00 00 00    	js     801e71 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	ff 75 f4             	pushl  -0xc(%ebp)
  801db4:	e8 8c f5 ff ff       	call   801345 <fd2data>
  801db9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbb:	83 c4 0c             	add    $0xc,%esp
  801dbe:	68 07 04 00 00       	push   $0x407
  801dc3:	50                   	push   %eax
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 55 f3 ff ff       	call   801120 <sys_page_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	0f 88 89 00 00 00    	js     801e61 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dde:	e8 62 f5 ff ff       	call   801345 <fd2data>
  801de3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dea:	50                   	push   %eax
  801deb:	6a 00                	push   $0x0
  801ded:	56                   	push   %esi
  801dee:	6a 00                	push   $0x0
  801df0:	e8 4f f3 ff ff       	call   801144 <sys_page_map>
  801df5:	89 c3                	mov    %eax,%ebx
  801df7:	83 c4 20             	add    $0x20,%esp
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 55                	js     801e53 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801dfe:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e13:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e21:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2e:	e8 02 f5 ff ff       	call   801335 <fd2num>
  801e33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e36:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e38:	83 c4 04             	add    $0x4,%esp
  801e3b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3e:	e8 f2 f4 ff ff       	call   801335 <fd2num>
  801e43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e46:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e51:	eb 30                	jmp    801e83 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801e53:	83 ec 08             	sub    $0x8,%esp
  801e56:	56                   	push   %esi
  801e57:	6a 00                	push   $0x0
  801e59:	e8 0c f3 ff ff       	call   80116a <sys_page_unmap>
  801e5e:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801e61:	83 ec 08             	sub    $0x8,%esp
  801e64:	ff 75 f0             	pushl  -0x10(%ebp)
  801e67:	6a 00                	push   $0x0
  801e69:	e8 fc f2 ff ff       	call   80116a <sys_page_unmap>
  801e6e:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801e71:	83 ec 08             	sub    $0x8,%esp
  801e74:	ff 75 f4             	pushl  -0xc(%ebp)
  801e77:	6a 00                	push   $0x0
  801e79:	e8 ec f2 ff ff       	call   80116a <sys_page_unmap>
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801e83:	89 d0                	mov    %edx,%eax
  801e85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e88:	5b                   	pop    %ebx
  801e89:	5e                   	pop    %esi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    

00801e8c <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e95:	50                   	push   %eax
  801e96:	ff 75 08             	pushl  0x8(%ebp)
  801e99:	e8 0e f5 ff ff       	call   8013ac <fd_lookup>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 18                	js     801ebd <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	ff 75 f4             	pushl  -0xc(%ebp)
  801eab:	e8 95 f4 ff ff       	call   801345 <fd2data>
	return _pipeisclosed(fd, p);
  801eb0:	89 c2                	mov    %eax,%edx
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	e8 21 fd ff ff       	call   801bdb <_pipeisclosed>
  801eba:	83 c4 10             	add    $0x10,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    

00801ec9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ecf:	68 4e 2b 80 00       	push   $0x802b4e
  801ed4:	ff 75 0c             	pushl  0xc(%ebp)
  801ed7:	e8 fb ed ff ff       	call   800cd7 <strcpy>
	return 0;
}
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	57                   	push   %edi
  801ee7:	56                   	push   %esi
  801ee8:	53                   	push   %ebx
  801ee9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801eef:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ef4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801efa:	eb 2d                	jmp    801f29 <devcons_write+0x46>
		m = n - tot;
  801efc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eff:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801f01:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801f04:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801f09:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	53                   	push   %ebx
  801f10:	03 45 0c             	add    0xc(%ebp),%eax
  801f13:	50                   	push   %eax
  801f14:	57                   	push   %edi
  801f15:	e8 50 ef ff ff       	call   800e6a <memmove>
		sys_cputs(buf, m);
  801f1a:	83 c4 08             	add    $0x8,%esp
  801f1d:	53                   	push   %ebx
  801f1e:	57                   	push   %edi
  801f1f:	e8 45 f1 ff ff       	call   801069 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f24:	01 de                	add    %ebx,%esi
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	89 f0                	mov    %esi,%eax
  801f2b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f2e:	72 cc                	jb     801efc <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    

00801f38 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	83 ec 08             	sub    $0x8,%esp
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f47:	74 2a                	je     801f73 <devcons_read+0x3b>
  801f49:	eb 05                	jmp    801f50 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f4b:	e8 a9 f1 ff ff       	call   8010f9 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801f50:	e8 3a f1 ff ff       	call   80108f <sys_cgetc>
  801f55:	85 c0                	test   %eax,%eax
  801f57:	74 f2                	je     801f4b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 16                	js     801f73 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801f5d:	83 f8 04             	cmp    $0x4,%eax
  801f60:	74 0c                	je     801f6e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	88 02                	mov    %al,(%edx)
	return 1;
  801f67:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6c:	eb 05                	jmp    801f73 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f6e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f81:	6a 01                	push   $0x1
  801f83:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f86:	50                   	push   %eax
  801f87:	e8 dd f0 ff ff       	call   801069 <sys_cputs>
}
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <getchar>:

int
getchar(void)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f97:	6a 01                	push   $0x1
  801f99:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f9c:	50                   	push   %eax
  801f9d:	6a 00                	push   $0x0
  801f9f:	e8 6d f6 ff ff       	call   801611 <read>
	if (r < 0)
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	78 0f                	js     801fba <getchar+0x29>
		return r;
	if (r < 1)
  801fab:	85 c0                	test   %eax,%eax
  801fad:	7e 06                	jle    801fb5 <getchar+0x24>
		return -E_EOF;
	return c;
  801faf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801fb3:	eb 05                	jmp    801fba <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801fb5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc5:	50                   	push   %eax
  801fc6:	ff 75 08             	pushl  0x8(%ebp)
  801fc9:	e8 de f3 ff ff       	call   8013ac <fd_lookup>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	78 11                	js     801fe6 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801fde:	39 10                	cmp    %edx,(%eax)
  801fe0:	0f 94 c0             	sete   %al
  801fe3:	0f b6 c0             	movzbl %al,%eax
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <opencons>:

int
opencons(void)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff1:	50                   	push   %eax
  801ff2:	e8 66 f3 ff ff       	call   80135d <fd_alloc>
  801ff7:	83 c4 10             	add    $0x10,%esp
		return r;
  801ffa:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 3e                	js     80203e <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	68 07 04 00 00       	push   $0x407
  802008:	ff 75 f4             	pushl  -0xc(%ebp)
  80200b:	6a 00                	push   $0x0
  80200d:	e8 0e f1 ff ff       	call   801120 <sys_page_alloc>
  802012:	83 c4 10             	add    $0x10,%esp
		return r;
  802015:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802017:	85 c0                	test   %eax,%eax
  802019:	78 23                	js     80203e <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80201b:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	50                   	push   %eax
  802034:	e8 fc f2 ff ff       	call   801335 <fd2num>
  802039:	89 c2                	mov    %eax,%edx
  80203b:	83 c4 10             	add    $0x10,%esp
}
  80203e:	89 d0                	mov    %edx,%eax
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802048:	89 d0                	mov    %edx,%eax
  80204a:	c1 e8 16             	shr    $0x16,%eax
  80204d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802059:	f6 c1 01             	test   $0x1,%cl
  80205c:	74 1d                	je     80207b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80205e:	c1 ea 0c             	shr    $0xc,%edx
  802061:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802068:	f6 c2 01             	test   $0x1,%dl
  80206b:	74 0e                	je     80207b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80206d:	c1 ea 0c             	shr    $0xc,%edx
  802070:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802077:	ef 
  802078:	0f b7 c0             	movzwl %ax,%eax
}
  80207b:	5d                   	pop    %ebp
  80207c:	c3                   	ret    
  80207d:	66 90                	xchg   %ax,%ax
  80207f:	90                   	nop

00802080 <__udivdi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
  802087:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80208b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80208f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	85 f6                	test   %esi,%esi
  802099:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80209d:	89 ca                	mov    %ecx,%edx
  80209f:	89 f8                	mov    %edi,%eax
  8020a1:	75 3d                	jne    8020e0 <__udivdi3+0x60>
  8020a3:	39 cf                	cmp    %ecx,%edi
  8020a5:	0f 87 c5 00 00 00    	ja     802170 <__udivdi3+0xf0>
  8020ab:	85 ff                	test   %edi,%edi
  8020ad:	89 fd                	mov    %edi,%ebp
  8020af:	75 0b                	jne    8020bc <__udivdi3+0x3c>
  8020b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b6:	31 d2                	xor    %edx,%edx
  8020b8:	f7 f7                	div    %edi
  8020ba:	89 c5                	mov    %eax,%ebp
  8020bc:	89 c8                	mov    %ecx,%eax
  8020be:	31 d2                	xor    %edx,%edx
  8020c0:	f7 f5                	div    %ebp
  8020c2:	89 c1                	mov    %eax,%ecx
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	89 cf                	mov    %ecx,%edi
  8020c8:	f7 f5                	div    %ebp
  8020ca:	89 c3                	mov    %eax,%ebx
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	89 fa                	mov    %edi,%edx
  8020d0:	83 c4 1c             	add    $0x1c,%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5f                   	pop    %edi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    
  8020d8:	90                   	nop
  8020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	39 ce                	cmp    %ecx,%esi
  8020e2:	77 74                	ja     802158 <__udivdi3+0xd8>
  8020e4:	0f bd fe             	bsr    %esi,%edi
  8020e7:	83 f7 1f             	xor    $0x1f,%edi
  8020ea:	0f 84 98 00 00 00    	je     802188 <__udivdi3+0x108>
  8020f0:	bb 20 00 00 00       	mov    $0x20,%ebx
  8020f5:	89 f9                	mov    %edi,%ecx
  8020f7:	89 c5                	mov    %eax,%ebp
  8020f9:	29 fb                	sub    %edi,%ebx
  8020fb:	d3 e6                	shl    %cl,%esi
  8020fd:	89 d9                	mov    %ebx,%ecx
  8020ff:	d3 ed                	shr    %cl,%ebp
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e0                	shl    %cl,%eax
  802105:	09 ee                	or     %ebp,%esi
  802107:	89 d9                	mov    %ebx,%ecx
  802109:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80210d:	89 d5                	mov    %edx,%ebp
  80210f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802113:	d3 ed                	shr    %cl,%ebp
  802115:	89 f9                	mov    %edi,%ecx
  802117:	d3 e2                	shl    %cl,%edx
  802119:	89 d9                	mov    %ebx,%ecx
  80211b:	d3 e8                	shr    %cl,%eax
  80211d:	09 c2                	or     %eax,%edx
  80211f:	89 d0                	mov    %edx,%eax
  802121:	89 ea                	mov    %ebp,%edx
  802123:	f7 f6                	div    %esi
  802125:	89 d5                	mov    %edx,%ebp
  802127:	89 c3                	mov    %eax,%ebx
  802129:	f7 64 24 0c          	mull   0xc(%esp)
  80212d:	39 d5                	cmp    %edx,%ebp
  80212f:	72 10                	jb     802141 <__udivdi3+0xc1>
  802131:	8b 74 24 08          	mov    0x8(%esp),%esi
  802135:	89 f9                	mov    %edi,%ecx
  802137:	d3 e6                	shl    %cl,%esi
  802139:	39 c6                	cmp    %eax,%esi
  80213b:	73 07                	jae    802144 <__udivdi3+0xc4>
  80213d:	39 d5                	cmp    %edx,%ebp
  80213f:	75 03                	jne    802144 <__udivdi3+0xc4>
  802141:	83 eb 01             	sub    $0x1,%ebx
  802144:	31 ff                	xor    %edi,%edi
  802146:	89 d8                	mov    %ebx,%eax
  802148:	89 fa                	mov    %edi,%edx
  80214a:	83 c4 1c             	add    $0x1c,%esp
  80214d:	5b                   	pop    %ebx
  80214e:	5e                   	pop    %esi
  80214f:	5f                   	pop    %edi
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    
  802152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802158:	31 ff                	xor    %edi,%edi
  80215a:	31 db                	xor    %ebx,%ebx
  80215c:	89 d8                	mov    %ebx,%eax
  80215e:	89 fa                	mov    %edi,%edx
  802160:	83 c4 1c             	add    $0x1c,%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5f                   	pop    %edi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    
  802168:	90                   	nop
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 d8                	mov    %ebx,%eax
  802172:	f7 f7                	div    %edi
  802174:	31 ff                	xor    %edi,%edi
  802176:	89 c3                	mov    %eax,%ebx
  802178:	89 d8                	mov    %ebx,%eax
  80217a:	89 fa                	mov    %edi,%edx
  80217c:	83 c4 1c             	add    $0x1c,%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5f                   	pop    %edi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    
  802184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802188:	39 ce                	cmp    %ecx,%esi
  80218a:	72 0c                	jb     802198 <__udivdi3+0x118>
  80218c:	31 db                	xor    %ebx,%ebx
  80218e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802192:	0f 87 34 ff ff ff    	ja     8020cc <__udivdi3+0x4c>
  802198:	bb 01 00 00 00       	mov    $0x1,%ebx
  80219d:	e9 2a ff ff ff       	jmp    8020cc <__udivdi3+0x4c>
  8021a2:	66 90                	xchg   %ax,%ax
  8021a4:	66 90                	xchg   %ax,%ax
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	66 90                	xchg   %ax,%ax
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	66 90                	xchg   %ax,%ax
  8021ae:	66 90                	xchg   %ax,%ax

008021b0 <__umoddi3>:
  8021b0:	55                   	push   %ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8021bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021c7:	85 d2                	test   %edx,%edx
  8021c9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021d1:	89 f3                	mov    %esi,%ebx
  8021d3:	89 3c 24             	mov    %edi,(%esp)
  8021d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021da:	75 1c                	jne    8021f8 <__umoddi3+0x48>
  8021dc:	39 f7                	cmp    %esi,%edi
  8021de:	76 50                	jbe    802230 <__umoddi3+0x80>
  8021e0:	89 c8                	mov    %ecx,%eax
  8021e2:	89 f2                	mov    %esi,%edx
  8021e4:	f7 f7                	div    %edi
  8021e6:	89 d0                	mov    %edx,%eax
  8021e8:	31 d2                	xor    %edx,%edx
  8021ea:	83 c4 1c             	add    $0x1c,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
  8021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	89 d0                	mov    %edx,%eax
  8021fc:	77 52                	ja     802250 <__umoddi3+0xa0>
  8021fe:	0f bd ea             	bsr    %edx,%ebp
  802201:	83 f5 1f             	xor    $0x1f,%ebp
  802204:	75 5a                	jne    802260 <__umoddi3+0xb0>
  802206:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80220a:	0f 82 e0 00 00 00    	jb     8022f0 <__umoddi3+0x140>
  802210:	39 0c 24             	cmp    %ecx,(%esp)
  802213:	0f 86 d7 00 00 00    	jbe    8022f0 <__umoddi3+0x140>
  802219:	8b 44 24 08          	mov    0x8(%esp),%eax
  80221d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	85 ff                	test   %edi,%edi
  802232:	89 fd                	mov    %edi,%ebp
  802234:	75 0b                	jne    802241 <__umoddi3+0x91>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f7                	div    %edi
  80223f:	89 c5                	mov    %eax,%ebp
  802241:	89 f0                	mov    %esi,%eax
  802243:	31 d2                	xor    %edx,%edx
  802245:	f7 f5                	div    %ebp
  802247:	89 c8                	mov    %ecx,%eax
  802249:	f7 f5                	div    %ebp
  80224b:	89 d0                	mov    %edx,%eax
  80224d:	eb 99                	jmp    8021e8 <__umoddi3+0x38>
  80224f:	90                   	nop
  802250:	89 c8                	mov    %ecx,%eax
  802252:	89 f2                	mov    %esi,%edx
  802254:	83 c4 1c             	add    $0x1c,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5f                   	pop    %edi
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    
  80225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802260:	8b 34 24             	mov    (%esp),%esi
  802263:	bf 20 00 00 00       	mov    $0x20,%edi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	29 ef                	sub    %ebp,%edi
  80226c:	d3 e0                	shl    %cl,%eax
  80226e:	89 f9                	mov    %edi,%ecx
  802270:	89 f2                	mov    %esi,%edx
  802272:	d3 ea                	shr    %cl,%edx
  802274:	89 e9                	mov    %ebp,%ecx
  802276:	09 c2                	or     %eax,%edx
  802278:	89 d8                	mov    %ebx,%eax
  80227a:	89 14 24             	mov    %edx,(%esp)
  80227d:	89 f2                	mov    %esi,%edx
  80227f:	d3 e2                	shl    %cl,%edx
  802281:	89 f9                	mov    %edi,%ecx
  802283:	89 54 24 04          	mov    %edx,0x4(%esp)
  802287:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80228b:	d3 e8                	shr    %cl,%eax
  80228d:	89 e9                	mov    %ebp,%ecx
  80228f:	89 c6                	mov    %eax,%esi
  802291:	d3 e3                	shl    %cl,%ebx
  802293:	89 f9                	mov    %edi,%ecx
  802295:	89 d0                	mov    %edx,%eax
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	09 d8                	or     %ebx,%eax
  80229d:	89 d3                	mov    %edx,%ebx
  80229f:	89 f2                	mov    %esi,%edx
  8022a1:	f7 34 24             	divl   (%esp)
  8022a4:	89 d6                	mov    %edx,%esi
  8022a6:	d3 e3                	shl    %cl,%ebx
  8022a8:	f7 64 24 04          	mull   0x4(%esp)
  8022ac:	39 d6                	cmp    %edx,%esi
  8022ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022b2:	89 d1                	mov    %edx,%ecx
  8022b4:	89 c3                	mov    %eax,%ebx
  8022b6:	72 08                	jb     8022c0 <__umoddi3+0x110>
  8022b8:	75 11                	jne    8022cb <__umoddi3+0x11b>
  8022ba:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8022be:	73 0b                	jae    8022cb <__umoddi3+0x11b>
  8022c0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8022c4:	1b 14 24             	sbb    (%esp),%edx
  8022c7:	89 d1                	mov    %edx,%ecx
  8022c9:	89 c3                	mov    %eax,%ebx
  8022cb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022cf:	29 da                	sub    %ebx,%edx
  8022d1:	19 ce                	sbb    %ecx,%esi
  8022d3:	89 f9                	mov    %edi,%ecx
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	d3 e0                	shl    %cl,%eax
  8022d9:	89 e9                	mov    %ebp,%ecx
  8022db:	d3 ea                	shr    %cl,%edx
  8022dd:	89 e9                	mov    %ebp,%ecx
  8022df:	d3 ee                	shr    %cl,%esi
  8022e1:	09 d0                	or     %edx,%eax
  8022e3:	89 f2                	mov    %esi,%edx
  8022e5:	83 c4 1c             	add    $0x1c,%esp
  8022e8:	5b                   	pop    %ebx
  8022e9:	5e                   	pop    %esi
  8022ea:	5f                   	pop    %edi
  8022eb:	5d                   	pop    %ebp
  8022ec:	c3                   	ret    
  8022ed:	8d 76 00             	lea    0x0(%esi),%esi
  8022f0:	29 f9                	sub    %edi,%ecx
  8022f2:	19 d6                	sbb    %edx,%esi
  8022f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022fc:	e9 18 ff ff ff       	jmp    802219 <__umoddi3+0x69>
