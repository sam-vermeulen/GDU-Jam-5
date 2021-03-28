extends Area2D

export (int) var speed
export (int) var damage
export (bool) var homing = false
var targetBody
var velocity = Vector2()
var rng = RandomNumberGenerator.new()

func _ready():
	# Set random projectile
	
	rng.randomize()
	var random = rng.randi_range(0, 3)
	print(random)
	if random == 0:
		$Sprite.set_texture(load("res://assets/battery.png"))
	elif random == 1:
		$Sprite.set_texture(load("res://assets/nut.png"))
	elif random == 2:
		$Sprite.set_texture(load("res://assets/wingbolt.png"))

func start_position(pos, enemyBody):
	position = pos  # Spawn point
	targetBody = enemyBody  # Enemy body to track
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
		queue_free()
	elif (!homing && body.has_method("damage")):
		body.damage(damage)
		queue_free()
		
