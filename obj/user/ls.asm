
obj/user/ls.debug:     formato del fichero elf32-i386


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
  80002c:	e8 93 02 00 00       	call   8002c4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 22 22 80 00       	push   $0x802222
  80005f:	e8 f1 18 00 00       	call   801955 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 3a                	je     8000a5 <ls1+0x72>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 88 22 80 00       	mov    $0x802288,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	74 1e                	je     800093 <ls1+0x60>
  800075:	83 ec 0c             	sub    $0xc,%esp
  800078:	53                   	push   %ebx
  800079:	e8 bc 08 00 00       	call   80093a <strlen>
  80007e:	83 c4 10             	add    $0x10,%esp
			sep = "/";
		else
			sep = "";
  800081:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  800086:	ba 88 22 80 00       	mov    $0x802288,%edx
  80008b:	b8 20 22 80 00       	mov    $0x802220,%eax
  800090:	0f 44 c2             	cmove  %edx,%eax
		printf("%s%s", prefix, sep);
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	50                   	push   %eax
  800097:	53                   	push   %ebx
  800098:	68 2b 22 80 00       	push   $0x80222b
  80009d:	e8 b3 18 00 00       	call   801955 <printf>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  8000a5:	83 ec 08             	sub    $0x8,%esp
  8000a8:	ff 75 14             	pushl  0x14(%ebp)
  8000ab:	68 b5 26 80 00       	push   $0x8026b5
  8000b0:	e8 a0 18 00 00       	call   801955 <printf>
	if(flag['F'] && isdir)
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000bf:	74 16                	je     8000d7 <ls1+0xa4>
  8000c1:	89 f0                	mov    %esi,%eax
  8000c3:	84 c0                	test   %al,%al
  8000c5:	74 10                	je     8000d7 <ls1+0xa4>
		printf("/");
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 20 22 80 00       	push   $0x802220
  8000cf:	e8 81 18 00 00       	call   801955 <printf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	printf("\n");
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	68 87 22 80 00       	push   $0x802287
  8000df:	e8 71 18 00 00       	call   801955 <printf>
}
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5d                   	pop    %ebp
  8000ed:	c3                   	ret    

008000ee <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	57                   	push   %edi
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
  8000f4:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fa:	8b 7d 08             	mov    0x8(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  8000fd:	6a 00                	push   $0x0
  8000ff:	57                   	push   %edi
  800100:	e8 b2 16 00 00       	call   8017b7 <open>
  800105:	89 c3                	mov    %eax,%ebx
  800107:	83 c4 10             	add    $0x10,%esp
  80010a:	85 c0                	test   %eax,%eax
  80010c:	79 41                	jns    80014f <lsdir+0x61>
		panic("open %s: %e", path, fd);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	57                   	push   %edi
  800113:	68 30 22 80 00       	push   $0x802230
  800118:	6a 1d                	push   $0x1d
  80011a:	68 3c 22 80 00       	push   $0x80223c
  80011f:	e8 04 02 00 00       	call   800328 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800124:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80012b:	74 28                	je     800155 <lsdir+0x67>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80012d:	56                   	push   %esi
  80012e:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800134:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  80013b:	0f 94 c0             	sete   %al
  80013e:	0f b6 c0             	movzbl %al,%eax
  800141:	50                   	push   %eax
  800142:	ff 75 0c             	pushl  0xc(%ebp)
  800145:	e8 e9 fe ff ff       	call   800033 <ls1>
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	eb 06                	jmp    800155 <lsdir+0x67>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80014f:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 00 01 00 00       	push   $0x100
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	e8 36 12 00 00       	call   80139a <readn>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	3d 00 01 00 00       	cmp    $0x100,%eax
  80016c:	74 b6                	je     800124 <lsdir+0x36>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80016e:	85 c0                	test   %eax,%eax
  800170:	7e 12                	jle    800184 <lsdir+0x96>
		panic("short read in directory %s", path);
  800172:	57                   	push   %edi
  800173:	68 46 22 80 00       	push   $0x802246
  800178:	6a 22                	push   $0x22
  80017a:	68 3c 22 80 00       	push   $0x80223c
  80017f:	e8 a4 01 00 00       	call   800328 <_panic>
	if (n < 0)
  800184:	85 c0                	test   %eax,%eax
  800186:	79 16                	jns    80019e <lsdir+0xb0>
		panic("error reading directory %s: %e", path, n);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	50                   	push   %eax
  80018c:	57                   	push   %edi
  80018d:	68 8c 22 80 00       	push   $0x80228c
  800192:	6a 24                	push   $0x24
  800194:	68 3c 22 80 00       	push   $0x80223c
  800199:	e8 8a 01 00 00       	call   800328 <_panic>
}
  80019e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	53                   	push   %ebx
  8001aa:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  8001b3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	53                   	push   %ebx
  8001bb:	e8 df 13 00 00       	call   80159f <stat>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	79 16                	jns    8001dd <ls+0x37>
		panic("stat %s: %e", path, r);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	50                   	push   %eax
  8001cb:	53                   	push   %ebx
  8001cc:	68 61 22 80 00       	push   $0x802261
  8001d1:	6a 0f                	push   $0xf
  8001d3:	68 3c 22 80 00       	push   $0x80223c
  8001d8:	e8 4b 01 00 00       	call   800328 <_panic>
	if (st.st_isdir && !flag['d'])
  8001dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e0:	85 c0                	test   %eax,%eax
  8001e2:	74 1a                	je     8001fe <ls+0x58>
  8001e4:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001eb:	75 11                	jne    8001fe <ls+0x58>
		lsdir(path, prefix);
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	ff 75 0c             	pushl  0xc(%ebp)
  8001f3:	53                   	push   %ebx
  8001f4:	e8 f5 fe ff ff       	call   8000ee <lsdir>
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb 17                	jmp    800215 <ls+0x6f>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8001fe:	53                   	push   %ebx
  8001ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800202:	85 c0                	test   %eax,%eax
  800204:	0f 95 c0             	setne  %al
  800207:	0f b6 c0             	movzbl %al,%eax
  80020a:	50                   	push   %eax
  80020b:	6a 00                	push   $0x0
  80020d:	e8 21 fe ff ff       	call   800033 <ls1>
  800212:	83 c4 10             	add    $0x10,%esp
}
  800215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <usage>:
	printf("\n");
}

void
usage(void)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800220:	68 6d 22 80 00       	push   $0x80226d
  800225:	e8 2b 17 00 00       	call   801955 <printf>
	exit();
  80022a:	e8 df 00 00 00       	call   80030e <exit>
}
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <umain>:

void
umain(int argc, char **argv)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
  800239:	83 ec 14             	sub    $0x14,%esp
  80023c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80023f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800242:	50                   	push   %eax
  800243:	56                   	push   %esi
  800244:	8d 45 08             	lea    0x8(%ebp),%eax
  800247:	50                   	push   %eax
  800248:	e8 8c 0c 00 00       	call   800ed9 <argstart>
	while ((i = argnext(&args)) >= 0)
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800253:	eb 1e                	jmp    800273 <umain+0x3f>
		switch (i) {
  800255:	83 f8 64             	cmp    $0x64,%eax
  800258:	74 0a                	je     800264 <umain+0x30>
  80025a:	83 f8 6c             	cmp    $0x6c,%eax
  80025d:	74 05                	je     800264 <umain+0x30>
  80025f:	83 f8 46             	cmp    $0x46,%eax
  800262:	75 0a                	jne    80026e <umain+0x3a>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800264:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  80026b:	01 
			break;
  80026c:	eb 05                	jmp    800273 <umain+0x3f>
		default:
			usage();
  80026e:	e8 a7 ff ff ff       	call   80021a <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	53                   	push   %ebx
  800277:	e8 8d 0c 00 00       	call   800f09 <argnext>
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	85 c0                	test   %eax,%eax
  800281:	79 d2                	jns    800255 <umain+0x21>
  800283:	bb 01 00 00 00       	mov    $0x1,%ebx
			break;
		default:
			usage();
		}

	if (argc == 1)
  800288:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80028c:	75 2a                	jne    8002b8 <umain+0x84>
		ls("/", "");
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	68 88 22 80 00       	push   $0x802288
  800296:	68 20 22 80 00       	push   $0x802220
  80029b:	e8 06 ff ff ff       	call   8001a6 <ls>
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	eb 18                	jmp    8002bd <umain+0x89>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  8002a5:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002a8:	83 ec 08             	sub    $0x8,%esp
  8002ab:	50                   	push   %eax
  8002ac:	50                   	push   %eax
  8002ad:	e8 f4 fe ff ff       	call   8001a6 <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  8002b2:	83 c3 01             	add    $0x1,%ebx
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8002bb:	7c e8                	jl     8002a5 <umain+0x71>
			ls(argv[i], argv[i]);
	}
}
  8002bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c0:	5b                   	pop    %ebx
  8002c1:	5e                   	pop    %esi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
  8002c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8002cf:	e8 9d 0a 00 00       	call   800d71 <sys_getenvid>
	if (id >= 0)
  8002d4:	85 c0                	test   %eax,%eax
  8002d6:	78 12                	js     8002ea <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8002d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ea:	85 db                	test   %ebx,%ebx
  8002ec:	7e 07                	jle    8002f5 <libmain+0x31>
		binaryname = argv[0];
  8002ee:	8b 06                	mov    (%esi),%eax
  8002f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	e8 35 ff ff ff       	call   800234 <umain>

	// exit gracefully
	exit();
  8002ff:	e8 0a 00 00 00       	call   80030e <exit>
}
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800314:	e8 df 0e 00 00       	call   8011f8 <close_all>
	sys_env_destroy(0);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	6a 00                	push   $0x0
  80031e:	e8 2c 0a 00 00       	call   800d4f <sys_env_destroy>
}
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80032d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800330:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800336:	e8 36 0a 00 00       	call   800d71 <sys_getenvid>
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	56                   	push   %esi
  800345:	50                   	push   %eax
  800346:	68 b8 22 80 00       	push   $0x8022b8
  80034b:	e8 b1 00 00 00       	call   800401 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	53                   	push   %ebx
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	e8 54 00 00 00       	call   8003b0 <vcprintf>
	cprintf("\n");
  80035c:	c7 04 24 87 22 80 00 	movl   $0x802287,(%esp)
  800363:	e8 99 00 00 00       	call   800401 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036b:	cc                   	int3   
  80036c:	eb fd                	jmp    80036b <_panic+0x43>

0080036e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	53                   	push   %ebx
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800378:	8b 13                	mov    (%ebx),%edx
  80037a:	8d 42 01             	lea    0x1(%edx),%eax
  80037d:	89 03                	mov    %eax,(%ebx)
  80037f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800382:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800386:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038b:	75 1a                	jne    8003a7 <putch+0x39>
		sys_cputs(b->buf, b->idx);
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	68 ff 00 00 00       	push   $0xff
  800395:	8d 43 08             	lea    0x8(%ebx),%eax
  800398:	50                   	push   %eax
  800399:	e8 67 09 00 00       	call   800d05 <sys_cputs>
		b->idx = 0;
  80039e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a4:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8003a7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c0:	00 00 00 
	b.cnt = 0;
  8003c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003cd:	ff 75 0c             	pushl  0xc(%ebp)
  8003d0:	ff 75 08             	pushl  0x8(%ebp)
  8003d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d9:	50                   	push   %eax
  8003da:	68 6e 03 80 00       	push   $0x80036e
  8003df:	e8 86 01 00 00       	call   80056a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e4:	83 c4 08             	add    $0x8,%esp
  8003e7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003ed:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f3:	50                   	push   %eax
  8003f4:	e8 0c 09 00 00       	call   800d05 <sys_cputs>

	return b.cnt;
}
  8003f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800407:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040a:	50                   	push   %eax
  80040b:	ff 75 08             	pushl  0x8(%ebp)
  80040e:	e8 9d ff ff ff       	call   8003b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800413:	c9                   	leave  
  800414:	c3                   	ret    

00800415 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
  800418:	57                   	push   %edi
  800419:	56                   	push   %esi
  80041a:	53                   	push   %ebx
  80041b:	83 ec 1c             	sub    $0x1c,%esp
  80041e:	89 c7                	mov    %eax,%edi
  800420:	89 d6                	mov    %edx,%esi
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 55 0c             	mov    0xc(%ebp),%edx
  800428:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80042e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800431:	bb 00 00 00 00       	mov    $0x0,%ebx
  800436:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800439:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80043c:	39 d3                	cmp    %edx,%ebx
  80043e:	72 05                	jb     800445 <printnum+0x30>
  800440:	39 45 10             	cmp    %eax,0x10(%ebp)
  800443:	77 45                	ja     80048a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800445:	83 ec 0c             	sub    $0xc,%esp
  800448:	ff 75 18             	pushl  0x18(%ebp)
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800451:	53                   	push   %ebx
  800452:	ff 75 10             	pushl  0x10(%ebp)
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	ff 75 e4             	pushl  -0x1c(%ebp)
  80045b:	ff 75 e0             	pushl  -0x20(%ebp)
  80045e:	ff 75 dc             	pushl  -0x24(%ebp)
  800461:	ff 75 d8             	pushl  -0x28(%ebp)
  800464:	e8 17 1b 00 00       	call   801f80 <__udivdi3>
  800469:	83 c4 18             	add    $0x18,%esp
  80046c:	52                   	push   %edx
  80046d:	50                   	push   %eax
  80046e:	89 f2                	mov    %esi,%edx
  800470:	89 f8                	mov    %edi,%eax
  800472:	e8 9e ff ff ff       	call   800415 <printnum>
  800477:	83 c4 20             	add    $0x20,%esp
  80047a:	eb 18                	jmp    800494 <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	56                   	push   %esi
  800480:	ff 75 18             	pushl  0x18(%ebp)
  800483:	ff d7                	call   *%edi
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	eb 03                	jmp    80048d <printnum+0x78>
  80048a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048d:	83 eb 01             	sub    $0x1,%ebx
  800490:	85 db                	test   %ebx,%ebx
  800492:	7f e8                	jg     80047c <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	56                   	push   %esi
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049e:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a7:	e8 04 1c 00 00       	call   8020b0 <__umoddi3>
  8004ac:	83 c4 14             	add    $0x14,%esp
  8004af:	0f be 80 db 22 80 00 	movsbl 0x8022db(%eax),%eax
  8004b6:	50                   	push   %eax
  8004b7:	ff d7                	call   *%edi
}
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bf:	5b                   	pop    %ebx
  8004c0:	5e                   	pop    %esi
  8004c1:	5f                   	pop    %edi
  8004c2:	5d                   	pop    %ebp
  8004c3:	c3                   	ret    

