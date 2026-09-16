extends StaticBody2D

enum STATES { BASE, CHEESE }
var state: STATES = STATES.BASE

var cheese_bit_resource: PackedScene = preload("res://game_stuff/scenes/cheese_bit.tscn")

func _handle_hit_by_cheese_ray():
	match state:
		STATES.BASE:
			$AnimatedSprite2D.play("cheese")
			AudioController.play_transform_into_cheese()
			state = STATES.CHEESE
		STATES.CHEESE:
			var chz_bit: Node2D
			for x in 4:
				chz_bit = cheese_bit_resource.instantiate()
				chz_bit.global_position = global_position
				var game = GlobalHelper.get_game()
				var room = game.get_room()
				room.call_deferred("add_child", chz_bit)
			AudioController.play_burst_into_cheese()
			$AnimatedSprite2D.play("burst")
			$CollisionShape2D.set_deferred("disabled", true)
			$cheeseable_box/CollisionShape2D.set_deferred("disabled", true)

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"burst":
			queue_free()
