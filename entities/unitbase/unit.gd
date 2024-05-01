class_name Unit
extends RigidBody2D

@export_category("SPEED")
@export_range(10, 100, 10) var SPEED: float

@export_category("Pathing")
@export var move: bool
@export var target: Node2D

@export_category("Debug")
@export var clr: Color
@export var debug: bool

func _physics_process(delta):
	#if debug: 
		#print("Moving to ", global_position.lerp(target.global_position, delta * SPEED), " using lerp")
	if move: 
		global_position = global_position.lerp(target.global_position, delta * SPEED * 0.01)
		if global_position.distance_to(target.global_position) < 0.1:
			global_position = target.global_position
