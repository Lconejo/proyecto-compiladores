/* Bibliotecas a usar, variables globales y estructuras */
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int linea_actual = 1;

/* --------------------------------------------------
 * TABLA DE SÍMBOLOS (Identificadores - Clase 5)
 * -------------------------------------------------- */
typedef struct {
    int posicion;
    char nombre[50];
    int tipo;
} Simbolo; 

Simbolo tablaIden[150];
int numIden = 0;

int guardarIden(char* token) {
    /* Búsqueda previa para evitar duplicados */
    for(int i = 0; i < numIden; i++) {
        if(strcmp(tablaIden[i].nombre, token) == 0) {
            return tablaIden[i].posicion;
        }
    }

    /* Inserción si es nuevo */
    tablaIden[numIden].posicion = numIden;
    strcpy(tablaIden[numIden].nombre, token);
    tablaIden[numIden].tipo = -1; // Valor inicial por defecto
    numIden++;
    return numIden - 1;
}

/* --------------------------------------------------
 * TABLA DE LITERALES (Cadenas - Clase 8)
 * -------------------------------------------------- */
typedef struct {
    int posicion;
    char dato[200];
} Literal;

Literal tablaLiterales[150];
int numLiterales = 0;

int guardarLiteral(char* cadena) {
    /* Inserción directa (sin verificar duplicados) */
    tablaLiterales[numLiterales].posicion = numLiterales;
    strcpy(tablaLiterales[numLiterales].dato, cadena);
    numLiterales++;
    return numLiterales - 1;
}

%}

%option noyywrap

/* Expresiones regulares */

/* Clase 0: Operadores aritméticos */
op_arit     (\+|-|\/|\*|%)

/* Clase 1: Operadores lógicos */
op_log      (&&|\|\||!)

/* Clase 2: Operadores relacionales */
op_rel      (==|!=|>=|<=|>|<)

/* Clase 3: Constantes numéricas base 10 con o sin signo */
digito       [0-9]
dig_signo    \([+-]{digito}+\)
ctes_numerica {digito}+|{dig_signo}

/* Clase 4: Palabras reservadas */
pal_res      (assinado|caso|enquanto|fazer|flutuador|inteiro|para|quebrar|retorno|se|trocar)

/* Clase 5: Identificadores */
letra        [a-zA-Z]
identificador _{letra}({letra}|{digito}|_)*

/* Clase 6: Símbolos especiales */
simb_esp     (\(|\)|\{|\}|;|,|\[|\]|:|#)

/* Clase 8: Cadenas encerradas entre comillas */
cadena       \"([^"\\]|\\.)*\"

%%

 /* Control de líneas y espacios */
\n          { linea_actual++; }
[ \t\r]+    { /* Ignorar espacios y tabuladores */ }

 /* Clase 0: Operadores aritméticos */
{op_arit} {
    printf("<0, %d>\n", yytext[0]);
}

 /* Clase 1: Operadores lógicos */
"&&" { printf("<1, 0>\n"); }
"||" { printf("<1, 1>\n"); }
"!"  { printf("<1, 2>\n"); }

 /* Clase 2: Operadores relacionales */ 
"==" { printf("<2, 0>\n"); }
"!=" { printf("<2, 1>\n"); }
">"  { printf("<2, 2>\n"); }
"<"  { printf("<2, 3>\n"); }
">=" { printf("<2, 4>\n"); }
"<=" { printf("<2, 5>\n"); }

 /* Clase 3: Constantes numéricas */
{ctes_numerica} {
    int valorCte;
    if (yytext[0] == '(') {
        valorCte = atoi(&yytext[1]); /* Convierte omitiendo el '(' inicial */
    } else {
        valorCte = atoi(yytext);
    }
    printf("<3, %d>\n", valorCte);
}

 /* Clase 4: Palabras reservadas */
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

 /* Clase 5: Identificadores */
{identificador} {
    int indice = guardarIden(yytext);
    printf("<5, %d>\n", indice);
}

 /* Clase 6: Símbolos especiales */
{simb_esp} { printf("<6, %d>\n", yytext[0]); }

 /* Clase 7: Operadores de asignación */
"+=" { printf("<7, 1>\n"); }
"-=" { printf("<7, 2>\n"); }
"*=" { printf("<7, 3>\n"); }
"/=" { printf("<7, 4>\n"); }
"%=" { printf("<7, 5>\n"); }
"="  { printf("<7, 0>\n"); }

 /* Clase 8: Constantes cadenas */
{cadena} {
    /* Contar saltos de línea internos si la cadena abarca varias líneas */
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') linea_actual++;
    }
    int pos = guardarLiteral(yytext);
    printf("<8, %d>\n", pos);
}

 /* Clase 9: Operadores sobre cadenas */
"&"    { printf("<9, 0>\n"); }
"like" { printf("<9, 1>\n"); }

 /* Manejo de Errores Léxicos */
. {
    printf("[Error Lexico] Linea %d: Simbolo no reconocido '%s'\n", linea_actual, yytext);
}

%%

/* Código C Principal */
int main(int argc, char *argv[]) {

    printf("======================================================\n");
    printf("           PROYECTO 1 - ANALIZADOR LEXICO            \n");
    printf("  Integrantes:\n");
    printf("  - Ambrosio Escobar Dominic Yael \n");
    printf("  - Briones Gomez Oliver Cesar Augusto\n");
    printf("  - Ramirez Rodriguez Oscar Gael\n");
    printf("  Fecha: Octubre 2026\n");
    printf("======================================================\n\n");



    if (argc < 2) {
        printf("Falta el archivo de entrada.\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Error al abrir el archivo.\n");
        return 1;
    }

    printf("\n--- TOKENS GENERADOS (Clase, Valor) ---\n");

    /* Iniciar el análisis léxico */
    yylex();

    fclose(yyin);

    /* Impresión de la Tabla de Símbolos */
    printf("\n\n--- TABLA DE SÍMBOLOS (Identificadores) ---\n");
    printf("%-10s | %-25s | %-10s\n", "Posicion", "Nombre", "Tipo");
    printf("------------------------------------------------------\n");
    for(int i = 0; i < numIden; i++) {
        printf("%-10d | %-25s | %-10d\n", tablaIden[i].posicion, tablaIden[i].nombre, tablaIden[i].tipo);
    }

    /* Impresión de la Tabla de Literales */
    printf("\n\n--- TABLA DE LITERALES (Cadenas) ---\n");
    printf("%-10s | %-40s\n", "Posicion", "Dato");
    printf("------------------------------------------------------\n");
    for(int i = 0; i < numLiterales; i++) {
        printf("%-10d | %-40s\n", tablaLiterales[i].posicion, tablaLiterales[i].dato);
    }

    return 0;
}
