class_name LevelManager
extends CanvasLayer

var _current_index: int = 0

func initiate_level(index: int):
	# Initiate this level
	_current_index = index
	var main = $/root/Main as Main
	var packed_level = main.packed_level_array[index] as PackedScene
	var level = packed_level.instantiate() as Level
	add_child.call_deferred(level)
	# When the player completes this level, go to the next
	level.level_exit.connect("level_complete", next_level)

func next_level():
	for node in get_children():
		node.queue_free()
	_current_index += 1
	initiate_level(_current_index)
