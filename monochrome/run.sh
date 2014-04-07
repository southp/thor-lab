#!/bin/bash

impl=$1
target=$2

if test -z $target
then
    target=$PWD/awesome.png
else
    target=$PWD/$2
fi

shift 2
options=$@

for opt in $@
do
    if test $opt=-g
    then
        debug=1
    fi
done

thor_exec_cmd(){
    entry_name=$1
    is_debug=$2

    if test -z $is_debug
    then
        thorc r $entry_name -g --domain=mt --args $target
    else
        thorc r $entry_name --domain=mt --args $target
    fi
}


case $impl in
thor_func)
    cd thor/monochrome
    thor_exec_cmd mono_function $debug
    ;;

thor_per_pixel)
    cd thor/monochrome
    thor_exec_cmd mono_async_per_pixel $debug
    ;;

thor_per_segment)
    cd thor/monochrome
    thor_exec_cmd mono_async_per_segment $debug
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

