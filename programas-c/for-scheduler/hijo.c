#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    int contador = 1;
    while(contador <= 1000){
        printf("Inicio proceso hijo %d PID: %d\n", contador, getpid());
        contador++;
    }
    exit(0);
    return 0;
}