extends Entity

signal damaged()

func _ready():
	pass

func damage(amount):
	_set_health(health - amount)
	emit_signal("damaged")

func kill():
	emit_signal("killed")
	get_tree().change_scene("res://src/title/TitleScreen.tscn")
	queue_free()
