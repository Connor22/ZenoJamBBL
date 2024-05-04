extends RigidBody2D
var a: int = 0

func _on_impact_shape_area_entered(area: Area2D):
	if area.owner is Player:
		a += 1
		print(a)
		$ColorRect.color = Color.from_hsv(randf(), 1, 1)
		apply_central_impulse(area.owner.shield_direction.normalized() * 500)
