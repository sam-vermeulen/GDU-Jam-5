extends Entity

signal damaged()

func _ready():
	pass

func damage(amount):
	_set_health(health - amount)
	emit_signal("damaged")
