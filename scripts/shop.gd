extends StaticBody2D

func _ready():
	$shop_menu.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$shop_menu.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$shop_menu.visible = false
