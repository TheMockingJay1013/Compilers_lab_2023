	.file	"code.c"							# source file name 
	.text										
	.globl	calculateFrequency					# calculateFrequency is a global name
	.type	calculateFrequency, @function		# calculateFrequency is a function
calculateFrequency:								# calculateFrequency starts
.LFB0:
	.cfi_startproc								# Call frame information to unwind stack frames for debugging and exception handling
	endbr64										# helps the hardware CET mechanisms track the control flow of the function
	pushq	%rbp								# Save old base pointer
	.cfi_def_cfa_offset 16						# offsets CFA from current stack pointer by 16 bytes
	.cfi_offset 6, -16							# aids debugging of code
	movq	%rsp, %rbp							# Set new base pointer
	.cfi_def_cfa_register 6						# aids debugging of code
	movq	%rdi, -24(%rbp)						# load the value stored in rdi to (rbp - 24) [arr1 head]
	movl	%esi, -28(%rbp)						# load the value stored in esi to (rbp - 28) [arr1 size -n]
	movq	%rdx, -40(%rbp)						# load the value stored in rdx to (rbp - 40) [freq head]
	movl	$0, -12(%rbp)						# load 0 to (rbp - 12) [i = 0]
	jmp	.L2										# jump to L2
.L7:
	movl	$1, -4(%rbp)						# load 1 to (rbp - 4) [ctr = 1]
	movl	-12(%rbp), %eax						# load the value stored in (rbp - 12) to eax [i]
	addl	$1, %eax							# add 1 to eax [i + 1]
	movl	%eax, -8(%rbp)						# store eax to (rbp - 8) [j = i + 1]
	jmp	.L3										# jump to L3
.L5:
	movl	-12(%rbp), %eax						# load the value stored in (rbp - 12) to eax [i]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rdx					# load (rax * 4) to rdx
	movq	-24(%rbp), %rax						# load the value stored in (rbp - 24) to rax [arr1 head]
	addq	%rdx, %rax							# add rdx to rax [arr1 head + (i * 4)]
	movl	(%rax), %edx						# load the value stored in (rax) to edx [arr1[i]]
	movl	-8(%rbp), %eax						# load the value stored in (rbp - 8) to eax [j]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rcx					# load (rax * 4) to rcx
	movq	-24(%rbp), %rax						# load the value stored in (rbp - 24) to rax [arr1 head]
	addq	%rcx, %rax							# add rcx to rax [arr1 head + (j * 4)]
	movl	(%rax), %eax						# load the value stored in (rax) to eax [arr1[j]]
	cmpl	%eax, %edx							# compare eax with edx [arr1[i] with arr1[j]]
	jne	.L4										# if arr1[i] != arr1[j], jump to L4
	addl	$1, -4(%rbp)						# else add 1 to (rbp - 4) [ctr++]
	movl	-8(%rbp), %eax						# load the value stored in (rbp - 8) to eax [j]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rdx					# load (rax * 4) to rdx
	movq	-40(%rbp), %rax						# load the value stored in (rbp - 40) to rax [freq head]
	addq	%rdx, %rax							# add rdx to rax [freq head + (j * 4)]
	movl	$0, (%rax)							# store 0 to (rax) [freq[j] = 0]
.L4:
	addl	$1, -8(%rbp)						# add 1 to (rbp - 8) [j++]
.L3:
	movl	-8(%rbp), %eax						# load the value stored in (rbp - 8) to eax [j]
	cmpl	-28(%rbp), %eax						# compare eax with (rbp - 28) [compare j with n]
	jl	.L5										# if j < n, jump to L5
	movl	-12(%rbp), %eax						# load the value stored in (rbp - 12) to eax [i]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rdx					# load (rax * 4) to rdx
	movq	-40(%rbp), %rax						# load the value stored in (rbp - 40) to rax [freq head]
	addq	%rdx, %rax							# add rdx to rax [freq head + (i * 4)]
	movl	(%rax), %eax						# load the value stored in (rax) to eax [freq[i]]
	testl	%eax, %eax							# test eax with eax [check if freq[i] == 0]
	je	.L6										# if freq[i] == 0, jump to L6
	movl	-12(%rbp), %eax						# else load the value stored in (rbp - 12) to eax [i]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rdx					# load (rax * 4) to rdx
	movq	-40(%rbp), %rax						# load the value stored in (rbp - 40) to rax [freq head]
	addq	%rax, %rdx							# add rax to rdx [freq head + (i * 4)]
	movl	-4(%rbp), %eax						# load the value stored in (rbp - 4) to eax [ctr]
	movl	%eax, (%rdx)						# store eax to (rdx) [freq[i] = ctr]
.L6:
	addl	$1, -12(%rbp)						# add 1 to (rbp - 12) [i++]
.L2:
	movl	-12(%rbp), %eax							# load the value stored in (rbp - 12) to eax
	cmpl	-28(%rbp), %eax							# compare eax with (rbp - 28) [compare i with n]
	jl	.L7											# if i < n, jump to L7
	nop												# no operation
	nop												# no operation
	popq	%rbp									# restore old base pointer
	.cfi_def_cfa 7, 8								
	ret												# return
	.cfi_endproc									
