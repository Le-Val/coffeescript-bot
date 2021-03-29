export class Command

	@names: ["ping"]
	@desc: "¿?"
	@usage: "¿?"
	@permissions: client: [], user: []
	@cooldown: 5

	@run: () -> (message) -> "pong!"