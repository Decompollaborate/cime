#include <stdio.h>
#include <string.h>
#include "rabbitizer.h"

#if 0
int main() {
    printf("Reading from stdin. Press ctrl-C to exit\n");

    while (true) {
        RabbitizerInstrId instrId = RABBITIZER_INSTR_ID_cpu_INVALID;
        const RabbitizerInstrDescriptor *descriptor = NULL;
        char opcodeBuff[0x100];
        char operandBuff[ARRAY_COUNT(descriptor->operands)][0x100];
        size_t i;
        int scanRet;

        scanRet = scanf("%100s", opcodeBuff);
        printf("opcodeBuff scanRet: %i\n", scanRet);

        for (i = 0; i < RABBITIZER_INSTR_ID_ALL_MAX; i++) {
            if (strcmp(RabbitizerInstrId_Names[i], opcodeBuff) == 0) {
                instrId = i;
                break;
            }
        }

        if (!RabbitizerInstrId_isValid(instrId)) {
            // maybe fatal error instead?
            fprintf(stderr, "Token '%s' not found, skipping\n", opcodeBuff);
            continue;
        }

        #ifdef DEVELOPMENT
        fprintf(stderr, "Token '%s' found: '%d'\n", opcodeBuff, instrId);
        #endif

        descriptor = &RabbitizerInstrDescriptor_Descriptors[instrId];

        for (i = 0; i < ARRAY_COUNT(descriptor->operands) && descriptor->operands[i] != RAB_OPERAND_ALL_INVALID; i++) {
            //RabbitizerOperandType operand = descriptor->operands[i];

            if (i != 0) {
                scanf(",");
                printf(", scanRet: %i\n", scanRet);
                scanf(",");
                printf(", scanRet: %i\n", scanRet);
            }

            scanRet = scanf("%100s", operandBuff[i]);
            printf("operandBuff scanRet: %i\n", scanRet);
            printf("operandBuff[i]: %s\n", operandBuff[i]);
        }
    }

    return 0;
}
#endif
