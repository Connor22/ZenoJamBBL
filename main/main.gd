class_name Main
extends Node
## Entry point for game!
## "I provide indirect communication between my children." ($/root/Main)

# Request functions
func request_quit():
	# Save the game here, etc (rename func to request_save_and_quit)
	get_tree().quit()

# Submit functions
#...
