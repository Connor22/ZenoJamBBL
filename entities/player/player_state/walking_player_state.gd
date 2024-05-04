class_name WalkingPlayerState
extends PlayerState
## The state when the player is free to walk around.

func _player_state_input(event: InputEvent):
	if event.is_action_pressed("aim_ability"):
		player_state_machine.transition_to("AimingPlayerState")

func _player_state_physics_process(delta):
	player.smooth_player_movement(delta)
	# Animations:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	match direction:
		var vec2 when vec2.x > 0:
			if player.animations.current_animation != "walk_right":
				player.animations.play("walk_right")
		var vec2 when vec2.x < 0:
			if player.animations.current_animation != "walk_left":
				player.animations.play("walk_left")
		var vec2 when vec2.y > 0:
			if player.animations.current_animation != "walk_down":
				player.animations.play("walk_down")
		var vec2 when vec2.y < 0:
			if player.animations.current_animation != "walk_up":
				player.animations.play("walk_up")
	
	if player.velocity == Vector2.ZERO and not player.wants_to_move():
		player_state_machine.transition_to("IdlePlayerState")

func _enter(_init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Walking"

func _exit(_init_data: ={}):
	player.animations.pause()
