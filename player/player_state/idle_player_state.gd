class_name IdlePlayerState
extends PlayerState
## The state when the player is left alone.

func _player_state_input(event: InputEvent):
	if event.is_action_pressed("aim_ability"):
		player_state_machine.transition_to("AimingPlayerState")
	if player.wants_to_move():
		player_state_machine.transition_to("WalkingPlayerState")

func _enter(init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Idle"
