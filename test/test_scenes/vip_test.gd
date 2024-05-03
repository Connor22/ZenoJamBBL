extends Node2D

@export var KeyPressLabel: Label
var timer: float = 0

func _init():
	ProjectSettings.set_setting("debug", false)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			ProjectSettings.set_setting("debug", !ProjectSettings.get_setting("debug"))
			KeyPressLabel.visible = true
			timer = 0.2

func _physics_process(delta):
	if timer > 0.1:
		timer -= delta
	if timer < 0.1:
		timer = 0
		KeyPressLabel.visible = false
