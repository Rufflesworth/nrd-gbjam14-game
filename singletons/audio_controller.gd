extends Node

### TODO: Since we are implementing PC death to be one-hit and basically instant respawn inside that
###			same room, we don't want the music playing inside that room as it'd restart everytime
###			the player'd die.
###		So it should be played here...
###		- we need ways to know what music to be playing
###		- and other stuff???

const VOLUME_STEP = 0.1

var transform_into_cheese_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/Cheese.wav")
var burst_into_cheese_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/Cheese Bits.wav")

var boot_volume = 0.5

func _ready() -> void:
	var masterIdx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(masterIdx, boot_volume)

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("audio_increase_volume")):
		increase_volume()
	elif (Input.is_action_just_pressed("audio_decrease_volume")):
		decrease_volume()

func set_music_track(music: AudioStreamWAV):
	$background_music.stream = music
	$background_music.play()

func stop_music_track():
	$background_music.stop()

func increase_volume():
	var masterIdx = AudioServer.get_bus_index("Master")
	var currentVolume = AudioServer.get_bus_volume_linear(masterIdx)
	if (currentVolume + VOLUME_STEP <= 1.0): AudioServer.set_bus_volume_linear(masterIdx, currentVolume + VOLUME_STEP)
	else: AudioServer.set_bus_volume_linear(masterIdx, 1.0)

func decrease_volume():
	var masterIdx = AudioServer.get_bus_index("Master")
	var currentVolume = AudioServer.get_bus_volume_linear(masterIdx)
	if (currentVolume - VOLUME_STEP >= 0.0): AudioServer.set_bus_volume_linear(masterIdx, currentVolume - VOLUME_STEP)
	else: AudioServer.set_bus_volume_linear(masterIdx, 0.0)

func play_transform_into_cheese():
	$cheese_audio.stream = transform_into_cheese_sfx
	$cheese_audio.play(0.0)

func play_burst_into_cheese():
	$cheese_audio.stream = burst_into_cheese_sfx
	$cheese_audio.play(0.0)

func play_cheese_collected():
	$cheese_collected.play(0.0)
