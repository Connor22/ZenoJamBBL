class_name ShieldPlayerState
extends PlayerState
## The state when the player is has just used the shield ability.

func _player_state_physics_process(delta):
	if player.velocity.length() > (player.sheild_friction * delta):
		player.velocity -= player.velocity.normalized() * (player.sheild_friction * delta)
	else:
		player_state_machine.transition_to("WalkingPlayerState")
	player.move_and_slide()


func _enter(init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Shield"
	# Get Direction, Impulse the velocity
	var direction = (player.get_global_mouse_position() - player.position).normalized()
	player.velocity = direction * player.sheild_max_speed
	# Enable col for impacts
	player.get_node("ImpactShape").monitorable = true
	player.get_node("ImpactShape").visible = true

func _exit(init_data: ={}):
	# Disable col for impacts
	player.get_node("ImpactShape").monitorable = false
	player.get_node("ImpactShape").visible = false
