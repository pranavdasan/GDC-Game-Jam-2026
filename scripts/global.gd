extends Node

# format:
# id
# ability_name
# description
# cooldown (0.0 means passive)
# snow_cost
# upgradable
var abilities : Array[Ability] = [
	Ability.new(
		0,
		"Grow",
		"Allows the user to replenish snow by rolling around",
		0.0,
		0.0,
		true
	),
	Ability.new(
		1,
		"Snow Jump",
		"Allows the user to launch upwards from the ground at the cost of some snow",
		0.0,
		4.0,
		true
	),
	Ability.new(
		2,
		"Snow Bullet",
		"Fires a projectile made of snow in the direction of the uesr's movement",
		AbilityHandler.BASE_BULLET_COOLDOWN,
		2.0,
		true
	),
	Ability.new(
		3,
		"Snow Jetpack",
		"Boost upwards at a high speed at the cost of some snow",
		2.0,
		15.0,
		true
	),
	Ability.new(
		4,
		"Dash",
		"Allows the user to rapidly move in a certain direction at the cost of some snow",
		AbilityHandler.BASE_DASH_COOLDOWN,
		6.0,
		true
	)
]

# in order of how they appear on bottom
# text to display : button keycode
const ability_keybinds : Dictionary[int, String] = {
	KEY_Z : "Z",
	KEY_X : "X",
	KEY_C : "C",
	KEY_V : "V",
	KEY_B : "B"
}

const ABILITY_SHEET_PIXEL_WIDTH : int = 32

const MAX_ABILITY_LEVEL : int = 5

const MIN_SNOW_METER : float = 0.0
const MAX_SNOW_METER : float = 100.0

const BUTTON_MODULATE_WAIT_TIME : float = 0.5

signal owned_abilities_added()
signal ability_upgraded()

signal skill_points_changed()
signal snow_meter_changed()

var skill_points : int = 25
var snow_meter : float = 0.0

func _ready() -> void:
	abilities[0].set_upgrade_description(AbilityHandler.BASE_GROWTH_RATE)
	abilities[1].set_upgrade_description(AbilityHandler.BASE_JUMP_FORCE)
	abilities[2].set_upgrade_description(abilities[2].cooldown, AbilityHandler.BASE_BULLET_DAMAGE)
	abilities[4].set_upgrade_description(abilities[4].cooldown, AbilityHandler.BASE_DASH_SPEED)

# essential functions
func die() -> void:
	get_tree().quit()

# ability functions
func get_ability(ability_id : int) -> Ability:
	return abilities[ability_id]

func unlock_ability(ability_id : int) -> void:
	abilities[ability_id].owned = true
	owned_abilities_added.emit()

# skill point functions
func set_skill_points(value : int) -> void:
	skill_points = value
	skill_points_changed.emit()

func add_skill_points(value : int) -> void:
	set_skill_points(skill_points + value)

func subtract_skill_points(value : int) -> void:
	set_skill_points(skill_points - value)

# snow meter functions
func set_snow_meter(value : float) -> void:
	snow_meter = clamp(value, MIN_SNOW_METER, MAX_SNOW_METER)
	snow_meter_changed.emit()

func add_snow_meter(value : float) -> void:
	set_snow_meter(snow_meter + value)

func subtract_snow_meter(value : float) -> void:
	set_snow_meter(snow_meter - value)
