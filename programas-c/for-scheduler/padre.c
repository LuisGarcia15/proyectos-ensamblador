#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    pid_t pid = fork();
    int contador = 1;
    if(pid == 0){
       execl("./ciclo-fork-hijo", "ciclo-fork-hijo", (char*)NULL);
    }else{
        while(contador <= 1000){
            printf("Inicio proceso padre %d PID: %d\n", contador,getpid());
            contador++;
        }
    }
    return 0;
}