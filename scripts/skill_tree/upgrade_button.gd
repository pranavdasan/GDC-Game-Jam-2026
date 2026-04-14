extends Button

@onready var SkillTree : CanvasLayer = $"../../../../../.."

const MAX_UPGRADE_LEVEL : int = Global.MAX_ABILITY_LEVEL

func _ready() -> void:
	SkillTree.focus_changed.connect(refresh_status)
	Global.owned_abilities_added.connect(refresh_status)

func _on_pressed() -> void:
	var FocusedAbility : Ability = Global.get_ability(SkillTree.focused_ability_id)
	
	if (Global.skill_points >= 1):
		FocusedAbility.upgrade_ability_level()
		Global.subtract_skill_points(1)
		
		self.modulate = Color.GREEN

func _on_button_up() -> void:
	await get_tree().create_timer(Global.BUTTON_MODULATE_WAIT_TIME).timeout
	
	self.modulate = Color.WHITE

func refresh_status() -> void:
	var FocusedAbility : Ability = Global.get_ability(SkillTree.focused_ability_id)
	
	if (
		FocusedAbility.owned and
		FocusedAbility.upgradable and
		FocusedAbility.ability_level < MAX_UPGRADE_LEVEL and
		Global.skill_points >= 1
	):
		disabled = false
	else:
		disabled = true
