extends CharacterBody3D

#vars 
@export var max_health: float = 1
var health: float = max_health
var SPEED: float
var normal_speed = Globvar.normal_speed
var crouch_speed = Globvar.crouch_fall
var JUMP_VELOCITY = Globvar.jump_velocity
var boost = false
var boost_speed
#all usful stuff
var sensitivity = 0.12
var gravity = Globvar.gravity
var num_of_jumps = 0

enum movement {
	Walking,
	}

var cuurent_state: movement = movement.Walking

#the callbacks to the elements to the player
@onready var head := $Head
@onready var Camera := $Head/Camera3D
@onready var right_arm := $Head/Camera3D/arms/right_arm
@onready var left_arm :=$Head/Camera3D/arms/left_arm
@onready var player_colision := $CollisionShape3D
@onready var grapple_reach := $Head/Camera3D/grapple_reach
@onready var speedlines := $UI/speed_lines
#function that are responsible for update damage, knockback etc.

func damage(hit_points):
	if hit_points < health:
		health -= hit_points
	else:
		health = 0
	if health == 0:
		die()
#func for speed boost
func speed_boost(status,speed_value = 1):
	if status:
		boost = true
		boost_speed = speed_value
	else:
		boost = false

func die():
	Globvar.dead = true
	Globvar.material_color_change(240, 33, 33)
	$UI/speed_lines.visible = false
	
func _ready():
	Globvar.dead = false
	Globvar.material_color_change(255, 255, 255)
#rotation of the camera with the mouse
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad((-event.relative.x * sensitivity * Globvar.gravity_reversed)))
		head.rotate_x(deg_to_rad((-event.relative.y * sensitivity)))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90),deg_to_rad(90)) 
#handle speed and number or jumps and also gravity
#speed lines drew
func update_speed_lines():
	var lines_speed = velocity.length() / 10
	var line_density = clamp(lines_speed / 20.0, 0.0, 0.5)
	speedlines.material.set_shader_parameter("line_density", line_density)
func _physics_process(delta):
	print(health)
	var target_fov = lerp(75.0,115.0, clamp(velocity.length()/100, 0, 1))
	Camera.fov = lerp(Camera.fov, target_fov, 2.0 * delta)
	update_speed_lines()
	match cuurent_state:
		movement.Walking:
			if boost:
				SPEED = lerp(SPEED, normal_speed * boost_speed, delta * 3 )
			else:
				SPEED = lerp(SPEED, normal_speed, delta * 3)
				
	if is_on_floor():
		num_of_jumps = 2
		velocity.y -= (gravity * delta) * Globvar.gravity_reversed

	if not is_on_floor():
		var air_time = 1
		air_time += delta
		velocity.y -= (gravity * delta * (1.3 + air_time)) * Globvar.gravity_reversed
		if cuurent_state == movement.Walking:
			SPEED = clamp(SPEED,normal_speed,50)

	# Handle jump and double jumpw
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print(Globvar.Score)
		if num_of_jumps == 2:
			num_of_jumps -= 1
			velocity.y = JUMP_VELOCITY * Globvar.gravity_reversed
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if num_of_jumps == 1:
			num_of_jumps -= 1
			velocity.y = JUMP_VELOCITY * Globvar.gravity_reversed
	if Input.is_action_pressed("fast_falling") and not is_on_floor():
		velocity.y -= 1.2 * Globvar.gravity_reversed
			
	#Sprinting
	if Input.is_action_just_pressed("Sprint"):
		pass
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
