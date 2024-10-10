extends Control




func _on_exit_button_pressed():
	get_tree().quit()


func _on_test_button_pressed():
	get_tree().change_scene_to_file("res://Levels/First_Level/first_level.tscn")

func _physics_process(delta):
	$VBoxContainer/Label.text = "Your Time  " + str(Globvar.firt_stage_time)
