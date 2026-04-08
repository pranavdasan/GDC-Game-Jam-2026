extends Node

class_name Ability

var ability_name: String
var description: String
var price: int
var id : int

func _init(p_ability_name: String, p_description: String, p_price: int, p_id):
	ability_name = p_ability_name
	description = p_description
	price = p_price
	id = p_id
