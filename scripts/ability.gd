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

func set_ability_cooldown(new_cooldown : float) -> void:
	cooldown = new_cooldown

func set_ability_level(new_level : int) -> void:
	ability_level = new_level

func upgrade_ability_level() -> void:
	set_ability_level(ability_level + 1)
	AbilityHandler.update_ability_values()
	Global.ability_upgraded.emit()

func set_upgrade_description(_property_one = null, _property_two = null, _property_three = null, _property_four = null) -> void:
	match id:
		0:
			upgrade_description = "Increases the rate at which the user grows by " + str(AbilityHandler.GROWTH_RATE_UPGRADE_MULT) + "%.
			\nCurrent growth rate: " + str(_property_one) + "%"
		1:
			upgrade_description = "Increases jump force by " + str(AbilityHandler.JUMP_FORCE_UPGRADE_MULT) + ".
			\nCurrent jump force: " + str(_property_one) + "px/s"
		2:
			upgrade_description = "Reduces cooldown by " + str(AbilityHandler.DASH_COOLDOWN_UPGRADE_MULT) + " sec, increases damage by " + str(AbilityHandler.BULLET_DAMAGE_UPGRADE_MULT) + ".
			\nCurrent cooldown: " + str(_property_one) + " sec
			\nCurrent damage: " + str(_property_two) + " damage"
		3:
			pass
		4:
			upgrade_description = "Reduces cooldown by " + str(AbilityHandler.DASH_COOLDOWN_UPGRADE_MULT) + " sec, increases dash force by " + str(AbilityHandler.DASH_SPEED_UPGRADE_MULT) + "px/s.
			\nCurrent cooldown: " + str(_property_one) + " sec
			\nCurrent dash force: " + str(_property_two) + "px/s"