008004c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c7:	83 fa 01             	cmp    $0x1,%edx
  8004ca:	7e 0e                	jle    8004da <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004cc:	8b 10                	mov    (%eax),%edx
  8004ce:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004d1:	89 08                	mov    %ecx,(%eax)
  8004d3:	8b 02                	mov    (%edx),%eax
  8004d5:	8b 52 04             	mov    0x4(%edx),%edx
  8004d8:	eb 22                	jmp    8004fc <getuint+0x38>
	else if (lflag)
  8004da:	85 d2                	test   %edx,%edx
  8004dc:	74 10                	je     8004ee <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004de:	8b 10                	mov    (%eax),%edx
  8004e0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004e3:	89 08                	mov    %ecx,(%eax)
  8004e5:	8b 02                	mov    (%edx),%eax
  8004e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ec:	eb 0e                	jmp    8004fc <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004ee:	8b 10                	mov    (%eax),%edx
  8004f0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004f3:	89 08                	mov    %ecx,(%eax)
  8004f5:	8b 02                	mov    (%edx),%eax
  8004f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004fc:	5d                   	pop    %ebp
  8004fd:	c3                   	ret    

008004fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800501:	83 fa 01             	cmp    $0x1,%edx
  800504:	7e 0e                	jle    800514 <getint+0x16>
		return va_arg(*ap, long long);
  800506:	8b 10                	mov    (%eax),%edx
  800508:	8d 4a 08             	lea    0x8(%edx),%ecx
  80050b:	89 08                	mov    %ecx,(%eax)
  80050d:	8b 02                	mov    (%edx),%eax
  80050f:	8b 52 04             	mov    0x4(%edx),%edx
  800512:	eb 1a                	jmp    80052e <getint+0x30>
	else if (lflag)
  800514:	85 d2                	test   %edx,%edx
  800516:	74 0c                	je     800524 <getint+0x26>
		return va_arg(*ap, long);
  800518:	8b 10                	mov    (%eax),%edx
  80051a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80051d:	89 08                	mov    %ecx,(%eax)
  80051f:	8b 02                	mov    (%edx),%eax
  800521:	99                   	cltd   
  800522:	eb 0a                	jmp    80052e <getint+0x30>
	else
		return va_arg(*ap, int);
  800524:	8b 10                	mov    (%eax),%edx
  800526:	8d 4a 04             	lea    0x4(%edx),%ecx
  800529:	89 08                	mov    %ecx,(%eax)
  80052b:	8b 02                	mov    (%edx),%eax
  80052d:	99                   	cltd   
}
  80052e:	5d                   	pop    %ebp
  80052f:	c3                   	ret    

00800530 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800536:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80053a:	8b 10                	mov    (%eax),%edx
  80053c:	3b 50 04             	cmp    0x4(%eax),%edx
  80053f:	73 0a                	jae    80054b <sprintputch+0x1b>
		*b->buf++ = ch;
  800541:	8d 4a 01             	lea    0x1(%edx),%ecx
  800544:	89 08                	mov    %ecx,(%eax)
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	88 02                	mov    %al,(%edx)
}
  80054b:	5d                   	pop    %ebp
  80054c:	c3                   	ret    

