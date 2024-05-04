class_name Main
extends Node
## Entry point for game!
## "I provide indirect communication between my children." ($/root/Main)

## All levels as packed scenes for us to grab from anywhere
@export var packed_level_array: Array[PackedScene]


# Request functions
func request_quit():
	# Save the game here, etc (rename func to request_save_and_quit)
	get_tree().quit()

# Submit functions
#...
