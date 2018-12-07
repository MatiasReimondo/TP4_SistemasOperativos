
obj/user/echo.debug:     formato del fichero elf32-i386


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
  80002c:	e8 ad 00 00 00       	call   8000de <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7e 2b                	jle    800079 <umain+0x46>
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	68 e0 1d 80 00       	push   $0x801de0
  800056:	ff 76 04             	pushl  0x4(%esi)
  800059:	e8 c7 01 00 00       	call   800225 <strcmp>
  80005e:	83 c4 10             	add    $0x10,%esp
void
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
  800061:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800068:	85 c0                	test   %eax,%eax
  80006a:	75 0d                	jne    800079 <umain+0x46>
		nflag = 1;
		argc--;
  80006c:	83 ef 01             	sub    $0x1,%edi
		argv++;
  80006f:	83 c6 04             	add    $0x4,%esi
{
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
  800072:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800079:	bb 01 00 00 00       	mov    $0x1,%ebx
  80007e:	eb 38                	jmp    8000b8 <umain+0x85>
		if (i > 1)
  800080:	83 fb 01             	cmp    $0x1,%ebx
  800083:	7e 14                	jle    800099 <umain+0x66>
			write(1, " ", 1);
  800085:	83 ec 04             	sub    $0x4,%esp
  800088:	6a 01                	push   $0x1
  80008a:	68 e3 1d 80 00       	push   $0x801de3
  80008f:	6a 01                	push   $0x1
  800091:	e8 01 0a 00 00       	call   800a97 <write>
  800096:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009f:	e8 9e 00 00 00       	call   800142 <strlen>
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000ab:	6a 01                	push   $0x1
  8000ad:	e8 e5 09 00 00       	call   800a97 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000b2:	83 c3 01             	add    $0x1,%ebx
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	39 df                	cmp    %ebx,%edi
  8000ba:	7f c4                	jg     800080 <umain+0x4d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c0:	75 14                	jne    8000d6 <umain+0xa3>
		write(1, "\n", 1);
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	6a 01                	push   $0x1
  8000c7:	68 f3 1e 80 00       	push   $0x801ef3
  8000cc:	6a 01                	push   $0x1
  8000ce:	e8 c4 09 00 00       	call   800a97 <write>
  8000d3:	83 c4 10             	add    $0x10,%esp
}
  8000d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d9:	5b                   	pop    %ebx
  8000da:	5e                   	pop    %esi
  8000db:	5f                   	pop    %edi
  8000dc:	5d                   	pop    %ebp
  8000dd:	c3                   	ret    

008000de <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000de:	55                   	push   %ebp
  8000df:	89 e5                	mov    %esp,%ebp
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
  8000e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t id = sys_getenvid();
  8000e9:	e8 8b 04 00 00       	call   800579 <sys_getenvid>
	if (id >= 0)
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	78 12                	js     800104 <libmain+0x26>
		thisenv = &envs[ENVX(id)];
  8000f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ff:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800104:	85 db                	test   %ebx,%ebx
  800106:	7e 07                	jle    80010f <libmain+0x31>
		binaryname = argv[0];
  800108:	8b 06                	mov    (%esi),%eax
  80010a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80010f:	83 ec 08             	sub    $0x8,%esp
  800112:	56                   	push   %esi
  800113:	53                   	push   %ebx
  800114:	e8 1a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800119:	e8 0a 00 00 00       	call   800128 <exit>
}
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5d                   	pop    %ebp
  800127:	c3                   	ret    

00800128 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012e:	e8 79 07 00 00       	call   8008ac <close_all>
	sys_env_destroy(0);
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	6a 00                	push   $0x0
  800138:	e8 1a 04 00 00       	call   800557 <sys_env_destroy>
}
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	eb 03                	jmp    800152 <strlen+0x10>
		n++;
  80014f:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800152:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800156:	75 f7                	jne    80014f <strlen+0xd>
		n++;
	return n;
}
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800160:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800163:	ba 00 00 00 00       	mov    $0x0,%edx
  800168:	eb 03                	jmp    80016d <strnlen+0x13>
		n++;
  80016a:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80016d:	39 c2                	cmp    %eax,%edx
  80016f:	74 08                	je     800179 <strnlen+0x1f>
  800171:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800175:	75 f3                	jne    80016a <strnlen+0x10>
  800177:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  800179:	5d                   	pop    %ebp
  80017a:	c3                   	ret    

0080017b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	53                   	push   %ebx
  80017f:	8b 45 08             	mov    0x8(%ebp),%eax
  800182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800185:	89 c2                	mov    %eax,%edx
  800187:	83 c2 01             	add    $0x1,%edx
  80018a:	83 c1 01             	add    $0x1,%ecx
  80018d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800191:	88 5a ff             	mov    %bl,-0x1(%edx)
  800194:	84 db                	test   %bl,%bl
  800196:	75 ef                	jne    800187 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800198:	5b                   	pop    %ebx
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001a2:	53                   	push   %ebx
  8001a3:	e8 9a ff ff ff       	call   800142 <strlen>
  8001a8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8001ab:	ff 75 0c             	pushl  0xc(%ebp)
  8001ae:	01 d8                	add    %ebx,%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 c5 ff ff ff       	call   80017b <strcpy>
	return dst;
}
  8001b6:	89 d8                	mov    %ebx,%eax
  8001b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c8:	89 f3                	mov    %esi,%ebx
  8001ca:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001cd:	89 f2                	mov    %esi,%edx
  8001cf:	eb 0f                	jmp    8001e0 <strncpy+0x23>
		*dst++ = *src;
  8001d1:	83 c2 01             	add    $0x1,%edx
  8001d4:	0f b6 01             	movzbl (%ecx),%eax
  8001d7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001da:	80 39 01             	cmpb   $0x1,(%ecx)
  8001dd:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001e0:	39 da                	cmp    %ebx,%edx
  8001e2:	75 ed                	jne    8001d1 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8001e4:	89 f0                	mov    %esi,%eax
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f5:	8b 55 10             	mov    0x10(%ebp),%edx
  8001f8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001fa:	85 d2                	test   %edx,%edx
  8001fc:	74 21                	je     80021f <strlcpy+0x35>
  8001fe:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800202:	89 f2                	mov    %esi,%edx
  800204:	eb 09                	jmp    80020f <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800206:	83 c2 01             	add    $0x1,%edx
  800209:	83 c1 01             	add    $0x1,%ecx
  80020c:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80020f:	39 c2                	cmp    %eax,%edx
  800211:	74 09                	je     80021c <strlcpy+0x32>
  800213:	0f b6 19             	movzbl (%ecx),%ebx
  800216:	84 db                	test   %bl,%bl
  800218:	75 ec                	jne    800206 <strlcpy+0x1c>
  80021a:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80021c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80021f:	29 f0                	sub    %esi,%eax
}
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    

00800225 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80022e:	eb 06                	jmp    800236 <strcmp+0x11>
		p++, q++;
  800230:	83 c1 01             	add    $0x1,%ecx
  800233:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800236:	0f b6 01             	movzbl (%ecx),%eax
  800239:	84 c0                	test   %al,%al
  80023b:	74 04                	je     800241 <strcmp+0x1c>
  80023d:	3a 02                	cmp    (%edx),%al
  80023f:	74 ef                	je     800230 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800241:	0f b6 c0             	movzbl %al,%eax
  800244:	0f b6 12             	movzbl (%edx),%edx
  800247:	29 d0                	sub    %edx,%eax
}
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    

0080024b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	53                   	push   %ebx
  80024f:	8b 45 08             	mov    0x8(%ebp),%eax
  800252:	8b 55 0c             	mov    0xc(%ebp),%edx
  800255:	89 c3                	mov    %eax,%ebx
  800257:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80025a:	eb 06                	jmp    800262 <strncmp+0x17>
		n--, p++, q++;
  80025c:	83 c0 01             	add    $0x1,%eax
  80025f:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800262:	39 d8                	cmp    %ebx,%eax
  800264:	74 15                	je     80027b <strncmp+0x30>
  800266:	0f b6 08             	movzbl (%eax),%ecx
  800269:	84 c9                	test   %cl,%cl
  80026b:	74 04                	je     800271 <strncmp+0x26>
  80026d:	3a 0a                	cmp    (%edx),%cl
  80026f:	74 eb                	je     80025c <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800271:	0f b6 00             	movzbl (%eax),%eax
  800274:	0f b6 12             	movzbl (%edx),%edx
  800277:	29 d0                	sub    %edx,%eax
  800279:	eb 05                	jmp    800280 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  80027b:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800280:	5b                   	pop    %ebx
  800281:	5d                   	pop    %ebp
  800282:	c3                   	ret    

00800283 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80028d:	eb 07                	jmp    800296 <strchr+0x13>
		if (*s == c)
  80028f:	38 ca                	cmp    %cl,%dl
  800291:	74 0f                	je     8002a2 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800293:	83 c0 01             	add    $0x1,%eax
  800296:	0f b6 10             	movzbl (%eax),%edx
  800299:	84 d2                	test   %dl,%dl
  80029b:	75 f2                	jne    80028f <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  80029d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    

008002a4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002ae:	eb 03                	jmp    8002b3 <strfind+0xf>
  8002b0:	83 c0 01             	add    $0x1,%eax
  8002b3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002b6:	38 ca                	cmp    %cl,%dl
  8002b8:	74 04                	je     8002be <strfind+0x1a>
  8002ba:	84 d2                	test   %dl,%dl
  8002bc:	75 f2                	jne    8002b0 <strfind+0xc>
			break;
	return (char *) s;
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p = v;

	if (n == 0)
  8002cc:	85 c9                	test   %ecx,%ecx
  8002ce:	74 37                	je     800307 <memset+0x47>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002d0:	f6 c2 03             	test   $0x3,%dl
  8002d3:	75 2a                	jne    8002ff <memset+0x3f>
  8002d5:	f6 c1 03             	test   $0x3,%cl
  8002d8:	75 25                	jne    8002ff <memset+0x3f>
		c &= 0xFF;
  8002da:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002de:	89 df                	mov    %ebx,%edi
  8002e0:	c1 e7 08             	shl    $0x8,%edi
  8002e3:	89 de                	mov    %ebx,%esi
  8002e5:	c1 e6 18             	shl    $0x18,%esi
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	c1 e0 10             	shl    $0x10,%eax
  8002ed:	09 f0                	or     %esi,%eax
  8002ef:	09 c3                	or     %eax,%ebx
		asm volatile("cld; rep stosl\n"
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
  8002f1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8002f4:	89 f8                	mov    %edi,%eax
  8002f6:	09 d8                	or     %ebx,%eax
  8002f8:	89 d7                	mov    %edx,%edi
  8002fa:	fc                   	cld    
  8002fb:	f3 ab                	rep stos %eax,%es:(%edi)
  8002fd:	eb 08                	jmp    800307 <memset+0x47>
			: "=D" (p), "=c" (n)
			: "D" (p), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002ff:	89 d7                	mov    %edx,%edi
  800301:	8b 45 0c             	mov    0xc(%ebp),%eax
  800304:	fc                   	cld    
  800305:	f3 aa                	rep stos %al,%es:(%edi)
			: "=D" (p), "=c" (n)
			: "0" (p), "a" (c), "1" (n)
			: "cc", "memory");
	return v;
}
  800307:	89 d0                	mov    %edx,%eax
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	8b 75 0c             	mov    0xc(%ebp),%esi
  800319:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80031c:	39 c6                	cmp    %eax,%esi
  80031e:	73 35                	jae    800355 <memmove+0x47>
  800320:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800323:	39 d0                	cmp    %edx,%eax
  800325:	73 2e                	jae    800355 <memmove+0x47>
		s += n;
		d += n;
  800327:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80032a:	89 d6                	mov    %edx,%esi
  80032c:	09 fe                	or     %edi,%esi
  80032e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800334:	75 13                	jne    800349 <memmove+0x3b>
  800336:	f6 c1 03             	test   $0x3,%cl
  800339:	75 0e                	jne    800349 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  80033b:	83 ef 04             	sub    $0x4,%edi
  80033e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800341:	c1 e9 02             	shr    $0x2,%ecx
  800344:	fd                   	std    
  800345:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800347:	eb 09                	jmp    800352 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800349:	83 ef 01             	sub    $0x1,%edi
  80034c:	8d 72 ff             	lea    -0x1(%edx),%esi
  80034f:	fd                   	std    
  800350:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800352:	fc                   	cld    
  800353:	eb 1d                	jmp    800372 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800355:	89 f2                	mov    %esi,%edx
  800357:	09 c2                	or     %eax,%edx
  800359:	f6 c2 03             	test   $0x3,%dl
  80035c:	75 0f                	jne    80036d <memmove+0x5f>
  80035e:	f6 c1 03             	test   $0x3,%cl
  800361:	75 0a                	jne    80036d <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800363:	c1 e9 02             	shr    $0x2,%ecx
  800366:	89 c7                	mov    %eax,%edi
  800368:	fc                   	cld    
  800369:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80036b:	eb 05                	jmp    800372 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80036d:	89 c7                	mov    %eax,%edi
  80036f:	fc                   	cld    
  800370:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800372:	5e                   	pop    %esi
  800373:	5f                   	pop    %edi
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800379:	ff 75 10             	pushl  0x10(%ebp)
  80037c:	ff 75 0c             	pushl  0xc(%ebp)
  80037f:	ff 75 08             	pushl  0x8(%ebp)
  800382:	e8 87 ff ff ff       	call   80030e <memmove>
}
  800387:	c9                   	leave  
  800388:	c3                   	ret    

