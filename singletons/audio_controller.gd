extends Node

const TITLE_THEME_LOOP = 1.20
const PLANET_THEME_LOOP = 8.60
const CREDITS_THEME_LOOP = 22.40
const VOLUME_STEP = 0.1

var title_music: AudioStreamWAV = preload("res://assets/audio/music/Title Theme.wav")
var planet_music: AudioStreamWAV = preload("res://assets/audio/music/Planet Theme.wav")
var boss_music: AudioStreamWAV = preload("res://assets/audio/music/Boss Theme.wav")
var credits_music: AudioStreamWAV = preload("res://assets/audio/music/Credits Theme.wav")
var transform_into_cheese_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/Cheese.wav")
var burst_into_cheese_sfx: AudioStreamWAV = preload("res://assets/audio/sfx/Cheese Bits.wav")

var boot_volume = 0.5
var music_loop_time: float = 0.0

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
	$background_music.play(0.0)
	music_loop_time = 0.0

func stop_music_track(): $background_music.stop()

func set_music_to_title_theme():
	set_music_track(title_music)
	music_loop_time = TITLE_THEME_LOOP

func set_music_to_planet_theme():
	set_music_track(planet_music)
	music_loop_time = PLANET_THEME_LOOP

func set_music_to_boss_theme():
	set_music_track(boss_music)
	music_loop_time = 0.0

func set_music_to_credits_theme():
	set_music_track(credits_music)
	music_loop_time = CREDITS_THEME_LOOP

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

func _on_background_music_finished() -> void:
	prints("background music finished playing! Looping manually!")
	$background_music.play(music_loop_time)
