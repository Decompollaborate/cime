%{
#include <stdio.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int linenum;

void yyerror(const char *s);
%}

%union {
    int ival;
    char *sval;
}

%token <sval> T_IDENTIFIER
%token <ival> T_INT


%type <sval> Instruction Opcode Operand

%%

Instruction:
    Opcode {
            //$$ = $1;
            printf("Opcode: %s\n", $1);
        }
    | Opcode Operand {
            printf("Opcode: %s, Operands: [%s]\n", $1, $2);
        }
    | Opcode Operand ',' Operand {
            printf("Opcode: %s, Operands: [%s, %s]\n", $1, $2, $4);
        }
    | Opcode Operand ',' Operand ',' Operand {
            printf("Opcode: %s, Operands: [%s, %s, %s]\n", $1, $2, $4, $6);
        }
    ;

Opcode:
    T_IDENTIFIER
    ;

Operand:
    '$' T_IDENTIFIER {
        $$ = malloc(strlen($2) + 2);
        $$[0] = '$';
        strcpy(&$$[1], $2);
        free($2);
        }
    | T_IDENTIFIER
    | T_INT {
        $$ = malloc(64);
        sprintf($$, "0x%X", $1);
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
    fprintf(stderr, "Unknown thingy found: '%s' at line %d\n\tgonna crash now!\n", s, linenum);
    abort();
}
