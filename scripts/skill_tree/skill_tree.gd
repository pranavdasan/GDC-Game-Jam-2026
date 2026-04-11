extends CanvasLayer

const ABILITY_SHEET_PIXEL_WIDTH = Global.ABILITY_SHEET_PIXEL_WIDTH
const AbilityButtonSkillTree = preload("res://scenes/ability_button_skill_tree.tscn")

@onready var TreeContainer : VBoxContainer = $PanelContainer/TreeScrollContainer/TreeContainer
@onready var TreeScrollContainer : ScrollContainer = $PanelContainer/TreeScrollContainer

var AbilityButtonZero : Button = AbilityButtonSkillTree.instantiate()
var AbilityButtonOne : Button = AbilityButtonSkillTree.instantiate()
var AbilityButtonTwo : Button = AbilityButtonSkillTree.instantiate()
var AbilityButtonThree : Button = AbilityButtonSkillTree.instantiate()
var AbilityButtonFour : Button = AbilityButtonSkillTree.instantiate()

var ability_buttons = [
	AbilityButtonZero,
	AbilityButtonOne,
	AbilityButtonTwo,
	AbilityButtonThree,
	AbilityButtonFour
]

var tree_structure : Dictionary[Button, Dictionary] = {
	AbilityButtonZero : {
		AbilityButtonOne : {
			AbilityButtonThree : {},
			AbilityButtonFour : {}
		},
		AbilityButtonTwo : {}
	}
}

@export var tree_position_connections : Array[Array]
var layer_index : int = -1

func _ready() -> void:
	visible = false
	
	Global.owned_abilities_added.connect(on_owned_abilities_added)
	
	# sets the initial properties for each button
	for ability_button_index in ability_buttons.size():
		var AbilityButton : Button = ability_buttons[ability_button_index]
		AbilityButton.name = "AbilityButton" + str(ability_button_index)
		AbilityButton.ability_id = ability_button_index
		AbilityButton.icon = AbilityButton.icon.duplicate()
		AbilityButton.icon.region.position = Vector2(
				int(AbilityButton.ability_id) % 8 * ABILITY_SHEET_PIXEL_WIDTH,
				floor(float(AbilityButton.ability_id) / 8) * ABILITY_SHEET_PIXEL_WIDTH
			)
	
	generate_tree_structure(null, tree_structure)

func _input(event) -> void:
	if event.is_action_pressed("open_skill_tree"):
		redraw_tree_connections()
		
		visible = not visible

func generate_tree_structure(ParentButton, current_layer_dict : Dictionary):
	layer_index += 1
	
	var LayerBox : HBoxContainer = HBoxContainer.new()
	LayerBox.alignment = BoxContainer.ALIGNMENT_CENTER
	LayerBox.theme = load("res://themes/theme.tres")
	LayerBox.theme_type_variation = "skill_tree_layer_box"
	LayerBox.name = "Layer" + str(layer_index)
	
	TreeContainer.add_child(LayerBox)
	
	for ability_button_index in current_layer_dict.keys().size():
		var ChildButton : Button = current_layer_dict.keys()[ability_button_index]
		
		LayerBox.add_child(ChildButton)
		
		if ParentButton:
			ChildButton.parent_button = ParentButton
		
		generate_tree_structure(ChildButton, current_layer_dict.values()[ability_button_index])

func redraw_tree_connections() -> void:
	tree_position_connections.clear()
	
	for AbilityButton in ability_buttons:
		await get_tree().physics_frame
		
		if not AbilityButton.visible:
			continue
		
		var ParentAbilityButton = AbilityButton.parent_button
		
		if ParentAbilityButton:
			# relative to TreeScrollContainer
			var parent_relative_position : Vector2 = ParentAbilityButton.global_position - TreeScrollContainer.global_position
			var child_relative_position : Vector2 = AbilityButton.global_position - TreeScrollContainer.global_position
			
			tree_position_connections.append([
				parent_relative_position + ParentAbilityButton.size / 2,
				child_relative_position + AbilityButton.size / 2
			])

func reset_ability_button_focus() -> void:
	for AbilityButton : Button in ability_buttons:
		AbilityButton.focused = false
		AbilityButton.get_child(0).visible = false

func on_owned_abilities_added() -> void:
	redraw_tree_connections()
