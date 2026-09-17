extends TextureProgressBar

var boss: CharacterBody2D

func _ready() -> void:
	var game = GlobalHelper.get_game()
	game.connect("boss_room_loaded", _on_boss_room_loaded)
	
	hide()

func _on_boss_room_loaded():
	prints(self, "trying to handle boss room loaded")
	var game = GlobalHelper.get_game()
	var room = game.get_room()
	boss = room.get_boss()
	boss.connect("health_changed", _on_boss_health_changed)
	show()

func _on_boss_health_changed():
	value = boss.health
