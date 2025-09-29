class_name Player extends Area2D

@export var speed = 900
@export var x = 0
@export var y = 0
@export var life: int = 100
@export var attackDmg: int = 12
@export var def: int = 3
@export var isEnemies: bool = false

signal onDead

var previousX
var previousY
var screen_size
var timer = 0
var currentPosition
var newPos
var isAttack = false
var isDead = false


func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("idle")
	previousX = x
	previousY = y
	currentPosition = Vector2(x, y)
	newPos = Vector2(position.x, position.y)
	if (isEnemies):
		$AnimatedSprite2D.flip_h = true
	
func _attack(pos):
	var type = ["attacking", "casting"].pick_random()
	if (type == "attacking"):
		_updatePos(pos)
		_switchAnimation(type)
	else:
		_switchAnimation(type)
	print("timer", $Timer.wait_time)
	$Timer.start()
	isAttack = true
	await $Timer.timeout
	isAttack = false
	_switchAnimation("idle")
	z_index = 0


func _process(_delta: float) -> void:
	if (isAttack):
		z_index = 1
		position = position.move_toward(Vector2(x, y + 1), _delta * speed)
	else:
		await $Timer.timeout
		position = position.move_toward(Vector2(previousX, previousY), _delta * speed * 2)
		$Life.text = str(life)
	_isDead()
	
func _switchAnimation(anim: String) -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play(anim)

func _updatePos(pos):
	x = pos.x
	y = pos.y


func _onBeingAttack():
	$Timer.start()
	_switchAnimation("hurt")
	await $Timer.timeout
	print("isDead", isDead)
	if (isDead):
		$Timer.start()
		_switchAnimation("dying")
		await $Timer.timeout
		visible = false

	else:
		_switchAnimation("idle")


func _isDead():
	if (life <= 0):
		isDead = true
		onDead.emit()