0080054d <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80054d:	55                   	push   %ebp
  80054e:	89 e5                	mov    %esp,%ebp
  800550:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800553:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800556:	50                   	push   %eax
  800557:	ff 75 10             	pushl  0x10(%ebp)
  80055a:	ff 75 0c             	pushl  0xc(%ebp)
  80055d:	ff 75 08             	pushl  0x8(%ebp)
  800560:	e8 05 00 00 00       	call   80056a <vprintfmt>
	va_end(ap);
}
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	57                   	push   %edi
  80056e:	56                   	push   %esi
  80056f:	53                   	push   %ebx
  800570:	83 ec 2c             	sub    $0x2c,%esp
  800573:	8b 75 08             	mov    0x8(%ebp),%esi
  800576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800579:	8b 7d 10             	mov    0x10(%ebp),%edi
  80057c:	eb 12                	jmp    800590 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80057e:	85 c0                	test   %eax,%eax
  800580:	0f 84 44 03 00 00    	je     8008ca <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	53                   	push   %ebx
  80058a:	50                   	push   %eax
  80058b:	ff d6                	call   *%esi
  80058d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800590:	83 c7 01             	add    $0x1,%edi
  800593:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800597:	83 f8 25             	cmp    $0x25,%eax
  80059a:	75 e2                	jne    80057e <vprintfmt+0x14>
  80059c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8005a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8005a7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	eb 07                	jmp    8005c3 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8005bf:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8d 47 01             	lea    0x1(%edi),%eax
  8005c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c9:	0f b6 07             	movzbl (%edi),%eax
  8005cc:	0f b6 c8             	movzbl %al,%ecx
  8005cf:	83 e8 23             	sub    $0x23,%eax
  8005d2:	3c 55                	cmp    $0x55,%al
  8005d4:	0f 87 d5 02 00 00    	ja     8008af <vprintfmt+0x345>
  8005da:	0f b6 c0             	movzbl %al,%eax
  8005dd:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
  8005e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005e7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8005eb:	eb d6                	jmp    8005c3 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005f8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005fb:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8005ff:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  800602:	8d 51 d0             	lea    -0x30(%ecx),%edx
  800605:	83 fa 09             	cmp    $0x9,%edx
  800608:	77 39                	ja     800643 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80060a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80060d:	eb e9                	jmp    8005f8 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8d 48 04             	lea    0x4(%eax),%ecx
  800615:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800620:	eb 27                	jmp    800649 <vprintfmt+0xdf>
  800622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800625:	85 c0                	test   %eax,%eax
  800627:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062c:	0f 49 c8             	cmovns %eax,%ecx
  80062f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800632:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800635:	eb 8c                	jmp    8005c3 <vprintfmt+0x59>
  800637:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80063a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800641:	eb 80                	jmp    8005c3 <vprintfmt+0x59>
  800643:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800646:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  800649:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80064d:	0f 89 70 ff ff ff    	jns    8005c3 <vprintfmt+0x59>
				width = precision, precision = -1;
  800653:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800656:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800659:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800660:	e9 5e ff ff ff       	jmp    8005c3 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800665:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800668:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80066b:	e9 53 ff ff ff       	jmp    8005c3 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 50 04             	lea    0x4(%eax),%edx
  800676:	89 55 14             	mov    %edx,0x14(%ebp)
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	53                   	push   %ebx
  80067d:	ff 30                	pushl  (%eax)
  80067f:	ff d6                	call   *%esi
			break;
  800681:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800684:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  800687:	e9 04 ff ff ff       	jmp    800590 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 50 04             	lea    0x4(%eax),%edx
  800692:	89 55 14             	mov    %edx,0x14(%ebp)
  800695:	8b 00                	mov    (%eax),%eax
  800697:	99                   	cltd   
  800698:	31 d0                	xor    %edx,%eax
  80069a:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80069c:	83 f8 0f             	cmp    $0xf,%eax
  80069f:	7f 0b                	jg     8006ac <vprintfmt+0x142>
  8006a1:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  8006a8:	85 d2                	test   %edx,%edx
  8006aa:	75 18                	jne    8006c4 <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  8006ac:	50                   	push   %eax
  8006ad:	68 f3 22 80 00       	push   $0x8022f3
  8006b2:	53                   	push   %ebx
  8006b3:	56                   	push   %esi
  8006b4:	e8 94 fe ff ff       	call   80054d <printfmt>
  8006b9:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  8006bf:	e9 cc fe ff ff       	jmp    800590 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  8006c4:	52                   	push   %edx
  8006c5:	68 b5 26 80 00       	push   $0x8026b5
  8006ca:	53                   	push   %ebx
  8006cb:	56                   	push   %esi
  8006cc:	e8 7c fe ff ff       	call   80054d <printfmt>
  8006d1:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006d7:	e9 b4 fe ff ff       	jmp    800590 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 50 04             	lea    0x4(%eax),%edx
  8006e2:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e5:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8006e7:	85 ff                	test   %edi,%edi
  8006e9:	b8 ec 22 80 00       	mov    $0x8022ec,%eax
  8006ee:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8006f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f5:	0f 8e 94 00 00 00    	jle    80078f <vprintfmt+0x225>
  8006fb:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006ff:	0f 84 98 00 00 00    	je     80079d <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 d0             	pushl  -0x30(%ebp)
  80070b:	57                   	push   %edi
  80070c:	e8 41 02 00 00       	call   800952 <strnlen>
  800711:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800714:	29 c1                	sub    %eax,%ecx
  800716:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800719:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80071c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800720:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800723:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800726:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800728:	eb 0f                	jmp    800739 <vprintfmt+0x1cf>
					putch(padc, putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	ff 75 e0             	pushl  -0x20(%ebp)
  800731:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800733:	83 ef 01             	sub    $0x1,%edi
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	85 ff                	test   %edi,%edi
  80073b:	7f ed                	jg     80072a <vprintfmt+0x1c0>
  80073d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800740:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800743:	85 c9                	test   %ecx,%ecx
  800745:	b8 00 00 00 00       	mov    $0x0,%eax
  80074a:	0f 49 c1             	cmovns %ecx,%eax
  80074d:	29 c1                	sub    %eax,%ecx
  80074f:	89 75 08             	mov    %esi,0x8(%ebp)
  800752:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800755:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800758:	89 cb                	mov    %ecx,%ebx
  80075a:	eb 4d                	jmp    8007a9 <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80075c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800760:	74 1b                	je     80077d <vprintfmt+0x213>
  800762:	0f be c0             	movsbl %al,%eax
  800765:	83 e8 20             	sub    $0x20,%eax
  800768:	83 f8 5e             	cmp    $0x5e,%eax
  80076b:	76 10                	jbe    80077d <vprintfmt+0x213>
					putch('?', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	6a 3f                	push   $0x3f
  800775:	ff 55 08             	call   *0x8(%ebp)
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb 0d                	jmp    80078a <vprintfmt+0x220>
				else
					putch(ch, putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	52                   	push   %edx
  800784:	ff 55 08             	call   *0x8(%ebp)
  800787:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078a:	83 eb 01             	sub    $0x1,%ebx
  80078d:	eb 1a                	jmp    8007a9 <vprintfmt+0x23f>
  80078f:	89 75 08             	mov    %esi,0x8(%ebp)
  800792:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800795:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800798:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80079b:	eb 0c                	jmp    8007a9 <vprintfmt+0x23f>
  80079d:	89 75 08             	mov    %esi,0x8(%ebp)
  8007a0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8007a3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8007a6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8007a9:	83 c7 01             	add    $0x1,%edi
  8007ac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b0:	0f be d0             	movsbl %al,%edx
  8007b3:	85 d2                	test   %edx,%edx
  8007b5:	74 23                	je     8007da <vprintfmt+0x270>
  8007b7:	85 f6                	test   %esi,%esi
  8007b9:	78 a1                	js     80075c <vprintfmt+0x1f2>
  8007bb:	83 ee 01             	sub    $0x1,%esi
  8007be:	79 9c                	jns    80075c <vprintfmt+0x1f2>
  8007c0:	89 df                	mov    %ebx,%edi
  8007c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007c8:	eb 18                	jmp    8007e2 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	53                   	push   %ebx
  8007ce:	6a 20                	push   $0x20
  8007d0:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d2:	83 ef 01             	sub    $0x1,%edi
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	eb 08                	jmp    8007e2 <vprintfmt+0x278>
  8007da:	89 df                	mov    %ebx,%edi
  8007dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007e2:	85 ff                	test   %edi,%edi
  8007e4:	7f e4                	jg     8007ca <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007e9:	e9 a2 fd ff ff       	jmp    800590 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ee:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f1:	e8 08 fd ff ff       	call   8004fe <getint>
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800801:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800805:	79 74                	jns    80087b <vprintfmt+0x311>
				putch('-', putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	53                   	push   %ebx
  80080b:	6a 2d                	push   $0x2d
  80080d:	ff d6                	call   *%esi
				num = -(long long) num;
  80080f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800812:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800815:	f7 d8                	neg    %eax
  800817:	83 d2 00             	adc    $0x0,%edx
  80081a:	f7 da                	neg    %edx
  80081c:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80081f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800824:	eb 55                	jmp    80087b <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800826:	8d 45 14             	lea    0x14(%ebp),%eax
  800829:	e8 96 fc ff ff       	call   8004c4 <getuint>
			base = 10;
  80082e:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800833:	eb 46                	jmp    80087b <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800835:	8d 45 14             	lea    0x14(%ebp),%eax
  800838:	e8 87 fc ff ff       	call   8004c4 <getuint>
			base = 8;
  80083d:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800842:	eb 37                	jmp    80087b <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	53                   	push   %ebx
  800848:	6a 30                	push   $0x30
  80084a:	ff d6                	call   *%esi
			putch('x', putdat);
  80084c:	83 c4 08             	add    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 78                	push   $0x78
  800852:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 50 04             	lea    0x4(%eax),%edx
  80085a:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800864:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800867:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  80086c:	eb 0d                	jmp    80087b <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086e:	8d 45 14             	lea    0x14(%ebp),%eax
  800871:	e8 4e fc ff ff       	call   8004c4 <getuint>
			base = 16;
  800876:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  80087b:	83 ec 0c             	sub    $0xc,%esp
  80087e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800882:	57                   	push   %edi
  800883:	ff 75 e0             	pushl  -0x20(%ebp)
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	89 da                	mov    %ebx,%edx
  80088b:	89 f0                	mov    %esi,%eax
  80088d:	e8 83 fb ff ff       	call   800415 <printnum>
			break;
  800892:	83 c4 20             	add    $0x20,%esp
  800895:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800898:	e9 f3 fc ff ff       	jmp    800590 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	51                   	push   %ecx
  8008a2:	ff d6                	call   *%esi
			break;
  8008a4:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8008aa:	e9 e1 fc ff ff       	jmp    800590 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	53                   	push   %ebx
  8008b3:	6a 25                	push   $0x25
  8008b5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	eb 03                	jmp    8008bf <vprintfmt+0x355>
  8008bc:	83 ef 01             	sub    $0x1,%edi
  8008bf:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8008c3:	75 f7                	jne    8008bc <vprintfmt+0x352>
  8008c5:	e9 c6 fc ff ff       	jmp    800590 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  8008ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008cd:	5b                   	pop    %ebx
  8008ce:	5e                   	pop    %esi
  8008cf:	5f                   	pop    %edi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 18             	sub    $0x18,%esp
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ef:	85 c0                	test   %eax,%eax
  8008f1:	74 26                	je     800919 <vsnprintf+0x47>
  8008f3:	85 d2                	test   %edx,%edx
  8008f5:	7e 22                	jle    800919 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f7:	ff 75 14             	pushl  0x14(%ebp)
  8008fa:	ff 75 10             	pushl  0x10(%ebp)
  8008fd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800900:	50                   	push   %eax
  800901:	68 30 05 80 00       	push   $0x800530
  800906:	e8 5f fc ff ff       	call   80056a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80090b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800914:	83 c4 10             	add    $0x10,%esp
  800917:	eb 05                	jmp    80091e <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800919:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    

00800920 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800926:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800929:	50                   	push   %eax
  80092a:	ff 75 10             	pushl  0x10(%ebp)
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 9a ff ff ff       	call   8008d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800940:	b8 00 00 00 00       	mov    $0x0,%eax
  800945:	eb 03                	jmp    80094a <strlen+0x10>
		n++;
  800947:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80094a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80094e:	75 f7                	jne    800947 <strlen+0xd>
		n++;
	return n;
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	eb 03                	jmp    800965 <strnlen+0x13>
		n++;
  800962:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800965:	39 c2                	cmp    %eax,%edx
  800967:	74 08                	je     800971 <strnlen+0x1f>
  800969:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80096d:	75 f3                	jne    800962 <strnlen+0x10>
  80096f:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	53                   	push   %ebx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	83 c2 01             	add    $0x1,%edx
  800982:	83 c1 01             	add    $0x1,%ecx
  800985:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800989:	88 5a ff             	mov    %bl,-0x1(%edx)
  80098c:	84 db                	test   %bl,%bl
  80098e:	75 ef                	jne    80097f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800990:	5b                   	pop    %ebx
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	53                   	push   %ebx
  800997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80099a:	53                   	push   %ebx
  80099b:	e8 9a ff ff ff       	call   80093a <strlen>
  8009a0:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	01 d8                	add    %ebx,%eax
  8009a8:	50                   	push   %eax
  8009a9:	e8 c5 ff ff ff       	call   800973 <strcpy>
	return dst;
}
  8009ae:	89 d8                	mov    %ebx,%eax
  8009b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009b3:	c9                   	leave  
  8009b4:	c3                   	ret    

008009b5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	56                   	push   %esi
  8009b9:	53                   	push   %ebx
  8009ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8009bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c0:	89 f3                	mov    %esi,%ebx
  8009c2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c5:	89 f2                	mov    %esi,%edx
  8009c7:	eb 0f                	jmp    8009d8 <strncpy+0x23>
		*dst++ = *src;
  8009c9:	83 c2 01             	add    $0x1,%edx
  8009cc:	0f b6 01             	movzbl (%ecx),%eax
  8009cf:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009d2:	80 39 01             	cmpb   $0x1,(%ecx)
  8009d5:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d8:	39 da                	cmp    %ebx,%edx
  8009da:	75 ed                	jne    8009c9 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	5b                   	pop    %ebx
  8009df:	5e                   	pop    %esi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	56                   	push   %esi
  8009e6:	53                   	push   %ebx
  8009e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8009f0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f2:	85 d2                	test   %edx,%edx
  8009f4:	74 21                	je     800a17 <strlcpy+0x35>
  8009f6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009fa:	89 f2                	mov    %esi,%edx
  8009fc:	eb 09                	jmp    800a07 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009fe:	83 c2 01             	add    $0x1,%edx
  800a01:	83 c1 01             	add    $0x1,%ecx
  800a04:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	74 09                	je     800a14 <strlcpy+0x32>
  800a0b:	0f b6 19             	movzbl (%ecx),%ebx
  800a0e:	84 db                	test   %bl,%bl
  800a10:	75 ec                	jne    8009fe <strlcpy+0x1c>
  800a12:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a14:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a17:	29 f0                	sub    %esi,%eax
}
  800a19:	5b                   	pop    %ebx
  800a1a:	5e                   	pop    %esi
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a26:	eb 06                	jmp    800a2e <strcmp+0x11>
		p++, q++;
  800a28:	83 c1 01             	add    $0x1,%ecx
  800a2b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a2e:	0f b6 01             	movzbl (%ecx),%eax
  800a31:	84 c0                	test   %al,%al
  800a33:	74 04                	je     800a39 <strcmp+0x1c>
  800a35:	3a 02                	cmp    (%edx),%al
  800a37:	74 ef                	je     800a28 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a39:	0f b6 c0             	movzbl %al,%eax
  800a3c:	0f b6 12             	movzbl (%edx),%edx
  800a3f:	29 d0                	sub    %edx,%eax
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	53                   	push   %ebx
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4d:	89 c3                	mov    %eax,%ebx
  800a4f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a52:	eb 06                	jmp    800a5a <strncmp+0x17>
		n--, p++, q++;
  800a54:	83 c0 01             	add    $0x1,%eax
  800a57:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a5a:	39 d8                	cmp    %ebx,%eax
  800a5c:	74 15                	je     800a73 <strncmp+0x30>
  800a5e:	0f b6 08             	movzbl (%eax),%ecx
  800a61:	84 c9                	test   %cl,%cl
  800a63:	74 04                	je     800a69 <strncmp+0x26>
  800a65:	3a 0a                	cmp    (%edx),%cl
  800a67:	74 eb                	je     800a54 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a69:	0f b6 00             	movzbl (%eax),%eax
  800a6c:	0f b6 12             	movzbl (%edx),%edx
  800a6f:	29 d0                	sub    %edx,%eax
  800a71:	eb 05                	jmp    800a78 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a73:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a78:	5b                   	pop    %ebx
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	eb 07                	jmp    800a8e <strchr+0x13>
		if (*s == c)
  800a87:	38 ca                	cmp    %cl,%dl
  800a89:	74 0f                	je     800a9a <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	0f b6 10             	movzbl (%eax),%edx
  800a91:	84 d2                	test   %dl,%dl
  800a93:	75 f2                	jne    800a87 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa6:	eb 03                	jmp    800aab <strfind+0xf>
  800aa8:	83 c0 01             	add    $0x1,%eax
  800aab:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aae:	38 ca                	cmp    %cl,%dl
  800ab0:	74 04                	je     800ab6 <strfind+0x1a>
  800ab2:	84 d2                	test   %dl,%dl
  800ab4:	75 f2                	jne    800aa8 <strfind+0xc>
			break;
	return (char *) s;
}
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	57                   	push   %edi
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
  800abe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  800ac4:	85 c9                	test   %ecx,%ecx
  800ac6:	74 37                	je     800aff <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac8:	f6 c2 03             	test   $0x3,%dl
  800acb:	75 2a                	jne    800af7 <memset+0x3f>
  800acd:	f6 c1 03             	test   $0x3,%cl
  800ad0:	75 25                	jne    800af7 <memset+0x3f>
		c &= 0xFF;
  800ad2:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad6:	89 df                	mov    %ebx,%edi
  800ad8:	c1 e7 08             	shl    $0x8,%edi
  800adb:	89 de                	mov    %ebx,%esi
  800add:	c1 e6 18             	shl    $0x18,%esi
  800ae0:	89 d8                	mov    %ebx,%eax
  800ae2:	c1 e0 10             	shl    $0x10,%eax
  800ae5:	09 f0                	or     %esi,%eax
  800ae7:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  800ae9:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800aec:	89 f8                	mov    %edi,%eax
  800aee:	09 d8                	or     %ebx,%eax
  800af0:	89 d7                	mov    %edx,%edi
  800af2:	fc                   	cld    
  800af3:	f3 ab                	rep stos %eax,%es:(%edi)
  800af5:	eb 08                	jmp    800aff <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af7:	89 d7                	mov    %edx,%edi
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	fc                   	cld    
  800afd:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800aff:	89 d0                	mov    %edx,%eax
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b14:	39 c6                	cmp    %eax,%esi
  800b16:	73 35                	jae    800b4d <memmove+0x47>
  800b18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1b:	39 d0                	cmp    %edx,%eax
  800b1d:	73 2e                	jae    800b4d <memmove+0x47>
		s += n;
		d += n;
  800b1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b22:	89 d6                	mov    %edx,%esi
  800b24:	09 fe                	or     %edi,%esi
  800b26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2c:	75 13                	jne    800b41 <memmove+0x3b>
  800b2e:	f6 c1 03             	test   $0x3,%cl
  800b31:	75 0e                	jne    800b41 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  800b33:	83 ef 04             	sub    $0x4,%edi
  800b36:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b39:	c1 e9 02             	shr    $0x2,%ecx
  800b3c:	fd                   	std    
  800b3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3f:	eb 09                	jmp    800b4a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b41:	83 ef 01             	sub    $0x1,%edi
  800b44:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b47:	fd                   	std    
  800b48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b4a:	fc                   	cld    
  800b4b:	eb 1d                	jmp    800b6a <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4d:	89 f2                	mov    %esi,%edx
  800b4f:	09 c2                	or     %eax,%edx
  800b51:	f6 c2 03             	test   $0x3,%dl
  800b54:	75 0f                	jne    800b65 <memmove+0x5f>
  800b56:	f6 c1 03             	test   $0x3,%cl
  800b59:	75 0a                	jne    800b65 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800b5b:	c1 e9 02             	shr    $0x2,%ecx
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	fc                   	cld    
  800b61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b63:	eb 05                	jmp    800b6a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	fc                   	cld    
  800b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b71:	ff 75 10             	pushl  0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 87 ff ff ff       	call   800b06 <memmove>
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8c:	89 c6                	mov    %eax,%esi
  800b8e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b91:	eb 1a                	jmp    800bad <memcmp+0x2c>
		if (*s1 != *s2)
  800b93:	0f b6 08             	movzbl (%eax),%ecx
  800b96:	0f b6 1a             	movzbl (%edx),%ebx
  800b99:	38 d9                	cmp    %bl,%cl
  800b9b:	74 0a                	je     800ba7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b9d:	0f b6 c1             	movzbl %cl,%eax
  800ba0:	0f b6 db             	movzbl %bl,%ebx
  800ba3:	29 d8                	sub    %ebx,%eax
  800ba5:	eb 0f                	jmp    800bb6 <memcmp+0x35>
		s1++, s2++;
  800ba7:	83 c0 01             	add    $0x1,%eax
  800baa:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bad:	39 f0                	cmp    %esi,%eax
  800baf:	75 e2                	jne    800b93 <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	53                   	push   %ebx
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800bc1:	89 c1                	mov    %eax,%ecx
  800bc3:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc6:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bca:	eb 0a                	jmp    800bd6 <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bcc:	0f b6 10             	movzbl (%eax),%edx
  800bcf:	39 da                	cmp    %ebx,%edx
  800bd1:	74 07                	je     800bda <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bd3:	83 c0 01             	add    $0x1,%eax
  800bd6:	39 c8                	cmp    %ecx,%eax
  800bd8:	72 f2                	jb     800bcc <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bda:	5b                   	pop    %ebx
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be9:	eb 03                	jmp    800bee <strtol+0x11>
		s++;
  800beb:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bee:	0f b6 01             	movzbl (%ecx),%eax
  800bf1:	3c 20                	cmp    $0x20,%al
  800bf3:	74 f6                	je     800beb <strtol+0xe>
  800bf5:	3c 09                	cmp    $0x9,%al
  800bf7:	74 f2                	je     800beb <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bf9:	3c 2b                	cmp    $0x2b,%al
  800bfb:	75 0a                	jne    800c07 <strtol+0x2a>
		s++;
  800bfd:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c00:	bf 00 00 00 00       	mov    $0x0,%edi
  800c05:	eb 11                	jmp    800c18 <strtol+0x3b>
  800c07:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c0c:	3c 2d                	cmp    $0x2d,%al
  800c0e:	75 08                	jne    800c18 <strtol+0x3b>
		s++, neg = 1;
  800c10:	83 c1 01             	add    $0x1,%ecx
  800c13:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c1e:	75 15                	jne    800c35 <strtol+0x58>
  800c20:	80 39 30             	cmpb   $0x30,(%ecx)
  800c23:	75 10                	jne    800c35 <strtol+0x58>
  800c25:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c29:	75 7c                	jne    800ca7 <strtol+0xca>
		s += 2, base = 16;
  800c2b:	83 c1 02             	add    $0x2,%ecx
  800c2e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c33:	eb 16                	jmp    800c4b <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800c35:	85 db                	test   %ebx,%ebx
  800c37:	75 12                	jne    800c4b <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c39:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c3e:	80 39 30             	cmpb   $0x30,(%ecx)
  800c41:	75 08                	jne    800c4b <strtol+0x6e>
		s++, base = 8;
  800c43:	83 c1 01             	add    $0x1,%ecx
  800c46:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c50:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c53:	0f b6 11             	movzbl (%ecx),%edx
  800c56:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c59:	89 f3                	mov    %esi,%ebx
  800c5b:	80 fb 09             	cmp    $0x9,%bl
  800c5e:	77 08                	ja     800c68 <strtol+0x8b>
			dig = *s - '0';
  800c60:	0f be d2             	movsbl %dl,%edx
  800c63:	83 ea 30             	sub    $0x30,%edx
  800c66:	eb 22                	jmp    800c8a <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800c68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6b:	89 f3                	mov    %esi,%ebx
  800c6d:	80 fb 19             	cmp    $0x19,%bl
  800c70:	77 08                	ja     800c7a <strtol+0x9d>
			dig = *s - 'a' + 10;
  800c72:	0f be d2             	movsbl %dl,%edx
  800c75:	83 ea 57             	sub    $0x57,%edx
  800c78:	eb 10                	jmp    800c8a <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800c7a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c7d:	89 f3                	mov    %esi,%ebx
  800c7f:	80 fb 19             	cmp    $0x19,%bl
  800c82:	77 16                	ja     800c9a <strtol+0xbd>
			dig = *s - 'A' + 10;
  800c84:	0f be d2             	movsbl %dl,%edx
  800c87:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800c8a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c8d:	7d 0b                	jge    800c9a <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800c8f:	83 c1 01             	add    $0x1,%ecx
  800c92:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c96:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800c98:	eb b9                	jmp    800c53 <strtol+0x76>

	if (endptr)
  800c9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9e:	74 0d                	je     800cad <strtol+0xd0>
		*endptr = (char *) s;
  800ca0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca3:	89 0e                	mov    %ecx,(%esi)
  800ca5:	eb 06                	jmp    800cad <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ca7:	85 db                	test   %ebx,%ebx
  800ca9:	74 98                	je     800c43 <strtol+0x66>
  800cab:	eb 9e                	jmp    800c4b <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800cad:	89 c2                	mov    %eax,%edx
  800caf:	f7 da                	neg    %edx
  800cb1:	85 ff                	test   %edi,%edi
  800cb3:	0f 45 c2             	cmovne %edx,%eax
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	53                   	push   %ebx
  800cc1:	83 ec 1c             	sub    $0x1c,%esp
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800cc7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800cca:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cd2:	8b 7d 10             	mov    0x10(%ebp),%edi
  800cd5:	8b 75 14             	mov    0x14(%ebp),%esi
  800cd8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cde:	74 1d                	je     800cfd <syscall+0x42>
  800ce0:	85 c0                	test   %eax,%eax
  800ce2:	7e 19                	jle    800cfd <syscall+0x42>
  800ce4:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	50                   	push   %eax
  800ceb:	52                   	push   %edx
  800cec:	68 df 25 80 00       	push   $0x8025df
  800cf1:	6a 23                	push   $0x23
  800cf3:	68 fc 25 80 00       	push   $0x8025fc
  800cf8:	e8 2b f6 ff ff       	call   800328 <_panic>

	return ret;
}
  800cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800d0b:	6a 00                	push   $0x0
  800d0d:	6a 00                	push   $0x0
  800d0f:	6a 00                	push   $0x0
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d17:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	e8 95 ff ff ff       	call   800cbb <syscall>
}
  800d26:	83 c4 10             	add    $0x10,%esp
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <sys_cgetc>:

