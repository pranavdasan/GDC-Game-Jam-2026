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

## "stat_name" : [stat_value, "unit"]
var stats : Dictionary[String, Array] = {}

func _init(
	p_id : int,
	p_ability_name : String,
	p_description : String,
	p_upgrade_description : String,
	p_cooldown : float,
	p_snow_cost : float,
	p_upgradable : bool
) -> void:
	id = p_id
	ability_name = p_ability_name
	description = p_description
	upgrade_description = p_upgrade_description
	cooldown = p_cooldown
	snow_cost = p_snow_cost
	upgradable = p_upgradable
	
	match id:
		0:
			stats["growth_rate"] = [AbilityHandler.BASE_GROWTH_RATE, "%"]
		1:
			pass # not upgradeable
		2:
			stats["bullet_damage"] = [AbilityHandler.BASE_BULLET_DAMAGE, "damage"]
		3:
			stats["punch_damage"] = [AbilityHandler.BASE_PUNCH_DAMAGE, "damage"]
		4:
			stats["dash_speed"] = [AbilityHandler.BASE_DASH_SPEED, "px/s"]


func set_ability_cooldown(new_cooldown : float) -> void:
	cooldown = new_cooldown

func set_ability_level(new_level : int) -> void:
	ability_level = new_level

func upgrade_ability_level() -> void:
	set_ability_level(ability_level + 1)
	AbilityHandler.update_ability_values()
	Global.ability_upgraded.emit()
