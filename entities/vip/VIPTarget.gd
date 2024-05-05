extends PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_loop(false)

func _input(_event):
	if ProjectSettings.get_setting("debug"):
		visible = true
	else:
		visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var _path: Path2D = get_parent()
	# path.curve.get_closest_offset()
