extends CharacterBody2D

@onready var anim_player = $AnimatedSprite2D

# Attack settings you can tweak in the Inspector
@export var attack_speed: float = 400.0
@export var damage: float = 5.0
@export var min_hover_time: float = 1.25
@export var max_hover_time: float = 1.5
@export var arrival_tolerance: float = 50.0

# Variables to track the attack state
var target_position: Vector2 = Vector2.ZERO
var is_attacking: bool = false
var player: Node2D

func _ready():
	# 1. Play the spawn animation
	anim_player.play("spawn")
	
	# Grab a reference to the player (ensure your player node is in the "player" group!)
	player = $"../Snowball"
	
	# 2. Start the hover/wait sequence
	hover_and_strike()

func _on_animated_sprite_2d_animation_finished():
	if anim_player.animation == "spawn":
		anim_player.play("idle")

func hover_and_strike():
	# Pick a random time between 1 and 2 seconds
	var wait_time = randf_range(min_hover_time, max_hover_time)
	
	# Pause this specific function until the timer counts down
	await get_tree().create_timer(wait_time).timeout
	
	# 3. Timer is done! Lock onto the player's exact location at this moment
	if player:
		target_position = player.global_position
		is_attacking = true # Give the green light to start moving

func _physics_process(delta):
	if is_attacking:
		# Calculate the direction to the saved target_position
		var direction = global_position.direction_to(target_position)
		
		# Apply velocity and move
		velocity = direction * attack_speed
		move_and_slide()
		
		# Check for collisions
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			# Hit the player
			if collider == player:
				# Update snow meter
				Global.subtract_snow_meter(damage)
				queue_free() # Destroy it
			
			if collider.is_in_group("terrain"):
				queue_free()
							
		# Destroy the orb once it reaches the target location
		if global_position.distance_to(target_position) < arrival_tolerance:
			queue_free() # The orb has reached the buffer zone, destroy it!


func _on_timer_timeout() -> void:
	pass # Replace with function body.
