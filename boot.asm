mov ax, 0x7c0
mov ds, ax
mov ecx, 10
boot:
	mov cx, MSGLEN
	mov si, msg
	mov ah, 0xe
putchar:
	mov al, [si]
	int 0x10
	inc si
loop putchar

mov ecx, 0x5

beep:
	mov ah, 0xe
	mov al, 0x7
	int 0x10
	call print_hello
	sub ecx, 0x1
	or ecx, ecx
	jnz beep

read_and_display:
	mov ah, 0
	int 0x16
	cmp al, secret_number
	jne wrong_guess
	jmp correct_guess
wrong_guess:
	mov cx, wrong_msg_len
	mov si, wrong_msg
	mov ah, 0xe
print_wrong_guess:
	mov al, [si]
	int 0x10
	inc si
	loop print_wrong_guess
jmp read_and_display

correct_guess:
	pusha
	mov cx, correct_msg_len
	mov si, correct_msg
	mov ah, 0xe
print_correct_guess:
	mov al, [si]
	int 0x10
	inc si
	loop print_correct_guess
	jmp read_and_display

print_hello:
	pusha
	mov cx, msg2_len
	mov si, msg2
	mov ah, 0xe

print_hello_char:
	mov al, [si]
	int 0x10
	inc si
	loop print_hello_char
	popa
	ret

halt:
	jmp $

msg: db 'Welcome to my bootloader! OS will boot soon...Meanwhile, guess the secret number!', 0xa, 0xd

MSGLEN: EQU ($ - msg)

msg2: db 'Beep!', 0xa, 0xd

msg2_len: EQU ($-msg2)

correct_msg: db 'Correct!', 0xa, 0xd

correct_msg_len: EQU ($-correct_msg)

wrong_msg: db 'Wrong!', 0xa, 0xd

wrong_msg_len: EQU ($-wrong_msg)

secret_number: EQU 53

padding: times (510 - ($ - $$)) db 0

BOOT_SIGN: db 0x55, 0xaa
