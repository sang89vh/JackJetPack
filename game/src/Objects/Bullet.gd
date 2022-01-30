extends Area2D
class_name Bullet
export var damage := 15
export var move_speed := 600

var direction : Vector2
var is_fly = true
onready var animatedSprite :=  $AnimatedSprite
onready var sprite :=  $Sprite
onready var timer :=  $Timer

func _ready() -> void:
	set_as_toplevel(true)
	connect("body_entered", self, "_on_body_entered")
	animatedSprite.visible = false

func _process(delta: float) -> void:
	if is_fly:
		position += direction * move_speed * delta

func _on_body_entered(body) -> void:
	print_debug("bullet on body enter " + str(body.name))
	if body.is_a_parent_of(self):
		return
	elif body is Enemy:
		body.damage(damage)
	elif body is ElectricLight:
		body.damage(damage)	
	
	die()

func set_move_speed(_move_speed:float):
	move_speed = _move_speed

func die():
	is_fly = false
	timer.start(2)
	
	animatedSprite.playing = true
	animatedSprite.visible = true
	animatedSprite.play("buzz")
	sprite.visible = false

func initialize(_direction: Vector2, _rotation:float) -> void:
	direction = _direction
	rotation = _rotation


func _on_Timer_timeout():
	queue_free()


func _on_Bullet_area_entered(area):
	if area is EnemyStatic or area is EnemyStaticFireball:
		area.damage(damage)
