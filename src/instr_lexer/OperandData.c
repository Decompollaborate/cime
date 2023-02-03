#include "OperandData.h"

#include <string.h>
#include "rabbitizer.h"


int8_t getGprNumFromName(const char *name) {
    int8_t i;
    size_t j;

    for (j = 0; j < ARRAY_COUNT(*RabbitizerRegister_GprO32_Names); j++) {
        for (i = 0; i < RAB_REGISTERS_COUNT; i++) {
            if (strcmp(name, RabbitizerRegister_GprO32_Names[i][j]) == 0) {
                return i;
            }
        }
    }

    for (j = 0; j < ARRAY_COUNT(*RabbitizerRegister_GprN32_Names); j++) {
        for (i = 0; i < RAB_REGISTERS_COUNT; i++) {
            if (strcmp(name, RabbitizerRegister_GprN32_Names[i][j]) == 0) {
                return i;
            }
        }
    }

    return -1;
}

int8_t getFprNumFromName(const char *name) {
    int8_t i;
    size_t j;

    for (j = 0; j < ARRAY_COUNT(*RabbitizerRegister_Cop1O32_Names); j++) {
        for (i = 0; i < RAB_REGISTERS_COUNT; i++) {
            if (strcmp(name, RabbitizerRegister_Cop1O32_Names[i][j]) == 0) {
                return i;
            }
        }
    }

    for (j = 0; j < ARRAY_COUNT(*RabbitizerRegister_Cop1N32_Names); j++) {
        for (i = 0; i < RAB_REGISTERS_COUNT; i++) {
            if (strcmp(name, RabbitizerRegister_Cop1N32_Names[i][j]) == 0) {
                return i;
            }
        }
    }

    for (j = 0; j < ARRAY_COUNT(*RabbitizerRegister_Cop1N64_Names); j++) {
        for (i = 0; i < RAB_REGISTERS_COUNT; i++) {
            if (strcmp(name, RabbitizerRegister_Cop1N64_Names[i][j]) == 0) {
                return i;
            }
        }
    }

    return -1;
}


int OperandData_Data_ParseRegister(OperandData_Data *data, const char* reg) {
    int8_t regVal;

    regVal = getGprNumFromName(reg);
    if (regVal > 0) {
        data->type = OPERANDDATA_TYPE_GPR;
        data->data.reg.registerNum = regVal;
        return 0;
    }

    regVal = getFprNumFromName(reg);
    if (regVal > 0) {
        data->type = OPERANDDATA_TYPE_FPR;
        data->data.reg.registerNum = regVal;
        return 0;
    }

    return -1;
}



void OperandData_Data_fprint(FILE *f, const OperandData_Data *data) {
    fprintf(f, "<OperandData type: ");

    switch (data->type) {
        case OPERANDDATA_TYPE_NONE:
            fprintf(f, "NONE");
            break;
        case OPERANDDATA_TYPE_GPR:
            fprintf(f, "GPR, value: %d", data->data.reg.registerNum);
            break;
        case OPERANDDATA_TYPE_FPR:
            fprintf(f, "FPR, value: %d", data->data.reg.registerNum);
            break;
        case OPERANDDATA_TYPE_IMM:
            fprintf(f, "IMM, value: %X", data->data.imm.immVal);
            break;
        case OPERANDDATA_TYPE_IMMBASE:
            fprintf(f, "IMMBASE, imm: 0x%X, reg: %d", data->data.immBase.immVal, data->data.immBase.registerNum);
            break;
    }

    fprintf(f, ">");
}