int
sys_cgetc(void)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800d31:	6a 00                	push   $0x0
  800d33:	6a 00                	push   $0x0
  800d35:	6a 00                	push   $0x0
  800d37:	6a 00                	push   $0x0
  800d39:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d43:	b8 01 00 00 00       	mov    $0x1,%eax
  800d48:	e8 6e ff ff ff       	call   800cbb <syscall>
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800d55:	6a 00                	push   $0x0
  800d57:	6a 00                	push   $0x0
  800d59:	6a 00                	push   $0x0
  800d5b:	6a 00                	push   $0x0
  800d5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d60:	ba 01 00 00 00       	mov    $0x1,%edx
  800d65:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6a:	e8 4c ff ff ff       	call   800cbb <syscall>
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800d77:	6a 00                	push   $0x0
  800d79:	6a 00                	push   $0x0
  800d7b:	6a 00                	push   $0x0
  800d7d:	6a 00                	push   $0x0
  800d7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d84:	ba 00 00 00 00       	mov    $0x0,%edx
  800d89:	b8 02 00 00 00       	mov    $0x2,%eax
  800d8e:	e8 28 ff ff ff       	call   800cbb <syscall>
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <sys_yield>:

void
sys_yield(void)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800d9b:	6a 00                	push   $0x0
  800d9d:	6a 00                	push   $0x0
  800d9f:	6a 00                	push   $0x0
  800da1:	6a 00                	push   $0x0
  800da3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dad:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db2:	e8 04 ff ff ff       	call   800cbb <syscall>
}
  800db7:	83 c4 10             	add    $0x10,%esp
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  800dc2:	6a 00                	push   $0x0
  800dc4:	6a 00                	push   $0x0
  800dc6:	ff 75 10             	pushl  0x10(%ebp)
  800dc9:	ff 75 0c             	pushl  0xc(%ebp)
  800dcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dcf:	ba 01 00 00 00       	mov    $0x1,%edx
  800dd4:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd9:	e8 dd fe ff ff       	call   800cbb <syscall>
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  800de6:	ff 75 18             	pushl  0x18(%ebp)
  800de9:	ff 75 14             	pushl  0x14(%ebp)
  800dec:	ff 75 10             	pushl  0x10(%ebp)
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df5:	ba 01 00 00 00       	mov    $0x1,%edx
  800dfa:	b8 05 00 00 00       	mov    $0x5,%eax
  800dff:	e8 b7 fe ff ff       	call   800cbb <syscall>
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800e0c:	6a 00                	push   $0x0
  800e0e:	6a 00                	push   $0x0
  800e10:	6a 00                	push   $0x0
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e18:	ba 01 00 00 00       	mov    $0x1,%edx
  800e1d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e22:	e8 94 fe ff ff       	call   800cbb <syscall>
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800e2f:	6a 00                	push   $0x0
  800e31:	6a 00                	push   $0x0
  800e33:	6a 00                	push   $0x0
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3b:	ba 01 00 00 00       	mov    $0x1,%edx
  800e40:	b8 08 00 00 00       	mov    $0x8,%eax
  800e45:	e8 71 fe ff ff       	call   800cbb <syscall>
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  800e52:	6a 00                	push   $0x0
  800e54:	6a 00                	push   $0x0
  800e56:	6a 00                	push   $0x0
  800e58:	ff 75 0c             	pushl  0xc(%ebp)
  800e5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5e:	ba 01 00 00 00       	mov    $0x1,%edx
  800e63:	b8 09 00 00 00       	mov    $0x9,%eax
  800e68:	e8 4e fe ff ff       	call   800cbb <syscall>
}
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  800e75:	6a 00                	push   $0x0
  800e77:	6a 00                	push   $0x0
  800e79:	6a 00                	push   $0x0
  800e7b:	ff 75 0c             	pushl  0xc(%ebp)
  800e7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e81:	ba 01 00 00 00       	mov    $0x1,%edx
  800e86:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8b:	e8 2b fe ff ff       	call   800cbb <syscall>
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  800e98:	6a 00                	push   $0x0
  800e9a:	ff 75 14             	pushl  0x14(%ebp)
  800e9d:	ff 75 10             	pushl  0x10(%ebp)
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  800eab:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb0:	e8 06 fe ff ff       	call   800cbb <syscall>
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  800ebd:	6a 00                	push   $0x0
  800ebf:	6a 00                	push   $0x0
  800ec1:	6a 00                	push   $0x0
  800ec3:	6a 00                	push   $0x0
  800ec5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec8:	ba 01 00 00 00       	mov    $0x1,%edx
  800ecd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed2:	e8 e4 fd ff ff       	call   800cbb <syscall>
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800ee5:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800ee7:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800eea:	83 3a 01             	cmpl   $0x1,(%edx)
  800eed:	7e 09                	jle    800ef8 <argstart+0x1f>
  800eef:	ba 88 22 80 00       	mov    $0x802288,%edx
  800ef4:	85 c9                	test   %ecx,%ecx
  800ef6:	75 05                	jne    800efd <argstart+0x24>
  800ef8:	ba 00 00 00 00       	mov    $0x0,%edx
  800efd:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800f00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <argnext>:

int
argnext(struct Argstate *args)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800f13:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800f1a:	8b 43 08             	mov    0x8(%ebx),%eax
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	74 6f                	je     800f90 <argnext+0x87>
		return -1;

	if (!*args->curarg) {
  800f21:	80 38 00             	cmpb   $0x0,(%eax)
  800f24:	75 4e                	jne    800f74 <argnext+0x6b>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800f26:	8b 0b                	mov    (%ebx),%ecx
  800f28:	83 39 01             	cmpl   $0x1,(%ecx)
  800f2b:	74 55                	je     800f82 <argnext+0x79>
		    || args->argv[1][0] != '-'
  800f2d:	8b 53 04             	mov    0x4(%ebx),%edx
  800f30:	8b 42 04             	mov    0x4(%edx),%eax
  800f33:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f36:	75 4a                	jne    800f82 <argnext+0x79>
		    || args->argv[1][1] == '\0')
  800f38:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f3c:	74 44                	je     800f82 <argnext+0x79>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800f3e:	83 c0 01             	add    $0x1,%eax
  800f41:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f44:	83 ec 04             	sub    $0x4,%esp
  800f47:	8b 01                	mov    (%ecx),%eax
  800f49:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800f50:	50                   	push   %eax
  800f51:	8d 42 08             	lea    0x8(%edx),%eax
  800f54:	50                   	push   %eax
  800f55:	83 c2 04             	add    $0x4,%edx
  800f58:	52                   	push   %edx
  800f59:	e8 a8 fb ff ff       	call   800b06 <memmove>
		(*args->argc)--;
  800f5e:	8b 03                	mov    (%ebx),%eax
  800f60:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f63:	8b 43 08             	mov    0x8(%ebx),%eax
  800f66:	83 c4 10             	add    $0x10,%esp
  800f69:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f6c:	75 06                	jne    800f74 <argnext+0x6b>
  800f6e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f72:	74 0e                	je     800f82 <argnext+0x79>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800f74:	8b 53 08             	mov    0x8(%ebx),%edx
  800f77:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800f7a:	83 c2 01             	add    $0x1,%edx
  800f7d:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  800f80:	eb 13                	jmp    800f95 <argnext+0x8c>

    endofargs:
	args->curarg = 0;
  800f82:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800f89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800f8e:	eb 05                	jmp    800f95 <argnext+0x8c>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  800f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	53                   	push   %ebx
  800f9e:	83 ec 04             	sub    $0x4,%esp
  800fa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800fa4:	8b 43 08             	mov    0x8(%ebx),%eax
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	74 58                	je     801003 <argnextvalue+0x69>
		return 0;
	if (*args->curarg) {
  800fab:	80 38 00             	cmpb   $0x0,(%eax)
  800fae:	74 0c                	je     800fbc <argnextvalue+0x22>
		args->argvalue = args->curarg;
  800fb0:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800fb3:	c7 43 08 88 22 80 00 	movl   $0x802288,0x8(%ebx)
  800fba:	eb 42                	jmp    800ffe <argnextvalue+0x64>
	} else if (*args->argc > 1) {
  800fbc:	8b 13                	mov    (%ebx),%edx
  800fbe:	83 3a 01             	cmpl   $0x1,(%edx)
  800fc1:	7e 2d                	jle    800ff0 <argnextvalue+0x56>
		args->argvalue = args->argv[1];
  800fc3:	8b 43 04             	mov    0x4(%ebx),%eax
  800fc6:	8b 48 04             	mov    0x4(%eax),%ecx
  800fc9:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	8b 12                	mov    (%edx),%edx
  800fd1:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800fd8:	52                   	push   %edx
  800fd9:	8d 50 08             	lea    0x8(%eax),%edx
  800fdc:	52                   	push   %edx
  800fdd:	83 c0 04             	add    $0x4,%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 20 fb ff ff       	call   800b06 <memmove>
		(*args->argc)--;
  800fe6:	8b 03                	mov    (%ebx),%eax
  800fe8:	83 28 01             	subl   $0x1,(%eax)
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	eb 0e                	jmp    800ffe <argnextvalue+0x64>
	} else {
		args->argvalue = 0;
  800ff0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800ff7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  800ffe:	8b 43 0c             	mov    0xc(%ebx),%eax
  801001:	eb 05                	jmp    801008 <argnextvalue+0x6e>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801008:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100b:	c9                   	leave  
  80100c:	c3                   	ret    

0080100d <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801016:	8b 51 0c             	mov    0xc(%ecx),%edx
  801019:	89 d0                	mov    %edx,%eax
  80101b:	85 d2                	test   %edx,%edx
  80101d:	75 0c                	jne    80102b <argvalue+0x1e>
  80101f:	83 ec 0c             	sub    $0xc,%esp
  801022:	51                   	push   %ecx
  801023:	e8 72 ff ff ff       	call   800f9a <argnextvalue>
  801028:	83 c4 10             	add    $0x10,%esp
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	05 00 00 00 30       	add    $0x30000000,%eax
  801038:	c1 e8 0c             	shr    $0xc,%eax
}
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  801040:	ff 75 08             	pushl  0x8(%ebp)
  801043:	e8 e5 ff ff ff       	call   80102d <fd2num>
  801048:	83 c4 04             	add    $0x4,%esp
  80104b:	c1 e0 0c             	shl    $0xc,%eax
  80104e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801053:	c9                   	leave  
  801054:	c3                   	ret    

00801055 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80105b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801060:	89 c2                	mov    %eax,%edx
  801062:	c1 ea 16             	shr    $0x16,%edx
  801065:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106c:	f6 c2 01             	test   $0x1,%dl
  80106f:	74 11                	je     801082 <fd_alloc+0x2d>
  801071:	89 c2                	mov    %eax,%edx
  801073:	c1 ea 0c             	shr    $0xc,%edx
  801076:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107d:	f6 c2 01             	test   $0x1,%dl
  801080:	75 09                	jne    80108b <fd_alloc+0x36>
			*fd_store = fd;
  801082:	89 01                	mov    %eax,(%ecx)
			return 0;
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
  801089:	eb 17                	jmp    8010a2 <fd_alloc+0x4d>
  80108b:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801090:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801095:	75 c9                	jne    801060 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801097:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80109d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010aa:	83 f8 1f             	cmp    $0x1f,%eax
  8010ad:	77 36                	ja     8010e5 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010af:	c1 e0 0c             	shl    $0xc,%eax
  8010b2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b7:	89 c2                	mov    %eax,%edx
  8010b9:	c1 ea 16             	shr    $0x16,%edx
  8010bc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010c3:	f6 c2 01             	test   $0x1,%dl
  8010c6:	74 24                	je     8010ec <fd_lookup+0x48>
  8010c8:	89 c2                	mov    %eax,%edx
  8010ca:	c1 ea 0c             	shr    $0xc,%edx
  8010cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d4:	f6 c2 01             	test   $0x1,%dl
  8010d7:	74 1a                	je     8010f3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010dc:	89 02                	mov    %eax,(%edx)
	return 0;
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e3:	eb 13                	jmp    8010f8 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ea:	eb 0c                	jmp    8010f8 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f1:	eb 05                	jmp    8010f8 <fd_lookup+0x54>
  8010f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    

