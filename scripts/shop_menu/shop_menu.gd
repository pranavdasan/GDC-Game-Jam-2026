extends CanvasLayer

const spriteSheetWidth : int = 32

var abilities : Array[Ability] = Global.abilities

var item_buttons : Array[Button] = []

@onready var buy_button : Button = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/buy_button

#ability detail nodes
@onready var name_label : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/name_label
@onready var description_label : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/description_label
@onready var price_label : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/price_label
@onready var item_icon : TextureRect = $PanelContainer/HBoxContainer/VBoxContainer/item_icon

var selected_ability_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in abilities.size():
		var button : Button = Button.new()
		button.autowrap_mode = TextServer.AUTOWRAP_WORD
		button.name = abilities[i].ability_name
		button.text = abilities[i].ability_name
		
		button.pressed.connect(button_pressed.bind(i))
		
		item_buttons.append(button)
		
		$PanelContainer/HBoxContainer/Shop.add_child(button)
	
	#default ability is set to the button w/ index 0
	name_label.text = "[b]Ability: [/b] " + abilities[0].ability_name
	description_label.text = "[b]Description: [/b]" + abilities[0].description
	price_label.text = "[b]Price:[/b] $" + str(abilities[0].price)
	
	selected_ability_index = 0
	
	item_icon.texture.region.position = Vector2(0,0)

func button_pressed(button_index : int):
	name_label.text = "[b]Ability: [/b] " + abilities[button_index].ability_name
	description_label.text = "[b]Description: [/b]" + abilities[button_index].description
	price_label.text = "[b]Price:[/b] $" + str(abilities[button_index].price)
	
	selected_ability_index = button_index
	
	#x position on grid: button_index % 8
	#y position on grid: floor(button_index / 8)
	#8 being the grid width
	item_icon.texture.region.position = Vector2(button_index % 8 * spriteSheetWidth,floor(float(button_index) / 8) * spriteSheetWidth)

func _on_buy_button_pressed() -> void:
	var selected_ability : Ability = abilities[selected_ability_index]
	if Global.snobux >= selected_ability.price and Global.owned_abilities.find(selected_ability) == -1:
		Global.snobux -= selected_ability.price
		Global.owned_abilities.append(selected_ability)
		#show user they bought it
	else:
		pass #show user that they cant buy
