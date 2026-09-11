extends Node

#var title_screen_resource: PackedScene = preload("res://title_and_splash_screens/scenes/title_screen.tscn")

func get_game() -> Node:
	var game: Node
	var tree = get_parent()
	game = tree.get_node("game")
	return game

#func go_to_title_screen():
	#change_scene(title_screen_resource)

func change_scene(scene: PackedScene):
	if (scene != null): call_deferred("deferred_change_scene", scene)

func deferred_change_scene(scene: PackedScene):
	var newScene = scene.instantiate()
	var tree = get_tree()
	tree.current_scene.free()
	tree.root.add_child(newScene)
	tree.current_scene = newScene
