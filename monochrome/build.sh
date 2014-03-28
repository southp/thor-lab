#!/bin/bash

set -e

if ! test -e ../mono_build
then
    premake4 gmake
fi

if test "$1" = "thor"
then
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

elif test "$1" = "c_st"
then
    cd ../mono_build
    make c_st
else
    echo "What do you want?"
fi
