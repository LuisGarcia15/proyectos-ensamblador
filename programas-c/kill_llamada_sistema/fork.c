#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/types.h>

int main(){
    pid_t pid = fork();
    if(pid == 0){
	printf("HIJO - Inicio proceso hijo. PID: %d\n", getpid());
   	printf("HIJO - Retorno de Fork a hijo.  PID: %d\n", pid); 
	printf("HIJO - Matando al proceso padre PPID: %d\n",getppid());
        sleep(5);
	kill(getppid(), 9);
	sleep(10);
   }else{
        printf("PADRE - Inicio proceso padre. PID: %d\n", getpid());
        printf("PADRE - Retorno de Fork a padre. PID: %d\n", pid);
	sleep(10);
    }
    exit(1);
    return 0;
}
