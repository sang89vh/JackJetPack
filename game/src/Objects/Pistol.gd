extends Gun
onready var barrel := get_node("Barrel")
onready var animatedSprite := get_node("AnimatedSprite")
onready var audioStreamPlayer2D := get_node("AudioStreamPlayer2D")

export var audio_stream : AudioStream = preload("res://assets/audio/shoot_2.ogg")
func _ready():
	audioStreamPlayer2D.stream = audio_stream

func shoot(_direction:Vector2, _rotation:float) -> void:
	timer.start()
	
	#animatedSprite.playing = true
	animatedSprite.play("fire")
	
	var new_bullet := bullet.instance()
	new_bullet.initialize(_direction, _rotation)
	add_child(new_bullet)
	
	new_bullet.global_position = barrel.global_position

	audioStreamPlayer2D.play()
	#animatedSprite.playing = false
	#animatedSprite.play("idle")
	#global_scale.x = abs(global_scale.x)


func _on_Timer_timeout():
	animatedSprite.playing = false
	animatedSprite.play("idle")
	audioStreamPlayer2D.stop()
