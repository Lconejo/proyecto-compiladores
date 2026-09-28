//bibliotecas a usar, variables globales y expresiones regulares <>
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char tablaIden [150][50];
int numIden = 0, numCtes = 0;
int tablaCtes [150];


int guardarIden(char* token){
    //busqueda para no guardarlo 2 veces
    for(int i=0; i<numIden; i++){
        if(strcmp(tablaIden[i], token) == 0){
            return i; //indice en la tabla
        }
    }
    strcpy(tablaIden[numIden], token); //guardamos el token en la tabla
    numIden++;
    return numIden-1;
}

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
    
    int indice = guardarCte(yytext);
    printf("Constante Numerica Valida: %s, Valor: %d\n", yytext, indice);

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
    printf("Palabra Reservada Valida: %s, Valor: %d\n", yytext, valor);

    //**NO REQUIERE TABLA**
    }


//clase 5
{identificador} {
    
    int indice = guardarIden(yytext);
    printf("Identificador Valido: %s, Valor: %d\n", yytext, indice);

}

//clase 6
{simb_esp} {printf("Simbolo Especial Valido: %s\n", yytext);

//**NO REQUIERE TABLA**

}


%%

//codigo C main