#ifndef __THORLAB__IMGUTIL__IMAGE__H
#define __THORLAB__IMGUTIL__IMAGE__H

#include <SDL2/SDL.h>

#include "thor/PrimitiveTypes.h"
#include "thor/lang/Language.h"
#include "thor/lang/String.h"
#include "thor/container/Vector.h"

namespace imgutil
{

class Image : public thor::lang::Object
{
public:
    using PixCont = thor::container::Vector<thor::int32>;

    Image();
    ~Image();

    bool load(thor::lang::String* filename);

    PixCont* getAllPixels();
       void  setAllPixels(PixCont* pixs);

    thor::int32 getWidth()  const;
    thor::int32 getHeight() const;

    SDL_Surface *surface;
};

}

#endif
