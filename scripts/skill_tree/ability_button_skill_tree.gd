extends Node

@export var focused : bool = false
@export var ability_id : int
@export var parent_button : Button = null

@onready var SkillTree : CanvasLayer = $"../../../../.."

@onready var AbilityLevelBar : ProgressBar = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/AbilityLevelBar"
@onready var AbilityLevelLabel : Label = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/AbilityLevelBar/AbilityLevelLabel"

@onready var NameLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/NameLabel"
@onready var CooldownLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/CooldownLabel"
@onready var DescriptionLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/DescriptionLabel"
@onready var UpgradeDescriptionLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/UpgradeDescriptionLabel"

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
	
	AbilityLevelBar.value = FocusedAbility.ability_level
	if FocusedAbility.upgradable:
		AbilityLevelLabel.text = "ABILITY LEVEL: " + str(FocusedAbility.ability_level)
	else:
		AbilityLevelLabel.text = "NOT UPGRADEABLE"
	
	NameLabel.text = "[b]Name: [/b]" + FocusedAbility.ability_name
	if Global.get_ability(ability_id).cooldown == 0:
		CooldownLabel.text = "[b]Cooldown: [/b]Passive Ability"
	else:
		CooldownLabel.text = "[b]Cooldown: [/b]" + str(FocusedAbility.cooldown) + " seconds"
	DescriptionLabel.text = "[b]Description: [/b]" + FocusedAbility.description
	if not FocusedAbility.upgradable or FocusedAbility.upgrade_description == "":
		UpgradeDescriptionLabel.text = "[b]When Upgraded:[/b] NOT UPGRADABLE"
	else:
		match FocusedAbility.id:
			0:
				FocusedAbility.set_upgrade_description(AbilityHandler.current_growth_rate)
			1:
				FocusedAbility.set_upgrade_description(AbilityHandler.current_jump_force)
			2:
				FocusedAbility.set_upgrade_description(AbilityHandler.current_bullet_cooldown, AbilityHandler.current_bullet_damage)
			4:
				FocusedAbility.set_upgrade_description(AbilityHandler.current_dash_cooldown, AbilityHandler.current_dash_speed)
		
		UpgradeDescriptionLabel.text = "[b]When Upgraded:[/b]" + FocusedAbility.upgrade_description

## every time a new ability is bought: checks if its parent has been bought and if so becomes visible, checks if itself is bought and if so makes lock invisible
func on_owned_abilities_added():
	if parent_button:
		if Global.get_ability(parent_button.ability_id).owned:
			self.visible = true
	
	if Global.get_ability(ability_id).owned:
		Lock.visible = false

func on_ability_upgraded():
	if focused:
		focus_details()
