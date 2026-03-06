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
int 0x13            ;llamada a int 13

xor ax, ax ; Get 0
mov es, ax ;ES to 0
mov ds, ax ; Reset data segment to 0
; mov es, ax ; Reset extra segment (heap) to 0
mov ss, ax ; Reset stack segment to 0
mov sp, 0x7C00 ; Set stack pointer to 0x7C00

; Ajustar inicio del DS a CS
push cs
pop ds

push cs
pop es

cld

mov ax, 0x1000
mov ds, ax          ; Ahora DS = 0x1000
mov si, 0x0000      ; Offset inicial de la data (el comienzo del buffer)

.print:
lodsb
test al, al ; Operacion AND entre al y al guardando las flags de la ALU
jz .done ; Si ZF contiene 1, salta a done

mov ah, 0x0E ; Función 0x0E de la INT 10h: "Teletype Output"
int 0x10 ; Llamada a la interrupción de video del BIOS
jmp .print ; Repite para el siguiente carácter
.done:
hlt ; Detiene la ejecucion y pone el CPU en estado inactivo de bajo consumo


; ------ Firma Boot Loader ------
times 510-($-$$) db 0
dw 0xAA55