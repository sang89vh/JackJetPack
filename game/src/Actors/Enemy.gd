extends Actor
class_name Enemy

onready var ray:= $RayCast2D
export var rotate_speed:= 180.0
export var is_shootable := true
export var is_drop := false
export var is_up := false
export var bullet_direction := Vector2.LEFT

var can_shoot = true
var state = "fly"

onready var animatedSprite := $AnimatedSprite
onready var timerAutoShoot := $TimerAutoShoot
onready var pistolEnemy := $PistolEnemy
onready var timer := $Timer

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x
	animatedSprite.play(state)

func _physics_process(delta: float) -> void:
	if is_on_wall():
		_velocity.x *= -1
		if not animatedSprite.flip_h:
			animatedSprite.flip_h = true
			animatedSprite.scale.x = -1*animatedSprite.scale.x
	else:
		_velocity.x *= 1
		if animatedSprite.flip_h:
			animatedSprite.flip_h = false
			animatedSprite.scale.x = 1*animatedSprite.scale.x

	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

	update()
	ray.rotation_degrees += rotate_speed * delta
	
	if is_shootable:
		shoot()
	else:
		attack()

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
			if timerAutoShoot != null:
				timerAutoShoot.start()
		else:
			print_debug("Enemy isn't colliding Player")
			animatedSprite.play("fly")
	#else:
	#	animatedSprite.play("fly")
func shoot_bullet():
	animatedSprite.play("shoot")
	var target_rotation
	if is_up:
		target_rotation = rad2deg(-90)
	elif is_drop:
		target_rotation = rad2deg(90)
	else:
		target_rotation = deg2rad(ray.rotation)
		
	# shooting
	pistolEnemy.shoot(bullet_direction, target_rotation)

func damage(damage:int):
	print_debug("Enemy damage " + str(damage))
	can_shoot = false
	animatedSprite.play("buzz")
	state = "buzz"
	timer.start(1)


func _on_Timer_timeout():
	if state == "buzz":
		queue_free()


func _on_TimerAutoShoot_timeout():
	shoot_bullet()
