extends CharacterBody2D

const FPS : float = 15.0

@onready var Sprite : AnimatedSprite2D = $AnimatedSprite2D

var tween : Tween

var animations : Array[String] = [
	"default",
	"flip",
	"shake"
]
var animation_index : int = 1
var shakes : int = 0

func _ready() -> void:
	
	Sprite.play("default")
	
	await get_tree().create_timer(1).timeout
	
	Sprite.play("flip")
	
	tween = create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(-180), 9.0/FPS).as_relative()

func _on_animated_sprite_2d_animation_finished() -> void:
	animation_index += 1
	
	if animation_index == 2:
		shake(Vector2.LEFT)

func _on_animated_sprite_2d_animation_looped() -> void:
	print("loop finished")

func shake(attack_direction : Vector2) -> void:
	Sprite.play("shake")
	
	for i in range(5):
		tween = create_tween()
		tween.tween_property(self, "position", Vector2(0, -50), 6.0/FPS).as_relative()\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		
		tween = create_tween()
		tween.tween_property(self, "position", Vector2(0, 50), 6.0/FPS).as_relative()\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		print("shake finished")
	
	Sprite.stop()
