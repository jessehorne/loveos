--[[
    Created by Jesse Horne 2013
    This library is used by LoveOS developers, to create awesome LoveOS applications to run on LoveOS. Because we love LoveOS.
]]--
function loveos:prints(str) -- Used for printing strings of text
  loveos.term:feed(str)
  loveos.term:update()
end
