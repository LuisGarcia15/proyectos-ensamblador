ORG 0
BITS 16
; --------- Formato inicial exigido por el BIOS (https://wiki.osdev.org/index.php?title=FAT#Boot_Record) ---------
_start:
jmp short start; 2 bytes
nop; 1 byte

times 33 nop ; Espacio para el BCP (Bios Control Block)

start:
jmp 0x07C0:main; Ajusta el CS (Code Segment) a 0x07C0

main:
cli ; Clear Interrupts

xor ax, ax ; Get 0
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

mov si, msg ; offset de msg en Source Index (registro para operaciones en cadena)

.print:
lodsb
test al, al ; Operacion AND entre al y al guardando las flags de la ALU
jz .done ; Si ZF contiene 1, salta a done

mov ah, 0x0E ; Función 0x0E de la INT 10h: "Teletype Output"
int 0x10 ; Llamada a la interrupción de video del BIOS
jmp .print ; Repite para el siguiente carácter
.done:
hlt ; Detiene la ejecucion y pone el CPU en estado inactivo de bajo consumo


; ------ Data ------
msg: db 'Hola Mundo :D', 0

times 510-($-$$) db 0
dw 0xAA55