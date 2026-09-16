extends StaticBody2D

const SPEED = 16.0
const GRAVITY = 96.0

#var direction: float = 0.0
var velocity: Vector2

func _ready() -> void:
	var x_vel = randi() % 16 + 8
	if randi() % 2 == 0:
		x_vel *= -1
	velocity = Vector2(x_vel, -1 * randi() % 16 - 32)
	
	$AnimatedSprite2D.frame = randi() % 3

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	var col = move_and_collide(velocity * delta)
	if col: velocity.x = 0.0

func collect():
	queue_free()
