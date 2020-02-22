# vnk
V Nuklear module -- a nuklear wrapper in V language

If you are new to nuklear see [here](https://github.com/Immediate-Mode-UI/Nuklear)

If you are new to V language see [here](https://vlang.io/)

Current APIs available/tested in examples :
- create SDL2 / OpenGL window
- set clear color
- create nuklear subwindows
- create widgets : buttons, slider, text inputs, color picker, etc...
- persistent layout
- debug tools : FPS, stats, etc..

# Examples

See in examples/mainnk_v/mainnk_v.v

This is a V port of Nuklear sdl_opengl3 demo

# Dependencies
Ubuntu :
`$ sudo apt install git cmake libsdl2-dev libglew-dev libsdl2-ttf-dev libsdl2-mixer-dev`

ClearLinux :
`$ sudo swupd bundle-add git cmake devpkg-SDL2 devpkg-glew devpkg-SDL2_ttf devpkg-SDL2_mixer`

Windows/MSYS2 :
`$ pacman -S msys/git mingw64/mingw-w64-x86_64-cmake mingw64/mingw-w64-x86_64-SDL2 mingw64/mingw-w64-x86_64-glew mingw64/mingw-w64-x86_64-SDL2_ttf mingw64/mingw-w64-x86_64-SDL2_mixer`
