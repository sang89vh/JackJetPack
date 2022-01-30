extends RayCast2D

signal revert_gravity
# Declare member variables here. Examples:
# var a = 2
var is_emitted = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_emitted:
		var object = self.get_collider()
		if object is KinematicBody2D:
			print_debug("raycast revert gravity emit signal revert_gravity")
			is_emitted = true
			emit_signal("revert_gravity")
