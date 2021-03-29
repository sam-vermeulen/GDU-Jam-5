extends Node

# mainframe
var mainframe_health = 200

var spawn_rate = 0.1

# starting
var start_currency = Vector3(1000, 0, 51) # 50, 0, 51
var start_wave = 15

# turret
var turret_cost = Vector3(50, 0, 1)
var turret_damage = 50
var turret_delay = 0.2
var turret_radius = 32

# slime turret
var slime_turret_cost = Vector3(50, 60, 1)
var slime_turret_damage = 30
var slime_turret_slow = 0.05
var slime_turret_delay = 0.5
var slime_turret_radius = 16

# slime
var blue_slime_drop = Vector3(0, 2, 0)
var blue_slime_speed = 100
var blue_slime_min_speed = 10
var blue_slime_health = 800
var blue_slime_damage = 20
var blue_slime_cost = 50
var blue_slime_id = 2

# robot
var robot_drop = Vector3(4, 0, 2)
var robot_speed = 100
var robot_min_speed = 10
var robot_health = 100
var robot_damage = 1
var robot_cost = 1
var robot_id = 1

# slime
var slime_drop = Vector3(0, 2, 0)
var slime_speed = 75
var slime_min_speed = 10
var slime_health = 400
var slime_damage = 5
var slime_cost = 5
var slime_id = 0

var hack_cooldown = 1

# explode hack
var explode_cost = Vector3(0, 0, 25)
var explode_damage = 200
var explode_range = 32

# lightning hack
var lightning_cost = Vector3(0, 0, 25)
var lightning_strength = 0.01
var lightning_range = 32

# music
var muted = false

func calc_wave_function(wave_number):
	if wave_number < 15:
		return wave_number * wave_number + 10
	elif wave_number < 30:
		return wave_number*wave_number*wave_number
	elif wave_number < 60:
		return wave_number*wave_number*wave_number*wave_number
		
	return 1000000000000

