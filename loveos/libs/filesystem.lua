loveos:add_function("cd", "Used to change directories.")
loveos:add_function("mkdir", "Used to make directories.")
loveos:add_function("ls", "Used to list directories.")
loveos:add_function("rm", "Used to remove directories.")
loveos:add_function("help", "Get help on commands.")

loveos.commands = {}

function loveos.commands.cd(var)
  if var == ".." then
    if loveos.fs.dir ~= "home" then
      local temp_table = {}
      local temp_file = loveos.fs.dir:split("/")
      table.remove(temp_file, #temp_file)
      --temp_file = table.concat(temp_file); for c in temp_file:gmatch(".") do temp_table[#temp_table+1] = c end;
      temp_file = table.concat(temp_file, "/")
      loveos.fs.dir = temp_file
    end
  elseif var ~= nil then
    if love.filesystem.exists( "loveos/fs/" .. loveos.fs.dir .. "/" .. var ) == true then
      loveos.fs.dir = loveos.fs.dir .. "/" .. var
    else
      loveos:prints("File not found!")
    end
  else
    loveos.fs.dir = "home"
  end
end

function loveos.commands.mkdir(dir)
  if dir ~= nil then
    love.filesystem.mkdir( "loveos/fs/" .. loveos.fs.dir .. "/" .. dir )
  elseif dir == nil then
    loveos:prints("Please enter a real file name!")
  end
end

function loveos.commands.ls(var)
  if var ~= nil then
    local files = love.filesystem.enumerate("loveos/fs/" .. loveos.fs.dir .. "/" .. var)
    for k, file in ipairs(files) do
        loveos:prints(file) --outputs something like "1. main.lua"
    end
  elseif var == nil then
    local files = love.filesystem.enumerate("loveos/fs/" .. loveos.fs.dir)
    for k, file in ipairs(files) do
        loveos:prints(file) --outputs something like "1. main.lua"
    end
  end
end

function loveos.commands.rm(dir)
  if dir ~= nil then
    if love.filesystem.exists( "loveos/fs/" .. loveos.fs.dir .. "/" .. dir ) == true then
      love.filesystem.remove("loveos/fs/" .. loveos.fs.dir .. "/" .. dir)
    end
  end
end

function loveos.commands.help(cmd)
  if cmd ~= nil then
    for i,v in ipairs(loveos.commands) do
      if cmd == v.name then
        loveos:prints(v.name .. " | " .. v.desc)
      end
    end
  else
    for i,v in ipairs(loveos.commands) do
      loveos:prints(v.name .. " | " .. v.desc)
    end
  end
end
