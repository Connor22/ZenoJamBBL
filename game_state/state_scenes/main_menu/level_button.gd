extends Button

@export var level_index: int

func _ready():
	# Assign events to state transition
	var game_state_machine = $/root/Main/GameStateMachine as GameStateMachine
	connect("pressed", func(): game_state_machine.transition_to("GameplayState", {"level_index" = level_index}))
