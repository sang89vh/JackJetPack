extends Node2D
class_name Gun

onready var timer : Timer = $Timer

export var fire_rate := 1
export var bullet : PackedScene

func _ready() -> void:
	timer.wait_time = 1.0 / fire_rate
