#include <stdio.h>
#include <unistd.h>
#include <crypt.h>
#include <string.h>

int *probar_contrasenia(){

    FILE *valores_hash; //Variable para leer de archivo hash.txt
    char resultado_valores_hash[500]; //Variable para almacenar vh
    FILE *valores_sal; //Variable para leer de archivo sal.txt
    char resultado_valores_sal[500];//Variable para almacenar sales
    FILE *potenciales_pass; //Variable para leer de archivo diccionario.txt
    char resultado_potenciales_pass[500];//Variable para almacenar potenciales pass

    char valor_sal_hash[500] = "";//Variable para almacenar sal+$+vh

    valores_hash = fopen("hash.txt", "r"); //Lectura de archivo hash.txt
    valores_sal = fopen("sal.txt", "r"); //Lectura de archivo sal.txt

    for (int contador = 1; contador <= 3; contador++) {

        //Lee Bytes de un flujo de Bytes. Coloca un valor nulo cada que una nueva linea
        //es leida. Lo hace en resultado_valores_hash y resultado_valores_sal
        fgets(resultado_valores_hash, 500, valores_hash);

        fgets(resultado_valores_sal, 500, valores_sal);

        //Elimina valores nulos encontrados al leer el flujo de Bytes. Lo hace en resultado_valores_hash y resultado_valores_sal
        resultado_valores_hash[strcspn(resultado_valores_hash, "\n")] = 0;

        resultado_valores_sal[strcspn(resultado_valores_sal, "\n")] = 0;

        potenciales_pass = fopen("diccionario.txt", "r");//Lectura de archivo diccionario.txt

        for (int contador2 = 1; contador2 <= 3; contador2++) {

            //Lee Bytes de un flujo de Bytes. Coloca un valor nulo cada que una nueva linea
            //es leida. Lo hace en resultado_potenciales_pass
            fgets(resultado_potenciales_pass, 500, potenciales_pass);

            //Elimina valores nulos encontrados al leer el flujo de Bytes. Lo hace en resultado_potenciales_pass
            resultado_potenciales_pass[strcspn(resultado_potenciales_pass, "\n")] = 0;

            //Obtención de vh a partir de potencial pass y sal
            char *valor_hash = crypt(resultado_potenciales_pass, resultado_valores_sal);

            //Cada nueva comparación, elimina el contenido anterior de valor_sal_hash
            valor_sal_hash[0] = '\0';

            //Concatena a valor_sal_hash de la siguiente forma:
            //1) resultado_valores_sal (sal)
            //2) signo $
            //3) resultado_valores_hash (hash)
            strcat(valor_sal_hash, resultado_valores_sal);

            strcat(valor_sal_hash, "$");

            strcat(valor_sal_hash, resultado_valores_hash);

            //Compara si el valor hash contruido y obtenido de shadow (valor_sal_hash) es el mismo
            //que la transformación obtenida de crypt(). Si lo es, imprime en pantalla la pass que
            //produce la transformación y la sal que se usa para obtener vh
            if (strcmp(valor_hash, valor_sal_hash) == 0) {
                printf("Los hashes son iguales. Hash: %s | Pass: %s\n", valor_hash, resultado_potenciales_pass);
            }
        }
    }

    return 0;
}

int main() {
    probar_contrasenia();
    return 0;
}