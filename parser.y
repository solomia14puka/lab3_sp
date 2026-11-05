%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

extern int yylex();
extern int yyparse();
void yyerror(const char *s) { printf("Синтаксична помилка: %s\n", s); }

ASTNode* root; // Корінь нашого дерева
%}

%union {
    char* str;
    struct ASTNode* node;
}

%token <str> INT NUMBER IDENTIFIER
%token PLUS ASSIGN SEMICOLON

%type <node> program statement expr

%left PLUS

%%

program:
    statement { root = $1; }
    ;

statement:
    INT IDENTIFIER ASSIGN expr SEMICOLON { 
        $$ = makeNode("Declaration", $2, $4, NULL); 
    }
    ;

expr:
    expr PLUS expr { $$ = makeNode("Addition", "+", $1, $3); }
    | NUMBER       { $$ = makeNode("Number", $1, NULL, NULL); }
    | IDENTIFIER   { $$ = makeNode("Variable", $1, NULL, NULL); }
    ;

%%

int main() {
    printf("Введіть код на C (наприклад: int a = 5 + 3;):\n");
    if (yyparse() == 0 && root != NULL) {
        printf("\n--- 1. AST побудовано успішно! ---\n");
        
        printf("\n--- 2. Виконання обчислень (Семантика) ---\n");
        evaluate(root);
        
        printf("\n--- 3. JSON для веб-візуалізації дерева ---\n");
        printJSON(root);
        printf("\n\n");
    }
    return 0;
}