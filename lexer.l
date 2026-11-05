%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

/* Опція, щоб не читати декілька файлів підряд */
%option noyywrap 

%%

"int"                   { return INT; }
[0-9]+                  { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return IDENTIFIER; }
"+"                     { return PLUS; }
"="                     { return ASSIGN; }
";"                     { return SEMICOLON; }
[ \t\n\r]+              { /* Ігноруємо пробіли та переноси рядків */ }
.                       { printf("Невідомий символ: %s\n", yytext); }

%%