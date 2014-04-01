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

void monochrome(SDL_Surface *sur)
{
    SDL_Color *pxs = sur->pixels;
    int w = sur->w;
    int h = sur->h;
    int total = w*h;
    int half = total / 2;

    pthread_t threads[2];
    struct region arg[2];

    arg[0].beg = pxs;
    arg[0].end = pxs + half;

    arg[1].beg = pxs + half;
    arg[1].end = pxs + total;

    pthread_create(threads, NULL, mono_work, arg);
    pthread_create(threads + 1, NULL, mono_work, arg + 1);

    pthread_join(threads[0], NULL);
    pthread_join(threads[1], NULL);
}

