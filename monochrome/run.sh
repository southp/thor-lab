#!/bin/bash

awesome=$PWD/awesome.png

if test "$1" = "thor"
then
    cd thor/monochrome
    thorc r test --domain=mt --args $awesome

elif test "$1" = "c_st"
then
    ./bin/c_st $awesome
else
    echo "What do you want?"
fi
