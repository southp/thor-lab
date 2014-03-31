#!/bin/bash

awesome=$PWD/awesome.png

case $1 in
thor)
    cd thor/monochrome
    thorc r test --domain=mt --args $awesome
    ;;

c_st)
    ./bin/c_st $awesome
    ;;

c_mt)
    ./bin/c_mt $awesome
    ;;

*)
    echo "What do you want?"
    ;;
esac

