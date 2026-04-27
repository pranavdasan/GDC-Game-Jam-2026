extends Node2D

@onready var animation_player = $AnimationPlayer
func _ready():
	# Start the scene invisible and fade it in
	animation_player.play("fade_in")
	
func _on_texture_button_pressed() -> void:
	animation_player.play("fade_out")
	
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file("res://levels/main.tscn")
