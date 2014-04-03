project "opencv_mono"
    language "C++"
    kind "ConsoleApp"

    -- FIXME: Somehow my opencv2 complained about not finding CUDA nppc.
    -- even though I didn't use opencv-gpu...
    libdirs {
        "/usr/local/cuda-5.5/targets/x86_64-linux/lib"
    }

    links {
        "opencv_core",
        "opencv_highgui",
        "opencv_imgproc",
        "nppc"
    }

    files {
        "opencv_monochrome.cpp"
    }

