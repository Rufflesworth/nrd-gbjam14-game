extends CharacterBody2D

signal freeing

const SPEED = 80.0

var camera: Camera2D
var direction: float = 0.0 # right = 1.0, left = -1.0

func _ready() -> void:
	velocity = Vector2(direction * SPEED, 0.0)
	camera = GlobalHelper.get_game().get_room().get_camera()

func _physics_process(delta: float) -> void:
	var screen_center: Vector2 = camera.get_screen_center_position()
	if absf(global_position.x - screen_center.x) > 88.0: despawn()
	
	var col = move_and_collide(velocity * delta)
	if col: impact()

func impact():
	despawn()

func despawn():
	queue_free()
	emit_signal("freeing")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("cheeseable_boxes"):
		prints("16by16 cheese ray hit")
		var chzd_obj = area.get_parent()
		chzd_obj._handle_hit_by_cheese_ray()
		impact()
	elif area.is_in_group("hurt_boxes"):
		var enemy = area.get_parent()
		enemy.take_damage()
		impact()
