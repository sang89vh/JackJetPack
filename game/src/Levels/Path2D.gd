extends Path2D


onready var pathFollow2D_AnimationPlayer := $PathFollow2D/AnimationPlayer


func _on_VisibilityNotifier2D_screen_entered():
	print_debug("PathFollowingPlatform1 _on_VisibilityNotifier2D_screen_entered")
	pathFollow2D_AnimationPlayer.play("Move")
	#$MovingPlatform2/Sprite/AnimationPlayer.play("rotate")
