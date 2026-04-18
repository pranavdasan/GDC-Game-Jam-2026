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
		"Increases the rate at which the user grows by " + str(AbilityHandler.GROWTH_RATE_UPGRADE_MULT) + "%.",
		0.0,
		0.0,
		true
	),
	Ability.new(
		1,
		"Snow Jump",
		"Allows the user to launch upwards from the ground at the cost of some snow",
		"",
		0.0,
		4.0,
		false
	),
	Ability.new(
		2,
		"Snow Bullet",
		"Fires a projectile made of snow in the direction of the user's movement",
		"Reduces cooldown by " + str(AbilityHandler.DASH_COOLDOWN_UPGRADE_MULT) + " sec + increases damage by " + str(AbilityHandler.BULLET_DAMAGE_UPGRADE_MULT) + ".",
		AbilityHandler.BASE_BULLET_COOLDOWN,
		2.0,
		true
	),
	Ability.new(
		3,
		"Snow Punch",
		"Hits enemies directly in front of the user",
		"no",
		0.25,
		5.0,
		true
	),
	Ability.new(
		4,
		"Dash",
		"Allows the user to rapidly move in a certain direction at the cost of some snow",
		"Reduces cooldown by " + str(AbilityHandler.DASH_COOLDOWN_UPGRADE_MULT) + " sec + increases dash force by " + str(AbilityHandler.DASH_SPEED_UPGRADE_MULT) + "px/s.",
		AbilityHandler.BASE_DASH_COOLDOWN,
		6.0,
		true
	),
	Ability.new(
		5,
		"Crushing Roll",
		"Whenever the user rolls over an enemy, damage is dealt",
		"no",
		0.0,
		0.0,
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

const ABILITY_SP_COST : int = 5
const ABILITY_UPGRADE_SP_COST : int = 1

const MIN_SNOW_METER : float = 0.0
const MAX_SNOW_METER : float = 100.0

const BUTTON_MODULATE_WAIT_TIME : float = 0.5

signal owned_abilities_added()
signal ability_upgraded()

signal skill_points_changed()
signal snow_meter_changed()

var skill_points : int = 75
var snow_meter : float = 0.0

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
