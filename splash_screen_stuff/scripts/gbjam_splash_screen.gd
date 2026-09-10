extends Node2D

@export var next_scene: PackedScene

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame == 4: $bloing.play()
	elif $AnimatedSprite2D.frame == 12: $pling.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	GlobalHelper.change_scene(next_scene)
