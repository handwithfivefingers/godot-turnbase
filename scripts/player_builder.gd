class_name PlayerBuilder extends Node
@export var chars: Array[Player]
signal onGameOver

var current_character: Player
var idx: int = -1 # init is -1
var maxIdx: int


func _ready():
	maxIdx = chars.size()


func gameOut() -> void:
	if (maxIdx == 0):
		onGameOver.emit()

func getCharByIdx():
	idx +=1
	return chars.get((idx) % maxIdx)


func _beingAttack():
	current_character._onBeingAttack()

func _attack(pos):
	current_character = getCharByIdx()
	if (current_character):
		current_character._attack(pos)
	return current_character
