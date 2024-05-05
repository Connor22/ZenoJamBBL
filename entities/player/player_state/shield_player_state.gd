class_name ShieldPlayerState
extends PlayerState
## The state when the player is has just used the shield ability

var idle_direction: String

func _player_state_physics_process(delta):
	if player.velocity.length() > (player.shield_friction * delta):
		player.velocity -= player.velocity.normalized() * (player.shield_friction * delta)
	else:
		player_state_machine.transition_to("IdlePlayerState", {"idle_direction" = idle_direction})
	player.move_and_slide()
	
	if player.get_slide_collision_count():
		var collidedObject = player.get_last_slide_collision().get_collider()
		player.bash.emit(collidedObject, player.shield_direction)
		player_state_machine.transition_to("ImpactedPlayerState", {"idle_direction" = idle_direction})
		
	if player.get_node("ImpactShape").has_overlapping_areas():
		player_state_machine.transition_to("ImpactedPlayerState", {"idle_direction" = idle_direction})

func _enter(_init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Shield"
	# Update Direction, Impulse the velocity
	player.shield_direction = (player.get_global_mouse_position() - player.global_position).normalized()
	player.velocity = player.shield_direction * player.shield_max_speed
	# "Grow" Impact hitbox to regiter area_entered on area2d right next to player
	player.get_node("ImpactShape").scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(player.get_node("ImpactShape"), "scale", Vector2(1,1), 0.05)
	# Enable col for impacts
	_toggle_impact_shape(true)
	# Play animations:
	match rad_to_deg(player.shield_direction.angle()):
		var deg when deg >= -50 and deg <= 30:
			player.animations.play("shield_right")
			idle_direction = "right"
		var deg when deg >= 150 or deg <= -130:
			player.animations.play("shield_left")
			idle_direction = "left"
		var deg when deg >= 30 and deg <= 150:
			player.animations.play("shield_down")
			idle_direction = "down"
		var deg when deg >= -130 and deg <= -50:
			player.animations.play("shield_up")
			idle_direction = "up"

func _exit(_init_data: ={}):
	player.animations.stop()
	# Disable col for impacts
	$ImpactShapeLingerTimer.start()

func _on_impact_shape_linger_timer_timeout():
	_toggle_impact_shape(false)
	
func _toggle_impact_shape(toggle: bool):
	player.get_node("ImpactShape/CollisionShape2D").disabled = !toggle
	player.get_node("ImpactShape/CollisionShape2D").visible = toggle
