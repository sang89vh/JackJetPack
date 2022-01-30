tool
extends Button


export(String, FILE) var next_scene_path: = ""

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

onready var processbar := get_parent().get_parent().get_node("ProgressBar")
onready var menubar := get_parent()

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func _on_button_up() -> void:
	print_debug("_on_button_up clicked")
	PlayerData.reset()
	#var ok: = get_tree().change_scene(next_scene_path)
	#print_debug("change screen okie" + str(ok))
	goto_scene(next_scene_path)

func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if next_scene_path == "" else ""


func goto_scene(path): # Game requests to switch to this scene.
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		show_error()
		return
	set_process(true)

	wait_frames = 1

func show_error():
	printerr("load screen has an error")

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar?
	processbar.visible = true
	menubar.visible = false
	processbar.value = progress
	print_debug("Update your progress bar " + str(progress))

func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			show_error()
			loader = null
			break

func set_new_scene(scene_resource):
	processbar.visible = false
	#current_scene = scene_resource.instance()
	#get_node("/root").add_child(current_scene)
	get_tree().change_scene(next_scene_path)
