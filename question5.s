main:
	ldr sp, =0x10140
	mov r9, #100
	str r9, [sp, #24]
	mov r0, #196
	mov lr, pc
	b SVC_handler
	b .

SVC_handler:
	ldr r10, [sp, #24]
	and r10, r10, #0xff
	cmp r10, #100
	beq SVC_100
	mov pc, lr
SVC_100:
	stmia sp!, {r0, lr}
	mov r6, #0
call:
	add r6, r6, #1
	cmp r6, #11
	beq not_ok
	mov lr, pc
	b algorithm196
	cmp r0, #0
	beq ok
	b call
ok:
	mov r5, #1
	b end
not_ok:
	mov r5, #2
end:
	ldmdb sp!, {r0, pc}


algorithm196:
	stmia sp!, {lr}	// store the link register in order to avoid overriding it
wrapper1:
	mov r1, #0	// counter storing the amount of digits of the input (times 4 in order to faciitate the stack visit)
	mov r2, #10	// constant used later for the division
	stmia sp!, {r0}	// store the input value on the stack in such a way to make available 1 more register
main1:
	mov r3, #0
division_by_10:
	cmp r2, r0
	bgt continue
	add r3, r3, #1
	add r2, r2, #10
	b division_by_10
	//udiv r3, r0, r2	// calculate initial value for the next cycle
continue:
	mov r2, #10
	mul r12, r3, r2	// procedure useful to find the remainder later on
	sub r0, r0, r12	// find the remainder
	stmia sp!, {r0}	// store the remainder in the stack (actual digit of input)
	add r1, r1, #4
	mov r0, r3
	cmp r0, #0
	bne main1
wrapper2:	// r0 -> 0, r1 -> amount of digits, r2 -> 10, r3 -> trash, sp -> remainders]
	sub r0, sp, r1
	sub r3, sp, #4
main2:
	ldr r2, [r0]
	ldr r12, [r3]
	cmp r2, r12
	bne wrapper3
	add r0, r0, #4
	sub r3, r3, #4
	cmp r0, r3
	blo main2
	mov r0, #0
	b find_lr
wrapper3:
	mov r0, #0	// accumulator
	sub r3, sp, r1	// address first remainder
	mov r2, #10
main3:
		ldr r12, [r3]
		mul r0, r0, r2
		add r0, r0, r12
		add r3, r3, #4
		cmp sp, r3
		bgt main3
		sub r1, sp, r1
		sub r1, r1, #4		// r1 contains the address of the original value
		ldr r2, [r1]	// now r2 contains the original value
		add r0, r0, r2
		b clean
find_lr:
		sub r1, sp, r1
		sub r1, r1, #4		// r1 contains the address of the original value
clean:
		ldmdb sp!, {r3}
		cmp sp, r1
		bne clean
		ldmdb sp!, {pc}
