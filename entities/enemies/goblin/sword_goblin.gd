extends RigidBody2D
class_name SwordGoblin 

@export_range(0, 500, 10) var MoveSpeed = 50

@export_range(0, 5000, 100) var PushBack = 500

var flash_timer = 0.0

@export var DisableDuration: float = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	contact_monitor = true
	max_contacts_reported = 2
	
	var root = find_parent("Level*") as Level
	var player = root.find_child("Player") as Player
	player.connect("bash", _on_player_bash)
	
func _process(delta):
	var sprite = find_child("Sprite") as Sprite2D
	if flash_timer > 0:
		sprite.self_modulate.a = clampf(flash_timer % 1, 0.4, 0.8)
		flash_timer -= delta
	
func getMoveSpeed():
	return MoveSpeed
	
func _on_player_bash(object, direction):
	if object == self:
		flash_timer = DisableDuration

func _on_area_2d_body_entered(body):
	print(body.name)
	if body.name == "Vip":
		var vip = body as VIP
		vip.incrementMotivation()
		body.apply_central_impulse((global_position - body.global_position).normalized() * PushBack)
	if body.name == "Player":
		body.velocity += ((global_position - body.global_position).normalized() * PushBack)
