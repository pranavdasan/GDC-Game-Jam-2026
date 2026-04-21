extends CharacterBody2D

@onready var Sprite : AnimatedSprite2D = $AnimatedSprite2D

var tween : Tween

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	
	Sprite.play("flip")
	
	tween = create_tween()
	tween.tween_property(self, "rotation", 180, (9/15))
