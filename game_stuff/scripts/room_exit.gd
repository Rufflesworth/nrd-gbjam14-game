extends Area2D

@export var next_room: PackedScene

func _ready() -> void:
	if next_room == null:
		printerr(self, "doesn't have a next_room assigned")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_stuffs"):
		prints("player has reach a room exit, now fade to black and load a new room")
		
		var game = GlobalHelper.get_game()
		game.load_new_room(next_room)
