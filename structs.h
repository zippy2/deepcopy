#ifndef __STRUCTS_H__
# define __STRUCTS_H__

int virAlloc(void *ptrptr, size_t size);
void virFree(void *ptrptr);

# define VIR_ALLOC(ptr) virAlloc(&(ptr), sizeof(*(ptr)))
# define VIR_FREE(ptr) virFree(&(ptr))
#endif /*__STRUCTS_H__ */
