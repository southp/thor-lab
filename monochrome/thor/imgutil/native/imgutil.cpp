#include <iostream>
// #include <cstring>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#include "thor/PrimitiveTypes.h"
#include "thor/lang/Language.h"
#include "thor/lang/String.h"
#include "thor/container/Vector.h"

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

class Image : thor::lang::Object
{
public:
    using PixCont = thor::container::Vector<int32>;

    Image();
    ~Image();

    bool load(thor::lang::String* filename);

    PixCont* getAllPixels();
       void  setAllPixels(PixCont* pixs);

    SDL_Surface *surface;
};

Image::Image() : surface(nullptr)
{
}

Image::~Image()
{
}

bool Image::load(thor::lang::String* filename)
{
    char cfilename[64];
    wcstombs(cfilename, filename->data->c_str(), sizeof(cfilename));
    surface = IMG_Load(cfilename);

    return surface != nullptr;
}

auto Image::getAllPixels() -> PixCont*
{
    int          w = surface->w;
    int          h = surface->h;
    int      total = w*h;
    int*  ori_pixs = reinterpret_cast<int*>(surface->pixels);

    PixCont* pixs = PixCont::create(total);

    for(int i = 0; i < total; ++i)
    {
        int val = *ori_pixs;
        /* memcpy(&val, ori_pixs, sizeof(val)); */
        pixs->set(i, val);
        ++ori_pixs;
    }

    return pixs;
}

void Image::setAllPixels(PixCont* pixs)
{
}

class Window : thor::lang::Object
{
public:
    Window(int32 x, int32 y);
    ~Window();

    bool isQuit();

    void handleEvent();

    void showImage(Image* img);

private:
    SDL_Window   *_window;
    SDL_Renderer *_render;
    SDL_Texture  *_texture;

    bool _quit;
};

Window::Window(int32 x, int32 y) :
    _window(nullptr),
    _render(nullptr),
    _texture(nullptr),
    _quit(false)
{
    SDL_CreateWindowAndRenderer(0, 0, 0, &_window, &_render);
    SDL_SetWindowPosition(_window, 0, 0);
    SDL_SetWindowTitle(_window, "Thorlang Monochrome");
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

bool initialize()
{
    int result = SDL_Init(SDL_INIT_VIDEO);

    return result == 0;
}

void finalize()
{
    SDL_Quit();
}

}

