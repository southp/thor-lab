#include <cassert>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#include "thor/PrimitiveTypes.h"
#include "thor/lang/Language.h"

#include "image.h"

using namespace thor;

namespace
{
// function courtesy of showimage.c from SDL2_image lib.
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

class Window : public thor::lang::Object
{
public:
    Window();
    ~Window();

    void showImage(Image* img);

private:
    SDL_Window   *_window = nullptr;
    SDL_Renderer *_render = nullptr;
    SDL_Texture  *_texture = nullptr;

};

Window::Window()
{
    SDL_CreateWindowAndRenderer(0, 0, 0, &_window, &_render);
    SDL_SetWindowPosition(_window, 0, 0);
    SDL_SetWindowTitle(_window, "Thorlang Monochrome");

    assert(_window != nullptr && _render != nullptr && "Failed to create SDL_Window / SDL_Renderer.");
}

Window::~Window()
{
    if(_texture != nullptr)
        SDL_DestroyTexture(_texture);

    SDL_DestroyRenderer(_render);
    SDL_DestroyWindow(_window);
}

void Window::showImage(Image* img)
{
    int w, h;

    _texture = SDL_CreateTextureFromSurface(_render, img->surface);

    SDL_QueryTexture(_texture, nullptr, nullptr, &w, &h);
    SDL_SetWindowSize(_window, w, h);

    draw_background(_render, w, h);

    SDL_RenderCopy(_render, _texture, nullptr, nullptr);
    SDL_RenderPresent(_render);

    SDL_ShowWindow(_window);
}

}

