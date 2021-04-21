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

// pub type nk_colorf C.nk_colorf
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

pub struct C.nk_image {
pub:
	handle voidptr
	w      u16
	h      u16
	region [4]u16
}

fn C.glGenTextures(n u32, textures u32)
fn C.glBindTexture(target int, texture u32)
fn C.glTexParameterf(target int, pname int, param f32)
fn C.glGenerateMipmap(target int)

fn C.nk_subimage_id(id int, w u16, h u16, sub_region C.nk_rect) C.nk_image
fn C.nk_window_get_canvas(ctx voidptr) voidptr
fn C.nk_draw_image(ptr voidptr, rect C.nk_rect, img voidptr, col C.nk_color)
fn C.nk_image_color(ctx voidptr, img C.nk_image, col C.nk_color)
fn C.nk_button_image_label(ctx voidptr, img C.nk_image, label &char, text_alignment int) bool
fn C.nk_image_id(tex int) C.nk_image
fn C.nk_rgb_cf(c C.nk_colorf) C.nk_color
fn C.nk_widget_width(ctx voidptr) f32
fn C.nk_combo_begin_color(ctx voidptr, color C.nk_color, size C.nk_vec2) int
fn C.nk_color_picker(ctx voidptr, colorf C.nk_colorf, cfmt int) C.nk_colorf
fn C.nk_propertyf(ctx voidptr, name &byte, min f32, val f32, max f32, step f32, inc_per_pixel f32) f32
fn C.nk_combo_end(ctx voidptr)
fn C.nk_rect(x f32, y f32, w f32, h f32) C.nk_rect
fn C.nk_begin(ctx voidptr, title &byte, bounds C.nk_rect, flags int) int
fn C.nk_layout_row_static(ctx voidptr, height f32, item_width int, cols int)
fn C.nk_button_label(ctx voidptr, title &byte) int
fn C.nk_layout_row_dynamic(ctx voidptr, height f32, cols int)
fn C.nk_option_label(ctx voidptr, title &byte, active int) int
fn C.nk_property_int(ctx voidptr, name &byte, min int, val voidptr, max int, step int, inc_per_pixel f32)
fn C.nk_label(ctx voidptr, title &byte, align int)
fn C.nk_text(ctx voidptr, title &byte, flags int)
fn C.nk_end(ctx voidptr)
fn C.nk_sdl_render(nk_anti_aliasing int, max_vertex_buffer int, max_element_buffer int)
fn C.nk_sdl_init(win voidptr) voidptr
fn C.nk_sdl_font_stash_begin(atlas voidptr)
fn C.nk_sdl_font_stash_end()
fn C.nk_input_begin(ctx voidptr)
fn C.nk_sdl_handle_event(evt voidptr) int
fn C.nk_input_end(ctx voidptr)
fn C.nk_sdl_shutdown()
fn C.glViewport(x int, y int, width int, height int)
fn C.glClear(mask int)
fn C.glClearColor(red f32, green f32, blue f32, alpha f32)
fn C.glewInit() int
fn C.nk_window_get_bounds(ctx voidptr) C.nk_rect
fn C.nk_popup_begin(nk_context voidptr, nk_popup_type int, charp &char, nk_flags int, bounds C.nk_rect) bool
fn C.nk_popup_end(nk_context voidptr)
fn C.nk_font_atlas_add_from_file(atlas voidptr, file_path &char, height f32, config voidptr) voidptr

pub const (
	version = '0.1' // hack to avoid unused module warning in the main program
)
