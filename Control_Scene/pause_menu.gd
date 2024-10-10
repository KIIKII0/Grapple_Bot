extends Control

func _ready():
	$".".visible = false
func _on_resume_button_pressed():
	get_tree().paused = false
	$".".visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Control_Scene/main menu.tscn")
	Globvar.time = 0