.LFE0:
	.size	calculateFrequency, .-calculateFrequency
	.section	.rodata
.LC0:											# label for printf in printArrayWithFrequency
	.string	"Element\tFrequency"
.LC1:											# label for printf in printArrayWithFrequency
	.string	"%d\t%d\n"
	.text										# start of text section
	.globl	printArrayWithFrequency				# global declaration of printArrayWithFrequency
	.type	printArrayWithFrequency, @function	# printArrayWithFrequency is a function
printArrayWithFrequency:
.LFB1:
	.cfi_startproc								# start of procedure
	endbr64										# helps the hardware CET mechanisms track the control flow of the function
	pushq	%rbp								# save base pointer
	.cfi_def_cfa_offset 16						# define offset
	.cfi_offset 6, -16							# aids debugging of code
	movq	%rsp, %rbp							# set new base pointer
	.cfi_def_cfa_register 6						# aids debugging of code
	subq	$48, %rsp							# allocate space for local variables
	movq	%rdi, -24(%rbp)						# store the value of rdi to (rbp - 24) [arr]
	movq	%rsi, -32(%rbp)						# store the value of rsi to (rbp - 32) [freq head]
	movl	%edx, -36(%rbp)						# store the value of edx to (rbp - 36) [n]
	leaq	.LC0(%rip), %rdi					# load the address of LC0 to rdi
	call	puts@PLT							# call puts to print LC0
	movl	$0, -4(%rbp)						# store 0 to (rbp - 4) [i = 0]
	jmp	.L9										# jump to L9
.L11:
	movl	-4(%rbp), %eax						# load the value stored in (rbp - 4) to eax [i]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rdx					# load (rax * 4) to rdx
	movq	-32(%rbp), %rax						# load the value stored in (rbp - 32) to rax [freq head]
	addq	%rdx, %rax							# add rdx to rax [freq head + (i * 4)]
	movl	(%rax), %eax						# load the value stored in (rax) to eax [freq[i]]
	testl	%eax, %eax							# test eax with eax [check if freq[i] == 0]
	je	.L10									# if freq[i] == 0, jump to L10
	movl	-4(%rbp), %eax						# load the value stored in (rbp - 4) to eax [i]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rdx					# load (rax * 4) to rdx
	movq	-32(%rbp), %rax						# load the value stored in (rbp - 32) to rax [freq head]
	addq	%rdx, %rax							# add rdx to rax [freq head + (i * 4)]
	movl	(%rax), %edx						# load the value stored in (rax) to edx [freq[i]]
	movl	-4(%rbp), %eax						# load the value stored in (rbp - 4) to eax [i]
	cltq										# Sign extend eax to rax
	leaq	0(,%rax,4), %rcx					# load (rax * 4) to rcx
	movq	-24(%rbp), %rax						# load the value stored in (rbp - 24) to rax [arr]
	addq	%rcx, %rax							# add rcx to rax [arr + (i * 4)]
	movl	(%rax), %eax						# load the value stored in (rax) to eax [arr[i]]
	movl	%eax, %esi							# store eax to esi [second label for printf]
	leaq	.LC1(%rip), %rdi					# load the address of LC1 to rdi
	movl	$0, %eax							# store 0 to eax
	call	printf@PLT							# call printf to print LC1
.L10:
	addl	$1, -4(%rbp)						# add 1 to (rbp - 4) [i++]
.L9:
	movl	-4(%rbp), %eax						# load the value stored in (rbp - 4) to eax [i]
	cmpl	-36(%rbp), %eax						# compare eax with (rbp - 36) [compare i with n]
	jl	.L11									# if i < n, jump to L11
	nop											# no operation
	nop											# no operation
	leave										# restore old base pointer
	.cfi_def_cfa 7, 8
	ret											# return
	.cfi_endproc
.LFE1:
	.size	printArrayWithFrequency, .-printArrayWithFrequency		
	.section	.rodata
	.align 8
.LC2:										# label for f-string 1st-printf
	.string	"\n\nCount frequency of each integer element of an array:"
	.align 8								# align with 8-byte boundary
.LC3:										# label for f-string 2nd printf
	.string	"------------------------------------------------"
	.align 8								# align with 8 byte boundary
.LC4:										# label for f-string 3rd printf
	.string	"Input the number of elements to be stored in the array :"
.LC5:										# label for f-string 1st scanf
	.string	"%d"
	.align 8								# align with 8 byte boundary
.LC6:										# label for f-string 4th printf
	.string	"Enter each elements separated by space: "
	.text									
	.globl	main							# main is a global name
	.type	main, @function					# main is a function 
