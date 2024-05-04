class_name AimingPlayerState
extends PlayerState
## The state when the player is aiming the shield ability

func _player_state_input(_event: InputEvent):
	pass

func _player_state_physics_process(delta):
	player.smooth_player_movement(delta, 0.3)
	var aimer = player.get_node("AimerPivot") as Node2D
	aimer.look_at(player.get_global_mouse_position())
	# Animations:
	var animation_string = "none"
	var is_moving = player.wants_to_move()
	var sprite = player.get_node("SpritePivot/ShieldSquireSprites") as Sprite2D
	match rad_to_deg((player.get_global_mouse_position()-player.position).angle()):
		var deg when deg >= -50 and deg <= 30:
			animation_string = "walk_right"
			if !is_moving and player.animations.current_animation != "aim":
				player.animations.pause()
				sprite.frame = 0
				sprite.flip_h = false
		var deg when deg >= 150 or deg <= -130:
			animation_string = "walk_left"
			if !is_moving and player.animations.current_animation != "aim":
				player.animations.pause()
				sprite.frame = 0
				sprite.flip_h = true
		var deg when deg >= 30 and deg <= 150:
			animation_string = "walk_down"
			if !is_moving and player.animations.current_animation != "aim":
				player.animations.pause()
				sprite.frame = 3
				sprite.flip_h = false
		var deg when deg >= -130 and deg <= -50:
			animation_string = "walk_up"
			if !is_moving and player.animations.current_animation != "aim":
				player.animations.pause()
				sprite.frame = 6
				sprite.flip_h = false
	if is_moving and player.animations.current_animation != animation_string:
		player.animations.play(animation_string, -1, 0.5)
	
	if Input.is_action_just_released("aim_ability"):
		# Orientate the hitbox when confirmed
		player.get_node("ImpactShape").look_at(player.get_global_mouse_position())
		player_state_machine.transition_to("ShieldPlayerState")

func _enter(_init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Aiming"
	# Point and show the visual aimer
	player.get_node("AimerPivot").look_at(player.get_global_mouse_position())
	player.get_node("AimerPivot/ColorRect").visible = true
	# Blend aiming animation into walk
	player.animations.play("aim")

func _exit(_init_data: ={}):
	player.animations.stop()
	# Hide the visual aimer
	player.get_node("AimerPivot/ColorRect").visible = false
