extends RichTextLabel

func _ready() -> void:
	#to set the first value
	on_snobux_changed()
	
	Global.snobux_changed.connect(on_snobux_changed)

func on_snobux_changed() -> void:
	text = "[b]$" + str(Global.snobux)
