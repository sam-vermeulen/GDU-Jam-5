extends Node

# mainframe
var mainframe_health = 200

var spawn_rate = 0.1

# starting
var start_currency = Vector3(50, 0, 1)

# turret
var turret_cost = Vector3(50, 0, 1)
var turret_damage = 2

# robot
var robot_drop = Vector3(3, 0, 1)
var robot_speed = 100
var robot_min_speed = 30
var robot_health = 100
var robot_damage = 500

var hack_cooldown = 1

# explode hack
var explode_cost = Vector3(0, 0, 50)
var explode_damage = 200
var explode_range = 2

# lightning hack
var lightning_cost = Vector3(0, 0, 50)
var lightning_strength = 0.4
var lightning_range = 2

