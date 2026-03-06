; DIRECTIVAS -  Es una operación orientada al ensamblador que le indica 
;el curso/guia/comportamiento que debe tomar las instrucciones y/o
;ejecución del programa. NO SON EJECUTADAS POR EL CPU. NO GENERAN
;INSTRUCCIONES A NIVEL DE MEMORIA PRINCIPAL

;INSTRUCCIONES - Es una operación orientada a ser ejecutada por el CPU, 
;expresada en con un nombre simbolico. Representa un instrucción de una
;arquitectura que puede ejecutar el CPU.

;LABEL - Es una nombre simbolico para un bloque de código, que describe un 
;lugar en programa más facil que la dirección de memoria. _, ., ? son suados
;como simbolos de inicio de la etiqueta.

ORG 0 ;Permite especificar la dirección origen donde NASM asume que el programa inicio.
;desde ahí pudes dirigir el movimiento del programa. Hace independiente el código de donde
;fue cargado en memoria. Puede ayudar a identificar la zona donde esta la instruccion del inicio
;del archivo
BITS 16 ;Especifica si NASM debe generar código generado para correr en una arquitectura
;de procesador 16,32 y 64 bits.
; --------- Formato inicial exigido por el BIOS (https://wiki.osdev.org/index.php?title=FAT#Boot_Record) ---------
;Punto de entrada del programa
;Label representa la dirección de memoria de una instrucción o datos
_start:
;jmp transfiere el control del programa a una ubicación especifica en el codigo
;pudiendo ser una dirección de memoria, una label, un registro. Modificando
;el program counter
jmp short start; 2 bytes - El Opcode de JMP mide 8 bits, su operando mide 8 -EXIGIDO POR LA BIOS
nop; 1 byte -EXIGIDO POR LA BIOS
;NoOperation: Intrucción que le indica que el CPU no haga ninguna
;operación por un ciclo. Usado para llenar con espacio la secuencia
;de instrucciones

times 33 nop ; Espacio para el BCP (BIOS CONTROL BLOCK)
;prefijo times que ensambla n veces una instrucción, dejando ese espacio
;vacio. En este caso con la instrucción NoOperation

;Label representa la dirección de memoria de una instrucción o datos
start:
jmp 0x07C0:main; Ajusta el CS (CODE SEGMENT) a 0x07C0
;Salta al label main. coloca el CS en 0x07C0. IP a main

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
push cs ;Envia el valor de CODE SEGMENT al STACK
pop ds ;Saca el valor del stack y lo COLOCA A DATA SEGMENT

push cs ;Envia el valor de CODE SEGMENT al STACK
pop es ;Saca el valor del stack y lo COLOCA A EXTERNAL SEGMENT

cld ;Clear Direction Flag - Determina como un conjunto de bits seran movidos
;de un lugar en la memoria a otro. Causando que SOURCE INDEX Y DESTINAITION
;INDEX aumenten incrementalmente

mov si, msg ; offset de msg en SOURCE INDEX (registro para operaciones en cadena)

.print:
;Load Single Byte: Toma el contenido de la dirección de memoria apuntada por el
;registro Data Segment y Source Index. Y lo coloca en AL
    lodsb
    test al, al ; Operacion AND entre al y al guardando las flags de la ALU
    ;Jump If Zero: Evalua la bandera Zero Flag, si contine 1, salta a .done
    jz .done ; Si Zero Flag contiene 1, salta a done

mov ah, 0x0E ; Función 0x0E de la INT 10h: "Teletype Output"
int 0x10 ; Llamada a la interrupción de video del BIOS
jmp .print ; Repite para el siguiente carácter - "Brinca a label .print"

.done:
    hlt ; Detiene la ejecucion y pone el CPU en estado inactivo de bajo consumo


; ------ Data ------
;Define Byte (db): Define un espacio en memoria para almacenas datos | 1 Byte - 8 bits
;Interpreta todo lo que sigue como secuencia de Bytes. 0 -> EOL: End Of Line, define
;el fin de la cadena para mostrarla en pantalla
msg: db 'Hola Mundo :D', 0

;Estructura de MBR - 512 B
; Se ha llenado tantos B, necesito solo 510 B
;$ - Dirección actual de la instrucción
;$$ - Devuelve la dirección de inicio
;A la pocisión actual restarle la pocición inicial. Luego restarle a 510 ese valor
;Resultando en un valor M, El resultado rellenarlo de 0 (Ceros)
;Ensamblando M veces con cero. Es a nivel de código
times 510-($-$$) db 0
;Define Word (dw): Define un espacio en memoria para almacenas datos | 2 Byte - 16 bits
;Interpreta todo lo que sigue como secuencia de Word. 0 -> EOL: End Of Line, define
;el fin de la cadena para mostrarla en pantalla
dw 0xAA55