class_name Player
extends CharacterBody2D

const SPEED = 300.0
var _shield_bash_direction = Vector2.ZERO

func _ready():
	$ImpactShape.monitorable = false
	$ImpactShape.visible = false
	!$ShieldBashTimer.timeout.connect(_on_shield_bash_timer_timeout)

func _physics_process(delta):
	if !$ShieldBashTimer.is_stopped():
		velocity = _shield_bash_direction * 1800
	elif Input.is_action_just_pressed("shield_bash"):
		$ImpactShape.monitorable = true
		$ImpactShape.visible = true
		_shield_bash_direction = (get_global_mouse_position() - position).normalized()
		$Pivot.modulate = Color(1000,1000,1000)
		velocity = _shield_bash_direction * 1800
		$ShieldBashTimer.start()
	else:
		# Get the input direction and handle the movement
		var direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
		velocity = direction * SPEED
	move_and_slide()

func _on_shield_bash_timer_timeout():
	$Pivot.modulate = Color(1, 1, 1)
	$ImpactShape.monitorable = false
	$ImpactShape.visible = false
