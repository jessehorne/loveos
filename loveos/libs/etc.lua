-- Uncategorized commands

loveos.commands.help = {
	desc = "Get help on commands",
	help = [[
Usage: help [command]

If called without arguments, help will list all commands and their short descriptions.
If called with a command name as an argument, it will print a more detailed help for it.
]],
	func = function(cmd)
		if cmd then
			for k,v in pairs(loveos.commands) do
				if cmd == k then
					loveos:prints(v.desc .. '\n')
					if v.help then
						loveos:prints(v.help)
						return
					end
				end
			end
			loveos:prints("help: " .. cmd .. ": No such command.\n")
		else
			for k,v in pairs(loveos.commands) do
				loveos:prints(k .. " - " .. v.desc .. "\n")
			end
		end
	end
}

loveos.commands.clear = {
  desc = "Clear the screen",
  help = "This command also erases the scrollback. Don't use it if you might need to read the scrollback\n",
  func = function()
    loveos.term:clear()
  end
}