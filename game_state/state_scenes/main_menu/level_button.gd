extends Button

var level_index: int

func _ready():
	text = name
	level_index = int(name.trim_prefix("Level ")) - 1
	# Assign events to state transition
	var game_state_machine = $/root/Main/GameStateMachine as GameStateMachine
	connect("pressed", func(): game_state_machine.transition_to("GameplayState", {"level_index" = level_index}))
