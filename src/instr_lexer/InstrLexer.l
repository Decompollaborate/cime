%{
#include <stdio.h>

// to get the token types from Bison
#include "InstrLexer.tab.h"

extern int yylex();


extern int linenum;

%}
%option noyywrap

%%

[ \t]                   ; /* skip the space */
\n                      { ++linenum; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.sval = malloc(strlen(yytext)+1); strcpy(yylval.sval, yytext); return T_IDENTIFIER; }
[0-9]+                  { sscanf(yytext, "%d", &yylval.ival); return T_INT; }
0x[0-9a-fA-F]+          { sscanf(yytext, "%X", &yylval.ival); return T_INT; }
"$"                     { return T_DOLLAR; }
","                     { return T_COMMA; }
"("                     { return T_PAREN_LEFT; }
")"                     { return T_PAREN_RIGHT; }
.                       { printf("Unknown thingy found: '%s'\n\tgonna crash now!\n", yytext); fflush(stdout); abort(); }

%%

int linenum = 0;
#if 0

int main(/*int argc, char **argv*/) {
    yyin = stdin;

    // lex through the input:
    while (yylex());
}
#endif
