class_name Entity extends PhysicsBody2D

signal health_changed(health)
signal killed()

export(float) var max_health

onready var health = max_health setget _set_health

func damage(amount):
	print("health" + str(health))
	_set_health(health - amount)

func kill():
	emit_signal("killed")
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_changed", health)
		if health == 0:
			kill()

