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

# slime turret
var slime_turret_cost = Vector3(0, 75, 0)
var slime_turret_damage = 30
var slime_turret_slow = 0.05
var slime_turret_delay = 0.3

# robot
var robot_drop = Vector3(5, 0, 5)
var robot_speed = 100
var robot_min_speed = 30
var robot_health = 100
var robot_damage = 500

var hack_cooldown = 1

# explode hack
var explode_cost = Vector3(0, 0, 50)
var explode_damage = 200
var explode_range = 4

# lightning hack
var lightning_cost = Vector3(0, 0, 25)
var lightning_strength = 0.4
var lightning_range = 4

# music
var muted = false

