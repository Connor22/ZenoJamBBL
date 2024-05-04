class_name MainMenuState
extends GameState

func _enter(init_data: ={}):
	current_scene = state_scene.instantiate()
	add_child.call_deferred(current_scene)
	# Assign events to state transition
	current_scene.get_node("GUI/Menu/Quit").pressed.connect($/root/Main.request_quit)

func _exit(init_data: ={}):
	current_scene.queue_free()
