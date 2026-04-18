extends RigidBody2D

const BASE_PIXEL_RADIUS : int = 700
const HURT_BOX_RATIO : float = 0.5

@export var speed : float = 50000
@export var max_radius : float = 120.0

@export var base_radius : float = 19.0
@export var base_mass : float = 1.0
@export var mass_growth_multiplier : float = 0.025

@export var input_vector : Vector2 = Vector2.ZERO
# input vector before it equals zero
@export var last_input_vector : Vector2 = Vector2.ZERO
# last SINGLE input vector direction (ie only up, down, left, or right)
@export var last_cardinal_input_vector : Vector2 = Vector2.ZERO

@onready var CollisionShape : CollisionShape2D = $CollisionShape2D
@onready var Sprite : Sprite2D = $Sprite2D

@onready var FloorShapeCast : ShapeCast2D = $FloorShapeCast2D
@onready var RollingCrushAttackBox : Area2D = $RollingCrushAttackBox
@onready var HurtBox : Area2D = $HurtBox

var current_radius : float
var original_scale : Vector2
var scale_ratio : float

func _ready() -> void:
	current_radius = base_radius
	original_scale = Sprite.scale
	
	Global.set_snow_meter(base_radius / max_radius * 100)
	
	# Make sure the
	CollisionShape.shape.radius = base_radius

	update_scale()
	# update_mass()

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	
	update_visual_size(delta)

func _input(input : InputEvent):
	if Input.is_action_just_pressed_by_event("move_up", input):
		last_cardinal_input_vector = Vector2.UP
	if Input.is_action_just_pressed_by_event("move_down", input):
		last_cardinal_input_vector = Vector2.DOWN
	if Input.is_action_just_pressed_by_event("move_left", input):
		last_cardinal_input_vector = Vector2.LEFT
	if Input.is_action_just_pressed_by_event("move_right", input):
		last_cardinal_input_vector = Vector2.RIGHT

func handle_movement(delta: float) -> void:
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	if Input.is_action_pressed("move_up"):
		if Global.get_ability(1).owned:
			AbilityHandler.use_ability(1)
	
	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector
	
	if Global.get_ability(0).owned:
		handle_growth(delta)
	
	if input_vector != Vector2.ZERO:
		apply_central_force(Vector2(input_vector.x * speed,0))

func handle_growth(delta: float) -> void:
	# Check if snowball fully moving (so not for every button press) and not exceed max_radius and not touching flor
	# if so then stop here
	if (
			linear_velocity.length() < 100
			or current_radius >= max_radius
			or not touching_floor()
		):
			return
	
	var growth_amount : float = speed * AbilityHandler.current_growth_rate * delta
	Global.add_snow_meter(growth_amount / max_radius * 100)

func update_visual_size(_delta : float) -> void:
	current_radius = min(
		Global.snow_meter / 100 * max_radius,
		max_radius
	)
	
	update_hitboxes()
	
	update_collisionShape()
	update_scale()
	# update_mass()

func update_collisionShape() -> void:
	CollisionShape.shape.radius = current_radius

func update_scale() -> void:
	scale_ratio = current_radius / base_radius
	Sprite.scale = original_scale * scale_ratio

func update_mass() -> void:
	mass = base_mass + (current_radius - base_radius) * mass_growth_multiplier

func update_hitboxes() -> void:
	# floor ray cast for floor check
	# sets floor FloorRayCast to always face down and be the length of the radius
	FloorShapeCast.target_position = Vector2.DOWN * (current_radius + 10)
	FloorShapeCast.global_rotation = 0
	
	# attack box for rolling crush:
	# always faces the rolling crush attack box to face downwards as well
	RollingCrushAttackBox.scale = Vector2.ONE * scale_ratio * 1 # 1 being the original scale, in case it ever changes
	RollingCrushAttackBox.global_rotation = 0
	
	# hurt box (technically hurt circle haha):
	# set it relative to visual scale, ie smaller for more forgiveness
	HurtBox.scale = Vector2.ONE * scale_ratio * HURT_BOX_RATIO

func touching_floor() -> bool:
	FloorShapeCast.force_shapecast_update()
	
	var collision_result = FloorShapeCast.get_collision_result()
	
	for collider_dict in collision_result:
		var collider = collider_dict["collider"]
		
		if get_tree().get_nodes_in_group("terrain").find(collider)  != -1:
			return true
	
	return false

func _on_rolling_crush_attack_box_body_entered(body: Node2D) -> void:
	if get_tree().get_nodes_in_group("enemies").find(body) != -1:
		print("enemy found") # attack the enemy here
