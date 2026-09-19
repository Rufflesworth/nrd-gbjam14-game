extends Node2D

signal transition_complete

const SCREEN_IN_TILES: Vector2 = Vector2(10.0, 9.0)
const ADD_TILE_TIMER = 0.01

enum STATES { WAITING, TRANSITIONING }
var state: STATES = STATES.WAITING

var num_tiles_to_draw: int = 0
var num_tiles_to_skip: int = -1
var add_tile_count: float = 0.0
var is_transitioning_entrance: bool = false

func _draw() -> void:
	if state == STATES.TRANSITIONING:
		var tile: Rect2
		var shade: Color = GlobalHelper.PALETTE[0]
		var xcoord: float
		var ycoord: float
		for x in num_tiles_to_draw:
			
			if x <= num_tiles_to_skip: continue
			
			xcoord = fmod(x, 10.0) * 16.0
			ycoord = floorf(x / 10.0) * 16.0
			tile = Rect2(xcoord, ycoord, 16.0, 16.0)
			draw_rect(tile, shade)

func _process(delta: float) -> void:
	match state:
		STATES.WAITING: pass
		STATES.TRANSITIONING:
			add_tile_count += delta
			if add_tile_count >= ADD_TILE_TIMER:
				if not is_transitioning_entrance:
					num_tiles_to_draw += 1
					if num_tiles_to_draw > (SCREEN_IN_TILES.x * SCREEN_IN_TILES.y):
						emit_signal("transition_complete")
						state = STATES.WAITING
					else:
						queue_redraw()
						add_tile_count = 0.0
				else: # removing tiles to remove black screen
					num_tiles_to_skip += 1
					if num_tiles_to_skip > (SCREEN_IN_TILES.x * SCREEN_IN_TILES.y):
						num_tiles_to_draw = 0
						num_tiles_to_skip = -1
						add_tile_count = 0.0
						emit_signal("transition_complete")
						state = STATES.WAITING
					else:
						queue_redraw()
						add_tile_count = 0.0

func start_transition_exit():
	is_transitioning_entrance = false
	state = STATES.TRANSITIONING

func start_transition_entrance():
	is_transitioning_entrance = true
	state = STATES.TRANSITIONING
