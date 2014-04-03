#!/bin/bash

impl=$1
target=$2

if test -z $2
then
    target=$PWD/awesome.png
else
    target=$2
fi

case $impl in
thor)
    cd thor/monochrome
    thorc r test --domain=mt --args $target
    ;;

c_st)
    ./bin/c_st_mono $target
    ;;

c_mt)
    ./bin/c_mt_mono $target
    ;;

opencv)
    ./bin/opencv_mono $target
    ;;

cuda)
    ./bin/cuda_mono $target
    ;;

*)
    echo "What do you want?"
    ;;
esac

