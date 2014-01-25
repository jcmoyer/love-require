-- This is free and unencumbered software released into the public domain.
--
-- Anyone is free to copy, modify, publish, use, compile, sell, or
-- distribute this software, either in source code form or as a compiled
-- binary, for any purpose, commercial or non-commercial, and by any
-- means.
--
-- In jurisdictions that recognize copyright laws, the author or authors
-- of this software dedicate any and all copyright interest in the
-- software to the public domain. We make this dedication for the benefit
-- of the public at large and to the detriment of our heirs and
-- successors. We intend this dedication to be an overt act of
-- relinquishment in perpetuity of all present and future rights to this
-- software under copyright law.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
-- OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
--
-- For more information, please refer to <http://unlicense.org/>

--- Implements a better require for LÖVE-based games.
-- The rationale for this module is that `require` does not respect
-- `package.path` in `.love` packages because LÖVE registers its own loader
-- to handle loading scripts from these packages correctly.
--
-- @usage
-- -- Method 1 (preferred)
-- -- Replaces the global require so that modules you require go through this
-- -- module when they require modules of their own.
-- local loverequire = require('love-require')
-- loverequire.mount('lib')
-- loverequire.enable()
-- local bar = require('foo.bar') -- this will find lib/foo/bar.lua
--
-- -- Method 2
-- -- Only works as long as modules you require do not require modules that
-- -- rely on directories mounted via love-require.
-- local loverequire = require('love-require')
-- loverequire.mount('lib')
-- local bar = loverequire('foo.bar') -- this will find lib/foo/bar.lua

local M = {}

local _require = require
local modtable = {}

--- Mounts a directory to look for modules in.
-- @string dir Directory name to mount. Case sensitive.
function M.mount(dir)
  table.insert(modtable, dir)
end

--- Unmounts a directory.
-- @string dir Directory name to unmount. Case sensitive.
function M.unmount(dir)
  for i = #modtable, 1, -1 do
    if modtable[i] == dir then
      table.remove(modtable, i)
    end
  end
end

--- Requires a module.
-- First, this function looks at `package.loaded` to see if a module called
-- `name` has already been loaded. If it has, it is returned. If no module by
-- this name has been loaded, each of the mounted directories are searched for
-- a suitable module to load. If one is found, it is stored in `package.loaded`
-- by `name`. If the named module is not found in any mounted directories, this
-- function falls back to Lua's default `require` implementation.
-- @string name The name of the module to require.
-- @return The result of executing the named module if it exists.
function M.require(name)
  local value = package.loaded[name]
  if value then
    return value
  end
  for i = 1, #modtable do
    local filename = modtable[i] .. '/' .. name:gsub('%.', '/') .. '.lua'
    if love.filesystem.exists(filename) then
      local chunk = love.filesystem.load(filename)
      value = chunk()
      package.loaded[name] = value
      return value
    end
  end
  return _require(name)
end

--- Sets love-require as the global `require` function.
function M.enable()
  require = M.require
end

--- Restores the default global `require` function.
function M.disable()
  require = _require
end

--- Implements the `__call` metamethod for this module.
-- Calling this table will return the result of calling `M.require`.
function M.__call(...)
  return M.require(...)
end

return setmetatable(M, M)
