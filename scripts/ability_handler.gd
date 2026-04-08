extends Node

@onready var ability_hud : HBoxContainer = get_node("/root/main/hud/ability_hud")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ability_hud.ability_button_pressed.connect(on_ability_button_pressed)

func on_ability_button_pressed(ability_id : int) -> void:
	use_ability(ability_id)

func _input(event) -> void:
	# checks that pressed key is a number key 0-9
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_0 and event.keycode <= KEY_9:
			# this is the int version of key pressed
			var ability_button_index : int = event.keycode - KEY_0
			
			# if it's zero it's actually 10 (the tenth number key)
			if ability_button_index == 0:
				ability_button_index = 10
			
			# checks that this button actually has a created ability
			if ability_button_index <= ability_hud.created_ability_button_ids.size():
				# finds the ability id of this created ability button
				var ability_id : int = ability_hud.created_ability_button_ids[ability_button_index - 1]
				use_ability(ability_id)

func use_ability(ability_id : int) -> void:
	# gets the real ability button node for used ability
	var ability_button_index : int = ability_hud.created_ability_button_ids.find(ability_id)
	var ability_button : Button = ability_hud.get_children()[ability_button_index]
	
	# to make sure the ability is not on cooldown
	if ability_button.cooldown_timer.time_left == 0.0:
		# starts cooldown for that ability
		ability_button.use_ability(ability_id)
		
		# actual code for the ability
		match ability_id:
			0:
				pass
			1:
				pass
			2:
				pass
