extends StaticBody2D

const SPEED = 24.0

@export var patrol_distance: float
var health: int = 2
var velocity: Vector2
var home: Vector2

func _ready() -> void:
	velocity = Vector2(0.0, SPEED)
	home = global_position

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
	if velocity.y > 0.0: # moving down:
		if global_position.y - home.y >= patrol_distance:
			global_position.y = home.y + patrol_distance
			velocity.y = -1.0 * SPEED
	else: # moving up
		if global_position.y - home.y < 0.0:
			global_position.y = home.y
			velocity.y = SPEED

func take_damage():
	health -= 1
	$AnimatedSprite2D.play("take_damage")
	if health <= 0:
		queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var dir: float = 1.0
		if global_position.x > pc.global_position.x: dir = -1.0
		var shove: Vector2 = Vector2(dir * 512.0, -96.0)
		pc.apply_external_force(shove)
		pc.take_damage()
