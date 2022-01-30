extends Node


onready var scene_tree: SceneTree = get_tree()
onready var score_label: Label = $Score
onready var pause_overlay: ColorRect = $PauseOverlay
onready var main_screen_button: Button = $PauseOverlay/PauseMenu/MainScreenButton

const MESSAGE_DIED: = "You died"

var paused: = false setget set_paused


func _ready() -> void:
	PlayerData.connect("updated", self, "update_interface")
	PlayerData.connect("died", self, "_on_Player_died")
	PlayerData.connect("reset", self, "_on_Player_reset")
	
	#main_screen_button.icon
	update_interface()


func _on_Player_died() -> void:
	self.paused = true

func _on_Player_reset() -> void:
	self.paused = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not self.paused


func update_interface() -> void:
	score_label.text = "Score: %s" % PlayerData.score
	$BulletBar.set_current_value(PlayerData.remaining_bullet)

func set_paused(value: bool) -> void:
	print_debug("set_paused " + str(value))
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
