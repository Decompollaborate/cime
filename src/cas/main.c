#include <stdio.h>
#include <string.h>
#include "rabbitizer.h"

#include "instr_lexer/OperandData.h"
#include "instr_lexer/InstructionData.h"
#include "instr_lexer/InstrLexer.tab.h"
#include "instr_lexer/InstrLexer.yy.h"

int main(int argc, char **argv) {
    FILE *inFile;

    // disable buffering in stdout
    setvbuf(stdout, NULL, _IONBF, 0); 

    if (argc > 1) {
        inFile = fopen(argv[1], "r");
        if (inFile == NULL) {
            abort();
        }
    } else {
        inFile = stdin;
    }

    yyscan_t scanner;

    yylex_init(&scanner);
    yyset_in(inFile, scanner);

    while (yyparse(scanner));
    yylex_destroy(scanner);

    if (inFile != stdin) {
        fclose(inFile);
    }

    return 0;
}
