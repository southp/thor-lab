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
    case $opt in
    -g)
        echo "AAAA" $opt
        debug=1
        ;;
    esac
done

thor_exec_cmd(){
    entry_name=$1

    if test -z $debug
    then
        thorc r $entry_name --domain=mt --args $target
    else
        thorc r $entry_name -g --domain=mt --args $target
    fi
}

native_exec_cmd(){
    bin_name=$1

    if test -z $debug
    then
        ./bin/$bin_name $target
    else
        cgdb --args ./bin/$bin_name $target
    fi
}

case $impl in
thor_func)
    cd thor/monochrome
    thor_exec_cmd mono_function
    ;;

thor_per_pixel)
    cd thor/monochrome
    thor_exec_cmd mono_async_per_pixel
    ;;

thor_per_segment)
    cd thor/monochrome
    thor_exec_cmd mono_async_per_segment
    ;;

c_st)
    native_exec_cmd c_st_mono
    ;;

c_mt)
    native_exec_cmd c_mt_mono
    ;;

opencv)
    native_exec_cmd opencv_mono
    ;;

cuda)
    native_exec_cmd cuda_mono
    ;;

*)
    echo "What do you want?"
    ;;
esac

