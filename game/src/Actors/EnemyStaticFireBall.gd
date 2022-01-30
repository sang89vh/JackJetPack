extends Area2D
class_name EnemyStaticFireball
export var bullet : PackedScene
var state = "shoot"
onready var barrel := get_node("Barrel")
onready var animatedSprite := $AnimatedSprite
onready var animatedSprite2 := $AnimatedSprite2
onready var timer := $Timer

func _ready():
	animatedSprite.play("idle")
	animatedSprite2.play("idle")

func damage(damage:int):
	print_debug("Enemy damage " + str(damage))
	animatedSprite.play("buzz")
	state = "buzz"
	timer.start()


func _on_TimerDie_timeout():
	if state == "buzz":
		queue_free()


func _on_TimerShoot_timeout():
	print_debug("_on_Timer2_timeout")
	
	var new_bullet := bullet.instance()
	new_bullet.initialize(Vector2.RIGHT, deg2rad(0))
	add_child(new_bullet)
	
	new_bullet.global_position = barrel.global_position
	
	animatedSprite.play("shoot")
	animatedSprite2.play("shoot")


func _on_VisibilityEnabler2D_screen_entered():
	$TimerShoot.start()