main:										# main starts
.LFB2:
	.cfi_startproc							# Call Frame information
	endbr64									# helps the hardware CET mechanisms track the control flow of the function
	pushq	%rbp							# Save old base pointer
	.cfi_def_cfa_offset 16					# offsets CFA from current stack pointer by 16 bytes
	.cfi_offset 6, -16						# aids debugging of code
	movq	%rsp, %rbp						# setting new stack base pointer
	.cfi_def_cfa_register 6					# aids debugging of code
	movq	%fs:40, %rax					# loading value in a Thread local storage into rax
	subq	$832, %rsp						# allocate 832 bytes of space on the stack 
	movq	%rax, -8(%rbp)					# (rbp-8) <-- rax 
	xorl	%eax, %eax						# eax <-- 0
	leaq	.LC2(%rip), %rdi				# loads the address of .LC2 and stores in rdi
	call	puts@PLT						# prints 1st string to stdout
	leaq	.LC3(%rip), %rdi				# loads string 2 address to rdi 
	call	puts@PLT						# prints 2nd string to stdout
	leaq	.LC4(%rip), %rdi				# loads string 3 address to rdi
	movl	$0, %eax						# eax <-- 0
	call	printf@PLT						# prints 3rd string to stdout
	leaq	-828(%rbp), %rax				# loads (rbp - 828) to rax
	movq	%rax, %rsi						# move the address in rax to rsi to input n
	leaq	.LC5(%rip), %rdi				# load address of the %d string to rdi
	movl	$0, %eax						# eax <-- 0
	call	__isoc99_scanf@PLT				# scan the input using the parameters rdi and rsi
	leaq	.LC6(%rip), %rdi				# load string 4 address to rdi
	movl	$0, %eax						# eax <-- 0
	call	printf@PLT						# prints the 4th string to stdout
	movl	$0, -824(%rbp)					# put 0 in the address (rbp - 824)
	jmp	.L13								# branch to .L13
.L14:
	leaq	-816(%rbp), %rax				# load the address of (rbp - 816) in rax
	movl	-824(%rbp), %edx				# load the value in (rbp - 824) in edx
	movslq	%edx, %rdx						# store 32 bit value in 64 bit rdx
	salq	$2, %rdx						# perform a 2 bit left shift on the value in rdx
	addq	%rdx, %rax						# add 4 to the address stored in rax [moving to next element in arr1]
	movq	%rax, %rsi						# store the address in rax into rsi [address for input buffer]
	leaq	.LC5(%rip), %rdi				# load address of %d string to rdi
	movl	$0, %eax						# eax <-- 0
	call	__isoc99_scanf@PLT				# scanf arr1 element from stdin
	addl	$1, -824(%rbp)					# add 1 to (rbp - 824) [incrementing value of i]
.L13:
	movl	-828(%rbp), %eax				# load value of n in ( bsp - 824) in eax
	cmpl	%eax, -824(%rbp)				# compare eax [n] and value in (rbp -824) [i] 
	jl	.L14								# branch to .L4 if value in eax is greater [i<n]
	movl	$0, -820(%rbp)					# if not put 0 in (rbp - 820) [j]
	jmp	.L15								# then branch to .L15
.L16:
	movl	-820(%rbp), %eax				# load value in (rbp - 820) in eax 
	cltq									# Sign extend eax to rax
	movl	$-1, -416(%rbp,%rax,4)			# put -1 in (rbp - 416 + 4*rax) [putting -1 in freq[j]]
	addl	$1, -820(%rbp)					# add 1 to (rbp - 820) [incrementing j]
.L15:
	movl	-828(%rbp), %eax				# load (rbp - 820) in eax [ loading n in eax]
	cmpl	%eax, -820(%rbp)				# compare eax with (rbp - 820) [check j<n]
	jl	.L16								# jump to .L16 [if j<n]
	movl	-828(%rbp), %ecx				# else case : load (rbp - 828) to ecx [load n]
	leaq	-416(%rbp), %rdx				# load address of (rbp - 416) to rdx [loading freq arr head to rdx]
	leaq	-816(%rbp), %rax				# load address of (rbp - 816) to rax [loading arr1 head to rax]
	movl	%ecx, %esi						# put value in ecx in esi [n]
	movq	%rax, %rdi						# put value in rax in rdi
	call	calculateFrequency				# make function call to calculateFrequency
	movl	-828(%rbp), %edx				# load (rbp - 828) to edx [n]
	leaq	-416(%rbp), %rcx				# load address of (rbp - 416) to rcx [loading freq head to rcx]
	leaq	-816(%rbp), %rax				# load address of (rbp - 816) to rax [loading arr1 head to rax]
	movq	%rcx, %rsi						# load value in rcx to rsi [freq]
	movq	%rax, %rdi						# load value in rdi to rdi [arr1]
	call	printArrayWithFrequency			# make function call to printArrayWithFrequency
	movl	$0, %eax						# eax <-- 0
	movq	-8(%rbp), %rcx					# load the value in (rpb - 8) to rcx
	xorq	%fs:40, %rcx					# 
	je	.L18								# if equal branch to .L18
	call	__stack_chk_fail@PLT
.L18:		
	leave									# clearn up the stack frame
	.cfi_def_cfa 7, 8						
	ret										# return from main
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
