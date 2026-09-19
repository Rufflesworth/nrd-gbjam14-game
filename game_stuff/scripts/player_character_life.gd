extends Control

var player_character: CharacterBody2D

func _ready() -> void:
	var game = GlobalHelper.get_game()
	game.connect("retrying_current_room", _on_game_retrying_current_room)
	hide()

func boss_entered():
	var game = GlobalHelper.get_game()
	var room = game.get_room()
	player_character = room.get_player_character()
	$hp.text = str(player_character.health)
	player_character.connect("health_changed", _on_player_character_health_changed)
	show()

func _on_player_character_health_changed():
	$hp.text = str(player_character.health)

func _on_game_retrying_current_room():
	hide()
