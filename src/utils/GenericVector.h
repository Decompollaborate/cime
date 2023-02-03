#ifndef GENERIC_VECTOR_H
#define GENERIC_VECTOR_H

#include <stdint.h>
#include <stdlib.h>

#define GENERICVECTOR_DECLARE(name, nodetype)                        \
    typedef struct name {                                            \
        size_t capacity;                                             \
        size_t len;                                                  \
        nodetype *arr;                                               \
    } name;                                                          \
    int name ## _init(name *self, size_t startingCapacity);     \
    void name ## _destroy(name *self); \
    void name ## _append(name *self, const nodetype *element)

#define GENERICVECTOR_DEFINE(name, nodetype)                                        \
    int name ## _init(name *self, size_t startingCapacity) {                   \
        self->arr = malloc(sizeof(nodetype) * startingCapacity);                    \
                                                                                    \
        if (self->arr == NULL) {                                                    \
            return -1;                                                              \
        }                                                                           \
                                                                                    \
        self->len = 0;                                                              \
        self->capacity = startingCapacity;                                          \
                                                                                    \
        return 0;                                                                   \
    }                                                                               \
                                                                                    \
    void name ## _destroy(name *self) {               \
        if (self->arr != NULL) {                                                    \
            free(self->arr);                                                        \
        }                                                                           \
        self->arr = NULL;                                                           \
        self->len = 0;                                                              \
        self->capacity = 0;                                                         \
    }                                                                               \
                                                                                    \
    void name ## _append(name *self, const nodetype *element) {                     \
        assert(self->arr != NULL);                                                  \
                                                                                    \
        if (self->len >= self->capacity) {                                          \
            self->capacity *= 2;                                                    \
            self->arr = realloc(self->arr, sizeof(nodetype) * self->capacity);      \
        }                                                                           \
        self->arr[self->len++] = *element;                                          \
    }

#endif
