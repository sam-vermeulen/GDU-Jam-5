extends Node

onready var mainframe = $Mainframe

var spawn_timer
export(float) var spawn_delay

var wave_number = 1
var num_monsters_left = 1000000
onready var monster_list = $Monsters

onready var robot_scene = load("res://src/scenes/entities/Robot.tscn")

var path = PoolVector2Array()

func _ready():
	calculate_path()
	setup_timer()

func update_fighting():
	pass
	
func _spawn_monsters():
	if (num_monsters_left > 0):
		var robot = robot_scene.instance()
		robot.set_global_position($SpawnPoint.global_position)
		monster_list.add_child(robot)
		robot.set_path(path)
		num_monsters_left = num_monsters_left - 1
	else:
		spawn_timer.stop()
		
	pass

func update_build():
	pass
	
func update_pause():
	pass
	
func update_gameover():
	pass

func _building():
	if (num_monsters_left == 0 && monster_list.get_child_count() == 0):
		return true
	return false

func _fighting():
	if (num_monsters_left > 0 || monster_list.get_child_count() > 0):
		return true
	return false
	
func _gameover():
	if mainframe == null:
		return true
	return false

func calculate_monster_count(wave_number):
	return wave_number * wave_number
	
func calculate_path():
	path = $Navigation2D.get_simple_path($SpawnPoint.global_position, $Mainframe.global_position, false)
	
	for i in range(path.size()):
		path[i].y -= 4
		$Line2D.add_point(path[i])
			
func setup_timer():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.autostart = true
	spawn_timer.wait_time = spawn_delay
	spawn_timer.connect("timeout", self, "_spawn_monsters")
	spawn_timer.start()
	

