extends CharacterBody2D

### TODO: HOW IN THE WORLD DO WE HANDLE BREWING?!?!?!?!
###		We reference some table or whatever of ingredient combinations
###		Then get the cauldron to instantiate that resource and put it into the world

const SPEED = 8.0

enum STATES { IDLE, SEEKING, BREWING }
var state: STATES = STATES.IDLE

var target_ingredient: Node2D = null
var direction: float = 0.0
var fallen_ingredients: Array = []
var ingredient_one: Node2D = null
var ingredient_two: Node2D = null

func _physics_process(_delta: float) -> void:
	match state:
		STATES.IDLE:
			if target_ingredient == null and fallen_ingredients.size() > 0:
				prints("trying to select new target from idle")
				select_new_target()
			update_held_ingredients()
		STATES.SEEKING:
			velocity = Vector2(direction * SPEED, 0.0)
			move_and_slide()
			update_held_ingredients()
		STATES.BREWING:
			prints("cauldron buuddy trying to brew, but it is not implemented!!!!")

func update_held_ingredients():
	if ingredient_one != null:
		ingredient_one.global_position = global_position + Vector2(-8.0, -8.0)
	if ingredient_two != null:
		ingredient_two.global_position = global_position + Vector2(8.0, -8.0)

func set_direction():
	if state != STATES.BREWING:
		if target_ingredient != null:
			if global_position.x < target_ingredient.global_position.x:
				direction = 1.0
			else: direction = -1.0

func select_new_target():
	if state != STATES.BREWING:
		if fallen_ingredients.size() > 0:
			var new_target = fallen_ingredients[0]
			var distance
			var target_distance
			for x in fallen_ingredients.size():
				target_distance = absf(global_position.x - new_target.global_position.x)
				distance = absf(global_position.x - fallen_ingredients[x].global_position.x)
				if distance < target_distance:
					new_target = fallen_ingredients[x]
			target_ingredient = new_target
			set_direction()
			state = STATES.SEEKING
		else: # no more ingredients to seek
			#prints("no more ingredients for cauldron buddy to seek!")
			state = STATES.IDLE

func _on_ingredient_detector_body_entered(body: Node2D) -> void:
	if (body.is_in_group("ingredients")):
		#prints("cauldron buddy detected new ingredient nearby")
		fallen_ingredients.push_back(body)
		if target_ingredient == null: select_new_target()

func _on_ingredient_picker_body_entered(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		if ingredient_one == null or ingredient_two == null:
			
			body.capture()
			
			if ingredient_one == null:
				ingredient_one = body
			elif ingredient_two == null:
				ingredient_two = body
				ingredient_one.global_position = global_position + Vector2(-8.0, -8.0)
				ingredient_two.global_position = global_position + Vector2(8.0, -8.0)
				state = STATES.BREWING
			
			direction = 0.0 # stop moving
			fallen_ingredients.erase(body) # remove from catalog
			target_ingredient = null
			select_new_target() # look for new ingredient to seek
