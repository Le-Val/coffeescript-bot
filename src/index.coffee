import { data } from "./handler.js"
import { Client } from "discord.js"
import { token } from "./config.js"
import PrefixController from "./controllers/prefixcontroller.js"
import moment from "moment"

import "./db.js"
import "./handler.js"

client = new Client disableMentions: "all"
client.login token

# cooldowns
cooldowns = new Map

client.on "message", (message) ->
	response = await PrefixController.get message.guild.id
	prefix   = response.prefix or "."

	# prevent infinite loops
	return unless message.content.startsWith prefix
	return if message.author.bot

	# prevent MISSING_PERMISSIONS error
	return unless message.guild.me.permissions.has "SEND_MESAGES"

	# the message arguments after the prefix
	args = message.content[prefix.length..].split /\s+/gm

	# the name of the command
	name = do args.shift

	command = data.commands.get name
	command ?= data.commands.get data.aliases.get name

	return unless command

	# cooldowns
	unless cooldowns.has command.names[0] then cooldowns.set command.names[0], new Map
	timestamps = cooldowns.get command.names[0]

	if timestamps.has message.channel.id

		expirationTime = (command.cooldown * 1000) + timestamps.get message.channel.id
		timeLeft = moment(expirationTime - do Date.now).format "s [segundos]"
		return message.channel.send """

			Estoy re caliente como para poder ejecutar más comandos :fire:
			Espera **#{timeLeft}** antes volver a usar `#{command.names[0]}`

		""" if do Date.now < expirationTime

	fn = -> timestamps.delete message.channel.id
	client.setTimeout fn, command.cooldown * 1000
	timestamps.set message.channel.id, do Date.now

	return message.channel.send """

		No tengo permisos para usar ese comando.
		¡Por favor verifica mis permisos en el apartado de roles!

	""" unless message.guild.me.permissions.has command.permissions.client

	return message.channel.send """

		No tenés permisos para ejecutar ese comando.
		¡Por favor verifica tus roles y sus permisos!

	""" unless message.member.permissions.any command.permissions.user

	if command?
		output = await command.run(client)(message, args, prefix)
		if output then message.channel.send output

client.once "ready", ->
	
	await client.user?.setPresence status: "online", activity: name: "With Coffee", type: "LISTENING"
	console.info "I'm ready logged as %s", client.user.tag

client.on "unhandledRejection", (err) -> console.error err.stack