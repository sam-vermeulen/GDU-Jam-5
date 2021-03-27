class_name Turret extends StateMachine

var enemy_list;

func _ready():
	$AnimationPlayer.play("Idle")
	add_state("shoot")
	add_state("idle")
	call_deferred("set_state", states.idle)
	enemy_list = []

# implement in state machine
func _state_logic(delta):
	pass

# implement in state machine
func _get_transition(delta):
	return null

# implement in state machine
func _enter_state(new_state, old_state):
	set_state(new_state)
	if (new_state == "shoot"):
		$AnimationPlayer.play("Shoot")
		#Pivot toward enemy_list[0]
		$Sprite.look_at(enemy_list[0].global_position)
	if (new_state == "idle"):
		$AnimationPlayer.play("Idle")

# implement in state machine
func _exit_state(old_state, new_state):
	pass

# Enemy body enters area2d
func _on_Area2D_body_entered(body):
	if (enemy_list.empty()):
		_enter_state("shoot", "idle")
	enemy_list.append(body)

# Enemy body leaves area2d
func _on_Area2D_body_exited(body):
	enemy_list.erase(body)
	if (enemy_list.empty()):
		_enter_state("idle", "shoot")
	else:
		$Sprite.look_at(enemy_list[0].global_position)
