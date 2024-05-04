class_name LevelExit
extends Area2D

signal level_complete

enum Pointing {LEFT, RIGHT, UP, DOWN}

@export var direction:= Pointing.RIGHT
@export var is_locked: bool = false
@export var collision_shape: CollisionShape2D

func _ready():
	update_sign()
	body_entered.connect(_on_body_entered)
	
func update_sign():
	match [direction, is_locked]:
		[_, true]:
			$LevelExitSprites.frame = 3
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = true
		[Pointing.UP, _]:
			$LevelExitSprites.frame = 2
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = false
		[Pointing.LEFT, _]:
			$LevelExitSprites.frame = 1
			$LevelExitSprites.flip_h = true
			collision_shape.disabled = false
		[Pointing.RIGHT, _]:
			$LevelExitSprites.frame = 1
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = false
		[Pointing.UP, _]:
			$LevelExitSprites.frame = 0
			$LevelExitSprites.flip_h = false
			collision_shape.disabled = false

func _on_body_entered(body):
	emit_signal("level_complete")
