class_name Enemy extends Entity

var move_speed = 200

var path
var tween = Tween.new()

func _ready():
	set_process(false)

func slow(percent):
	set_speed(move_speed * percent)
	
func get_max_speed():
	pass
	
func get_min_speed():
	pass
	
func set_speed(amount):
	move_speed = clamp(amount, get_min_speed(), get_max_speed())

func set_path(p):
	set_process(true)
	path = p

func _process(delta):
	var start = global_position
	var distance = move_speed * delta
	
	for i in range(path.size()):
		var next = start.distance_to(path[0])
		
		if distance <= next and distance >= 0.0:
			position = start.linear_interpolate(path[0], distance / next)
			break
		
		path.remove(0)

