class_name VIP
extends RigidBody2D

@export_category("Debug")
@export var debug: bool = false
@export var print_location: bool = false
@export var clr: Color = Color("red")

@export_category("Movement")
@export var move: bool = true
@export_range(10, 100, 10) var MoveSpeedTowardsTarget: float = 50

@export_category("Target")
@export var target: Node2D
@export var distance_to_target: float
@export var closest_offset: float
@export var progress: float
@export_range(100, 1000, 10) var TargetPullDistance: float = 200
@export_range(100, 1000, 10) var DecelerationDistance: float = 100

@export_category("Pathing")
@export_range(100, 1000, 10) var PathMoveDistance: float = 200
@export_range(100, 10000, 100) var PathMoveSpeed: int = 2500


var line_exists: bool = false

func _draw():
	if ProjectSettings.get_setting("debug"):
		draw_set_transform_matrix(global_transform.affine_inverse())
		draw_line(global_position, target.global_position, clr, 2.0)
		# print("drawing line from ", global_position, " to ", target.global_position)
	else:
		draw_set_transform_matrix(global_transform.affine_inverse())
		draw_line(global_position, target.global_position, Color(1, 1, 1, 0), 2.0)

func _physics_process(delta):
	var path = target.get_parent()
	
	distance_to_target = position.distance_to(target.global_position)
	
	progress = target.get_progress()
	closest_offset = path.curve.get_closest_offset(path.to_local(global_position))
	
	if move: 
		global_position = global_position.lerp(target.global_position, delta * MoveSpeedTowardsTarget * 0.01)
		if global_position.distance_to(target.global_position) < 0.1:
			global_position = target.global_position
	
	# Target slowly returns to 0 while nearby
	if global_position.distance_to(target.global_position) < PathMoveDistance:
		target.set_progress_ratio(target.get_progress_ratio() - (PathMoveSpeed * 0.0000001))

	# Decrease speed after being bashed
	if !linear_velocity.is_zero_approx():
		linear_damp = (distance_to_target / DecelerationDistance) * 5
	else:
		linear_damp = 0.5
	
	# If we're a certain distance away, move the target closer to us along the path
	if distance_to_target > TargetPullDistance:
		target.set_progress(target.get_progress() + 5 * signf(path.curve.get_closest_offset(path.to_local(global_position)) - target.get_progress()))
		
	# Debug
	if ProjectSettings.get_setting("debug"):
		queue_redraw() 
		line_exists = true
	elif line_exists:
		queue_redraw()
		line_exists = false
