extends Node

var abilities : Array[Ability] = [
	Ability.new(
		"Grow",
		"Allows the user to replenish snow by rolling around",
		0.0,
		0.0,
		0
	),
	Ability.new(
		"Snow Jump",
		"Allows the user to launch upwards from the ground at the cost of some snow",
		0.0,
		4.0,
		1
	),
	Ability.new(
		"Snow Bullet",
		"Fires a projectile made of snow in the direction of the uesr's movement",
		0.25,
		2.0,
		2
	),
	Ability.new(
		"Snow Jetpack",
		"Boost upwards at a high speed at the cost of some snow",
		2.0,
		15.0,
		3
	),
	Ability.new(
		"Dash",
		"Allows the user to rapidly move in a certain direction at the cost of some snow",
		1.0,
		6.0,
		4
	)
]

const ABILITY_SHEET_PIXEL_WIDTH : int = 32

const MIN_SNOW_METER : float = 0.0
const MAX_SNOW_METER : float = 100.0

signal owned_abilities_added()

signal skill_points_changed()
signal snow_meter_changed()

var owned_abilities : Array[Ability]

var skill_points : int = 200
var snow_meter : float = 0.0

func _ready() -> void:
	pass

func is_ability_owned(ability_id : int) -> bool:
	for ability in owned_abilities:
		if ability.id == ability_id:
			return true
	
	return false

func add_owned_ability(ability_id : int) -> void:
	owned_abilities.append(abilities[ability_id])
	owned_abilities_added.emit()

func set_skill_points(value : int) -> void:
	skill_points = value
	skill_points_changed.emit()

func add_skill_points(value : int) -> void:
	set_skill_points(skill_points + value)

func subtract_skill_points(value : int) -> void:
	set_skill_points(skill_points - value)

func set_snow_meter(value : float) -> void:
	snow_meter = clamp(value, MIN_SNOW_METER, MAX_SNOW_METER)
	snow_meter_changed.emit()

func add_snow_meter(value : float) -> void:
	set_snow_meter(snow_meter + value)

func subtract_snow_meter(value : float) -> void:
	set_snow_meter(snow_meter - value)
