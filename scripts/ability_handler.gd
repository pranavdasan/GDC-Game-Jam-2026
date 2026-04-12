extends Node

const GROWTH_RATE : float = 0.02
const JUMP_FORCE : float = 1250
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
		#z through b keys are used, so that mouse is not used like hollow knight
		match event.keycode:
			KEY_Z:
				use_ability(AbilityHud.created_ability_button_ids[0])
			KEY_X:
				use_ability(AbilityHud.created_ability_button_ids[1])
			KEY_C:
				use_ability(AbilityHud.created_ability_button_ids[2])
			KEY_V:
				use_ability(AbilityHud.created_ability_button_ids[3])
			KEY_B:
				use_ability(AbilityHud.created_ability_button_ids[4])
		
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
	var AbilityButton : Button = AbilityHud.get_children()[ability_button_index]
	
	# to make sure there is enough snow AND that the ability is not on cooldown
	if Global.snow_meter < Global.abilities[ability_id].snow_cost or AbilityButton.CooldownTimer.time_left != 0.0:
		return
	
	# for snow jump
	if ability_id == 1 and not Snowball.touching_floor():
		return
	
	#subtracts the cost of the ability from snow meter
	Global.subtract_snow_meter(Global.abilities[ability_id].snow_cost)
	
	# starts cooldown for that ability
	AbilityButton.start_cooldown(ability_id)
	
	# actual code for the ability
	match ability_id:
		0: # grow
			pass # passive
		1: # snow jump
			jump_ability()
		2:
			snow_bullet_ability(Snowball.last_input_vector.normalized())
		3:
			pass
		4: # dash
			dash_ability(Snowball.last_input_vector.normalized())

## applies jump force to snowball in up direction
func jump_ability() -> void:
	Snowball.apply_central_impulse(Vector2.UP * JUMP_FORCE)

## instantiates a snow bullet with direction of [param direction] and constant force
func snow_bullet_ability(direction : Vector2) -> void:
	var SnowBulletInstance : RigidBody2D = SnowBullet.instantiate()
	SnowBulletInstance.position = Snowball.position
	SnowBulletInstance.rotation = direction.angle()
	SnowBulletInstance.constant_force = direction * BULLET_SPEED
	Main.add_child(SnowBulletInstance)

## applies force to snowball in direction of [param direction]
func dash_ability(direction : Vector2) -> void:
	Snowball.apply_central_impulse(direction * DASH_SPEED)