00800389 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	56                   	push   %esi
  80038d:	53                   	push   %ebx
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	8b 55 0c             	mov    0xc(%ebp),%edx
  800394:	89 c6                	mov    %eax,%esi
  800396:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800399:	eb 1a                	jmp    8003b5 <memcmp+0x2c>
		if (*s1 != *s2)
  80039b:	0f b6 08             	movzbl (%eax),%ecx
  80039e:	0f b6 1a             	movzbl (%edx),%ebx
  8003a1:	38 d9                	cmp    %bl,%cl
  8003a3:	74 0a                	je     8003af <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8003a5:	0f b6 c1             	movzbl %cl,%eax
  8003a8:	0f b6 db             	movzbl %bl,%ebx
  8003ab:	29 d8                	sub    %ebx,%eax
  8003ad:	eb 0f                	jmp    8003be <memcmp+0x35>
		s1++, s2++;
  8003af:	83 c0 01             	add    $0x1,%eax
  8003b2:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003b5:	39 f0                	cmp    %esi,%eax
  8003b7:	75 e2                	jne    80039b <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8003b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003be:	5b                   	pop    %ebx
  8003bf:	5e                   	pop    %esi
  8003c0:	5d                   	pop    %ebp
  8003c1:	c3                   	ret    

008003c2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	53                   	push   %ebx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8003c9:	89 c1                	mov    %eax,%ecx
  8003cb:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8003ce:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8003d2:	eb 0a                	jmp    8003de <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003d4:	0f b6 10             	movzbl (%eax),%edx
  8003d7:	39 da                	cmp    %ebx,%edx
  8003d9:	74 07                	je     8003e2 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8003db:	83 c0 01             	add    $0x1,%eax
  8003de:	39 c8                	cmp    %ecx,%eax
  8003e0:	72 f2                	jb     8003d4 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8003e2:	5b                   	pop    %ebx
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	57                   	push   %edi
  8003e9:	56                   	push   %esi
  8003ea:	53                   	push   %ebx
  8003eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003f1:	eb 03                	jmp    8003f6 <strtol+0x11>
		s++;
  8003f3:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003f6:	0f b6 01             	movzbl (%ecx),%eax
  8003f9:	3c 20                	cmp    $0x20,%al
  8003fb:	74 f6                	je     8003f3 <strtol+0xe>
  8003fd:	3c 09                	cmp    $0x9,%al
  8003ff:	74 f2                	je     8003f3 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800401:	3c 2b                	cmp    $0x2b,%al
  800403:	75 0a                	jne    80040f <strtol+0x2a>
		s++;
  800405:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800408:	bf 00 00 00 00       	mov    $0x0,%edi
  80040d:	eb 11                	jmp    800420 <strtol+0x3b>
  80040f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800414:	3c 2d                	cmp    $0x2d,%al
  800416:	75 08                	jne    800420 <strtol+0x3b>
		s++, neg = 1;
  800418:	83 c1 01             	add    $0x1,%ecx
  80041b:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800420:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800426:	75 15                	jne    80043d <strtol+0x58>
  800428:	80 39 30             	cmpb   $0x30,(%ecx)
  80042b:	75 10                	jne    80043d <strtol+0x58>
  80042d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800431:	75 7c                	jne    8004af <strtol+0xca>
		s += 2, base = 16;
  800433:	83 c1 02             	add    $0x2,%ecx
  800436:	bb 10 00 00 00       	mov    $0x10,%ebx
  80043b:	eb 16                	jmp    800453 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  80043d:	85 db                	test   %ebx,%ebx
  80043f:	75 12                	jne    800453 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800441:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800446:	80 39 30             	cmpb   $0x30,(%ecx)
  800449:	75 08                	jne    800453 <strtol+0x6e>
		s++, base = 8;
  80044b:	83 c1 01             	add    $0x1,%ecx
  80044e:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800453:	b8 00 00 00 00       	mov    $0x0,%eax
  800458:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80045b:	0f b6 11             	movzbl (%ecx),%edx
  80045e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800461:	89 f3                	mov    %esi,%ebx
  800463:	80 fb 09             	cmp    $0x9,%bl
  800466:	77 08                	ja     800470 <strtol+0x8b>
			dig = *s - '0';
  800468:	0f be d2             	movsbl %dl,%edx
  80046b:	83 ea 30             	sub    $0x30,%edx
  80046e:	eb 22                	jmp    800492 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800470:	8d 72 9f             	lea    -0x61(%edx),%esi
  800473:	89 f3                	mov    %esi,%ebx
  800475:	80 fb 19             	cmp    $0x19,%bl
  800478:	77 08                	ja     800482 <strtol+0x9d>
			dig = *s - 'a' + 10;
  80047a:	0f be d2             	movsbl %dl,%edx
  80047d:	83 ea 57             	sub    $0x57,%edx
  800480:	eb 10                	jmp    800492 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800482:	8d 72 bf             	lea    -0x41(%edx),%esi
  800485:	89 f3                	mov    %esi,%ebx
  800487:	80 fb 19             	cmp    $0x19,%bl
  80048a:	77 16                	ja     8004a2 <strtol+0xbd>
			dig = *s - 'A' + 10;
  80048c:	0f be d2             	movsbl %dl,%edx
  80048f:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800492:	3b 55 10             	cmp    0x10(%ebp),%edx
  800495:	7d 0b                	jge    8004a2 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800497:	83 c1 01             	add    $0x1,%ecx
  80049a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80049e:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  8004a0:	eb b9                	jmp    80045b <strtol+0x76>

	if (endptr)
  8004a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a6:	74 0d                	je     8004b5 <strtol+0xd0>
		*endptr = (char *) s;
  8004a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ab:	89 0e                	mov    %ecx,(%esi)
  8004ad:	eb 06                	jmp    8004b5 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8004af:	85 db                	test   %ebx,%ebx
  8004b1:	74 98                	je     80044b <strtol+0x66>
  8004b3:	eb 9e                	jmp    800453 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  8004b5:	89 c2                	mov    %eax,%edx
  8004b7:	f7 da                	neg    %edx
  8004b9:	85 ff                	test   %edi,%edi
  8004bb:	0f 45 c2             	cmovne %edx,%eax
}
  8004be:	5b                   	pop    %ebx
  8004bf:	5e                   	pop    %esi
  8004c0:	5f                   	pop    %edi
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
  8004c6:	57                   	push   %edi
  8004c7:	56                   	push   %esi
  8004c8:	53                   	push   %ebx
  8004c9:	83 ec 1c             	sub    $0x1c,%esp
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004d2:	89 ca                	mov    %ecx,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004da:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004dd:	8b 75 14             	mov    0x14(%ebp),%esi
  8004e0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8004e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004e6:	74 1d                	je     800505 <syscall+0x42>
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	7e 19                	jle    800505 <syscall+0x42>
  8004ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
		panic("syscall %d returned %d (> 0)", num, ret);
  8004ef:	83 ec 0c             	sub    $0xc,%esp
  8004f2:	50                   	push   %eax
  8004f3:	52                   	push   %edx
  8004f4:	68 ef 1d 80 00       	push   $0x801def
  8004f9:	6a 23                	push   $0x23
  8004fb:	68 0c 1e 80 00       	push   $0x801e0c
  800500:	e8 e9 0e 00 00       	call   8013ee <_panic>

	return ret;
}
  800505:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800508:	5b                   	pop    %ebx
  800509:	5e                   	pop    %esi
  80050a:	5f                   	pop    %edi
  80050b:	5d                   	pop    %ebp
  80050c:	c3                   	ret    

0080050d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800513:	6a 00                	push   $0x0
  800515:	6a 00                	push   $0x0
  800517:	6a 00                	push   $0x0
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80051f:	ba 00 00 00 00       	mov    $0x0,%edx
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	e8 95 ff ff ff       	call   8004c3 <syscall>
}
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <sys_cgetc>:

int
sys_cgetc(void)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800539:	6a 00                	push   $0x0
  80053b:	6a 00                	push   $0x0
  80053d:	6a 00                	push   $0x0
  80053f:	6a 00                	push   $0x0
  800541:	b9 00 00 00 00       	mov    $0x0,%ecx
  800546:	ba 00 00 00 00       	mov    $0x0,%edx
  80054b:	b8 01 00 00 00       	mov    $0x1,%eax
  800550:	e8 6e ff ff ff       	call   8004c3 <syscall>
}
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80055d:	6a 00                	push   $0x0
  80055f:	6a 00                	push   $0x0
  800561:	6a 00                	push   $0x0
  800563:	6a 00                	push   $0x0
  800565:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800568:	ba 01 00 00 00       	mov    $0x1,%edx
  80056d:	b8 03 00 00 00       	mov    $0x3,%eax
  800572:	e8 4c ff ff ff       	call   8004c3 <syscall>
}
  800577:	c9                   	leave  
  800578:	c3                   	ret    

00800579 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	83 ec 08             	sub    $0x8,%esp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80057f:	6a 00                	push   $0x0
  800581:	6a 00                	push   $0x0
  800583:	6a 00                	push   $0x0
  800585:	6a 00                	push   $0x0
  800587:	b9 00 00 00 00       	mov    $0x0,%ecx
  80058c:	ba 00 00 00 00       	mov    $0x0,%edx
  800591:	b8 02 00 00 00       	mov    $0x2,%eax
  800596:	e8 28 ff ff ff       	call   8004c3 <syscall>
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <sys_yield>:

void
sys_yield(void)
{
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 08             	sub    $0x8,%esp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8005a3:	6a 00                	push   $0x0
  8005a5:	6a 00                	push   $0x0
  8005a7:	6a 00                	push   $0x0
  8005a9:	6a 00                	push   $0x0
  8005ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	b8 0b 00 00 00       	mov    $0xb,%eax
  8005ba:	e8 04 ff ff ff       	call   8004c3 <syscall>
}
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
  8005ca:	6a 00                	push   $0x0
  8005cc:	6a 00                	push   $0x0
  8005ce:	ff 75 10             	pushl  0x10(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8005dc:	b8 04 00 00 00       	mov    $0x4,%eax
  8005e1:	e8 dd fe ff ff       	call   8004c3 <syscall>
}
  8005e6:	c9                   	leave  
  8005e7:	c3                   	ret    

008005e8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005e8:	55                   	push   %ebp
  8005e9:	89 e5                	mov    %esp,%ebp
  8005eb:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
  8005ee:	ff 75 18             	pushl  0x18(%ebp)
  8005f1:	ff 75 14             	pushl  0x14(%ebp)
  8005f4:	ff 75 10             	pushl  0x10(%ebp)
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005fd:	ba 01 00 00 00       	mov    $0x1,%edx
  800602:	b8 05 00 00 00       	mov    $0x5,%eax
  800607:	e8 b7 fe ff ff       	call   8004c3 <syscall>
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
  800614:	6a 00                	push   $0x0
  800616:	6a 00                	push   $0x0
  800618:	6a 00                	push   $0x0
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800620:	ba 01 00 00 00       	mov    $0x1,%edx
  800625:	b8 06 00 00 00       	mov    $0x6,%eax
  80062a:	e8 94 fe ff ff       	call   8004c3 <syscall>
}
  80062f:	c9                   	leave  
  800630:	c3                   	ret    

