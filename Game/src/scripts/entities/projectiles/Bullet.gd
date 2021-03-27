extends KinematicBody2D

export (int) var speed = 20
export (int) var damage = 5
export (bool) var homing = false
var targetBody
var velocity = Vector2()
var rng = RandomNumberGenerator.new()

func _ready():
	# Set random projectile
	var random = rng.randi_range(0, 3)
	if random == 0:
		$Sprite.texture("res://assets/battery.png")
	elif random == 1:
		$Sprite.texture("res://assets/nut.png")
	elif random == 2:
		$Sprite.texture("res://assets/wingbolt.png")

func start_position(pos, enemyBody):
	position = pos  # Spawn point
	targetBody = enemyBody  # Enemy body to track
	velocity = find_enemy(targetBody.global_position()) # Fire towards enemy
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		#Deal damage, free bullet from queue
		if homing:
			if collision.collider == targetBody:
				collision.collider.damage(damage)
				queue_free()
		else:
			if collision.collider.has_method("damage"):
				collision.collider.damage(damage)
				queue_free()
	#update direction/position of enemy if bullets are homing
	if homing:
		velocity = find_enemy(targetBody.global_position())
		
func find_enemy(enemyPosition):
	return Vector2(speed, 0).rotated(enemyPosition)
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
