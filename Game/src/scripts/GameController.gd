extends Node

onready var mainframe = $Mainframe

var spawn_timer
export(float) var spawn_delay

var wave_number = 1
var num_monsters_left = 0
onready var monster_list = $Monsters
onready var structure_list = $Structures

var currency = Vector3() # nuts, slime, cpus

onready var robot_scene = load("res://src/scenes/entities/Robot.tscn")
onready var selected_structure_scene = load("res://src/scenes/entities/Turret.tscn")

var path = PoolVector2Array()

var hacks = []
var chosen_hack
var hacking = false

func _ready():
	currency.x = 0
	currency.y = 0
	currency.z = 0
	update_hud()
	$Mainframe.connect("damaged", self, "update_hud")
	Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
	hacks.append(SelfDestruct.new())
	hacks.append(Lightning.new())
	calculate_path()
	setup_timer()
	
func _spawn_monsters():
	if (num_monsters_left > 0):
		var robot = robot_scene.instance()
		robot.set_global_position($SpawnPoint.global_position)
		monster_list.add_child(robot)
		robot.set_path(path)
		num_monsters_left = num_monsters_left - 1
	else:
		spawn_timer.stop()

func update_build():
	if Input.is_action_just_pressed("place_structure"):
		var structure = selected_structure_scene.instance()
		if can_afford(structure): # Pass in structure cost defined in hud
			structure.set_position(mouse_to_grid())
			structure_list.add_child(structure)
	elif Input.is_action_just_pressed("next_wave"):
		num_monsters_left = 5 * wave_number
		
func update_fighting():
	if Input.is_action_just_pressed("place_structure"):
		var mouse = get_viewport().get_mouse_position()
		var hits = get_parent().world_2d.direct_space_state.intersect_point(mouse)
		var target = hits[0].collider
		if (hacking):
			hacks[chosen_hack].use(target)
		
			
	spawn_timer.start()
	for i in range(hacks.size()):
		var hack_str = "hack_" + str(i+1)
		if Input.is_action_just_pressed(hack_str):
			if (!hacking):
				hacking = true
				chosen_hack = i
			elif (hacking):
				if (i == chosen_hack):
					hacking = false
				else:
					hacking = true
					chosen_hack = i

func can_afford(structure):
	if structure.name == "Turret":
		if currency.x >= structure.cost:
			currency.x -= structure.cost
			update_hud()
			return true
	#Logic: Check structure name to determine currency, check if balance is >= cost
	
	return true	
	#return false

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
	
	
func mouse_to_grid():
	var mouse = get_viewport().get_mouse_position()
	#Prints grid coord of mouse
	print($Navigation2D/FactoryMap.world_to_map(mouse))
	mouse.x = floor(mouse.x / 16) * 16 + 6
	mouse.y = floor(mouse.y / 16) * 16 + 6
	
	return mouse
	
func update_hud():
	$HUD/CurrencyMenu/Panel/ScrewCount.text = String(currency.x)
	$HUD/CurrencyMenu/Panel/SlimeCount.text = String(currency.y)
	$HUD/CurrencyMenu/Panel/CPUCount.text = String(currency.z)
	$HUD/MainframeHP/Panel/Health.text = String($Mainframe.health)
	$HUD/WaveMenu/Panel/WaveNum.text = String(wave_number)
