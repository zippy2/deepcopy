#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "structs.h"
#include "structs_gen.h"

#define ERROR(...)                      \
do {                                    \
    fprintf(stderr, __VA_ARGS__);       \
} while (0)

int virAlloc(void *ptrptr,
             size_t size)
{
    *(void **)ptrptr = calloc(1, size);
    if (*(void **)ptrptr == NULL)
        return -1;
    return 0;
}

void virFree(void *ptrptr)
{
    free(*(void**)ptrptr);
    *(void**)ptrptr = NULL;
}

int virStrdup(char **dest,
              const char *src)
{
    *dest = NULL;
    if (!src)
        return 0;
    if (!(*dest = strdup(src)))
        return -1;
    return 1;
}

int main(int argc, char *argv[])
{
    int ret = EXIT_FAILURE;
    test1Ptr t1_dst = NULL;
    test1 t1_src;
    test2Ptr t2_dst = NULL;
    test2 t2_src;

    memset(&t1_src, 0, sizeof(t1_src));
    memset(&t2_src, 0, sizeof(t2_src));

    t1_src.x = 4;

    if (!(t1_dst = test1Copy(&t1_src)))
        goto cleanup;

    if (t1_dst->x != 4) {
        ERROR("Unexpected value\n");
        goto cleanup;
    }

    t2_src.a = 'a';

    if (!(t2_dst = test2Copy(&t2_src)))
        goto cleanup;

    if (t2_dst->a != 'a') {
        ERROR("Unexpected value\n");
        goto cleanup;
    }

    ret = EXIT_SUCCESS;
 cleanup:
    test1Free(t1_dst);
    test2Free(t2_dst);
    return 0;
}
