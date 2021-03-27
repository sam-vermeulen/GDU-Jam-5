extends StateMachine

func _ready():
	add_state("chase")
	add_state("explode")
	call_deferred("set_state", states.chase)

func _state_logic(delta):
	if state == states.chase:
		parent._chase_target()
	else:
		parent._stop()
		
	if state == states.explode:
		parent._explode()

func _get_transition(delta):
	match state:
		states.chase:
			if parent._should_chase():
				return states.chase
			elif parent._should_explode():
				print("explode")
				return states.explode
				
		states.explode:
			if parent._should_explode():
				return states.explode
			elif parent._should_chase():
				print("chase")
				return states.chase
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