00800631 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800637:	6a 00                	push   $0x0
  800639:	6a 00                	push   $0x0
  80063b:	6a 00                	push   $0x0
  80063d:	ff 75 0c             	pushl  0xc(%ebp)
  800640:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800643:	ba 01 00 00 00       	mov    $0x1,%edx
  800648:	b8 08 00 00 00       	mov    $0x8,%eax
  80064d:	e8 71 fe ff ff       	call   8004c3 <syscall>
}
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
  80065a:	6a 00                	push   $0x0
  80065c:	6a 00                	push   $0x0
  80065e:	6a 00                	push   $0x0
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800666:	ba 01 00 00 00       	mov    $0x1,%edx
  80066b:	b8 09 00 00 00       	mov    $0x9,%eax
  800670:	e8 4e fe ff ff       	call   8004c3 <syscall>
}
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
  80067d:	6a 00                	push   $0x0
  80067f:	6a 00                	push   $0x0
  800681:	6a 00                	push   $0x0
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800689:	ba 01 00 00 00       	mov    $0x1,%edx
  80068e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800693:	e8 2b fe ff ff       	call   8004c3 <syscall>
}
  800698:	c9                   	leave  
  800699:	c3                   	ret    

0080069a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80069a:	55                   	push   %ebp
  80069b:	89 e5                	mov    %esp,%ebp
  80069d:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
  8006a0:	6a 00                	push   $0x0
  8006a2:	ff 75 14             	pushl  0x14(%ebp)
  8006a5:	ff 75 10             	pushl  0x10(%ebp)
  8006a8:	ff 75 0c             	pushl  0xc(%ebp)
  8006ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8006b8:	e8 06 fe ff ff       	call   8004c3 <syscall>
}
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 08             	sub    $0x8,%esp
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
  8006c5:	6a 00                	push   $0x0
  8006c7:	6a 00                	push   $0x0
  8006c9:	6a 00                	push   $0x0
  8006cb:	6a 00                	push   $0x0
  8006cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006d0:	ba 01 00 00 00       	mov    $0x1,%edx
  8006d5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8006da:	e8 e4 fd ff ff       	call   8004c3 <syscall>
}
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	05 00 00 00 30       	add    $0x30000000,%eax
  8006ec:	c1 e8 0c             	shr    $0xc,%eax
}
  8006ef:	5d                   	pop    %ebp
  8006f0:	c3                   	ret    

008006f1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8006f1:	55                   	push   %ebp
  8006f2:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
  8006f4:	ff 75 08             	pushl  0x8(%ebp)
  8006f7:	e8 e5 ff ff ff       	call   8006e1 <fd2num>
  8006fc:	83 c4 04             	add    $0x4,%esp
  8006ff:	c1 e0 0c             	shl    $0xc,%eax
  800702:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80070f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800714:	89 c2                	mov    %eax,%edx
  800716:	c1 ea 16             	shr    $0x16,%edx
  800719:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800720:	f6 c2 01             	test   $0x1,%dl
  800723:	74 11                	je     800736 <fd_alloc+0x2d>
  800725:	89 c2                	mov    %eax,%edx
  800727:	c1 ea 0c             	shr    $0xc,%edx
  80072a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800731:	f6 c2 01             	test   $0x1,%dl
  800734:	75 09                	jne    80073f <fd_alloc+0x36>
			*fd_store = fd;
  800736:	89 01                	mov    %eax,(%ecx)
			return 0;
  800738:	b8 00 00 00 00       	mov    $0x0,%eax
  80073d:	eb 17                	jmp    800756 <fd_alloc+0x4d>
  80073f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800744:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800749:	75 c9                	jne    800714 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80074b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800751:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80075e:	83 f8 1f             	cmp    $0x1f,%eax
  800761:	77 36                	ja     800799 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800763:	c1 e0 0c             	shl    $0xc,%eax
  800766:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80076b:	89 c2                	mov    %eax,%edx
  80076d:	c1 ea 16             	shr    $0x16,%edx
  800770:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800777:	f6 c2 01             	test   $0x1,%dl
  80077a:	74 24                	je     8007a0 <fd_lookup+0x48>
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	c1 ea 0c             	shr    $0xc,%edx
  800781:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800788:	f6 c2 01             	test   $0x1,%dl
  80078b:	74 1a                	je     8007a7 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80078d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800790:	89 02                	mov    %eax,(%edx)
	return 0;
  800792:	b8 00 00 00 00       	mov    $0x0,%eax
  800797:	eb 13                	jmp    8007ac <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079e:	eb 0c                	jmp    8007ac <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a5:	eb 05                	jmp    8007ac <fd_lookup+0x54>
  8007a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b7:	ba 98 1e 80 00       	mov    $0x801e98,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8007bc:	eb 13                	jmp    8007d1 <dev_lookup+0x23>
  8007be:	83 c2 04             	add    $0x4,%edx
		if (devtab[i]->dev_id == dev_id) {
  8007c1:	39 08                	cmp    %ecx,(%eax)
  8007c3:	75 0c                	jne    8007d1 <dev_lookup+0x23>
			*dev = devtab[i];
  8007c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8007ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cf:	eb 2e                	jmp    8007ff <dev_lookup+0x51>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007d1:	8b 02                	mov    (%edx),%eax
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	75 e7                	jne    8007be <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8007d7:	a1 04 40 80 00       	mov    0x804004,%eax
  8007dc:	8b 40 48             	mov    0x48(%eax),%eax
  8007df:	83 ec 04             	sub    $0x4,%esp
  8007e2:	51                   	push   %ecx
  8007e3:	50                   	push   %eax
  8007e4:	68 1c 1e 80 00       	push   $0x801e1c
  8007e9:	e8 d9 0c 00 00       	call   8014c7 <cprintf>
	*dev = 0;
  8007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    

00800801 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	56                   	push   %esi
  800805:	53                   	push   %ebx
  800806:	83 ec 10             	sub    $0x10,%esp
  800809:	8b 75 08             	mov    0x8(%ebp),%esi
  80080c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80080f:	56                   	push   %esi
  800810:	e8 cc fe ff ff       	call   8006e1 <fd2num>
  800815:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800818:	89 14 24             	mov    %edx,(%esp)
  80081b:	50                   	push   %eax
  80081c:	e8 37 ff ff ff       	call   800758 <fd_lookup>
  800821:	83 c4 08             	add    $0x8,%esp
  800824:	85 c0                	test   %eax,%eax
  800826:	78 05                	js     80082d <fd_close+0x2c>
	    || fd != fd2)
  800828:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80082b:	74 0c                	je     800839 <fd_close+0x38>
		return (must_exist ? r : 0);
  80082d:	84 db                	test   %bl,%bl
  80082f:	ba 00 00 00 00       	mov    $0x0,%edx
  800834:	0f 44 c2             	cmove  %edx,%eax
  800837:	eb 41                	jmp    80087a <fd_close+0x79>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80083f:	50                   	push   %eax
  800840:	ff 36                	pushl  (%esi)
  800842:	e8 67 ff ff ff       	call   8007ae <dev_lookup>
  800847:	89 c3                	mov    %eax,%ebx
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	85 c0                	test   %eax,%eax
  80084e:	78 1a                	js     80086a <fd_close+0x69>
		if (dev->dev_close)
  800850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800853:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800856:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80085b:	85 c0                	test   %eax,%eax
  80085d:	74 0b                	je     80086a <fd_close+0x69>
			r = (*dev->dev_close)(fd);
  80085f:	83 ec 0c             	sub    $0xc,%esp
  800862:	56                   	push   %esi
  800863:	ff d0                	call   *%eax
  800865:	89 c3                	mov    %eax,%ebx
  800867:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	56                   	push   %esi
  80086e:	6a 00                	push   $0x0
  800870:	e8 99 fd ff ff       	call   80060e <sys_page_unmap>
	return r;
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 d8                	mov    %ebx,%eax
}
  80087a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80087d:	5b                   	pop    %ebx
  80087e:	5e                   	pop    %esi
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800887:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80088a:	50                   	push   %eax
  80088b:	ff 75 08             	pushl  0x8(%ebp)
  80088e:	e8 c5 fe ff ff       	call   800758 <fd_lookup>
  800893:	83 c4 08             	add    $0x8,%esp
  800896:	85 c0                	test   %eax,%eax
  800898:	78 10                	js     8008aa <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	6a 01                	push   $0x1
  80089f:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a2:	e8 5a ff ff ff       	call   800801 <fd_close>
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    

008008ac <close_all>:

void
close_all(void)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	53                   	push   %ebx
  8008b0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8008b8:	83 ec 0c             	sub    $0xc,%esp
  8008bb:	53                   	push   %ebx
  8008bc:	e8 c0 ff ff ff       	call   800881 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008c1:	83 c3 01             	add    $0x1,%ebx
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	83 fb 20             	cmp    $0x20,%ebx
  8008ca:	75 ec                	jne    8008b8 <close_all+0xc>
		close(i);
}
  8008cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	57                   	push   %edi
  8008d5:	56                   	push   %esi
  8008d6:	53                   	push   %ebx
  8008d7:	83 ec 2c             	sub    $0x2c,%esp
  8008da:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8008e0:	50                   	push   %eax
  8008e1:	ff 75 08             	pushl  0x8(%ebp)
  8008e4:	e8 6f fe ff ff       	call   800758 <fd_lookup>
  8008e9:	83 c4 08             	add    $0x8,%esp
  8008ec:	85 c0                	test   %eax,%eax
  8008ee:	0f 88 c1 00 00 00    	js     8009b5 <dup+0xe4>
		return r;
	close(newfdnum);
  8008f4:	83 ec 0c             	sub    $0xc,%esp
  8008f7:	56                   	push   %esi
  8008f8:	e8 84 ff ff ff       	call   800881 <close>

	newfd = INDEX2FD(newfdnum);
  8008fd:	89 f3                	mov    %esi,%ebx
  8008ff:	c1 e3 0c             	shl    $0xc,%ebx
  800902:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800908:	83 c4 04             	add    $0x4,%esp
  80090b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80090e:	e8 de fd ff ff       	call   8006f1 <fd2data>
  800913:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  800915:	89 1c 24             	mov    %ebx,(%esp)
  800918:	e8 d4 fd ff ff       	call   8006f1 <fd2data>
  80091d:	83 c4 10             	add    $0x10,%esp
  800920:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800923:	89 f8                	mov    %edi,%eax
  800925:	c1 e8 16             	shr    $0x16,%eax
  800928:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80092f:	a8 01                	test   $0x1,%al
  800931:	74 37                	je     80096a <dup+0x99>
  800933:	89 f8                	mov    %edi,%eax
  800935:	c1 e8 0c             	shr    $0xc,%eax
  800938:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80093f:	f6 c2 01             	test   $0x1,%dl
  800942:	74 26                	je     80096a <dup+0x99>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800944:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80094b:	83 ec 0c             	sub    $0xc,%esp
  80094e:	25 07 0e 00 00       	and    $0xe07,%eax
  800953:	50                   	push   %eax
  800954:	ff 75 d4             	pushl  -0x2c(%ebp)
  800957:	6a 00                	push   $0x0
  800959:	57                   	push   %edi
  80095a:	6a 00                	push   $0x0
  80095c:	e8 87 fc ff ff       	call   8005e8 <sys_page_map>
  800961:	89 c7                	mov    %eax,%edi
  800963:	83 c4 20             	add    $0x20,%esp
  800966:	85 c0                	test   %eax,%eax
  800968:	78 2e                	js     800998 <dup+0xc7>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80096a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80096d:	89 d0                	mov    %edx,%eax
  80096f:	c1 e8 0c             	shr    $0xc,%eax
  800972:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	25 07 0e 00 00       	and    $0xe07,%eax
  800981:	50                   	push   %eax
  800982:	53                   	push   %ebx
  800983:	6a 00                	push   $0x0
  800985:	52                   	push   %edx
  800986:	6a 00                	push   $0x0
  800988:	e8 5b fc ff ff       	call   8005e8 <sys_page_map>
  80098d:	89 c7                	mov    %eax,%edi
  80098f:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  800992:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800994:	85 ff                	test   %edi,%edi
  800996:	79 1d                	jns    8009b5 <dup+0xe4>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	53                   	push   %ebx
  80099c:	6a 00                	push   $0x0
  80099e:	e8 6b fc ff ff       	call   80060e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8009a3:	83 c4 08             	add    $0x8,%esp
  8009a6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8009a9:	6a 00                	push   $0x0
  8009ab:	e8 5e fc ff ff       	call   80060e <sys_page_unmap>
	return r;
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 f8                	mov    %edi,%eax
}
  8009b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009b8:	5b                   	pop    %ebx
  8009b9:	5e                   	pop    %esi
  8009ba:	5f                   	pop    %edi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	53                   	push   %ebx
  8009c1:	83 ec 14             	sub    $0x14,%esp
  8009c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009ca:	50                   	push   %eax
  8009cb:	53                   	push   %ebx
  8009cc:	e8 87 fd ff ff       	call   800758 <fd_lookup>
  8009d1:	83 c4 08             	add    $0x8,%esp
  8009d4:	89 c2                	mov    %eax,%edx
  8009d6:	85 c0                	test   %eax,%eax
  8009d8:	78 6d                	js     800a47 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009e0:	50                   	push   %eax
  8009e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e4:	ff 30                	pushl  (%eax)
  8009e6:	e8 c3 fd ff ff       	call   8007ae <dev_lookup>
  8009eb:	83 c4 10             	add    $0x10,%esp
  8009ee:	85 c0                	test   %eax,%eax
  8009f0:	78 4c                	js     800a3e <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8009f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8009f5:	8b 42 08             	mov    0x8(%edx),%eax
  8009f8:	83 e0 03             	and    $0x3,%eax
  8009fb:	83 f8 01             	cmp    $0x1,%eax
  8009fe:	75 21                	jne    800a21 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800a00:	a1 04 40 80 00       	mov    0x804004,%eax
  800a05:	8b 40 48             	mov    0x48(%eax),%eax
  800a08:	83 ec 04             	sub    $0x4,%esp
  800a0b:	53                   	push   %ebx
  800a0c:	50                   	push   %eax
  800a0d:	68 5d 1e 80 00       	push   $0x801e5d
  800a12:	e8 b0 0a 00 00       	call   8014c7 <cprintf>
		return -E_INVAL;
  800a17:	83 c4 10             	add    $0x10,%esp
  800a1a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800a1f:	eb 26                	jmp    800a47 <read+0x8a>
	}
	if (!dev->dev_read)
  800a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a24:	8b 40 08             	mov    0x8(%eax),%eax
  800a27:	85 c0                	test   %eax,%eax
  800a29:	74 17                	je     800a42 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800a2b:	83 ec 04             	sub    $0x4,%esp
  800a2e:	ff 75 10             	pushl  0x10(%ebp)
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	52                   	push   %edx
  800a35:	ff d0                	call   *%eax
  800a37:	89 c2                	mov    %eax,%edx
  800a39:	83 c4 10             	add    $0x10,%esp
  800a3c:	eb 09                	jmp    800a47 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	eb 05                	jmp    800a47 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800a42:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_read)(fd, buf, n);
}
  800a47:	89 d0                	mov    %edx,%eax
  800a49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4c:	c9                   	leave  
  800a4d:	c3                   	ret    

