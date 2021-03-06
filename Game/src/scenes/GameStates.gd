extends StateMachine

var spawn_timer

func _ready():
	add_state("build")
	add_state("fight")
	add_state("gameover")
	call_deferred("set_state", states.build)

func _state_logic(delta):
	if state == states.build:
		parent.update_build()
	
	if state == states.fight:
		parent.update_fighting()
		
	if state == states.gameover:
		parent.update_gameover()
		
func _get_transition(delta):
	if parent._building():
		return states.build
	elif parent._fighting():
		return states.fight
	return null

func _enter_state(new_state, old_state):		
	if (old_state == states.fight && new_state == states.build):
		Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
		parent.selected_structure_scene = null
		parent.wave_number = parent.wave_number + 1
		parent.update_hud()
		
	if (old_state == states.build && new_state == states.fight):
		Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
		parent.calculate_wave_value(parent.wave_number)

func _exit_state(old_state, new_state):
	pass

