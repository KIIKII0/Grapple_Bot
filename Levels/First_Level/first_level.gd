extends Node3D

var mouse_capture
@onready var player = $Bob
@onready var enemy = preload("res://enemies/Cubic/cucubic.tscn")



func _physics_process(delta):
	get_tree().call_group('Enemies',"update_target_location",player.global_transform.origin)

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_capture = true

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
