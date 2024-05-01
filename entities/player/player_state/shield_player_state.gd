class_name ShieldPlayerState
extends PlayerState
## The state when the player is has just used the shield ability.

func _player_state_physics_process(delta):
	if player.velocity.length() > (player.sheild_friction * delta):
		player.velocity -= player.velocity.normalized() * (player.sheild_friction * delta)
	else:
		player_state_machine.transition_to("IdlePlayerState")
	player.move_and_slide()
	
	if player.get_slide_collision_count():
		player_state_machine.transition_to("ImpactedPlayerState")
		
	if player.get_node("ImpactShape").has_overlapping_areas() and player.get_node("ImpactShape").monitorable:
		player_state_machine.transition_to("ImpactedPlayerState")

func _enter(init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Shield"
	# Update Direction, Impulse the velocity
	player.shield_direction = (player.get_global_mouse_position() - player.position).normalized()
	player.velocity = player.shield_direction * player.sheild_max_speed
	# "Grow" Impact hitbox to regiter area_entered on area2d right next to player
	player.get_node("ImpactShape").scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(player.get_node("ImpactShape"), "scale", Vector2(1,1), 0.01)
	# Enable col for impacts
	_toggle_impact_shape(true)


func _exit(init_data: ={}):
	# Disable col for impacts
	$ImpactShapeLingerTimer.start()

func _toggle_impact_shape(toggle: bool):
	player.get_node("ImpactShape").monitorable = toggle
	player.get_node("ImpactShape").visible = toggle

func _on_impact_shape_linger_timer_timeout():
	_toggle_impact_shape(false)
