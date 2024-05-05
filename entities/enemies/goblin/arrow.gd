extends RigidBody2D
class_name Arrow

@export_range(0, 500, 10) var MoveSpeed = 50
@export_range(0, 5000, 100) var PushBack = 500

var is_reflected: bool = false

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
		linear_velocity = linear_velocity.reflect(direction)

func _on_impact_box_area_entered(area):
	match area.owner.name:
		"Vip":
			var vip = area.owner as VIP
			vip.incrementMotivation()
			vip.bash_vip(PushBack,(area.global_position - global_position).normalized())
			queue_free()
		"Player":
			var player = area.owner as Player
			is_reflected = true
			linear_velocity = (linear_velocity.length() + 100) * player.shield_direction
		"ShootGoblin" when is_reflected:
			var goblin = area.owner as ShootGoblin
			goblin.disable()
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
