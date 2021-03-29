extends Area2D

export (int) var speed
export (int) var damage
export (int) var slow
export (bool) var homing = false
var targetBody
var velocity = Vector2()


func start_position(pos, enemyBody):
	position = pos  # Spawn point
	targetBody = enemyBody  # Enemy body to track
	print(enemyBody)
	if targetBody != null:
		velocity = find_enemy(targetBody.position) # Fire towards enemy
	
func apply_velocity(delta):
	position += velocity * delta
	
func _physics_process(delta):
	apply_velocity(delta)
	if (homing && targetBody != null):
		velocity = find_enemy(targetBody.position)
		
func find_enemy(enemyPosition):
	$Sprite.rotation = position.angle_to(enemyPosition) - PI/2
	return (enemyPosition - position).normalized() * speed
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(body):
	if (homing && body == targetBody || targetBody == null):
		body.damage(damage)
		body.slow(slow)
		queue_free()
	elif (!homing && body.has_method("damage")):
		body.damage(damage)
		body.slow(slow)
		queue_free()
		
