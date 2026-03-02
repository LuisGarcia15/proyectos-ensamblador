; DIRECTIVAS
ORG 0 ;Permite especificar la dirección origen donde NASM asume que el programa inicio.
;desde ahí pudes dirigir el movimiento del programa.
BITS 16 ;Especifica si NASM debe generar código generado para correr en una arquitectura
;de procesador 16,32 y 64 bits.
; --------- Formato inicial exigido por el BIOS (https://wiki.osdev.org/index.php?title=FAT#Boot_Record) ---------
;Punto de entrada del programa
;Label representa la dirección de memoria de una instrucción o datos
_start:
;jmp transfiere el control del programa a una ubicación especifica en el codigo
;pudiendo ser una dirección de memoria, una label, un registro. Modificando
;el program counter
jmp short start; 2 bytes
nop; 1 byte 
;NoOperation: Intrucción que le indica que el CPU no haga ninguna
;operación por un ciclo. Usado para llenar con espacio la secuencia
;de instrucciones

times 33 nop ; Espacio para el BCP (BIOS CONTROL BLOCK)
;prefijo times que ensambla n veces una instrucción, dejando ese espacio
;vacio. En este caso con la instrucción NoOperation

;Label representa la dirección de memoria de una instrucción o datos
start:
jmp 0x07C0:main; Ajusta el CS (CODE SEGMENT) a 0x07C0
;Salta al label main. coloca el CS en 0x07C0

;Label representa la dirección de memoria de una instrucción o datos
main:
cli ; Clear Interrupts - Limpia la bandera de interrupciones - Ignorando
;las interrupciones maskable. Coloca en 0

xor ax, ax ; Get 0 - Evalua el valor de AX consigo mismo en una operación XOR
;Obteniendo un valor cero en el registro AX

mov ds, ax ; Reset DATA SEGMENT to 0 - Muevele el valor de AX (Cero) a DATA SEGMENT

; mov es, ax ; Reset EXTRA SEGMENT (heap) to 0

mov ss, ax ; Reset STACK SEGMENT to 0

mov sp, 0x7C00 ; Set STACK POINTER to 0x7C00

;Ajustar inicio del DATA SEGMENT a CODE SEGMENT
push cs
pop ds

push cs
pop es

cld ;Clear Direction Flag - Determina como un conjunto de bits seran movidos
;de un lugar en la memoria a otro. CausandO que SOURCE INDEX Y DESTINAITION
;INDEX aumenten incrementalmente

mov si, msg ; offset de msg en SOURCE INDEX (registro para operaciones en cadena)

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