extends Enemy

var target = null

func _ready():
	target = get_node("/root/Game/Mainframe")
	pass

func _should_chase():
	if (get_position().distance_to(target.get_position()) >= 20):
		return true
	return false
	
func _should_explode():
	if (get_position().distance_to(target.get_position()) < 20):
		return true
	return false

func _chase_target():
	pass

func _stop():
	pass
	
func _explode():
	kill()
	pass