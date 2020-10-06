// V standalone example application for Nuklear + SDL2 + OpenGL
// based on nuklear sdl_opengl3 demo
// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module main
import nsauzede.vsdl2 as sdl
import nsauzede.vnk
import os
import time

const (
	window_width = 400
	window_height = 400
	max_vertex_memory = 512 * 1024
	max_element_memory = 128 * 1024
)

enum Op {
	easy hard
}

struct AppState {
mut:
	hide_window bool
	nkw_rect C.nk_rect = C.nk_rect{50, 50, 230, 250}
	bg C.nk_colorf
	last_time int
	frames int
	fps int
	win voidptr
	ctx voidptr
	win_width int
	win_height int
	op Op
	property int
}

// these kludges are workaround for "the following imports were never used"
// until these annoyances are fixed
const (
  vnk_version = vnk.version
  sdl_version = sdl.version
  os_maxpath = os.max_path_len
)

[live]
fn (mut s AppState) live_main() {
	if !s.hide_window {
	if 1 == C.nk_begin(s.ctx, "Hello, Vorld! VVVV", s.nkw_rect, 0
//		| C.NK_WINDOW_BORDER
		| C.NK_WINDOW_MOVABLE
		| C.NK_WINDOW_SCALABLE
		| C.NK_WINDOW_MINIMIZABLE
		| C.NK_WINDOW_TITLE
		) {
		s.nkw_rect = C.nk_window_get_bounds(s.ctx)

		C.nk_layout_row_static(s.ctx, 30, 80, 1)

		if 1 == C.nk_button_label(s.ctx, "Click Me!") {
			mode := if s.op == .easy {"Easy"} else {"Hard"}
			r := s.bg.r * 255
			g := s.bg.g * 255
			b := s.bg.b * 255
			println('button pressed! mode=$mode compr=$s.property r=$r g=$g b=$b')
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

		t := time.now().unix
		s.frames++
		fps := 'Application average $s.fps FPS'
		if t > s.last_time {
			s.fps = s.frames
			s.frames = 0
		}
		s.last_time = int(t)
		C.nk_label(s.ctx, fps.str, C.NK_TEXT_LEFT)

		C.nk_layout_row_dynamic(s.ctx, 20, 1)
		C.nk_label(s.ctx, "background:", C.NK_TEXT_LEFT)
		C.nk_layout_row_dynamic(s.ctx, 25, 1)
		size := C.nk_vec2{C.nk_widget_width(s.ctx),400}
		if 1 == C.nk_combo_begin_color(s.ctx, C.nk_rgb_cf(s.bg), size) {
			C.nk_layout_row_dynamic(s.ctx, 120, 1)
			s.bg = C.nk_color_picker(s.ctx, s.bg, C.NK_RGBA)
			C.nk_layout_row_dynamic(s.ctx, 25, 1)
			s.bg.r = C.nk_propertyf(s.ctx, "#R:", 0, s.bg.r, 1.0, 0.01, 0.005)
			s.bg.g = C.nk_propertyf(s.ctx, "#G:", 0, s.bg.g, 1.0, 0.01, 0.005)
			s.bg.b = C.nk_propertyf(s.ctx, "#B:", 0, s.bg.b, 1.0, 0.01, 0.005)
			s.bg.a = C.nk_propertyf(s.ctx, "#A:", 0, s.bg.a, 1.0, 0.01, 0.005)
			C.nk_combo_end(s.ctx)
		}
	}
	C.nk_end(s.ctx)
	}
	C.SDL_GetWindowSize(s.win, &s.win_width, &s.win_height)
	C.glViewport(0, 0, s.win_width, s.win_height)
	C.glClear(C.GL_COLOR_BUFFER_BIT)
	C.glClearColor(s.bg.r, s.bg.g, s.bg.b, s.bg.a)
	C.nk_sdl_render(C.NK_ANTI_ALIASING_ON, max_vertex_memory, max_element_memory)
	C.SDL_GL_SwapWindow(s.win)
}

fn main() {
	mut s := AppState{win:0 ctx:0}
	s.last_time = int(time.now().unix)

	C.SDL_SetHint(C.SDL_HINT_VIDEO_HIGHDPI_DISABLED, "0")
	C.SDL_Init(C.SDL_INIT_VIDEO|C.SDL_INIT_TIMER|C.SDL_INIT_EVENTS)
	s.win = C.SDL_CreateWindow("Live! V Nuklear+SDL2+OpenGL3 demo",
	C.SDL_WINDOWPOS_CENTERED, C.SDL_WINDOWPOS_CENTERED,
	window_width, window_height, C.SDL_WINDOW_OPENGL|C.SDL_WINDOW_SHOWN|C.SDL_WINDOW_ALLOW_HIGHDPI)
	gl_context := C.SDL_GL_CreateContext(s.win)
	C.SDL_GL_SetAttribute (C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
	C.SDL_GL_SetAttribute (C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
	C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MAJOR_VERSION, 3)
	C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_MINOR_VERSION, 3)
	C.SDL_GL_SetAttribute(C.SDL_GL_DOUBLEBUFFER, 1)
	s.win_width = 0
	s.win_height = 0
	C.SDL_GetWindowSize(s.win, &s.win_width, &s.win_height)
	C.glViewport(0, 0, window_width, window_height)
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
		/*nk_style_set_font(ctx, &roboto->handle);*/
	}

	s.op = .easy
	s.property = 20
	bg := C.nk_colorf{0.10, 0.18, 0.24, 1.0}
	s.bg = bg
	mut running := true
	for running {
		evt := sdl.Event{}
		C.nk_input_begin(s.ctx)
		for C.SDL_PollEvent(&evt) > 0 {
			if int(evt.@type) == C.SDL_QUIT {
				running = false
				goto cleanup
			}
			if evt.@type == C.SDL_KEYDOWN {
				if evt.key.keysym.sym == C.SDLK_l {
					s.hide_window = !s.hide_window
				}
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
