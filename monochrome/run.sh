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

*)
    echo "What do you want?"
    ;;
esac

