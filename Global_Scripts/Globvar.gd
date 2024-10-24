extends Node

var Score = 0
var gravity = 20
var pull_speed = 8
var stop = false
var gravity_reversed = 1
#player variables
var normal_speed: float = 30.0
var crouch_fall: float = 3.0
var jump_velocity:float = 20
var dead = false

#first_stag_var
var first_stage_speed_time: String
var best_first_stage_time: float

#material color
@onready var material_white = preload("res://Assets/City/uniwersal_white_material.tres")
@onready var grappling_rope = preload("res://Fists/Basic_fist/rope_material.tres")
@onready var button_theme = preload("res://Control_Scene/button_theme.tres")
func _ready():
	material_color_change(255, 255, 255)
	gravity_reversed = 1
	
	
func material_color_change(red = 1,green = 1,blue= 1):
	red = red / 255.0
	green = green / 255.0
	blue = blue / 255.0
	material_white.emission_enabled = true
	material_white.albedo_color = Color(red,green,blue)
	material_white.emission = Color(red,green,blue)
	material_white.emission_energy_multiplier = 1
	button_theme.get_stylebox("normal", "Button").border_color = Color(red,green,blue)
	if red and blue and green == 1:
		grappling_rope.emission_enabled = true
		grappling_rope.albedo_color = Color(0, 0.278, 0.639)
		grappling_rope.emission = Color(0, 0.278, 0.639)
		grappling_rope.emission_energy_multiplier = 1
		
	else:
		grappling_rope.emission_enabled = true
		grappling_rope.albedo_color = Color(1.0-red,1.0-green,1.0-blue)
		grappling_rope.emission = Color(1.0-red,1.0-green,1.0-blue)
		grappling_rope.emission_energy_multiplier = 1
	

func best_time(time_from_stage, stage):
	time_from_stage = float(time_from_stage)
	if best_first_stage_time == 0 and stage == 1:
		best_first_stage_time = time_from_stage
		print(best_first_stage_time)
	elif  time_from_stage < best_first_stage_time and stage == 1:
		best_first_stage_time = time_from_stage
		print(best_first_stage_time)
	else:
		pass
		
