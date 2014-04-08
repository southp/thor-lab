#!/bin/bash

set -e

if ! test -e ../mono_build/Makefile
then
    premake4 gmake
fi

case $1 in
thor)
    cd thor

    cd imgutil

    echo "Build imgutil..."
    if ! test -e dep
    then
        thorc e
    fi

    cd native

    g++ -I../dep/system.bundle/src -std=c++11 -fPIC -g -c application.cpp window.cpp image.cpp

    cd ..

    thorc b d && thorc g b

    cd ../monochrome

    echo "Build monochome..."
    thorc b d

    ;;

c_st)
    cd ../mono_build
    make c_st_mono

    ;;

c_mt)
    cd ../mono_build
    make c_mt_mono

    ;;

opencv)
    cd ../mono_build
    make opencv_mono

    ;;

cuda)
    cd cuda
    nvcc cuda_monochrome.cu -o ../bin/cuda_mono -lSDL2 -lSDL2_image

    ;;

*)
    echo "What do you want?"
    ;;
esac

