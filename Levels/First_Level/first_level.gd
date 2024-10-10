extends Node3D

var mouse_capture
@onready var player = $Bob


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_capture = true
	Globvar.stop = false

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		if mouse_capture == true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$Pause_Menu.visible = true
			mouse_capture = false
			get_tree().paused = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_capture = true
			get_tree().paused = false
			$Pause_Menu.visible = false
		
