extends Node

onready var mainframe = $Mainframe

var spawn_timer
export(float) var spawn_delay

var wave_number = 1
var num_monsters_left = 0
onready var monster_list = $Monsters
onready var structure_list = $Structures

var currency = GameVariables.start_currency

onready var robot_scene = load("res://src/scenes/entities/Robot.tscn")
onready var selected_structure_scene = load("res://src/scenes/entities/Turret.tscn")

var path = PoolVector2Array()

var structure_positions = []
var hacks = []
var chosen_hack
var hacking = false

func _ready():
	update_hud()
	$Mainframe.connect("damaged", self, "update_hud")
	Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
	hacks.append("Explode")
	hacks.append("Lightning")
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
	handle_structure()
		
func update_fighting():
	spawn_timer.start()
	handle_hack()
	handle_structure()
	
func handle_structure():
	if Input.is_action_just_pressed("place_structure"):
		print(get_viewport().get_mouse_position())
		print($Camera2D.position)
		var tile_clicked = position_to_tile(get_viewport().get_mouse_position())
		var cell_type = get_cell_type(tile_clicked)
		print(cell_type)
		if cell_type != -1 && cell_type != 3 && !structure_positions.has(tile_clicked):
			var structure = selected_structure_scene.instance()
			if can_afford_structure(structure): # Pass in structure cost defined in hud
				structure.set_position(snap_to_grid(get_viewport().get_mouse_position()))
				structure_positions.append(tile_clicked)
				structure_list.add_child(structure)
	elif Input.is_action_just_pressed("next_wave"):
		num_monsters_left = 5 * wave_number

func handle_hack():
	if Input.is_action_just_pressed("place_structure"):
		var mouse = get_viewport().get_mouse_position()
		var hits = get_parent().world_2d.direct_space_state.intersect_point(mouse)
		if (hits.size() > 0):
			var target = hits[0].collider
			if (hacking):
				var instance = load("res://src/scenes/hacks/" + hacks[chosen_hack] + ".tscn").instance()
				instance.position = mouse
				$Spells.add_child(instance)
				instance.use()
				
	for i in range(hacks.size()):
		var hack_str = "hack_" + str(i+1)
		if Input.is_action_just_pressed(hack_str):
			if (!hacking):
				hacking = true
				chosen_hack = i
				#Input.set_custom_mouse_cursor(load(hacks[chosen_hack].get_cursor()))
			elif (hacking):
				if (i == chosen_hack):
					hacking = false
					#Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
				else:
					print("hack")
					hacking = true
					chosen_hack = i
					#Input.set_custom_mouse_cursor(load(hacks[chosen_hack].get_cursor()))

func can_afford_structure(structure):
	if currency.x >= structure.cost.x && currency.y >= structure.cost.y && currency.z >= structure.cost.z:
		currency -= structure.cost
		update_hud()
		return true	
	return false

func update_pause():
	pass
	
func update_gameover():
	pass

func _building():
	if (num_monsters_left == 0 && monster_list.get_child_count() == 0):
		Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
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
	return 50 * wave_number * wave_number - 20
	
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

func get_cell_type(tile):
	return $Navigation2D/FactoryMap.get_cell(tile.x, tile.y)

func snap_to_grid(position):
	return tile_to_global(position_to_tile(position))

func tile_to_global(tile):
	tile.x = tile.x * 16 + 7 
	tile.y = tile.y * 16 + 7
	return tile

func position_to_tile(position):
	return $Navigation2D/FactoryMap.world_to_map(position)
	
func update_hud():
	$HUD/CurrencyMenu/Panel/ScrewCount.text = String(currency.x)
	$HUD/CurrencyMenu/Panel/SlimeCount.text = String(currency.y)
	$HUD/CurrencyMenu/Panel/CPUCount.text = String(currency.z)
	$HUD/MainframeHP/Panel/Health.text = String($Mainframe.health)
	$HUD/WaveMenu/Panel/WaveNum.text = String(wave_number)
