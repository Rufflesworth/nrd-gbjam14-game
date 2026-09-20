extends Node

## [ Black, Shade, Midtone, Highlight ]
var PALETTE: Array = [Color.from_rgba8(62.0,58.0,66.0), Color.from_rgba8(135.0,114.0,134.0),
	 Color.from_rgba8(240.0,182.0,149.0), Color.from_rgba8(233.0,245.0,218.0)]

var title_screen_resource: PackedScene = preload("res://start_screen_stuff/start_screen.tscn")

func _ready() -> void:
	randomize()

func get_main() -> Node2D:
	var main: Node2D
	var tree = get_parent()
	main = tree.get_node("main")
	return main

func get_game() -> Node:
	var game: Node
	var tree = get_parent()
	game = tree.get_node("main/current_scene/game")
	return game

func goto_title_screen():
	change_scene(title_screen_resource)
	var scrn_trans = get_main().get_screen_transitioner()
	scrn_trans.start_transition_entrance()

func change_scene(scene: PackedScene):
	if (scene != null): call_deferred("deferred_change_scene", scene)

func deferred_change_scene(scene: PackedScene):
	var new_scene = scene.instantiate()
	var main = get_main()
	main.change_current_scene(new_scene)
