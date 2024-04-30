class_name WalkingPlayerState
extends PlayerState
## The state when the player is free to walk around.

func _player_state_input(event: InputEvent):
	if event.is_action_pressed("aim_ability"):
		player_state_machine.transition_to("AimingPlayerState")

func _player_state_physics_process(delta):
	player.smooth_player_movement(delta)
	if player.velocity == Vector2.ZERO and not player.wants_to_move():
		player_state_machine.transition_to("IdlePlayerState")

func _enter(init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Walking"