00800a4e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	57                   	push   %edi
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	83 ec 0c             	sub    $0xc,%esp
  800a57:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800a5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a62:	eb 21                	jmp    800a85 <readn+0x37>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800a64:	83 ec 04             	sub    $0x4,%esp
  800a67:	89 f0                	mov    %esi,%eax
  800a69:	29 d8                	sub    %ebx,%eax
  800a6b:	50                   	push   %eax
  800a6c:	89 d8                	mov    %ebx,%eax
  800a6e:	03 45 0c             	add    0xc(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	57                   	push   %edi
  800a73:	e8 45 ff ff ff       	call   8009bd <read>
		if (m < 0)
  800a78:	83 c4 10             	add    $0x10,%esp
  800a7b:	85 c0                	test   %eax,%eax
  800a7d:	78 10                	js     800a8f <readn+0x41>
			return m;
		if (m == 0)
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	74 0a                	je     800a8d <readn+0x3f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800a83:	01 c3                	add    %eax,%ebx
  800a85:	39 f3                	cmp    %esi,%ebx
  800a87:	72 db                	jb     800a64 <readn+0x16>
  800a89:	89 d8                	mov    %ebx,%eax
  800a8b:	eb 02                	jmp    800a8f <readn+0x41>
  800a8d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800a8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5f                   	pop    %edi
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	53                   	push   %ebx
  800a9b:	83 ec 14             	sub    $0x14,%esp
  800a9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800aa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800aa4:	50                   	push   %eax
  800aa5:	53                   	push   %ebx
  800aa6:	e8 ad fc ff ff       	call   800758 <fd_lookup>
  800aab:	83 c4 08             	add    $0x8,%esp
  800aae:	89 c2                	mov    %eax,%edx
  800ab0:	85 c0                	test   %eax,%eax
  800ab2:	78 68                	js     800b1c <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800aba:	50                   	push   %eax
  800abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abe:	ff 30                	pushl  (%eax)
  800ac0:	e8 e9 fc ff ff       	call   8007ae <dev_lookup>
  800ac5:	83 c4 10             	add    $0x10,%esp
  800ac8:	85 c0                	test   %eax,%eax
  800aca:	78 47                	js     800b13 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800acf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800ad3:	75 21                	jne    800af6 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800ad5:	a1 04 40 80 00       	mov    0x804004,%eax
  800ada:	8b 40 48             	mov    0x48(%eax),%eax
  800add:	83 ec 04             	sub    $0x4,%esp
  800ae0:	53                   	push   %ebx
  800ae1:	50                   	push   %eax
  800ae2:	68 79 1e 80 00       	push   $0x801e79
  800ae7:	e8 db 09 00 00       	call   8014c7 <cprintf>
		return -E_INVAL;
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800af4:	eb 26                	jmp    800b1c <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800af6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af9:	8b 52 0c             	mov    0xc(%edx),%edx
  800afc:	85 d2                	test   %edx,%edx
  800afe:	74 17                	je     800b17 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b00:	83 ec 04             	sub    $0x4,%esp
  800b03:	ff 75 10             	pushl  0x10(%ebp)
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	50                   	push   %eax
  800b0a:	ff d2                	call   *%edx
  800b0c:	89 c2                	mov    %eax,%edx
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	eb 09                	jmp    800b1c <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b13:	89 c2                	mov    %eax,%edx
  800b15:	eb 05                	jmp    800b1c <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800b17:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_write)(fd, buf, n);
}
  800b1c:	89 d0                	mov    %edx,%eax
  800b1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <seek>:

int
seek(int fdnum, off_t offset)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800b29:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800b2c:	50                   	push   %eax
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 23 fc ff ff       	call   800758 <fd_lookup>
  800b35:	83 c4 08             	add    $0x8,%esp
  800b38:	85 c0                	test   %eax,%eax
  800b3a:	78 0e                	js     800b4a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800b3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	53                   	push   %ebx
  800b50:	83 ec 14             	sub    $0x14,%esp
  800b53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b56:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	53                   	push   %ebx
  800b5b:	e8 f8 fb ff ff       	call   800758 <fd_lookup>
  800b60:	83 c4 08             	add    $0x8,%esp
  800b63:	89 c2                	mov    %eax,%edx
  800b65:	85 c0                	test   %eax,%eax
  800b67:	78 65                	js     800bce <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b6f:	50                   	push   %eax
  800b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b73:	ff 30                	pushl  (%eax)
  800b75:	e8 34 fc ff ff       	call   8007ae <dev_lookup>
  800b7a:	83 c4 10             	add    $0x10,%esp
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	78 44                	js     800bc5 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b84:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800b88:	75 21                	jne    800bab <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800b8a:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800b8f:	8b 40 48             	mov    0x48(%eax),%eax
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	53                   	push   %ebx
  800b96:	50                   	push   %eax
  800b97:	68 3c 1e 80 00       	push   $0x801e3c
  800b9c:	e8 26 09 00 00       	call   8014c7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800ba9:	eb 23                	jmp    800bce <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
  800bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bae:	8b 52 18             	mov    0x18(%edx),%edx
  800bb1:	85 d2                	test   %edx,%edx
  800bb3:	74 14                	je     800bc9 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	50                   	push   %eax
  800bbc:	ff d2                	call   *%edx
  800bbe:	89 c2                	mov    %eax,%edx
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	eb 09                	jmp    800bce <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bc5:	89 c2                	mov    %eax,%edx
  800bc7:	eb 05                	jmp    800bce <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800bc9:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bd3:	c9                   	leave  
  800bd4:	c3                   	ret    

