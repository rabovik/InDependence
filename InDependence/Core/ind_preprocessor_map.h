/*
 *
 * Original source from: https://raw.github.com/swansontec/map-macro/88b436e0272507bb86139afd129d9d74f89bdba6/map.h
 * See also: http://stackoverflow.com/a/13459454/441735
 *
 */

/* 
 * Copyright (C) 2012 William Swanson
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the names of the authors or
 * their institutions shall not be used in advertising or otherwise to
 * promote the sale, use or other dealings in this Software without
 * prior written authorization from the authors.
 */

#ifndef _IND_MAP_H_INCLUDED
#define _IND_MAP_H_INCLUDED

#define _IND_EVAL0(...) __VA_ARGS__
#define _IND_EVAL1(...) _IND_EVAL0 (_IND_EVAL0 (_IND_EVAL0 (__VA_ARGS__)))
#define _IND_EVAL2(...) _IND_EVAL1 (_IND_EVAL1 (_IND_EVAL1 (__VA_ARGS__)))
#define _IND_EVAL3(...) _IND_EVAL2 (_IND_EVAL2 (_IND_EVAL2 (__VA_ARGS__)))
#define _IND_EVAL4(...) _IND_EVAL3 (_IND_EVAL3 (_IND_EVAL3 (__VA_ARGS__)))
#define _IND_EVAL(...)  _IND_EVAL4 (_IND_EVAL4 (_IND_EVAL4 (__VA_ARGS__)))

#define _IND_MAP_END(...)

#define _IND_MAP_OUT
#define _IND_MAP_GET_END() 0, _IND_MAP_END
#define _IND_MAP_NEXT0(item, next, ...) next _IND_MAP_OUT
#define _IND_MAP_NEXT1(item, next) _IND_MAP_NEXT0 (item, next, 0)
#define _IND_MAP_NEXT(item, next)  _IND_MAP_NEXT1 (_IND_MAP_GET_END item, next)

#define _IND_MAP0(f, x, peek, ...) \
    f(x) _IND_MAP_NEXT (peek, _IND_MAP1) (f, peek, __VA_ARGS__)
#define _IND_MAP1(f, x, peek, ...) \
    f(x) _IND_MAP_NEXT (peek, _IND_MAP0) (f, peek, __VA_ARGS__)
#define _IND_MAP(f, ...) _IND_EVAL (_IND_MAP1 (f, __VA_ARGS__, (), 0))

#endif
