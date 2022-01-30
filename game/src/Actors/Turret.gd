extends Area2D

var Missile = load("res://src/Objects/HomingMissile.tscn")
onready var ray:= $RayCast2D
onready var turret_nimatedSprite:= $Turret/AnimatedSprite
onready var turret_Muzzle := $Turret/Muzzle
export var rotation_speed = PI
export var cooldown = 0.5

var target = null
var can_shoot = true

func shoot():
	if can_shoot:
		var m = Missile.instance()
		get_tree().current_scene.add_child(m)
		m.start(turret_Muzzle.global_transform, target)
		flash()
		can_shoot = false
		yield(get_tree().create_timer(cooldown), "timeout")
		ray.enabled = false
		#can_shoot = true

func flash():
	turret_nimatedSprite.play("shoot")
	yield(get_tree().create_timer(1), "timeout")
	turret_nimatedSprite.play("idle")
	
func find_target():
	if can_shoot and ray.is_colliding():
		print_debug("Enemy colliding")
		if ray.get_collider().is_in_group("Player"):
			target = ray.get_collider()

func _process(delta):
	if !target:
		find_target()
	if target:
		#turret_nimatedSprite.look_at(target.global_position)
		shoot()
		
func _on_Launcher_body_exited(body):
	if body == target:
		target = null