00800bd5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 14             	sub    $0x14,%esp
  800bdc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bdf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800be2:	50                   	push   %eax
  800be3:	ff 75 08             	pushl  0x8(%ebp)
  800be6:	e8 6d fb ff ff       	call   800758 <fd_lookup>
  800beb:	83 c4 08             	add    $0x8,%esp
  800bee:	89 c2                	mov    %eax,%edx
  800bf0:	85 c0                	test   %eax,%eax
  800bf2:	78 58                	js     800c4c <fstat+0x77>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bfa:	50                   	push   %eax
  800bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfe:	ff 30                	pushl  (%eax)
  800c00:	e8 a9 fb ff ff       	call   8007ae <dev_lookup>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	78 37                	js     800c43 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
  800c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c0f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800c13:	74 32                	je     800c47 <fstat+0x72>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800c15:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800c18:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800c1f:	00 00 00 
	stat->st_isdir = 0;
  800c22:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c29:	00 00 00 
	stat->st_dev = dev;
  800c2c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	53                   	push   %ebx
  800c36:	ff 75 f0             	pushl  -0x10(%ebp)
  800c39:	ff 50 14             	call   *0x14(%eax)
  800c3c:	89 c2                	mov    %eax,%edx
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	eb 09                	jmp    800c4c <fstat+0x77>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c43:	89 c2                	mov    %eax,%edx
  800c45:	eb 05                	jmp    800c4c <fstat+0x77>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800c47:	ba f1 ff ff ff       	mov    $0xfffffff1,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800c4c:	89 d0                	mov    %edx,%eax
  800c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	6a 00                	push   $0x0
  800c5d:	ff 75 08             	pushl  0x8(%ebp)
  800c60:	e8 06 02 00 00       	call   800e6b <open>
  800c65:	89 c3                	mov    %eax,%ebx
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	78 1b                	js     800c89 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800c6e:	83 ec 08             	sub    $0x8,%esp
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	50                   	push   %eax
  800c75:	e8 5b ff ff ff       	call   800bd5 <fstat>
  800c7a:	89 c6                	mov    %eax,%esi
	close(fd);
  800c7c:	89 1c 24             	mov    %ebx,(%esp)
  800c7f:	e8 fd fb ff ff       	call   800881 <close>
	return r;
  800c84:	83 c4 10             	add    $0x10,%esp
  800c87:	89 f0                	mov    %esi,%eax
}
  800c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	89 c6                	mov    %eax,%esi
  800c97:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800c99:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ca0:	75 12                	jne    800cb4 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ca2:	83 ec 0c             	sub    $0xc,%esp
  800ca5:	6a 01                	push   $0x1
  800ca7:	e8 13 0e 00 00       	call   801abf <ipc_find_env>
  800cac:	a3 00 40 80 00       	mov    %eax,0x804000
  800cb1:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] fsipc %d %08x\n",
		        thisenv->env_id,
		        type,
		        *(uint32_t *) &fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800cb4:	6a 07                	push   $0x7
  800cb6:	68 00 50 80 00       	push   $0x805000
  800cbb:	56                   	push   %esi
  800cbc:	ff 35 00 40 80 00    	pushl  0x804000
  800cc2:	e8 a4 0d 00 00       	call   801a6b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800cc7:	83 c4 0c             	add    $0xc,%esp
  800cca:	6a 00                	push   $0x0
  800ccc:	53                   	push   %ebx
  800ccd:	6a 00                	push   $0x0
  800ccf:	e8 2c 0d 00 00       	call   801a00 <ipc_recv>
}
  800cd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  800ce7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfe:	e8 8d ff ff ff       	call   800c90 <fsipc>
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  800d11:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d20:	e8 6b ff ff ff       	call   800c90 <fsipc>
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <devfile_stat>:
	return result;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 04             	sub    $0x4,%esp
  800d2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 40 0c             	mov    0xc(%eax),%eax
  800d37:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d41:	b8 05 00 00 00       	mov    $0x5,%eax
  800d46:	e8 45 ff ff ff       	call   800c90 <fsipc>
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	78 2c                	js     800d7b <devfile_stat+0x54>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800d4f:	83 ec 08             	sub    $0x8,%esp
  800d52:	68 00 50 80 00       	push   $0x805000
  800d57:	53                   	push   %ebx
  800d58:	e8 1e f4 ff ff       	call   80017b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800d5d:	a1 80 50 80 00       	mov    0x805080,%eax
  800d62:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800d68:	a1 84 50 80 00       	mov    0x805084,%eax
  800d6d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 08             	sub    $0x8,%esp
  800d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800d8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d8f:	8b 49 0c             	mov    0xc(%ecx),%ecx
  800d92:	89 0d 00 50 80 00    	mov    %ecx,0x805000
	size_t bytes_count = sizeof(fsipcbuf.write.req_buf);
	if (bytes_count < n){
  800d98:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800d9d:	76 22                	jbe    800dc1 <devfile_write+0x41>
		fsipcbuf.write.req_n = bytes_count;
  800d9f:	c7 05 04 50 80 00 f8 	movl   $0xff8,0x805004
  800da6:	0f 00 00 
		memmove(fsipcbuf.write.req_buf, buf, bytes_count);
  800da9:	83 ec 04             	sub    $0x4,%esp
  800dac:	68 f8 0f 00 00       	push   $0xff8
  800db1:	52                   	push   %edx
  800db2:	68 08 50 80 00       	push   $0x805008
  800db7:	e8 52 f5 ff ff       	call   80030e <memmove>
  800dbc:	83 c4 10             	add    $0x10,%esp
  800dbf:	eb 17                	jmp    800dd8 <devfile_write+0x58>
	}	
	else{
		fsipcbuf.write.req_n = n;
  800dc1:	a3 04 50 80 00       	mov    %eax,0x805004
		memmove(fsipcbuf.write.req_buf, buf, n);
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	50                   	push   %eax
  800dca:	52                   	push   %edx
  800dcb:	68 08 50 80 00       	push   $0x805008
  800dd0:	e8 39 f5 ff ff       	call   80030e <memmove>
  800dd5:	83 c4 10             	add    $0x10,%esp
	}

	int result  = fsipc(FSREQ_WRITE, NULL);
  800dd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddd:	b8 04 00 00 00       	mov    $0x4,%eax
  800de2:	e8 a9 fe ff ff       	call   800c90 <fsipc>
	if (result < 0)
		return result;

	return result;
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8b 40 0c             	mov    0xc(%eax),%eax
  800df7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800dfc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800e02:	ba 00 00 00 00       	mov    $0x0,%edx
  800e07:	b8 03 00 00 00       	mov    $0x3,%eax
  800e0c:	e8 7f fe ff ff       	call   800c90 <fsipc>
  800e11:	89 c3                	mov    %eax,%ebx
  800e13:	85 c0                	test   %eax,%eax
  800e15:	78 4b                	js     800e62 <devfile_read+0x79>
		return r;
	assert(r <= n);
  800e17:	39 c6                	cmp    %eax,%esi
  800e19:	73 16                	jae    800e31 <devfile_read+0x48>
  800e1b:	68 a8 1e 80 00       	push   $0x801ea8
  800e20:	68 af 1e 80 00       	push   $0x801eaf
  800e25:	6a 7c                	push   $0x7c
  800e27:	68 c4 1e 80 00       	push   $0x801ec4
  800e2c:	e8 bd 05 00 00       	call   8013ee <_panic>
	assert(r <= PGSIZE);
  800e31:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800e36:	7e 16                	jle    800e4e <devfile_read+0x65>
  800e38:	68 cf 1e 80 00       	push   $0x801ecf
  800e3d:	68 af 1e 80 00       	push   $0x801eaf
  800e42:	6a 7d                	push   $0x7d
  800e44:	68 c4 1e 80 00       	push   $0x801ec4
  800e49:	e8 a0 05 00 00       	call   8013ee <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	50                   	push   %eax
  800e52:	68 00 50 80 00       	push   $0x805000
  800e57:	ff 75 0c             	pushl  0xc(%ebp)
  800e5a:	e8 af f4 ff ff       	call   80030e <memmove>
	return r;
  800e5f:	83 c4 10             	add    $0x10,%esp
}
  800e62:	89 d8                	mov    %ebx,%eax
  800e64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 20             	sub    $0x20,%esp
  800e72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800e75:	53                   	push   %ebx
  800e76:	e8 c7 f2 ff ff       	call   800142 <strlen>
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800e83:	7f 67                	jg     800eec <open+0x81>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800e85:	83 ec 0c             	sub    $0xc,%esp
  800e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e8b:	50                   	push   %eax
  800e8c:	e8 78 f8 ff ff       	call   800709 <fd_alloc>
  800e91:	83 c4 10             	add    $0x10,%esp
		return r;
  800e94:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	78 57                	js     800ef1 <open+0x86>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	53                   	push   %ebx
  800e9e:	68 00 50 80 00       	push   $0x805000
  800ea3:	e8 d3 f2 ff ff       	call   80017b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb3:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb8:	e8 d3 fd ff ff       	call   800c90 <fsipc>
  800ebd:	89 c3                	mov    %eax,%ebx
  800ebf:	83 c4 10             	add    $0x10,%esp
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	79 14                	jns    800eda <open+0x6f>
		fd_close(fd, 0);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	6a 00                	push   $0x0
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	e8 2e f9 ff ff       	call   800801 <fd_close>
		return r;
  800ed3:	83 c4 10             	add    $0x10,%esp
  800ed6:	89 da                	mov    %ebx,%edx
  800ed8:	eb 17                	jmp    800ef1 <open+0x86>
	}

	return fd2num(fd);
  800eda:	83 ec 0c             	sub    $0xc,%esp
  800edd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee0:	e8 fc f7 ff ff       	call   8006e1 <fd2num>
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	83 c4 10             	add    $0x10,%esp
  800eea:	eb 05                	jmp    800ef1 <open+0x86>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800eec:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800ef1:	89 d0                	mov    %edx,%eax
  800ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800efe:	ba 00 00 00 00       	mov    $0x0,%edx
  800f03:	b8 08 00 00 00       	mov    $0x8,%eax
  800f08:	e8 83 fd ff ff       	call   800c90 <fsipc>
}
  800f0d:	c9                   	leave  
  800f0e:	c3                   	ret    

00800f0f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
  800f14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	ff 75 08             	pushl  0x8(%ebp)
  800f1d:	e8 cf f7 ff ff       	call   8006f1 <fd2data>
  800f22:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800f24:	83 c4 08             	add    $0x8,%esp
  800f27:	68 db 1e 80 00       	push   $0x801edb
  800f2c:	53                   	push   %ebx
  800f2d:	e8 49 f2 ff ff       	call   80017b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800f32:	8b 46 04             	mov    0x4(%esi),%eax
  800f35:	2b 06                	sub    (%esi),%eax
  800f37:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800f3d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800f44:	00 00 00 
	stat->st_dev = &devpipe;
  800f47:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800f4e:	30 80 00 
	return 0;
}
  800f51:	b8 00 00 00 00       	mov    $0x0,%eax
  800f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	53                   	push   %ebx
  800f61:	83 ec 0c             	sub    $0xc,%esp
  800f64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800f67:	53                   	push   %ebx
  800f68:	6a 00                	push   $0x0
  800f6a:	e8 9f f6 ff ff       	call   80060e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800f6f:	89 1c 24             	mov    %ebx,(%esp)
  800f72:	e8 7a f7 ff ff       	call   8006f1 <fd2data>
  800f77:	83 c4 08             	add    $0x8,%esp
  800f7a:	50                   	push   %eax
  800f7b:	6a 00                	push   $0x0
  800f7d:	e8 8c f6 ff ff       	call   80060e <sys_page_unmap>
}
  800f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    

00800f87 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 1c             	sub    $0x1c,%esp
  800f90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f93:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800f95:	a1 04 40 80 00       	mov    0x804004,%eax
  800f9a:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  800f9d:	83 ec 0c             	sub    $0xc,%esp
  800fa0:	ff 75 e0             	pushl  -0x20(%ebp)
  800fa3:	e8 50 0b 00 00       	call   801af8 <pageref>
  800fa8:	89 c3                	mov    %eax,%ebx
  800faa:	89 3c 24             	mov    %edi,(%esp)
  800fad:	e8 46 0b 00 00       	call   801af8 <pageref>
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	39 c3                	cmp    %eax,%ebx
  800fb7:	0f 94 c1             	sete   %cl
  800fba:	0f b6 c9             	movzbl %cl,%ecx
  800fbd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
  800fc0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800fc6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800fc9:	39 ce                	cmp    %ecx,%esi
  800fcb:	74 1b                	je     800fe8 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800fcd:	39 c3                	cmp    %eax,%ebx
  800fcf:	75 c4                	jne    800f95 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800fd1:	8b 42 58             	mov    0x58(%edx),%eax
  800fd4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fd7:	50                   	push   %eax
  800fd8:	56                   	push   %esi
  800fd9:	68 e2 1e 80 00       	push   $0x801ee2
  800fde:	e8 e4 04 00 00       	call   8014c7 <cprintf>
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	eb ad                	jmp    800f95 <_pipeisclosed+0xe>
	}
}
  800fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5f                   	pop    %edi
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	57                   	push   %edi
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
  800ff9:	83 ec 28             	sub    $0x28,%esp
  800ffc:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800fff:	56                   	push   %esi
  801000:	e8 ec f6 ff ff       	call   8006f1 <fd2data>
  801005:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	bf 00 00 00 00       	mov    $0x0,%edi
  80100f:	eb 4b                	jmp    80105c <devpipe_write+0x69>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801011:	89 da                	mov    %ebx,%edx
  801013:	89 f0                	mov    %esi,%eax
  801015:	e8 6d ff ff ff       	call   800f87 <_pipeisclosed>
  80101a:	85 c0                	test   %eax,%eax
  80101c:	75 48                	jne    801066 <devpipe_write+0x73>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80101e:	e8 7a f5 ff ff       	call   80059d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801023:	8b 43 04             	mov    0x4(%ebx),%eax
  801026:	8b 0b                	mov    (%ebx),%ecx
  801028:	8d 51 20             	lea    0x20(%ecx),%edx
  80102b:	39 d0                	cmp    %edx,%eax
  80102d:	73 e2                	jae    801011 <devpipe_write+0x1e>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801036:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801039:	89 c2                	mov    %eax,%edx
  80103b:	c1 fa 1f             	sar    $0x1f,%edx
  80103e:	89 d1                	mov    %edx,%ecx
  801040:	c1 e9 1b             	shr    $0x1b,%ecx
  801043:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801046:	83 e2 1f             	and    $0x1f,%edx
  801049:	29 ca                	sub    %ecx,%edx
  80104b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80104f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801053:	83 c0 01             	add    $0x1,%eax
  801056:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801059:	83 c7 01             	add    $0x1,%edi
  80105c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80105f:	75 c2                	jne    801023 <devpipe_write+0x30>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801061:	8b 45 10             	mov    0x10(%ebp),%eax
  801064:	eb 05                	jmp    80106b <devpipe_write+0x78>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80106b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
  801079:	83 ec 18             	sub    $0x18,%esp
  80107c:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80107f:	57                   	push   %edi
  801080:	e8 6c f6 ff ff       	call   8006f1 <fd2data>
  801085:	89 c6                	mov    %eax,%esi
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108f:	eb 3d                	jmp    8010ce <devpipe_read+0x5b>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801091:	85 db                	test   %ebx,%ebx
  801093:	74 04                	je     801099 <devpipe_read+0x26>
				return i;
  801095:	89 d8                	mov    %ebx,%eax
  801097:	eb 44                	jmp    8010dd <devpipe_read+0x6a>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801099:	89 f2                	mov    %esi,%edx
  80109b:	89 f8                	mov    %edi,%eax
  80109d:	e8 e5 fe ff ff       	call   800f87 <_pipeisclosed>
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	75 32                	jne    8010d8 <devpipe_read+0x65>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8010a6:	e8 f2 f4 ff ff       	call   80059d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8010ab:	8b 06                	mov    (%esi),%eax
  8010ad:	3b 46 04             	cmp    0x4(%esi),%eax
  8010b0:	74 df                	je     801091 <devpipe_read+0x1e>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8010b2:	99                   	cltd   
  8010b3:	c1 ea 1b             	shr    $0x1b,%edx
  8010b6:	01 d0                	add    %edx,%eax
  8010b8:	83 e0 1f             	and    $0x1f,%eax
  8010bb:	29 d0                	sub    %edx,%eax
  8010bd:	0f b6 44 06 08       	movzbl 0x8(%esi,%eax,1),%eax
  8010c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c5:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8010c8:	83 06 01             	addl   $0x1,(%esi)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8010cb:	83 c3 01             	add    $0x1,%ebx
  8010ce:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8010d1:	75 d8                	jne    8010ab <devpipe_read+0x38>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	eb 05                	jmp    8010dd <devpipe_read+0x6a>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8010dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e0:	5b                   	pop    %ebx
  8010e1:	5e                   	pop    %esi
  8010e2:	5f                   	pop    %edi
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    

