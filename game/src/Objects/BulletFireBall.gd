#res://src/Objects/BulletFireBall.gd
extends Area2D
class_name BulletFireball
export var damage := 15
export var move_speed := 600
onready var sprite = $FireBallEffect
onready var timer = $Timer
var direction : Vector2
var is_fly = true

func _ready() -> void:
	set_as_toplevel(true)
	connect("body_entered", self, "_on_body_entered")

func _process(delta: float) -> void:
	if is_fly:
		position += direction * move_speed * delta

func _on_body_entered(body) -> void:
	if body.is_a_parent_of(self):
		return
	if body is Player:
		body.die()

	is_fly = false
	timer.start(1)
	
func initialize(_direction: Vector2, _rotation:float) -> void:
	direction = _direction
	rotation = _rotation

func _on_Timer_timeout():
	queue_free()
