extends TextureProgressBar

var boss: CharacterBody2D

func _ready() -> void:
	var game = GlobalHelper.get_game()
	game.connect("retrying_current_room", _on_game_retrying_current_room)
	hide()

func boss_entered(b: Node2D):
	boss = b
	boss.connect("health_changed", _on_boss_health_changed)
	value = boss.health
	show()

func _on_boss_health_changed():
	value = boss.health

func _on_game_retrying_current_room():
	hide()
