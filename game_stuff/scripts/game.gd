extends Node2D

func add_ingredient(ingr: Node2D):
	$ingredients.call_deferred("add_child", ingr)
