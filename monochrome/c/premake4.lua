solution "monochrome"
    configurations {"debug", "release"}
    language  "C"
    targetdir "bin"
    location  "build"

    configuration "debug"
        defines {
            "DEBUG"
        }
        flags {
            "Symbols"
        }

    configuration "release"
        defines {
            "NDEBUG"
        }
        flags {
            "Optimize"
        }

    project "c_monochrome"
        kind "ConsoleApp"

        links {
            "SDL2",
            "SDL2_image"
        }

        files {
            "monochrome.c"
        }
