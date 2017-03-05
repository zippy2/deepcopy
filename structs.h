#ifndef __STRUCTS_H__
# define __STRUCTS_H__

int virAlloc(void *ptrptr, size_t size);
void virFree(void *ptrptr);
int virStrdup(char **dest, const char *src);

# define VIR_ALLOC(ptr) virAlloc(&(ptr), sizeof(*(ptr)))
# define VIR_FREE(ptr) virFree(&(ptr))
# define VIR_STRDUP(dst, src) virStrdup(&(dst), src)
#endif /*__STRUCTS_H__ */
