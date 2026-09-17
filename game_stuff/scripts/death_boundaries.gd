extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var shove: Vector2 = Vector2(0.0, -256.0)
		pc.apply_external_force(shove)
		pc.take_damage()
