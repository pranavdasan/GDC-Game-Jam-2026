extends StaticBody2D

@onready var ShopMenu = $ShopMenu

func _ready():
	ShopMenu.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		ShopMenu.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		ShopMenu.visible = false
