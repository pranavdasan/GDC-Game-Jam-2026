extends Node

class_name Ability

# 0.0 cooldowns means passive ability
var id : int
var ability_name : String
var description : String
var upgrade_description : String
var cooldown : float
var snow_cost : float
var upgradable : bool

var owned : bool = false
var ability_level : int = 0

func _init(
	p_id : int,
	p_ability_name : String,
	p_description : String,
	p_cooldown : float,
	p_snow_cost : float,
	p_upgradable : bool
) -> void:
	id = p_id
	ability_name = p_ability_name
	description = p_description
	cooldown = p_cooldown
	snow_cost = p_snow_cost
	upgradable = p_upgradable

func set_ability_level(new_level : int) -> void:
	ability_level = new_level

func upgrade_ability_level() -> void:
	set_ability_level(ability_level + 1)
	Global.ability_upgraded.emit()

func set_upgrade_description(_property_one = null, _property_two = null, _property_three = null, _property_four = null) -> void:
	match id:
		0:
			upgrade_description = "Increases the rate at which the user grows
			\nCurrent growth rate: " + str(_property_one) + "%"
		1:
			upgrade_description = "Increases jump force.
			\nCurrent jump force: " + str(_property_one) + "px/s"
		2:
			upgrade_description = "Reduces cooldown by " + str(_property_one) + " sec, increases damage.
			\nCurrent cooldown: " + str(_property_two) + " sec
			\nCurrent damage: " + str(_property_three) + " damage"
		3:
			upgrade_description = "Reduces cooldown by " + str(_property_one) + " sec, increases dash force by " + str(_property_two) + "px/s.
			\nCurrent cooldown: " + str(_property_three) + " sec
			\nCurrent dash force: " + str(_property_four) + "px/s"
		4:
			upgrade_description = "dash"
