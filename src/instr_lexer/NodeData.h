#ifndef NODE_DATA_H
#define NODE_DATA_H

#include <assert.h>

#include "InstructionData.h"
#include "utils/GenericVector.h"


typedef enum NodeData_Type {
    NODEDATA_TYPE_NONE,
    NODEDATA_TYPE_INSTRUCTION,
    // NODEDATA_TYPE_DIRECTIVE,
} NodeData_Type;

typedef struct NodeData_Data {
    NodeData_Type type;
    union {
        InstructionData instruction;
        // DirectiveData directive;
    } data;
} NodeData_Data;


GENERICVECTOR_DECLARE(NodeDataVector, NodeData_Data);


#endif
