extends Button

@onready var SkillTree : CanvasLayer = $"../../../../../.."

func _on_pressed() -> void:
	if Global.skill_points >= 1 and not Global.get_ability(SkillTree.focused_ability_id).owned:
		Global.subtract_skill_points(1)
		Global.unlock_ability(SkillTree.focused_ability_id)
		
		# so that player knows they successfully bought
		self.modulate = Color.GREEN
	else:
		self.modulate = Color.RED

func _on_button_up() -> void:
	await get_tree().create_timer(Global.BUTTON_MODULATE_WAIT_TIME).timeout
	
	self.modulate = Color.WHITE
