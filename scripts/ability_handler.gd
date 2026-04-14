extends Node

const BASE_GROWTH_RATE : float = 0.02
const GROWTH_RATE_UPGRADE_MULT : float = 0.005
const BASE_JUMP_FORCE : float = 400.0
const JUMP_FORCE_UPGRADE_MULT : float = 100.0
const BULLET_SPEED : float = 15000
const DASH_SPEED : float = 1250

const SnowBullet = preload("res://scenes/snow_bullet.tscn")

@onready var Main : Node2D = get_node("/root/Main")

@onready var AbilityHud : HBoxContainer = get_node("/root/Main/Hud/AbilityHud")
@onready var Snowball : RigidBody2D = get_node("/root/Main/Snowball")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AbilityHud.ability_button_pressed.connect(on_ability_button_pressed)

func on_ability_button_pressed(ability_id : int) -> void:
	use_ability(ability_id)

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		for i in Global.ability_keybinds.keys().size():
			if event.keycode == Global.ability_keybinds.keys()[i]:
				use_ability(AbilityHud.created_ability_button_ids[i])
				break
		
		# \/ this is for arrow keys \/
		#if event.keycode >= KEY_0 and event.keycode <= KEY_9:
			## this is the int version of key pressed
			#var ability_button_index : int = event.keycode - KEY_0
			#
			## if it's zero it's actually 10 (the tenth number key)
			#if ability_button_index == 0:
				#ability_button_index = 10
			#
			## checks that this button actually has a created ability
			#if ability_button_index <= AbilityHud.created_ability_button_ids.size():
				## finds the ability id of this created ability button
				#var ability_id : int = AbilityHud.created_ability_button_ids[ability_button_index - 1]
				#use_ability(ability_id)

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
			pass # passive
		1: # snow jump
			jump_ability()
		2:
			snow_bullet_ability(Snowball.linear_velocity, Snowball.last_input_vector.normalized())
		3:
			pass
		4: # dash
			dash_ability(Snowball.last_input_vector.normalized())

## applies jump force to snowball in up direction
func jump_ability() -> void:
	Snowball.apply_central_impulse(Vector2.UP * BASE_JUMP_FORCE - Vector2(0, JUMP_FORCE_UPGRADE_MULT * Global.get_ability(1).ability_level))

## instantiates a snow bullet with direction of [param direction] and constant force
func snow_bullet_ability(starting_velocity: Vector2, direction : Vector2) -> void:
	var SnowBulletInstance : RigidBody2D = SnowBullet.instantiate()
	SnowBulletInstance.position = Snowball.position
	SnowBulletInstance.rotation = direction.angle()
	SnowBulletInstance.constant_force = direction * BULLET_SPEED
	SnowBulletInstance.linear_velocity = starting_velocity
	Main.add_child(SnowBulletInstance)

## applies force to snowball in direction of [param direction]
func dash_ability(direction : Vector2) -> void:
	Snowball.apply_central_impulse(direction * DASH_SPEED)
