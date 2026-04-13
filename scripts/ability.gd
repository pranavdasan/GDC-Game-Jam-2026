extends Node

class_name Ability

# 0.0 cooldowns means passive ability
var id : int
var ability_name: String
var description: String
var cooldown : float
var snow_cost : float
var upgradable : bool

var owned : bool = false
var ability_level : int = 0

func _init(
	p_id : int,
	p_ability_name: String,
	p_description: String,
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

func downgrade_ability_level() -> void:
	set_ability_level(ability_level - 1)
