extends RigidBody2D
class_name Arrow

@export_range(0, 500, 10) var MoveSpeed = 50
@export_range(0, 5000, 100) var PushBack = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_rotation = false
	contact_monitor = true
	max_contacts_reported = 1
	var root = find_parent("Level*") as Level
	var player = root.find_child("Player") as Player
	player.connect("bash", _on_player_bash)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_bash(object, direction):
	if object == self:
		linear_velocity.reflect(direction)

func _on_body_entered(body):
	match body.name:
		"Vip":
			var vip = body as VIP
			vip.incrementMotivation()
			body.apply_central_impulse((body.global_position - global_position).normalized() * PushBack)
		"Player":
			var player = body as Player
			body.velocity += ((global_position - body.global_position).normalized() * PushBack)
			$CollisionShape2D.queue_free()
		_:
			queue_free()
	pass # Replace with function body.
