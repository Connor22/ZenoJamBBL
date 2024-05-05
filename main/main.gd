class_name Main
extends Node
## Entry point for game!
## "I provide indirect communication between my children." ($/root/Main)

## All levels as packed scenes for us to grab from anywhere
var packed_level_array: Array[PackedScene]

func _init():
	var path = "res://level/level_scenes/"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var level = dir.get_next()
	while level != "":
		packed_level_array.append(load(path.path_join(level)))
		level = dir.get_next()

# Request functions
func request_quit():
	# Save the game here, etc (rename func to request_save_and_quit)
	get_tree().quit()

# Submit fu$GameStateMachinenctions
#...
