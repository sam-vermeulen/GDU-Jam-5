extends Node

# mainframe
var mainframe_health = 200

var spawn_rate = 0.1

# starting
var start_currency = Vector3(50, 0, 51)

# turret
var turret_cost = Vector3(50, 0, 1)
var turret_damage = 50
var turret_delay = 0.2
var turret_radius = 32

# slime turret
var slime_turret_cost = Vector3(25, 50, 1)
var slime_turret_damage = 30
var slime_turret_slow = 0.05
var slime_turret_delay = 0.3
var slime_turret_radius = 16

# robot
var robot_drop = Vector3(5, 0, 5)
var robot_speed = 100
var robot_min_speed = 30
var robot_health = 100
var robot_damage = 1
var robot_cost = 1
var robot_id = 1

# slime
var slime_drop = Vector3(0, 10, 0)
var slime_speed = 70
var slime_min_speed = 30
var slime_health = 200
var slime_damage = 5
var slime_cost = 5
var slime_id = 0

var hack_cooldown = 1

# explode hack
var explode_cost = Vector3(0, 0, 50)
var explode_damage = 200
var explode_range = 4

# lightning hack
var lightning_cost = Vector3(0, 0, 25)
var lightning_strength = 0.4
var lightning_range = 64

# music
var muted = false

func calc_wave_function(wave_number):
	return wave_number * wave_number + 10

