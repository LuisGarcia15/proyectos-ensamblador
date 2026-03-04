#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    int contador = 1;
    while(contador <= 10){
   contador++;
    pid_t pid = fork();
    if(pid == 0){
       execl("./ciclo-fork-huerfano", "ciclo-fork-huerfano", (char*)NULL);
     }
    }
    exit(0);
    return 0;
}
