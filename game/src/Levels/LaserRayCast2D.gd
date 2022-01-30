extends RayCast2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal laser_fire
var is_emitted = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_emitted:
		var object = self.get_collider()
		if object is KinematicBody2D:
			print_debug("raycast revert gravity emit signal laser_fire")
			is_emitted = true
			emit_signal("laser_fire")
