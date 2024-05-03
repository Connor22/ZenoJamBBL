class_name GameplayState
extends GameState
## "I provide functionality relating to the gameplay state."

func _game_state_input(event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		current_scene.process_mode = Node.PROCESS_MODE_DISABLED
		game_state_machine.transition_to("PauseMenuState", {"paused_scene" : current_scene, "paused_state_path" : name})

func _enter(init_data: ={}):
	# Checks for previous puased state
	if has_node(state_scene_name):
		current_scene.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		current_scene = state_scene.instantiate()
		add_child.call_deferred(current_scene)

func _exit(init_data: ={}):
	# Check to prevent puased scene from being deleted.
	if current_scene.process_mode != Node.PROCESS_MODE_DISABLED:
		current_scene.queue_free()
