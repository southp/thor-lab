#include <iostream>

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#include "thor/PrimitiveTypes.h"
#include "thor/lang/Language.h"

using namespace thor;

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
};

Window::Window(int32 x, int32 y) :
    _window(nullptr),
    _render(nullptr)
{
    SDL_CreateWindowAndRenderer(0, 0, 0, &_window, &_render);
}

Window::~Window()
{
}

bool Window::isQuit()
{
    static int count = 0;
    ++count;
    return count > 1000;
}

void Window::handleEvent()
{
    std::cout << "HAHA" << std::endl;
}

bool initialize()
{
    int result = SDL_Init(SDL_INIT_EVERYTHING);

    return result == 0;
}

void finialize()
{
    SDL_Quit();
}

}

