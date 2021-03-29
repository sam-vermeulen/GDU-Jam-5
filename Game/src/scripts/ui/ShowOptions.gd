extends Panel

var is_expanded = false


func _ready():
	$VBoxContainer/Show.connect("pressed",self,"expand")


func expand():
	is_expanded = !is_expanded
	if (is_expanded):
		$VBoxContainer/Turret.show()
		$VBoxContainer/SlimeTurret.show()
	else:
		$VBoxContainer/SlimeTurret.hide()


var last_rect_size = Vector2.ZERO
func _process(delta):

	#snap to end
	if abs(rect_size.y-rect_min_size.y) < 1:
		rect_size.y = rect_min_size.y

	#resize to target size
	if is_expanded:
		rect_size.y = lerp(rect_size.y, 70, 0.1)
	else:
		rect_size.y = lerp(rect_size.y, rect_min_size.y, 0.1)

	#update layout
	if last_rect_size != rect_size:
		get_parent().update()
		last_rect_size = rect_size
