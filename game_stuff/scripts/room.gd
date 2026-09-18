extends Node2D

signal room_completed

@export_enum("normal:0", "boss:1") var room_type: int

func _ready() -> void:
	$room_exit.connect("exit_reached", _on_room_exit_reached)

func get_player_character(): return $player_character

func get_camera(): return $camera

func get_boss(): return $boss

func add_enemy_hazard(obj: Node2D):
	$level_objects.add_child(obj)

func _on_room_exit_reached():
	emit_signal("room_completed")
