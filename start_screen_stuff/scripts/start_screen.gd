extends Node2D

var game_resource: PackedScene = preload("res://game_stuff/scenes/game.tscn")
var music: AudioStreamWAV = preload("res://assets/audio/music/Title Theme.wav")

enum STATES { WAITING, STARTING }
var state: STATES = STATES.WAITING

func _ready() -> void:
	AudioController.set_music_track(music)

func _process(_delta: float) -> void:
	match state:
		STATES.WAITING:
			if Input.is_action_just_pressed("player_start"):
				$selected.play(0.0)
				state = STATES.STARTING
		STATES.STARTING: pass

func _on_selected_finished() -> void:
	$start_pressed.play(0.0)

func _on_start_pressed_finished() -> void:
	var scrn_trans = GlobalHelper.get_main().get_screen_transitioner()
	scrn_trans.connect("transition_complete", _on_screen_transitioner_transition_completed)
	scrn_trans.start_transition_exit()

func _on_screen_transitioner_transition_completed():
	GlobalHelper.change_scene(game_resource)
