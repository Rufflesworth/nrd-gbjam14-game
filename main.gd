extends Node2D

@export var first_scene: PackedScene

var current_scene

func _ready():
	if first_scene == null: printerr(self, "has no first scene assigned!!!")
	else:
		current_scene = first_scene.instantiate()
		$current_scene.add_child(current_scene)

func get_current_scene(): return $current_scene.get_child(0)

func change_current_scene(new_scene: Node2D):
	if current_scene: current_scene.free()
	
	current_scene = new_scene
	$current_scene.add_child(new_scene)

func get_screen_transitioner() -> Node2D: return $CanvasLayer/screen_transitioner
