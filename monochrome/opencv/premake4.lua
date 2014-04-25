project "opencv_mono"
    language "C++"
    kind "ConsoleApp"

    includedirs {
        "../util"
    }

    -- FIXME: Somehow my opencv2 complained about not finding CUDA nppc.
    -- even though I didn't use opencv-gpu...
    libdirs {
        "/usr/local/cuda-5.5/targets/x86_64-linux/lib",
        "/home/southp/work/opencv-build/lib/"
    }

    links {
        "opencv_core",
        "opencv_highgui",
        "opencv_imgproc",
        "nppc",
        "util"
    }

    files {
        "opencv_monochrome.cpp"
    }

