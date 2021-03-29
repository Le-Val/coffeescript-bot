import TagController from "../controllers/tagcontroller.js"
import { Util } from "discord.js"
export class Command

	@names: ["tag", "t", "q", "quote"]
	@desc: "Sistema de tags de Azu."
	@usage: "`tag <add | remove | edit | list | nsfw | owner | gift | global> | merge> <Nombre> [Contenido]`"
	@permissions: client: [], user: []
	@cooldown: 2

	@run: () -> (message, args) ->

		OWNER = "659611986413355018" # here goes your id

		switch args[0]

			when "add"

				tag = await TagController.get args[1], message.guild.id

				"Ese tag ya existe en éste servidor." if tag?
				"El tag no puede estar vacío." unless args[2] or message.attachments.size > 1

				output = await TagController.add message.guild.id, message.author.id, (args[2..].join " "), args[1], message.attachments.map (att) -> att.url
				"Añadí el tag **#{output.name}**"

			when "global"

				tag = await TagController.get args[1], message.guild.id

				"Ese tag no existe." unless tag
				"No sos el dueño del bot." if message.author.id isnt OWNER
				
				output = await TagController.edit tag, { content: tag.content, attachments: tag.attachments }, no, if tag.global is on then off else on
				"Edité el tag **#{output?.name}**."

			when "nsfw"

				tag = await TagController.get args[1], message.guild.id

				"Ese tag no existe." unless tag
				"No se puede marcar como NSFW un tag global" if tag.global is on

				"""

					No puedes marcar como NSFW si no sos dueño del tag o admin del servidor.

				""" if not message.author.permissions.has "ADMINISTRATOR" and tag.user isnt message.author.id

				if tag.nsfw is off

					output = await TagController.edit tag, { content: tag.content, attachments: tag.attachments }, yes
					"Marqué como NSFW el tag **#{output?.name}**"

				if tag.nsfw is on

					output = await TagController.edit tag, { content: tag.content, attachments: tag.attachments }, no
					"Desmarqué como NSFW el tag **#{output?.name}**"

			when "edit"

				tag = await TagController.get args[1], message.guild.id

				"Ese tag no existe." unless tag
				"El tag no puede estar vacío" unless args[2] or message.attachments.size > 1

				output = await TagController.edit tag, { content: (args[2..].join " "), attachments: message.attachments.map (att) -> att.url }

				"Edité el tag **#{output.name}**"

			when "remove"

				tag = await TagController.get args[1], message.guild.id

				"""
					Ese tag no te pertenece 
					O no tenés permisos para remover el tag de **#{message.guild.name}**
				""" if message.author.id isnt tag.user or message.author.id isnt OWNER

				"Ese tag no existe." unless tag

				await TagController.remove message.guild.id, message.author.id, tag.name
				"Removí el tag **#{args[1]}**"

			when "list"

				tags = await TagController.find message.guild.id, message.mentions.users.first()?.id ? message.author.id
				list = Util.splitMessage tags.map((tag) -> tag.name).join ", "

				content: "# #{tags}", code: "cpp" for tags in list

			when "gift"

				tag = await TagController.get args[1], message.guild.id
				target = message.mentions.users.first()

				"Ese tag no existe." unless tag
				"Menciona un usuario." unless target
				"No podés regalar un tag global." if tag.global is on
				"Ni puta gracia." if target.bot is on

				output = await TagController.pass tag, { server: tag.server, user: target.id }
				"Regalaste el tag **#{output?.name}** a <@!#{output?.user}>"

			when "owner"

				tag = await TagController.get args[1], message.guild.id

				"Ese tag no existe." unless tag

				"`Tag: #{tag.name}` #{tag.user}"

			when "merge"

				# BETA

				server = args[1]
				target = TagController.find server, message.author.id
				transf = TagController.find message.guild.id, message.author.id

				for to_merge in transf

					"Hay tags duplicados." if target.some (t) -> t.name is to_merge.name
					await TagController.add server, to_merge.content, to_merge.name, to_merge.attachments
				
				"Envié #{transf.length} tags a #{server}"

			else

				tag = await TagController.get args[0], message.guild.id

				"Ese tag no existe." unless tag
				"No puedo poner ese contenido en el canal actual." if tag.nsfw is on and not message.channel?.nsfw

				content: ["Global:" if tag.global is on, tag?.content ? " "], files: tag?.attachments