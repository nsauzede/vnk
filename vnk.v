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
pub:
mut:
	r f32
	g f32
	b f32
	a f32
}
//type NkColorF NkColorF0
