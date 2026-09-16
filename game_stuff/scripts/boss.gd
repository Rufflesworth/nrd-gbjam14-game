extends CharacterBody2D

### TODO: Hook up the boss to the boss life bar
### TODO: Hook up the boss music!
### TODO: Have a laugh phase!!!
### NOTE: I think we can allow the player to muck about (meaning not dealing with disabling input)
###			if they cannot accomplish anything while the boss does their thing.

signal health_changed

const ENTRANCE_TARGET = 40.0

enum PHASES { ENTRANCE, LAUGH }
var phase: PHASES = PHASES.ENTRANCE

var health: int = 80

func _physics_process(delta: float) -> void:
	match phase:
		PHASES.ENTRANCE:
			velocity = Vector2(0.0, 32.0)
			move_and_slide()
			if global_position.y >= ENTRANCE_TARGET:
				global_position.y = ENTRANCE_TARGET
				prints("The boss has entered!")
				phase = PHASES.LAUGH

func take_damage():
	prints(self, "doesn't implement take_damage()!")
	health -= 3
	if health <= 0:
		prints("BOSS DEFEATED!!! GG!!!")
		$hurt_box/CollisionShape2D.set_deferred("disabled", true)
	emit_signal("health_changed")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_stuffs") and area.is_in_group("hurt_boxes"):
		var pc = area.get_parent()
		var dir: float = 1.0
		if global_position.x > pc.global_position.x: dir = -1.0
		var shove: Vector2 = Vector2(dir * 384.0, -96.0)
		#match state:
			#STATES.NORMAL:
		pc.apply_external_force(shove)
		pc.take_damage()
			#STATES.CHEESE:
				#pc.apply_external_force(Vector2(0.0, -216.0))
				#$AnimatedSprite2D.play("bounce")
				#$AnimatedSprite2D.frame = 0
				#$boing_audio.play(0.0)
