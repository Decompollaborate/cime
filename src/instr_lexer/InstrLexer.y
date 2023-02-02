%define parse.error verbose
%define api.pure true
%locations
%token-table
%glr-parser
%lex-param {void *scanner}
%parse-param {void *scanner}


%{
#include <stdio.h>
#include "InstrLexer.tab.h"
//#include "InstrLexer.yy.h"

//extern int yylex();
//extern int yyparse();
//extern FILE *yyin;
extern int linenum;

int yyerror(YYLTYPE *locp, void* scanner, const char *msg) ;
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

#if 0
void yyerror(const char *s) {
    fprintf(stderr, "Unknown thingy found: '%s' at line %d\n\tgonna crash now!\n", s, linenum);
    abort();
}
#endif

int
yyerror(YYLTYPE *locp, void* scanner, const char *msg) {
  if (locp) {
    fprintf(stderr, "parse error: %s (:%d.%d -> :%d.%d)\n",
                    msg,
                    locp->first_line, locp->first_column,
                    locp->last_line,  locp->last_column
    );
    /* todo: add some fancy ^^^^^ error handling here */
  } else {
    fprintf(stderr, "parse error: %s\n", msg);
  }
  return (0);
}

