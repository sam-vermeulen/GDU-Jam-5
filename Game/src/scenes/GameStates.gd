extends StateMachine

var spawn_timer

func _ready():
	add_state("fight")
	add_state("build")
	add_state("gameover")
	call_deferred("set_state", states.build)

func _state_logic(delta):
	if state == states.fight:
		parent.update_fighting()
		
	if state == states.build:
		print("build")
		parent.update_build()
	
	if state == states.gameover:
		parent.update_gameover()
		
func _get_transition(delta):
	if parent._gameover():
		return states.gameover
	elif parent._fighting():
		return states.fight
	elif parent._building():
		return states.build
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass

