loveos = {}

loveos.commands = {}
loveos_cmd_num = 0

loveos.fs = {}
loveos.fs.dirs = {}
loveos.fs.dirs["home"] = {}
loveos.fs.dir = "home"

loveos_screen_width = 800
loveos_screen_height = 600
loveos_start_x = 100
loveos_start_y = 20

loveos_font = love.graphics.newFont("loveos/font.ttf", 20)
loveos_dir = "~"
loveos_cursor_default = "$"
loveos_font_w = loveos_font:getWidth(loveos_cursor_default)
loveos_font_h = loveos_font:getHeight(loveos_cursor_default)
loveos_cursor_x = loveos_start_x + 10
loveos_cursor_y = loveos_start_y + (loveos_screen_height - 10 - loveos_font_h)
loveos_cursor_orig = loveos_dir .. loveos.fs.dir .. loveos_cursor_default
loveos_cursor = loveos_cursor_orig
loveos_backlog_max = 28
loveos_upper = false
loveos_is_letter = false

require("loveos.libs.libloveos")
require("loveos.libs.filesystem")

local loveos_disabled_keys = { --keys to disable in case they are not in use.
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

  love.graphics.setFont(loveos_font)
  
  loveos_backlog = {}
  loveos_curr_string = {}

  loveos_welcome_msg = {} 
  for i=1, 4 do loveos_welcome_msg[i] = {} end
  table.insert(loveos_welcome_msg[1], "loveos-Created by Jesse Horne")
  table.insert(loveos_welcome_msg[2], "(github.com/jessehorne)")
  table.insert(loveos_welcome_msg[3], "Configuring stuff...")
  table.insert(loveos_welcome_msg[4], "Booted!")
  for i,v in ipairs(loveos_welcome_msg) do
    loveos:printt(v)
  end

  loveos_cursor_place = #loveos_cursor

end

function loveos:printt(str)
  if table.concat(str) ~= "" then
    loveos_curr_table = {}
    loveos_curr_table.text = table.concat(str)
    loveos_curr_table.x = loveos_cursor_x
    loveos_curr_table.y = loveos_cursor_y - loveos_font_h
    table.insert(loveos_backlog, loveos_curr_table)
    for i,v in ipairs(loveos_backlog) do
      v.y = v.y - loveos_font_h
    end
  end
end

function loveos:update(dt) -- Update
  loveos_cursor_x = loveos_start_x + 10 + #loveos_cursor
  loveos_cursor_y = loveos_start_y + (loveos_screen_height - 10 - loveos_font_h)
  loveos_cursor = loveos_dir .. loveos.fs.dir .. loveos_cursor_default
  if loveos_curr_string[1] == nil then loveos_cursor_place = #loveos_cursor end
end

function loveos:draw() -- Draw
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", loveos_start_x, loveos_start_y, loveos_screen_width, loveos_screen_height)
  love.graphics.setColor(150,150,150)
  love.graphics.setLine(10)
  love.graphics.rectangle("line", loveos_start_x, loveos_start_y, loveos_screen_width, loveos_screen_height)
  love.graphics.setLine(1)
  love.graphics.setColor(255,255,255)
  love.graphics.print(loveos_cursor, loveos_cursor_x, loveos_cursor_y)

  -- Draw Current line
  love.graphics.print(table.concat(loveos_curr_string), loveos_cursor_x + (#loveos_cursor*loveos_font_w) + loveos_font_w, loveos_cursor_y)

  -- Draw backlog
  for i,v in ipairs(loveos_backlog) do
    if i > (#loveos_backlog - loveos_backlog_max) then love.graphics.print(v.text, loveos_start_x + 10, loveos_start_y + v.y) end
  end

  -- Draw Cursor
  love.graphics.rectangle("fill", loveos_cursor_x + (loveos_cursor_place*loveos_font_w)+loveos_font_w, loveos_cursor_y, loveos_font_w, loveos_font_h)

end

function loveos:keypressed(key) -- Keypressed

  loveos_can_put = true
  for i,v in ipairs(loveos_disabled_keys) do
    if key == v then
      loveos_can_put = false
      break
    end
  end
  if key == "return" then -- Return
    loveos_temp_str = loveos_curr_string
    --table.insert(loveos_temp_str, 1, "> ")
    loveos_curr_string = table.concat(loveos_curr_string)
    loveos_curr_string = loveos_curr_string:split(" ")
    local command = loveos_curr_string[1]
    table.remove(loveos_curr_string, 1)
    loveos:printt({"> ", unpack(loveos_temp_str)})
    --table.remove(loveos_temp_str, 1)
    if loveos.commands[command] then
      loveos.commands[command].func(unpack(loveos_curr_string))
    else
      loveos:prints("Invalid Command.")
    end
    loveos_curr_string = {}
  elseif key == "backspace" then -- Backspace
    table.remove(loveos_curr_string, #loveos_curr_string)
    if loveos_cursor_place > #loveos_cursor then loveos_cursor_place = loveos_cursor_place - 1 end
  elseif key == "rshift" or key == "lshift" then
    loveos_upper = true
  end
  if loveos_can_put == true then
    if #loveos_curr_string < 46 then -- Checks to make sure the current string isnt to large
      loveos_cursor_place = loveos_cursor_place + 1 -- Adds 1 space to the cursor
      if loveos_upper == true then -- Handles Uppercase
        for i,v in ipairs(letters) do 
          if key == v then 
            key = string.upper(key)
            loveos_is_letter = true
          end 
        end
        if loveos_is_letter == false then key = keys_with_upper[key] end
      end
      loveos_is_letter = false
      table.insert(loveos_curr_string, key) -- adds the key just pressed to the currstring
    end
  end

end

function loveos:keyreleased(key)
  if key == "rshift" or key == "lshift" then
    loveos_upper = false
  end
end

function loveos:check_bb(ax1,ay1,aw,ah, bx1,by1,bw,bh) -- check_bb
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
