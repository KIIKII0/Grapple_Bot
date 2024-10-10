extends CharacterBody3D

#vars 
@export var max_health: float = 100
var health: float = max_health
var SPEED: float
var normal_speed = Globvar.normal_speed
var sprint_speed = Globvar.sprint_speed
var crouch_speed = Globvar.crouch_fall
var JUMP_VELOCITY = Globvar.jump_velocity
var boost = false
var boost_speed
#all usful stuff
var sensitivity = 0.12
var gravity = Globvar.gravity
var num_of_jumps = 0
var sprinting = false
var current_time = Globvar.time

enum movement {
	Walking,
	Sprinting,
	Falling,
	}

var cuurent_state: movement = movement.Walking

#the callbacks to the elements to the player
@onready var head := $Head
@onready var Camera := $Head/Camera3D
@onready var right_arm := $Head/Camera3D/arms/right_arm
@onready var left_arm :=$Head/Camera3D/arms/left_arm
@onready var player_colision := $CollisionShape3D
@onready var health_bar := $UI/essential_container/Health_Bar
@onready var speedometer := $UI/essential_container/speedometer
@onready var Score := $UI/time_and_score/Score
@onready var speedrun_time := $UI/time_and_score/Speedrun_Time
@onready var grapple_reach := $Head/Camera3D/grapple_reach
#function that are responsible for update damage, knockback etc.

func damage(hit_points):
	update_health_bar()
	if hit_points < health:
		health -= hit_points
		update_health_bar()
	else:
		health = 0
	if health == 0:
		update_health_bar()
		die()
#updating healthbar
func update_health_bar():
	var health_percentage = (health / max_health) * 100
	health_bar.text = str(round(health_percentage)) + "% "
#updates speedometer
func update_speedometer():
	var cuurent_speed = velocity.length() * 3
	speedometer.text = str(round(cuurent_speed)) + "KM/H"
#func for speed boost
func speed_boost(status,speed_value = 1):
	if status:
		boost = true
		boost_speed = speed_value
	else:
		boost = false
func update_score():
	Score.text = "SCORE: " + str(Globvar.Score)
	
func die():
	pass
	
func update_time():
	var stopped = Globvar.stop
	var formated_time = str(current_time)
	var decimel_index = formated_time.find(".")
	if Globvar.Score == 4:
		stopped = true
	if stopped == false:
		if decimel_index > 0:
			formated_time = formated_time.left(decimel_index + 3)
		Globvar.time = formated_time
		speedrun_time.text = formated_time
		Globvar.firt_stage_time = formated_time
	else:
		pass
	
func _ready():
	update_health_bar()
	
#rotation of the camera with the mouse
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad((-event.relative.x * sensitivity)))
		head.rotate_x(deg_to_rad((-event.relative.y * sensitivity)))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90),deg_to_rad(90))
#handle speed and number or jumps and also gravity

func _physics_process(delta):
	current_time = float(current_time) + delta
	update_time()
	update_speedometer()
	match cuurent_state:
		movement.Walking:
			if boost:
				SPEED = lerp(SPEED, normal_speed * boost_speed, delta * 3 )
			else:
				SPEED = lerp(SPEED, normal_speed, delta * 3)
		movement.Sprinting:
			if boost:
				SPEED = lerp(SPEED, sprint_speed * boost_speed, delta * 3 )
			else:
				SPEED = lerp(SPEED,sprint_speed,delta * 6)
				
	if is_on_floor():
		num_of_jumps = 2
	if not is_on_floor():
		var air_time = 1
		air_time += delta
		velocity.y -= gravity * delta * (1.3 + air_time)
		if cuurent_state == movement.Sprinting or cuurent_state == movement.Walking:
			SPEED = clamp(SPEED,normal_speed,50)

	# Handle jump and double jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print(Globvar.Score)
		if num_of_jumps == 2:
			num_of_jumps -= 1
			velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if num_of_jumps == 1:
			num_of_jumps -= 1
			velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("fast_falling") and not is_on_floor():
		velocity.y -= 1.5
			
	#Sprinting
	if Input.is_action_just_pressed("Sprint"):
		if cuurent_state == movement.Walking:
			cuurent_state = movement.Sprinting
		elif cuurent_state == movement.Sprinting:
			cuurent_state = movement.Walking
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		#the simulate realistic slow effecct when running
		else: 
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 6.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 6.0)
	#for making the speed
	else: 
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2.2)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2.2)
	move_and_slide()
