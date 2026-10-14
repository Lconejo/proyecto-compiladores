%{
#include <stdio.h>
#include <stdlib.h>
%}

%option noyywrap

/* ============================
   EXPRESIONES REGULARES
   ============================ */

/* Clase 0: operadores aritmeticos */
op_arit     (\+|-|/|\*|%)

/* Clase 1: operadores logicos */
op_log      (&&|\|\||!)

/* Clase 2: operadores relacionales */
op_rel      (==|!=|>=|<=|>|<)

%%

/* ============================
   ACCIONES
   ============================ */

/* Clase 0: operadores aritmeticos */
{op_arit} {
    printf("<0, %s>\n", yytext);
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

/* Clase 2: operadores relacionales */
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

/* Ignorar espacios, tabuladores y saltos de linea */
[ \t\r\n]+ {
}

/* Cualquier otro caracter */
. {
    printf("Error Lexico Encontrado: %s\n", yytext);
}

%%

int main(int argc, char *argv[])
{
    /* Verificar archivo de entrada */
    if (argc < 2) {
        printf("Falta el archivo de entrada.\n");
        return 1;
    }

    /* Abrir archivo */
    yyin = fopen(argv[1], "r");

    if (!yyin) {
        printf("Error al abrir el archivo.\n");
        return 1;
    }

    /* Ejecutar analizador lexico */
    yylex();

    fclose(yyin);

    return 0;
}