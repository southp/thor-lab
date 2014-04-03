solution "monochrome"
    configurations {"debug", "release"}
    targetdir "bin"
    location  "../mono_build"

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

    include "c"

    include "opencv"

