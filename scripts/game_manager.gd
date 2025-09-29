class_name Game_Manager extends Node

@export var ai_character: Enemies
@export var playerBuilder: PlayerBuilder

var current_character
var game_over: bool = false
var turn: int = 0
var chars

func _ready() -> void:
	print("ready")
	spawnPlayer()
	

func onGameOver():
	game_over = true

func nextTurn():
	$TurnDelay.start()
	if (turn > 30):
		onGameOver()
	var pos = {x = 0, y = 0}
	if (isPlayerTurn()):
		pos = ai_character.position
		var cPlayer = playerBuilder._attack({x = pos.x + 50, y = pos.y})
		if (!cPlayer):
			onGameOver()
		ai_character._onBeingAttack()
		ai_character.life = ai_character.life - (cPlayer.attackDmg - cPlayer.def)
	else:
		if (playerBuilder.current_character):
			var cPlayer = playerBuilder.current_character
			pos = cPlayer.position
			cPlayer.life = ai_character.life - (ai_character.attackDmg - ai_character.def)
			ai_character._attack({x = pos.x + 50, y = pos.y})
			cPlayer._onBeingAttack()
			if (!playerBuilder.current_character):
				onGameOver()
			if (ai_character.isDead):
				onGameOver()
	if (game_over != true):
		turn += 1
		await $TurnDelay.timeout
		nextTurn(); ## kep going
	

func isPlayerTurn():
	if (turn % 2):
		return false
	return true


func _on_hud_next_turn() -> void:
	if (game_over != true):
		print("game_over", game_over)
		nextTurn();
		$HUD.update_turn(turn)
		if (turn % 2):
			$HUD.show_message("Your Turn")
		else:
			$HUD.show_message("Enemies Turn")
	else:
		$HUD.show_game_over()


func _on_player_on_dead() -> void:
	print('_on_player_on_dead')
	onGameOver()
	$HUD.show_message("You Lose")


func _on_ai_on_dead() -> void:
	print('_on_ai_on_dead')
	onGameOver()
	$HUD.show_message("You Win")


func _on_player_builder_on_game_over() -> void:
	onGameOver()
	_on_hud_next_turn()
	pass # Replace with function body.


func spawnPlayer():
	chars = get_node("Characters").get_children(0)
	chars[0].visible = true
	chars[1].visible = true
	chars[2].visible = true
	playerBuilder.chars.insert(0, chars[0])
	playerBuilder.chars.insert(1, chars[1])
	playerBuilder.chars.insert(2, chars[2])
	playerBuilder.maxIdx = 3
	print("chars", playerBuilder.chars)