008010e5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	56                   	push   %esi
  8010e9:	53                   	push   %ebx
  8010ea:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8010ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f0:	50                   	push   %eax
  8010f1:	e8 13 f6 ff ff       	call   800709 <fd_alloc>
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	89 c2                	mov    %eax,%edx
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	0f 88 2c 01 00 00    	js     80122f <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	68 07 04 00 00       	push   $0x407
  80110b:	ff 75 f4             	pushl  -0xc(%ebp)
  80110e:	6a 00                	push   $0x0
  801110:	e8 af f4 ff ff       	call   8005c4 <sys_page_alloc>
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	89 c2                	mov    %eax,%edx
  80111a:	85 c0                	test   %eax,%eax
  80111c:	0f 88 0d 01 00 00    	js     80122f <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801122:	83 ec 0c             	sub    $0xc,%esp
  801125:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801128:	50                   	push   %eax
  801129:	e8 db f5 ff ff       	call   800709 <fd_alloc>
  80112e:	89 c3                	mov    %eax,%ebx
  801130:	83 c4 10             	add    $0x10,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	0f 88 e2 00 00 00    	js     80121d <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80113b:	83 ec 04             	sub    $0x4,%esp
  80113e:	68 07 04 00 00       	push   $0x407
  801143:	ff 75 f0             	pushl  -0x10(%ebp)
  801146:	6a 00                	push   $0x0
  801148:	e8 77 f4 ff ff       	call   8005c4 <sys_page_alloc>
  80114d:	89 c3                	mov    %eax,%ebx
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	0f 88 c3 00 00 00    	js     80121d <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	ff 75 f4             	pushl  -0xc(%ebp)
  801160:	e8 8c f5 ff ff       	call   8006f1 <fd2data>
  801165:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801167:	83 c4 0c             	add    $0xc,%esp
  80116a:	68 07 04 00 00       	push   $0x407
  80116f:	50                   	push   %eax
  801170:	6a 00                	push   $0x0
  801172:	e8 4d f4 ff ff       	call   8005c4 <sys_page_alloc>
  801177:	89 c3                	mov    %eax,%ebx
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	85 c0                	test   %eax,%eax
  80117e:	0f 88 89 00 00 00    	js     80120d <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	ff 75 f0             	pushl  -0x10(%ebp)
  80118a:	e8 62 f5 ff ff       	call   8006f1 <fd2data>
  80118f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801196:	50                   	push   %eax
  801197:	6a 00                	push   $0x0
  801199:	56                   	push   %esi
  80119a:	6a 00                	push   $0x0
  80119c:	e8 47 f4 ff ff       	call   8005e8 <sys_page_map>
  8011a1:	89 c3                	mov    %eax,%ebx
  8011a3:	83 c4 20             	add    $0x20,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 55                	js     8011ff <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8011aa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8011b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8011b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8011bf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8011c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8011ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8011da:	e8 02 f5 ff ff       	call   8006e1 <fd2num>
  8011df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8011e4:	83 c4 04             	add    $0x4,%esp
  8011e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ea:	e8 f2 f4 ff ff       	call   8006e1 <fd2num>
  8011ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fd:	eb 30                	jmp    80122f <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	56                   	push   %esi
  801203:	6a 00                	push   $0x0
  801205:	e8 04 f4 ff ff       	call   80060e <sys_page_unmap>
  80120a:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80120d:	83 ec 08             	sub    $0x8,%esp
  801210:	ff 75 f0             	pushl  -0x10(%ebp)
  801213:	6a 00                	push   $0x0
  801215:	e8 f4 f3 ff ff       	call   80060e <sys_page_unmap>
  80121a:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	ff 75 f4             	pushl  -0xc(%ebp)
  801223:	6a 00                	push   $0x0
  801225:	e8 e4 f3 ff ff       	call   80060e <sys_page_unmap>
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
  80122f:	89 d0                	mov    %edx,%eax
  801231:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801234:	5b                   	pop    %ebx
  801235:	5e                   	pop    %esi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80123e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801241:	50                   	push   %eax
  801242:	ff 75 08             	pushl  0x8(%ebp)
  801245:	e8 0e f5 ff ff       	call   800758 <fd_lookup>
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 18                	js     801269 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	ff 75 f4             	pushl  -0xc(%ebp)
  801257:	e8 95 f4 ff ff       	call   8006f1 <fd2data>
	return _pipeisclosed(fd, p);
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	e8 21 fd ff ff       	call   800f87 <_pipeisclosed>
  801266:	83 c4 10             	add    $0x10,%esp
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
  801273:	5d                   	pop    %ebp
  801274:	c3                   	ret    

00801275 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80127b:	68 fa 1e 80 00       	push   $0x801efa
  801280:	ff 75 0c             	pushl  0xc(%ebp)
  801283:	e8 f3 ee ff ff       	call   80017b <strcpy>
	return 0;
}
  801288:	b8 00 00 00 00       	mov    $0x0,%eax
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	57                   	push   %edi
  801293:	56                   	push   %esi
  801294:	53                   	push   %ebx
  801295:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80129b:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8012a0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8012a6:	eb 2d                	jmp    8012d5 <devcons_write+0x46>
		m = n - tot;
  8012a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ab:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8012ad:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8012b0:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8012b5:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	53                   	push   %ebx
  8012bc:	03 45 0c             	add    0xc(%ebp),%eax
  8012bf:	50                   	push   %eax
  8012c0:	57                   	push   %edi
  8012c1:	e8 48 f0 ff ff       	call   80030e <memmove>
		sys_cputs(buf, m);
  8012c6:	83 c4 08             	add    $0x8,%esp
  8012c9:	53                   	push   %ebx
  8012ca:	57                   	push   %edi
  8012cb:	e8 3d f2 ff ff       	call   80050d <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8012d0:	01 de                	add    %ebx,%esi
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	89 f0                	mov    %esi,%eax
  8012d7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8012da:	72 cc                	jb     8012a8 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012df:	5b                   	pop    %ebx
  8012e0:	5e                   	pop    %esi
  8012e1:	5f                   	pop    %edi
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    

008012e4 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
  8012ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f3:	74 2a                	je     80131f <devcons_read+0x3b>
  8012f5:	eb 05                	jmp    8012fc <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8012f7:	e8 a1 f2 ff ff       	call   80059d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8012fc:	e8 32 f2 ff ff       	call   800533 <sys_cgetc>
  801301:	85 c0                	test   %eax,%eax
  801303:	74 f2                	je     8012f7 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801305:	85 c0                	test   %eax,%eax
  801307:	78 16                	js     80131f <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801309:	83 f8 04             	cmp    $0x4,%eax
  80130c:	74 0c                	je     80131a <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80130e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801311:	88 02                	mov    %al,(%edx)
	return 1;
  801313:	b8 01 00 00 00       	mov    $0x1,%eax
  801318:	eb 05                	jmp    80131f <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80132d:	6a 01                	push   $0x1
  80132f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801332:	50                   	push   %eax
  801333:	e8 d5 f1 ff ff       	call   80050d <sys_cputs>
}
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <getchar>:

int
getchar(void)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801343:	6a 01                	push   $0x1
  801345:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	6a 00                	push   $0x0
  80134b:	e8 6d f6 ff ff       	call   8009bd <read>
	if (r < 0)
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	78 0f                	js     801366 <getchar+0x29>
		return r;
	if (r < 1)
  801357:	85 c0                	test   %eax,%eax
  801359:	7e 06                	jle    801361 <getchar+0x24>
		return -E_EOF;
	return c;
  80135b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  80135f:	eb 05                	jmp    801366 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801361:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80136e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801371:	50                   	push   %eax
  801372:	ff 75 08             	pushl  0x8(%ebp)
  801375:	e8 de f3 ff ff       	call   800758 <fd_lookup>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 11                	js     801392 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801384:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80138a:	39 10                	cmp    %edx,(%eax)
  80138c:	0f 94 c0             	sete   %al
  80138f:	0f b6 c0             	movzbl %al,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <opencons>:

int
opencons(void)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80139a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139d:	50                   	push   %eax
  80139e:	e8 66 f3 ff ff       	call   800709 <fd_alloc>
  8013a3:	83 c4 10             	add    $0x10,%esp
		return r;
  8013a6:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	78 3e                	js     8013ea <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	68 07 04 00 00       	push   $0x407
  8013b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b7:	6a 00                	push   $0x0
  8013b9:	e8 06 f2 ff ff       	call   8005c4 <sys_page_alloc>
  8013be:	83 c4 10             	add    $0x10,%esp
		return r;
  8013c1:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 23                	js     8013ea <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8013c7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8013cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8013d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8013dc:	83 ec 0c             	sub    $0xc,%esp
  8013df:	50                   	push   %eax
  8013e0:	e8 fc f2 ff ff       	call   8006e1 <fd2num>
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	83 c4 10             	add    $0x10,%esp
}
  8013ea:	89 d0                	mov    %edx,%eax
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	56                   	push   %esi
  8013f2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8013f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8013f6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8013fc:	e8 78 f1 ff ff       	call   800579 <sys_getenvid>
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	ff 75 08             	pushl  0x8(%ebp)
  80140a:	56                   	push   %esi
  80140b:	50                   	push   %eax
  80140c:	68 08 1f 80 00       	push   $0x801f08
  801411:	e8 b1 00 00 00       	call   8014c7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801416:	83 c4 18             	add    $0x18,%esp
  801419:	53                   	push   %ebx
  80141a:	ff 75 10             	pushl  0x10(%ebp)
  80141d:	e8 54 00 00 00       	call   801476 <vcprintf>
	cprintf("\n");
  801422:	c7 04 24 f3 1e 80 00 	movl   $0x801ef3,(%esp)
  801429:	e8 99 00 00 00       	call   8014c7 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801431:	cc                   	int3   
  801432:	eb fd                	jmp    801431 <_panic+0x43>

