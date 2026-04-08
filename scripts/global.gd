extends Node

var abilities : Array[Ability] = [
	Ability.new(
		"Dash",
		"Allows the user to rapidly move in a certain direction at the cost of some snow",
		50
	),
	Ability.new(
		"Snow Jetpack",
		"Boost upwards at a high speed at the cost of some snow",
		100
	),
	Ability.new(
		"Snow Gun",
		"Shoots some snow towards the mouse at the cost of some snow",
		150
	)
]

var owned_abilities : Array[Ability]

signal snobux_changed()
signal snow_meter_changed()

var snobux : int = 200
var snow_meter : float = 0.0

func set_snobux(value : int) -> void:
	snobux = value
	emit_signal("snobux_changed")

func set_snow_meter(value : float) -> void:
	snow_meter = value
	emit_signal("snow_meter_changed")
