extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/fps_slider.value = Settings.Fps

func _on_resolution_item_selected(index):
	var resolution
	match index:
		0:
			resolution = Vector2(2560,1440)
		1:
			resolution = Vector2(1920,1080)
		2:
			resolution = Vector2(1600,900)
		3:
			resolution = Vector2(1440,900)
		4:
			resolution = Vector2(1280,720)
	Settings.setting_change("resolution", resolution)

func _on_screen_type_item_selected(index):
	var window_mode
	match index:
		0:
			window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		1:
			window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		2:
			window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	Settings.setting_change("window_mode", window_mode)
	
func _on_fps_counter_toggled(toggled_on):
	if toggled_on == true:
		Settings.fps_counter_show = true
	elif toggled_on == false:
		Settings.fps_counter_show = false


func _on_return_pressed():
	get_tree().change_scene_to_file("res://Control_Scene/main menu.tscn")

func _on_h_slider_value_changed(value):
	var fps = int(value)
	$VBoxContainer/Label.text = "FPS: %d" % fps
	Settings.setting_change("fps", fps)
