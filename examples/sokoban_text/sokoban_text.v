// Text-mode Sokoban in V with Nuklear + SDL2 + OpenGL
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
	zoom               = 1
	font_height        = 10
	window_width       = 400
	window_height      = 400
	debug_width        = window_width
	debug_height       = 160
	max_vertex_memory  = 512 * 1024
	max_element_memory = 128 * 1024
)

// these kludges are workaround for "the following imports were never used"
// until these annoyances are fixed
const (
	vnk_version = vnk.version
	sdl_version = sdl.version
	os_maxpath  = os.max_path_len
)

const (
	c_empty   = ` `
	c_store   = `.`
	c_stored  = `*`
	c_crate   = `$`
	c_player  = `@`
	c_splayer = `+`
	c_wall    = `#`
)

struct State {
mut:
	hide_window bool
	nkw_rect    C.nk_rect = C.nk_rect{0, window_height - debug_height, debug_width, debug_height}
	bg          C.nk_colorf
	last_time   int
	frames      int
	fps         int
	win         voidptr
	ctx         voidptr
	win_width   int
	win_height  int
	// Game state
	w           int
	h           int
	px          int
	py          int
	moves       int
	pushes      int
	map         [][]rune
}

[live]
fn (mut s State) live_main() {
	mut stored := 0
	mut crates := 0
	rec := C.nk_rect{0, 0, window_width, window_height}
	if 1 == C.nk_begin(s.ctx, 'Hello world', rec, C.NK_WINDOW_BACKGROUND) {
		C.nk_layout_row_dynamic(s.ctx, font_height * zoom, 1)
		s.h = 0
		for j, ar in s.map {
			s.w = 0
			for i, ch in ar {
				match ch {
					c_player {
						s.px = i
						s.py = j
					}
					c_splayer {
						s.px = i
						s.py = j
					}
					c_crate {
						crates++
					}
					c_stored {
						stored++
						crates++
					}
					else {}
				}
				s.w++
			}
			s.h++
			// we must convert ar : array of rune to array of byte for nk_label
			mut ab := []byte{}
			for b in ar {
				ab << b
			}
			C.nk_label(s.ctx, ab.data, C.NK_TEXT_LEFT)
		}
		mut status := ''
		if stored == crates {
			status = 'YOU WIN!'
		}
		C.nk_label(s.ctx, 'moves=$s.moves pushes=$s.pushes $status'.str, C.NK_TEXT_LEFT)
	}
	C.nk_end(s.ctx)
	if !s.hide_window {
		if 1 == C.nk_begin(s.ctx, 'Debug [l]', s.nkw_rect, 0 | C.NK_WINDOW_BORDER | C.NK_WINDOW_MOVABLE |
			C.NK_WINDOW_SCALABLE | C.NK_WINDOW_MINIMIZABLE | C.NK_WINDOW_TITLE) {
			s.nkw_rect = C.nk_window_get_bounds(s.ctx)
			C.nk_layout_row_dynamic(s.ctx, font_height * zoom, 1)
			C.nk_label(s.ctx, '$s.fps FPS'.str, C.NK_TEXT_LEFT)
			C.nk_label(s.ctx, 'w=$s.w h=$s.h'.str, C.NK_TEXT_LEFT)
			C.nk_label(s.ctx, 'px=$s.px py=$s.py'.str, C.NK_TEXT_LEFT)
			C.nk_label(s.ctx, 'stored=$stored crates=$crates'.str, C.NK_TEXT_LEFT)
			s.frames++
			t := time.now().unix
			if t > s.last_time {
				s.fps = s.frames
				s.frames = 0
			}
			s.last_time = int(t)
		}
		C.nk_end(s.ctx)
	}
	C.SDL_GetWindowSize(s.win, &s.win_width, &s.win_height)
	C.glViewport(0, 0, s.win_width, s.win_height)
	C.glClear(C.GL_COLOR_BUFFER_BIT)
	C.glClearColor(s.bg.r, s.bg.g, s.bg.b, s.bg.a)
	C.nk_sdl_render(C.NK_ANTI_ALIASING_ON, max_vertex_memory, max_element_memory)
	C.SDL_GL_SwapWindow(s.win)
	time.sleep_ms(1000 / 60)
}

fn (s State) can_move(x int, y int) bool {
	if x < s.w && y < s.h {
		e := s.map[y][x]
		if e == c_empty || e == c_store {
			return true
		}
	}
	return false
}

