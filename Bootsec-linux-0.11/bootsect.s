SETUPLEN = 4 ! Número de sectores que debe leer de HDD Para las instrucciones de configuración
BOOTSEG = 0x07c0 ! Código de MBR
INITSEG = 0x9000 ! Copia de MBR
SETUPSEG = 0x9020 ! Código de configuración inicia en esta dirección
SYSSEG = 0x1000 ! Kernel de Linux es cargado en esta dirección
ENDSEG = SYSSEG + SYSSIZE ! Frontera donde termina de cargar el Kernel de Linux

//	jmpl	$BOOTSEG, $start2
//Uns instrucción como esa define la primera instrucción. Por eso puede copiar de 0x07C0 a 0x90000

//Bootsect copies itself (total 512 B) from 0x07C00 to 0x90000
! --- Rutina de reubicación del sector de arranque (bootsect.s) ---

mov ax,#BOOTSEG   ! Carga el segmento de origen (0x07C0) en el registro AX
mov ds,ax         ! DS (Data Segment) ahora apunta a donde la BIOS cargó el boot DS:(0x07C0)
mov ax,#INITSEG   ! Carga el segmento de destino (0x9000) en el registro AX
mov es,ax         ! ES (Extra Segment) ahora apunta a la nueva ubicación segura ES:(0x9000)

//DS+SI = 0x07C00 - ORIGEN
//ES+DI = 0x90000 - DESTINO
mov cx,#256       ! Prepara el contador: copiaremos 256 palabras (16 bits c/u)
//CX va restando hasta que sea cero. Entonces termina de copiar el MBR
sub si,si         ! Pone SI en 0. DS:SI ahora es 0x07C0:0000
sub di,di         ! Pone DI en 0. ES:DI ahora es 0x9000:0000
rep               ! Prefijo: repite la siguiente instrucción hasta que CX sea 0
movw              ! Move Word: copia 2 bytes de DS:SI a ES:DI y avanza los punteros
//Apunta a las siguiente instrucción aumentando SI y DI
// Al terminar esto, el sector de arranque está duplicado en 0x90000

jmpi go,INITSEG //CS apunta a 0x9000
go: mov ax,cs //IP apunta a la dirección de go - referencia a memoria AX vale CS
mov ds,ax //Data Segment vale AX 
mov es,ax //Extra Segment vale AX - Para subir los archivos de configuración 

mov ss,ax //Stack Segment Register Vale AX (Base de la Pila)
mov sp,#0xFF00 ! arbitrary value >>512 //Stack Pointer (Fin de la Pila)
! load the setup-sectors directly after the bootblock.
! Note that ‘es’ is already set up.

//code path:boot/bootsect.s
; Ruta: boot/bootsect.s

Load_setup:
//Se usan los registros de proposito especial como parametros para las INT
    mov dx, #0x0000        ; DX = 0x0000
                           ; DH = cabeza 0
                           ; DL = unidad 0 (disco 0, normalmente floppy) - NO se usa en HDD

    mov cx, #0x0002        ; CX = 0x0002
                           ; CH = cilindro 0
                           ; CL = sector 2
                           ; (empieza a leer desde el sector 2)

    mov bx, #0x0200        ; BX = 0x0200
                           ; Dirección de memoria destino (offset 0x0200)

    mov ax, #0x0200+SETUPLEN
                            // Para que al llamar 13INTH vea que función ejecutar || AH = 02h	TODOS	Leer sectores
                            // y cuantos sectores leer
                           ; AH = 0x02 → función 02h de INT 13h (leer sectores)
                           ; AL = SETUPLEN → número de sectores a leer

    int 0x13               ; Llama a la BIOS para leer sectores del disco
                           ; Lee SETUPLEN sectores desde:
                           ; cilindro 0, cabeza 0, sector 2
                           ; y los carga en ES:BX (normalmente 9000:0200) = 9020. Dirección de SetUp

    jnc load_setup         ; Si NO hay error (CF=0), salta a load_setup
                           ; Si hay error, continúa (para manejo de error)

Ok_load_setup: