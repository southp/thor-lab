#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include <sys/time.h>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#include "timer.h"

void monochrome(SDL_Surface *sur);

// function courtesy of showimage.c from SDL2_image lib.
static void draw_background(SDL_Renderer *renderer, int w, int h)
{
    SDL_Color col[2] = {
        { 0x66, 0x66, 0x66, 0xff },
        { 0x99, 0x99, 0x99, 0xff },
    };
    int i, x, y;
    SDL_Rect rect;

    rect.w = 8;
    rect.h = 8;
    for (y = 0; y < h; y += rect.h) {
        for (x = 0; x < w; x += rect.w) {
            i = (((x ^ y) >> 3) & 1);
            SDL_SetRenderDrawColor(renderer, col[i].r, col[i].g, col[i].b, col[i].a);

            rect.x = x;
            rect.y = y;
            SDL_RenderFillRect(renderer, &rect);
        }
    }
}

int main(int argc, char *argv[])
{
    Uint32 flags = 0;
    int i, w, h, done;

    struct timeval t1, t2;

    SDL_Window   *window = NULL;
    SDL_Renderer *renderer = NULL;
    SDL_Texture  *texture = NULL;
    SDL_Surface  *img_surface = NULL;
    SDL_Event     event;

    const char *img_name = NULL;

    if(argc != 2)
    {
        fprintf(stderr, "Usage: %s <image_file> \n", argv[0]);
        return -1;
    }

    img_name = argv[1];

    if (SDL_CreateWindowAndRenderer(0, 0, flags, &window, &renderer) < 0)
    {
        fprintf(stderr, "SDL_CreateWindowAndRenderer() failed: %s\n", SDL_GetError());
        return -2;
    }
    SDL_SetWindowPosition(window, 0, 0);

    img_surface = IMG_Load(img_name);
    if(!img_surface)
    {
        fprintf(stderr, "Failed to load %s.\n", img_name);
        return -3;
    }

    begin_timing();
        monochrome(img_surface);
    end_timing();

    texture = SDL_CreateTextureFromSurface(renderer, img_surface);
    if (!texture)
    {
        fprintf(stderr, "Couldn't create texture from surface!\n");
        return -1;
    }
    SDL_QueryTexture(texture, NULL, NULL, &w, &h);

    SDL_SetWindowTitle(window, img_name);
    SDL_SetWindowSize(window, w, h);
    SDL_ShowWindow(window);

    done = 0;
    while(!done)
    {
        while(SDL_PollEvent(&event))
        {
            switch (event.type)
            {
                case SDL_KEYUP:
                    switch (event.key.keysym.sym) {
                        case SDLK_ESCAPE:
                            done = 1;
                        default:
                            break;
                    }
                    break;

                case SDL_QUIT:
                    done = 1;
                    break;

                //refresh whatever happened to the window. I'm just too lazy to handle each in detail...
                case SDL_WINDOWEVENT:
                    draw_background(renderer, w, h);
                    SDL_RenderCopy(renderer, texture, NULL, NULL);
                    SDL_RenderPresent(renderer);
                    break;

                default:
                    break;
            }
        }

        SDL_Delay(100);
    }

    SDL_FreeSurface(img_surface);
    SDL_DestroyTexture(texture);
    SDL_DestroyWindow(window);
    SDL_DestroyRenderer(renderer);
    SDL_Quit();
    return 0;
}

