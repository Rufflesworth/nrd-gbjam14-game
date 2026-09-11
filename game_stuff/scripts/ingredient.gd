extends CharacterBody2D

const GRAVITY = 64.0
const FRICTION = 2.0

enum STATES { WAITING, FALLING, CAPTURED }
var state: STATES = STATES.WAITING

var direction: float = 0.0

func _ready() -> void:
	velocity = Vector2(direction * 32.0, -64.0)

func _physics_process(delta: float) -> void:
	match state:
		STATES.WAITING:
			process_movement(delta)
		STATES.FALLING:
			process_movement(delta)
			if global_position.y >= 104.0: # we've passed through the last floor before ground
				$CollisionShape2D.set_deferred("disabled", false)
				state = STATES.WAITING
		STATES.CAPTURED:
			pass

func process_movement(delta: float):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if velocity.x != 0.0:
		velocity.x = lerpf(velocity.x, 0.0, FRICTION * delta)
		if absf(velocity.x) < 1.0: velocity.x = 0.0
	
	move_and_slide()

func kick(pc_global_pos: Vector2):
	if global_position > pc_global_pos: # on the right side of the player character
		velocity = Vector2(32.0, 64.0)
	else: velocity = Vector2(-32.0, 64.0)
	
	$CollisionShape2D.set_deferred("disabled", true)
	state = STATES.FALLING

func capture():
	#$ColorRect.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	state = STATES.CAPTURED
