import ms from "ms"
export class Command

    @names: ["mute"]
    @desc: "Mutea a alguien."
    @usage: "mute <@user> [time]"
    @permissions: client: [ "MANAGE_ROLES" ], user: [ "MANAGE_MESSAGES", "MANAGE_ROLES", "ADMINISTRATOR" ]
    @cooldown: 1

    @run: (client) -> (message, args) ->

        toMute = message.mentions.members?.first()
        muteRole = message.guild?.roles?.cache.find (r) -> r.name is "Muted" or r.name is "In a silent way"
        muteTime = args?[1]

        "Uso correcto: #{usage}" if not toMute toMute.bot

        unless muteRole
            createMuteRole message.guild
            "Creé #{muteRole.name}"

        await toMute.roles?.add muteRole?.id
        "**#{toMute.displayName}** muteado por #{muteTime ? "∞"}"

        if muteTime? then client.setTimeout ->

            if toMute.roles?.cache.has muteRole?.id

                toMute.roles.remove muteRole?.id
                message.channel.send "**#{toMute.displayName}** unmuteado."

        , ms muteTime

createMuteRole = (guild) ->
    
    muteRole = await guild?.roles.create

        data:

            name: "In a silent way"
            color: 0x000000
            permissions: []
            mentionable: yes

        reason: "Mute"

    await guild?.channels.cache.each (channel) -> channel.overwritePermissions [ id: muteRole?.id, deny: ["SEND_MESSAGES", "ADD_REACTIONS"] ]
    muteRole