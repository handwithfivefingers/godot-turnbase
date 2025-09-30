
extends Node
class_name TurnManager

signal turn_started(actor_type: String, actor: Node, target: Node)

@export var turn_delay: float = 0.6

var players: Array = []   # danh sách Player nodes
var enemies: Array = []   # danh sách Enemy nodes

var player_index: int = 0
var enemy_index: int = 0
var is_player_turn: bool = true

# Setup ban đầu
func setup(_players: Array, _enemies: Array) -> void:
	players = _players
	enemies = _enemies
	reset_round()

# Reset chỉ số vòng mới
func reset_round() -> void:
	player_index = 0
	enemy_index = 0
	is_player_turn = true

# Bắt đầu round/lượt
func start_next_turn() -> void:
	if is_player_turn:
		var actor = _get_next_alive(players, player_index)
		if actor:
			var target = _get_first_alive(enemies)
			emit_signal("turn_started", "player", actor, target)
		else:
			# nếu player hết lượt → chuyển sang enemy
			is_player_turn = false
			start_next_turn()
	else:
		var actor = _get_next_alive(enemies, enemy_index)
		if actor:
			var target = _get_first_alive(players)
			emit_signal("turn_started", "enemy", actor, target)
		else:
			# nếu enemy hết lượt → reset round mới
			reset_round()
			start_next_turn()
		
# Kết thúc lượt hiện tại
func end_current_turn() -> void:
	if is_player_turn:
		player_index += 1
		is_player_turn = false
	else:
		enemy_index += 1
		is_player_turn = true

	# await get_tree().create_timer(1.0).timeout
	start_next_turn()

# ---------------------
# Helpers
# ---------------------

# Lấy actor tiếp theo còn sống theo index
func _get_next_alive(side: Array, start_index: int) -> Node:
	for i in range(start_index, side.size()):
		var actor = side[i]
		print()
		var l = actor._getAttribute("life")
		if l and l > 0:
			return actor
	return null

# Lấy mục tiêu còn sống đầu tiên
func _get_first_alive(side: Array) -> Node:
	for actor in side:
		if actor and actor.attributes["life"] > 0:
			return actor
	return null
