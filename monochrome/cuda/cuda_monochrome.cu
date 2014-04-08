#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

#include <cuda_runtime.h>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

__global__
void monochrome(uint32_t *pixs, int w, int h)
{
    unsigned int u = blockIdx.x*blockDim.x + threadIdx.x;
    unsigned int v = blockIdx.y*blockDim.y + threadIdx.y;
    SDL_Color *p = (SDL_Color*)(pixs + u + v*h);

    float r = p->r / 255.0f;
    float g = p->g / 255.0f;
    float b = p->b / 255.0f;
    float mono = (0.2125 * r) + (0.7154 * g) + (0.0721 * b);
    uint8_t mono_v = (uint8_t)(mono * 255);

    p->r = mono_v;
    p->g = mono_v;
    p->b = mono_v;
}

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
    int w, h, size, done;
    clock_t clk;

    SDL_Window   *window = NULL;
    SDL_Renderer *renderer = NULL;
    SDL_Texture  *img_texture = NULL;
    SDL_Surface  *img_surface = NULL;
    SDL_Event     event;

    const char *img_name = NULL;

    uint32_t *dev_buf = NULL;
    dim3 thrd_per_block(32,32), block_per_grid;

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

    w = img_surface->w;
    h = img_surface->h;
    size = w * h * sizeof(uint32_t);

    cudaMalloc((void**)&dev_buf, size);
    cudaMemcpy(dev_buf, img_surface->pixels, size, cudaMemcpyHostToDevice);

    block_per_grid.x = w / thrd_per_block.x;
    block_per_grid.y = h / thrd_per_block.y;

    clk = clock();

    monochrome<<<block_per_grid, thrd_per_block, 0>>>(dev_buf, w, h);
    cudaDeviceSynchronize();

    printf("*** Time: %f\n", (float)(clock() - clk) / CLOCKS_PER_SEC);

    cudaMemcpy(img_surface->pixels, dev_buf, size, cudaMemcpyDeviceToHost);
    cudaFree(dev_buf);

    img_texture = SDL_CreateTextureFromSurface(renderer, img_surface);
    if (!img_texture)
    {
        fprintf(stderr, "Couldn't create texture from surface!\n");
        return -1;
    }

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
                    SDL_RenderCopy(renderer, img_texture, NULL, NULL);
                    SDL_RenderPresent(renderer);
                    break;

                default:
                    break;
            }
        }

        SDL_Delay(100);
    }

    SDL_FreeSurface(img_surface);
    SDL_DestroyTexture(img_texture);
    SDL_DestroyWindow(window);
    SDL_DestroyRenderer(renderer);
    SDL_Quit();
    return 0;
}

