#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <arpa/inet.h>

int main(){
    //ip de maquina a entablar comunicacion
    char ip[13] = "192.168.64.11";
    //Atributos del socket
    struct sockaddr_in estructura_socket;
    estructura_socket.sin_family = AF_INET;
    estructura_socket.sin_port = htons(6000);
    int opt = 1;

   //Crea un endpoint para una comunicación de red. Retorna el File
   //Descriptor del socket, -1 si hubo un error
   int fd_socket = socket(AF_INET, SOCK_STREAM, 0);
   if(fd_socket < 0){
        printf("Error al crear el socket %d\n", fd_socket);
   }else{
        printf("Socket creado con exito %d\n", fd_socket);
   }

    setsockopt(fd_socket, SOL_SOCKET,
                  SO_REUSEADDR | SO_REUSEPORT, &opt,
                   sizeof(opt));

   //Transforma una direccion IPv4 a formato binario y lo
   //almacena en la direccion de memoria del segundo parametro
   //&: Puntero a la direccion donde se encuentra in_addr
   //if (inet_aton(ip,&estructura_socket.sin_addr) < 0){
    //printf("Error al transformar IP en formato binario\n");
   //}else{
   //     printf("IP convertida a formato binario\n");
   //}

   //Realiza una conexion por medio de un socket (fd), con su estructura definida parseada
   //y el tamaño de esa estructura
   int resultado_enlace = bind(fd_socket, (struct sockaddr*)&estructura_socket, 
                             sizeof(estructura_socket));
   if(resultado_enlace < 0){
        //printf("Error al realizar la enlace %d\n", resultado_enlace);
        perror("Error al realizar el enlace");
   }else{
        printf("Socket enlace con exito\n");
   }

}