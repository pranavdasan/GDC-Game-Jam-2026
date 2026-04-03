extends CenterContainer

var abilities : Array[Ability] = [
	Ability.new(
	"Dash",
	"Allows the user to rapidly move in a certain direction at the cost of some snow",
	50.0),
	Ability.new(
	"Snow Jetpack",
	"Boost upwards at a high speed at the cost of some snow",
	100.0)
]

var item_buttons : Array[Button] = []

@onready var name_label : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/name_label
@onready var description_label : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/description_label
@onready var price_label : RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/price_label

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

func button_pressed(button_index : int):
	name_label.text = "[b]Ability: [/b] " + abilities[button_index].ability_name
	description_label.text = "[b]Description: [/b]" + abilities[button_index].description
	price_label.text = "[b]Price:[/b] $" + str(abilities[button_index].price)

#func _on_item_0_pressed() -> void:
	#name_label.text = "[b]Ability: [/b] " + abilities[0].ability_name
	#description_label.text = "[b]Description: [/b]" + abilities[0].description
	#price_label.text = "[b]Price:[/b] $" + str(abilities[0].price)
