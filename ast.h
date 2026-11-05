#ifndef AST_H
#define AST_H
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

// Структура вузла дерева
typedef struct ASTNode {
    char* type;
    char* value;
    struct ASTNode* left;
    struct ASTNode* right;
} ASTNode;

// Функція для швидкого створення вузла
static inline ASTNode* makeNode(const char* type, const char* value, ASTNode* left, ASTNode* right) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = strdup(type);
    node->value = value ? strdup(value) : NULL;
    node->left = left;
    node->right = right;
    return node;
}

// Функція обчислення (Семантика дерева)
static inline int evaluate(ASTNode* node) {
    if (!node) return 0;
    if (strcmp(node->type, "Number") == 0) return atoi(node->value);
    if (strcmp(node->type, "Addition") == 0) return evaluate(node->left) + evaluate(node->right);
    if (strcmp(node->type, "Declaration") == 0) {
        int result = evaluate(node->left);
        printf(">> [Семантика] Змінна '%s' отримала обчислене значення: %d\n", node->value, result);
        return result;
    }
    return 0;
}

// Функція генерації JSON для графіка D3.js
static inline void printJSON(ASTNode* node) {
    if (!node) return;
    printf("{\"name\": \"%s\"", node->type);
    if (node->value) printf(", \"value\": \"%s\"", node->value);
    if (node->left || node->right) {
        printf(", \"children\": [");
        if (node->left) printJSON(node->left);
        if (node->left && node->right) printf(", ");
        if (node->right) printJSON(node->right);
        printf("]");
    }
    printf("}");
}
#endif