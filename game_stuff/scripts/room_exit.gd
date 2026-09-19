extends Area2D

signal exit_reached

@export var next_room: PackedScene

func _ready() -> void:
	if next_room == null:
		printerr(self, "doesn't have a next_room assigned")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_stuffs"):
		body.freeze()
		var scrn_trans = GlobalHelper.get_main().get_screen_transitioner()
		scrn_trans.connect("transition_complete", _on_screen_transitioner_transition_completed)
		scrn_trans.start_transition_exit()
		emit_signal("exit_reached")

func _on_screen_transitioner_transition_completed():
	var game = GlobalHelper.get_game()
	game.load_new_room(next_room)
