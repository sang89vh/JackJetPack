extends Gun
onready var barrel := get_node("Barrel")
export var bullet_move_speed := 500
export var show_fx_shoot := true
onready var animatedSprite :=  $AnimatedSprite
func shoot(_direction:Vector2, _rotation:float) -> void:
	timer.start()
	
	if show_fx_shoot:
		animatedSprite.playing = true
		animatedSprite.play("fire")
	
	var new_bullet := bullet.instance()
	new_bullet.initialize(_direction, _rotation)
	new_bullet.set_move_speed(bullet_move_speed)
	add_child(new_bullet)
	
	new_bullet.global_position = barrel.global_position

	#animatedSprite.playing = false
	#animatedSprite.play("idle")
	global_scale.x = abs(global_scale.x)

func _on_Timer_timeout():
	if show_fx_shoot:
		animatedSprite.playing = false
		animatedSprite.play("idle")
