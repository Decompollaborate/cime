%define parse.error verbose
%define api.pure true
%locations
%token-table
%glr-parser
%lex-param {void *scanner}
%parse-param {void *scanner}


%{
#include <stdio.h>
#include "OperandData.h"
#include "InstrLexer.tab.h"



extern int linenum;

int yyerror(YYLTYPE *locp, void* scanner, const char *msg) ;
%}

%union {
    int ival;
    char *sval;
    OperandData_Data operandData;
}

%token <sval> T_IDENTIFIER
%token <sval> T_REG
%token <ival> T_INT

%type <sval> Opcode
%type <operandData> Operand
%type <operandData> Register

%%

OtherInstruction:
    OtherInstruction Instruction
    | Instruction
    ;

Instruction:
    Opcode {
            //$$ = $1;
            printf("Opcode: %s\n", $1);
            free($1);
        }
    | Opcode Operand {
            printf("Opcode: %s, Operands: [\n    ", $1);
            OperandData_Data_fprint(stdout, &$2);
            printf("\n]\n");
            free($1);
        }
    | Opcode Operand ',' Operand {
            printf("Opcode: %s, Operands: [\n    ", $1);
            OperandData_Data_fprint(stdout, &$2);
            printf("\n    ");
            OperandData_Data_fprint(stdout, &$4);
            printf("\n]\n");
            free($1);
        }
    | Opcode Operand ',' Operand ',' Operand {
            printf("Opcode: %s, Operands: [\n    ", $1);
            OperandData_Data_fprint(stdout, &$2);
            printf("\n    ");
            OperandData_Data_fprint(stdout, &$4);
            printf("\n    ");
            OperandData_Data_fprint(stdout, &$6);
            printf("\n]\n");
            free($1);
        }
    ;

Opcode:
    T_IDENTIFIER
    ;

Operand:
    Register
    | T_INT {
        $$.type = OPERANDDATA_TYPE_IMM;
        $$.data.imm.immVal = $1;
        }
    | T_INT '(' Register ')' {
        if ($3.type != OPERANDDATA_TYPE_GPR) {
            fprintf(stderr, "Error at line %i: Found ", linenum);
            OperandData_Data_fprint(stdout, &$3);
            fprintf(stderr, " when a GPR was expected.\n");
            exit(-1);
        }
        $$.type = OPERANDDATA_TYPE_IMMBASE;
        $$.data.immBase.immVal = $1;
        $$.data.immBase.registerNum = $3.data.reg.registerNum;
    }
    ;

Register:
    T_REG {
        if (OperandData_Data_ParseRegister(&$$, $1) < 0) {
            fprintf(stderr, "error at line %d\n", linenum);
            exit(-1);
        }
        free($1);
        }
    | T_IDENTIFIER {
        if (OperandData_Data_ParseRegister(&$$, $1) < 0) {
            fprintf(stderr, "error at line %d\n", linenum);
            exit(-1);
        }
        free($1);
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

