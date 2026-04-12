extends Button

@onready var SkillTree : CanvasLayer = $"../../../../../.."

func _on_pressed() -> void:
	if Global.skill_points >= 1 and not Global.is_ability_owned(SkillTree.focused_ability_id):		
		Global.subtract_skill_points(1)
		Global.add_owned_ability(SkillTree.focused_ability_id)
		
		# so that player knows they successfully bought
		self.modulate = Color.GREEN
	else:
		self.modulate = Color.RED

func _on_button_up() -> void:
	await get_tree().create_timer(0.5).timeout
	
	self.modulate = Color.WHITE