008010fa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	ba 8c 26 80 00       	mov    $0x80268c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801108:	eb 13                	jmp    80111d <dev_lookup+0x23>
  80110a:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  80110d:	39 08                	cmp    %ecx,(%eax)
  80110f:	75 0c                	jne    80111d <dev_lookup+0x23>
			*dev = devtab[i];
  801111:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801114:	89 01                	mov    %eax,(%ecx)
			return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
  80111b:	eb 2e                	jmp    80114b <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80111d:	8b 02                	mov    (%edx),%eax
  80111f:	85 c0                	test   %eax,%eax
  801121:	75 e7                	jne    80110a <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801123:	a1 20 44 80 00       	mov    0x804420,%eax
  801128:	8b 40 48             	mov    0x48(%eax),%eax
  80112b:	83 ec 04             	sub    $0x4,%esp
  80112e:	51                   	push   %ecx
  80112f:	50                   	push   %eax
  801130:	68 0c 26 80 00       	push   $0x80260c
  801135:	e8 c7 f2 ff ff       	call   800401 <cprintf>
	*dev = 0;
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801143:	83 c4 10             	add    $0x10,%esp
  801146:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	83 ec 10             	sub    $0x10,%esp
  801155:	8b 75 08             	mov    0x8(%ebp),%esi
  801158:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80115b:	56                   	push   %esi
  80115c:	e8 cc fe ff ff       	call   80102d <fd2num>
  801161:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801164:	89 14 24             	mov    %edx,(%esp)
  801167:	50                   	push   %eax
  801168:	e8 37 ff ff ff       	call   8010a4 <fd_lookup>
  80116d:	83 c4 08             	add    $0x8,%esp
  801170:	85 c0                	test   %eax,%eax
  801172:	78 05                	js     801179 <fd_close+0x2c>
	    || fd != fd2)
  801174:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801177:	74 0c                	je     801185 <fd_close+0x38>
		return (must_exist ? r : 0);
  801179:	84 db                	test   %bl,%bl
  80117b:	ba 00 00 00 00       	mov    $0x0,%edx
  801180:	0f 44 c2             	cmove  %edx,%eax
  801183:	eb 41                	jmp    8011c6 <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801185:	83 ec 08             	sub    $0x8,%esp
  801188:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80118b:	50                   	push   %eax
  80118c:	ff 36                	pushl  (%esi)
  80118e:	e8 67 ff ff ff       	call   8010fa <dev_lookup>
  801193:	89 c3                	mov    %eax,%ebx
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	78 1a                	js     8011b6 <fd_close+0x69>
		if (dev->dev_close)
  80119c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119f:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011a2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	74 0b                	je     8011b6 <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  8011ab:	83 ec 0c             	sub    $0xc,%esp
  8011ae:	56                   	push   %esi
  8011af:	ff d0                	call   *%eax
  8011b1:	89 c3                	mov    %eax,%ebx
  8011b3:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011b6:	83 ec 08             	sub    $0x8,%esp
  8011b9:	56                   	push   %esi
  8011ba:	6a 00                	push   $0x0
  8011bc:	e8 45 fc ff ff       	call   800e06 <sys_page_unmap>
	return r;
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	89 d8                	mov    %ebx,%eax
}
  8011c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c9:	5b                   	pop    %ebx
  8011ca:	5e                   	pop    %esi
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d6:	50                   	push   %eax
  8011d7:	ff 75 08             	pushl  0x8(%ebp)
  8011da:	e8 c5 fe ff ff       	call   8010a4 <fd_lookup>
  8011df:	83 c4 08             	add    $0x8,%esp
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	78 10                	js     8011f6 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	6a 01                	push   $0x1
  8011eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ee:	e8 5a ff ff ff       	call   80114d <fd_close>
  8011f3:	83 c4 10             	add    $0x10,%esp
}
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <close_all>:

void
close_all(void)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801204:	83 ec 0c             	sub    $0xc,%esp
  801207:	53                   	push   %ebx
  801208:	e8 c0 ff ff ff       	call   8011cd <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80120d:	83 c3 01             	add    $0x1,%ebx
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	83 fb 20             	cmp    $0x20,%ebx
  801216:	75 ec                	jne    801204 <close_all+0xc>
		close(i);
}
  801218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	83 ec 2c             	sub    $0x2c,%esp
  801226:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80122c:	50                   	push   %eax
  80122d:	ff 75 08             	pushl  0x8(%ebp)
  801230:	e8 6f fe ff ff       	call   8010a4 <fd_lookup>
  801235:	83 c4 08             	add    $0x8,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	0f 88 c1 00 00 00    	js     801301 <dup+0xe4>
		return r;
	close(newfdnum);
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	56                   	push   %esi
  801244:	e8 84 ff ff ff       	call   8011cd <close>

	newfd = INDEX2FD(newfdnum);
  801249:	89 f3                	mov    %esi,%ebx
  80124b:	c1 e3 0c             	shl    $0xc,%ebx
  80124e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801254:	83 c4 04             	add    $0x4,%esp
  801257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125a:	e8 de fd ff ff       	call   80103d <fd2data>
  80125f:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801261:	89 1c 24             	mov    %ebx,(%esp)
  801264:	e8 d4 fd ff ff       	call   80103d <fd2data>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80126f:	89 f8                	mov    %edi,%eax
  801271:	c1 e8 16             	shr    $0x16,%eax
  801274:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127b:	a8 01                	test   $0x1,%al
  80127d:	74 37                	je     8012b6 <dup+0x99>
  80127f:	89 f8                	mov    %edi,%eax
  801281:	c1 e8 0c             	shr    $0xc,%eax
  801284:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80128b:	f6 c2 01             	test   $0x1,%dl
  80128e:	74 26                	je     8012b6 <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801290:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801297:	83 ec 0c             	sub    $0xc,%esp
  80129a:	25 07 0e 00 00       	and    $0xe07,%eax
  80129f:	50                   	push   %eax
  8012a0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8012a3:	6a 00                	push   $0x0
  8012a5:	57                   	push   %edi
  8012a6:	6a 00                	push   $0x0
  8012a8:	e8 33 fb ff ff       	call   800de0 <sys_page_map>
  8012ad:	89 c7                	mov    %eax,%edi
  8012af:	83 c4 20             	add    $0x20,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 2e                	js     8012e4 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012b9:	89 d0                	mov    %edx,%eax
  8012bb:	c1 e8 0c             	shr    $0xc,%eax
  8012be:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	25 07 0e 00 00       	and    $0xe07,%eax
  8012cd:	50                   	push   %eax
  8012ce:	53                   	push   %ebx
  8012cf:	6a 00                	push   $0x0
  8012d1:	52                   	push   %edx
  8012d2:	6a 00                	push   $0x0
  8012d4:	e8 07 fb ff ff       	call   800de0 <sys_page_map>
  8012d9:	89 c7                	mov    %eax,%edi
  8012db:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8012de:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012e0:	85 ff                	test   %edi,%edi
  8012e2:	79 1d                	jns    801301 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	53                   	push   %ebx
  8012e8:	6a 00                	push   $0x0
  8012ea:	e8 17 fb ff ff       	call   800e06 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ef:	83 c4 08             	add    $0x8,%esp
  8012f2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8012f5:	6a 00                	push   $0x0
  8012f7:	e8 0a fb ff ff       	call   800e06 <sys_page_unmap>
	return r;
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	89 f8                	mov    %edi,%eax
}
  801301:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801304:	5b                   	pop    %ebx
  801305:	5e                   	pop    %esi
  801306:	5f                   	pop    %edi
  801307:	5d                   	pop    %ebp
  801308:	c3                   	ret    

00801309 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	53                   	push   %ebx
  80130d:	83 ec 14             	sub    $0x14,%esp
  801310:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801313:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801316:	50                   	push   %eax
  801317:	53                   	push   %ebx
  801318:	e8 87 fd ff ff       	call   8010a4 <fd_lookup>
  80131d:	83 c4 08             	add    $0x8,%esp
  801320:	89 c2                	mov    %eax,%edx
  801322:	85 c0                	test   %eax,%eax
  801324:	78 6d                	js     801393 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132c:	50                   	push   %eax
  80132d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801330:	ff 30                	pushl  (%eax)
  801332:	e8 c3 fd ff ff       	call   8010fa <dev_lookup>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 4c                	js     80138a <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80133e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801341:	8b 42 08             	mov    0x8(%edx),%eax
  801344:	83 e0 03             	and    $0x3,%eax
  801347:	83 f8 01             	cmp    $0x1,%eax
  80134a:	75 21                	jne    80136d <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80134c:	a1 20 44 80 00       	mov    0x804420,%eax
  801351:	8b 40 48             	mov    0x48(%eax),%eax
  801354:	83 ec 04             	sub    $0x4,%esp
  801357:	53                   	push   %ebx
  801358:	50                   	push   %eax
  801359:	68 50 26 80 00       	push   $0x802650
  80135e:	e8 9e f0 ff ff       	call   800401 <cprintf>
		return -E_INVAL;
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80136b:	eb 26                	jmp    801393 <read+0x8a>
	}
	if (!dev->dev_read)
  80136d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801370:	8b 40 08             	mov    0x8(%eax),%eax
  801373:	85 c0                	test   %eax,%eax
  801375:	74 17                	je     80138e <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	ff 75 10             	pushl  0x10(%ebp)
  80137d:	ff 75 0c             	pushl  0xc(%ebp)
  801380:	52                   	push   %edx
  801381:	ff d0                	call   *%eax
  801383:	89 c2                	mov    %eax,%edx
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	eb 09                	jmp    801393 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138a:	89 c2                	mov    %eax,%edx
  80138c:	eb 05                	jmp    801393 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80138e:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  801393:	89 d0                	mov    %edx,%eax
  801395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	57                   	push   %edi
  80139e:	56                   	push   %esi
  80139f:	53                   	push   %ebx
  8013a0:	83 ec 0c             	sub    $0xc,%esp
  8013a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ae:	eb 21                	jmp    8013d1 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	89 f0                	mov    %esi,%eax
  8013b5:	29 d8                	sub    %ebx,%eax
  8013b7:	50                   	push   %eax
  8013b8:	89 d8                	mov    %ebx,%eax
  8013ba:	03 45 0c             	add    0xc(%ebp),%eax
  8013bd:	50                   	push   %eax
  8013be:	57                   	push   %edi
  8013bf:	e8 45 ff ff ff       	call   801309 <read>
		if (m < 0)
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 10                	js     8013db <readn+0x41>
			return m;
		if (m == 0)
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	74 0a                	je     8013d9 <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013cf:	01 c3                	add    %eax,%ebx
  8013d1:	39 f3                	cmp    %esi,%ebx
  8013d3:	72 db                	jb     8013b0 <readn+0x16>
  8013d5:	89 d8                	mov    %ebx,%eax
  8013d7:	eb 02                	jmp    8013db <readn+0x41>
  8013d9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013de:	5b                   	pop    %ebx
  8013df:	5e                   	pop    %esi
  8013e0:	5f                   	pop    %edi
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	53                   	push   %ebx
  8013e7:	83 ec 14             	sub    $0x14,%esp
  8013ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	53                   	push   %ebx
  8013f2:	e8 ad fc ff ff       	call   8010a4 <fd_lookup>
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	89 c2                	mov    %eax,%edx
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 68                	js     801468 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801406:	50                   	push   %eax
  801407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140a:	ff 30                	pushl  (%eax)
  80140c:	e8 e9 fc ff ff       	call   8010fa <dev_lookup>
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	78 47                	js     80145f <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141f:	75 21                	jne    801442 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801421:	a1 20 44 80 00       	mov    0x804420,%eax
  801426:	8b 40 48             	mov    0x48(%eax),%eax
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	53                   	push   %ebx
  80142d:	50                   	push   %eax
  80142e:	68 6c 26 80 00       	push   $0x80266c
  801433:	e8 c9 ef ff ff       	call   800401 <cprintf>
		return -E_INVAL;
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801440:	eb 26                	jmp    801468 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801445:	8b 52 0c             	mov    0xc(%edx),%edx
  801448:	85 d2                	test   %edx,%edx
  80144a:	74 17                	je     801463 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	ff 75 10             	pushl  0x10(%ebp)
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	50                   	push   %eax
  801456:	ff d2                	call   *%edx
  801458:	89 c2                	mov    %eax,%edx
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	eb 09                	jmp    801468 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145f:	89 c2                	mov    %eax,%edx
  801461:	eb 05                	jmp    801468 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801463:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  801468:	89 d0                	mov    %edx,%eax
  80146a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <seek>:

int
seek(int fdnum, off_t offset)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801475:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	ff 75 08             	pushl  0x8(%ebp)
  80147c:	e8 23 fc ff ff       	call   8010a4 <fd_lookup>
  801481:	83 c4 08             	add    $0x8,%esp
  801484:	85 c0                	test   %eax,%eax
  801486:	78 0e                	js     801496 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801488:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801491:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	53                   	push   %ebx
  80149c:	83 ec 14             	sub    $0x14,%esp
  80149f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a5:	50                   	push   %eax
  8014a6:	53                   	push   %ebx
  8014a7:	e8 f8 fb ff ff       	call   8010a4 <fd_lookup>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	89 c2                	mov    %eax,%edx
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 65                	js     80151a <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bb:	50                   	push   %eax
  8014bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bf:	ff 30                	pushl  (%eax)
  8014c1:	e8 34 fc ff ff       	call   8010fa <dev_lookup>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	78 44                	js     801511 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d4:	75 21                	jne    8014f7 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014d6:	a1 20 44 80 00       	mov    0x804420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014db:	8b 40 48             	mov    0x48(%eax),%eax
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	53                   	push   %ebx
  8014e2:	50                   	push   %eax
  8014e3:	68 2c 26 80 00       	push   $0x80262c
  8014e8:	e8 14 ef ff ff       	call   800401 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8014f5:	eb 23                	jmp    80151a <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  8014f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fa:	8b 52 18             	mov    0x18(%edx),%edx
  8014fd:	85 d2                	test   %edx,%edx
  8014ff:	74 14                	je     801515 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801501:	83 ec 08             	sub    $0x8,%esp
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	50                   	push   %eax
  801508:	ff d2                	call   *%edx
  80150a:	89 c2                	mov    %eax,%edx
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	eb 09                	jmp    80151a <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801511:	89 c2                	mov    %eax,%edx
  801513:	eb 05                	jmp    80151a <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801515:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  80151a:	89 d0                	mov    %edx,%eax
  80151c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	53                   	push   %ebx
  801525:	83 ec 14             	sub    $0x14,%esp
  801528:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152e:	50                   	push   %eax
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 6d fb ff ff       	call   8010a4 <fd_lookup>
  801537:	83 c4 08             	add    $0x8,%esp
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 58                	js     801598 <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154a:	ff 30                	pushl  (%eax)
  80154c:	e8 a9 fb ff ff       	call   8010fa <dev_lookup>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 37                	js     80158f <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  801558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80155f:	74 32                	je     801593 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801561:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801564:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80156b:	00 00 00 
	stat->st_isdir = 0;
  80156e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801575:	00 00 00 
	stat->st_dev = dev;
  801578:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80157e:	83 ec 08             	sub    $0x8,%esp
  801581:	53                   	push   %ebx
  801582:	ff 75 f0             	pushl  -0x10(%ebp)
  801585:	ff 50 14             	call   *0x14(%eax)
  801588:	89 c2                	mov    %eax,%edx
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	eb 09                	jmp    801598 <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158f:	89 c2                	mov    %eax,%edx
  801591:	eb 05                	jmp    801598 <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801593:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801598:	89 d0                	mov    %edx,%eax
  80159a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	56                   	push   %esi
  8015a3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	6a 00                	push   $0x0
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 06 02 00 00       	call   8017b7 <open>
  8015b1:	89 c3                	mov    %eax,%ebx
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 1b                	js     8015d5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	50                   	push   %eax
  8015c1:	e8 5b ff ff ff       	call   801521 <fstat>
  8015c6:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c8:	89 1c 24             	mov    %ebx,(%esp)
  8015cb:	e8 fd fb ff ff       	call   8011cd <close>
	return r;
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	89 f0                	mov    %esi,%eax
}
  8015d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d8:	5b                   	pop    %ebx
  8015d9:	5e                   	pop    %esi
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	56                   	push   %esi
  8015e0:	53                   	push   %ebx
  8015e1:	89 c6                	mov    %eax,%esi
  8015e3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015e5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015ec:	75 12                	jne    801600 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	6a 01                	push   $0x1
  8015f3:	e8 11 09 00 00       	call   801f09 <ipc_find_env>
  8015f8:	a3 00 40 80 00       	mov    %eax,0x804000
  8015fd:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801600:	6a 07                	push   $0x7
  801602:	68 00 50 80 00       	push   $0x805000
  801607:	56                   	push   %esi
  801608:	ff 35 00 40 80 00    	pushl  0x804000
  80160e:	e8 a2 08 00 00       	call   801eb5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801613:	83 c4 0c             	add    $0xc,%esp
  801616:	6a 00                	push   $0x0
  801618:	53                   	push   %ebx
  801619:	6a 00                	push   $0x0
  80161b:	e8 2a 08 00 00       	call   801e4a <ipc_recv>
}
  801620:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801623:	5b                   	pop    %ebx
  801624:	5e                   	pop    %esi
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    

