class_name Enemy extends Entity

var move_speed = 200

var path

func _ready():
	set_process(false)

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


