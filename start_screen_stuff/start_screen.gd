extends Node2D

const WAVE_LOOPS = 6
const BREATHER_LOOPS = 4

var game_resource: PackedScene = preload("res://game_stuff/scenes/game.tscn")

enum STATES { WAITING, STARTING }
var state: STATES = STATES.WAITING
var mouse_velocity: Vector2 = Vector2.ZERO

var mouse_count: int = 0

func _ready() -> void:
	AudioController.set_music_to_title_theme()

func _process(_delta: float) -> void:
	match state:
		STATES.WAITING:
			if Input.is_action_just_pressed("player_start"):
				$selected.play(0.0)
				AudioController.stop_music_track()
				$push_start.hide()
				state = STATES.STARTING
		STATES.STARTING: pass

func _physics_process(delta: float) -> void:
	if mouse_velocity != Vector2.ZERO:
		$mouse_ship.global_position += mouse_velocity * delta
		if $mouse_ship.global_position.y <= $planet.global_position.y:
			mouse_velocity = Vector2.ZERO

func _on_selected_finished() -> void:
	$start_pressed.play(0.0)

func _on_start_pressed_finished() -> void:
	$mouse_ship.play("retract")

func _on_screen_transitioner_transition_completed():
	GlobalHelper.change_scene(game_resource)

func _on_mouse_ship_animation_finished() -> void:
	match $mouse_ship.animation:
		"retract":
			mouse_velocity = Vector2(0.0, -48.0)
			$mouse_ship.play("fly_off")
		"fly_off":
			var scrn_trans = GlobalHelper.get_main().get_screen_transitioner()
			scrn_trans.connect("transition_complete", _on_screen_transitioner_transition_completed)
			scrn_trans.start_transition_exit()

func _on_mouse_ship_animation_looped() -> void:
	match $mouse_ship.animation:
		"hand_wave":
			mouse_count += 1
			if mouse_count > WAVE_LOOPS:
				$mouse_ship.play("breather")
				mouse_count = 0
		"breather":
			mouse_count += 1
			if mouse_count > BREATHER_LOOPS:
				$mouse_ship.play("hand_wave")
				mouse_count = 0
