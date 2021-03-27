class_name Entity extends PhysicsBody2D

signal health_changed(health)
signal killed()

export(float) var max_health

onready var health = max_health setget _set_health

func damage(amount):
	_set_health(health - amount)

func kill():
	_set_health(0)

func on_death():
	emit_signal("killed")

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_changed", health)
		if health == 0:
			on_death()

