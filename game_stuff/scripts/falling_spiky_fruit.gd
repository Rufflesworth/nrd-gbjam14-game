extends CharacterBody2D

const FALL_SPEED = 96.0

var cheese_bit_resource: PackedScene = preload("res://game_stuff/scenes/cheese_bit.tscn")

enum STATES { NORMAL, CHEESE }
var state: STATES = STATES.NORMAL

func _ready() -> void:
	velocity = Vector2(0.0, FALL_SPEED)

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
	
	if global_position.y >= 160.0: queue_free()

func _handle_hit_by_cheese_ray():
			var chz_bit: Node2D
			for x in 2:
				chz_bit = cheese_bit_resource.instantiate()
				chz_bit.global_position = global_position
				var game = GlobalHelper.get_game()
				var room = game.get_room()
				room.call_deferred("add_child", chz_bit)
			AudioController.play_burst_into_cheese()
			$cheeseable_box/CollisionShape2D.set_deferred("disabled", true)
			$hit_box/CollisionShape2D.set_deferred("disabled", true)
			$AnimatedSprite2D.play("burst")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var dir: float = 1.0
		if global_position.x > pc.global_position.x: dir = -1.0
		var shove: Vector2 = Vector2(dir * 512.0, -96.0)
		match state:
			STATES.NORMAL:
				pc.apply_external_force(shove)
				pc.take_damage()
			STATES.CHEESE:
				### TODO: if anything just burst into like 2 cheese bits
				pass

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"burst": queue_free()
