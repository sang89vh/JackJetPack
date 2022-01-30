extends KinematicBody2D
class_name Actor


const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(300.0, 500.0)
export var gravity: = 1500.0
export var use_gravity = true

var _velocity: = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if use_gravity:
		_velocity.y += gravity * delta
	else:
		_velocity.y += delta
