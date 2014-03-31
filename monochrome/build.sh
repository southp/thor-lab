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

    g++ -I../dep/system.bundle/src -std=c++11 -fPIC -g -c imgutil.cpp

    cd ..

    thorc b d && thorc g b

    cd ../monochrome

    echo "Build monochome..."
    thorc b d

    ;;

c_st)
    cd ../mono_build
    make c_st

    ;;

*)
    echo "What do you want?"
    ;;
esac

