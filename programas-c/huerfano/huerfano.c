#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    pid_t pid = fork();
    int contador = 1;
    if(pid == 0){
        printf("Inicio proceso zombie PID: %d\n",getpid());
        sleep(10);
    }else{
            printf("Inicio proceso padre PID: %d\n", getpid());
            exit(0);
    }
    return 0;
}