00801434 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	53                   	push   %ebx
  801438:	83 ec 04             	sub    $0x4,%esp
  80143b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80143e:	8b 13                	mov    (%ebx),%edx
  801440:	8d 42 01             	lea    0x1(%edx),%eax
  801443:	89 03                	mov    %eax,(%ebx)
  801445:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801448:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80144c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801451:	75 1a                	jne    80146d <putch+0x39>
		sys_cputs(b->buf, b->idx);
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	68 ff 00 00 00       	push   $0xff
  80145b:	8d 43 08             	lea    0x8(%ebx),%eax
  80145e:	50                   	push   %eax
  80145f:	e8 a9 f0 ff ff       	call   80050d <sys_cputs>
		b->idx = 0;
  801464:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80146a:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80146d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80147f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801486:	00 00 00 
	b.cnt = 0;
  801489:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801490:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	ff 75 08             	pushl  0x8(%ebp)
  801499:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80149f:	50                   	push   %eax
  8014a0:	68 34 14 80 00       	push   $0x801434
  8014a5:	e8 86 01 00 00       	call   801630 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8014aa:	83 c4 08             	add    $0x8,%esp
  8014ad:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8014b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8014b9:	50                   	push   %eax
  8014ba:	e8 4e f0 ff ff       	call   80050d <sys_cputs>

	return b.cnt;
}
  8014bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8014cd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8014d0:	50                   	push   %eax
  8014d1:	ff 75 08             	pushl  0x8(%ebp)
  8014d4:	e8 9d ff ff ff       	call   801476 <vcprintf>
	va_end(ap);

	return cnt;
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	57                   	push   %edi
  8014df:	56                   	push   %esi
  8014e0:	53                   	push   %ebx
  8014e1:	83 ec 1c             	sub    $0x1c,%esp
  8014e4:	89 c7                	mov    %eax,%edi
  8014e6:	89 d6                	mov    %edx,%esi
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8014f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014ff:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801502:	39 d3                	cmp    %edx,%ebx
  801504:	72 05                	jb     80150b <printnum+0x30>
  801506:	39 45 10             	cmp    %eax,0x10(%ebp)
  801509:	77 45                	ja     801550 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	ff 75 18             	pushl  0x18(%ebp)
  801511:	8b 45 14             	mov    0x14(%ebp),%eax
  801514:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801517:	53                   	push   %ebx
  801518:	ff 75 10             	pushl  0x10(%ebp)
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801521:	ff 75 e0             	pushl  -0x20(%ebp)
  801524:	ff 75 dc             	pushl  -0x24(%ebp)
  801527:	ff 75 d8             	pushl  -0x28(%ebp)
  80152a:	e8 11 06 00 00       	call   801b40 <__udivdi3>
  80152f:	83 c4 18             	add    $0x18,%esp
  801532:	52                   	push   %edx
  801533:	50                   	push   %eax
  801534:	89 f2                	mov    %esi,%edx
  801536:	89 f8                	mov    %edi,%eax
  801538:	e8 9e ff ff ff       	call   8014db <printnum>
  80153d:	83 c4 20             	add    $0x20,%esp
  801540:	eb 18                	jmp    80155a <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	56                   	push   %esi
  801546:	ff 75 18             	pushl  0x18(%ebp)
  801549:	ff d7                	call   *%edi
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	eb 03                	jmp    801553 <printnum+0x78>
  801550:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801553:	83 eb 01             	sub    $0x1,%ebx
  801556:	85 db                	test   %ebx,%ebx
  801558:	7f e8                	jg     801542 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	56                   	push   %esi
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	ff 75 e4             	pushl  -0x1c(%ebp)
  801564:	ff 75 e0             	pushl  -0x20(%ebp)
  801567:	ff 75 dc             	pushl  -0x24(%ebp)
  80156a:	ff 75 d8             	pushl  -0x28(%ebp)
  80156d:	e8 fe 06 00 00       	call   801c70 <__umoddi3>
  801572:	83 c4 14             	add    $0x14,%esp
  801575:	0f be 80 2b 1f 80 00 	movsbl 0x801f2b(%eax),%eax
  80157c:	50                   	push   %eax
  80157d:	ff d7                	call   *%edi
}
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5f                   	pop    %edi
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80158d:	83 fa 01             	cmp    $0x1,%edx
  801590:	7e 0e                	jle    8015a0 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801592:	8b 10                	mov    (%eax),%edx
  801594:	8d 4a 08             	lea    0x8(%edx),%ecx
  801597:	89 08                	mov    %ecx,(%eax)
  801599:	8b 02                	mov    (%edx),%eax
  80159b:	8b 52 04             	mov    0x4(%edx),%edx
  80159e:	eb 22                	jmp    8015c2 <getuint+0x38>
	else if (lflag)
  8015a0:	85 d2                	test   %edx,%edx
  8015a2:	74 10                	je     8015b4 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8015a4:	8b 10                	mov    (%eax),%edx
  8015a6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8015a9:	89 08                	mov    %ecx,(%eax)
  8015ab:	8b 02                	mov    (%edx),%eax
  8015ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b2:	eb 0e                	jmp    8015c2 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8015b4:	8b 10                	mov    (%eax),%edx
  8015b6:	8d 4a 04             	lea    0x4(%edx),%ecx
  8015b9:	89 08                	mov    %ecx,(%eax)
  8015bb:	8b 02                	mov    (%edx),%eax
  8015bd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    

008015c4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015c7:	83 fa 01             	cmp    $0x1,%edx
  8015ca:	7e 0e                	jle    8015da <getint+0x16>
		return va_arg(*ap, long long);
  8015cc:	8b 10                	mov    (%eax),%edx
  8015ce:	8d 4a 08             	lea    0x8(%edx),%ecx
  8015d1:	89 08                	mov    %ecx,(%eax)
  8015d3:	8b 02                	mov    (%edx),%eax
  8015d5:	8b 52 04             	mov    0x4(%edx),%edx
  8015d8:	eb 1a                	jmp    8015f4 <getint+0x30>
	else if (lflag)
  8015da:	85 d2                	test   %edx,%edx
  8015dc:	74 0c                	je     8015ea <getint+0x26>
		return va_arg(*ap, long);
  8015de:	8b 10                	mov    (%eax),%edx
  8015e0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8015e3:	89 08                	mov    %ecx,(%eax)
  8015e5:	8b 02                	mov    (%edx),%eax
  8015e7:	99                   	cltd   
  8015e8:	eb 0a                	jmp    8015f4 <getint+0x30>
	else
		return va_arg(*ap, int);
  8015ea:	8b 10                	mov    (%eax),%edx
  8015ec:	8d 4a 04             	lea    0x4(%edx),%ecx
  8015ef:	89 08                	mov    %ecx,(%eax)
  8015f1:	8b 02                	mov    (%edx),%eax
  8015f3:	99                   	cltd   
}
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8015fc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801600:	8b 10                	mov    (%eax),%edx
  801602:	3b 50 04             	cmp    0x4(%eax),%edx
  801605:	73 0a                	jae    801611 <sprintputch+0x1b>
		*b->buf++ = ch;
  801607:	8d 4a 01             	lea    0x1(%edx),%ecx
  80160a:	89 08                	mov    %ecx,(%eax)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	88 02                	mov    %al,(%edx)
}
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    

00801613 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  801619:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80161c:	50                   	push   %eax
  80161d:	ff 75 10             	pushl  0x10(%ebp)
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	ff 75 08             	pushl  0x8(%ebp)
  801626:	e8 05 00 00 00       	call   801630 <vprintfmt>
	va_end(ap);
}
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	57                   	push   %edi
  801634:	56                   	push   %esi
  801635:	53                   	push   %ebx
  801636:	83 ec 2c             	sub    $0x2c,%esp
  801639:	8b 75 08             	mov    0x8(%ebp),%esi
  80163c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80163f:	8b 7d 10             	mov    0x10(%ebp),%edi
  801642:	eb 12                	jmp    801656 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801644:	85 c0                	test   %eax,%eax
  801646:	0f 84 44 03 00 00    	je     801990 <vprintfmt+0x360>
				return;
			putch(ch, putdat);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	53                   	push   %ebx
  801650:	50                   	push   %eax
  801651:	ff d6                	call   *%esi
  801653:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801656:	83 c7 01             	add    $0x1,%edi
  801659:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80165d:	83 f8 25             	cmp    $0x25,%eax
  801660:	75 e2                	jne    801644 <vprintfmt+0x14>
  801662:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801666:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80166d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801674:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	eb 07                	jmp    801689 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801682:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  801685:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801689:	8d 47 01             	lea    0x1(%edi),%eax
  80168c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80168f:	0f b6 07             	movzbl (%edi),%eax
  801692:	0f b6 c8             	movzbl %al,%ecx
  801695:	83 e8 23             	sub    $0x23,%eax
  801698:	3c 55                	cmp    $0x55,%al
  80169a:	0f 87 d5 02 00 00    	ja     801975 <vprintfmt+0x345>
  8016a0:	0f b6 c0             	movzbl %al,%eax
  8016a3:	ff 24 85 60 20 80 00 	jmp    *0x802060(,%eax,4)
  8016aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8016ad:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8016b1:	eb d6                	jmp    801689 <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8016be:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8016c1:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
				ch = *fmt;
  8016c5:	0f be 0f             	movsbl (%edi),%ecx
				if (ch < '0' || ch > '9')
  8016c8:	8d 51 d0             	lea    -0x30(%ecx),%edx
  8016cb:	83 fa 09             	cmp    $0x9,%edx
  8016ce:	77 39                	ja     801709 <vprintfmt+0xd9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016d0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8016d3:	eb e9                	jmp    8016be <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8016d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d8:	8d 48 04             	lea    0x4(%eax),%ecx
  8016db:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8016de:	8b 00                	mov    (%eax),%eax
  8016e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8016e6:	eb 27                	jmp    80170f <vprintfmt+0xdf>
  8016e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f2:	0f 49 c8             	cmovns %eax,%ecx
  8016f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016fb:	eb 8c                	jmp    801689 <vprintfmt+0x59>
  8016fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801700:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801707:	eb 80                	jmp    801689 <vprintfmt+0x59>
  801709:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80170c:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80170f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801713:	0f 89 70 ff ff ff    	jns    801689 <vprintfmt+0x59>
				width = precision, precision = -1;
  801719:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80171c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80171f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801726:	e9 5e ff ff ff       	jmp    801689 <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80172b:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80172e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801731:	e9 53 ff ff ff       	jmp    801689 <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801736:	8b 45 14             	mov    0x14(%ebp),%eax
  801739:	8d 50 04             	lea    0x4(%eax),%edx
  80173c:	89 55 14             	mov    %edx,0x14(%ebp)
  80173f:	83 ec 08             	sub    $0x8,%esp
  801742:	53                   	push   %ebx
  801743:	ff 30                	pushl  (%eax)
  801745:	ff d6                	call   *%esi
			break;
  801747:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80174a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  80174d:	e9 04 ff ff ff       	jmp    801656 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801752:	8b 45 14             	mov    0x14(%ebp),%eax
  801755:	8d 50 04             	lea    0x4(%eax),%edx
  801758:	89 55 14             	mov    %edx,0x14(%ebp)
  80175b:	8b 00                	mov    (%eax),%eax
  80175d:	99                   	cltd   
  80175e:	31 d0                	xor    %edx,%eax
  801760:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801762:	83 f8 0f             	cmp    $0xf,%eax
  801765:	7f 0b                	jg     801772 <vprintfmt+0x142>
  801767:	8b 14 85 c0 21 80 00 	mov    0x8021c0(,%eax,4),%edx
  80176e:	85 d2                	test   %edx,%edx
  801770:	75 18                	jne    80178a <vprintfmt+0x15a>
				printfmt(putch, putdat, "error %d", err);
  801772:	50                   	push   %eax
  801773:	68 43 1f 80 00       	push   $0x801f43
  801778:	53                   	push   %ebx
  801779:	56                   	push   %esi
  80177a:	e8 94 fe ff ff       	call   801613 <printfmt>
  80177f:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801782:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  801785:	e9 cc fe ff ff       	jmp    801656 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  80178a:	52                   	push   %edx
  80178b:	68 c1 1e 80 00       	push   $0x801ec1
  801790:	53                   	push   %ebx
  801791:	56                   	push   %esi
  801792:	e8 7c fe ff ff       	call   801613 <printfmt>
  801797:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80179a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80179d:	e9 b4 fe ff ff       	jmp    801656 <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8017a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a5:	8d 50 04             	lea    0x4(%eax),%edx
  8017a8:	89 55 14             	mov    %edx,0x14(%ebp)
  8017ab:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8017ad:	85 ff                	test   %edi,%edi
  8017af:	b8 3c 1f 80 00       	mov    $0x801f3c,%eax
  8017b4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8017b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017bb:	0f 8e 94 00 00 00    	jle    801855 <vprintfmt+0x225>
  8017c1:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8017c5:	0f 84 98 00 00 00    	je     801863 <vprintfmt+0x233>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 d0             	pushl  -0x30(%ebp)
  8017d1:	57                   	push   %edi
  8017d2:	e8 83 e9 ff ff       	call   80015a <strnlen>
  8017d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8017da:	29 c1                	sub    %eax,%ecx
  8017dc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8017df:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8017e2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8017e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017e9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8017ec:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8017ee:	eb 0f                	jmp    8017ff <vprintfmt+0x1cf>
					putch(padc, putdat);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	53                   	push   %ebx
  8017f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8017f7:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8017f9:	83 ef 01             	sub    $0x1,%edi
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	85 ff                	test   %edi,%edi
  801801:	7f ed                	jg     8017f0 <vprintfmt+0x1c0>
  801803:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801806:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801809:	85 c9                	test   %ecx,%ecx
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
  801810:	0f 49 c1             	cmovns %ecx,%eax
  801813:	29 c1                	sub    %eax,%ecx
  801815:	89 75 08             	mov    %esi,0x8(%ebp)
  801818:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80181b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80181e:	89 cb                	mov    %ecx,%ebx
  801820:	eb 4d                	jmp    80186f <vprintfmt+0x23f>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801822:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801826:	74 1b                	je     801843 <vprintfmt+0x213>
  801828:	0f be c0             	movsbl %al,%eax
  80182b:	83 e8 20             	sub    $0x20,%eax
  80182e:	83 f8 5e             	cmp    $0x5e,%eax
  801831:	76 10                	jbe    801843 <vprintfmt+0x213>
					putch('?', putdat);
  801833:	83 ec 08             	sub    $0x8,%esp
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	6a 3f                	push   $0x3f
  80183b:	ff 55 08             	call   *0x8(%ebp)
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	eb 0d                	jmp    801850 <vprintfmt+0x220>
				else
					putch(ch, putdat);
  801843:	83 ec 08             	sub    $0x8,%esp
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	52                   	push   %edx
  80184a:	ff 55 08             	call   *0x8(%ebp)
  80184d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801850:	83 eb 01             	sub    $0x1,%ebx
  801853:	eb 1a                	jmp    80186f <vprintfmt+0x23f>
  801855:	89 75 08             	mov    %esi,0x8(%ebp)
  801858:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80185b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80185e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801861:	eb 0c                	jmp    80186f <vprintfmt+0x23f>
  801863:	89 75 08             	mov    %esi,0x8(%ebp)
  801866:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801869:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80186c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80186f:	83 c7 01             	add    $0x1,%edi
  801872:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801876:	0f be d0             	movsbl %al,%edx
  801879:	85 d2                	test   %edx,%edx
  80187b:	74 23                	je     8018a0 <vprintfmt+0x270>
  80187d:	85 f6                	test   %esi,%esi
  80187f:	78 a1                	js     801822 <vprintfmt+0x1f2>
  801881:	83 ee 01             	sub    $0x1,%esi
  801884:	79 9c                	jns    801822 <vprintfmt+0x1f2>
  801886:	89 df                	mov    %ebx,%edi
  801888:	8b 75 08             	mov    0x8(%ebp),%esi
  80188b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80188e:	eb 18                	jmp    8018a8 <vprintfmt+0x278>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	53                   	push   %ebx
  801894:	6a 20                	push   $0x20
  801896:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801898:	83 ef 01             	sub    $0x1,%edi
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	eb 08                	jmp    8018a8 <vprintfmt+0x278>
  8018a0:	89 df                	mov    %ebx,%edi
  8018a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8018a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018a8:	85 ff                	test   %edi,%edi
  8018aa:	7f e4                	jg     801890 <vprintfmt+0x260>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8018ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8018af:	e9 a2 fd ff ff       	jmp    801656 <vprintfmt+0x26>
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8018b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8018b7:	e8 08 fd ff ff       	call   8015c4 <getint>
  8018bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8018c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8018c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018cb:	79 74                	jns    801941 <vprintfmt+0x311>
				putch('-', putdat);
  8018cd:	83 ec 08             	sub    $0x8,%esp
  8018d0:	53                   	push   %ebx
  8018d1:	6a 2d                	push   $0x2d
  8018d3:	ff d6                	call   *%esi
				num = -(long long) num;
  8018d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018db:	f7 d8                	neg    %eax
  8018dd:	83 d2 00             	adc    $0x0,%edx
  8018e0:	f7 da                	neg    %edx
  8018e2:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8018e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ea:	eb 55                	jmp    801941 <vprintfmt+0x311>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8018ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8018ef:	e8 96 fc ff ff       	call   80158a <getuint>
			base = 10;
  8018f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8018f9:	eb 46                	jmp    801941 <vprintfmt+0x311>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8018fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8018fe:	e8 87 fc ff ff       	call   80158a <getuint>
			base = 8;
  801903:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801908:	eb 37                	jmp    801941 <vprintfmt+0x311>

		// pointer
		case 'p':
			putch('0', putdat);
  80190a:	83 ec 08             	sub    $0x8,%esp
  80190d:	53                   	push   %ebx
  80190e:	6a 30                	push   $0x30
  801910:	ff d6                	call   *%esi
			putch('x', putdat);
  801912:	83 c4 08             	add    $0x8,%esp
  801915:	53                   	push   %ebx
  801916:	6a 78                	push   $0x78
  801918:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80191a:	8b 45 14             	mov    0x14(%ebp),%eax
  80191d:	8d 50 04             	lea    0x4(%eax),%edx
  801920:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801923:	8b 00                	mov    (%eax),%eax
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80192a:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80192d:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801932:	eb 0d                	jmp    801941 <vprintfmt+0x311>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801934:	8d 45 14             	lea    0x14(%ebp),%eax
  801937:	e8 4e fc ff ff       	call   80158a <getuint>
			base = 16;
  80193c:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801941:	83 ec 0c             	sub    $0xc,%esp
  801944:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801948:	57                   	push   %edi
  801949:	ff 75 e0             	pushl  -0x20(%ebp)
  80194c:	51                   	push   %ecx
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	89 da                	mov    %ebx,%edx
  801951:	89 f0                	mov    %esi,%eax
  801953:	e8 83 fb ff ff       	call   8014db <printnum>
			break;
  801958:	83 c4 20             	add    $0x20,%esp
  80195b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80195e:	e9 f3 fc ff ff       	jmp    801656 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	53                   	push   %ebx
  801967:	51                   	push   %ecx
  801968:	ff d6                	call   *%esi
			break;
  80196a:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80196d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  801970:	e9 e1 fc ff ff       	jmp    801656 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801975:	83 ec 08             	sub    $0x8,%esp
  801978:	53                   	push   %ebx
  801979:	6a 25                	push   $0x25
  80197b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	eb 03                	jmp    801985 <vprintfmt+0x355>
  801982:	83 ef 01             	sub    $0x1,%edi
  801985:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  801989:	75 f7                	jne    801982 <vprintfmt+0x352>
  80198b:	e9 c6 fc ff ff       	jmp    801656 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  801990:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5f                   	pop    %edi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    

