import { MessageEmbed } from "discord.js"
import PrefixController from "../controllers/prefixcontroller.js"

export class Command

    @names: ["prefix", "prefijo"]
    @desc: "Cambia el prefijo del servidor."
    @usage: "prefix <Prefijo>"
    @permissions: client: [], user: ["ADMINISTRATOR"]
    @cooldown: 30

    @run: () -> (message, args) ->
        return unless message.guild
        options = args[0]
        current = await PrefixController.get message.guild.id

        if not options
            "El prefijo actual del servidor: #{current.prefix}" if current
            "El prefijo del bot es: ´.´" if not current

        if not current
            added = await PrefixController.add message.guild.id, options
            "El nuevo prefijo #{added.prefix} se agregó a mi base de datos."

        if current
            editted = await PrefixController.edit message.guild.id, options
            "El nuevo prefijo será: #{editted.prefix}"
