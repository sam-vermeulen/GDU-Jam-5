extends StateMachine

func _ready():
	add_state("follow_path")
	add_state("explode")
	call_deferred("set_state", states.follow_path)

func _state_logic(delta):
	if state == states.follow_path:
		parent._follow_path()
	else:
		parent._stop()
		
	if state == states.explode:
		parent._explode()

func _get_transition(delta):
	match state:
		states.follow_path:
			if parent._should_follow_path():
				return states.follow_path
			elif parent._should_explode():
				return states.explode
				
		states.explode:
			if parent._should_explode():
				return states.explode
			elif parent._should_follow_path():
				return states.follow_path
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
