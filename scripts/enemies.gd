class_name Enemies extends Area2D

@export var speed = 400
@export var x = 0
@export var y = 0
var screen_size
var timer = 0
var previousX
var previousY
var currentPosition
var newPos 
var isAttack = false
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("idle_left")
	previousX = x
	previousY = y
	currentPosition = Vector2(x,y)
	newPos = Vector2(position.x, position.y)
	
func _attack(pos):
	print(pos)
	timer = 0
	$AnimatedSprite2D.stop()
	x = pos.x
	y = pos.y
	$AnimatedSprite2D.play("attack_left")
	print("timer",timer)
	isAttack = true
	
func _process(_delta: float) -> void:
	print("x",x,"y",y,"previousX",previousX,"previousY",previousY)
	if(isAttack):
		timer += 1
		position = position.move_toward(Vector2(x,y), _delta * speed)
	else:
		position = position.move_toward(Vector2(previousX,previousY), _delta * speed * 2)
	if(isAttack && $AnimatedSprite2D.animation == 'attack_left' && timer >= 450):
		print("callback")
		$AnimatedSprite2D.play("idle_left")
		isAttack = false
		timer = 0
