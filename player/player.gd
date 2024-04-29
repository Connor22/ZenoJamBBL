class_name Player
extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	# Get the input direction and handle the movement
	var direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	velocity = direction * SPEED
	move_and_slide()
