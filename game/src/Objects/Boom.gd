extends Area2D
class_name Boom
onready var ray:= $RayCast2D
export var rotate_speed:= 180.0
onready var animatedSprite := $AnimatedSprite
onready var collisionShape2D := $CollisionShape2D
onready var timer := $Timer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)


func _process(delta: float) -> void:
	ray.rotation_degrees += rotate_speed * delta
	
	if ray.is_colliding():
		print_debug("Boom colliding")
		if ray.get_collider().is_in_group("Player"):
			print_debug("Boom is colliding Player")
			collisionShape2D.visible = true
			animatedSprite.play("buzz")
			timer.start()

func _on_Timer_timeout():
	queue_free()
