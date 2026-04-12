extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	if get_tree().get_nodes_in_group("terrain").find(body)  != -1:
		queue_free()
	
	if get_tree().get_nodes_in_group("enemies").find(body) != -1:
		# enemy found
		pass
	
