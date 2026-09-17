extends StaticBody2D

var health: int = 2

func _handle_hit_by_cheese_ray():
	health -= 1
	$AnimatedSprite2D.play("take_hit")

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"take_hit":
			if health <= 0:
				$AnimatedSprite2D.play("bloom")
				$platform.set_deferred("disabled", false)
				$cheeseable_box/CollisionShape2D.set_deferred("disabled", true)
			else: $AnimatedSprite2D.play("bud")
		"bloom":
			$AnimatedSprite2D.play("cheese")
