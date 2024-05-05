extends Area2D


func _on_area_entered(area):
	if area.owner.name == "Vip":
		var vip = area.owner as VIP
		vip.incrementMotivation()
		vip.incrementMotivation()
