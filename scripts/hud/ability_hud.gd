extends HBoxContainer

const ability_hud_button = preload("res://scenes/ability_hud_button.tscn")
const ability_sheet_pixel_width : int = Global.ability_sheet_pixel_width

signal ability_button_pressed(ability_id : int)

# array of ints
# each one corresponding to the ability ID of a created ability button
var created_ability_button_ids : Array[int]

func _ready() -> void:
	Global.owned_abilities_added.connect(on_owned_abilities_added)

func on_owned_abilities_added() -> void:
	# creates a new button for each unowned ability
	for ability in Global.owned_abilities:
		#makes sure that a button for this ability id has not already been created
		if created_ability_button_ids.find(ability.id) == -1:
			created_ability_button_ids.append(ability.id)
			
			var ability_button : Button = ability_hud_button.instantiate()
			# \/ apparently i have to make this a unique reference to this property
			ability_button.icon = ability_button.icon.duplicate()
			
			ability_button.name = ability.ability_name
			
			# see shop_menu for what does this mean
			ability_button.icon.region.position = Vector2(
				int(ability.id) % 8 * ability_sheet_pixel_width,
				floor(float(ability.id) / 8) * ability_sheet_pixel_width
			)
			
			add_child(ability_button)
			
			# pressed event for every button that passes the ability id (for ability_handler)
			ability_button.pressed.connect(on_ability_button_pressed.bind(ability.id))

func on_ability_button_pressed(ability_id : int) -> void:
	ability_button_pressed.emit(ability_id)
