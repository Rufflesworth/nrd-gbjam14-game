extends StaticBody2D

const SPEED = 12.0

var float_pos: Vector2
var velocity: Vector2

func _ready() -> void:
	float_pos = global_position

func _physics_process(delta: float) -> void:
	
	global_position = float_pos
	move_and_collide(velocity * delta)
	float_pos = global_position
	global_position = float_pos.round()
	#prints(self.name, "global_position:", global_position)
	#prints(self.name, "float_position:", float_pos)

func _on_capture_pc_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_stuffs"):
		velocity = Vector2(SPEED, 0.0)
