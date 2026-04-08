extends Node

var abilities : Array[Ability] = [
	Ability.new(
		"Dash",
		"Allows the user to rapidly move in a certain direction at the cost of some snow",
		10,
		0
	),
	Ability.new(
		"Snow Jetpack",
		"Boost upwards at a high speed at the cost of some snow",
		20,
		1
	),
	Ability.new(
		"Snow Gun",
		"Shoots some snow towards the mouse at the cost of some snow",
		30,
		2
	)
]

const ability_sheet_pixel_width : int = 32

signal owned_abilities_added()

signal snobux_changed()
signal snow_meter_changed()

var owned_abilities : Array[Ability]

var snobux : int = 200
var snow_meter : float = 0.0

func add_owned_ability(ability : Ability) -> void:
	owned_abilities.append(ability)
	emit_signal("owned_abilities_added")

func set_snobux(value : int) -> void:
	snobux = value
	emit_signal("snobux_changed")

func set_snow_meter(value : float) -> void:
	snow_meter = value
	emit_signal("snow_meter_changed")
