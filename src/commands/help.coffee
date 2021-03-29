import { MessageEmbed } from "discord.js"
import { data } from "../handler.js"
export class Command

    @names: ["help", "h"]
    @desc: "Ayuda"
    @usage: "help <Commando>"
    @permissions: client: [], user: []
    @cooldown: 8

    @run: (client) -> (message, args, prefix) ->

        options = args?[0]

        command = data.commands.get options
        command ?= data.commands.get data.aliases.get options

        "No encontré ese comando" unless command

        embed = new MessageEmbed()
            .setColor "RANDOM"
            .setAuthor "Comando de ayuda.", client.user?.displayAvatarURL()
            .setTimestamp()
            .addField "Comando:", "#{prefix}#{command.config.names[0]}"
            .addField "Descripción:", "#{command.config.desc}"
            .addField "Uso correcto:", "#{prefix}#{command.config.usage}"
            .addField "Cooldown:", "#{command.config.cooldown} segundo(s)"
            .setFooter "<> = required [] = optional", client.user?.displayAvatarURL()
        
        embed.addField "Nombre(s)  alternativo(s) :", command.config.names[1..].join ", " if command.config.names.length > 1

        embed