# Package

version       = "1.0"
author        = "Earl Kennedy"
description   = "SFML Test"
license       = "MIT"

srcDir        = "src"
binDir        = "bin"

bin           = @["NimSnake"]
backend       = "cpp"

# Dependencies

requires "nim >= 0.17.2"

task debugBuild, "Debug Build":
    exec "nim cpp --d:debug --debugger:on --lineDir:on --debuginfo --run src/NimSFML.nim"