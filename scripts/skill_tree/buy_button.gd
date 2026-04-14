extends Button

@onready var SkillTree : CanvasLayer = $"../../../../../.."

func _ready() -> void:
	SkillTree.focus_changed.connect(refresh_status)
	Global.owned_abilities_added.connect(refresh_status)

func _on_pressed() -> void:
	Global.subtract_skill_points(1)
	Global.unlock_ability(SkillTree.focused_ability_id)
	
	# so that player knows they successfully bought
	self.modulate = Color.GREEN

func _on_button_up() -> void:
	await get_tree().create_timer(Global.BUTTON_MODULATE_WAIT_TIME).timeout
	
	self.modulate = Color.WHITE

func refresh_status() -> void:
	var FocusedAbility : Ability = Global.get_ability(SkillTree.focused_ability_id)
	
	if (
		not FocusedAbility.owned and
		Global.skill_points >= 1
	):
		disabled = false
	else:
		disabled = true
