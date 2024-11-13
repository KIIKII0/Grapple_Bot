extends Control
var best_time_1: String



func _on_exit_button_pressed():
	get_tree().quit()


func _on_test_button_pressed():
	get_tree().change_scene_to_file("res://Levels/First_Level/first_level.tscn")
	
	



func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://Control_Scene/option_menu.tscn")
	
