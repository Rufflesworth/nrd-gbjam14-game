extends StaticBody2D

var ingredient_resource: PackedScene = preload("res://game_stuff/scenes/ingredient.tscn")

func explode(pc_global_pos: Vector2):
	var ingredient = ingredient_resource.instantiate()
	var game = GlobalHelper.get_game()
	game.add_ingredient(ingredient)
	ingredient.global_position = global_position
	
	if global_position > pc_global_pos: # object is right of player character
		ingredient.direction = 1.0
	else: ingredient.direction = -1.0
	
	queue_free()
