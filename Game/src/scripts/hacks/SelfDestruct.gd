class_name SelfDestruct extends Area2D
	
func use():
	get_node("Explode/AnimationPlayer").play("Explode")
	yield(get_tree().create_timer(0.1), "timeout")
	var targets = get_overlapping_bodies()
	print(targets)
	for target in targets:
		if (target is Entity):
			target.damage(GameVariables.explode_damage)
	yield(get_tree().create_timer(0.2), "timeout")
	self.queue_free()
