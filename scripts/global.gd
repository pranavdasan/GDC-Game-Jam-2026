extends Node

var abilities : Array[Ability] = [
	Ability.new(
		"Dash",
		"Allows the user to rapidly move in a certain direction at the cost of some snow",
		10,
		1.0,
		0
	),
	Ability.new(
		"Snow Jetpack",
		"Boost upwards at a high speed at the cost of some snow",
		20,
		2.0,
		1
	),
	Ability.new(
		"Snow Gun",
		"Shoots some snow towards the mouse at the cost of some snow",
		30,
		3.0,
		2
	)
]

const ABILITY_SHEET_PIXEL_WIDTH : int = 32

const MIN_SNOW_METER : float = 0.0
const MAX_SNOW_METER : float = 100.0

signal owned_abilities_added()

signal snobux_changed()
signal snow_meter_changed()

var owned_abilities : Array[Ability]

var snobux : int = 200
var snow_meter : float = 0.0

func add_owned_ability(ability : Ability) -> void:
	owned_abilities.append(ability)
	owned_abilities_added.emit()

func set_snobux(value : int) -> void:
	snobux = value
	snobux_changed.emit()

func set_snow_meter(value : float) -> void:
	snow_meter = clamp(value, MIN_SNOW_METER, MAX_SNOW_METER)
	snow_meter_changed.emit()

func add_snow_meter(value : float) -> void:
	set_snow_meter(snow_meter + value)

func subtract_snow_meter(value : float) -> void:
	set_snow_meter(snow_meter - value)
