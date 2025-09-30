class_name Game_Manager extends Node

@export var ai_character: Enemies
@export var player_builder: PlayerBuilder
@export var turn_manager = TurnManager.new()

# Create instance of a scene.
#var diamond = preload("res://diamond.tscn").instantiate()
enum BattleState {IDLE, PLAYER_TURN, ENEMY_TURN, ANIMATING, VICTORY, DEFEAT}
var state: BattleState = BattleState.IDLE


var current_character
var players: Array = []
var enemies: Array = []


func _ready():
	players = player_builder.chars
	enemies = get_node("MobBuilder").get_children()
	turn_manager.setup(players, enemies)
	# setup turn manager
	turn_manager.connect("turn_started", _on_turn_started, 1)
	call_deferred("_start_first_turn")

func _start_first_turn():
	await get_tree().create_timer(0.8).timeout # delay để UI hiện "Battle starts!"
	turn_manager.start_next_turn()


func _on_turn_started(actor_type: String, actor: Player, target: Player) -> void:
	if not actor or not target:
		print("⚠ No actor or target available for this turn")
		turn_manager.end_current_turn()
		return

	if actor_type == "player":
		state = BattleState.PLAYER_TURN
		# emit_signal("battle_message", "%s (Player) attacks %s (Enemy)" % [actor.name, target.name])
		# Player tấn công
		await actor._attack(target.position)
		# Target bị đánh
		await target._onBeingAttack()
		var dmg = _calcDmg(actor, target, actor.isSpell)
		# var dmg = max(0, actor.attributes["attackDmg"] - target.attributes['def'])
		target.attributes["life"] = max(0, target.attributes['life'] - dmg)

	elif actor_type == "enemy":
		state = BattleState.ENEMY_TURN
		# emit_signal("battle_message", "%s (Enemy) attacks %s (Player)" % [actor.name, target.name])

		# Enemy tấn công
		await actor._attack(target.position)

		# Target bị đánh
		await target._onBeingAttack()
		var dmg = _calcDmg(actor, target, actor.isSpell)
		# var dmg = max(0, actor.attributes["attackDmg"] - target.attributes['def'])
		target.attributes["life"] = max(0, target.attributes['life'] - dmg)

	# Sau action → check battle end
	if _check_battle_end():
		return

	# Kết thúc lượt
	turn_manager.end_current_turn()
		
func _on_hud_next_turn() -> void:
	#turn_manager.start_next_turn()
	print("_on_hud_next_turn")
	if state == BattleState.PLAYER_TURN:
		# Kết thúc lượt player mà không hành động gì
		_showMsg("Player skipped turn")
		turn_manager.end_current_turn()
		$HUD.update_turn(turn_manager.current_turn_index)


func _check_battle_end() -> bool:
	var all_dead = true
	for e in enemies:
		if e.attributes['life'] > 0:
			all_dead = false
	if all_dead:
		state = BattleState.VICTORY
		_showMsg("Victory!")
		# emit_signal("battle_message", "Victory!")
		# emit_signal("battle_ended", "victory")
		return true

	all_dead = true
	for p in players:
		if p:
			var l = p._getAttribute("life")
			if l && l > 0:
				all_dead = false
	if all_dead:
		state = BattleState.DEFEAT
		_showMsg("Defeat ...")
		# emit_signal("battle_message", "Defeat...")
		# emit_signal("battle_ended", "defeat")
		return true

	return false

func _calcDmg(actor: Player, target: Player, isSpell: bool) -> int:
	var dmg = actor._getAttribute("attackDmg")
	if isSpell:
		return dmg
	var armour = target._getAttribute("armour")
	var result = 5 * dmg * dmg / (armour + 5 * dmg)
	return result


func _showMsg(msg: String):
	$HUD.show_message(String(msg))
