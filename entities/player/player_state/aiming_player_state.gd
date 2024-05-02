class_name AimingPlayerState
extends PlayerState
## The state when the player is aiming the shield ability

func _player_state_input(event: InputEvent):
	pass

func _player_state_physics_process(delta):
	player.smooth_player_movement(delta, 0.3)
	player.get_node("AimerPivot").look_at(player.get_global_mouse_position())
	if Input.is_action_just_released("aim_ability"):
		# Orientate the hitbox when confirmed
		player.get_node("ImpactShape").look_at(player.get_global_mouse_position())
		player_state_machine.transition_to("ShieldPlayerState")

func _enter(init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Aiming"
	# Point and show the visual aimer
	player.get_node("AimerPivot").look_at(player.get_global_mouse_position())
	player.get_node("AimerPivot/ColorRect").visible = true

func _exit(init_data: ={}):
	# Hide the visual aimer
	player.get_node("AimerPivot/ColorRect").visible = false
