extends Control

var player_character: CharacterBody2D

func _ready() -> void:
	var game = GlobalHelper.get_game()
	game.connect("boss_room_loaded", _on_boss_room_loaded)
	
	hide()

func _on_boss_room_loaded():
	var game = GlobalHelper.get_game()
	var room = game.get_room()
	player_character = room.get_player_character()
	$hp.text = str(player_character.health)
	player_character.connect("health_changed", _on_player_character_health_changed)
	show()

func _on_player_character_health_changed():
	$hp.text = str(player_character.health)
