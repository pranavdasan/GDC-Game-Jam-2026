extends Node

@export var focused : bool = false
@export var ability_id : int
@export var parent_button : Button = null

@onready var SkillTree : CanvasLayer = $"../../../../.."

@onready var AbilityLevelBar : ProgressBar = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/AbilityLevelBar"

@onready var NameLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/NameLabel"
@onready var CooldownLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/CooldownLabel"
@onready var DescriptionLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/DescriptionLabel"

@onready var Outline : ColorRect = $Outline
@onready var Lock : TextureRect = $Lock

func _ready() -> void:
	# the first button is focused by default
	if ability_id == 0:
		self.visible = true
		
		focus_details()
	else:
		self.visible = false
	
	Global.owned_abilities_added.connect(on_owned_abilities_added)

func _on_pressed() -> void:
	if not focused:
		focus_details()

## focuses on called AbilityButton's details, setting all labels to the respective ability's details
func focus_details() -> void:
	SkillTree.focused_ability_id = ability_id
	SkillTree.reset_ability_button_focus()
	focused = true
	
	Outline.visible = true
	
	NameLabel.text = "[b]Name: [/b]" + Global.get_ability(ability_id).ability_name
	if Global.get_ability(ability_id).cooldown == 0:
		CooldownLabel.text = "[b]Cooldown: [/b]Passive Ability"
	else:
		CooldownLabel.text = "[b]Cooldown: [/b]" + str(Global.get_ability(ability_id).cooldown) + " seconds"
	DescriptionLabel.text = "[b]Description: [/b]" + Global.get_ability(ability_id).description

## every time a new ability is bought: checks if its parent has been bought and if so becomes visible, checks if itself is bought and if so makes lock invisible
func on_owned_abilities_added():
	if parent_button:
		if Global.get_ability(parent_button.ability_id).owned:
			self.visible = true
	
	if Global.get_ability(ability_id).owned:
		Lock.visible = false
