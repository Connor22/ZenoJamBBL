extends RigidBody2D
var a: int = 0

func _on_impact_shape_area_entered(area: Area2D):
	if not area.monitorable:
		return
	$ColorRect.color = Color.from_hsv(randf(), 1, 1)
	a += 1
	print(a)
	var direction = position - area.owner.position as Vector2
	apply_central_impulse(direction.normalized() * 500)

