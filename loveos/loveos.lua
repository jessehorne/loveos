loveos = {}

loveos.commands = {}
loveos.cmd_num = 0

loveos.fs = {}
loveos.fs.dirs = {}
loveos.fs.dirs["home"] = {}
loveos.fs.dir = "home"

loveos.screen_width = 800
loveos.screen_height = 600
loveos.start_x = 100
loveos.start_y = 20

loveos.font = love.graphics.newFont("loveos/font.ttf", 20)
loveos.dir = "~"
loveos.cursor_default = "$"
loveos.font_w = loveos.font:getWidth(loveos.cursor_default)
loveos.font_h = loveos.font:getHeight(loveos.cursor_default)
loveos.cursor_x = loveos.start_x + 10
loveos.cursor_y = loveos.start_y + (loveos.screen_height - 10 - loveos.font_h)
loveos.cursor_orig = loveos.dir .. loveos.fs.dir .. loveos.cursor_default
loveos.cursor = loveos.cursor_orig
loveos.backlog_max = 28
loveos.upper = false
loveos.is_letter = false

require("loveos.libs.libloveos")
require("loveos.libs.filesystem")

local disabled_keys = { --keys to disable in case they are not in use.
  "up","down","left","right","home","end","pageup","pagedown","return",--Navigation keys
  "insert","tab","clear","delete","backspace","rshift","lshift","lctrl","rctrl",--Editing keys
  "f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","f13","f14","f15",--Function keys
  "numlock","scrollock","ralt","lalt","rmeta","lmeta","lsuper","rsuper","mode","compose",--Modifier keys
  "pause","escape","help","print","sysreq","break","menu","power","euro","undo",--Miscellaneous keys
  "capslock"
}

local letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
                  "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"} 

local keys_with_upper = {["1"] = "!", ["2"] = "@", ["3"] = "#", ["4"] = "$", ["5"] = "%", ["6"] = "^",
                         ["7"] = "&", ["8"] = "*", ["9"] = "(", ["0"] = ")", ["-"] = "_", ["="] = "+",
                         ["["] = "{", ["]"] = "}", ["\\"] = "|", [";"] = ":", ["'"] = "\"", [","] = "<",
                         ["."] = ">", ["/"] = "?", ["`"] = "~" }

function string:split(sep) -- String splitting function
	local sep, fields = sep or " ", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function loveos:load() -- Load

  love.graphics.setFont(loveos.font)
  
  loveos.backlog = {}
  loveos.curr_string = {}

  loveos.welcome_msg = {} 
  for i=1, 4 do loveos.welcome_msg[i] = {} end
  table.insert(loveos.welcome_msg[1], "loveos-Created by Jesse Horne")
  table.insert(loveos.welcome_msg[2], "(github.com/jessehorne)")
  table.insert(loveos.welcome_msg[3], "Configuring stuff...")
  table.insert(loveos.welcome_msg[4], "Booted!")
  for i,v in ipairs(loveos.welcome_msg) do
    loveos:printt(v)
  end

  loveos.cursor_place = #loveos.cursor

end

function loveos:printt(str)
  if table.concat(str) ~= "" then
    loveos.curr_table = {}
    loveos.curr_table.text = table.concat(str)
    loveos.curr_table.x = loveos.cursor_x
    loveos.curr_table.y = loveos.cursor_y - loveos.font_h
    table.insert(loveos.backlog, loveos.curr_table)
    for i,v in ipairs(loveos.backlog) do
      v.y = v.y - loveos.font_h
    end
  end
end

function loveos:update(dt) -- Update
  loveos.cursor_x = loveos.start_x + 10 + #loveos.cursor
  loveos.cursor_y = loveos.start_y + (loveos.screen_height - 10 - loveos.font_h)
  loveos.cursor = loveos.dir .. loveos.fs.dir .. loveos.cursor_default
  if loveos.curr_string[1] == nil then loveos.cursor_place = #loveos.cursor end
end

function loveos:draw() -- Draw
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", loveos.start_x, loveos.start_y, loveos.screen_width, loveos.screen_height)
  love.graphics.setColor(150,150,150)
  love.graphics.setLine(10)
  love.graphics.rectangle("line", loveos.start_x, loveos.start_y, loveos.screen_width, loveos.screen_height)
  love.graphics.setLine(1)
  love.graphics.setColor(255,255,255)
  love.graphics.print(loveos.cursor, loveos.cursor_x, loveos.cursor_y)

  -- Draw Current line
  love.graphics.print(table.concat(loveos.curr_string), loveos.cursor_x + (#loveos.cursor*loveos.font_w) + loveos.font_w, loveos.cursor_y)

  -- Draw backlog
  for i,v in ipairs(loveos.backlog) do
    if i > (#loveos.backlog - loveos.backlog_max) then love.graphics.print(v.text, loveos.start_x + 10, loveos.start_y + v.y) end
  end

  -- Draw Cursor
  love.graphics.rectangle("fill", loveos.cursor_x + (loveos.cursor_place*loveos.font_w)+loveos.font_w, loveos.cursor_y, loveos.font_w, loveos.font_h)

end

function loveos:keypressed(key) -- Keypressed

  loveos.can_put = true
  for i,v in ipairs(disabled_keys) do
    if key == v then
      loveos.can_put = false
      break
    end
  end
  if key == "return" then -- Return
    local temp_str = loveos.curr_string
    --table.insert(loveos.temp_str, 1, "> ")
    loveos.curr_string = table.concat(loveos.curr_string)
    loveos.curr_string = loveos.curr_string:split(" ")
    local command = loveos.curr_string[1]
    table.remove(loveos.curr_string, 1)
    loveos:printt({"> ", unpack(temp_str)})
    --table.remove(loveos.temp_str, 1)
    if loveos.commands[command] then
      loveos.commands[command].func(unpack(loveos.curr_string))
    elseif command then
      loveos:prints("No such command: " .. command)
    end
    loveos.curr_string = {}
  elseif key == "backspace" then -- Backspace
    table.remove(loveos.curr_string, #loveos.curr_string)
    if loveos.cursor_place > #loveos.cursor then loveos.cursor_place = loveos.cursor_place - 1 end
  elseif key == "rshift" or key == "lshift" then
    loveos.upper = true
  end
  if loveos.can_put == true then
    if #loveos.curr_string < 46 then -- Checks to make sure the current string isnt to large
      loveos.cursor_place = loveos.cursor_place + 1 -- Adds 1 space to the cursor
      if loveos.upper == true then -- Handles Uppercase
        for i,v in ipairs(letters) do 
          if key == v then 
            key = string.upper(key)
            loveos.is_letter = true
          end 
        end
        if loveos.is_letter == false then key = keys_with_upper[key] end
      end
      loveos.is_letter = false
      table.insert(loveos.curr_string, key) -- adds the key just pressed to the currstring
    end
  end

end

function loveos:keyreleased(key)
  if key == "rshift" or key == "lshift" then
    loveos.upper = false
  end
end

function loveos:check_bb(ax1,ay1,aw,ah, bx1,by1,bw,bh) -- check_bb
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
