class_name Turret extends StateMachine

func _ready():
	add_state("shoot")
	add_state("idle")
	call_deferred("set_state", states.idle)

# implement in state machine
func _state_logic(delta):
	if state == states.shoot:
		parent._shoot()
	else:
		parent._idle()
		
	if state == states.idle:
		parent._idle()

# implement in state machine
func _get_transition(delta):
	match state:
		states.shoot:
			if parent._should_shoot():
				return states.shoot
			elif parent._should_idle():
				return states.idle
				
		states.idle:
			if parent._should_shoot():
				return states.shoot
			elif parent._should_idle():
				return states.idle
	return null

# implement in state machine
func _enter_state(new_state, old_state):
	pass

# implement in state machine
func _exit_state(old_state, new_state):
	pass
