extends CenterContainer

func _process(delta: float) -> void:
	$ProgressBar.value = Global.snow_meter