fn (mut s State) try_move(dx int, dy int) bool {
	mut do_it := false
	x := s.px + dx
	y := s.py + dy
	if s.map[y][x] == c_crate || s.map[y][x] == c_stored {
		to_x := x + dx
		to_y := y + dy
		if s.can_move(to_x, to_y) {
			do_it = true
			s.pushes++
			s.map[y][x] = match s.map[y][x] {
				c_stored { c_store }
				else { c_empty }
			}
			s.map[to_y][to_x] = match s.map[to_y][to_x] {
				c_store { c_stored }
				else { c_crate }
			}
		}
	} else {
		do_it = s.can_move(x, y)
	}
	if do_it {
		s.moves++
		s.map[s.py][s.px] = match s.map[s.py][s.px] {
			c_splayer { c_store }
			else { c_empty }
		}
		s.px = x
		s.py = y
		s.map[s.py][s.px] = match s.map[s.py][s.px] {
			c_store { c_splayer }
			else { c_player }
		}
	}
	return do_it
}

fn main() {
	mut s := State{
		win: 0
		ctx: 0
	}
	s.map = [
		[`#`, `#`, `#`, `#`, `#`, `#`],
		[`#`, ` `, ` `, ` `, ` `, `#`],
		[`#`, `@`, `$`, ` `, ` `, `#`],
		[`#`, ` `, ` `, `.`, ` `, `#`],
		[`#`, `#`, `#`, `#`, `#`, `#`],
	]
	s.last_time = int(time.now().unix)
	C.SDL_SetHint(C.SDL_HINT_VIDEO_HIGHDPI_DISABLED, '0')
	C.SDL_Init(C.SDL_INIT_VIDEO | C.SDL_INIT_TIMER | C.SDL_INIT_EVENTS)
	s.win = C.SDL_CreateWindow('Live! V Nuklear+SDL2+OpenGL3 demo', C.SDL_WINDOWPOS_CENTERED,
		C.SDL_WINDOWPOS_CENTERED, window_width, window_height, C.SDL_WINDOW_OPENGL | C.SDL_WINDOW_SHOWN |
		C.SDL_WINDOW_ALLOW_HIGHDPI)
	gl_context := C.SDL_GL_CreateContext(s.win)
	C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_FLAGS, C.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
	C.SDL_GL_SetAttribute(C.SDL_GL_CONTEXT_PROFILE_MASK, C.SDL_GL_CONTEXT_PROFILE_CORE)
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
	s.ctx = C.nk_sdl_init(s.win) // Load Fonts: if none of these are loaded a default font will be used // Load Cursor: if you uncomment cursor loading please hide the cursor
	{
		// struct nk_font_atlas *atlas
		atlas := voidptr(0)
		C.nk_sdl_font_stash_begin(&atlas)
		/*
		struct nk_font *droid = nk_font_atlas_add_from_file(atlas, "../../../extra_font/DroidSans.ttf", 14, 0);
		struct nk_font *roboto = nk_font_atlas_add_from_file(atlas, "../../../extra_font/Roboto-Regular.ttf", 16, 0);
		struct nk_font *future = nk_font_atlas_add_from_file(atlas, "../../../extra_font/kenvector_future_thin.ttf", 13, 0); // struct nk_font *clean = nk_font_atlas_add_from_file(atlas, "../../../extra_font/ProggyClean.ttf", 12, 0); // struct nk_font *tiny = nk_font_atlas_add_from_file(atlas, "../../../extra_font/ProggyTiny.ttf", 10, 0); // struct nk_font *cousine = nk_font_atlas_add_from_file(atlas, "../../../extra_font/Cousine-Regular.ttf", 13, 0);
		*/
		// C.nk_font_atlas_add_from_file(atlas, 'RobotoMono-Regular.ttf', 16, 0)
		C.nk_sdl_font_stash_end() // nk_style_load_all_cursors(ctx, atlas->cursors); // nk_style_set_font(ctx, &roboto->handle);
		/*
		C.nk_font_atlas_init_default(&atlas)
		C.nk_font_atlas_begin(&atlas)
		font := C.nk_font_atlas_add_from_file(&atlas, "RobotoMono-Regular.ttf", 13, 0)
		mut img_width := 0
		mut img_height := 0
		image := C.nk_font_atlas_bake(&atlas, &img_width, &img_height, C.NK_FONT_ATLAS_RGBA32)
		//device_upload_atlas(&device, image, img_width, img_height)
		glGenTextures(1, &dev->font_tex);
		C.nk_font_atlas_end(&atlas, C.nk_handle_id(device.font_tex), 0)
		C.nk_init_default(&ctx, &font->handle)
		*/
		// maybe use :
		// nk_font_atlas_add_default(atlas, 13.0f * 2, 0)
	}
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
				if evt.key.keysym.sym == C.SDLK_ESCAPE {
					running = false
					goto cleanup
				}
				if evt.key.keysym.sym == C.SDLK_l {
					s.hide_window = !s.hide_window
				}
				if evt.key.keysym.sym == C.SDLK_UP {
					s.try_move(0, -1)
				}
				if evt.key.keysym.sym == C.SDLK_DOWN {
					s.try_move(0, 1)
				}
				if evt.key.keysym.sym == C.SDLK_LEFT {
					s.try_move(-1, 0)
				}
				if evt.key.keysym.sym == C.SDLK_RIGHT {
					s.try_move(1, 0)
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
