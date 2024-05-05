extends RigidBody2D
class_name Coffee

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	set_max_contacts_reported(4)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_bash(object, direction):
	if object == self:
		apply_central_impulse(direction.normalized() * 2000)

func _on_body_entered(body):
	if (body.name == "Vip"):
		var vip = body as VIP
		vip.currentMorale = vip.moraleStates[vip.Motivation.MOTIVATED]
		queue_free()
