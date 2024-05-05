extends PathFollow2D

var PathingSign = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_progress(get_progress + delta * get_child().MoveSpeed * PathingSign)
	if get_progress_ratio() = 1:
		PathingSign = PathingSign * -1
