class_name Enemies extends Player

# func _ready():
# 	screen_size = get_viewport_rect().size
# 	$AnimatedSprite2D.play("idle_left")
# 	previousX = x
# 	previousY = y
# 	currentPosition = Vector2(x, y)
# 	newPos = Vector2(position.x, position.y)
	
# func _attack(pos):
# 	_updatePos(pos)
# 	_switchAnimation("attack_left")
# 	print("timer", $Timer.wait_time)
# 	$Timer.start()
# 	isAttack = true
# 	await $Timer.timeout
# 	isAttack = false
# 	_switchAnimation("idle_left")
# 	z_index = 0
