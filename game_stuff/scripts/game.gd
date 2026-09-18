extends Node2D

signal retrying_current_room
signal room_completed
signal new_room_loaded
signal boss_room_loaded

@export var first_room: PackedScene
@export var stage_music: AudioStreamWAV

## [ Black, Shade, Midtone, Highlight ]
var PALETTE: Array = [Color.from_rgba8(53.0, 61.0, 70.0), Color.from_rgba8(0.0,0.0,0.0),
	 Color.from_rgba8(240.0,182.0,149.0), Color.from_rgba8(0.0,0.0,0.0)]

var current_room: Node2D
var current_room_resource: PackedScene

func _ready() -> void:
	load_stage()
	load_new_room(first_room)

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("player_select"):
		#retry_current_room()

func get_room() -> Node2D:
	var room: Node2D
	if $room.get_child_count() > 0: room = $room.get_child(0)
	return room

func get_camera(): return $camera

func load_stage():
	AudioController.set_music_track(stage_music)

func retry_current_room():
	#load_new_room(current_room_resource)
	call_deferred("deferred_retry_current_room")
	emit_signal("retrying_current_room")

func deferred_retry_current_room():
	if current_room_resource != null:
		var new_room = current_room_resource.instantiate()
		if current_room: current_room.free()
		$room.add_child(new_room)
		current_room = new_room
		call_deferred("emit_signal", "new_room_loaded")

func load_new_room(room: PackedScene):
	if room != null: call_deferred("deferred_load_new_room", room)

func deferred_load_new_room(room: PackedScene):
	var new_room = room.instantiate()
	if current_room: current_room.free()
	
	if new_room.room_type == 1: # boss room!
		call_deferred("emit_signal", "boss_room_loaded")
	
	$room.add_child(new_room)
	current_room_resource = room
	current_room = new_room
	current_room.connect("room_completed", _on_current_room_room_completed)
	call_deferred("emit_signal", "new_room_loaded")

func _on_current_room_room_completed():
	emit_signal("room_completed")
