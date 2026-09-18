extends Node2D

@export var spawn_timer: float = 3.0
@export var initial_delay: float = 0.0
var spiky_fruit_resource: PackedScene = preload("res://game_stuff/enemies_hazards/falling_spiky_fruit.tscn")
var spawn_count: float

func _ready() -> void:
	spawn_count = spawn_timer + initial_delay

func _physics_process(delta: float) -> void:
	spawn_count -= delta
	if spawn_count <= 0.0:
		spawn_fruit()
		spawn_count = spawn_timer

func spawn_fruit():
	var fruit = spiky_fruit_resource.instantiate()
	var room = GlobalHelper.get_game().get_room()
	fruit.global_position = global_position
	room.add_enemy_hazard(fruit)
