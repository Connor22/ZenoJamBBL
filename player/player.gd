class_name Player
extends CharacterBody2D

const SPEED = 250.0
const SHIELD_BASH_SPEED = 1200
const REFLECT_IMPULSE = 800

var _shield_bash_direction = Vector2.ZERO

func _ready():
	$ImpactShape.monitorable = false
	$ImpactShape.visible = false
	!$ShieldBashTimer.timeout.connect(_on_shield_bash_timer_timeout)

func _physics_process(delta):
	if !$ShieldBashTimer.is_stopped():
		velocity = _shield_bash_direction * SHIELD_BASH_SPEED
	elif Input.is_action_just_pressed("shield_bash"):
		$ImpactShape.monitorable = true
		$ImpactShape.visible = true
		_shield_bash_direction = (get_global_mouse_position() - position).normalized()
		velocity = _shield_bash_direction * SHIELD_BASH_SPEED
		$ShieldBashTimer.start()
	else:
		# Get the input direction and handle the movement
		var direction = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
		velocity = direction * SPEED
	move_and_slide()

func _on_shield_bash_timer_timeout():
	$ImpactShape.monitorable = false
	$ImpactShape.visible = false

func _reflect_the_object(reflect_object):
	var reflect_object_pos = reflect_object.position as Vector2
	var impact_shape_pos = $ImpactShape.position as Vector2
	var direction = (reflect_object_pos - impact_shape_pos).normalized()
	reflect_object.velocity = direction * REFLECT_IMPULSE