00801998 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 18             	sub    $0x18,%esp
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8019a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019a7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8019ab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8019ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	74 26                	je     8019df <vsnprintf+0x47>
  8019b9:	85 d2                	test   %edx,%edx
  8019bb:	7e 22                	jle    8019df <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8019bd:	ff 75 14             	pushl  0x14(%ebp)
  8019c0:	ff 75 10             	pushl  0x10(%ebp)
  8019c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8019c6:	50                   	push   %eax
  8019c7:	68 f6 15 80 00       	push   $0x8015f6
  8019cc:	e8 5f fc ff ff       	call   801630 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8019d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	eb 05                	jmp    8019e4 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8019df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8019ec:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8019ef:	50                   	push   %eax
  8019f0:	ff 75 10             	pushl  0x10(%ebp)
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	e8 9a ff ff ff       	call   801998 <vsnprintf>
	va_end(ap);

	return rc;
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <ipc_recv>:
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
#define NO_PAGE UTOP //Elijo un valor sin sentido para que sys_ipc_recv entienda que no tiene sentido.
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	8b 75 08             	mov    0x8(%ebp),%esi
  801a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
    if (!pg)
  801a0e:	85 c0                	test   %eax,%eax
		pg = (void*)NO_PAGE;
  801a10:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801a15:	0f 44 c2             	cmove  %edx,%eax
	result = sys_ipc_recv(pg);
  801a18:	83 ec 0c             	sub    $0xc,%esp
  801a1b:	50                   	push   %eax
  801a1c:	e8 9e ec ff ff       	call   8006bf <sys_ipc_recv>
	if (from_env_store)
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	85 f6                	test   %esi,%esi
  801a26:	74 0b                	je     801a33 <ipc_recv+0x33>
		*from_env_store = thisenv->env_ipc_from;
  801a28:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a2e:	8b 52 74             	mov    0x74(%edx),%edx
  801a31:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801a33:	85 db                	test   %ebx,%ebx
  801a35:	74 0b                	je     801a42 <ipc_recv+0x42>
		*perm_store = thisenv->env_ipc_perm;
  801a37:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a3d:	8b 52 78             	mov    0x78(%edx),%edx
  801a40:	89 13                	mov    %edx,(%ebx)

	if (result < 0) {
  801a42:	85 c0                	test   %eax,%eax
  801a44:	79 16                	jns    801a5c <ipc_recv+0x5c>
		if (from_env_store)
  801a46:	85 f6                	test   %esi,%esi
  801a48:	74 06                	je     801a50 <ipc_recv+0x50>
			*from_env_store = 0;
  801a4a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store)
  801a50:	85 db                	test   %ebx,%ebx
  801a52:	74 10                	je     801a64 <ipc_recv+0x64>
			*perm_store = 0;
  801a54:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a5a:	eb 08                	jmp    801a64 <ipc_recv+0x64>
		
		 return result;
	}

	return thisenv->env_ipc_value;
  801a5c:	a1 04 40 80 00       	mov    0x804004,%eax
  801a61:	8b 40 70             	mov    0x70(%eax),%eax
}
  801a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    

00801a6b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	57                   	push   %edi
  801a6f:	56                   	push   %esi
  801a70:	53                   	push   %ebx
  801a71:	83 ec 0c             	sub    $0xc,%esp
  801a74:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a77:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int result;
	if (!pg)
  801a7d:	85 db                	test   %ebx,%ebx
		pg = (void*)NO_PAGE;
  801a7f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801a84:	0f 44 d8             	cmove  %eax,%ebx
  801a87:	eb 1c                	jmp    801aa5 <ipc_send+0x3a>
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
		if (result != -E_IPC_NOT_RECV) 
  801a89:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a8c:	74 12                	je     801aa0 <ipc_send+0x35>
			panic("Error inesperado, %e\n", result);
  801a8e:	50                   	push   %eax
  801a8f:	68 20 22 80 00       	push   $0x802220
  801a94:	6a 42                	push   $0x42
  801a96:	68 36 22 80 00       	push   $0x802236
  801a9b:	e8 4e f9 ff ff       	call   8013ee <_panic>
		sys_yield();
  801aa0:	e8 f8 ea ff ff       	call   80059d <sys_yield>
	// LAB 4: Your code here.
	int result;
	if (!pg)
		pg = (void*)NO_PAGE;
	
	while ((result = sys_ipc_try_send(to_env, val, pg, perm))) {
  801aa5:	ff 75 14             	pushl  0x14(%ebp)
  801aa8:	53                   	push   %ebx
  801aa9:	56                   	push   %esi
  801aaa:	57                   	push   %edi
  801aab:	e8 ea eb ff ff       	call   80069a <sys_ipc_try_send>
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	75 d2                	jne    801a89 <ipc_send+0x1e>
		if (result != -E_IPC_NOT_RECV) 
			panic("Error inesperado, %e\n", result);
		sys_yield();
	}
}
  801ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aba:	5b                   	pop    %ebx
  801abb:	5e                   	pop    %esi
  801abc:	5f                   	pop    %edi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ac5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801aca:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801acd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ad3:	8b 52 50             	mov    0x50(%edx),%edx
  801ad6:	39 ca                	cmp    %ecx,%edx
  801ad8:	75 0d                	jne    801ae7 <ipc_find_env+0x28>
			return envs[i].env_id;
  801ada:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801add:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ae2:	8b 40 48             	mov    0x48(%eax),%eax
  801ae5:	eb 0f                	jmp    801af6 <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ae7:	83 c0 01             	add    $0x1,%eax
  801aea:	3d 00 04 00 00       	cmp    $0x400,%eax
  801aef:	75 d9                	jne    801aca <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801af1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    

00801af8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801afe:	89 d0                	mov    %edx,%eax
  801b00:	c1 e8 16             	shr    $0x16,%eax
  801b03:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b0f:	f6 c1 01             	test   $0x1,%cl
  801b12:	74 1d                	je     801b31 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801b14:	c1 ea 0c             	shr    $0xc,%edx
  801b17:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b1e:	f6 c2 01             	test   $0x1,%dl
  801b21:	74 0e                	je     801b31 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b23:	c1 ea 0c             	shr    $0xc,%edx
  801b26:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b2d:	ef 
  801b2e:	0f b7 c0             	movzwl %ax,%eax
}
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    
  801b33:	66 90                	xchg   %ax,%ax
  801b35:	66 90                	xchg   %ax,%ax
  801b37:	66 90                	xchg   %ax,%ax
  801b39:	66 90                	xchg   %ax,%ax
  801b3b:	66 90                	xchg   %ax,%ax
  801b3d:	66 90                	xchg   %ax,%ax
  801b3f:	90                   	nop

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
