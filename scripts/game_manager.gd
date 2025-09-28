class_name Game_Manager extends Node

@export var player_character: Player
@export var ai_character: Player
var current_character: Player
var game_over: bool = false
var turn : int = 0

func _ready() -> void:
	print("ready")

func onGameOver():
	game_over = true

func nextTurn(): 
	turn += 1
	if(current_character == player_character):
		current_character = ai_character
	else: 
		current_character == player_character
