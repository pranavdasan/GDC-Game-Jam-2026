extends HBoxContainer

const ABILITY_HUD_BUTTON = preload("res://scenes/ability_button_hud.tscn")
const ABILITY_SHEET_PIXEL_WIDTH : int = Global.ABILITY_SHEET_PIXEL_WIDTH

signal ability_button_pressed(ability_id : int)

# array of ints
# each one corresponding to the ability ID of a created ability button
var created_ability_button_ids : Array[int]

func _ready() -> void:
	Global.owned_abilities_added.connect(on_owned_abilities_added)

func on_owned_abilities_added() -> void:
	for ability in Global.abilities:
		# makes sure that:
		# a button for this ability id has not already been created
		# ability is owned
		# ability is not passive
		if created_ability_button_ids.find(ability.id) == -1 and ability.owned and ability.cooldown != 0.0:
			created_ability_button_ids.append(ability.id)
			
			var AbilityButton : Button = ABILITY_HUD_BUTTON.instantiate()
			# apparently i have to make this a unique reference to this property
			AbilityButton.icon = AbilityButton.icon.duplicate()
			
			AbilityButton.name = "Ability" + ability.ability_name
			
			# see shop_menu for what does this mean
			AbilityButton.icon.region.position = Vector2(
				int(ability.id) % 8 * ABILITY_SHEET_PIXEL_WIDTH,
				floor(float(ability.id) / 8) * ABILITY_SHEET_PIXEL_WIDTH
			)
			
			add_child(AbilityButton)
			
			# pressed event for every button that passes the ability id (for ability_handler)
			AbilityButton.pressed.connect(on_ability_button_pressed.bind(ability.id))

func on_ability_button_pressed(ability_id : int) -> void:
	ability_button_pressed.emit(ability_id)
