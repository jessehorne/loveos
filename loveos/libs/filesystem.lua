loveos.commands.cd = {
	desc = "Change the current working directory",
	help = [[
Usage: cd <directory>
If <directory> is not found, the current working directory remains unchanged
]],
	func = function(var)
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
				loveos:prints("File not found!\n")
			end
		else
			loveos.fs.dir = "home"
		end
	end
}

loveos.commands.touch = {
  desc = "Create a text file",
  help = [[
  Usage: touch <file>
  Create a file named <file>
]],
  func = function(name)
    if name ~= nil then
      if love.filesystem.exists(name) then
        loveos:prints("File already exists!\n")
      else
        local file = love.filesystem.newFile("loveos/fs/" .. loveos.fs.dir .. "/" .. name )
        file:open("w")
        file:close()
      end
    else
      loveos:prints("Provide second argument file name please.\n")
    end
  end
}

loveos.commands.mkdir = {
	desc = "Create a directory",
	help = [[
Usage: mkdir <directory>
]],
	func = function(dir)
		if dir ~= nil then
			love.filesystem.createDirectory( "loveos/fs/" .. loveos.fs.dir .. "/" .. dir )
		elseif dir == nil then
			loveos:prints("Please enter a real file name!\n")
		end
	end
}

loveos.commands.ls = {
	desc = "List directory contents",
	help = [[
Usage: ls [directory]

If called without arguments, ls lists the contents of the current directory.
Else, it lists the contents of <directory>
]],
	func = function(var)
		if var ~= nil then
			local files = love.filesystem.getDirectoryItems("loveos/fs/" .. loveos.fs.dir .. "/" .. var)
			for k, file in ipairs(files) do
					loveos:prints(file .. ' ') --outputs something like "1. main.lua"
			end
      loveos:prints("\n")
		elseif var == nil then
			local files = love.filesystem.getDirectoryItems("loveos/fs/" .. loveos.fs.dir)
			for k, file in ipairs(files) do
					loveos:prints(file .. ' ') --outputs something like "1. main.lua"
			end
      if #files > 0 then loveos:prints("\n") end
		end
	end
}

loveos.commands.rm = {
	desc = "Remove a directory",
	help = [[
Usage: rm <directory>
]],
	func = function(dir)
		if dir ~= nil then
			if love.filesystem.exists( "loveos/fs/" .. loveos.fs.dir .. "/" .. dir ) == true then
				love.filesystem.remove("loveos/fs/" .. loveos.fs.dir .. "/" .. dir)
			end
		else
			loveos:prints("Please put a file argument!\n")
		end
	end
}

loveos.commands.run = {
  desc = "Run Lua script",
  help = [[ 
Usage: run [script]

If called without arguments, it will print an error to the console.
If called with arguments, and the argument file exists, it will run that script.
]],
  func = function(var)
    if var ~= nil then
      if love.filesystem.exists( "loveos/fs/" .. loveos.fs.dir .. "/" .. var ) == true then
        script = love.filesystem.load( "loveos/fs/" .. loveos.fs.dir .. "/" .. var )
        script()
      else
        loveos:prints("File does not exist!\n")
      end
    end
  end
}
