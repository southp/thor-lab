#include <iostream>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#include "thor/PrimitiveTypes.h"
#include "thor/lang/Language.h"

using namespace thor;

namespace
{
void draw_background(SDL_Renderer *renderer, int w, int h)
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
            /* use an 8x8 checkerboard pattern */
            i = (((x ^ y) >> 3) & 1);
            SDL_SetRenderDrawColor(renderer, col[i].r, col[i].g, col[i].b, col[i].a);

            rect.x = x;
            rect.y = y;
            SDL_RenderFillRect(renderer, &rect);
        }
    }
}

}

namespace imgutil
{

class Window : thor::lang::Object
{
public:
    Window(int32 x, int32 y);
    ~Window();

    bool isQuit();

    void handleEvent();

private:
    SDL_Window   *_window;
    SDL_Renderer *_render;

    bool _quit;
};

Window::Window(int32 x, int32 y) :
    _window(nullptr),
    _render(nullptr),
    _quit(false)
{
    SDL_CreateWindowAndRenderer(0, 0, 0, &_window, &_render);
    SDL_SetWindowPosition(_window, 0, 0);
    SDL_SetWindowTitle(_window, "Thorlang Monochrome");
    SDL_SetWindowSize(_window, 800, 600);
    SDL_ShowWindow(_window);

    draw_background(_render, 800, 600);
    SDL_RenderPresent(_render);
}

Window::~Window()
{
}

bool Window::isQuit()
{
    return _quit;
}

void Window::handleEvent()
{
    SDL_Event event;

    while(SDL_PollEvent(&event))
    {
        switch (event.type)
        {
            case SDL_KEYUP:
                switch (event.key.keysym.sym) {
                    case SDLK_ESCAPE:
                        _quit = 1;
                    default:
                        break;
                }
                break;
            case SDL_QUIT:
                _quit = 1;
                break;
            default:
                break;
        }
    }
}

bool initialize()
{
    // int result = SDL_Init(SDL_INIT_VIDEO);
    int result = 0;

    return result == 0;
}

void finalize()
{
    SDL_Quit();
}

}

