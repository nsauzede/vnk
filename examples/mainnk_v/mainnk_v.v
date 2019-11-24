// V standalone example application for Nuklear + SDL2 + OpenGL
// based on nuklear sdl_opengl3 demo
// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module main
import nsauzede.vsdl2
import nsauzede.vnk
import os
import time

const (
	WINDOW_WIDTH = 400
	WINDOW_HEIGHT = 400
	MAX_VERTEX_MEMORY = 512 * 1024
	MAX_ELEMENT_MEMORY = 128 * 1024
)

enum Op {
	easy hard
}

struct AppState {
mut:
	build int
	win voidptr
	ctx voidptr
	win_width int
	win_height int
	op Op
	property int
}

[live]
fn (s mut AppState) live_main() {
//	mut
	bg := vnk.NkColorF{0.10, 0.18, 0.24, 1.0}
        if (1 == C.nk_begin(s.ctx, "Hello, Vorld!", C.nk_rect(50, 50, 230, 250),
            C.NK_WINDOW_BORDER|C.NK_WINDOW_MOVABLE|C.NK_WINDOW_SCALABLE|
            C.NK_WINDOW_MINIMIZABLE|C.NK_WINDOW_TITLE)) {

            C.nk_layout_row_static(s.ctx, 30, 80, 1)

            if 1 == C.nk_button_label(s.ctx, "button") {
                println('button pressed!')
            }
            C.nk_layout_row_dynamic(s.ctx, 30, 2)
            if 1 == C.nk_option_label(s.ctx, "easy", s.op == .easy) {
                s.op = .easy
            }
            if 1 == C.nk_option_label(s.ctx, "hard", s.op == .hard) {
                s.op = .hard
            }
            C.nk_layout_row_dynamic(s.ctx, 22, 1)
            C.nk_property_int(s.ctx, "Compression:", 0, &s.property, 100, 10, 1)

            C.nk_layout_row_dynamic(s.ctx, 20, 1)
            C.nk_label(s.ctx, "background:", C.NK_TEXT_LEFT)
            C.nk_layout_row_dynamic(s.ctx, 25, 1)
/*
            if (C.nk_combo_begin_color(s.ctx, C.nk_rgb_cf(bg), C.nk_vec2(C.nk_widget_width(s.ctx),400))) {
                C.nk_layout_row_dynamic(s.ctx, 120, 1)
                bg = C.nk_color_picker(s.ctx, bg, C.NK_RGBA)
                C.nk_layout_row_dynamic(s.ctx, 25, 1)
                bg.r = C.nk_propertyf(s.ctx, "#R:", 0, bg.r, 1.0, 0.01, 0.005)
                bg.g = C.nk_propertyf(s.ctx, "#G:", 0, bg.g, 1.0, 0.01, 0.005)
                bg.b = C.nk_propertyf(s.ctx, "#B:", 0, bg.b, 1.0, 0.01, 0.005)
                bg.a = C.nk_propertyf(s.ctx, "#A:", 0, bg.a, 1.0, 0.01, 0.005)
                C.nk_combo_end(s.ctx)
            }
*/
        }
        C.nk_end(s.ctx)
        C.SDL_GetWindowSize(s.win, &s.win_width, &s.win_height)
        C.glViewport(0, 0, s.win_width, s.win_height)
        C.glClear(C.GL_COLOR_BUFFER_BIT)
        C.glClearColor(bg.r, bg.g, bg.b, bg.a)
        C.nk_sdl_render(C.NK_ANTI_ALIASING_ON, MAX_VERTEX_MEMORY, MAX_ELEMENT_MEMORY)
        C.SDL_GL_SwapWindow(s.win)
}

fn main() {
	mut s := AppState{}
	s.build = time.now().uni
	println('build $s.build')

    C.SDL_SetHint(C.SDL_HINT_VIDEO_HIGHDPI_DISABLED, "0")
    C.SDL_Init(C.SDL_INIT_VIDEO|C.SDL_INIT_TIMER|C.SDL_INIT_EVENTS)
    s.win = C.SDL_CreateWindow("V Nuklear+SDL2+OpenGL3 Demo",
        C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH, WINDOW_HEIGHT, C.SDL_WINDOW_OPENGL|C.SDL_WINDOW_SHOWN|C.SDL_WINDOW_ALLOW_HIGHDPI)
    gl_context := C.SDL_GL_CreateContext(s.win)
    C.SDL_GL_SetAttribute (C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
    C.SDL_GL_SetAttribute (C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
    C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 3)
    C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
    s.win_width = 0
    s.win_height = 0
    C.SDL_GetWindowSize(s.win, &s.win_width, &s.win_height)
    C.glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    if C.glewInit() != C.GLEW_OK {
        println('Failed to setup GLEW')
        exit(1)
    }
    s.ctx = C.nk_sdl_init(s.win)
    /* Load Fonts: if none of these are loaded a default font will be used  */
    /* Load Cursor: if you uncomment cursor loading please hide the cursor */
    {
    //struct nk_font_atlas *atlas
    atlas := voidptr(0)
    C.nk_sdl_font_stash_begin(&atlas)
    /*struct nk_font *droid = nk_font_atlas_add_from_file(atlas, "../../../extra_font/DroidSans.ttf", 14, 0);*/
    /*struct nk_font *roboto = nk_font_atlas_add_from_file(atlas, "../../../extra_font/Roboto-Regular.ttf", 16, 0);*/
    /*struct nk_font *future = nk_font_atlas_add_from_file(atlas, "../../../extra_font/kenvector_future_thin.ttf", 13, 0);*/
    /*struct nk_font *clean = nk_font_atlas_add_from_file(atlas, "../../../extra_font/ProggyClean.ttf", 12, 0);*/
    /*struct nk_font *tiny = nk_font_atlas_add_from_file(atlas, "../../../extra_font/ProggyTiny.ttf", 10, 0);*/
    /*struct nk_font *cousine = nk_font_atlas_add_from_file(atlas, "../../../extra_font/Cousine-Regular.ttf", 13, 0);*/
    C.nk_sdl_font_stash_end()
    /*nk_style_load_all_cursors(ctx, atlas->cursors);*/
    /*nk_style_set_font(ctx, &roboto->handle);*/}

    s.op = .easy
    s.property = 20
//    struct C.nk_colorf bg
//    bg.r = 0.10, bg.g = 0.18, bg.b = 0.24, bg.a = 1.0
//    /*mut*/ bg = NkColorF{0.10, 0.18, 0.24, 1.0}
    mut running := true
    for running {
        evt := vsdl2.Event{}
        C.nk_input_begin(s.ctx)
        for C.SDL_PollEvent(&evt) > 0 {
            if int(evt._type) == C.SDL_QUIT {
                running = false
                goto cleanup
            }
            C.nk_sdl_handle_event(&evt)
        }
        C.nk_input_end(s.ctx)

        s.live_main()
    }

cleanup:
    C.nk_sdl_shutdown()
    C.SDL_GL_DeleteContext(gl_context)
    C.SDL_DestroyWindow(s.win)
    C.SDL_Quit()
}
