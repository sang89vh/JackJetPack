extends Node2D


onready var audioStreamPlayer2D := $AudioStreamPlayer2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_audio():
	audioStreamPlayer2D.play()
