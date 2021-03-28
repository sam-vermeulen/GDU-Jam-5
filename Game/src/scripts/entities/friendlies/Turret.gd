extends Friendly

var enemy_list = []

onready var bullet_scene = load("res://src/scenes/entities/projectiles/Bullet.tscn")

var cost = GameVariables.turret_cost

var shoot_delay = 0.2
var shoot_timer = null
var can_shoot = true

func _ready():
	setup_timer()

func _shoot():
	if !enemy_list.empty():
		$Sprite.look_at(enemy_list[0].global_position)
		$Sprite.rotate(PI)
		
		if (can_shoot):
			$AudioStreamPlayer2D.play()
			var bullet = bullet_scene.instance()
			bullet.damage = GameVariables.turret_damage
			bullet.start_position(global_position, enemy_list[0])
			$Bullets.add_child(bullet)
			can_shoot = false
			shoot_timer.start()
	pass

func _idle():
	pass
	
func _should_shoot():
	if (!enemy_list.empty()):
		return true
	return false
	
func _should_idle():
	if (enemy_list.empty()):
		return true
	return false

# Enemy body enters area2d
func _on_Area2D_body_entered(body):
	enemy_list.append(body)

# Enemy body leaves area2d
func _on_Area2D_body_exited(body):
	enemy_list.erase(body)

func _toggle_shoot():
	can_shoot = true
	
func setup_timer():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.autostart = true
	shoot_timer.wait_time = shoot_delay
	shoot_timer.connect("timeout", self, "_toggle_shoot")
	shoot_timer.start()

