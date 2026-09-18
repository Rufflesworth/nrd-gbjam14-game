extends Control

var player_character: CharacterBody2D
var room_cheese: int = 0
var banked_cheese: int = 0

func _ready() -> void:
	var game = GlobalHelper.get_game()
	game.connect("retrying_current_room", _on_retrying_current_room)
	game.connect("new_room_loaded", _on_new_room_loaded)
	game.connect("room_completed", _on_game_room_completed)
	$amount.label_settings.font_color = GlobalHelper.get_game().PALETTE[2]

func _on_new_room_loaded():
	var game = GlobalHelper.get_game()
	player_character = game.get_room().get_player_character()
	if player_character == null: prints(name, "is missing a reference to the player character")
	else:
		player_character.connect("cheese_collected", _on_player_character_collected_cheese)

func _on_retrying_current_room():
	room_cheese = 0
	$amount.text = str(room_cheese + banked_cheese)

func _on_player_character_collected_cheese():
	room_cheese += 1
	$amount.text = str(room_cheese + banked_cheese)

func _on_game_room_completed():
	banked_cheese += room_cheese
	room_cheese = 0
