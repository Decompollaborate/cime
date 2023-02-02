%{
#include <stdio.h>
extern int yylex();


extern int linenum;

%}
%option noyywrap

%%

[ \t]                   ; /* skip the space */
\n                      { ++linenum; }
[0-9]+\.[0-9]+          { printf("Found float: %s\n", yytext); }
[0-9]+                  { printf("Found int: %s\n", yytext); }
[a-zA-Z][a-zA-Z0-9]*    { printf("Found token:  %s\n", yytext); }
\$                      { printf("Found $: %s\n", yytext); }
,                       { printf("Found ,: %s\n", yytext); }
\(                      { printf("Found (: %s\n", yytext); }
\)                      { printf("Found ): %s\n", yytext); }
.                       { printf("Unknown thingy found: '%s'\n\tgonna crash now!\n", yytext); fflush(stdout); abort(); }

%%

int linenum = 0;

int main(/*int argc, char **argv*/) {
    yyin = stdin;

    // lex through the input:
    while (yylex());
}
