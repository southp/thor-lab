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

    include "c"

