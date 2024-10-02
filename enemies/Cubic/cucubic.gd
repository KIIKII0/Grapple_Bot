extends RigidBody3D


var target
var state = FOLLOW
@onready var navigation3d = $NavigationAgent3D
@onready var healthbar = $SubViewport/healthbar
@export var health:float = 50
@export var speed: float = 0.05
@export var damaga_dealt: float = 15 

enum {
	IDLE,
	FOLLOW
}

func _ready():
	healthbar.max_value = health
	healthbar.value = health
func _process(delta):
	if state == FOLLOW:
		var current_location = global_transform.origin
		var next_location = navigation3d.get_next_path_position()
		var direction = (next_location - current_location).normalized()
		apply_central_impulse(direction * speed)

func update_target_location(target_location):
	navigation3d.set_target_position(target_location)
	
#function to calculate damage and update the healthbar
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
		
func knocback(force, origin_position):
	var direction = (global_transform.origin - origin_position).normalized()
	var knockback_vector = direction * force
	apply_central_impulse(knockback_vector)
	


func die():
	pass

func update_health_bar():
	healthbar.value = health

func _on_hurt_box_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().call_group("Player", "damage", damaga_dealt)
#function to calculate how much knockback it is
