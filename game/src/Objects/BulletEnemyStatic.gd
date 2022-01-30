extends Area2D
class_name BulletEnemyStatic
export var damage := 15
export var move_speed := 600
var direction : Vector2
var is_fly = true
onready var animatedSprite := $AnimatedSprite
onready var timer := $Timer
onready var timer2 := $Timer2
func _ready() -> void:
	set_as_toplevel(true)
	animatedSprite.play("fly")
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
	
	animatedSprite.playing = true
	animatedSprite.play("buzz")

	#queue_free()

func initialize(_direction: Vector2, _rotation:float) -> void:
	direction = _direction
	rotation = _rotation


func _on_Timer_timeout():
	animatedSprite.play("buzz")
	timer2.start(1)

func _on_Timer2_timeout():
	queue_free()
