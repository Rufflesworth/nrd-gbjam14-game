extends Node2D

var pause_count: float = -1.0

func _ready() -> void:
	var scrn_trans = GlobalHelper.get_main().get_screen_transitioner()
	scrn_trans.start_transition_entrance()
	
	AudioController.connect("background_music_finished", _on_audio_controller_background_music_finished)
	AudioController.set_music_to_credits_theme(false)

func _process(delta: float) -> void:
	if pause_count > 0.0:
		pause_count -= delta
		if pause_count <= 0.0:
			$Label.text = "THE END?"
			$mysterious.play()

func _on_audio_controller_background_music_finished():
	#prints("handling credits theme finished")
	pause_count = 1.0

func _on_mysterious_finished() -> void:
	$laugh.play()

func _on_laugh_finished() -> void:
	var scrn_trans = GlobalHelper.get_main().get_screen_transitioner()
	scrn_trans.connect("transition_complete", _on_screen_transitioner_transition_completed)
	scrn_trans.start_transition_exit()

func _on_screen_transitioner_transition_completed():
	GlobalHelper.goto_title_screen()
