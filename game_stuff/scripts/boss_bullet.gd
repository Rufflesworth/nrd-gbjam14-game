extends CharacterBody2D

const SPEED = 64.0

var direction: float = 0.0
var target: Vector2 = Vector2.ZERO
var camera: Camera2D

func _ready() -> void:
	if target != Vector2.ZERO: velocity = (target - global_position).normalized() * SPEED
	else: velocity = Vector2(SPEED * direction, 0.0)
	camera = GlobalHelper.get_game().get_room().get_camera()

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	if absf(global_position.distance_to(camera.get_screen_center_position())) > 144.0:
		queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var dir: float = 1.0
		if global_position.x > pc.global_position.x: dir = -1.0
		var shove: Vector2 = Vector2(dir * 256.0, -64.0)
		pc.apply_external_force(shove)
		pc.take_damage()
		queue_free()
