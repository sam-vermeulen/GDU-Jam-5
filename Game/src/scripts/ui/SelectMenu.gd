extends Control

export var spacing = 10

func _draw():

	var last_end_achor = Vector2.ZERO
	for child in get_children():
		child.rect_position = last_end_achor
		last_end_achor.y = child.rect_position.y + child.rect_size.y 
		last_end_achor.y += spacing

	rect_min_size.y = last_end_achor.y #to work with ScrollContainer
