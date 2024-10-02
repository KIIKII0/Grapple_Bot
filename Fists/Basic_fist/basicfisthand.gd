extends MeshInstance3D

@onready var hurtbox = $hurt_box
@onready var anima = $AnimationPlayer
@onready var parent_hand = get_parent().get_name()
@export var damaga_dealt: float = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("attack_right") and parent_hand == "right_arm":
		anima.play("right_attack")
	else:
		pass
	if Input.is_action_just_pressed("attack_left") and parent_hand == "left_arm":
		anima.play("left_attack")
	else:
		pass



