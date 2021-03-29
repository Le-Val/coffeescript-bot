import { readdirSync } from "fs"
import { resolve, dirname } from "path"

export data = commands: new Map, aliases: new Map

export handler = ->

	for file in readdirSync "#{resolve dirname ""}/dist/commands/" when file.endsWith "js"

		Mod = require "./commands/#{file}"

		data.commands.set Mod.Command.names[0], Mod.Command

		for alias in Mod.Command.names when alias isnt Mod.Command.names[0] and Mod.Command.names.length > 1
		
			data.aliases.set alias, Mod.Command.names[0]

		console.info "\x1b[35m", "Loaded #{Mod.Command.names[0]}", "\x1b[0m"

	console.table [ total: data.commands.size, commands: [ do data.commands.keys... ] ]

do handler