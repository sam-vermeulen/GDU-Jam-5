class_name Lightning extends Area2D
	
func use():
	$CollisionShape2D.shape.radius = GameVariables.lightning_range
	get_node("Lightning/AnimationPlayer").play("Lightning")
	yield(get_tree().create_timer(0.1), "timeout")
	var targets = get_overlapping_bodies()
	print(targets)
	for target in targets:
		if (target is Entity):
			target.slow(GameVariables.lightning_strength)
	yield(get_tree().create_timer(0.2), "timeout")
	self.queue_free()
