class_name VIP
extends RigidBody2D

@export_category("Debug")
@export var debug: bool = false
@export var print_location: bool = false
@export var clr: Color = Color("red")

@export_category("Movement")
@export var move: bool = true
## How fast should the VIP move towards the target
@export_range(10, 100, 10) var MoveSpeedTowardsTarget: float = 50
## How long in seconds to wait after being hit to start going home again
@export_range(0.1, 5.0, 0.1) var RecoveryTime: float = 1.0

@export_category("Target")
@export var target: Node2D
# Some debug vars to help calculate the below
@export var distance_to_target: float
@export var closest_offset: float
@export var progress: float
## At what distance should the VIP pull the target towards itself
@export_range(100, 1000, 10) var TargetPullDistance: float = 200
## How far from the target should the VIP really slow itself down while being flung 
@export_range(100, 1000, 10) var DecelerationDistance: float = 100
## How fast the target moves along the path
@export_range(100, 1000, 10) var TargetMoveSpeed: float = 200

@export_category("Pathing")
## How close should the VIP need to be to start pushing the target back
@export_range(100, 1000, 10) var PathMoveDistance: float = 200
## How fast should the VIP push its target back along the path
@export_range(100, 10000, 100) var PathMoveSpeed: int = 2500

# var to clean up after enabling debug
var line_exists: bool = false

# var to help with waiting after being hit
var timer: float = 0.0

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
	
	distance_to_target = position.distance_to(target.global_position)
	progress = target.get_progress()
	closest_offset = path.curve.get_closest_offset(path.to_local(global_position))
	
	if move: 
		global_position = global_position.lerp(target.global_position, delta * MoveSpeedTowardsTarget * 0.01)
		
		# Avoid interpolation issues when too close
		if global_position.distance_to(target.global_position) < 0.1:
			global_position = target.global_position
		
		# Target slowly returns to beginning
		target.set_progress_ratio(target.get_progress_ratio() - (PathMoveSpeed * 0.0000001))

	# Decrease speed after being bashed
	if !linear_velocity.is_zero_approx():
		linear_damp = (distance_to_target / DecelerationDistance) * 5
	else:
		linear_damp = 0.5
	
	# If we're a certain distance away, move the target closer to us along the path
	if (distance_to_target > TargetPullDistance) && (linear_velocity.length_squared() > 1):
		target.set_progress(target.get_progress() + delta * TargetMoveSpeed * signf(path.curve.get_closest_offset(path.to_local(global_position)) - target.get_progress()))
	
	# Handle animation in physics process (?)
	_handle_animation()
	
	# Debug
	if ProjectSettings.get_setting("debug"):
		queue_redraw() 
		line_exists = true
	elif line_exists:
		queue_redraw()
		line_exists = false

func _handle_animation():
	match rad_to_deg(linear_velocity.angle()):
		_ when linear_velocity.length() < 10:
			if $AnimationPlayer.current_animation != "sleep":
				$AnimationPlayer.play("sleep")
		var deg when deg >= -50 and deg <= 30:
			if $AnimationPlayer.current_animation != "walk_right":
				$AnimationPlayer.play("walk_right")
		var deg when deg >= 150 or deg <= -130:
			if $AnimationPlayer.current_animation != "walk_left":
				$AnimationPlayer.play("walk_left")
		var deg when deg >= 30 and deg <= 150:
			if $AnimationPlayer.current_animation != "walk_down":
				$AnimationPlayer.play("walk_down")
		var deg when deg >= -130 and deg <= -50:
			if $AnimationPlayer.current_animation != "walk_up":
				$AnimationPlayer.play("walk_up")

func _on_impact_shape_area_entered(area):
	if area.owner is Player:
		apply_central_impulse(area.owner.shield_direction.normalized() * 50000)
		move = false
		timer = RecoveryTime
