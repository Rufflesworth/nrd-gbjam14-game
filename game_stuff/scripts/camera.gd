extends Camera2D

@export var player_character: Node2D

const SPEED = 96.0
const PLAYER_LEAD = 16.0

enum STATES { ACTIVE, PAUSED }
var state: STATES = STATES.ACTIVE

var target: float
var move_counter: float = 0.0

func _ready() -> void:
	if player_character == null: prints(name, "is missing a reference to the player character")
	else: global_position = player_character.global_position

func _physics_process(delta: float) -> void:
	if state == STATES.PAUSED: return
	
	process_camera_movement(delta)

func process_camera_movement(delta: float):
	var direction = player_character.movement_direction
	var camera_speed = SPEED * delta # pixels/second
	var new_pos: float
	
	if direction == 0.0: pass
		# if the player is not inputting, then we let them drift and keep the camera still
	elif direction > 0.0: # player pressing right
		target = player_character.global_position.x + PLAYER_LEAD
		new_pos = min(global_position.x + camera_speed, target)
		if new_pos > limit_right - 80.0: new_pos = limit_right - 80.0
		global_position.x = new_pos
	elif direction < 0.0: # player pressing left
		target = player_character.global_position.x - PLAYER_LEAD
		new_pos = max(global_position.x - camera_speed, target)
		if new_pos < limit_left - 80.0: new_pos = limit_left - 80.0
		global_position.x = new_pos

func get_center_of_screen() -> Vector2:
	var center: Vector2
	center = global_position
	return center
