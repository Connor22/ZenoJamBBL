class_name IdlePlayerState
extends PlayerState
## The state when the player is left alone.

func _player_state_input(event: InputEvent):
	if event.is_action_pressed("aim_ability"):
		player_state_machine.transition_to("AimingPlayerState")

func _player_state_physics_process(_delta):
	if player.wants_to_move():
		player_state_machine.transition_to("WalkingPlayerState")

func _enter(init_data: ={}):
	if (init_data.has("idle_direction")):
		var sprite = player.get_node("SpritePivot/ShieldSquireSprites") as Sprite2D
		match init_data["idle_direction"]:
			"left":
				sprite.frame = 0
				sprite.flip_h = true
			"right":
				sprite.frame = 0
				sprite.flip_h = false
			"up":
				sprite.frame = 6
				sprite.flip_h = false
			"down":
				sprite.frame = 3
				sprite.flip_h = false
	player.animations.play("idle")
	player.velocity = Vector2.ZERO
	player.get_node("SpritePivot/StateTemp").text = "Idle"

func _exit(_init_data: ={}):
	player.animations.stop()
