extends Node

const VOLUME_STEP = 0.1

var boot_volume = 0.5

func _ready() -> void:
	var masterIdx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(masterIdx, boot_volume)

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("audio_increase_volume")):
		increase_volume()
	elif (Input.is_action_just_pressed("audio_decrease_volume")):
		decrease_volume()

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

#func get_volume() -> float:
	#var vol: float = 0.0
	#var masterIdx = AudioServer.get_bus_index("Master")
	#vol = AudioServer.get_bus_volume_db(masterIdx)
	#return vol
#
#func set_volume(val: float):
	#var masterIdx = AudioServer.get_bus_index("Master")
	##var currentVolume = AudioServer.get_bus_volume_db(masterIdx)
	#if (val <= 0.0 and val >= -60.0): AudioServer.set_bus_volume_db(masterIdx, val)
