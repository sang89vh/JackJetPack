extends Gun

export(int, 5, 25) var spread_percentage := 25
export var projectiles := 4
onready var barrel = get_node("Barrel")


func _ready() -> void:
	randomize()


func shoot(_direction:Vector2, _rotation:float) -> void:
	for i in range(projectiles):
		var new_bullet = bullet.instance()
		var bullet_y_spread = randf() * (spread_percentage / 100.0) * sign(rand_range(-1, 1))
		new_bullet.initialize((_direction + Vector2(0, bullet_y_spread)).normalized(), _rotation)
		add_child(new_bullet)
		new_bullet.global_position = barrel.global_position
