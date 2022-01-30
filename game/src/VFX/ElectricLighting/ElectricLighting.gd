extends Actor
class_name ElectricLight

onready var ray:= $RayCast2D
export var rotate_speed:= 180.0
var can_shoot = true
var state = "fly"

onready var animatedSprite := $AnimatedSprite
onready var lightingArea2D := $Area2D
onready var timer := $Timer

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x
	animatedSprite.play(state)

func _physics_process(delta: float) -> void:
	ray.rotation_degrees += rotate_speed * delta
	shoot()

func attack():
	if ray.is_colliding():
		print_debug("Enemy colliding")
		if ray.get_collider().is_in_group("Player"):
			animatedSprite.play("shoot")
func shoot():
	if can_shoot and ray.is_colliding():
		print_debug("Enemy colliding")
		if ray.get_collider().is_in_group("Player"):
			print_debug("Enemy is colliding Player")
			can_shoot = false
			shoot_bullet()
		else:
			print_debug("Enemy isn't colliding Player")
			animatedSprite.play("fly")
func shoot_bullet():
	animatedSprite.play("shoot")
	lightingArea2D.visible = true

func damage(damage:int):
	print_debug("Enemy damage " + str(damage))
	can_shoot = false
	lightingArea2D.visible = false
	animatedSprite.play("buzz")
	state = "buzz"
	timer.start(1.5)
	

func _on_Timer_timeout():
	if state == "buzz":
		queue_free()


func _on_TimerAutoShoot_timeout():
	shoot_bullet()
