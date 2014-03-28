#!/bin/bash

awesome=$PWD/awesome.png

if test "$1" = "thor"
then
    cd thor/monochrome
    thorc r test --domain=mt --args $awesome
fi
