extends Node2D

signal retrying_current_room
signal new_room_loaded

@export var first_room: PackedScene

var current_room: Node2D
var current_room_resource: PackedScene

func _ready() -> void:
	load_new_room(first_room)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_select"):
		retry_current_room()

func get_room() -> Node2D:
	var room: Node2D
	if $room.get_child_count() > 0: room = $room.get_child(0)
	return room

func get_camera(): return $camera

func retry_current_room():
	load_new_room(current_room_resource)
	emit_signal("retrying_current_room")

func load_new_room(room: PackedScene):
	if (room != null): call_deferred("deferred_load_new_room", room)

func deferred_load_new_room(room: PackedScene):
	var new_room = room.instantiate()
	#$room.get_child(0).free()
	if current_room: current_room.free()
	$room.add_child(new_room)
	current_room_resource = room
	current_room = new_room
	call_deferred("emit_signal", "new_room_loaded")
