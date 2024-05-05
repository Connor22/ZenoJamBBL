class_name LevelExit
extends Area2D

signal level_complete

enum Pointing {LEFT, RIGHT, UP, DOWN}

@export var direction:= Pointing.RIGHT
@export var keys: int = 0
@export var collision_shape: CollisionShape2D

var root

func _ready():
	update_sign()
	root = find_parent("Level*") as Level
	body_entered.connect(_on_body_entered)
	
func unlock():
	keys = max(0, keys - 1)
	
func update_sign():
	match [direction, keys]:
		[Pointing.UP, 0]:
			$LevelExitSprites.frame = 2
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = false
		[Pointing.LEFT, 0]:
			$LevelExitSprites.frame = 1
			$LevelExitSprites.flip_h = true
			collision_shape.disabled = false
		[Pointing.RIGHT, 0]:
			$LevelExitSprites.frame = 1
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = false
		[Pointing.UP, 0]:
			$LevelExitSprites.frame = 0
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = false
		[_, _]:
			$LevelExitSprites.frame = 3
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = true

func _on_body_entered(_body):
	emit_signal("level_complete")
