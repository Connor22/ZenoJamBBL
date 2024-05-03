class_name PauseMenuState
extends GameState

var _paused_scene: Node
var _paused_state_path: String

func _game_state_input(event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_return_to_paused_scene()

func _enter(init_data: ={}):
	# If transitioning away from the paused state, we need a refence in order to free it.
	_paused_scene = init_data["paused_scene"] as Node
	_paused_state_path = init_data["paused_state_path"] as String
	current_scene = state_scene.instantiate()
	add_child.call_deferred(current_scene)
	# Subscribe state transitions
	current_scene.get_node("Overlay/PauseMenu/CenterContainer/VBoxContainer/Abort").pressed.connect(_on_abort_to_main_menu)

func _exit(init_data: ={}):
	# Unsubscribe state transitions
	current_scene.get_node("Overlay/PauseMenu/CenterContainer/VBoxContainer/Abort").pressed.disconnect(_on_abort_to_main_menu)
	current_scene.queue_free()
	
func _on_return_to_paused_scene():
	game_state_machine.transition_to(_paused_state_path)

func _on_abort_to_main_menu():
	_paused_scene.queue_free()
	game_state_machine.transition_to("MainMenuState")
