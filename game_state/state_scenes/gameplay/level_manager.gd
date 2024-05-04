class_name LevelManager
extends CanvasLayer

var _current_level: int = 0

func initiate_level(index: int):
	_current_level = index
	var main = $/root/Main as Main
	var packed_level = main.packed_level_array[index] as PackedScene
	var level = packed_level.instantiate()
	add_child(level)
