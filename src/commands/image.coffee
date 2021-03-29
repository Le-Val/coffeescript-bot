import Scraper from "images-scraper"
import Discord from "discord.js"
export class Command

    @names: ["image", "img", "im"]
    @desc: "Busca imágenes."
    @usage: "image"
    @permissions: client: [], user: []
    @cooldown: 5

    @run: () -> (message, args) ->

        search = args.join ""

        BACK = "⬅️"
        NEXT = "➡️"
        DELT = "🗑️"

        # the current page
        page = 0

        return "Por favor especifica una búsqueda." unless search

        google = new Scraper puppeter: headless: false
        results = await google.scrape search, 50 # default

        awaitR = (m, author) ->
            # remove reactions
            removeR = (m) -> userReactions = m.reactions.cache.filter (r) -> r.users.cache.has(author.id)

            # filter
            filter = (reaction, user) -> [BACK, NEXT, DELT].includes reaction.emoji.name

            # update the embed
            update = (m, page) ->
                newEmbed = Object.create m.embeds[0]
                newEmbed.setImage results[page].url
                newEmbed.setTitle results[page].title
                newEmbed.setDescription "[Source](#{results[page].source})"
                newEmbed.setFooter "Page: #{page + 1}/#{results.length}"
                m.edit newEmbed

            # Collection<string, MessageReaction>
            collected = await m.awaitReactions filter, max: 1, time: 60*1000, errors: ["time"]

            switch collected.first()?.emoji.name
                when BACK
                    page-- if page isnt 0
                    update m, page
                    removeR m
                    await awaitR m, author
                when NEXT
                    page++ if page isnt 50
                    update m, page
                    removeR m
                    await awaitR m, author
                when DELT then do m.delete

        if message.guild?.me?.permissions.has "ADD_REACTIONS"

            # message
            embed = new Discord.MessageEmbed()
            embed.setColor "RANDOM"
            embed.setAuthor message.author.username, do message.author.displayAvatarURL
            embed.setImage results[0].url
            embed.setTitle results[0].title
            embed.setDescription "[Source](#{results[0].source})"
            embed.setFooter "First page from #{results.length} pages"

            msg = await message.channel.send embed

            await msg.react BACK
            await msg.react NEXT
            await msg.react DELT
            await awaitR msg, msg.author