00801627 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8b 40 0c             	mov    0xc(%eax),%eax
  801633:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801640:	ba 00 00 00 00       	mov    $0x0,%edx
  801645:	b8 02 00 00 00       	mov    $0x2,%eax
  80164a:	e8 8d ff ff ff       	call   8015dc <fsipc>
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8b 40 0c             	mov    0xc(%eax),%eax
  80165d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801662:	ba 00 00 00 00       	mov    $0x0,%edx
  801667:	b8 06 00 00 00       	mov    $0x6,%eax
  80166c:	e8 6b ff ff ff       	call   8015dc <fsipc>
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	53                   	push   %ebx
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	8b 40 0c             	mov    0xc(%eax),%eax
  801683:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801688:	ba 00 00 00 00       	mov    $0x0,%edx
  80168d:	b8 05 00 00 00       	mov    $0x5,%eax
  801692:	e8 45 ff ff ff       	call   8015dc <fsipc>
  801697:	85 c0                	test   %eax,%eax
  801699:	78 2c                	js     8016c7 <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	68 00 50 80 00       	push   $0x805000
  8016a3:	53                   	push   %ebx
  8016a4:	e8 ca f2 ff ff       	call   800973 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016a9:	a1 80 50 80 00       	mov    0x805080,%eax
  8016ae:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016b4:	a1 84 50 80 00       	mov    0x805084,%eax
  8016b9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 08             	sub    $0x8,%esp
  8016d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016db:	8b 49 0c             	mov    0xc(%ecx),%ecx
  8016de:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  8016e4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016e9:	76 22                	jbe    80170d <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  8016eb:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  8016f2:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	68 f8 0f 00 00       	push   $0xff8
  8016fd:	52                   	push   %edx
  8016fe:	68 08 50 80 00       	push   $0x805008
  801703:	e8 fe f3 ff ff       	call   800b06 <memmove>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	eb 17                	jmp    801724 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  80170d:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	50                   	push   %eax
  801716:	52                   	push   %edx
  801717:	68 08 50 80 00       	push   $0x805008
  80171c:	e8 e5 f3 ff ff       	call   800b06 <memmove>
  801721:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	b8 04 00 00 00       	mov    $0x4,%eax
  80172e:	e8 a9 fe ff ff       	call   8015dc <fsipc>
	if (result < 0)
		return result;

	return result;
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	56                   	push   %esi
  801739:	53                   	push   %ebx
  80173a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 40 0c             	mov    0xc(%eax),%eax
  801743:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801748:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	b8 03 00 00 00       	mov    $0x3,%eax
  801758:	e8 7f fe ff ff       	call   8015dc <fsipc>
  80175d:	89 c3                	mov    %eax,%ebx
  80175f:	85 c0                	test   %eax,%eax
  801761:	78 4b                	js     8017ae <devfile_read+0x79>
		return r;
	assert(r <= n);
  801763:	39 c6                	cmp    %eax,%esi
  801765:	73 16                	jae    80177d <devfile_read+0x48>
  801767:	68 9c 26 80 00       	push   $0x80269c
  80176c:	68 a3 26 80 00       	push   $0x8026a3
  801771:	6a 7c                	push   $0x7c
  801773:	68 b8 26 80 00       	push   $0x8026b8
  801778:	e8 ab eb ff ff       	call   800328 <_panic>
	assert(r <= PGSIZE);
  80177d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801782:	7e 16                	jle    80179a <devfile_read+0x65>
  801784:	68 c3 26 80 00       	push   $0x8026c3
  801789:	68 a3 26 80 00       	push   $0x8026a3
  80178e:	6a 7d                	push   $0x7d
  801790:	68 b8 26 80 00       	push   $0x8026b8
  801795:	e8 8e eb ff ff       	call   800328 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	50                   	push   %eax
  80179e:	68 00 50 80 00       	push   $0x805000
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	e8 5b f3 ff ff       	call   800b06 <memmove>
	return r;
  8017ab:	83 c4 10             	add    $0x10,%esp
}
  8017ae:	89 d8                	mov    %ebx,%eax
  8017b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 20             	sub    $0x20,%esp
  8017be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017c1:	53                   	push   %ebx
  8017c2:	e8 73 f1 ff ff       	call   80093a <strlen>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017cf:	7f 67                	jg     801838 <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017d1:	83 ec 0c             	sub    $0xc,%esp
  8017d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d7:	50                   	push   %eax
  8017d8:	e8 78 f8 ff ff       	call   801055 <fd_alloc>
  8017dd:	83 c4 10             	add    $0x10,%esp
		return r;
  8017e0:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 57                	js     80183d <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	53                   	push   %ebx
  8017ea:	68 00 50 80 00       	push   $0x805000
  8017ef:	e8 7f f1 ff ff       	call   800973 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f7:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801804:	e8 d3 fd ff ff       	call   8015dc <fsipc>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	79 14                	jns    801826 <open+0x6f>
		fd_close(fd, 0);
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	6a 00                	push   $0x0
  801817:	ff 75 f4             	pushl  -0xc(%ebp)
  80181a:	e8 2e f9 ff ff       	call   80114d <fd_close>
		return r;
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	89 da                	mov    %ebx,%edx
  801824:	eb 17                	jmp    80183d <open+0x86>
	}

	return fd2num(fd);
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	ff 75 f4             	pushl  -0xc(%ebp)
  80182c:	e8 fc f7 ff ff       	call   80102d <fd2num>
  801831:	89 c2                	mov    %eax,%edx
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	eb 05                	jmp    80183d <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801838:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80183d:	89 d0                	mov    %edx,%eax
  80183f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	b8 08 00 00 00       	mov    $0x8,%eax
  801854:	e8 83 fd ff ff       	call   8015dc <fsipc>
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80185b:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80185f:	7e 37                	jle    801898 <writebuf+0x3d>
};


static void
writebuf(struct printbuf *b)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	53                   	push   %ebx
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
  80186a:	ff 70 04             	pushl  0x4(%eax)
  80186d:	8d 40 10             	lea    0x10(%eax),%eax
  801870:	50                   	push   %eax
  801871:	ff 33                	pushl  (%ebx)
  801873:	e8 6b fb ff ff       	call   8013e3 <write>
		if (result > 0)
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	85 c0                	test   %eax,%eax
  80187d:	7e 03                	jle    801882 <writebuf+0x27>
			b->result += result;
  80187f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801882:	3b 43 04             	cmp    0x4(%ebx),%eax
  801885:	74 0d                	je     801894 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  801887:	85 c0                	test   %eax,%eax
  801889:	ba 00 00 00 00       	mov    $0x0,%edx
  80188e:	0f 4f c2             	cmovg  %edx,%eax
  801891:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801897:	c9                   	leave  
  801898:	f3 c3                	repz ret 

0080189a <putch>:

static void
putch(int ch, void *thunk)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	53                   	push   %ebx
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8018a4:	8b 53 04             	mov    0x4(%ebx),%edx
  8018a7:	8d 42 01             	lea    0x1(%edx),%eax
  8018aa:	89 43 04             	mov    %eax,0x4(%ebx)
  8018ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b0:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8018b4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8018b9:	75 0e                	jne    8018c9 <putch+0x2f>
		writebuf(b);
  8018bb:	89 d8                	mov    %ebx,%eax
  8018bd:	e8 99 ff ff ff       	call   80185b <writebuf>
		b->idx = 0;
  8018c2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8018c9:	83 c4 04             	add    $0x4,%esp
  8018cc:	5b                   	pop    %ebx
  8018cd:	5d                   	pop    %ebp
  8018ce:	c3                   	ret    

008018cf <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018e1:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018e8:	00 00 00 
	b.result = 0;
  8018eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018f2:	00 00 00 
	b.error = 1;
  8018f5:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018fc:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018ff:	ff 75 10             	pushl  0x10(%ebp)
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80190b:	50                   	push   %eax
  80190c:	68 9a 18 80 00       	push   $0x80189a
  801911:	e8 54 ec ff ff       	call   80056a <vprintfmt>
	if (b.idx > 0)
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801920:	7e 0b                	jle    80192d <vfprintf+0x5e>
		writebuf(&b);
  801922:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801928:	e8 2e ff ff ff       	call   80185b <writebuf>

	return (b.result ? b.result : b.error);
  80192d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801933:	85 c0                	test   %eax,%eax
  801935:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801944:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801947:	50                   	push   %eax
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	e8 7c ff ff ff       	call   8018cf <vfprintf>
	va_end(ap);

	return cnt;
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <printf>:

int
printf(const char *fmt, ...)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80195b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80195e:	50                   	push   %eax
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 01                	push   $0x1
  801964:	e8 66 ff ff ff       	call   8018cf <vfprintf>
	va_end(ap);

	return cnt;
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801973:	83 ec 0c             	sub    $0xc,%esp
  801976:	ff 75 08             	pushl  0x8(%ebp)
  801979:	e8 bf f6 ff ff       	call   80103d <fd2data>
  80197e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801980:	83 c4 08             	add    $0x8,%esp
  801983:	68 cf 26 80 00       	push   $0x8026cf
  801988:	53                   	push   %ebx
  801989:	e8 e5 ef ff ff       	call   800973 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80198e:	8b 46 04             	mov    0x4(%esi),%eax
  801991:	2b 06                	sub    (%esi),%eax
  801993:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801999:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019a0:	00 00 00 
	stat->st_dev = &devpipe;
  8019a3:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019aa:	30 80 00 
	return 0;
}
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b5:	5b                   	pop    %ebx
  8019b6:	5e                   	pop    %esi
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    

008019b9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	53                   	push   %ebx
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019c3:	53                   	push   %ebx
  8019c4:	6a 00                	push   $0x0
  8019c6:	e8 3b f4 ff ff       	call   800e06 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019cb:	89 1c 24             	mov    %ebx,(%esp)
  8019ce:	e8 6a f6 ff ff       	call   80103d <fd2data>
  8019d3:	83 c4 08             	add    $0x8,%esp
  8019d6:	50                   	push   %eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	e8 28 f4 ff ff       	call   800e06 <sys_page_unmap>
}
  8019de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	57                   	push   %edi
  8019e7:	56                   	push   %esi
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 1c             	sub    $0x1c,%esp
  8019ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019ef:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8019f1:	a1 20 44 80 00       	mov    0x804420,%eax
  8019f6:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8019ff:	e8 3e 05 00 00       	call   801f42 <pageref>
  801a04:	89 c3                	mov    %eax,%ebx
  801a06:	89 3c 24             	mov    %edi,(%esp)
  801a09:	e8 34 05 00 00       	call   801f42 <pageref>
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	39 c3                	cmp    %eax,%ebx
  801a13:	0f 94 c1             	sete   %cl
  801a16:	0f b6 c9             	movzbl %cl,%ecx
  801a19:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  801a1c:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801a22:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a25:	39 ce                	cmp    %ecx,%esi
  801a27:	74 1b                	je     801a44 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801a29:	39 c3                	cmp    %eax,%ebx
  801a2b:	75 c4                	jne    8019f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a2d:	8b 42 58             	mov    0x58(%edx),%eax
  801a30:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a33:	50                   	push   %eax
  801a34:	56                   	push   %esi
  801a35:	68 d6 26 80 00       	push   $0x8026d6
  801a3a:	e8 c2 e9 ff ff       	call   800401 <cprintf>
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	eb ad                	jmp    8019f1 <_pipeisclosed+0xe>
	}
}
  801a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4a:	5b                   	pop    %ebx
  801a4b:	5e                   	pop    %esi
  801a4c:	5f                   	pop    %edi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    

