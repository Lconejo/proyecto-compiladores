/*
    Elaborado por:
    Ambrosio Escobar Dominic Yael
    Briones Gómez Oliver Cesar Augusto
    Ramírez Rodríguez Oscar Gael

    Fecha de elaboración: 13/Octubre/2026
*/


/*bibliotecas a usar, variables globales y expresiones regulares <>*/
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*Tabla de simbolos:*/

typedef struct{
    int posicion;
    char nombre[50];
    int tipo;
} Simbolo; 

Simbolo tablaIden[150];
int numIden = 0;

    /*Función guardarIden: Guarda el token en la tabla de símbolos*/

int guardarIden(char* token){
    /*busqueda para no guardarlo 2 veces*/
    for(int i=0; i<numIden; i++){
        if(strcmp(tablaIden[i].nombre, token) == 0){
            return tablaIden[i].posicion; //indice en la tabla
        }
    }

    /*insertamos en la posicion, el nombre y su tipo*/

    tablaIden[numIden].posicion = numIden;
    strcpy(tablaIden[numIden].nombre, token); /*guardamos el token en la tabla*/
    tablaIden[numIden].tipo = -1; //valor inicial 
    numIden++;
    return numIden-1;
}

%}

%option noyywrap

/*Expresiones regulares <>*/


/*Clase 0: operadores aritmeticos*/
op_arit     (\+|-|\/|\*|%)

/*Clase 1: operadores logicos */
op_log      (&&|\|\||!)

/*Clase 2: operadores relacionales*/
op_rel      (==|!=|>=|<=|>|<)

/*Clase 3 contantes numericas base 10 con o sin signo*/
digito [0-9]
dig_signo \([+-]{digito}+\)
ctes_numerica {digito}+|{dig_signo}

/*Clase 4 palabras reservadas*/
pal_res (assinado|caso|enquanto|fazer|flutuador|inteiro|para|quebrar|retorno|se|trocar)

/*Clase 5 Identificadores*/
letra [a-zA-Z]
identificador _{letra}({letra}|{digito}|_)*

/*Clase 6 simbolos especiales*/
simb_esp (\(|\)|\{|\}|;|,|\[|\]|:|#)



%%

    /*Clase 0: operadores aritmeticos */
{op_arit} {
    printf("<0, %d>\n", yytext[0]);
}

    /* Clase 1: operadores logicos */
"&&" {
    printf("<1, 0>\n");
}

"||" {
    printf("<1, 1>\n");
}

"!" {
    printf("<1, 2>\n");
}

    /*Clase 2: operadores relacionales*/ 
"==" {
    printf("<2, 0>\n");
}

"!=" {
    printf("<2, 1>\n");
}

">" {
    printf("<2, 2>\n");
}

"<" {
    printf("<2, 3>\n");
}

">=" {
    printf("<2, 4>\n");
}

"<=" {
    printf("<2, 5>\n");
}


    /*Clase 3*/
{ctes_numerica} {
    
    int valorCte;

    if(yytext[0] == '(' ){
        valorCte = atoi(&yytext[1]); /*atoi es ascii to integer*/
    }
    else{
        valorCte = atoi(yytext);
    }

    printf("<3, %d>\n", valorCte); /*token clase, valor*/

}

    /*Clase 4*/

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


    /*Clase 5*/
{identificador} {
    
    int indice = guardarIden(yytext);
    printf("<5, %d>\n", indice);

}

    /*Clase 6*/
{simb_esp} {printf("<6, %d>\n", yytext[0]);}


    /*Ignorar espacios, tabuladores y saltos de linea */
[ \t\r\n]+ {
}

    /*Cualquier otro caracter*/
. {

    printf("Error Léxico Encontrado: %s\n", yytext);

}


%%

/*codigo C main*/
int main(int argc, char *argv[]) {
    /*Verificar si se pasó el archivo fuente en la línea de comandos*/
    if (argc < 2) {
        printf("Falta el archivo de entrada.\n");
        return 1;
    }

    /* Apuntar Flex al archivo de prueba*/
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Error al abrir el archivo.\n");
        return 1;
    }

    printf("\nTOKENS (Clase, Valor):\n");

    /* Iniciar el análisis léxico*/
    yylex();

    fclose(yyin);

    /*Imprime la tabla de símbolos*/
    printf("\n\n--- Tabla de Simbolos (Identificadores) ---\n");
    printf("%-10s | %-25s | %-10s\n", "Posicion", "Nombre", "Tipo");
    printf("------------------------------------------------------\n");
    
    for(int i = 0; i < numIden; i++) {
        /* Los %-10d y %-25s alinean los datos en columnas de 10 y 25 espacios */
        printf("%-10d | %-25s | %-10d\n", tablaIden[i].posicion, tablaIden[i].nombre, tablaIden[i].tipo);
    }
    
    return 0;
}