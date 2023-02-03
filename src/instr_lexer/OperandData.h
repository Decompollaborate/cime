#ifndef OPERAND_DATA_H
#define OPERAND_DATA_H

#include <stdint.h>
#include <stdio.h>

typedef struct OperandData_Register {
    uint32_t registerNum;
} OperandData_Register;

typedef struct OperandData_Op {
    uint32_t opVal;
} OperandData_Op;

typedef struct OperandData_Code {
    uint32_t codeVal;
} OperandData_Code;

// typedef struct OperandData_Label {
// } OperandData_Label;

typedef struct OperandData_Imm {
    uint16_t immVal;
} OperandData_Imm;

typedef struct OperandData_ImmBase {
    uint32_t immVal;
    uint16_t registerNum;
} OperandData_ImmBase;

//typedef struct OperandData_MaybeRdRs {
//    uint32_t rd;
//    uint32_t rs;
//} OperandData_MaybeRdRs;


typedef enum OperandData_Type {
    OPERANDDATA_TYPE_NONE,
    OPERANDDATA_TYPE_GPR,
    OPERANDDATA_TYPE_FPR,
    //OPERANDDATA_TYPE_OP,
    //OPERANDDATA_TYPE_CODE,
    // OPERANDDATA_TYPE_LABEL,
    OPERANDDATA_TYPE_IMM,
    OPERANDDATA_TYPE_IMMBASE,
    //OPERANDDATA_TYPE_MAYBERDRS,
} OperandData_Type;


typedef struct OperandData_Data {
    OperandData_Type type;
    union {
        OperandData_Register reg;
        //OperandData_Op op;
        //OperandData_Code code;
        //OperandData_Label label;
        OperandData_Imm imm;
        OperandData_ImmBase immBase;
        //OperandData_MaybeRdRs rdrs;
    } data;
} OperandData_Data;

// int8_t getGprNumFromName(const char *name);
// int8_t getFprNumFromName(const char *name);

int OperandData_Data_ParseRegister(OperandData_Data *data, const char* reg);

void OperandData_Data_fprint(FILE *f, const OperandData_Data *data);

#endif
