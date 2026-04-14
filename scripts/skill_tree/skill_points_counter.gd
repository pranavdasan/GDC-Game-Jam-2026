extends RichTextLabel

func _ready() -> void:
	#to set the first value
	on_skill_points_changed()
	
	Global.skill_points_changed.connect(on_skill_points_changed)

func on_skill_points_changed() -> void:
	text = "[b]" + str(Global.skill_points) + "SP"
