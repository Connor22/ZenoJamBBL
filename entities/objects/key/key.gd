extends Area2D
class_name Key

var exit
# Called when the node enters the scene tree for the first time.
func _ready():
	var root = find_parent("Level*") as Level
	exit = root.find_child("LevelExit")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		exit.unlock()
		exit.update_sign()
		queue_free()
