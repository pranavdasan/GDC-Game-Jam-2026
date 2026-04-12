extends Button

@onready var SkillTree : CanvasLayer = $"../../../../../.."

func _ready() -> void:
	SkillTree.focus_changed.connect(refresh_status)
	Global.owned_abilities_added.connect(refresh_status)

func _on_pressed() -> void:
	pass

func _on_button_up() -> void:
	pass

func refresh_status() -> void:
	if Global.is_ability_owned(SkillTree.focused_ability_id) and Global.abilities[SkillTree.focused_ability_id].upgradable:
		disabled = false
	else:
		disabled = true
