extends Area2D
class_name BulletEnemy
export var damage := 15
export var move_speed := 600
var direction : Vector2
var is_fly = true
onready var animatedSprite := $AnimatedSprite
onready var sprite := $Sprite
onready var timer := $Timer

func _ready() -> void:
	set_as_toplevel(true)
	connect("body_entered", self, "_on_body_entered")
	animatedSprite.visible = false
	animatedSprite.stop()

func _process(delta: float) -> void:
	if is_fly:
		position += direction * move_speed * delta

func set_move_speed(_move_speed:float):
	move_speed = _move_speed

func _on_body_entered(body) -> void:
	if body.is_a_parent_of(self):
		return
	if body is Player:
		body.die()
	
	buzz()

func buzz():
	is_fly = false
	timer.start(1)
	
	animatedSprite.visible = true
	animatedSprite.play("buzz")
	if sprite:
		sprite.visible = false

func initialize(_direction: Vector2, _rotation:float) -> void:
	direction = _direction
	rotation = _rotation


func _on_Timer_timeout():
	queue_free()
