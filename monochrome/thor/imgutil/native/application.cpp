#include <cassert>

#include <SDL2/SDL.h>

#include "thor/lang/Language.h"

using namespace thor;

namespace imgutil
{

class Application : public thor::lang::Object
{
public:
    Application();
    ~Application();

    void handleEvent();

    bool isQuit();

private:
    bool _quit = false;
};

Application::Application()
{
    assert(SDL_Init(SDL_INIT_VIDEO) == 0 && "SDL_Init failed!");
}

Application::~Application()
{
    SDL_Quit();
}

void Application::handleEvent()
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

bool Application::isQuit()
{
    return _quit;
}

}

