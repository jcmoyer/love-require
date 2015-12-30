# Deprecated

This library has been superseded by `love.filesystem.setRequirePath` and
`love.filesystem.getRequirePath` in love 0.10.0. Use those functions instead if
they are available.

# What's this?

love-require implements a better require function for LÖVE-based games. The
rationale for this module is that `require` does not respect `package.path` in
`.love` packages because LÖVE registers its own loader to handle loading
scripts from these packages correctly. With love-require you can control where
require looks for modules. This means that you can better organize your
projects by putting all of your third party dependencies into a directory called
`lib`, for example.

To use it, simply include it in the root folder of your project. Then, in
`main.lua`, add these lines to the top:

    local loverequire = require('love-require')
    loverequire.enable()

Then you can mount arbitrary directories to look for Lua modules in:

    loverequire.mount('lib')

Now when you `require('foo.bar.baz')`, `lib/foo/bar/baz.lua` will be the first
place looked at. If nothing is found there, love-require will delegate the call
to the default Lua `require` function, which will look at `foo/bar/baz.lua`.

# License

    This is free and unencumbered software released into the public domain.
    
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.
    
    In jurisdictions that recognize copyright laws, the author or authors
    of this software dedicate any and all copyright interest in the
    software to the public domain. We make this dedication for the benefit
    of the public at large and to the detriment of our heirs and
    successors. We intend this dedication to be an overt act of
    relinquishment in perpetuity of all present and future rights to this
    software under copyright law.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
    
    For more information, please refer to <http://unlicense.org/>
