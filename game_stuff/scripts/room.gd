extends Node2D

@export_enum("normal:0", "boss:1") var room_type: int

func get_player_character(): return $player_character

func get_camera(): return $camera

func get_boss(): return $boss
