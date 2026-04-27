extends Node

# 0 grow
const BASE_GROWTH_RATE : float = 0.02
const GROWTH_RATE_UPGRADE_MULT : float = 0.005

var current_growth_rate : float = BASE_GROWTH_RATE


# 1 snow jump
const JUMP_FORCE : float = 850


# 2 snow bullet
const BULLET_SPEED : float = 15000.0

const BASE_BULLET_DAMAGE : float = 5.0
const BULLET_DAMAGE_UPGRADE_MULT : float = 1.0

const BASE_BULLET_COOLDOWN : float = 0.25
const BULLET_COOLDOWN_UPGRADE_MULT : float = 0.025

var current_bullet_damage : float = BASE_BULLET_DAMAGE
var current_bullet_cooldown : float = BASE_BULLET_COOLDOWN


# 3 snow punch
const BASE_PUNCH_DAMAGE : float = 10.0
const PUNCH_DAMAGE_UPGRADE_MULT : float = 2.0

var current_punch_damage : float = BASE_PUNCH_DAMAGE


# 4 dash
const BASE_DASH_SPEED : float = 300
const DASH_SPEED_UPGRADE_MULT : float = 125

const BASE_DASH_COOLDOWN : float = 1.0
const DASH_COOLDOWN_UPGRADE_MULT : = 0.05

var current_dash_speed : float = BASE_DASH_SPEED
var current_dash_cooldown : float = BASE_DASH_COOLDOWN

const BASE_DASH_PARTICLE_SCALE_MIN : float = 4.0
const BASE_DASH_PARTICLE_SCALE_MAX : float = 5.0


const SnowBullet = preload("res://scenes/player/snow_bullet.tscn")

# to be defined when main is entered into the scene:
var Main : Node2D 
var AbilityHud : HBoxContainer
var Snowball : RigidBody2D
var SnowPunch : AnimatedSprite2D

func _ready() -> void:
	Global.main_ready.connect(on_main_ready)

func on_main_ready() -> void:
	Main = get_node("/root/Main")
	AbilityHud = get_node("/root/Main/Hud/AbilityHud")
	Snowball = get_node("/root/Main/Snowball")
	SnowPunch = get_node("/root/Main/Snowball/SnowPunch")
	
	AbilityHud.ability_button_pressed.connect(on_ability_button_pressed)

func on_ability_button_pressed(ability_id : int) -> void:
	use_ability(ability_id)

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		for i in Global.ability_keybinds.keys().size():
			if event.keycode == Global.ability_keybinds.keys()[i]:
				if i > AbilityHud.created_ability_button_ids.size() - 1:
					continue
				use_ability(AbilityHud.created_ability_button_ids[i])
				break

## checks if ability is able to be used (snow cost and cooldown) and uses respective ability
func use_ability(ability_id : int) -> void:
	# gets the real ability button node for used ability
	var ability_button_index : int = AbilityHud.created_ability_button_ids.find(ability_id)
	var AbilityButton : Button = null
	if ability_button_index != -1:
		# if ability button DOES exist (non-passive ability)
		AbilityButton = AbilityHud.get_children()[ability_button_index]
		
		if AbilityButton.CooldownTimer.time_left != 0.0:
			# if ability is on cooldown
			return
		
	# if user doesn't have enough snow, DIE!
	if Global.snow_meter < Global.get_ability(ability_id).snow_cost:
		Global.die()
	
	# for snow jump, cannot jump in air
	if ability_id == 1 and not Snowball.touching_floor():
		return
	
	#subtracts the cost of the ability from snow meter
	Global.subtract_snow_meter(Global.get_ability(ability_id).snow_cost)
	
	# starts cooldown for that ability, if it has one (meaning exists -> non-passive)
	if AbilityButton:
		AbilityButton.start_cooldown(ability_id)
	
	# actual code for the ability
	match ability_id:
		0: # grow
			pass # passive, checks in Snowball scene
		1: # snow jump
			jump_ability()
		2: # snow bullet
			snow_bullet_ability(Snowball.linear_velocity, Snowball.last_input_vector.normalized())
		3: # snow punch
			snow_punch_ability(Snowball.last_input_vector.angle())
		4: # dash
			dash_ability(Snowball.last_input_vector)

## sets all ablity properties to their levels according to current ability level
func update_ability_values() -> void:
	# 0 grow
	current_growth_rate = BASE_GROWTH_RATE + GROWTH_RATE_UPGRADE_MULT * Global.get_ability(0).ability_level
	Global.get_ability(0).stats["growth_rate"][0] = current_growth_rate
	
	# 2 bullet
	current_bullet_damage = BASE_BULLET_DAMAGE + BULLET_DAMAGE_UPGRADE_MULT * Global.get_ability(2).ability_level
	current_bullet_cooldown = BASE_BULLET_COOLDOWN - BULLET_COOLDOWN_UPGRADE_MULT * Global.get_ability(2).ability_level
	Global.get_ability(2).stats["bullet_damage"][0] = current_bullet_damage
	Global.get_ability(2).set_ability_cooldown(current_bullet_cooldown)
	
	# 3 punch
	current_punch_damage = BASE_PUNCH_DAMAGE + PUNCH_DAMAGE_UPGRADE_MULT * Global.get_ability(3).ability_level
	Global.get_ability(3).stats["punch_damage"][0] = current_punch_damage
	
	# 4 dash
	current_dash_speed = BASE_DASH_SPEED + DASH_SPEED_UPGRADE_MULT * Global.get_ability(4).ability_level
	current_dash_cooldown = BASE_DASH_COOLDOWN - DASH_COOLDOWN_UPGRADE_MULT * Global.get_ability(4).ability_level
	Global.get_ability(4).stats["dash_speed"][0] = current_dash_speed
	Global.get_ability(4).set_ability_cooldown(current_dash_cooldown)

## 1 applies jump force to snowball in up direction
func jump_ability() -> void:
	Snowball.linear_velocity.y = 0
	Snowball.apply_central_impulse(Vector2.UP * JUMP_FORCE)

## 2 instantiates a snow bullet with direction of [param direction] and constant force
func snow_bullet_ability(starting_velocity: Vector2, direction : Vector2) -> void:
	var SnowBulletInstance : RigidBody2D = SnowBullet.instantiate()
	SnowBulletInstance.position = Snowball.position
	SnowBulletInstance.rotation = direction.angle()
	SnowBulletInstance.constant_force = direction * BULLET_SPEED
	SnowBulletInstance.linear_velocity = starting_velocity
	Main.add_child(SnowBulletInstance)

## 3 calls the punch function in SnowPunch with direction of [param direction]
func snow_punch_ability(angle : float):
	SnowPunch.punch(rad_to_deg(angle) + 90)

## 4 applies force to snowball in direction of [param direction]
func dash_ability(direction : Vector2) -> void:
	var DashParticles : GPUParticles2D = Snowball.find_child("DashParticles")
	DashParticles.process_material.set("direction", Vector3(direction.x, direction.y, 0))
	DashParticles.process_material.set("scale_min", BASE_DASH_PARTICLE_SCALE_MIN * Snowball.scale_ratio)
	DashParticles.process_material.set("scale_max", BASE_DASH_PARTICLE_SCALE_MAX * Snowball.scale_ratio)
	
	Snowball.apply_central_impulse(direction * current_dash_speed)
	
	#DashParticles.process_material.set("initial_velocity", Snowball.linear_velocity)
	
	DashParticles.emitting = true
