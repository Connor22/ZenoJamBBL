class_name Player
extends CharacterBody2D
@export var walking_max_speed = 250
@export var walking_acceleration = 5000
@export var walking_friction = 2000
@export var sheild_max_speed = 2000
@export var sheild_friction = 14000
@export var reflect_impulse = 800
@export var push_impulse = 50
var shield_direction := Vector2.ZERO
@onready var animations = $AnimationPlayer

# Reuseble functionality to avoid duplicate code in player states
func smooth_player_movement(delta: float, multi: float = 1):
	# Get the input direction and handle the movement
	var direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	match [direction]:
		[Vector2.ZERO] when velocity.length() > (walking_friction * delta * multi):
			velocity -= velocity.normalized() * (walking_friction * delta * multi)
		[Vector2.ZERO]:
			velocity = Vector2.ZERO
		_:
			velocity += (direction * walking_acceleration * delta * multi)
			velocity = velocity.limit_length(walking_max_speed * multi)
	move_and_slide()

func wants_to_move() -> bool:
	return Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")\
	or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
# ----------------------------------------------------------------
