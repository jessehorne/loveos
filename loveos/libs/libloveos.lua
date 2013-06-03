--[[
    Created by Jesse Horne 2013
    This library is used by LoveOS developers, to create awesome LoveOS applications to run on LoveOS. Because we love LoveOS.
]]--
function loveos:prints(str) -- Used for printing strings of text
  if str ~= "" then
    loveos.curr_table = {}
    loveos.curr_table.text = str
    loveos.curr_table.x = loveos.cursor_x
    loveos.curr_table.y = loveos.cursor_y - loveos.font_h
    table.insert(loveos.backlog, loveos.curr_table)
    for i,v in ipairs(loveos.backlog) do
      v.y = v.y - loveos.font_h
    end
  end
end

function loveos:reload(mod) -- reload module function
  if package.loaded[mod] ~= nil then
    package.loaded[mod] = nil
    require("loveos.libs." .. mod)
    loveos:prints("module reloaded!")
  end
end

function loveos:execute(file)
  dofile(file)
end
