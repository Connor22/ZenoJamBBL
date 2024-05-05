extends RigidBody2D
class_name SwordGoblin 

@export_range(0, 500, 10) var MoveSpeed = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getMoveSpeed():
	return MoveSpeed
