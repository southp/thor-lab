#include <pthread.h>
#include <stdlib.h>
#include <SDL2/SDL.h>

struct region
{
    SDL_Color *beg;
    SDL_Color *end;
};

void* mono_work(void *arg)
{
    struct region *reg = (struct region*)arg;
    SDL_Color *p;
    pthread_t self = pthread_self();

    printf("Thread id: %d\n", self);

    for(p = reg->beg; p != reg->end; ++p)
    {
        float r = p->r / 255.0f;
        float g = p->g / 255.0f;
        float b = p->b / 255.0f;
        float mono = (0.2125 * r) + (0.7154 * g) + (0.0721 * b);
        uint8_t mono_v = (uint8_t)(mono * 255);

        p->r = mono_v;
        p->g = mono_v;
        p->b = mono_v;
    }

    return NULL;
}

#define NUM_CORE 4

void monochrome(SDL_Surface *sur)
{
    int w = sur->w;
    int h = sur->h;
    int total = w*h;
    int   div = total / NUM_CORE;

    SDL_Color *pxs = sur->pixels;
    SDL_Color *pxs_end = pxs + total;

    pthread_t threads[NUM_CORE];
    struct region arg[NUM_CORE];

    int i;

    for(i = 0; i < NUM_CORE; ++i)
    {
        struct region* a = arg + i;

        a->beg = pxs;

        if(i != NUM_CORE - 1)
        {
            pxs += div;
            a->end = pxs;
        }
        else
        {
            a->end = pxs_end;
        }
    }

    for(i = 0; i < NUM_CORE; ++i)
    {
        pthread_create(threads + i, NULL, mono_work, arg + i);
    }

    for(i = 0; i < NUM_CORE; ++i)
        pthread_join(threads[i], NULL);
}

