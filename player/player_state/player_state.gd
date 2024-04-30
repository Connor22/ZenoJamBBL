class_name PlayerState
extends Node
## "I am a blueprint for derived games states to inherit' (Walking, Idle, Sheild ability, Stunned... )

# We need each PlayerState to access the Player
var player: Player = null
# We need each PlayerState to be able to call the state machine for tranitions
var player_state_machine: PlayerStateMachine = null

# State specific call-backs ran by the game
func _player_state_input(event: InputEvent):
	# Definition supplied by child
	pass
func _player_state_process(delta):
	# Definition supplied by child
	pass
func _player_state_physics_process(delta):
	# Definition supplied by child
	pass

# State behaviour upon changing from one to another
func _enter(init_data: ={}):
	# Definition supplied by child
	pass
func _exit(init_data: ={}):
	# Definition supplied by child
	pass
