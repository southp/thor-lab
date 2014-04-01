project "c_st"
    language "C"
    kind "ConsoleApp"

    links {
        "SDL2",
        "SDL2_image"
    }

    files {
        "monochrome.c",
        "mono_st.c"
    }

project "c_mt"
    language "C"
    kind "ConsoleApp"

    links {
        "SDL2",
        "SDL2_image",
        "pthread"
    }

    files {
        "monochrome.c",
        "mono_mt.c"
    }
