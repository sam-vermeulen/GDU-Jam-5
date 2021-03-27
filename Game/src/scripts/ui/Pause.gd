extends Popup

func _process(delta):
	if Input.is_action_just_pressed('pause'):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			show()
		else:
			hide()
