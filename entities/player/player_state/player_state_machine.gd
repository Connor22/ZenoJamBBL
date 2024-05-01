class_name PlayerStateMachine
extends Node
## State machine tailored for player states.

# Emitted when transitioning to a new state.
signal player_transitioned(state_name: String)

@export var initial_state: NodePath
var current_state: PlayerState

# Setup for all available states that are children of this scene node:
func _ready():
	await(owner.ready)
	for child in get_children():
		child.player_state_machine = self
		child.player = owner
	current_state = get_node(initial_state)
	current_state._enter()

# Run the call-backs defined by our current state
func _input(event):
	current_state._player_state_input(event)
func _process(delta):
	current_state._player_state_process(delta)
func _physics_process(delta):
	current_state._player_state_physics_process(delta)

# Method called when states want to switch
func transition_to(target_path: String, init_data: ={}):
	if !has_node(target_path):
		return
	current_state._exit()
	current_state = get_node(target_path)
	current_state._enter(init_data)
	emit_signal("player_transitioned", current_state.name)
