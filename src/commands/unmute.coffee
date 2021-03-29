export class Command

    @names: ["unmute"]
    @desc: "Unmutea a alguien."
    @usage: "unmute <@user>"
    @aliases: []
    @permissions: client: [ "MANAGE_ROLES" ], user: [ "MANAGE_MESSAGES", "MANAGE_ROLES", "ADMINISTRATOR" ]
    @cooldown: 1

    @run: (client, message) ->

        toUnmute = message.mentions.members?.first()
        muteRole = toUnmute?.roles.cache.find (r) => r.name is "Muted" or r.name is "In a silent way"

        unless toUnmute

            "¡Menciona a alguien!"

        else unless muteRole

            "El usuario no está mute."

        else

            await toUnmute?.roles.remove muteRole
            "**#{toUnmute.displayName}** unmuteado."