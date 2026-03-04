#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    pid_t pid = fork();
    int contador = 1;
    if(pid == 0){
        while(contador <= 1000){
            printf("Inicio proceso zombie PID: %d\n",getpid());
            exit(0);
        }    
    }else{
            printf("Inicio proceso padre PID: %d\n", getpid());
            sleep(1000);
    }
    return 0;
}