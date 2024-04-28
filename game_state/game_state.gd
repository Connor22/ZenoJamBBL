class_name GameState
extends Node
## "I am a blueprint for derived games states to inherit (gamplay, pause menu, ect)"

# PackedScene for when we enter each state
@export var state_scene: PackedScene
var state_scene_name: String:
	get:
		return state_scene._bundled["names"][0]
# Referance to keep track of the states current child scene
var current_scene: Node
# We need each GameState to be able to call the state machine for tranitions
var game_state_machine: GameStateMachine = null

# State specific call-backs ran by the game
func _game_state_input(event: InputEvent):
	# Definition supplied by child
	pass
func _game_state_process(delta):
	# Definition supplied by child
	pass
func _game_state_physics_process(delta):
	# Definition supplied by child
	pass

# State behaviour upon changing from one to another
func _enter(init_data: ={}):
	# Definition supplied by child
	pass

func _exit(init_data: ={}):
	# Definition supplied by child
	pass
