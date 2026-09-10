extends Node2D

### We are imagining this could be used by any game object or event
### The initiating object is likely the one controlling the flow of things
### So it can connect to the dialogue_box's finished signal and simply
###		wait until it receives it

### One thought is to have the dialogue box handle more of the logical flow of things
### Simple process like:
###		- Connect to the finished signal, so things can know when to start up again
###		- Set Dialogue (one or more strings)
###		- Start Dialogue

### I suppose it depends upon what is all going on with the specific game and its systems
### But things like:
###		- disabling the player_character
###		- whatever else is relevant to the style of game
### I suppose it all depends upon when dialogue can even occur.
### Whether in a completely safe environment or what not

### Some kind of typical scenario might go like:
### The player walks up to an NPC and presses 'A'
### Then what all occurs?
###		The player character stops responding to player input
###		DialogueBox pops up
###		DialogueBox is supplied with some amount of dialogue
###		The player's input is now directed into advancing through the dialogue
###		Once there is no more dialogue to read
###		We hide the DialogueBox
###		Return control the the player character
###		And the game continues on!

signal finished

const INPUT_DELAY = 0.5

var input_delay_counter: float

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	input_delay_counter += delta
	if input_delay_counter > INPUT_DELAY:
		if Input.is_action_just_pressed("player_a"):
			input_delay_counter = 0.0
			# advance dialogue or dismiss dialogue box
			finish()

func set_dialogue(text: String):
	$dialogue.text = text

#func start():
	#var player = get_parent().get_player()
	#player.disable()
	#input_delay_counter = 0.0
	#show()

func finish():
	emit_signal("finished")
