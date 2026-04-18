extends Node

@export var focused : bool = false
@export var ability_id : int
@export var parent_button : Button = null

@onready var SkillTree : CanvasLayer = $"../../../../.."

@onready var StatsContainer : FoldableContainer = $"../../../../StatsContainer"

@onready var AbilityLevelBar : ProgressBar = $"../../../../StatsContainer/ScrollContainer/VBoxContainer/AbilityLevelBar"
@onready var AbilityLevelLabel : Label = $"../../../../StatsContainer/ScrollContainer/VBoxContainer/AbilityLevelBar/AbilityLevelLabel"

@onready var NameLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/NameLabel"
@onready var DescriptionLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/DescriptionLabel"

@onready var UpgradeDescriptionLabel : RichTextLabel = $"../../../../StatsContainer/ScrollContainer/VBoxContainer/UpgradeDescriptionLabel"
@onready var CooldownLabel : RichTextLabel = $"../../../../StatsContainer/ScrollContainer/VBoxContainer/CooldownLabel"

@onready var StatLabel0 : RichTextLabel = $"../../../../StatsContainer/ScrollContainer/VBoxContainer/StatLabel0"
@onready var StatLabel1 : RichTextLabel = $"../../../../StatsContainer/ScrollContainer/VBoxContainer/StatLabel1"

var stat_labels : Array[RichTextLabel]

@onready var Outline : ColorRect = $Outline
@onready var Lock : TextureRect = $Lock

func _ready() -> void:
	# the first button is focused by default
	if ability_id == 0:
		self.visible = true
		
		focus_details()
	else:
		self.visible = false
	
	stat_labels = [
		StatLabel0,
		StatLabel1
	]
	
	Global.owned_abilities_added.connect(on_owned_abilities_added)
	Global.ability_upgraded.connect(on_ability_upgraded)

func _on_pressed() -> void:
	if not focused:
		focus_details()

## focuses on called AbilityButton's details, setting all labels to the respective ability's details
func focus_details() -> void:
	SkillTree.focused_ability_id = ability_id
	SkillTree.reset_ability_button_focus()
	
	focused = true
	Outline.visible = true
	
	var FocusedAbility : Ability = Global.get_ability(ability_id)
	
	# name, is the name of the ability
	NameLabel.text = "[b]Name: [/b]" + FocusedAbility.ability_name
	
	# description, describes the ability
	DescriptionLabel.text = "[b]Description: [/b]" + FocusedAbility.description
	
	# upgrade level bar and label, shows the level of the ability in a progress bar and a number
	AbilityLevelBar.value = FocusedAbility.ability_level
	if FocusedAbility.upgradable:
		AbilityLevelLabel.text = "ABILITY LEVEL: " + str(FocusedAbility.ability_level)
	else:
		AbilityLevelLabel.text = "NOT UPGRADEABLE"
	
	# upgrade description, describes what upgrading ability does
	if not FocusedAbility.upgradable or FocusedAbility.upgrade_description == "":
		UpgradeDescriptionLabel.text = "[b]When Upgraded:[/b] NOT UPGRADABLE"
	else:
		UpgradeDescriptionLabel.text = "[b]When Upgraded: [/b]" + FocusedAbility.upgrade_description
	
	# stats, starting w/ cooldown
	if Global.get_ability(ability_id).cooldown == 0:
		CooldownLabel.text = "[b]Cooldown: [/b]Passive Ability"
	else:
		CooldownLabel.text = "[b]Cooldown: [/b]" + str(FocusedAbility.cooldown) + " seconds"
	
	for stat_label_index in stat_labels.size():
		var StatLabel : RichTextLabel = stat_labels[stat_label_index]
		StatLabel.visible = true
		
		if stat_label_index > FocusedAbility.stats.size() - 1:
			StatLabel.visible = false
			continue
		
		var stat_name : String = FocusedAbility.stats.keys()[stat_label_index]
		var stat_value = FocusedAbility.stats[stat_name][0]
		var stat_unit = FocusedAbility.stats[stat_name][1]
		
		# turns snake case to human form, eg "growth_rate" to "Growth Rate"
		stat_name = stat_name.replace("_", " ").capitalize()
		
		StatLabel.text = "[b]" + str(stat_name) + ": [/b]" + str(stat_value) + " " + stat_unit

## every time a new ability is bought: checks if its parent has been bought and if so becomes visible + checks if itself is bought and if so makes lock invisible
func on_owned_abilities_added():
	if parent_button:
		if Global.get_ability(parent_button.ability_id).owned:
			self.visible = true
	
	if Global.get_ability(ability_id).owned:
		Lock.visible = false

func on_ability_upgraded():
	if focused:
		focus_details()
