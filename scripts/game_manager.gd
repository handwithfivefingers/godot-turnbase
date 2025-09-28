class_name Game_Manager extends Node

@export var player_character: Player
@export var ai_character: Enemies
var current_character
var game_over: bool = false
var turn : int = 0

func _ready() -> void:
	print("player_character", player_character.transform.x)

func onGameOver():
	game_over = true

func nextTurn(): 
	turn += 1
	var pos
	if(current_character == player_character):
		current_character = ai_character
		pos = player_character.position
	else: 
		current_character = player_character
		pos = ai_character.position
	current_character._attack(pos)
	print("current_character", pos)

func _on_hud_next_turn() -> void:
	nextTurn();
	print("turn",turn)
	$HUD.update_turn(turn)
	if(turn % 2 ):
		$HUD.show_message("Your Turn")
	else:
		$HUD.show_message("Enemies Turn")
