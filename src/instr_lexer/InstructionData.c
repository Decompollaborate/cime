#include "InstructionData.h"

#include <string.h>

RabbitizerInstrId getOpcodeFromName(const char *name) {
    RabbitizerInstrId i;

    for (i = 0; i < RABBITIZER_INSTR_ID_ALL_MAX; i++) {
        if (strcmp(name, RabbitizerInstrId_Names[i]) == 0) {
            return i;
        }
    }

    return RABBITIZER_INSTR_ID_cpu_INVALID;
}

void InstructionData_fprint(FILE* f, const InstructionData *data) {
    size_t i;

    fprintf(f, "<InstructionData opcode: %s", RabbitizerInstrId_Names[data->opcode]);

    for (i = 0; i < data->operandCount; i++) {
        fprintf(f, "\n    ");
        OperandData_Data_fprint(f, &data->operands[i]);
    }

    fprintf(f, ">");
}
