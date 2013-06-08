loveos
=====

![ScreenShot](http://i.imgur.com/E7Ic1nq)

# What is LoveOS?
**LoveOS** is a "Virtual Operating-System" created by Jesse Horne with LÖVE. The goal was to create something, that anyone could add to their own LÖVE program, to give them something to interact with their game, or just for fun, that emulated a computer operating-system. If you are familiar with computercraft, then this should be pretty easy to understand.

# How do I put this in my game?
First you will need to install [Love](https://love2d.org/). This has only been tested with version 0.8.0
Then, put the _loveos_ folder that is inside this repo, into your games directory.
In your main.lua, you will need to require "loveos" then put the loveos:load(), loveos:update(dt), loveos:draw(), and loveos:keypressed(key) functions into the proper callbacks.
***

For example...
```lua
require("loveos")
function love.load()
  loveos:load()
end
function love.update(dt)
  loveos:update(dt)
end
function love.draw()
  loveos:draw()
end
function love.keypressed(key)
  loveos:keypressed(key)
end
```

Copyright (c) 2013 Jesse Horne
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell(as long as you donate 5%+ earnings to Jesse Horne himself)
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

