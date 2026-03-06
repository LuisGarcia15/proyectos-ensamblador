ORG 0
BITS 16
; --------- Formato inicial exigido por el BIOS (https://wiki.osdev.org/index.php?title=FAT#Boot_Record) ---------
_start:
jmp short start; 2 bytes
nop; 1 byte

times 33 nop ; Espacio para el BCP (Bios Control Block)

start:
jmp 0x07C0:main; Ajusta el CS (Code Segment) a 0x07C0, IP a main

main:
cli ; Clear Interrupts

;31 Bytes
xor cx, 0x1000 ; Get 0
mov ah, 0x02        ; Función: para leer sectores
mov al, 0x01           ; Cantidad de sectores a leer
mov ch, 0x00           ; Número de cilindro en chs
mov dh, 0x00           ; Número de cabeza en chs
mov cl, 0x02           ; Número de sector en chs

;ES:BX -> Buffer e Memoria. ES:Segmento BX:Offset
mov es, cx      ; Coloca la dirección del segmento
mov bx, 0x0000      ;Coloca la dirección del offset 
int 0x13            ; Llamada a int 13
    
    ; --- Verificación de error ---
    jc .error_handler   ; Si CF=1, hubo un error

    ; Si llega aquí, fue exitoso
    mov si, msg_success
    jmp .print_setup

.error_handler:
    mov si, msg_error
    jmp .print_setup

.print_setup:
    ; Aseguramos que DS apunte al segmento del código (0x07C0)
    ; para poder leer las cadenas de texto msg_success o msg_error
    mov ax, 0x07C0
    mov ds, ax

.print_loop:
    lodsb               ; Carga byte en AL e incrementa SI
    test al, al         ; ¿Es el fin de la cadena (0)?
    jz .done            ; Si es cero, terminar
    
    mov ah, 0x0E        ; Función BIOS para imprimir carácter
    int 0x10
    jmp .print_loop     ; Siguiente carácter

.done:
    hlt                 ; Detener ejecución

; --- Mensajes (deben estar dentro del sector de 512 bytes) ---
msg_success db 'Lectura exitosa!', 13, 10, 0
msg_error   db 'Error de lectura!', 13, 10, 0

; ------ Firma Boot Loader ------
times 510-($-$$) db 0
dw 0xAA55