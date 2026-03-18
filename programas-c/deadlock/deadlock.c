#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

char recurso_A[50] = "Recurso A - Sin utilizar";
char recurso_B[50] = "Recurso B - Sin utilizar";
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *uso_recurso_ab(void *arg){
 pthread_mutex_lock(&mutex);
 printf("%s\n", recurso_A);
 strcpy(recurso_A, "Recurso A - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_A, pthread_self());
 sleep(1);
 printf("Intentando tomar Recurso B por Hilo con ID: %i\n", pthread_self());
 pthread_mutex_lock(&mutex);
 strcpy(recurso_B, "Recurso B - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_B, pthread_self());
 sleep(1);
 pthread_exit(NULL);
}

void *uso_recurso_ba(void *arg){
 pthread_mutex_trylock(&mutex);
 printf("%s\n", recurso_B);
 strcpy(recurso_B, "Recurso B - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_B, pthread_self());
 sleep(1);
 printf("Intentando tomar Recurso A por Hilo con ID: %i\n", pthread_self());
 pthread_mutex_lock(&mutex);
 strcpy(recurso_A, "Recurso A - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_A, pthread_self());
 sleep(1);
 pthread_exit(NULL);
}

int main(){
    pthread_t id_hilo_uno;
    pthread_t id_hilo_dos;
    pthread_create(&id_hilo_uno,NULL,uso_recurso_ab,NULL);
    pthread_create(&id_hilo_dos,NULL,uso_recurso_ba,NULL);

    pthread_join(id_hilo_uno, NULL);
    pthread_join(id_hilo_dos, NULL);
    return 0;
}
