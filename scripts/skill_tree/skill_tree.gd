extends CanvasLayer

const ABILITY_SHEET_PIXEL_WIDTH = Global.ABILITY_SHEET_PIXEL_WIDTH
const AbilityButtonSkillTree = preload("res://scenes/ui/ability_button_skill_tree.tscn")

@onready var TreeContainer : VBoxContainer = $PanelContainer/TreeScrollContainer/TreeContainer
@onready var TreeScrollContainer : ScrollContainer = $PanelContainer/TreeScrollContainer

# WHENEVER YOU WANT TO ADD A NEW ABILITY TO SHOP + INSTANTIATE IT HERE AND THEN:
## grow ability
var AbilityButtonZero : Button = AbilityButtonSkillTree.instantiate()
## jump ability
var AbilityButtonOne : Button = AbilityButtonSkillTree.instantiate()
## snow bullet
var AbilityButtonTwo : Button = AbilityButtonSkillTree.instantiate()
## snow punch
var AbilityButtonThree : Button = AbilityButtonSkillTree.instantiate()
## dash
var AbilityButtonFour : Button = AbilityButtonSkillTree.instantiate()
## crushing roll
var AbilityButtonFive : Button = AbilityButtonSkillTree.instantiate()

# ADD IT TO THIS LIST
@export var ability_buttons = [
	AbilityButtonZero,
	AbilityButtonOne,
	AbilityButtonTwo,
	AbilityButtonThree,
	AbilityButtonFour,
	AbilityButtonFive
]

# \/ EDIT THIS DICT HERE FOR ADDING/REMOVING TREE ITEMS \/
var tree_structure : Dictionary[Button, Dictionary] = {
	AbilityButtonZero : {
		AbilityButtonOne : {
			AbilityButtonFour : {}
		},
		AbilityButtonFive : {
			AbilityButtonTwo : {},
			AbilityButtonThree : {}
		}
	}
}

signal focus_changed()

# list of all the connections that need to be drawn in the skill tree
@export var tree_position_connections : Array[Array]

@export var focused_ability_id : int

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
	
	generate_tree_structure(null, 0, tree_structure)
	
	var LayerBlank1 : HBoxContainer = HBoxContainer.new()
	LayerBlank1.custom_minimum_size.y = 150
	LayerBlank1.name = "LayerBlank1"
	TreeContainer.add_child(LayerBlank1)

func _process(_delta : float) -> void:
	reset_tree_connections()

func _input(event) -> void:
	if event.is_action_pressed("open_skill_tree"):
		reset_tree_connections()
		
		visible = not visible

## recursive function that generates formatted boxes for trees
func generate_tree_structure(ParentButton : Button, current_depth : int, current_layer_dict : Dictionary):
	var LayerBox : HBoxContainer
	
	LayerBox = TreeContainer.get_node_or_null("Layer" + str(current_depth))
	
	# creates a new HBoxContainer "layer" if it doesn't already exist
	if LayerBox == null:
		LayerBox = HBoxContainer.new()
		LayerBox.alignment = BoxContainer.ALIGNMENT_CENTER
		LayerBox.theme = load("res://themes/theme.tres")
		LayerBox.theme_type_variation = "skill_tree_layer_box"
		LayerBox.name = "Layer" + str(current_depth)
		
		TreeContainer.add_child(LayerBox)
	
	# makes a button for each child button of the one that called this function
	# and makes each child node call this function setting itself as the parent node (recursive)
	# first pass - adds all buttons at this depth
	for ChildButton in current_layer_dict.keys():
		LayerBox.add_child(ChildButton)
		
		# the first layer has no parent so there's not always parent button
		if ParentButton:
			ChildButton.parent_button = ParentButton
		
		# only recurse if there are children (as to not create empty boxes)
		if not current_layer_dict[ChildButton].is_empty():
			generate_tree_structure(ChildButton, current_depth + 1, current_layer_dict[ChildButton])

func reset_tree_connections() -> void:
	tree_position_connections.clear()
	
	for AbilityButton in ability_buttons:
		var ParentAbilityButton = AbilityButton.parent_button
		
		if ParentAbilityButton:
			# relative to TreeScrollContainer
			var parent_relative_position : Vector2 = ParentAbilityButton.global_position - TreeScrollContainer.global_position
			var child_relative_position : Vector2 = AbilityButton.global_position - TreeScrollContainer.global_position
			
			# if the parent or child is out of view, then don't draw this connection
			if (
				not AbilityButton.visible or
				child_relative_position.y > TreeScrollContainer.size.y or 
				parent_relative_position.y + ParentAbilityButton.size.y < 0
			):
				continue
			
			# add connection of the CENTER of each button (since godot tracks from top left)
			tree_position_connections.append([
				parent_relative_position + ParentAbilityButton.size / 2,
				child_relative_position + AbilityButton.size / 2
			])

# sets all ability buttons' focus to false
func reset_ability_button_focus() -> void:
	focus_changed.emit()
	
	for AbilityButton : Button in ability_buttons:
		AbilityButton.focused = false
		AbilityButton.get_child(0).visible = false

func on_owned_abilities_added() -> void:
	reset_tree_connections()
