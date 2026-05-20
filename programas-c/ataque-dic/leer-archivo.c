#include <stdio.h>
#include <unistd.h>
#include <crypt.h>
#define _XOPEN_SOURCE

int main() {
     FILE *fptr;

// Open a file in read mode
fptr = fopen("hash-salt.txt", "r");

// Store the content of the file
char myString[500];

// Read the content and store it inside myString
fgets(myString, 500, fptr);
// Print the file content
printf("%s \n", myString);
fgets(myString, 500, fptr);
// Print the file content
printf("%s \n", myString);

fgets(myString, 500, fptr);
// Print the file content
printf("%s \n", myString);


// Close the file
fclose(fptr);
}