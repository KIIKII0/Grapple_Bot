extends Node3D

var mouse_capture
@onready var player = $Bob
@onready var points = $Points.get_child_count()
var first_level_time: float
var send = false
var enter_count
func _ready():
	Globvar.Score = 0
	Globvar.stop = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_capture = true
	enter_count = 0
	Globvar.gravity_reversed = 1
	$city_reversed.visible = false
	$city_1.visible = true
	$death_areas/death_area2.monitoring = false
	
func change():
	enter_count += 1
	if enter_count == 1:
		Globvar.material_color_change(58, 201, 42)
		Globvar.gravity_reversed *= -1
		player.rotate_object_local(Vector3(0, 0, 1), deg_to_rad(Vector3(0, 0, 180).z))
		$city_reversed.visible = true
		$city_1.visible = false
		$death_areas/death_area2.monitoring = true

	else:
		pass

func _process(delta):
	if Globvar.Score != points:
		first_level_time = float(first_level_time) + delta
	elif Globvar.Score == points:
		Globvar.stop = true
		Globvar.best_time(first_level_time,1)
		send = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		$Vicotry_menu.visible = true
		
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
			
	if Globvar.dead:
		if mouse_capture == true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$Death_Screen.visible = true
			mouse_capture = false
			get_tree().paused = true
			Globvar.gravity_reversed *= 1
		else: 
			pass

