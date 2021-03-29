import { MessageEmbed } from "discord.js"
import process from "process"
import moment from "moment"
export class Command

    @names: ["info", "botinfo", "bot"]
    @desc: "Muestra información acerca del bot."
    @usage: "info"
    @permissions: client: [], user: []
    @cooldown: 5

    @run: (client) -> (message) ->

        embed = new MessageEmbed()

            .setColor "RED"
            .setAuthor message.member?.displayName, message.author.displayAvatarURL() ? client?.user?.displayAvatarURL()
            .setThumbnail client?.user?.displayAvatarURL() ? message.author.displayAvatarURL()
            .setDescription """
                [Invite del bot (con permisos)](https://discord.com/oauth2/authorize?client_id=#{client?.user?.id}&permissions=8&scope=bot)
                Activo en **#{client.guilds.cache.size}** servidores
                Sirviendo a **#{client.users.cache.size}** usuarios
            """
            .addField "Owner", "<@659611986413355018> - 659611986413355018"
            .addField "Librería", "[Discord.js 12.3.1](https://discord.js.org/#/)"
            .addField "Desarrollo", ### TODO reemplazar typescript por coffeescript ###
            """
                [TypeScript 4.0.3](https://www.typescriptlang.org/)
                [Node JS 14.0.0](https://nodejs.org/en/)
            """
            .addField "Open Source", "[Github](https://github.com/Le-Val/azu-bit/)"
            .addField "RAM", [(Math.round((process.memoryUsage().heapUsed / 1024 / 1024) * 100) / 100).toFixed 2, "MB"]
            .addField "Shards", client?.shard?.count ? 0
            .addField "Uptime", "Siendo genial desde **#{(do moment).milliseconds(client?.uptime).locale("es").toNow()}**"

        embed