00801a4f <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	57                   	push   %edi
  801a53:	56                   	push   %esi
  801a54:	53                   	push   %ebx
  801a55:	83 ec 28             	sub    $0x28,%esp
  801a58:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801a5b:	56                   	push   %esi
  801a5c:	e8 dc f5 ff ff       	call   80103d <fd2data>
  801a61:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6b:	eb 4b                	jmp    801ab8 <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801a6d:	89 da                	mov    %ebx,%edx
  801a6f:	89 f0                	mov    %esi,%eax
  801a71:	e8 6d ff ff ff       	call   8019e3 <_pipeisclosed>
  801a76:	85 c0                	test   %eax,%eax
  801a78:	75 48                	jne    801ac2 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801a7a:	e8 16 f3 ff ff       	call   800d95 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a7f:	8b 43 04             	mov    0x4(%ebx),%eax
  801a82:	8b 0b                	mov    (%ebx),%ecx
  801a84:	8d 51 20             	lea    0x20(%ecx),%edx
  801a87:	39 d0                	cmp    %edx,%eax
  801a89:	73 e2                	jae    801a6d <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a92:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a95:	89 c2                	mov    %eax,%edx
  801a97:	c1 fa 1f             	sar    $0x1f,%edx
  801a9a:	89 d1                	mov    %edx,%ecx
  801a9c:	c1 e9 1b             	shr    $0x1b,%ecx
  801a9f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801aa2:	83 e2 1f             	and    $0x1f,%edx
  801aa5:	29 ca                	sub    %ecx,%edx
  801aa7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801aaf:	83 c0 01             	add    $0x1,%eax
  801ab2:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ab5:	83 c7 01             	add    $0x1,%edi
  801ab8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801abb:	75 c2                	jne    801a7f <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801abd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac0:	eb 05                	jmp    801ac7 <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ac2:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aca:	5b                   	pop    %ebx
  801acb:	5e                   	pop    %esi
  801acc:	5f                   	pop    %edi
  801acd:	5d                   	pop    %ebp
  801ace:	c3                   	ret    

00801acf <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	57                   	push   %edi
  801ad3:	56                   	push   %esi
  801ad4:	53                   	push   %ebx
  801ad5:	83 ec 18             	sub    $0x18,%esp
  801ad8:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801adb:	57                   	push   %edi
  801adc:	e8 5c f5 ff ff       	call   80103d <fd2data>
  801ae1:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aeb:	eb 3d                	jmp    801b2a <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801aed:	85 db                	test   %ebx,%ebx
  801aef:	74 04                	je     801af5 <devpipe_read+0x26>
				return i;
  801af1:	89 d8                	mov    %ebx,%eax
  801af3:	eb 44                	jmp    801b39 <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801af5:	89 f2                	mov    %esi,%edx
  801af7:	89 f8                	mov    %edi,%eax
  801af9:	e8 e5 fe ff ff       	call   8019e3 <_pipeisclosed>
  801afe:	85 c0                	test   %eax,%eax
  801b00:	75 32                	jne    801b34 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801b02:	e8 8e f2 ff ff       	call   800d95 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801b07:	8b 06                	mov    (%esi),%eax
  801b09:	3b 46 04             	cmp    0x4(%esi),%eax
  801b0c:	74 df                	je     801aed <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b0e:	99                   	cltd   
  801b0f:	c1 ea 1b             	shr    $0x1b,%edx
  801b12:	01 d0                	add    %edx,%eax
  801b14:	83 e0 1f             	and    $0x1f,%eax
  801b17:	29 d0                	sub    %edx,%eax
  801b19:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  801b1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b21:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801b24:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801b27:	83 c3 01             	add    $0x1,%ebx
  801b2a:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801b2d:	75 d8                	jne    801b07 <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801b2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b32:	eb 05                	jmp    801b39 <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3c:	5b                   	pop    %ebx
  801b3d:	5e                   	pop    %esi
  801b3e:	5f                   	pop    %edi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    

00801b41 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	56                   	push   %esi
  801b45:	53                   	push   %ebx
  801b46:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801b49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4c:	50                   	push   %eax
  801b4d:	e8 03 f5 ff ff       	call   801055 <fd_alloc>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	89 c2                	mov    %eax,%edx
  801b57:	85 c0                	test   %eax,%eax
  801b59:	0f 88 2c 01 00 00    	js     801c8b <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	68 07 04 00 00       	push   $0x407
  801b67:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6a:	6a 00                	push   $0x0
  801b6c:	e8 4b f2 ff ff       	call   800dbc <sys_page_alloc>
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	89 c2                	mov    %eax,%edx
  801b76:	85 c0                	test   %eax,%eax
  801b78:	0f 88 0d 01 00 00    	js     801c8b <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b84:	50                   	push   %eax
  801b85:	e8 cb f4 ff ff       	call   801055 <fd_alloc>
  801b8a:	89 c3                	mov    %eax,%ebx
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	0f 88 e2 00 00 00    	js     801c79 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	68 07 04 00 00       	push   $0x407
  801b9f:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 13 f2 ff ff       	call   800dbc <sys_page_alloc>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	0f 88 c3 00 00 00    	js     801c79 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801bb6:	83 ec 0c             	sub    $0xc,%esp
  801bb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbc:	e8 7c f4 ff ff       	call   80103d <fd2data>
  801bc1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc3:	83 c4 0c             	add    $0xc,%esp
  801bc6:	68 07 04 00 00       	push   $0x407
  801bcb:	50                   	push   %eax
  801bcc:	6a 00                	push   $0x0
  801bce:	e8 e9 f1 ff ff       	call   800dbc <sys_page_alloc>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	0f 88 89 00 00 00    	js     801c69 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	ff 75 f0             	pushl  -0x10(%ebp)
  801be6:	e8 52 f4 ff ff       	call   80103d <fd2data>
  801beb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bf2:	50                   	push   %eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	56                   	push   %esi
  801bf6:	6a 00                	push   $0x0
  801bf8:	e8 e3 f1 ff ff       	call   800de0 <sys_page_map>
  801bfd:	89 c3                	mov    %eax,%ebx
  801bff:	83 c4 20             	add    $0x20,%esp
  801c02:	85 c0                	test   %eax,%eax
  801c04:	78 55                	js     801c5b <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801c06:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801c1b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c24:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c29:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801c30:	83 ec 0c             	sub    $0xc,%esp
  801c33:	ff 75 f4             	pushl  -0xc(%ebp)
  801c36:	e8 f2 f3 ff ff       	call   80102d <fd2num>
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c40:	83 c4 04             	add    $0x4,%esp
  801c43:	ff 75 f0             	pushl  -0x10(%ebp)
  801c46:	e8 e2 f3 ff ff       	call   80102d <fd2num>
  801c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	ba 00 00 00 00       	mov    $0x0,%edx
  801c59:	eb 30                	jmp    801c8b <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  801c5b:	83 ec 08             	sub    $0x8,%esp
  801c5e:	56                   	push   %esi
  801c5f:	6a 00                	push   $0x0
  801c61:	e8 a0 f1 ff ff       	call   800e06 <sys_page_unmap>
  801c66:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801c69:	83 ec 08             	sub    $0x8,%esp
  801c6c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c6f:	6a 00                	push   $0x0
  801c71:	e8 90 f1 ff ff       	call   800e06 <sys_page_unmap>
  801c76:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801c79:	83 ec 08             	sub    $0x8,%esp
  801c7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7f:	6a 00                	push   $0x0
  801c81:	e8 80 f1 ff ff       	call   800e06 <sys_page_unmap>
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  801c8b:	89 d0                	mov    %edx,%eax
  801c8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    

00801c94 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9d:	50                   	push   %eax
  801c9e:	ff 75 08             	pushl  0x8(%ebp)
  801ca1:	e8 fe f3 ff ff       	call   8010a4 <fd_lookup>
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	78 18                	js     801cc5 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb3:	e8 85 f3 ff ff       	call   80103d <fd2data>
	return _pipeisclosed(fd, p);
  801cb8:	89 c2                	mov    %eax,%edx
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	e8 21 fd ff ff       	call   8019e3 <_pipeisclosed>
  801cc2:	83 c4 10             	add    $0x10,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccf:	5d                   	pop    %ebp
  801cd0:	c3                   	ret    

00801cd1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801cd7:	68 ee 26 80 00       	push   $0x8026ee
  801cdc:	ff 75 0c             	pushl  0xc(%ebp)
  801cdf:	e8 8f ec ff ff       	call   800973 <strcpy>
	return 0;
}
  801ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	57                   	push   %edi
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cf7:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801cfc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d02:	eb 2d                	jmp    801d31 <devcons_write+0x46>
		m = n - tot;
  801d04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d07:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801d09:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801d0c:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801d11:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	53                   	push   %ebx
  801d18:	03 45 0c             	add    0xc(%ebp),%eax
  801d1b:	50                   	push   %eax
  801d1c:	57                   	push   %edi
  801d1d:	e8 e4 ed ff ff       	call   800b06 <memmove>
		sys_cputs(buf, m);
  801d22:	83 c4 08             	add    $0x8,%esp
  801d25:	53                   	push   %ebx
  801d26:	57                   	push   %edi
  801d27:	e8 d9 ef ff ff       	call   800d05 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d2c:	01 de                	add    %ebx,%esi
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	89 f0                	mov    %esi,%eax
  801d33:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d36:	72 cc                	jb     801d04 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5f                   	pop    %edi
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    

00801d40 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 08             	sub    $0x8,%esp
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  801d4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d4f:	74 2a                	je     801d7b <devcons_read+0x3b>
  801d51:	eb 05                	jmp    801d58 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d53:	e8 3d f0 ff ff       	call   800d95 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d58:	e8 ce ef ff ff       	call   800d2b <sys_cgetc>
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	74 f2                	je     801d53 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801d61:	85 c0                	test   %eax,%eax
  801d63:	78 16                	js     801d7b <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d65:	83 f8 04             	cmp    $0x4,%eax
  801d68:	74 0c                	je     801d76 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	88 02                	mov    %al,(%edx)
	return 1;
  801d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d74:	eb 05                	jmp    801d7b <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801d89:	6a 01                	push   $0x1
  801d8b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d8e:	50                   	push   %eax
  801d8f:	e8 71 ef ff ff       	call   800d05 <sys_cputs>
}
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <getchar>:

int
getchar(void)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801d9f:	6a 01                	push   $0x1
  801da1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801da4:	50                   	push   %eax
  801da5:	6a 00                	push   $0x0
  801da7:	e8 5d f5 ff ff       	call   801309 <read>
	if (r < 0)
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	85 c0                	test   %eax,%eax
  801db1:	78 0f                	js     801dc2 <getchar+0x29>
		return r;
	if (r < 1)
  801db3:	85 c0                	test   %eax,%eax
  801db5:	7e 06                	jle    801dbd <getchar+0x24>
		return -E_EOF;
	return c;
  801db7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801dbb:	eb 05                	jmp    801dc2 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801dbd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dcd:	50                   	push   %eax
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	e8 ce f2 ff ff       	call   8010a4 <fd_lookup>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	78 11                	js     801dee <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801de6:	39 10                	cmp    %edx,(%eax)
  801de8:	0f 94 c0             	sete   %al
  801deb:	0f b6 c0             	movzbl %al,%eax
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <opencons>:

int
opencons(void)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801df6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df9:	50                   	push   %eax
  801dfa:	e8 56 f2 ff ff       	call   801055 <fd_alloc>
  801dff:	83 c4 10             	add    $0x10,%esp
		return r;
  801e02:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801e04:	85 c0                	test   %eax,%eax
  801e06:	78 3e                	js     801e46 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	68 07 04 00 00       	push   $0x407
  801e10:	ff 75 f4             	pushl  -0xc(%ebp)
  801e13:	6a 00                	push   $0x0
  801e15:	e8 a2 ef ff ff       	call   800dbc <sys_page_alloc>
  801e1a:	83 c4 10             	add    $0x10,%esp
		return r;
  801e1d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 23                	js     801e46 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801e23:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e38:	83 ec 0c             	sub    $0xc,%esp
  801e3b:	50                   	push   %eax
  801e3c:	e8 ec f1 ff ff       	call   80102d <fd2num>
  801e41:	89 c2                	mov    %eax,%edx
  801e43:	83 c4 10             	add    $0x10,%esp
}
  801e46:	89 d0                	mov    %edx,%eax
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	56                   	push   %esi
  801e4e:	53                   	push   %ebx
  801e4f:	8b 75 08             	mov    0x8(%ebp),%esi
  801e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801e58:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801e5a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e5f:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	50                   	push   %eax
  801e66:	e8 4c f0 ff ff       	call   800eb7 <sys_ipc_recv>
	if (from_env_store)
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 f6                	test   %esi,%esi
  801e70:	74 0b                	je     801e7d <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801e72:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801e78:	8b 52 74             	mov    0x74(%edx),%edx
  801e7b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801e7d:	85 db                	test   %ebx,%ebx
  801e7f:	74 0b                	je     801e8c <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801e81:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801e87:	8b 52 78             	mov    0x78(%edx),%edx
  801e8a:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	79 16                	jns    801ea6 <ipc_recv+0x5c>
		if (from_env_store)
  801e90:	85 f6                	test   %esi,%esi
  801e92:	74 06                	je     801e9a <ipc_recv+0x50>
			*from_env_store = 0;
  801e94:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801e9a:	85 db                	test   %ebx,%ebx
  801e9c:	74 10                	je     801eae <ipc_recv+0x64>
			*perm_store = 0;
  801e9e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ea4:	eb 08                	jmp    801eae <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801ea6:	a1 20 44 80 00       	mov    0x804420,%eax
  801eab:	8b 40 70             	mov    0x70(%eax),%eax
}
  801eae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5d                   	pop    %ebp
  801eb4:	c3                   	ret    

00801eb5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	57                   	push   %edi
  801eb9:	56                   	push   %esi
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 0c             	sub    $0xc,%esp
  801ebe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ec1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ec4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801ec7:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801ec9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ece:	0f 44 d8             	cmove  %eax,%ebx
  801ed1:	eb 1c                	jmp    801eef <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801ed3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ed6:	74 12                	je     801eea <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801ed8:	50                   	push   %eax
  801ed9:	68 fa 26 80 00       	push   $0x8026fa
  801ede:	6a 42                	push   $0x42
  801ee0:	68 10 27 80 00       	push   $0x802710
  801ee5:	e8 3e e4 ff ff       	call   800328 <_panic>
		sys_yield();
  801eea:	e8 a6 ee ff ff       	call   800d95 <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801eef:	ff 75 14             	pushl  0x14(%ebp)
  801ef2:	53                   	push   %ebx
  801ef3:	56                   	push   %esi
  801ef4:	57                   	push   %edi
  801ef5:	e8 98 ef ff ff       	call   800e92 <sys_ipc_try_send>
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 d2                	jne    801ed3 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f04:	5b                   	pop    %ebx
  801f05:	5e                   	pop    %esi
  801f06:	5f                   	pop    %edi
  801f07:	5d                   	pop    %ebp
  801f08:	c3                   	ret    

