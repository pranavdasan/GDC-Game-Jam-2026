extends RigidBody2D

const BASE_BULLET_DAMAGE : float = AbilityHandler.BASE_BULLET_DAMAGE
const BULLET_DAMAGE_UPGRADE_MULT : float = AbilityHandler.BULLET_DAMAGE_UPGRADE_MULT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	if get_tree().get_nodes_in_group("terrain").find(body)  != -1:
		# hit the terrain/floor
		queue_free()
	
	if get_tree().get_nodes_in_group("enemies").find(body) != -1:
		# enemy found
		# damage enemy by BASE_BULLET_DAMAGE + BULLET_DAMAGE_UPGRADE_MULT * Global.get_ability(2).ability_level
		pass
	
