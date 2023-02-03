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
#include "InstructionData.h"
#include "InstrLexer.tab.h"



extern int linenum;

int yyerror(YYLTYPE *locp, void* scanner, const char *msg) ;
%}

%union {
    int ival;
    char *sval;
    InstructionData instrData;
    RabbitizerInstrId rabInstrId;
    OperandData_Data operandData;
}

%token <sval> T_IDENTIFIER
%token <sval> T_REG
%token <ival> T_INT

%type <instrData> Instruction
%type <rabInstrId> Opcode
%type <operandData> Operand
%type <operandData> Register

%%

OtherInstruction:
    OtherInstruction Instruction {
        int64_t word = InstructionData_toWord(&$2);

        InstructionData_fprint(stdout, &$2);

        if (word < 0) {
            fprintf(stderr, "\nError at line %i: instruction is invalid (%ld).\n", linenum, word);
            exit(-1);
        }

        fprintf(stdout, "\nword: %08lX", word);

        fprintf(stdout, "\n\n");
    }
    | Instruction {
        int64_t word = InstructionData_toWord(&$1);

        InstructionData_fprint(stdout, &$1);

        if (word < 0) {
            fprintf(stderr, "\nError at line %i: instruction is invalid (%ld).\n", linenum, word);
            exit(-1);
        }

        fprintf(stdout, "\nword: %08lX", word);

        fprintf(stdout, "\n\n");
    }
    ;

Instruction:
    Opcode {
            $$.opcode = $1;
            $$.operandCount = 0;
    }
    | Opcode Operand {
            $$.opcode = $1;
            $$.operandCount = 1;
            $$.operands[0] = $2;
    }
    | Opcode Operand ',' Operand {
            $$.opcode = $1;
            $$.operandCount = 2;
            $$.operands[0] = $2;
            $$.operands[1] = $4;
    }
    | Opcode Operand ',' Operand ',' Operand {
            $$.opcode = $1;
            $$.operandCount = 3;
            $$.operands[0] = $2;
            $$.operands[1] = $4;
            $$.operands[2] = $6;
    }
    ;

Opcode:
    T_IDENTIFIER {
        $$ = getOpcodeFromName($1);
        if (!RabbitizerInstrId_isValid($$)) {
            fprintf(stderr, "\nError at line %i: Found '%s' when an opcode was expected.\n", linenum, $1);
            exit(-1);
        }
    }
    ;

Operand:
    Register
    | T_INT {
        $$.type = OPERANDDATA_TYPE_IMM;
        $$.data.imm.immVal = $1;
    }
    | T_INT '(' Register ')' {
        if ($3.type != OPERANDDATA_TYPE_GPR) {
            fprintf(stderr, "\nError at line %i: Found ", linenum);
            OperandData_Data_fprint(stdout, &$3);
            fprintf(stderr, "\n when a GPR was expected.\n");
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
            fprintf(stderr, "\nerror at line %d\n", linenum);
            exit(-1);
        }
        free($1);
    }
    | T_IDENTIFIER {
        if (OperandData_Data_ParseRegister(&$$, $1) < 0) {
            fprintf(stderr, "\nerror at line %d\n", linenum);
            exit(-1);
        }
        free($1);
    }
    ;

%%

#if 0
void yyerror(const char *s) {
    fprintf(stderr, "\nUnknown thingy found: '%s' at line %d\n\tgonna crash now!\n", s, linenum);
    abort();
}
#endif

int
yyerror(YYLTYPE *locp, void* scanner, const char *msg) {
    if (locp) {
        fprintf(stderr, "\nparse error: %s (:%d.%d -> :%d.%d)\n",
                        msg,
                        locp->first_line, locp->first_column,
                        locp->last_line,  locp->last_column
        );
        /* todo: add some fancy ^^^^^ error handling here */
    } else {
        fprintf(stderr, "\nparse error: %s\n", msg);
    }
    return (0);
}

