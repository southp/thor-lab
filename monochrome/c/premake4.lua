project "c_st_mono"
    language "C"
    kind "ConsoleApp"

    includedirs{
        "../util/"
    }

    links {
        "SDL2",
        "SDL2_image",
        "util"
    }

    files {
        "monochrome.c",
        "mono_st.c"
    }

project "c_mt_mono"
    language "C"
    kind "ConsoleApp"

    includedirs{
        "../util/"
    }

    links {
        "SDL2",
        "SDL2_image",
        "pthread",
        "util"
    }

    files {
        "monochrome.c",
        "mono_mt.c"
    }
