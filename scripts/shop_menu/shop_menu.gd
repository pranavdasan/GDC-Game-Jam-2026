extends CanvasLayer

const ABILITY_SHOP_BUTTON = preload("res://scenes/ability_shop_button.tscn")
const ABILITY_SHEET_PIXEL_WIDTH : int = Global.ABILITY_SHEET_PIXEL_WIDTH

@onready var BuyButton : Button = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/BuyButton

# ability detail nodes
@onready var NameLabel : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/NameLabel
@onready var DescriptionLabel : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DescriptionLabel
@onready var PriceLabel : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/PriceLabel
@onready var ItemIcon : TextureRect = $PanelContainer/HBoxContainer/VBoxContainer/ItemIcon

var shop_abilities : Array[Ability]
var selected_id : int = -1

#  Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#  creates a button for each type of ability
	#  later i want to change this so then it's randomly generated per shop or smth
	for ability in Global.abilities:
		var button = ABILITY_SHOP_BUTTON.instantiate()
		button.name = "Ability" + ability.ability_name
		button.text = ability.ability_name
		$PanelContainer/HBoxContainer/Shop.add_child(button)
		
		button.pressed.connect(ability_button_pressed.bind(ability.id))
		
		shop_abilities.append(ability)
	
	# sets default icons and details to first item
	NameLabel.text = "[b]Ability: [/b] " + shop_abilities[0].ability_name
	DescriptionLabel.text = "[b]Description: [/b]" + shop_abilities[0].description
	PriceLabel.text = "[b]Price:[/b] $" + str(shop_abilities[0].price)
	
	# sets ability ID for first item
	selected_id = shop_abilities[0].id
	
	# sets image for first item
	ItemIcon.texture.region.position = Vector2(
			shop_abilities[0].id % 8 * ABILITY_SHEET_PIXEL_WIDTH,
			floor(float(shop_abilities[0].id) / 8) * ABILITY_SHEET_PIXEL_WIDTH
		)
	# ^^^^^^^^^^^^^^^^^
	# x position on grid: ability_id % 8
	# y position on grid: floor(ability_id / 8)
	# 8 being the grid width (of the tilemap w/ ability images)
	# if it doesn't work blame ai i asked him how to get grid coordinates from id thing

func ability_button_pressed(ability_id : int) -> void:
	# sets details for corresponding ability
	NameLabel.text = "[b]Ability: [/b] " + Global.abilities[ability_id].ability_name
	DescriptionLabel.text = "[b]Description: [/b]" + Global.abilities[ability_id].description
	PriceLabel.text = "[b]Price:[/b] $" + str(Global.abilities[ability_id].price)
	
	# sets ability ID
	selected_id = ability_id
	
	# sets image for corresponding ability:
	# see above for how i got these
	ItemIcon.texture.region.position = Vector2(
			ability_id % 8 * ABILITY_SHEET_PIXEL_WIDTH,
			floor(float(ability_id) / 8) * ABILITY_SHEET_PIXEL_WIDTH
		)

func _on_buy_button_pressed() -> void:
	var selected_ability : Ability = Global.abilities[selected_id]
	
	# if user has enough snobux and doesn't already own ability
	if Global.snobux >= selected_ability.price and Global.owned_abilities.find(selected_ability) == -1:
		Global.set_snobux(Global.snobux - selected_ability.price)
		Global.add_owned_ability(selected_ability)
		
		# so that player knows they successfully bought
		BuyButton.modulate = Color.GREEN
	else:
		# so that player knows they did not successfully bought
		BuyButton.modulate = Color.RED

func _on_buy_button_button_up() -> void:
	# uncolors the buy button when ability is purchased/failed to purchase
	BuyButton.modulate = Color.WHITE
