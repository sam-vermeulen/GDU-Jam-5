extends Friendly

var enemy_list = []

onready var bullet_scene = load("res://src/scenes/entities/projectiles/Bullet.tscn")

func _shoot():
	if !enemy_list.empty():
		$Sprite.look_at(enemy_list[0].global_position)
		$Sprite.rotate(PI)
		var bullet = bullet_scene.instance()
		bullet.start_position(global_position, enemy_list[0])
		$Bullets.add_child(bullet)
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

func _ready():
	pass 

# Enemy body enters area2d
func _on_Area2D_body_entered(body):
	enemy_list.append(body)

# Enemy body leaves area2d
func _on_Area2D_body_exited(body):
	enemy_list.erase(body)

