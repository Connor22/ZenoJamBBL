extends StaticBody2D
class_name ShootGoblin 

@export_range(0, 500, 10) var MoveSpeed = 50
@export_range(0, 5000, 100) var PushBack = 500
@export_range(0, 5000, 100) var ArrowSpeed: float = 200

@export var ShootTimer: float = 5.0
@export var DisableDuration: float = 60.0
@export var ArrowObj: PackedScene

var flash_timer = 0.0
var shoot_timer = 0.0
var root

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	root = find_parent("Level*") as Level
	var player = root.find_child("Player") as Player
	player.connect("bash", _on_player_bash)
	
func _process(delta):
	var sprite = find_child("Sprite") as Sprite2D
	if flash_timer > 0:
		sprite.self_modulate.a = wrapf(flash_timer, 0.4, 0.8)
		flash_timer -= delta
	elif shoot_timer <= 0:
		shoot_timer = ShootTimer
		shoot()
	else:
		shoot_timer -= delta

func shoot():
	var arrow = ArrowObj.instantiate()
	root.add_child(arrow)
	arrow.rotation = global_position.angle_to($ArrowSpawn.global_position)
	arrow.global_position = $ArrowSpawn.global_position
	arrow.apply_central_impulse(($ArrowSpawn.global_position - global_position).normalized() * ArrowSpeed)

func disable():
	flash_timer = DisableDuration
	
func getMoveSpeed():
	if flash_timer == 0:
		return MoveSpeed
	else:
		return 0
	
func _on_player_bash(object, direction):
	if object == self:
		flash_timer = DisableDuration

func _on_area_2d_body_entered(body):
	if flash_timer == 0.0:
		if body.name.begins_with("Arrow"):
			flash_timer = DisableDuration
