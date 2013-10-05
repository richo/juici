#ifndef __JUICI_LOG_H
#define __JUICI_LOG_H

#include <stdio.h>

#ifdef _DEBUG

#define debug(...) fprintf(stderr, "debug: " __VA_ARGS__)
#define info(...) fprintf(stderr,  "info: "  __VA_ARGS__)

#else

#define debug(fmt, ...)
#define info(fmt, ...)

#endif

#endif /* __JUICI_LOG_H */
