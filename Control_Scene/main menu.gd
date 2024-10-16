extends Control
var best_time_1: String



func _on_exit_button_pressed():
	get_tree().quit()


func _on_test_button_pressed():
	get_tree().change_scene_to_file("res://Levels/First_Level/first_level.tscn")
	
	
#function to make time into strin and pleased visual
func string_time():
	var formated_time = str(Globvar.best_first_stage_time)
	var decimel_find = formated_time.find(".")
	if decimel_find > 0 :
		formated_time = formated_time.left(decimel_find + 3)
	best_time_1 = formated_time

#function to display time
func _physics_process(delta):
	string_time()
	$VBoxContainer/first_stage_time.text = "Best Time of this stage: " + best_time_1
