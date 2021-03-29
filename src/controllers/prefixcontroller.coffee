import { Prefix } from "../models/prefixmodel.js"
import { Types } from "mongoose"

export default class TagController

    @add: (server, prefix) ->

        newPrefix = new Prefix

            id: Types.ObjectId()
            server: server
            prefix: prefix

        await newPrefix.save()

    @remove: (server) ->

        output = await Prefix.findOneAndDelete server: server
        output

    @edit: (server, prefix) ->

        finded =
            server: server

        edited =
            server: server,
            prefix: prefix

        output = await Prefix.findOneAndUpdate finded, edited, new: true
        output

    @get: (server) ->

        output = await Prefix.findOne server: server
        output