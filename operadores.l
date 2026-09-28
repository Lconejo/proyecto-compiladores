%{
#include <stdio.h>
%}

%option noyywrap

%%

"&&" {
    printf("Lexema: %s | Clase: 1 | Operador logico | Valor: 0\n", yytext);
}

"||" {
    printf("Lexema: %s | Clase: 1 | Operador logico | Valor: 1\n", yytext);
}

"!" {
    printf("Lexema: %s | Clase: 1 | Operador logico | Valor: 2\n", yytext);
}

"==" {
    printf("Lexema: %s | Clase: 2 | Operador relacional | Valor: 0\n", yytext);
}

"!=" {
    printf("Lexema: %s | Clase: 2 | Operador relacional | Valor: 1\n", yytext);
}

">=" {
    printf("Lexema: %s | Clase: 2 | Operador relacional | Valor: 4\n", yytext);
}

"<=" {
    printf("Lexema: %s | Clase: 2 | Operador relacional | Valor: 5\n", yytext);
}

">" {
    printf("Lexema: %s | Clase: 2 | Operador relacional | Valor: 2\n", yytext);
}

"<" {
    printf("Lexema: %s | Clase: 2 | Operador relacional | Valor: 3\n", yytext);
}

"+" {
    printf("Lexema: %s | Clase: 0 | Operador aritmetico\n", yytext);
}

"-" {
    printf("Lexema: %s | Clase: 0 | Operador aritmetico\n", yytext);
}

"/" {
    printf("Lexema: %s | Clase: 0 | Operador aritmetico\n", yytext);
}

"*" {
    printf("Lexema: %s | Clase: 0 | Operador aritmetico\n", yytext);
}

"%" {
    printf("Lexema: %s | Clase: 0 | Operador aritmetico\n", yytext);
}

[ \t\r\n]+  { }

. {
    printf("Lexema: %s | No pertenece a las clases 0, 1 o 2\n", yytext);
}

%%

int main(int argc, char *argv[])
{
    FILE *archivo;

    if (argc != 2)
    {
        printf("Uso: %s archivo.txt\n", argv[0]);
        return 1;
    }

    archivo = fopen(argv[1], "r");

    if (archivo == NULL)
    {
        printf("Error: no se pudo abrir el archivo %s\n", argv[1]);
        return 1;
    }

    yyin = archivo;

    yylex();

    fclose(archivo);

    return 0;
}