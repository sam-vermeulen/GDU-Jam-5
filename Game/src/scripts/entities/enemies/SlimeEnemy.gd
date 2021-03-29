extends Enemy

var target = null
var game = null

func _ready():
	move_speed = GameVariables.slime_speed
	max_health = GameVariables.slime_health
	health = GameVariables.slime_health
	
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
		target.damage(GameVariables.slime_damage)
		kill()
	pass

func get_max_speed():
	return GameVariables.slime_speed
	
func get_min_speed():
	return GameVariables.slime_min_speed

func kill():
	var slime_drop = load("res://src/scenes/particles/SlimeDrop.tscn").instance()
	slime_drop.position = position
	game.currency = game.currency + GameVariables.slime_drop
	get_parent().get_parent().get_node("./Particles").add_child(slime_drop)
	game.update_hud()
	emit_signal("killed")
	queue_free()
