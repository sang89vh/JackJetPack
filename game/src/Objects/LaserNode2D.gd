extends Node2D
onready var ray:= $RayCast2D
onready var animationPlayer:= $AnimationPlayer

func _physics_process(delta: float) -> void:
	if ray.is_colliding():
			print_debug("Laser colliding")
			if ray.get_collider().is_in_group("Player"):
				animationPlayer.play("Charging")
