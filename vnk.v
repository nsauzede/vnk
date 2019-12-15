// Copyright(C) 2019 Nicolas Sauzede. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

// The vnk module uses the nice Nuklear library (see README.md)
module vnk

#flag -Insauzede/vnk
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

#flag linux -lGL -lGLEW

#flag windows -lopengl32 -lglew32

pub struct NkColorF {
pub mut:
	r f32
	g f32
	b f32
	a f32
}
//type NkColorF NkColorF0

type NkRect C.nk_rect
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
