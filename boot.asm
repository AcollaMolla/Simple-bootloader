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
	cmp al, 27
	call esc_pressed
	mov ah, 0xe
	int 0x10
jmp read_and_display

esc_pressed
	ret

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

msg: db 'Welcome to my bootloader! OS will boot soon...'

MSGLEN: EQU ($ - msg)

msg2: db 'Beep!'

msg2_len: EQU ($-msg2)

padding: times (510 - ($ - $$)) db 0

BOOT_SIGN: db 0x55, 0xaa
