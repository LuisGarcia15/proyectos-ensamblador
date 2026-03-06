ORG 0
BITS 16

; --------- Formato inicial exigido por el BIOS ---------
_start:
    jmp short start
    nop

    times 33 nop ; Espacio para el BCP

start:
    jmp 0x07C0:main

main:
    cli 
    mov [boot_drive], dl    ; Guardamos el valor de la unidad inmediatamente
    
    ; Imprimimos el valor de la unidad detectada
    mov al, [boot_drive]
    call print_hex

    ; Preparar lectura de sector
    mov ah, 0x02            ; Función: leer sectores
    mov al, 0x01            ; Cantidad a leer
    mov ch, 0x00            ; Cilindro
    mov dh, 0x00            ; Cabeza
    mov cl, 0x02            ; Sector 2
    mov dl, [boot_drive]    ; Restauramos el ID guardado
    
    mov bx, 0x1000          
    mov es, bx
    mov bx, 0x0000          ; Destino 0x1000:0000
    int 0x13                ; Llamada al BIOS

    ; Verificación de error
    jc .error_handler       ; Si CF=1, hubo un error

    mov si, msg_success
    jmp .print_setup

.error_handler:
    mov si, msg_error

.print_setup:
    ; Configurar segmentos para imprimir los mensajes
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov ax, 0x07C0
    mov ds, ax              ; DS apunta a nuestro código para leer los mensajes

.print_loop:
    lodsb
    test al, al 
    jz .done 
    mov ah, 0x0E 
    int 0x10 
    jmp .print_loop 

.done:
    hlt 

; --- Rutina para imprimir hex ---
print_hex:
    push ax
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
    jl .num
    add al, 7
.num:
    add al, '0'
    mov ah, 0x0E
    int 0x10
    ret

; --- Datos ---
boot_drive: db 0
msg_success db ' - Lectura exitosa!', 0
msg_error   db ' - Error de lectura!', 0

; ------ Firma Boot Loader ------
times 510-($-$$) db 0
dw 0xAA55