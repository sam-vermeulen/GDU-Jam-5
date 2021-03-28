extends Enemy

signal got_hacked(body)

var target = null

func _ready():
	target = get_node("/root/Game/Mainframe")
	connect("got_hacked", get_node("/root/Game/"), "_on_UsedHack_input")
	pass

func _should_follow_path():
	if (target != null):
		if (get_position().distance_to(target.get_position()) >= 20):
			return true
	return false
	
func _should_explode():
	if (target != null):
		if (get_position().distance_to(target.get_position()) < 20):
			return true
	return false

func _follow_path():
	pass

func _stop():
	pass
	
func _explode():
	if (target != null):
		target.damage(1)
		kill()
	pass

func _on_Area2D_mouse_entered():
	if (Input.is_action_just_pressed("place_structure")):
		emit_signal("got_hacked", self)
		
