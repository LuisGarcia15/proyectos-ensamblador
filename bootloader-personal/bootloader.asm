ORG 0
BITS 16

_start:
jmp short start
nop

times 33 nop

start:
jmp 0x07C0:main

main:
cli
mov [boot_drive], dl

; imprimir unidad de arranque
mov al, [boot_drive]
call print_hex

; ---- leer sector 2 ----
mov cx, 0x1000
mov ah, 0x02
mov al, 0x01
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
mov dl, [boot_drive]

mov es, cx
mov bx, 0x0000
int 0x13

jc .error_handler
mov si, msg_success
jmp .print_setup

.error_handler:
mov si, msg_error

.print_setup:

; DS debe apuntar al mismo segmento del código
push cs
pop ds

cld

.print:
lodsb
test al, al
jz .done

mov ah, 0x0E
int 0x10
jmp .print

.done:
hlt

; --- imprimir byte en hex ---
print_hex:
push ax
push ax
shr al,4
call .nibble
pop ax
call .nibble
pop ax
ret

.nibble:
and al,0x0F
cmp al,10
jl .num
add al,7
.num:
add al,'0'
mov ah,0x0E
int 0x10
ret

boot_drive db 0
msg_success db ' - Lectura exitosa!',0
msg_error   db ' - Error de lectura!',0

times 510-($-$$) db 0
dw 0xAA55