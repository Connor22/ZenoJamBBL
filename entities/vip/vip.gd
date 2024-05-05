class_name VIP
extends RigidBody2D

enum Motivation { MOTIVATED, DEMOTIVATED, PEEVED }

@export var target: Node2D
## What motivation the knight starts at
@export var StartingMotivation: Motivation = Motivation.MOTIVATED
## Should the target match the position of the knight or simply move towards it
@export var TargetJump: bool = true
@export var ShouldRefresh: bool = true

@export_category("Debug")
@export var debug: bool = false
@export var print_location: bool = false
@export var clr: Color = Color("red")

var currentMorale: Morale
var currentMotivation: Motivation
var move: bool = true

const moraleStates: Array[Morale] = [
	preload("res://entities/vip/MoraleStates/Motivated.tres"),
	preload("res://entities/vip/MoraleStates/Demotivated.tres"),
	preload("res://entities/vip/MoraleStates/Peeved.tres")
]

# debug
var line_exists: bool = false
var distance_to_target: float
var closest_offset: float
var progress: float

# var to help with waiting after being hit
var timer: float = 0.0

func _ready():
	contact_monitor = true
	currentMorale = moraleStates[StartingMotivation]
	currentMotivation = StartingMotivation
	
	var parent = get_parent()
	var player = parent.find_child("Player") as Player
	player.connect("bash", _on_player_bash)

func _draw():
	if ProjectSettings.get_setting("debug"):
		draw_set_transform_matrix(global_transform.affine_inverse())
		draw_line(global_position, target.global_position, clr, 2.0)
		# print("drawing line from ", global_position, " to ", target.global_position)
	else:
		draw_set_transform_matrix(global_transform.affine_inverse())
		draw_line(global_position, target.global_position, Color(1, 1, 1, 0), 2.0)

func _process(delta):
	if (timer):
		timer -= delta
		if (timer < 0): 
			move = true
			timer = 0.0

func _physics_process(delta):
	var path = target.get_parent()
	
	distance_to_target = global_position.distance_to(target.global_position)
	progress = target.get_progress()
	closest_offset = path.curve.get_closest_offset(path.to_local(global_position))
	
	if move: 
		# Pull vip to target when outside the min pull distance
		if distance_to_target > currentMorale.VipMinPullDistance:
			global_position = global_position.move_toward(target.global_position, delta * currentMorale.VIPTowardsTargetSpeed)
		
		# Avoid interpolation issues when too close
		if global_position.distance_to(target.global_position) < 0.1:
			global_position = target.global_position
		
		# Target slowly returns to beginning
		target.set_progress(target.get_progress() - (currentMorale.TargetBackwardsSpeed * delta))
		
		if ShouldRefresh && target.get_progress() == 0:
			currentMotivation = Motivation.MOTIVATED
			currentMorale = moraleStates[currentMotivation]
			
	# Decrease speed after being basheds
	if !linear_velocity.is_zero_approx():
		linear_damp = (distance_to_target / currentMorale.DecelerationDistance) * (1/currentMorale.SecondsToStop)
		if linear_velocity.length() < 10:
			linear_velocity.x = 0
			linear_velocity.y = 0
	else:
		linear_damp = 0.5
	
	# If we're a certain distance away, move the target closer to us along the path
	if (distance_to_target > currentMorale.TargetPullDistance) && (linear_velocity.length_squared() > 10):
		if TargetJump:
			target.set_progress(closest_offset)
		else:
			target.set_progress(target.get_progress() + delta * currentMorale.TargetPullSpeed)
			# if we want speed to change based on distance
				#actualPullSpeed = clampf( 
				#currentMorale.TargetPullSpeed * (target.get_progress() - closest_offset),
				#0,
				#MaxPullSpeed)
	
	# Handle animation in physics process (?)
	_handle_animation()
	
	# Debug
	if ProjectSettings.get_setting("debug"):
		queue_redraw() 
		line_exists = true
	elif line_exists:
		queue_redraw()
		line_exists = false

func _unhandled_input(event):
	# Debug code to test motivation presets live
	if ProjectSettings.get_setting("debug") and event is InputEventKey and event.pressed:
		if event.keycode == KEY_I:
			currentMorale = moraleStates[Motivation.MOTIVATED]
		if event.keycode == KEY_O:
			currentMorale = moraleStates[Motivation.DEMOTIVATED]
		if event.keycode == KEY_P:
			currentMorale = moraleStates[Motivation.PEEVED]

func _handle_animation():
	# Determine which angle to use based on if the VIP is
	# being pushed or not
	var deg: float
	if !linear_velocity.is_zero_approx():
		deg = rad_to_deg(linear_velocity.angle())
	else:
		deg = rad_to_deg(get_angle_to(target.global_position))
	
	match deg:
		_ when (!linear_velocity.is_zero_approx() && linear_velocity.length() < 10):
			if $AnimationPlayer.current_animation != "sleep":
				$AnimationPlayer.play("sleep")
		_ when (linear_velocity.is_zero_approx() && (target.get_progress() == 0 && distance_to_target < currentMorale.VipMinPullDistance)):
			if $AnimationPlayer.current_animation != "sleep":
				$AnimationPlayer.play("sleep")
		deg when deg >= -50 and deg <= 30:
			if $AnimationPlayer.current_animation != "walk_right":
				$AnimationPlayer.play("walk_right")
		deg when deg >= 150 or deg <= -130:
			if $AnimationPlayer.current_animation != "walk_left":
				$AnimationPlayer.play("walk_left")
		deg when deg >= 30 and deg <= 150:
			if $AnimationPlayer.current_animation != "walk_down":
				$AnimationPlayer.play("walk_down")
		deg when deg >= -130 and deg <= -50:
			if $AnimationPlayer.current_animation != "walk_up":
				$AnimationPlayer.play("walk_up")

func incrementMotivation():
	currentMotivation = min(currentMotivation + 1, Motivation.PEEVED)
	currentMorale = moraleStates[currentMotivation]
	
func decrementMotivation():
	currentMotivation = max(Motivation.MOTIVATED, currentMotivation - 1)
	currentMorale = moraleStates[currentMotivation]

func bash_vip(force, direction):
	apply_central_impulse(direction * force)

func _on_player_bash(object, direction):
	if object == self:
		apply_central_impulse(direction.normalized() * currentMorale.PlayerImpactImpulse)

