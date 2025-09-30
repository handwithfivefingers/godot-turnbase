class_name Player extends Area2D

@export var speed = 900
@export var x = 0
@export var y = 0
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
var skill_class = SkillPreset;
var fireball := load("res://skills/fireball.tres") as SkillPreset
var thunderbold := load("res://skills/thunderbold.tres") as SkillPreset
var slash := load("res://skills/slash.tres") as SkillPreset
var isSpell = false
# var skill1 = skill_class.from_dict({
# 	"skillName": "Skill 1",
# 	"skillDesc": "Sample desc",
# 	"skillDmg": 10,
# 	"skillCost": 100,
# 	"skillType": "CC"
# })

@export var attributes = {
	"life" = 100,
	"attackDmg" = 10,
	"evasion" = 0, # %
	"armour" = 0, # %
	"energy" = 50, # Default is 50 -> Each turn increase 25
}


func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play("idle")
	previousX = x
	previousY = y
	currentPosition = Vector2(x, y)
	newPos = Vector2(position.x, position.y)
	if (isEnemies):
		$AnimatedSprite2D.flip_h = true
	print(fireball.get("skillName"))
	
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
		$Life.text = str(_getAttribute("life"))
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
	$BeSlashedEffect.emitting = true
	await $Timer.timeout
	print("isDead", isDead)
	if (isDead):
		$Timer.start()
		_switchAnimation("dying")
		await $Timer.timeout
		visible = false

	else:
		_switchAnimation("idle")
	$BeSlashedEffect.emitting = false
	

func _isDead():
	if (_getAttribute("life") <= 0):
		isDead = true
		onDead.emit()



func _getAttribute(attr: String):
	return attributes.get(attr)
