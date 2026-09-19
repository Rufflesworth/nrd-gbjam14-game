extends CharacterBody2D

### it moves along the ground and turns when it faceplants into a wall

const SPEED = 16.0
const GRAVITY = 64.0

enum STATES { NORMAL, CHEESE }
var state: STATES = STATES.NORMAL

var health: int = 3
var direction: float = 1.0

func _physics_process(_delta: float) -> void:
	match state:
		STATES.NORMAL:
			velocity = Vector2(0.0, GRAVITY)
			if is_on_floor(): velocity.x = direction * SPEED
			move_and_slide()
		STATES.CHEESE:
			velocity = Vector2(0.0, GRAVITY)
			move_and_slide()

func take_damage():
	match state:
		STATES.NORMAL:
			health -= 1
			$AnimatedSprite2D.play("take_damage")
			if health <= 0: turn_to_cheese()
		STATES.CHEESE:
			pass
			#queue_free()

func turn_to_cheese():
	$AnimatedSprite2D.play("cheese")
	health = 3
	velocity = Vector2.ZERO
	AudioController.play_transform_into_cheese()
	state = STATES.CHEESE

## Used by the boss
func revive():
	if state == STATES.CHEESE:
		$AnimatedSprite2D.play("default")
		health = 3
		state = STATES.NORMAL

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var dir: float = 1.0
		if global_position.x > pc.global_position.x: dir = -1.0
		var shove: Vector2 = Vector2(dir * 128.0, -96.0)
		match state:
			STATES.NORMAL:
				pc.apply_external_force(shove)
				pc.take_damage()
			STATES.CHEESE:
				pc.apply_external_force(Vector2(0.0, -224.0))
				$AnimatedSprite2D.play("bounce")
				$AnimatedSprite2D.frame = 0
				$boing_audio.play(0.0)

func _on_turn_around_box_body_entered(_body: Node2D) -> void:
	direction *= -1.0

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"take_damage":
			$AnimatedSprite2D.play("default")
