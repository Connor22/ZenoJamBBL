extends PathFollow2D

var PathingSign = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var goblin = get_child(0) as SwordGoblin
	goblin.scale.x *= PathingSign
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var goblin = get_child(0) as SwordGoblin
	set_progress(get_progress() + delta * goblin.getMoveSpeed() * PathingSign)
	if get_progress_ratio() == 0 || get_progress_ratio() == 1:
		PathingSign = PathingSign * -1
		goblin.scale.x *= PathingSign
