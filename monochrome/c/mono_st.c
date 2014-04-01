#include <SDL2/SDL.h>

void monochrome(SDL_Surface *sur)
{
    SDL_Color *pxs = sur->pixels;
    int u, v;

    for(v = 0; v < sur->h; ++v)
        for(u = 0; u < sur->w; ++u)
        {
            SDL_Color *p = pxs + v*sur->h + u;
            float r = p->r / 255.0f;
            float g = p->g / 255.0f;
            float b = p->b / 255.0f;
            float mono = (0.2125 * r) + (0.7154 * g) + (0.0721 * b);
            uint8_t mono_v = (uint8_t)(mono * 255);

            p->r = mono_v;
            p->g = mono_v;
            p->b = mono_v;
        }
}
