extends Node2D

@export var next_scene: PackedScene

const TIMER = 5.0

var timer_count = 0.0

func _process(delta: float) -> void:
	timer_count += delta
	if timer_count >= TIMER: GlobalHelper.change_scene(next_scene)
