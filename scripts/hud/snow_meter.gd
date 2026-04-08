extends ProgressBar

func _ready() -> void:
	#to set the first value
	on_snow_meter_changed()
	
	Global.snow_meter_changed.connect(on_snow_meter_changed)

func on_snow_meter_changed() -> void:
	self.value = Global.snow_meter
