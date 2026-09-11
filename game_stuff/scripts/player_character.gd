extends CharacterBody2D

const SPEED = 32.0
const GRAVITY = 64.0
const TERMINAL_VELOCITY = 96.0
const TELEPORT_UP = -40.0
const TELEPORT_DOWN = 24.0
const TELEPORT_COOLDOWN = 1.0
const HAMMER_COOLDOWN = 1.0
const KICK_COOLDOWN = 1.0

enum STATES { WALKING, HAMMERING, KICKING }
var state: STATES = STATES.WALKING

var teleport_refresh: float = 0.0
var hammer_refresh: float = 0.0
var kick_refresh: float = 0.0
var facing: float = 1.0 # right = 1.0, left = -1.0

func _physics_process(delta: float) -> void:
	if state == STATES.WALKING:
		process_movement(delta)
		process_teleport(delta)
		process_hammer(delta)
		process_kick(delta)
	elif state == STATES.HAMMERING:
		$hammer_box/CollisionShape2D.set_deferred("disabled", true)
		state = STATES.WALKING
	elif state == STATES.KICKING:
		$kick_box/CollisionShape2D.set_deferred("disabled", true)
		state = STATES.WALKING

func process_movement(delta: float):
	var direction = roundf(Input.get_axis("player_left", "player_right"))
	if direction == 1.0: facing = 1.0
	elif direction == -1.0: facing = -1.0
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		if velocity.y > TERMINAL_VELOCITY: velocity.y = TERMINAL_VELOCITY
	
	velocity.x = direction * SPEED
	
	move_and_slide()

func process_teleport(delta: float):
	if teleport_refresh > 0.0: # teleport is cooling down
		teleport_refresh -= delta
		if teleport_refresh <= 0.0: prints("teleport ready to use")
	
	if teleport_refresh <= 0.0: # ready to use
		if Input.is_action_pressed("player_up"):
			# Keeping the player on the screen
			if position.y + TELEPORT_UP >= 0.0:
				position += Vector2(0.0, TELEPORT_UP)
				teleport_refresh = TELEPORT_COOLDOWN
		elif Input.is_action_pressed("player_down"):
			if position.y != 120.0: # if not on ground level
				# Keeping the player on the screen
				if position.y + TELEPORT_DOWN <= 120.0:
					position += Vector2(0.0, TELEPORT_DOWN)
				else: # move the pc to the ground level
					position.y = 120.0
				teleport_refresh = TELEPORT_COOLDOWN

func process_hammer(delta: float):
	if hammer_refresh > 0.0: # hammer is cooling down
		hammer_refresh -= delta
		if hammer_refresh <= 0.0: prints("hammer ready to use")
	
	if facing == 1.0:
		$hammer_box.position.x = 12.0
	elif facing == -1.0:
		$hammer_box.position.x = -12.0
	
	if hammer_refresh <= 0.0: # ready to use
		if Input.is_action_just_pressed("player_b"):
			$hammer_box/CollisionShape2D.set_deferred("disabled", false)
			hammer_refresh = HAMMER_COOLDOWN
			state = STATES.HAMMERING

func process_kick(delta):
	if kick_refresh > 0.0: # kick is cooling down
		kick_refresh -= delta
		if kick_refresh <= 0.0: prints("kick ready to use")
	
	if kick_refresh <= 0.0: # ready to use
		if Input.is_action_just_pressed("player_a"):
			$kick_box/CollisionShape2D.set_deferred("disabled", false)
			kick_refresh = KICK_COOLDOWN
			state = STATES.KICKING

func _on_hammer_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("break_boxes"):
		## Check to see if it is a breakable hurtbox?
		## If so, then tell it to break.
		var breakable_obj = area.get_parent()
		breakable_obj.explode(global_position)

func _on_kick_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		body.kick(global_position)
