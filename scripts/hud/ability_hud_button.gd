extends Button

@onready var cooldown_bar : ProgressBar = $cooldown_bar
@onready var cooldown_timer : Timer = $cooldown_timer

func _process(delta: float) -> void:
	# sets cooldown bar to proportional cooldown remaining
	if cooldown_timer.time_left != 0.0:
		cooldown_bar.value = cooldown_timer.time_left / cooldown_timer.wait_time * 100
	else:
		cooldown_bar.value = 0.0

# starts the cooldown timer based on ability cooldown
func use_ability(ability_id : int):	
	cooldown_timer.start(Global.abilities[ability_id].cooldown)
