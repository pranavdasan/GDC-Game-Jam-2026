extends Node

class_name Ability

# 0.0 cooldowns means passive ability

var ability_name: String
var description: String
var cooldown : float
var snow_cost : float
var id : int

func _init(
		p_ability_name: String,
		p_description: String,
		p_cooldown : float,
		p_snow_cost : float,
		p_id : int
		):
	ability_name = p_ability_name
	description = p_description
	cooldown = p_cooldown
	snow_cost = p_snow_cost
	id = p_id
