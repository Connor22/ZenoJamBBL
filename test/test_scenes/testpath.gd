extends Path2D


# Draw the path in white
func _draw():
	var l := Line2D.new()   
	l.default_color = Color(1,1,1,1)  
	l.width = 20  
	for point in curve.get_baked_points():  
		l.add_point(point) 
	l.z_index = -1
	add_child.call_deferred(l, false)
