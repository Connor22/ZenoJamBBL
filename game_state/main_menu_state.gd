class_name MainMenuState
extends GameState

func _enter(init_data: ={}):
	current_scene = state_scene.instantiate()
	add_child.call_deferred(current_scene)
	# Assign events to state transition
	current_scene.get_node("GUI/Menu/Play").pressed.connect(_on_game_entered)
	current_scene.get_node("GUI/Menu/Quit").pressed.connect($/root/Main.request_quit)

func _exit(init_data: ={}):
	# Removes delefates from events we previously assigned
	current_scene.get_node("GUI/Menu/Play").pressed.disconnect(_on_game_entered)
	current_scene.queue_free()

func _on_game_entered():
	game_state_machine.transition_to("GameplayState")
