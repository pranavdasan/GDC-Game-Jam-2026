extends RigidBody2D

@export var speed: float = 50000
@export var growth_rate: float = 0.02
@export var max_radius: float = 120.0

@export var base_radius: float = 19.0
@export var base_mass: float = 1.0
@export var mass_growth_multiplier: float = 0.025

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var current_radius: float
var original_sprite_scale: Vector2


func _ready() -> void:
	current_radius = base_radius
	original_sprite_scale = sprite.scale
	
	# Make sure the 	
	collision_shape.shape.radius = base_radius

	update_scale()
	update_mass()


func _physics_process(delta: float) -> void:
	handle_movement(delta)


func handle_movement(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	
	if input_vector != Vector2.ZERO:
		apply_central_force(input_vector * speed)
		
		handle_growth(delta)

	

func handle_growth(delta: float) -> void:
	# Check if snowball fully moving (so not for every button press)
	if linear_velocity.length() < 100:
		return
	
	# Check if max size is reached
	if current_radius >= max_radius:
		return
	
	var growth_amount: float = speed * growth_rate * delta
	current_radius = min(current_radius + growth_amount, max_radius)
	
	update_collisionShape()
	update_scale()
	update_mass()

func update_collisionShape() -> void:
	collision_shape.shape.radius = current_radius


func update_scale() -> void:
	var scale_ratio: float = current_radius / base_radius
	sprite.scale = original_sprite_scale * scale_ratio

func update_mass() -> void:
	mass = base_mass + (current_radius - base_radius) * mass_growth_multiplier
