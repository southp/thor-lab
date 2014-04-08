#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#include "image.h"

#include "thor/PrimitiveTypes.h"
#include "thor/lang/Language.h"
#include "thor/lang/String.h"
#include "thor/container/Vector.h"

using namespace thor;

namespace imgutil
{

Image::Image() : surface(nullptr)
{
}

Image::~Image()
{
    SDL_FreeSurface(surface);
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
    int         w = surface->w;
    int         h = surface->h;
    int     total = w*h;
    int* ori_pixs = reinterpret_cast<int*>(surface->pixels);

    // FIXME: instead of total, create() always get a UINT_MAX...WTF?
    // PixCont* pixs = PixCont::create(static_cast<int64>(total));

    PixCont* pixs = PixCont::create();

    for(int i = 0; i < total; ++i)
    {
        int val = *ori_pixs;
        // pixs->set(i, val);

        pixs->pushBack(val);
        ++ori_pixs;
    }

    return pixs;
}

void Image::setAllPixels(PixCont* pixs)
{
    int         w = surface->w;
    int         h = surface->h;
    int     total = w*h;
    int* ori_pixs = reinterpret_cast<int*>(surface->pixels);

    for(int i = 0; i < total; ++i)
    {
        int val = pixs->get(i);

        *ori_pixs = val;
        ++ori_pixs;
    }
}

int32 Image::getWidth() const
{
    return surface->w;
}

int32 Image::getHeight() const
{
    return surface->h;
}

}

