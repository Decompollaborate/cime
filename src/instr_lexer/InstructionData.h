#ifndef INSTRUCTION_DATA_H
#define INSTRUCTION_DATA_H

#include <stdio.h>

#include "rabbitizer.h"
#include "OperandData.h"


#ifndef RAB_OPERAND_MAX
#define RAB_OPERAND_MAX 4
#endif


typedef struct InstructionData {
    RabbitizerInstrId opcode;
    size_t operandCount;
    OperandData_Data operands[RAB_OPERAND_MAX];
} InstructionData;

RabbitizerInstrId getOpcodeFromName(const char *name);

int64_t InstructionData_toWord(const InstructionData *data);

void InstructionData_fprint(FILE* f, const InstructionData *data);


#endif
