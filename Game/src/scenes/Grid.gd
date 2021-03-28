extends Node2D

func _ready():
	pass
	
func _draw():
	var style_box = StyleBoxFlat.new()
	for x in range(29):
		for y in range(26):
			var position = Vector2(x*16, y*16)
			var size = Vector2(1, 1)
			draw_style_box(style_box, Rect2(position, size))
