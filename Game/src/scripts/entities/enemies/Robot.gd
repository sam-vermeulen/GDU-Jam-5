extends Enemy

var target = null
var game = null

func _ready():
	move_speed = GameVariables.robot_speed
	max_health = GameVariables.robot_health
	health = GameVariables.robot_health
	
	target = get_node("/root/Game/Mainframe")
	game = get_node("/root/Game")

func _should_follow_path():
	if (target != null):
		if (get_position().distance_to(target.get_position()) >= 20):
			return true
	return false
	
func _should_explode():
	if (target != null):
		if (get_position().distance_to(target.get_position()) < 20):
			return true
	return false

func _follow_path():
	pass

func _stop():
	pass
	
func _explode():
	if (target != null):
		target.damage(GameVariables.robot_damage)
		kill()
	pass

func get_max_speed():
	return GameVariables.robot_speed
	
func get_min_speed():
	return GameVariables.robot_min_speed

func kill():
	var screw_drop = load("res://src/scenes/particles/ScrewDrop.tscn").instance()
	var cpu_drop = load("res://src/scenes/particles/CPUDrop.tscn").instance()
	cpu_drop.position = position
	screw_drop.position = position
	game.currency = game.currency + GameVariables.robot_drop
	get_parent().get_parent().get_node("./Particles").add_child(cpu_drop)
	get_parent().get_parent().get_node("./Particles").add_child(screw_drop)
	game.update_hud()
	emit_signal("killed")
	queue_free()
