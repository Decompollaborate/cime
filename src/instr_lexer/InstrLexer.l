%option bison-bridge
%option bison-locations
%option ecs
%option nodefault
%option noyywrap
%option reentrant
%option stack
%option warn
%option yylineno


%{
#include <stdio.h>

int fileno(FILE*);

#include "OperandData.h"
#include "InstructionData.h"
#include "NodeData.h"

#include "InstrLexer.tab.h"

// extern int yylex();


extern int linenum;

%}
%option noyywrap

%%

[ \t]                               ; /* skip the space */
(#.*)?\n                            { ++linenum; }
[a-zA-Z][a-zA-Z0-9_\.]*             { yylval->sval = malloc(strlen(yytext)+1); strcpy(yylval->sval, yytext); return T_IDENTIFIER; }
\$[a-zA-Z][a-zA-Z0-9_\.]*           { yylval->sval = malloc(strlen(yytext)+1); strcpy(yylval->sval, yytext); return T_REG; }
-?[0-9]+                            { sscanf(yytext, "%d", &yylval->ival); return T_INT; }
-?0x[0-9a-fA-F]+                    { sscanf(yytext, "%X", &yylval->ival); return T_INT; }
[\$,\(\)]                           { return yytext[0]; }
.                                   { printf("Unknown thingy found: '%s'\n\tgonna crash now!\n", yytext); fflush(stdout); abort(); }

%%

int linenum = 1;
