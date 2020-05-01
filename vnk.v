// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

// The vnk module uses the nice Nuklear library (see README.md)
module vnk

#flag -I@VROOT
#flag -DNK_INCLUDE_FIXED_TYPES
#flag -DNK_INCLUDE_STANDARD_IO
#flag -DNK_INCLUDE_STANDARD_VARARGS
#flag -DNK_INCLUDE_DEFAULT_ALLOCATOR
#flag -DNK_INCLUDE_VERTEX_BUFFER_OUTPUT
#flag -DNK_INCLUDE_FONT_BAKING
#flag -DNK_INCLUDE_DEFAULT_FONT
#flag -DNK_IMPLEMENTATION
#flag -DNK_SDL_GL3_IMPLEMENTATION

#include <GL/glew.h>
#include "nuklear.h"
#include "nuklear_sdl_gl3.h"
#include "vnk.h"

#flag linux -lGL -lGLEW

#flag windows -lopengl32 -lglew32

pub struct C.nk_colorf {
pub mut:
	r f32
	g f32
	b f32
	a f32
}
//pub type nk_colorf C.nk_colorf
pub struct C.nk_color {
pub mut:
	r byte
	g byte
	b byte
	a byte
}
pub struct C.nk_vec2 {
pub mut:
	x f32
	y f32
}

pub struct C.nk_rect {
	x f32
	y f32
	w f32
	h f32
}
fn C.nk_rgb_cf(c C.nk_colorf) C.nk_color
fn C.nk_widget_width(ctx voidptr) f32
fn C.nk_combo_begin_color(ctx voidptr, color C.nk_color, size C.nk_vec2) int
fn C.nk_color_picker(ctx voidptr, colorf C.nk_colorf, cfmt int) C.nk_colorf
fn C.nk_propertyf(ctx voidptr, name byteptr, min f32, val f32, max f32, step f32, inc_per_pixel f32) f32
fn C.nk_combo_end(ctx voidptr)
fn C.nk_rect(x f32, y f32, w f32, h f32) C.nk_rect
fn C.nk_begin(ctx voidptr, title byteptr, bounds NkRect, flags int) int
fn C.nk_layout_row_static(ctx voidptr, height f32, item_width int, cols int)
fn C.nk_button_label(ctx voidptr, title byteptr) int
fn C.nk_layout_row_dynamic(ctx voidptr, height f32, cols int)
fn C.nk_option_label(ctx voidptr, title byteptr, active int) int
fn C.nk_property_int(ctx voidptr, name byteptr, min int, val voidptr, max int, step int, inc_per_pixel f32)
fn C.nk_label(ctx voidptr, title byteptr, align int)
fn C.nk_end(ctx voidptr)
fn C.nk_sdl_render(nk_anti_aliasing int, max_vertex_buffer int, max_element_buffer int)
fn C.nk_sdl_init(win voidptr) voidptr
fn C.nk_sdl_font_stash_begin(atlas voidptr)
fn C.nk_sdl_font_stash_end()
fn C.nk_input_begin(ctx voidptr)
fn C.nk_sdl_handle_event(evt voidptr) int
fn C.nk_input_end(ctx voidptr)
fn C.nk_sdl_shutdown()
fn C.glViewport()
fn C.glClear()
fn C.glClearColor()
fn C.glewInit() int
fn C.nk_window_get_bounds() C.nk_rect

pub const (
  version = '0.1' // hack to avoid unused module warning in the main program
)
