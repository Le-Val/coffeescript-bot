import { MessageEmbed } from "discord.js"
export class Command

    @names: ["avatar", "avy", "pfp", "pic"]
    @desc: "Muestra un avatar."
    @usage: "avatar [@Usuario]"
    @permissions: client: [], user: []
    @cooldown: 5

    @run: () -> (message) ->

        target = do message.mentions.users.first ? message.author
        avatar = target.displayAvatarURL dynamic: yes, size: 1024, format: "png" or "gif"

        embed = new MessageEmbed()

            .setAuthor "Avatar pedido por #{message.author.tag}", avatar
            .setColor message.guild?.member(target)?.displayColor ? 0xd91d4d
            .setDescription """
                [Avatar](#{avatar})
                [Avatar Sauce](https://www.google.com/searchbyimage?image_url=#{avatar})
                `#{target.username}'s profile pic`
            """
            .setImage avatar

        return embed