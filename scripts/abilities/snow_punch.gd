extends AnimatedSprite2D

const ORIGINAL_SCALE : Vector2 = Vector2.ONE * 1.5

@onready var Snowball : RigidBody2D = get_node("/root/Main/Snowball")

var angle : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_rotation = deg_to_rad(angle)

## [param p_angle] is in degrees
func punch(p_angle : float):
	scale = ORIGINAL_SCALE * Snowball.scale_ratio
	angle = p_angle
	
	# the angles are really weird idk;
	# first it's in radians so it is 0 to 180 or 0 to -180
	# second the snowball's 0deg is facing right so i added 90
	# so therefore it's odd idk
	if angle >= 180 or angle <= 0:
		flip_h = true
	else:
		flip_h = false
	
	visible = true
	
	play("hit")

func _on_animation_finished() -> void:
	visible = false
