#include "InstructionData.h"

#include <string.h>
#include <stdlib.h>

RabbitizerInstrId getOpcodeFromName(const char *name) {
    RabbitizerInstrId i;

    for (i = 0; i < RABBITIZER_INSTR_ID_ALL_MAX; i++) {
        if (strcmp(name, RabbitizerInstrId_Names[i]) == 0) {
            return i;
        }
    }

    return RABBITIZER_INSTR_ID_cpu_INVALID;
}

size_t Descriptor_getOperandCount(const RabbitizerInstrDescriptor *descriptor) {
    size_t i = 0;

    while( i < ARRAY_COUNT(descriptor->operands) && descriptor->operands[i] != RAB_OPERAND_ALL_INVALID) {
        i++;
    }

    return i;
}

// negative means invalid
int64_t InstructionData_toWord(const InstructionData *data) {
    const RabbitizerInstrDescriptor *descriptor = &RabbitizerInstrDescriptor_Descriptors[data->opcode];
    size_t descOperandCount = Descriptor_getOperandCount(descriptor);
    size_t i;
    uint32_t word = 0;

    if (descOperandCount != data->operandCount) {
        return -1;
    }

    for (i = 0; i < descOperandCount; i++) {
        RabbitizerOperandType rabOperand = descriptor->operands[i];

        switch (rabOperand) {
            case RAB_OPERAND_cpu_rs:
                if (data->operands[i].type != OPERANDDATA_TYPE_GPR) {
                    return -2;
                }
                word = RAB_INSTR_PACK_rs(word, data->operands[i].data.reg.registerNum);
                break;

            case RAB_OPERAND_cpu_rt:
                if (data->operands[i].type != OPERANDDATA_TYPE_GPR) {
                    return -2;
                }
                word = RAB_INSTR_PACK_rt(word, data->operands[i].data.reg.registerNum);
                break;

            case RAB_OPERAND_cpu_rd:
                if (data->operands[i].type != OPERANDDATA_TYPE_GPR) {
                    return -2;
                }
                word = RAB_INSTR_PACK_rd(word, data->operands[i].data.reg.registerNum);
                break;

            case RAB_OPERAND_cpu_immediate:
                if (data->operands[i].type != OPERANDDATA_TYPE_IMM) {
                    return -2;
                }
                word = RAB_INSTR_PACK_immediate(word, data->operands[i].data.imm.immVal);
                break;

            case RAB_OPERAND_cpu_immediate_base:
                if (data->operands[i].type != OPERANDDATA_TYPE_IMMBASE) {
                    return -2;
                }
                word = RAB_INSTR_PACK_immediate(word, data->operands[i].data.immBase.immVal);
                word = RAB_INSTR_PACK_rs(word, data->operands[i].data.immBase.registerNum);
                break;

            default:
                fprintf(stderr, "unhandled operand type: %d\n", rabOperand);
                exit(-1);
                break;
        }
    }

    return word;
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
