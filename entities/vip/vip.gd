class_name VIP
extends RigidBody2D

enum PresetMotivation { NONE, MOTIVATED, DEMOTIVATED, PEEVED }

@export_category("Override")
## Will override the following exports with a preset type of "motivation" on _ready()
@export var on_ready_motivation: PresetMotivation = PresetMotivation.NONE

@export_category("Debug")
@export var debug: bool = false
@export var print_location: bool = false
@export var clr: Color = Color("red")

@export_category("Movement")
@export var move: bool = true
## How fast should the VIP move towards the target
@export_range(10, 200, 10) var MoveSpeedTowardsTarget: float = 50
## How long in seconds to wait after being hit to start going home again
@export_range(0.1, 5.0, 0.1) var RecoveryTime: float = 1.0
## How much force the player has when bashing the VIP around
@export_range(1000, 100000, 1000) var PlayerImpactImpulse: float = 50000

@export_category("Target")
@export var target: Node2D
# Some debug vars to help calculate the below
@export var distance_to_target: float
@export var closest_offset: float
@export var progress: float
## At what distance should the VIP pull the target towards itself
@export_range(100, 1000, 10) var TargetPullDistance: float = 200
## At what distance should the target pull the VIP towards itself
@export_range(0, 500, 10) var VipMinPullDistance: float = 0
## How far from the target should the VIP really slow itself down while being flung 
@export_range(100, 1000, 10) var DecelerationDistance: float = 100
## How fast the target moves along the path
@export_range(10, 1000, 10) var TargetMoveSpeed: float = 200

@export_category("Pathing")
## How close should the VIP need to be to start pushing the target back
@export_range(100, 1000, 10) var PathMoveDistance: float = 200
## How fast should the VIP push its target back along the path
@export_range(0, 10000, 100) var PathMoveSpeed: int = 2500

# var to clean up after enabling debug
var line_exists: bool = false

# var to help with waiting after being hit
var timer: float = 0.0

func _ready():
	set_preset_motivation(on_ready_motivation)

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
		# Pull vip to target when outside the min pull distance
		if distance_to_target > VipMinPullDistance:
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

func _unhandled_input(event):
	# Debug code to test motivation presets live
	if ProjectSettings.get_setting("debug") and event is InputEventKey and event.pressed:
		if event.keycode == KEY_I:
			set_preset_motivation(PresetMotivation.MOTIVATED)
		if event.keycode == KEY_O:
			set_preset_motivation(PresetMotivation.DEMOTIVATED)
		if event.keycode == KEY_P:
			set_preset_motivation(PresetMotivation.PEEVED)

func set_preset_motivation(behavior: PresetMotivation):
	match behavior:
		# Default behaviour when the VIP is unscathed or has just recovered morale.
		PresetMotivation.MOTIVATED:
			move = true
			MoveSpeedTowardsTarget = 50
			RecoveryTime = 0.6
			PlayerImpactImpulse = 20000
			TargetPullDistance = 100
			VipMinPullDistance = 130
			DecelerationDistance = 100
			TargetMoveSpeed = 400
			PathMoveDistance = 200
			PathMoveSpeed = 0
		# Behaviour when hit once, will default to "motivated" after a cooldown.
		PresetMotivation.DEMOTIVATED:
			move = true
			MoveSpeedTowardsTarget = 70
			RecoveryTime = 0.6
			PlayerImpactImpulse = 20000
			TargetPullDistance = 100
			VipMinPullDistance = 130
			DecelerationDistance = 100
			TargetMoveSpeed = 100
			PathMoveDistance = 200
			PathMoveSpeed = 7000
		# Behaviour when hit again while "demotivated", will default to "motivated" after a cooldown.
		PresetMotivation.PEEVED:
			move = true
			MoveSpeedTowardsTarget = 150
			RecoveryTime = 0.3
			PlayerImpactImpulse = 2000
			TargetPullDistance = 100
			VipMinPullDistance = 0
			DecelerationDistance = 100
			TargetMoveSpeed = 50
			PathMoveDistance = 200
			PathMoveSpeed = 10000

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
		apply_central_impulse(area.owner.shield_direction.normalized() * PlayerImpactImpulse)
		move = false
		timer = RecoveryTime
