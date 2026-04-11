extends Control

var TREE_LINE_COLOR : Color = Color.from_hsv(0.0, 0.0, 0.7, 1.0)
var TREE_LINE_WIDTH : float = 15.0

@onready var SkillTree = $"../.."

func _draw() -> void:
	var connections_to_draw : Array[Array] = SkillTree.tree_position_connections
	
	for connection_index in connections_to_draw.size():
		var position_one : Vector2 = connections_to_draw[connection_index][0]
		var position_two : Vector2 = connections_to_draw[connection_index][1]
		
		draw_line(position_one, position_two, TREE_LINE_COLOR, TREE_LINE_WIDTH)

func _process(_delta : float) -> void:
	queue_redraw()
