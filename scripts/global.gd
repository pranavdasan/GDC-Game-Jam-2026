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

var snobux : int = 200
var snow_meter : float = 0.0

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
