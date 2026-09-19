extends StaticBody2D

const SPEED = 24.0

@export var patrol_distance: float
var cheese_bit_resource: PackedScene = preload("res://game_stuff/scenes/cheese_bit.tscn")
var health: int = 2
var velocity: Vector2
var home: Vector2
var web_color: Color

func _ready() -> void:
	velocity = Vector2(0.0, SPEED)
	home = global_position.round()
	web_color = GlobalHelper.PALETTE[0]

func _draw():
	var start_pos = home - global_position.round() - Vector2(0.0, 152.0)
	draw_line(start_pos, Vector2.ZERO, web_color, 1.0)

func _process(_delta):
	queue_redraw()

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
	if velocity.y > 0.0: # moving down:
		if global_position.y - home.y >= patrol_distance:
			global_position.y = home.y + patrol_distance
			velocity.y = -1.0 * SPEED
	else: # moving up
		if global_position.y - home.y < 0.0:
			global_position.y = home.y
			velocity.y = SPEED

func take_damage():
	health -= 1
	$AnimatedSprite2D.play("take_damage")
	if health <= 0:
		var chz_bit: Node2D
		for x in 3:
			chz_bit = cheese_bit_resource.instantiate()
			chz_bit.global_position = global_position
			var game = GlobalHelper.get_game()
			var room = game.get_room()
			room.call_deferred("add_child", chz_bit)
		$hurt_box/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("burst")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var dir: float = 1.0
		if global_position.x > pc.global_position.x: dir = -1.0
		var shove: Vector2 = Vector2(dir * 512.0, -96.0)
		pc.apply_external_force(shove)
		pc.take_damage()


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"take_damage": $AnimatedSprite2D.play("default")
		"burst": queue_free()
