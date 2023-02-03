#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "rabbitizer.h"

#include "instr_lexer/OperandData.h"
#include "instr_lexer/InstructionData.h"
#include "instr_lexer/NodeData.h"

#include "instr_lexer/InstrLexer.tab.h"
#include "instr_lexer/InstrLexer.yy.h"


int main(int argc, char **argv) {
    NodeDataVector vector;
    FILE *inFile;
    size_t i;

    yyscan_t scanner;

    // disable buffering in stdout
    setvbuf(stdout, NULL, _IONBF, 0);

    NodeDataVector_init(&vector, 10);

#if 0
    yydebug = 1;
#endif

    if (argc > 1) {
        inFile = fopen(argv[1], "r");
        if (inFile == NULL) {
            abort();
        }
    } else {
        inFile = stdin;
    }

    yylex_init(&scanner);
    yyset_in(inFile, scanner);

    yyparse(scanner, &vector);

    for (i = 0; i < vector.len; i++) {
        NodeData_Data *node = &vector.arr[i];

        switch (node->type) {
            case NODEDATA_TYPE_INSTRUCTION:
            {
                InstructionData *instr = &node->data.instruction;

                int64_t word = InstructionData_toWord(instr);

                InstructionData_fprint(stdout, instr);

                if (word < 0) {
                    fprintf(stderr, "\ninstruction is invalid (%ld).\n", word);
                    exit(-1);
                }

                fprintf(stdout, "\nword: %08lX", word);

                fprintf(stdout, "\n\n");
            }
            break;

            default:
                fprintf(stderr, "unhandled node type (%d)\n", node->type);
                assert(false);
                break;
        }
    }

    yylex_destroy(scanner);

    if (inFile != stdin) {
        fclose(inFile);
    }

    NodeDataVector_destroy(&vector);

    return 0;
}
