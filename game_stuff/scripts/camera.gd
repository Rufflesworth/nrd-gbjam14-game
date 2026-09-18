extends Camera2D

@export var target_to_follow: Node2D

const SPEED = 120
const PLAYER_LEAD = 0.0

var target: Vector2
var float_position: Vector2

func _ready() -> void:
	if target_to_follow == null: prints(name, "is missing a reference to the player character")
	else: global_position = target_to_follow.global_position

func _physics_process(delta: float) -> void:
	if target_to_follow == null: return
	
	target = target_to_follow.global_position

	var weight: float = minf(SPEED * delta, 1.0)
	float_position = float_position.lerp(target, weight)

	var shake: Vector2 = Vector2.ZERO
	#if shake_strength > 0.0:
		#shake_strength = lerpf(shake_strength, 0.0, SHAKE_DECAY * delta)
		#shake = _get_noise_offset(delta, shake_strength)

	# One float position. One round.
	var desired_position: Vector2 = float_position + shake
	var rounded_position: Vector2 = desired_position.round()

	offset = Vector2.ZERO
	global_position = rounded_position
	#cam_offset = rounded_position - desired_position
	#_shader_material.set_shader_parameter("cam_offset", cam_offset)
