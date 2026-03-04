#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    int conteo = 1;
    printf("Inicio proceso padre. PID: %d\n", getpid());
    while(conteo <= 100){
        pid_t pid = fork();
        if(pid == 0){
            printf("Inicio proceso hijo %d - PID: %d\n", conteo ,getpid());
        }
        conteo++;
    }
    return 0;
}