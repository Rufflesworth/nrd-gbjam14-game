extends CharacterBody2D

### it moves along the ground and turns when it faceplants into a wall

const SPEED = 16.0

enum STATES { NORMAL, CHEESE }
var state: STATES = STATES.NORMAL

var health: int = 3
var direction: float = 1.0

func _physics_process(delta: float) -> void:
	match state:
		STATES.NORMAL:
			velocity = Vector2(direction * SPEED, 0.0)
			var col = move_and_collide(velocity * delta)
			if col: direction *= -1.0
		STATES.CHEESE:
			move_and_collide(velocity * delta)

func take_damage():
	health -= 1
	if health <= 0:
		match state:
			STATES.NORMAL:
				turn_to_cheese()
			STATES.CHEESE:
				pass
				#queue_free()

func turn_to_cheese():
	$AnimatedSprite2D.play("cheese")
	health = 3
	velocity = Vector2.ZERO
	state = STATES.CHEESE

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var dir: float = 1.0
		if global_position.x > pc.global_position.x: dir = -1.0
		var shove: Vector2 = Vector2(dir * 384.0, -96.0)
		match state:
			STATES.NORMAL:
				pc.apply_external_force(shove)
				pc.take_damage()
			STATES.CHEESE:
				pc.apply_external_force(Vector2(0.0, -216.0))
				$AnimatedSprite2D.play("bounce")
				$AnimatedSprite2D.frame = 0
