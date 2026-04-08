extends Button

@onready var cooldown_bar : ProgressBar = $cooldown_bar
@onready var cooldown_timer : Timer = $cooldown_timer

func _process(delta: float) -> void:
	# sets cooldown bar to proportional cooldown remaining
	# sets the text of this button to also show time remaining
	if cooldown_timer.time_left != 0.0:
		cooldown_bar.value = cooldown_timer.time_left / cooldown_timer.wait_time * 100
		text = "%.2f" % cooldown_timer.time_left
	else:
		cooldown_bar.value = 0.0
		text = ""

# starts the cooldown timer based on ability cooldown
func start_cooldown(ability_id : int):	
	cooldown_timer.start(Global.abilities[ability_id].cooldown)
