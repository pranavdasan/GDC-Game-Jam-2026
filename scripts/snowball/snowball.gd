extends RigidBody2D

const BASE_PIXEL_RADIUS : int = 700

@export var speed: float = 50000
@export var max_radius: float = 120.0

@export var base_radius: float = 19.0
@export var base_mass: float = 1.0
@export var mass_growth_multiplier: float = 0.025

@export var input_vector : Vector2 = Vector2.ZERO
# input vector before it equals zero
@export var last_input_vector : Vector2 = Vector2.ZERO

@onready var CollisionShape: CollisionShape2D = $CollisionShape2D
@onready var Sprite: Sprite2D = $Sprite2D
@onready var RayCast : RayCast2D = $RayCast2D

var current_radius: float
@export var original_scale: Vector2

func _ready() -> void:
	current_radius = base_radius
	original_scale = Sprite.scale
	
	Global.set_snow_meter(base_radius / max_radius * 100)
	
	# Make sure the
	CollisionShape.shape.radius = base_radius

	update_scale()
	# update_mass()

func _physics_process(delta: float) -> void:
	RayCast.target_position = Vector2(0, BASE_PIXEL_RADIUS * Sprite.scale.length() / 2 + 2)
	RayCast.global_rotation = 0
	
	handle_movement(delta)
	
	update_visual_size(delta)

func _input(event) -> void:
	if event.is_action_pressed("move_up"):
		if Global.get_ability(1).owned:
			AbilityHandler.use_ability(1)

func handle_movement(delta: float) -> void:
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector
	
	if Global.get_ability(0).owned:
		handle_growth(delta)
	
	if input_vector != Vector2.ZERO:
		apply_central_force(Vector2(input_vector.x * speed,0))

func handle_growth(delta: float) -> void:
	# Check if snowball fully moving (so not for every button press) and not exceed max_radius
	if (
			linear_velocity.length() < 100
			or current_radius >= max_radius
			or not touching_floor()
		):
			return
	
	var growth_amount: float = speed * AbilityHandler.current_growth_rate * delta
	Global.add_snow_meter(growth_amount / max_radius * 100)

func update_visual_size(_delta : float) -> void:
	current_radius = min(
		Global.snow_meter / 100 * max_radius,
		max_radius
	)
	
	update_collisionShape()
	update_scale()
	# update_mass()

func update_collisionShape() -> void:
	CollisionShape.shape.radius = current_radius

func update_scale() -> void:
	var scale_ratio: float = current_radius / base_radius
	Sprite.scale = original_scale * scale_ratio

func update_mass() -> void:
	mass = base_mass + (current_radius - base_radius) * mass_growth_multiplier

func touching_floor() -> bool:
	var raycast_collider = RayCast.get_collider()
	
	if raycast_collider:
		return get_tree().get_nodes_in_group("floor").find(raycast_collider)  == -1
	
	return false
