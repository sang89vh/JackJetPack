extends CanvasModulate


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var colors = [Color("f2dc59"),
		  Color("eb5e0b"),
		  Color("a3d2ca"),
		  Color("ff75a0"),
		  Color("fce38a"),
		  Color("5eaaa8")]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	randomize()
	self.color = colors[randi() % colors.size()]


func _on_VisibilityNotifier2D_screen_entered():
	self.visible = true
