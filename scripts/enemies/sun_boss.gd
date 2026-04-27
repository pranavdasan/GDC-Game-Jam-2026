extends CharacterBody2D

@export var sun_orb_scene: PackedScene

@export var attack_range: float = 600.0

@onready var spawn_point = $"Orb Spawn Point"
@onready var attack_timer = $Timer

@export var max_hp : float = 100;
@export var current_hp : float = 100;
@onready var health_bar : HealthBar = $"Health Bar"




var player: Node2D

func _ready() -> void:
	player = $"../Snowball"
	start_random_timer()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		# Hit the player
		if collider.is_in_group("snow_bullet"):
			print
			current_hp = current_hp - 5.0 
			health_bar.update_bar(current_hp, max_hp)
	
	move_and_slide()

func start_random_timer():
	attack_timer.wait_time = randf_range(2.0, 5.0)
	attack_timer.start()
	
func _on_timer_timeout() -> void:
	# Only spawn attack if player is in range
	if player and global_position.distance_to(player.global_position) <= attack_range: 
		spawn_orb()
		
	start_random_timer()
	
func spawn_orb():
	if sun_orb_scene:
		# Create a new orb
		var orb = sun_orb_scene.instantiate() 
		
		# Makes sure it won't collide with boss
		orb.add_collision_exception_with(self)
		
		# Move orb to attack spawn point
		orb.global_position = spawn_point.global_position
		
		get_tree().current_scene.add_child(orb)
