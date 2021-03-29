import mongoose, { Schema } from "mongoose";

PrefixSchema = new Schema

    id: Schema.Types.ObjectId
    server: String
    prefix: String

export Prefix = mongoose.model "Prefix", PrefixSchema