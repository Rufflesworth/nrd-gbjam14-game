extends StaticBody2D

const GRAVITY = 32.0

var velocity: Vector2

func _physics_process(delta: float) -> void:
	velocity = Vector2(0.0, GRAVITY)
	
	var col = move_and_collide(velocity * delta)
	
	global_position = global_position.snappedf(1.0)
