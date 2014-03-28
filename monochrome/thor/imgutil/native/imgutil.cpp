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
};

Window::Window(int32 x, int32 y)
{
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

}

