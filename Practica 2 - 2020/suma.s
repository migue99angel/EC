.section .data
#ifndef TEST
#define TEST 20
#endif
    .macro linea                # Resultado - Comentario
#if TEST==1
		.int 1, 2, 1, 2
		.int 1, 2, 1, 2
		.int 1, 2, 1, 2
		.int 1, 2, 1, 2
#elif TEST==2
		.int -1, -2, -1, -2
		.int -1, -2, -1, -2
		.int -1, -2, -1, -2
		.int -1, -2, -1, -2
#elif TEST==3
		.int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff
		.int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff
		.int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff
		.int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff
#elif TEST==4
		.int 0x80000000, 0x80000000, 0x80000000, 0x80000000
		.int 0x80000000, 0x80000000, 0x80000000, 0x80000000
		.int 0x80000000, 0x80000000, 0x80000000, 0x80000000
		.int 0x80000000, 0x80000000, 0x80000000, 0x80000000
#elif TEST==5
		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
#elif TEST==6
		.int 2000000000, 2000000000, 2000000000, 2000000000
		.int 2000000000, 2000000000, 2000000000, 2000000000
		.int 2000000000, 2000000000, 2000000000, 2000000000
		.int 2000000000, 2000000000, 2000000000, 2000000000
#elif TEST==7
		.quad 3000000000, 3000000000, 3000000000, 3000000000
		.quad 3000000000, 3000000000, 3000000000, 3000000000
		.quad 3000000000, 3000000000, 3000000000, 3000000000
		.quad 3000000000, 3000000000, 3000000000, 3000000000
#elif TEST==8
		.int -2000000000, -2000000000, -2000000000, -2000000000
		.int -2000000000, -2000000000, -2000000000, -2000000000
		.int -2000000000, -2000000000, -2000000000, -2000000000
		.int -2000000000, -2000000000, -2000000000, -2000000000
#elif TEST==9
		.quad -3000000000, -3000000000, -3000000000, -3000000000
		.quad -3000000000, -3000000000, -3000000000, -3000000000
		.quad -3000000000, -3000000000, -3000000000, -3000000000
		.quad -3000000000, -3000000000, -3000000000, -3000000000
#elif TEST>=10 && TEST<=14
		.int 1, 1, 1, 1
		.int 1, 1, 1, 1
		.int 1, 1, 1, 1
#elif TEST>=15 && TEST<=19
		.int -1, -1, -1, -1
		.int -1, -1, -1, -1
		.int -1, -1, -1, -1
#else
		.error "Definir un valor entre 1 y 19"
#endif
		.endm

		.macro linea0
#if TEST>= 1 && TEST<=9
		linea
#elif TEST==10
		.int 0, 2, 1, 1

#elif TEST==11
		.int 1, 2, 1, 1

#elif TEST==12
		.int 8, 2, 1, 1

#elif TEST==13
		.int 15, 2, 1, 1

#elif TEST==14
		.int 16, 2, 1, 1

#elif TEST==15
		.int 0, -2, -1, -1

#elif TEST==16
		.int -1, -2, -1, -1

#elif TEST==17
		.int -8, -2, -1, -1

#elif TEST==18
		.int -15, -2, -1, -1

#elif TEST==19
		.int -16, -2, -1, -1

#else
		.error "Definir un valor entre 1 y 19"
#endif
		.endm

lista: 		linea0
longlista:	.int   (.-lista)/4
media:		.int   	0
resto:		.int	0
formato:	.ascii "media \t = %11d \t resto \t = %11d   \n"
			.asciz       "\t = 0x %08x \t    \t = 0x %08x\n"
formatoq:	.ascii "(64 bits)-----------------\n"
			.ascii "media \t = %11d \t resto \t = %11d   \n"
			.asciz       "\t = 0x %08x \t    \t = 0x %08x\n"      "\t = 0x %08x \t    \t = 0x %08x\n"


.section .text
_main: .global _start
 main: .global  main

	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
	call division
	mov  %eax, media
	mov  %edx, resto


	mov   $formato, %rdi
	mov   media,%rsi
	mov   resto,%rdx
	mov	  media, %ecx
	mov	  resto, %r8d
	mov   $0,%eax	
	call  printf		# == printf(formato, res, res);

	mov     $lista, %rbx
	mov  longlista, %ecx
	call sumaq		# == suma(&lista, longlista);
	call divisionq
	mov  %eax, media
	mov  %edx, resto


	mov   $formatoq, %rdi
	mov   media,%rsi
	mov   resto,%rdx
	mov	  media, %ecx
	mov	  resto, %r8d
	mov   $0,%eax	
	call  printf		# == printf(formato, res, res);


	mov  $0, %edi
	call _exit		# ==  exit(resultado)
	ret

suma:
	mov  $0, %eax
	mov  $0, %edx 
	mov  $0, %rsi
	mov	 $0, %ebp
	mov  $0, %edi
bucle:
	mov  (%rbx,%rsi,4), %eax
	cdq	
	add	 %eax, %edi
	adc  %edx, %ebp
	inc   %rsi
	cmp   %rsi,%rcx
	jne    bucle

	mov  %edi, %eax
	mov  %ebp, %edx


	ret

division:
	idiv %ecx
	ret


sumaq:
	mov  $0, %eax
	mov  $0, %edx 
	mov  $0, %rsi
	mov	 $0, %ebp
	mov  $0, %edi
bucleq:
	mov  (%rbx,%rsi,4), %eax
	cdqe
	add   %rax, %rdi
	inc   %rsi
	cmp   %rsi,%rcx
	jne    bucleq

	mov %rdi, %rax
	cqo
	ret

divisionq:
	idiv %rcx
	ret

