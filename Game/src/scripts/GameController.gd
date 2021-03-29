extends Node

onready var mainframe = $Mainframe

var wave_number = 1
var wave_value = 0

var spawn_list = []

onready var monster_list = $Monsters
onready var structure_list = $Structures

var currency = GameVariables.start_currency

onready var robot_scene = load("res://src/scenes/entities/Robot.tscn")
onready var slime_scene = load("res://src/scenes/entities/Slime.tscn")
onready var turret_scene = load("res://src/scenes/entities/Turret.tscn")
var selected_structure_scene = null

var path = PoolVector2Array()

var structure_positions = []
var hacks = []
var chosen_hack
var hacking = false
var start_wave = false

var rng = RandomNumberGenerator.new()

func get_enemy_cost_by_id(id):
	match id:
		GameVariables.slime_id: return GameVariables.slime_cost
		GameVariables.robot_id: return GameVariables.robot_cost
	

func get_enemy_by_id(id):
	match id:
		GameVariables.slime_id: return slime_scene.instance()
		GameVariables.robot_id: return robot_scene.instance()

func get_random_enemy():
	rng.randomize()
	return rng.randi_range(0, 1)
		
func calculate_wave():
	var value_left = wave_value
	while value_left > 0:
		var enemy_id = get_random_enemy()
		if get_enemy_cost_by_id(enemy_id) <= wave_value:
			spawn_list.append(enemy_id)
			value_left = value_left - get_enemy_cost_by_id(enemy_id)

func _ready():
	$SpawnCooldown.wait_time = GameVariables.spawn_rate
	$HackCooldown.wait_time = GameVariables.hack_cooldown
	$HUD/HackUI/Panel/Cooldown.text = String(GameVariables.hack_cooldown) + "s"
	update_hud()
	$HUD/TurretMenu/Panel/VBoxContainer/Turret.connect("pressed", self, "change_turret", ["turret"])
	$HUD/HackUI/Panel/Cost.text = String(GameVariables.lightning_cost.z)
	$HUD/TurretMenu/Panel/VBoxContainer/Turret/Screws.text = String(GameVariables.turret_cost.x)
	$HUD/TurretMenu/Panel/VBoxContainer/Turret/Slime.text = String(GameVariables.turret_cost.y)
	$HUD/TurretMenu/Panel/VBoxContainer/Turret/CPUs.text = String(GameVariables.turret_cost.z)
	$Mainframe.connect("damaged", self, "update_hud")
	Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
	hacks.append("Explode")
	hacks.append("Lightning")
	calculate_path()
	
func update_build():
	handle_structure()
		
func update_fighting():
	if ($SpawnCooldown.is_stopped() && !spawn_list.empty()):
		var enemy = get_enemy_by_id(spawn_list[0])
		spawn_list.pop_front()
		enemy.set_global_position($SpawnPoint.global_position)
		monster_list.add_child(enemy)
		enemy.set_path(path)
		wave_value = wave_value - 1
		$SpawnCooldown.start()
	
	handle_hack()
	
func handle_structure():
	if Input.is_action_just_pressed("place_structure"):
		var tile_clicked = position_to_tile(get_viewport().get_mouse_position())
		var cell_type = get_cell_type(tile_clicked)
		if cell_type != -1 && cell_type != 3 && !structure_positions.has(tile_clicked):
			if (selected_structure_scene != null):
				var structure = selected_structure_scene.instance()
				if can_afford_structure(structure): # Pass in structure cost defined in hud
					structure.set_position(snap_to_grid(get_viewport().get_mouse_position()))
					structure_positions.append(tile_clicked)
					structure_list.add_child(structure)
	elif Input.is_action_just_pressed("next_wave"):
		start_wave = true

func handle_hack():
	if ($HackCooldown.is_stopped()):
		if Input.is_action_just_pressed("place_structure"):
			var mouse = get_viewport().get_mouse_position()
			if (hacking && currency.z >= GameVariables.lightning_cost.z):
				currency = currency - GameVariables.lightning_cost
				update_hud()
				var instance = load("res://src/scenes/hacks/" + hacks[chosen_hack] + ".tscn").instance()
				instance.position = mouse
				$Spells.add_child(instance)
				instance.use()
				$HackCooldown.start(GameVariables.hack_cooldown)
				
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
	if (monster_list.get_child_count() == 0):
		$Grid.show()
		$Line2D.show()
		Input.set_custom_mouse_cursor(load("res://assets/cursors/deafultcursor.png"))
		return true
	return false

func _fighting():
	if (start_wave):
		start_wave = false
		update_hud()
		$Grid.hide()
		$Line2D.hide()
		return true
	return false
	
func _gameover():
	if mainframe == null:
		return true
	return false

func calculate_wave_value(wave_number):
	wave_value = 50 * wave_number * wave_number - 20
	calculate_wave()
	
func calculate_path():
	path = $Navigation2D.get_simple_path($SpawnPoint.global_position, $Mainframe.global_position, false)
	
	for i in range(path.size()):
		path[i].y -= 4
		$Line2D.add_point(path[i])
			
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
	
func change_turret(button):
	if button == "turret":
		selected_structure_scene = turret_scene
		
func _process(delta):
	$HUD/HackUI/Panel/Cooldown.text = String(stepify($HackCooldown.time_left, 0.01)) + "s"
