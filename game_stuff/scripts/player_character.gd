extends CharacterBody2D

### TODO: We likely need some flashing invincibility frames?

### TODO: Shoot Buffer?
### TODO: It'd be nice to have some extra time at the apex of a jump to get two max height shots off easier?

### TODO: At the beginning of a boss fight, the player goes to two health
###			then gains an additional health point for every like 25 cheese they collected
###			throughout the level!

### IDEA: (SCOPE CREEP!) Allow the player to aim straight up and shoot? Seems reasonable and could be cool?

signal cheese_collected
signal health_changed

const ACCELERATION = 384.0
const MAX_SPEED = 48.0
const FRICTION = 24.0
const JUMP_FORCE = -160.0
const FALL_MULTIPLIER = 2.0
const TERMINAL_VELOCITY = 128.0
const SHOOT_TIMER = 0.10
const MAX_BULLETS = 3
const INVINCIBLE_TIMER = 0.50
const JUMP_BUFFER = 0.05 # if the player presses just before landing, let them have the jump
const COYOTE_TIMER = 0.10

@export var is_boss_room: bool = false

enum STATES { RUNNING, AIRBORNE, DYING }
var state: STATES

var jump_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/Jump.wav")
var land_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/Land.wav")
var die_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/Die.wav")

var cheese_ray_resource: PackedScene = preload("res://game_stuff/scenes/cheese_ray.tscn")
var float_pos: Vector2
var facing: float = 1.0 # right = 1.0, left = -1.0
var movement_direction: float = 0.0 # right = 1.0, left = -1.0
var shoot_count: float = 0.0
var active_cheese_rays: int = 0
var invincible_count: float = 0.0
var was_on_floor_last_frame: bool
var jump_buffer_count: float = 0.0
var coyote_count: float = 0.0
var is_external_bounce: bool = false
var external_velocity: Vector2
var health: int = 1

func _ready() -> void:
	float_pos = global_position
	if is_boss_room:
		health = 3

func _physics_process(delta: float) -> void:
	match state:
		STATES.RUNNING:
			process_movement(delta)
			process_jump(delta)
			process_cheese_ray(delta)
			process_animation()
		STATES.AIRBORNE:
			process_movement(delta)
			process_jump(delta)
			process_cheese_ray(delta)
			process_animation()
		STATES.DYING:
			process_movement(delta)

func process_movement(delta: float):
	movement_direction = roundf(Input.get_axis("player_left", "player_right"))
	
	if movement_direction == 1.0: facing = 1.0
	elif movement_direction == -1.0: facing = -1.0
	
	if movement_direction != 0.0:
		velocity.x += movement_direction * ACCELERATION * delta
		if absf(velocity.x) > MAX_SPEED: velocity.x = movement_direction * MAX_SPEED
	else: # no input from the player
		velocity.x = 0.0
		#velocity.x = lerpf(velocity.x, 0.0, FRICTION * delta)
		velocity += external_velocity
	
	if not is_on_floor():
		if velocity.y < 0.0: # moving upward
			velocity += get_gravity() * delta
		elif velocity.y >= 0.0: # falling
			velocity += get_gravity() * FALL_MULTIPLIER * delta
		
		if velocity.y > TERMINAL_VELOCITY: velocity.y = TERMINAL_VELOCITY
	
	global_position = float_pos
	move_and_slide()
	float_pos = global_position
	global_position = float_pos.round()
	#prints(self.name, "global_position:", global_position)
	#prints(self.name, "float_position:", float_pos)

func process_jump(delta: float):
	var can_jump: bool = false
	
	if is_on_floor():
		can_jump = true
		if not was_on_floor_last_frame:
			is_external_bounce = false
			land()
		was_on_floor_last_frame = true
	elif was_on_floor_last_frame:
		was_on_floor_last_frame = false
		coyote_count = COYOTE_TIMER
		can_jump = true
	elif coyote_count > 0.0 and state == STATES.RUNNING:
		coyote_count -= delta
		if coyote_count < 0.0: coyote_count = 0.0
		else: can_jump = true
	
	if Input.is_action_just_pressed("player_a"):
		# falling through a one-way platform
		if Input.is_action_pressed("player_down") and global_position.y < 96.0:
			global_position.y += 1.0
			float_pos.y += 1.0
		elif can_jump: jump()
		elif not is_on_floor():
			if jump_buffer_count == 0.0:
				jump_buffer_count = JUMP_BUFFER
	elif is_on_floor() and jump_buffer_count > 0.0: jump()
	elif (not is_external_bounce and not Input.is_action_pressed("player_a") and velocity.y < JUMP_FORCE/3.0):
		velocity.y = JUMP_FORCE / 3.0
	
	if jump_buffer_count > 0.0:
		jump_buffer_count -= delta
		if jump_buffer_count < 0.0:
			#prints("jump buffer timed out")
			jump_buffer_count = 0.0

func process_cheese_ray(delta: float):
	if shoot_count > 0.0:
		shoot_count -= delta
		if shoot_count <= 0.0: shoot_count = 0.0
	
	if shoot_count == 0.0 and active_cheese_rays < MAX_BULLETS and Input.is_action_just_pressed("player_b"):
		var chz_ray = cheese_ray_resource.instantiate()
		chz_ray.connect("freeing", _on_cheese_ray_freeing)
		chz_ray.direction = facing
		var offset: Vector2 = Vector2(0.0, 0.0)
		if facing == 1.0: offset.x = 8.0
		elif facing == -1.0: offset.x = -8.0
		chz_ray.global_position = global_position + offset
		var game = GlobalHelper.get_game()
		game.add_child(chz_ray)
		active_cheese_rays += 1
		$shot_audio.play(0.0)
		
		shoot_count = SHOOT_TIMER

func process_animation():
	match state:
		STATES.RUNNING:
			if velocity.x > 0.0:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("run")
			elif velocity.x < 0.0:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("run")
			else: $AnimatedSprite2D.play("idle")
		STATES.AIRBORNE:
			if facing == 1.0: $AnimatedSprite2D.flip_h = false
			elif facing == -1.0: $AnimatedSprite2D.flip_h = true
			
			if velocity.y <= 0.0: $AnimatedSprite2D.play("jump")
			else: $AnimatedSprite2D.play("fall")

func jump():
	velocity.y = JUMP_FORCE
	$jump_audio.stream = jump_sfx
	$jump_audio.play()
	state = STATES.AIRBORNE

func land():
	$jump_audio.stream = land_sfx
	$jump_audio.play()
	state = STATES.RUNNING

func apply_external_force(vec: Vector2):
	prints("something is trying to push away the pc:", vec)
	velocity = vec
	is_external_bounce = true
	state = STATES.AIRBORNE

func add_external_velocity(vel: Vector2):
	external_velocity = vel

func remove_external_velocity(): external_velocity = Vector2.ZERO

func take_damage():
	health -= 1
	if health <= 0:
		$hurt_box/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("die")
		$take_damage_audio.stream = die_sfx
		$take_damage_audio.play()
		state = STATES.DYING
	else:
		pass
	emit_signal("health_changed")

func _on_collect_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("collectables"):
		area.get_parent().collect()
		AudioController.play_cheese_collected()
		emit_signal("cheese_collected")

func _on_cheese_ray_freeing():
	active_cheese_rays -= 1
	if active_cheese_rays < 0: active_cheese_rays = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"die":
			var game = GlobalHelper.get_game()
			game.retry_current_room()
