//bibliotecas a usar, variables globales y expresiones regulares <>
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//Tabla de simbolos:

typedef struct{
    int posicion;
    char nombre[50];
    int tipo;
} Simbolo; 

Simbolo tablaIden[150];
int numIden = 0;


int guardarIden(char* token){
    //busqueda para no guardarlo 2 veces
    for(int i=0; i<numIden; i++){
        if(strcmp(tablaIden[i].nombre, token) == 0){
            return tablaIden[i].posicion; //indice en la tabla
        }
    }

    //insertamos en la posicion, el nombre y su tipo

    tablaIden[numIden].posicion = numIden;
    strcpy(tablaIden[numIden].nombre, token); //guardamos el token en la tabla
    tablaIden[numIden].tipo = -1; //valor inicial 
    numIden++;
    return numIden-1;
}

//esta funcion creo que se puede borrar:
int guardarCte(char* token){
    
    //Obtenemos los valores de char a int tratando los () de los valores con signo
    int valorCte;
    if(token[0] == '(' ){
        valorCte = atoi(&token[1]); //lee los digitos y finaliza all llegar a )
    }
    else{
        valorCte = atoi(token);
    }

    //busqueda
    for(int i=0; i<numCtes; i++){
        if(tablaCtes[i] == valorCte){
            return i;
        }
    }

    //insertar
    tablaCtes[numCtes] = valorCte;
    numCtes++;
    return numCtes - 1;
}

%}

//Expresiones regulares <>

//clase 3 contantes numericas base 10 con o sin signo
digito [0-9]
dig_signo \([+-]{digito}+\)
ctes_numerica {digito}+|{dig_signo}

//clase 4 palabras reservadas
pal_res (assinado|caso|enquanto|fazer|flutuador|inteiro|para|quebrar|retorno|se|trocar)

//clase 5 Identificadores
letra [a-zA-Z]
identificador _{letra}({letra}|{digito}|_)*

//clase 6 simbolos especiales
simb_esp (\(|\)|\{|\}|;|,|\[|\]|:|#)



%%

//acciones y expresiones finales
//clase 3
{ctes_numerica} {
    
    int valorCte;

    if(yytext[0] == '(' ){
        valorCte = atoi(&yytext[1]); //atoi es ascii to integer
    }
    else{
        valorCte = atoi(yytext);
    }

    printf("<3, %d>\n", valorCte); //token clase, valor

}

//clase 4

{pal_res} {
    int valor;
    if (strcmp(yytext, "assinado") == 0) valor = 0;
    else if (strcmp(yytext, "caso") == 0) valor = 1;
    else if (strcmp(yytext, "enquanto") == 0) valor = 2;
    else if (strcmp(yytext, "fazer") == 0) valor = 3;
    else if (strcmp(yytext, "flutuador") == 0) valor = 4;
    else if (strcmp(yytext, "inteiro") == 0) valor = 5;
    else if (strcmp(yytext, "para") == 0) valor = 6;
    else if (strcmp(yytext, "quebrar") == 0) valor = 7;
    else if (strcmp(yytext, "retorno") == 0) valor = 8;
    else if (strcmp(yytext, "se") == 0) valor = 9;
    else if (strcmp(yytext, "trocar") == 0) valor = 10;

    printf("<4, %d>\n", valor);
}


//clase 5
{identificador} {
    
    int indice = guardarIden(yytext);
    printf("<5, %d>\n", indice);

}

//clase 6
{simb_esp} {printf("<6, %d>\n", yytext[0]);}

. {

    printf("Error Léxico Encontrado: %s\n", yytext);

}


%%

//codigo C main

//codigo C main
int main(int argc, char *argv[]) {
    // Verificar si se pasó el archivo fuente en la línea de comandos
    if (argc < 2) {
        printf("Falta el archivo de entrada.\n");
        return 1;
    }

    // Apuntar Flex al archivo de prueba
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Error al abrir el archivo.\n");
        return 1;
    }

    // Iniciar el análisis léxico
    yylex();

    fclose(yyin);

    // Opcional: Imprimir tu tabla de símbolos al final para validar
    printf("\n--- Tabla de Simbolos (Identificadores) ---\n");
    for(int i = 0; i < numIden; i++) {
        printf("Pos: %d | Nombre: %s | Tipo: %d\n", tablaIden[i].posicion, tablaIden[i].nombre, tablaIden[i].tipo);
    }
    
    return 0;
}