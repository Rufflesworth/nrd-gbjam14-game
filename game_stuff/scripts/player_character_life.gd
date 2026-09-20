extends Node2D

var player_character: CharacterBody2D

func _ready() -> void:
	var game = GlobalHelper.get_game()
	game.connect("retrying_current_room", _on_game_retrying_current_room)
	hide()

func boss_entered():
	var game = GlobalHelper.get_game()
	var room = game.get_room()
	player_character = room.get_player_character()
	player_character.connect("health_changed", _on_player_character_health_changed)
	update_health(player_character.health)
	show()

func update_health(hp: int):
	match hp:
		3: $AnimatedSprite2D.play("three_health")
		2: $AnimatedSprite2D.play("two_health")
		1: $AnimatedSprite2D.play("one_health")
		0: $AnimatedSprite2D.play("no_health")

func _on_player_character_health_changed():
	var hp: int = player_character.health
	update_health(hp)

func _on_game_retrying_current_room():
	hide()
