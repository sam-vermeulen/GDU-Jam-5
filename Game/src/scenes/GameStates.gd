extends StateMachine

var spawn_timer

func _ready():
	
	add_state("fight")
	add_state("build")
	add_state("pause")
	call_deferred("set_state", states.fight) # SWITCH TO BUILD

func _state_logic(delta):
	if state == states.fight:
		parent.update_fighting()
		
	if state == states.build:
		parent.update_build()
	
	if state == states.pause:
		parent.update_pause()
		
func _get_transition(delta):
	if parent._fighting():
		return states.fight
	elif parent._building():
		return states.build
	elif parent._paused():
		return states.paused
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass

