class_name StateMachine extends Node

var state = null setget set_state
var previous_state = null
var states = {}

onready var parent = get_parent()

"""
in state machines _on_ready() function use add_state('[state name]') to add
a state. then use call_deferred('set_state', states.[state name]) to set
the initial state.
"""

func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

# implement in state machine
func _state_logic(delta):
	pass

# implement in state machine
func _get_transition(delta):
	return null

# implement in state machine
func _enter_state(new_state, old_state):
	pass

# implement in state machine
func _exit_state(old_state, new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)

func add_state(state_name):
	states[state_name] = states.size()
	
func print_states():
	print(states)
