extends Area2D

export var speed = 400
export var steer_force = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

onready var animatedSprite :=  $AnimatedSprite

func start(_transform, _target):
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target

func seek():
	var steer = Vector2.ZERO
	if is_instance_valid(target):
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	if is_instance_valid(target):
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
		position += velocity * delta
	else:
		queue_free()

func _on_Missile_body_entered(body):
	explode()

func _on_Lifetime_timeout():
	explode()
	
func _on_Player_die():
	queue_free()

func explode():
	set_physics_process(false)
	animatedSprite.play("buzz")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
