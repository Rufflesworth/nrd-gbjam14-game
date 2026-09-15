extends StaticBody2D

enum STATES { BASE, CHEESE }
var state: STATES = STATES.BASE

var cheese_bit_resource: PackedScene = preload("res://game_stuff/scenes/cheese_bit.tscn")

func _handle_hit_by_cheese_ray():
	prints(self, "handling hit by cheese ray")
	match state:
		STATES.BASE:
			$AnimatedSprite2D.play("cheese")
			state = STATES.CHEESE
		STATES.CHEESE:
			var chz_bit: Node2D
			for x in 4:
				chz_bit = cheese_bit_resource.instantiate()
				chz_bit.global_position = global_position
				var game = GlobalHelper.get_game()
				var room = game.get_room()
				room.call_deferred("add_child", chz_bit)
			queue_free()
