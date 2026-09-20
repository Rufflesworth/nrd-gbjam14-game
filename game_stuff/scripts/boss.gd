extends CharacterBody2D

### TODO: we need a second half phase OR just continue the same thing for all four quarters of health?

signal health_changed

const MAX_HEALTH = 80
const ENTRANCE_TARGET = 40.0
const SHOOT_TIMER = 3.0

@export var player_character: CharacterBody2D

enum PHASES { HIDING, ENTRANCE, LAUGHING, BATTLE, HALF_HP, DEFEATED }
var phase: PHASES = PHASES.HIDING

var walking_enemy_resource: PackedScene = preload("res://game_stuff/enemies_hazards/walking_enemy.tscn")
var bullet_resource: PackedScene = preload("res://game_stuff/scenes/boss_bullet.tscn")

var health: int
var shoot_count: float
var current_bullet
var rightside_lackey: Node2D
var leftside_lackey: Node2D

func _ready() -> void:
	if player_character == null: printerr(self, "doesn't have the player character reference assigned!")
	health = MAX_HEALTH
	AudioController.stop_music_track()

func _physics_process(delta: float) -> void:
	match phase:
		PHASES.ENTRANCE:
			velocity = Vector2(0.0, 32.0)
			move_and_slide()
			if global_position.y >= ENTRANCE_TARGET:
				global_position.y = ENTRANCE_TARGET
				$laugh.play()
				$AnimatedSprite2D.play("laugh")
				GlobalHelper.get_game().get_boss_life_bar().boss_entered(self)
				GlobalHelper.get_game().get_pc_life_bar().boss_entered()
				phase = PHASES.LAUGHING
		PHASES.LAUGHING:
			pass
		PHASES.BATTLE:
			shoot_count += delta
			if shoot_count >= SHOOT_TIMER: shoot()
			
			if health <= MAX_HEALTH * 0.5:
				# at half health, make the player go to the other side!
				if player_character.global_position.x >= global_position.x:
					rightside_lackey.queue_free()
				else: leftside_lackey.queue_free()
				phase = PHASES.HALF_HP
		PHASES.HALF_HP:
			shoot_count += delta
			if shoot_count >= SHOOT_TIMER: shoot()

func shoot():
	if current_bullet == null:
		var room = GlobalHelper.get_game().get_room()
		var bullet = bullet_resource.instantiate()
		current_bullet = bullet
		# pc is up on the platforms shooting us from the side
		if player_character.global_position.y < 48.0:
			if player_character.global_position.x > global_position.x:
				bullet.direction = 1.0
				bullet.global_position = $right_cannon.global_position
			else:
				bullet.direction = -1.0
				bullet.global_position = $left_cannon.global_position
		# pc is down below us like a fish in a barrel!!!
		else:
			bullet.global_position = $center_cannon.global_position
			bullet.target = player_character.global_position
		room.add_child(bullet)
		shoot_count = randf()

func take_damage():
	health -= 1
	if health <= 0:
		prints("BOSS DEFEATED!!! GG!!!")
		$hurt_box/CollisionShape2D.set_deferred("disabled", true)
		$hit_box/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("defeated")
		phase = PHASES.DEFEATED
	elif health % (MAX_HEALTH / 4) == 0: # every quarter hp lost
		$AnimatedSprite2D.play("laugh")
		$laugh.play()
		if rightside_lackey != null: rightside_lackey.revive()
		if leftside_lackey != null: leftside_lackey.revive()
		if current_bullet: current_bullet.queue_free()
		shove_pc_away()
	else:
		$AnimatedSprite2D.play("take_damage")
	$take_damage_audio.play()
	
	emit_signal("health_changed")

func shove_pc_away():
	var dir: float = 1.0
	if global_position.x > player_character.global_position.x: dir = -1.0
	var shove: Vector2 = Vector2(dir * 512.0, -96.0)
	player_character.apply_external_force(shove)

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		shove_pc_away()
		pc.take_damage()

func _on_laugh_finished() -> void:
	if phase == PHASES.LAUGHING:
		AudioController.set_music_to_boss_theme()
		phase = PHASES.BATTLE
	$AnimatedSprite2D.play("default")

func _on_pc_detection_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_stuffs"):
		prints("player character detected by boss!")
		
		# spawn in two walking enemies to fall from the sky!
		var room = GlobalHelper.get_game().get_room()
		var enemy = walking_enemy_resource.instantiate()
		enemy.global_position = global_position + Vector2(32.0, 0.0)
		rightside_lackey = enemy
		room.add_enemy_hazard(enemy)
		enemy = walking_enemy_resource.instantiate()
		enemy.global_position = global_position + Vector2(-32.0, 0.0)
		leftside_lackey = enemy
		room.add_enemy_hazard(enemy)
		
		$pc_detection_box/CollisionShape2D.set_deferred("disabled", true)
		$fake_cheese_of_power.play("fade")
		
		phase = PHASES.ENTRANCE

func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"take_damage":
			$AnimatedSprite2D.play("default")
