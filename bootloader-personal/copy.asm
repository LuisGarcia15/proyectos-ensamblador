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
; --- CAPTURAR DL AQUÍ ---
mov [boot_drive], dl ; Guardamos el valor inicial de DL

; --- IMPRIMIR DL ---
mov al, [boot_drive]
call print_hex

; (Resto de tu código...)
mov ah, 0x02        
mov al, 0x01           
mov ch, 0x00           
mov dh, 0x00           
mov cl, 0x02           

xor cx, 0x1000 
mov es, cx      
mov bx, 0x0000      
mov dl, [boot_drive] ; Usamos el valor capturado
int 0x13            

; --- (Tu lógica de mensajes) ---
jc .error_handler   
    mov si, msg_success
    jmp .print_setup

.error_handler:
    mov si, msg_error
    jmp .print_setup

.print_setup:
    ; ... (Tu lógica de impresión existente) ...

; --- RUTINA HEX (Nueva) ---
print_hex:
    push ax
    mov ah, 0x0E
    push ax
    shr al, 4
    call .nibble
    pop ax
    call .nibble
    pop ax
    ret
.nibble:
    and al, 0x0F
    cmp al, 10
    jl .digit
    add al, 7
.digit:
    add al, '0'
    int 0x10
    ret

boot_drive: db 0
msg_success db ' - Lectura exitosa!', 0
msg_error   db ' - Error de lectura!', 0

; ... (El resto de tu código de impresión sigue igual)