class_name VIP
extends Unit
@export_category("Debug")
@export var print_location: bool
@export var distance_to_target: float

@export_category("Pathing")
@export_range(10, 1000, 10) var move_tolerance: float
@export_range(100, 10000, 100) var path_speed: int



func _input(ev):
	if ev is InputEventKey and ev.pressed:
		if ev.keycode == KEY_SPACE:
			move = !move

func _draw():
	if debug:
		draw_set_transform_matrix(global_transform.affine_inverse())
		draw_line(global_position, target.global_position, clr, 2.0)
		# print("drawing line from ", global_position, " to ", target.global_position)

func _physics_process(delta):
	super(delta)
	if debug:
		queue_redraw() 
		distance_to_target = global_position.distance_to(target.global_position)
		if print_location: 
			print(position)
	if global_position.distance_to(target.global_position) < move_tolerance:
		target.set_progress_ratio(target.get_progress_ratio() + (path_speed * 0.0000001))
