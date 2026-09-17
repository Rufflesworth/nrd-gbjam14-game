extends Node2D

var game_resource: PackedScene = preload("res://game_stuff/scenes/game.tscn")
var music: AudioStreamWAV = preload("res://assets/audio/music/Title Theme.wav")

func _ready() -> void:
	AudioController.set_music_track(music)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_start"):
		GlobalHelper.change_scene(game_resource)
