#include <stdio.h>

#include <sys/time.h>

#include "timer.h"

static struct timeval t1;

void begin_timing()
{
    gettimeofday(&t1, NULL);
}

void end_timing()
{
    static struct timeval t2;
    gettimeofday(&t2, NULL);

    printf("*** time: %f\n", (float)(t2.tv_sec - t1.tv_sec) + (float)(t2.tv_usec - t1.tv_usec) / 1e6);
}