00801f09 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f14:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f17:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f1d:	8b 52 50             	mov    0x50(%edx),%edx
  801f20:	39 ca                	cmp    %ecx,%edx
  801f22:	75 0d                	jne    801f31 <ipc_find_env+0x28>
			return envs[i].env_id;
  801f24:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f27:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f2c:	8b 40 48             	mov    0x48(%eax),%eax
  801f2f:	eb 0f                	jmp    801f40 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801f31:	83 c0 01             	add    $0x1,%eax
  801f34:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f39:	75 d9                	jne    801f14 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    

00801f42 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f48:	89 d0                	mov    %edx,%eax
  801f4a:	c1 e8 16             	shr    $0x16,%eax
  801f4d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f59:	f6 c1 01             	test   $0x1,%cl
  801f5c:	74 1d                	je     801f7b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f5e:	c1 ea 0c             	shr    $0xc,%edx
  801f61:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f68:	f6 c2 01             	test   $0x1,%dl
  801f6b:	74 0e                	je     801f7b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f6d:	c1 ea 0c             	shr    $0xc,%edx
  801f70:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f77:	ef 
  801f78:	0f b7 c0             	movzwl %ax,%eax
}
  801f7b:	5d                   	pop    %ebp
  801f7c:	c3                   	ret    
  801f7d:	66 90                	xchg   %ax,%ax
  801f7f:	90                   	nop

00801f80 <__udivdi3>:
  801f80:	55                   	push   %ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	83 ec 1c             	sub    $0x1c,%esp
  801f87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f97:	85 f6                	test   %esi,%esi
  801f99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f9d:	89 ca                	mov    %ecx,%edx
  801f9f:	89 f8                	mov    %edi,%eax
  801fa1:	75 3d                	jne    801fe0 <__udivdi3+0x60>
  801fa3:	39 cf                	cmp    %ecx,%edi
  801fa5:	0f 87 c5 00 00 00    	ja     802070 <__udivdi3+0xf0>
  801fab:	85 ff                	test   %edi,%edi
  801fad:	89 fd                	mov    %edi,%ebp
  801faf:	75 0b                	jne    801fbc <__udivdi3+0x3c>
  801fb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb6:	31 d2                	xor    %edx,%edx
  801fb8:	f7 f7                	div    %edi
  801fba:	89 c5                	mov    %eax,%ebp
  801fbc:	89 c8                	mov    %ecx,%eax
  801fbe:	31 d2                	xor    %edx,%edx
  801fc0:	f7 f5                	div    %ebp
  801fc2:	89 c1                	mov    %eax,%ecx
  801fc4:	89 d8                	mov    %ebx,%eax
  801fc6:	89 cf                	mov    %ecx,%edi
  801fc8:	f7 f5                	div    %ebp
  801fca:	89 c3                	mov    %eax,%ebx
  801fcc:	89 d8                	mov    %ebx,%eax
  801fce:	89 fa                	mov    %edi,%edx
  801fd0:	83 c4 1c             	add    $0x1c,%esp
  801fd3:	5b                   	pop    %ebx
  801fd4:	5e                   	pop    %esi
  801fd5:	5f                   	pop    %edi
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    
  801fd8:	90                   	nop
  801fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fe0:	39 ce                	cmp    %ecx,%esi
  801fe2:	77 74                	ja     802058 <__udivdi3+0xd8>
  801fe4:	0f bd fe             	bsr    %esi,%edi
  801fe7:	83 f7 1f             	xor    $0x1f,%edi
  801fea:	0f 84 98 00 00 00    	je     802088 <__udivdi3+0x108>
  801ff0:	bb 20 00 00 00       	mov    $0x20,%ebx
  801ff5:	89 f9                	mov    %edi,%ecx
  801ff7:	89 c5                	mov    %eax,%ebp
  801ff9:	29 fb                	sub    %edi,%ebx
  801ffb:	d3 e6                	shl    %cl,%esi
  801ffd:	89 d9                	mov    %ebx,%ecx
  801fff:	d3 ed                	shr    %cl,%ebp
  802001:	89 f9                	mov    %edi,%ecx
  802003:	d3 e0                	shl    %cl,%eax
  802005:	09 ee                	or     %ebp,%esi
  802007:	89 d9                	mov    %ebx,%ecx
  802009:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80200d:	89 d5                	mov    %edx,%ebp
  80200f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802013:	d3 ed                	shr    %cl,%ebp
  802015:	89 f9                	mov    %edi,%ecx
  802017:	d3 e2                	shl    %cl,%edx
  802019:	89 d9                	mov    %ebx,%ecx
  80201b:	d3 e8                	shr    %cl,%eax
  80201d:	09 c2                	or     %eax,%edx
  80201f:	89 d0                	mov    %edx,%eax
  802021:	89 ea                	mov    %ebp,%edx
  802023:	f7 f6                	div    %esi
  802025:	89 d5                	mov    %edx,%ebp
  802027:	89 c3                	mov    %eax,%ebx
  802029:	f7 64 24 0c          	mull   0xc(%esp)
  80202d:	39 d5                	cmp    %edx,%ebp
  80202f:	72 10                	jb     802041 <__udivdi3+0xc1>
  802031:	8b 74 24 08          	mov    0x8(%esp),%esi
  802035:	89 f9                	mov    %edi,%ecx
  802037:	d3 e6                	shl    %cl,%esi
  802039:	39 c6                	cmp    %eax,%esi
  80203b:	73 07                	jae    802044 <__udivdi3+0xc4>
  80203d:	39 d5                	cmp    %edx,%ebp
  80203f:	75 03                	jne    802044 <__udivdi3+0xc4>
  802041:	83 eb 01             	sub    $0x1,%ebx
  802044:	31 ff                	xor    %edi,%edi
  802046:	89 d8                	mov    %ebx,%eax
  802048:	89 fa                	mov    %edi,%edx
  80204a:	83 c4 1c             	add    $0x1c,%esp
  80204d:	5b                   	pop    %ebx
  80204e:	5e                   	pop    %esi
  80204f:	5f                   	pop    %edi
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    
  802052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802058:	31 ff                	xor    %edi,%edi
  80205a:	31 db                	xor    %ebx,%ebx
  80205c:	89 d8                	mov    %ebx,%eax
  80205e:	89 fa                	mov    %edi,%edx
  802060:	83 c4 1c             	add    $0x1c,%esp
  802063:	5b                   	pop    %ebx
  802064:	5e                   	pop    %esi
  802065:	5f                   	pop    %edi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    
  802068:	90                   	nop
  802069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802070:	89 d8                	mov    %ebx,%eax
  802072:	f7 f7                	div    %edi
  802074:	31 ff                	xor    %edi,%edi
  802076:	89 c3                	mov    %eax,%ebx
  802078:	89 d8                	mov    %ebx,%eax
  80207a:	89 fa                	mov    %edi,%edx
  80207c:	83 c4 1c             	add    $0x1c,%esp
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5f                   	pop    %edi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    
  802084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802088:	39 ce                	cmp    %ecx,%esi
  80208a:	72 0c                	jb     802098 <__udivdi3+0x118>
  80208c:	31 db                	xor    %ebx,%ebx
  80208e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802092:	0f 87 34 ff ff ff    	ja     801fcc <__udivdi3+0x4c>
  802098:	bb 01 00 00 00       	mov    $0x1,%ebx
  80209d:	e9 2a ff ff ff       	jmp    801fcc <__udivdi3+0x4c>
  8020a2:	66 90                	xchg   %ax,%ax
  8020a4:	66 90                	xchg   %ax,%ax
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	66 90                	xchg   %ax,%ax
  8020aa:	66 90                	xchg   %ax,%ax
  8020ac:	66 90                	xchg   %ax,%ax
  8020ae:	66 90                	xchg   %ax,%ax

008020b0 <__umoddi3>:
  8020b0:	55                   	push   %ebp
  8020b1:	57                   	push   %edi
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
  8020b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020c7:	85 d2                	test   %edx,%edx
  8020c9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d1:	89 f3                	mov    %esi,%ebx
  8020d3:	89 3c 24             	mov    %edi,(%esp)
  8020d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020da:	75 1c                	jne    8020f8 <__umoddi3+0x48>
  8020dc:	39 f7                	cmp    %esi,%edi
  8020de:	76 50                	jbe    802130 <__umoddi3+0x80>
  8020e0:	89 c8                	mov    %ecx,%eax
  8020e2:	89 f2                	mov    %esi,%edx
  8020e4:	f7 f7                	div    %edi
  8020e6:	89 d0                	mov    %edx,%eax
  8020e8:	31 d2                	xor    %edx,%edx
  8020ea:	83 c4 1c             	add    $0x1c,%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5f                   	pop    %edi
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    
  8020f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020f8:	39 f2                	cmp    %esi,%edx
  8020fa:	89 d0                	mov    %edx,%eax
  8020fc:	77 52                	ja     802150 <__umoddi3+0xa0>
  8020fe:	0f bd ea             	bsr    %edx,%ebp
  802101:	83 f5 1f             	xor    $0x1f,%ebp
  802104:	75 5a                	jne    802160 <__umoddi3+0xb0>
  802106:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80210a:	0f 82 e0 00 00 00    	jb     8021f0 <__umoddi3+0x140>
  802110:	39 0c 24             	cmp    %ecx,(%esp)
  802113:	0f 86 d7 00 00 00    	jbe    8021f0 <__umoddi3+0x140>
  802119:	8b 44 24 08          	mov    0x8(%esp),%eax
  80211d:	8b 54 24 04          	mov    0x4(%esp),%edx
  802121:	83 c4 1c             	add    $0x1c,%esp
  802124:	5b                   	pop    %ebx
  802125:	5e                   	pop    %esi
  802126:	5f                   	pop    %edi
  802127:	5d                   	pop    %ebp
  802128:	c3                   	ret    
  802129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802130:	85 ff                	test   %edi,%edi
  802132:	89 fd                	mov    %edi,%ebp
  802134:	75 0b                	jne    802141 <__umoddi3+0x91>
  802136:	b8 01 00 00 00       	mov    $0x1,%eax
  80213b:	31 d2                	xor    %edx,%edx
  80213d:	f7 f7                	div    %edi
  80213f:	89 c5                	mov    %eax,%ebp
  802141:	89 f0                	mov    %esi,%eax
  802143:	31 d2                	xor    %edx,%edx
  802145:	f7 f5                	div    %ebp
  802147:	89 c8                	mov    %ecx,%eax
  802149:	f7 f5                	div    %ebp
  80214b:	89 d0                	mov    %edx,%eax
  80214d:	eb 99                	jmp    8020e8 <__umoddi3+0x38>
  80214f:	90                   	nop
  802150:	89 c8                	mov    %ecx,%eax
  802152:	89 f2                	mov    %esi,%edx
  802154:	83 c4 1c             	add    $0x1c,%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
  80215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802160:	8b 34 24             	mov    (%esp),%esi
  802163:	bf 20 00 00 00       	mov    $0x20,%edi
  802168:	89 e9                	mov    %ebp,%ecx
  80216a:	29 ef                	sub    %ebp,%edi
  80216c:	d3 e0                	shl    %cl,%eax
  80216e:	89 f9                	mov    %edi,%ecx
  802170:	89 f2                	mov    %esi,%edx
  802172:	d3 ea                	shr    %cl,%edx
  802174:	89 e9                	mov    %ebp,%ecx
  802176:	09 c2                	or     %eax,%edx
  802178:	89 d8                	mov    %ebx,%eax
  80217a:	89 14 24             	mov    %edx,(%esp)
  80217d:	89 f2                	mov    %esi,%edx
  80217f:	d3 e2                	shl    %cl,%edx
  802181:	89 f9                	mov    %edi,%ecx
  802183:	89 54 24 04          	mov    %edx,0x4(%esp)
  802187:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80218b:	d3 e8                	shr    %cl,%eax
  80218d:	89 e9                	mov    %ebp,%ecx
  80218f:	89 c6                	mov    %eax,%esi
  802191:	d3 e3                	shl    %cl,%ebx
  802193:	89 f9                	mov    %edi,%ecx
  802195:	89 d0                	mov    %edx,%eax
  802197:	d3 e8                	shr    %cl,%eax
  802199:	89 e9                	mov    %ebp,%ecx
  80219b:	09 d8                	or     %ebx,%eax
  80219d:	89 d3                	mov    %edx,%ebx
  80219f:	89 f2                	mov    %esi,%edx
  8021a1:	f7 34 24             	divl   (%esp)
  8021a4:	89 d6                	mov    %edx,%esi
  8021a6:	d3 e3                	shl    %cl,%ebx
  8021a8:	f7 64 24 04          	mull   0x4(%esp)
  8021ac:	39 d6                	cmp    %edx,%esi
  8021ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b2:	89 d1                	mov    %edx,%ecx
  8021b4:	89 c3                	mov    %eax,%ebx
  8021b6:	72 08                	jb     8021c0 <__umoddi3+0x110>
  8021b8:	75 11                	jne    8021cb <__umoddi3+0x11b>
  8021ba:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8021be:	73 0b                	jae    8021cb <__umoddi3+0x11b>
  8021c0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8021c4:	1b 14 24             	sbb    (%esp),%edx
  8021c7:	89 d1                	mov    %edx,%ecx
  8021c9:	89 c3                	mov    %eax,%ebx
  8021cb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021cf:	29 da                	sub    %ebx,%edx
  8021d1:	19 ce                	sbb    %ecx,%esi
  8021d3:	89 f9                	mov    %edi,%ecx
  8021d5:	89 f0                	mov    %esi,%eax
  8021d7:	d3 e0                	shl    %cl,%eax
  8021d9:	89 e9                	mov    %ebp,%ecx
  8021db:	d3 ea                	shr    %cl,%edx
  8021dd:	89 e9                	mov    %ebp,%ecx
  8021df:	d3 ee                	shr    %cl,%esi
  8021e1:	09 d0                	or     %edx,%eax
  8021e3:	89 f2                	mov    %esi,%edx
  8021e5:	83 c4 1c             	add    $0x1c,%esp
  8021e8:	5b                   	pop    %ebx
  8021e9:	5e                   	pop    %esi
  8021ea:	5f                   	pop    %edi
  8021eb:	5d                   	pop    %ebp
  8021ec:	c3                   	ret    
  8021ed:	8d 76 00             	lea    0x0(%esi),%esi
  8021f0:	29 f9                	sub    %edi,%ecx
  8021f2:	19 d6                	sbb    %edx,%esi
  8021f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021fc:	e9 18 ff ff ff       	jmp    802119 <__umoddi3+0x69>
