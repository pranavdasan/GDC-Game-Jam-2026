extends Node

@export var focused : bool = false
@export var owned : bool = false
@export var ability_id : int
@export var upgrade_level : int = 0
@export var parent_button : Button = null

@onready var SkillTree : CanvasLayer = $"../../../../.."

@onready var NameLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/NameLabel"
@onready var CooldownLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/CooldownLabel"
@onready var DescriptionLabel : RichTextLabel = $"../../../../DetailsContainer/ScrollContainer/VBoxContainer/DescriptionLabel"

@onready var Outline : ColorRect = $Outline

func _ready() -> void:
	if ability_id == 0:
		self.visible = true
		
		focus_details()
	else:
		self.visible = false
	
	Global.owned_abilities_added.connect(on_owned_abilities_added)

func _on_pressed() -> void:
	if not focused:
		focus_details()
	else:
		buy_ability()

func focus_details() -> void:
	SkillTree.reset_ability_button_focus()
	focused = true
	
	Outline.visible = true
	
	NameLabel.text = "[b]Name: [/b]" + Global.abilities[ability_id].ability_name
	if Global.abilities[ability_id].cooldown == 0:
		CooldownLabel.text = "[b]Cooldown: [/b]Passive Ability"
	else:
		CooldownLabel.text = "[b]Cooldown: [/b]" + str(Global.abilities[ability_id].cooldown) + " seconds"
	DescriptionLabel.text = "[b]Description: [/b]" + Global.abilities[ability_id].description

func buy_ability() -> void:	
	if Global.skill_points >= 1 and not Global.is_ability_owned(ability_id):
		owned = true
		
		Global.subtract_skill_points(1)
		Global.add_owned_ability(ability_id)
		
		# so that player knows they successfully bought
		self.modulate = Color.GREEN
	else:
		self.modulate = Color.RED

func _on_button_up() -> void:
	await get_tree().create_timer(0.5).timeout
	
	self.modulate = Color.WHITE

func upgrade() -> void:
	upgrade_level += 1

func on_owned_abilities_added():
	if parent_button:
		if parent_button.owned:
			self.visible = true
