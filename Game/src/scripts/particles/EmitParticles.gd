extends Particles2D

func _ready():
	play_animation()

func play_animation():
	emitting = true

func _process(delta):
	if not is_emitting():
		queue_free()
