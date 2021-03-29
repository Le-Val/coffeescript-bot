import { db } from "./config.js"
import mongoose from "mongoose"

export connect = ->

	return if database?
	mongoose.connect db,

		useNewUrlParser: yes
		useFindAndModify: no
		useCreateIndex: yes
		reconnectTries: 10
		reconnectInterval: 1500
		connectTimeoutMS: 3000
		socketTimeoutMS: 30000
		keepAlive: yes

	database = mongoose.connection;
	database.on "open", -> console.info "Connected to database"
	database.on "error", -> console.error "Error connecting to database"
	database.on "warn", -> console.warn "Warning"

export disconnect = ->

	mongoose.disconnect unless database


do connect