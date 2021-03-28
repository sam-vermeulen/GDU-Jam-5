extends Entity

signal damaged()

func _ready():
	health = GameVariables.mainframe_health
	pass

func damage(amount):
	_set_health(health - amount)
	emit_signal("damaged")
