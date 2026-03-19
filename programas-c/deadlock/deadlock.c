#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

//Recursos compartidos entre Hilos
char recurso_A[50] = "Recurso A - Sin utilizar";
char recurso_B[50] = "Recurso B - Sin utilizar";
//Declaracion de MUTEX de forma estatica - Existen dos formas
//de inicizializar
pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex2 = PTHREAD_MUTEX_INITIALIZER;

void *uso_recurso_ab(void *arg){
 //Bloqueo para el recurso A
 //Bloquea el MUTEX por el hilo que lo llama. Cambia su estado
 //de libre a ocupado
 pthread_mutex_lock(&mutex1);
 printf("%s\n", recurso_A);
 strcpy(recurso_A, "Recurso A - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_A, pthread_self());
 sleep(1);
 printf("Intentando tomar Recurso B por Hilo con ID: %i\n", pthread_self());
 //Bloqueo para el recurso A
 //Bloquea el MUTEX por el hilo que lo llama. Cambia su estado 
 //de libre a ocupado
 pthread_mutex_lock(&mutex2);
 //Copia una cadena de caracteres desde un destino a un final strcpy(Destino, Origen)
 strcpy(recurso_B, "Recurso B - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_B, pthread_self());
 sleep(1);
 //Funcion que termina un hilo que ejecuta la funcion y devuelve un valor
 //a travez de retval
 pthread_exit(NULL);
}

void *uso_recurso_ba(void *arg){
 //Intento de bloqueo para uso de recurso B
 //Intenta bloquear  el MUTEX por el hilo que lo llama, de no poder 
 //realizarlo, retorna un codigo de error
 pthread_mutex_lock(&mutex2);
 printf("%s\n", recurso_B);
 strcpy(recurso_B, "Recurso B - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_B, pthread_self());
 sleep(1);
 printf("Intentando tomar Recurso A por Hilo con ID: %i\n", pthread_self());
 //Intento de bloqueo para uso de recurso A 
 //Bloqua el MUTEX por el hilo que lo llama. Cambia su estado
 //de libre a ocupado
 pthread_mutex_lock(&mutex1);
 //Copia una cadena de caracteres desde un destino a un final strcpy(Destino, Origen)  
 strcpy(recurso_A, "Recurso A - Bloqueado por Hilo con ID:");
 printf("%s %i\n", recurso_A, pthread_self());
 sleep(1);
 //Funcion que termina un hilo que ejecuta la funcion y devulve un valor
 //a travez de retval
 pthread_exit(NULL);
}

int main(){
   //Variables para almacenar el ID de hilo de los hilos creados
    pthread_t id_hilo_uno;
    pthread_t id_hilo_dos;
   //Creacion de hilos (var para almacenar id hilo, Estructuras de datos para
   //que el hilo pueda usarlas, funcion que ejecuta el hilo, parametros para
   //el uso de la funcion que se le pasa como parametro)
    pthread_create(&id_hilo_uno,NULL,uso_recurso_ab,NULL);
    pthread_create(&id_hilo_dos,NULL,uso_recurso_ba,NULL);
   //Funcion que espera la finalizacion de hilos por el proceso.
   //Recibe el id del Hilo que debe esperar a finalizar
   //Si tiene exito, retorna 0, sino un numero de error
   //Si retval de pthread_exit() no es NULL, recupera el valor
    pthread_join(id_hilo_uno, NULL);
    pthread_join(id_hilo_dos, NULL);
    return 0;
}
