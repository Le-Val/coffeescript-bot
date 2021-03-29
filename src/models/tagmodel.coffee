import mongoose, { Schema } from "mongoose";

TagSchema = new Schema

	id: Schema.Types.ObjectId
	server: String
	user: String
	name: String
	content: String
	attachments: [String]
	global: Boolean
	nsfw: Boolean

export Tag = mongoose.model "Tag", TagSchema