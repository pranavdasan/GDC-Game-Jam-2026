extends Control
class_name HealthBar

@export var back_bar : TextureProgressBar
@export var front_bar : TextureProgressBar

@export var low_hp_pulse : bool = true
@export var damage_shake : bool = true

var original_scale : Vector2

func _ready() -> void:
	original_scale = scale

var current_percentage = 1.0 #0 means 0%, 1 means 100%
var front_tween : Tween
var back_tween : Tween
var pulse_tween : Tween = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_SPACE:
			update_bar(back_bar.value - 10, 100)

func update_bar(current: float, max_value: float):
	var percentage = clamp(current / max_value, 0.0, 1.0)
	
	front_bar.max_value = max_value
	back_bar.max_value = max_value
	
	var is_damage = percentage < current_percentage # Object is getting damaged
	var is_heal = percentage > current_percentage # Object is getting healed
	
	if is_damage:
		# Kills previous tweens
		if front_tween and front_tween.is_running():
			front_tween.kill()
		if back_tween and back_tween.is_running():
			back_tween.kill()
		
		# Change health bar to current health
		front_bar.value = current 
		
		# Bar update animation
		back_tween = create_tween()
		back_tween.tween_property(back_bar, "value", current, 0.45)
		
		_on_damage() # Play damage animation
			
	elif is_heal:
		# Kills previous tweens
		if front_tween and front_tween.is_running():
			front_tween.kill()
		if back_tween and back_tween.is_running():
			back_tween.kill()
		
		# Bar update animation
		front_tween = create_tween().set_parallel()
		front_tween.tween_property(front_bar, "value", current, 0.25)
		front_tween.tween_property(back_bar, "value", current, 0.25)
		
		_on_heal() # Play heal animation
		
		
	current_percentage = percentage
	
	_check_low_hp_pulse(percentage)

func _shake():
	var original_pos = position
	var tween = create_tween()
	
	tween.tween_property(self, "position", original_pos + Vector2(2, 0), 0.05)
	tween.tween_property(self, "position", original_pos - Vector2(2, 0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)

func _flash(flash_color : Color):
	modulate = flash_color
	var tween = create_tween()
	
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.25)
	
func _on_damage():
	_flash(Color(1, 0.3, 0.3))
	if damage_shake:
		_shake()
	
func _on_heal():
	_flash(Color(0.3, 1, 0.3))
	
func _check_low_hp_pulse(percentage : float) -> void:
	if percentage < 0.25: # Run when health is below 25%
		if pulse_tween == null or not pulse_tween.is_running():
			if pulse_tween:
				pulse_tween.kill()
				
			pulse_tween = create_tween()
			pulse_tween.set_loops()
			pulse_tween.tween_property(self, "scale", original_scale * 1.04, 0.2)
			pulse_tween.tween_property(self, "scale", original_scale, 0.2)
	else: # Reset if health above 25%
		scale = original_scale
		
		if pulse_tween and pulse_tween.is_running():
			pulse_tween.kill()
			pulse_tween = null
