%{
#include <stdlib.h>
#include <stdio.h>
#define INDENT 1
#define DEDENT 2
#define END 3
struct node {
  int indent; 
  struct node *next; 
};

struct node *stack = NULL;

void push (int indent) {
  struct node *new_node = malloc (sizeof (struct node)); 
  new_node->indent = indent;
  new_node->next = stack;
  stack = new_node; 
}

int pop () {
  if (stack == NULL) { 
    return -1; 
  }
  int indent = stack->indent; 
  struct node *temp = stack; 
  stack = stack->next; 
  free (temp); 
  return indent; 
}

int peek () {
  if (stack == NULL) { 
    return -1; 
  }
  return stack->indent;
}

int count_spaces (char *line) {
  int count = 0; 
  while (*line == ' ') { 
    count++;
    line++; 
  }
  return count; 
}
%}
STRING \"([^\"]*)\"
LETTER [a-zA-Z_] 
DIGIT [0-9] 
ID {LETTER}({LETTER}|{DIGIT})*
INT {DIGIT}+ 
FLOAT {DIGIT}+"."{DIGIT}* 
COMMENT #.*
%%
"int" {return("INT_KW ,yytext);}
"def"  {return("DEF_KW,yytext);}
"return" {return("RETURN_KW ,yytext);}
"else" {printf("ELSE_KW = %s \n",yytext);} 
"elif" {printf("ELIF_KW = %s \n",yytext);}
"while" {printf("WHILE_KW = %s \n",yytext);} 
"for" {printf("FOR_KW = %s \n",yytext);}  
"and" {printf("AND_kW = %s \n",yytext);} 
"if" {printf("IF_KW = %s \n",yytext);} 
"or" {printf("OR_KW = %s \n",yytext);}
"not" {printf("NOT_KW = %s \n",yytext);} 
"True" {printf("TRUE = %s \n",yytext);} 
"False" {printf("FALSE = %s \n",yytext);} 
"None" {printf("NONE_KW = %s \n",yytext);}
{ID} {printf("IDENTIFIER = %s \n",yytext);} 
{INT} {printf("INTEGER = %s \n",yytext);}
{FLOAT} {printf("FLOAT = %s \n",yytext);}  
{COMMENT} {/* ignore */;} 
\n[ \t]* {
  int spaces = count_spaces (yytext + 1); 
  int indent = peek (); 
  if (spaces > indent) { 
    push (spaces);  
    printf("INDENT = %d \n",INDENT);
  }
  while (spaces < indent) { 
    pop (); 
    printf("DEDENT = %d \n",DEDENT); 
    indent = peek (); 
  }
  if (stack == NULL) { 
    return END; 
  }
}
"+" {printf("PLUS = %s \n",yytext);} 
"-" {printf("MINUS = %s \n",yytext);}
"*" {printf("STAR = %s \n",yytext);} 
"/" {printf("SLASH = %s \n",yytext);} 
"%" {printf("PERCENT = %s \n",yytext);} 
"**" {printf("POWER = %s \n",yytext);} 
"==" {printf("EQUAL_EQUAL = %s \n",yytext);} 
"!=" {printf("NOT_EQUAL = %s \n",yytext);} 
"<" {printf("LESS = %s \n",yytext);} 
">" {printf("GREATER = %s \n",yytext);} 
"<=" {printf("LESS_EQUAL = %s \n",yytext);}
">=" {printf("GREATER_EQUAL = %s \n",yytext);}
"=" {printf("ASSIGN = %s \n",yytext);}  
"," {printf("COMMA = %s \n",yytext);} 
":" {printf("COLON = %s \n",yytext);}
"." {printf("DOT = %s \n",yytext);}
";" {printf("SEMICOLON = %s \n",yytext);} 
"//" {printf("FLOOR_DIV = %s \n",yytext);}
"(" {printf("LPAREN = %s \n",yytext);}
")" {printf("RPAREN = %s \n",yytext);}
"[" {printf("LBRACK = %s \n",yytext);} 
"]" {printf("RBRACK = %s \n",yytext);} 
"{" {printf("LBRACE = %s \n",yytext);} 
"}" {printf("RBRACE = %s \n",yytext);} 
{STRING} {printf("STRING = %s \n",yytext);}
%%
