extends CenterContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.text = "[b]$" + str(Global.snobux)
