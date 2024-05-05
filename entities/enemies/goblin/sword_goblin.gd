extends StaticBody2D
class_name SwordGoblin 

@export_range(0, 500, 10) var MoveSpeed = 50
@export_range(0, 5000, 100) var PushBack = 500

var flash_timer = 0.0

@export var DisableDuration: float = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	var root = find_parent("Level*") as Level
	var player = root.find_child("Player") as Player
	player.connect("bash", _on_player_bash)
	
func _process(delta):
	var sprite = $Sprite as Sprite2D
	if flash_timer > 0:
		sprite.self_modulate.a = wrapf(flash_timer, 0.4, 0.8)
		flash_timer -= delta
	elif flash_timer < 0:
		sprite.self_modulate.a = 1.0
		flash_timer = 0.0
	
func getMoveSpeed():
	if flash_timer == 0:
		return MoveSpeed
	else:
		return 0
	
func _on_player_bash(object, direction):
	if object == self:
		flash_timer = DisableDuration

func _on_area_2d_body_entered(body):
	match body.name:
		"Vip" when flash_timer == 0.0:
			var vip = body as VIP
			vip.incrementMotivation()
			body.apply_central_impulse((body.global_position - global_position).normalized() * PushBack)
		"Player" when flash_timer == 0.0:
			var player = body as Player
			body.velocity += ((global_position - body.global_position).normalized() * PushBack)
		_ when body.name.begins_with("Arrow"):
			flash_timer = DisableDuration
