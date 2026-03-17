#include <stdio.h>
#include <stdlib.h>

void funcion_abort(){
   abort();
}
int main() {
    printf("Programa que con la senal abort genera un core dump.\n");
    funcion_abort();
    printf("Este mensaje nunca se imprimira\n");
    return 0;
}
