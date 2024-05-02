class_name ImpactedPlayerState
extends PlayerState
## Rebound after impacting something with the shield ability.

func _player_state_physics_process(delta):
	if player.velocity.length() > (player.walking_friction * delta):
		player.velocity -= player.velocity.normalized() * (player.walking_friction * delta)
		player.move_and_slide()
	else:
		player_state_machine.transition_to("IdlePlayerState")

func _enter(init_data: ={}):
	player.get_node("SpritePivot/StateTemp").text = "Impacted"
	# Impulse the velocity in opposite direction
	player.velocity = -player.shield_direction.rotated(randf_range(-0.6,0.6)) * player.rebound_impulse
