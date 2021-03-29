import { Tag } from "../models/tagmodel.js"
import { Types } from "mongoose"

export default class TagController

	@add: (server, user, content, name, attachments) ->

		newTag = new Tag

			id: Types.ObjectId()
			server: server
			user: user
			name: name
			content: content
			attachments: attachments
			global: false
			nsfw: false

		await newTag.save()

	@remove: (server, user, name) ->

		output = await Tag.findOneAndDelete server: server, user: user, name: name
		output

	@pass: (tag, { server, user }, nsfw = false, global = false) ->

		finded =
			server: tag.server
			user: tag.user
			name: tag.name
		
		edited =
			server: server
			user: user
			global: global,
			nsfw: nsfw

		output = await Tag.findOneAndUpdate finded, edited, new: true
		output

	@edit: (tag, { content, attachments, }, nsfw = false, global = false) ->

		finded =
			server: tag.server
			user: tag.user
			name: tag.name

		edited =
			content: content
			attachments: attachments
			global: global
			nsfw: nsfw

		output = await Tag.findOneAndUpdate finded, edited, new: true
		output

	@get: (name, server) ->

		output = await Tag.findOne name: name, server: server unless global is true
		output

	@find: (server, user) ->

		output = await Tag.find user: user, server: server
		output