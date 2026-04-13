extends Button

@onready var CooldownBar : ProgressBar = $CooldownBar
@onready var CooldownTimer : Timer = $CooldownTimer

func _process(_delta: float) -> void:
	# sets cooldown bar to proportional cooldown remaining
	# sets the text of this button to also show time remaining
	if CooldownTimer.time_left != 0.0:
		CooldownBar.value = CooldownTimer.time_left / CooldownTimer.wait_time * 100
		text = "%.2f" % CooldownTimer.time_left
	else:
		CooldownBar.value = 0.0
		text = ""

# starts the cooldown timer based on ability cooldown
func start_cooldown(ability_id : int):	
	CooldownTimer.start(Global.get_ability(ability_id).cooldown)
