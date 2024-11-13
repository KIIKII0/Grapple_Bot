extends Node

var fps_counter_show
var resolution
var window_mode
var Fps

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Fps = 60
	Engine.max_fps = Fps 
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	DisplayServer.window_set_size(DisplayServer.window_get_size())

func setting_change(setting_name: String, value):
	match setting_name:
		"resolution":
			resolution = value
			DisplayServer.window_set_size(resolution)
		"window_mode":
			window_mode = value
			DisplayServer.window_set_mode(window_mode)
		"fps":
			Fps = value
			Engine.max_fps = Fps
