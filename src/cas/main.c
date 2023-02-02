#include <stdio.h>
#include <string.h>
#include "rabbitizer.h"

#include "instr_lexer/InstrLexer.tab.h"
#include "instr_lexer/InstrLexer.yy.h"

int main(/*int argc, char **argv*/) {
    #if 1
    //yyin = stdin;
    #else
    FILE *f = fopen("test.s", "r");
    if (f == NULL) {
        abort();
    }
    yyin = f;
    #endif

#if 0
    yyparse();

#else

    int result;
    yyscan_t scanner;

    yylex_init(&scanner);
    result = (yyparse(scanner));
    yylex_destroy(scanner);
    return (result);
#endif

/*
    if (yyin != stdin) {
        fclose(yyin);
    }
*/

    return 0;
}
