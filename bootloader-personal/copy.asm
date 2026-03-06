ORG 0x7C00      ; Informamos al ensamblador de nuestra dirección de carga
BITS 16

_start:
    jmp short start
    nop

start:
    ; 1. Salvar el ID de unidad pasado por el BIOS
    mov [boot_drive], dl 

    ; 2. Configuración segura de segmentos y pila
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00  ; La pila crece hacia abajo desde el inicio del sector

    ; 3. Preparar la lectura
    mov ah, 0x02        
    mov al, 0x01        ; Leer 1 sector
    mov ch, 0x00        ; Cilindro 0
    mov dh, 0x00        ; Cabeza 0
    mov cl, 0x02        ; Sector 2 (el primer sector es el 1, este bootloader)
    
    mov bx, 0x1000      ; Segmento destino 0x1000
    mov es, bx
    mov bx, 0x0000      ; Offset 0
    
    mov dl, [boot_drive] ; USAR EL ID DE UNIDAD QUE GUARDAMOS
    int 0x13            
    
    jc .error_handler   

    mov si, msg_success
    jmp .print_setup

.error_handler:
    mov si, msg_error

.print_setup:
    ; Nota: Como DS es 0, los mensajes deben estar referenciados 
    ; correctamente. Para simplificar, añadimos el org 0x7C00 al inicio.
    mov ah, 0x0E        
.print_loop:
    lodsb               
    or al, al           
    jz .done            
    int 0x10
    jmp .print_loop     

.done:
    hlt                 
    jmp .done           ; Bucle infinito para evitar ejecución de basura

boot_drive: db 0
msg_success db 'Lectura exitosa!', 13, 10, 0
msg_error   db 'Error de lectura!', 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55