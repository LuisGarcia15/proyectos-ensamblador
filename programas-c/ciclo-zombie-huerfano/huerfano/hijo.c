#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
    printf("Inicio proceso hijo PID: %d\n",  getpid());
    sleep(1000);
    return 0;
}
