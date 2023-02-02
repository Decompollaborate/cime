%{
#include <stdio.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);
%}

%union {
    int ival;
    char *sval;
}

%token <sval> T_IDENTIFIER
%token <ival> T_INT
%token T_DOLLAR
%token T_COMMA
%token T_PAREN_LEFT
%token T_PAREN_RIGHT

%%

test:
    test T_INT      {
        printf("bison found an int: %i\n", $2);
        }
    | test T_IDENTIFIER {
        printf("bison found a identifier: %s\n", $2);
        free($2);
        }
    | test T_DOLLAR      {
        printf("bison found a dollar\n");
        }
    | test T_COMMA     {
        printf("bison found a comma\n");
        }
    | test T_PAREN_LEFT      {
        printf("bison found an paren left\n");
        }
    | test T_PAREN_RIGHT      {
        printf("bison found an paren right\n");
        }
    | T_INT            {
        printf("bison found an int: %i\n", $1);
        }
    | T_IDENTIFIER         {
        printf("bison found a identifier: %s\n", $1);
        free($1);
        }
    | T_DOLLAR      {
        printf("bison found a dollar\n");
        }
    | T_COMMA      {
        printf("bison found a comma\n");
        }
    | T_PAREN_LEFT      {
        printf("bison found an paren left\n");
        }
    | T_PAREN_RIGHT      {
        printf("bison found an paren right\n");
        }
    ;
%%

int main(/*int argc, char **argv*/) {
    #if 1
    yyin = stdin;
    #else
    FILE *f = fopen("test.s", "r");
    if (f == NULL) {
        abort();
    }

    yyin = f;
    #endif

    yyparse();

    if (yyin != stdin) {
        fclose(yyin);
    }

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Unknown thingy found: '%s'\n\tgonna crash now!\n", s);;
    abort();
}
