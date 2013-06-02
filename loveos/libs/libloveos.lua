--[[
    Created by Jesse Horne 2013
    This library is used by LoveOS developers, to create awesome LoveOS applications to run on LoveOS. Because we love LoveOS.
]]--
function loveos:prints(str) -- Used for printing strings of text
  if str ~= "" then
    loveos_curr_table = {}
    loveos_curr_table.text = str
    loveos_curr_table.x = loveos_cursor_x
    loveos_curr_table.y = loveos_cursor_y - loveos_font_h
    table.insert(loveos_backlog, loveos_curr_table)
    for i,v in ipairs(loveos_backlog) do
      v.y = v.y - loveos_font_h
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
