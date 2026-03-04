#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    int conteo = 1;
    printf("Inicio proceso padre. PID: %d\n", getpid());
    while(1){
        pid_t pid = fork();
        if(pid == 0){
            printf("Inicio proceso hijo %d - PID: %d\n", conteo ,getpid());
           sleep(1000);
        }
        conteo++;
    }
    return 0;
}
