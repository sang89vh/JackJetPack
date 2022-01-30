extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var admob = $AdMob
# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("load_rewarded_video")
	admob.load_interstitial()
	AudioController.play_audio()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_die():
	print_debug("_on_Player_die")
	if admob.is_interstitial_loaded():
		print_debug("_on_Player_die amd rewarded video loeaded")
		admob.show_interstitial()
	else:
		print_debug("_on_Player_die amd rewarded video isn't loeaded")
