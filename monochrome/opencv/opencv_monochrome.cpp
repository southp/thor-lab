// code courtesy of opencv tutorial:
// http://docs.opencv.org/doc/tutorials/introduction/load_save_image/load_save_image.html#load-save-image
//

#include <stdio.h>

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>

#include "timer.h"

using namespace cv;

int main( int argc, char** argv )
{
    char* imageName = argv[1];

    Mat image;
    image = imread( imageName, 1 );

    if( argc != 2 || !image.data )
    {
        printf( " No image data \n " );
        return -1;
    }

    Mat gray_image;

    begin_timing();
        cvtColor( image, gray_image, CV_BGR2GRAY );
    end_timing();

    namedWindow( imageName, CV_WINDOW_AUTOSIZE );
    namedWindow( "Gray image", CV_WINDOW_AUTOSIZE );

    imshow( imageName, image );
    imshow( "Gray image", gray_image );

    waitKey(0);

    return 0;
}

