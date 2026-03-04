#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    pid_t pid = fork();
    if(pid == 0){
        printf("Inicio proceso hijo. PID: %d\n", getpid());
    }else{
        printf("Inicio proceso padre. PID: %d\n", getpid());
        wait(NULL);
        printf("Proceso hijo finalizado \n");
        printf("Proceso padre finalizado \n");
    }
    exit(1);
    return 0;
}