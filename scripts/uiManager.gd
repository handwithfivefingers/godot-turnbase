extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal next_turn

@export var GM: Game_Manager

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_turn(turn:int):
	print("turn",turn)
	$Turn.text = str(turn)

func _on_start_button_pressed() -> void:
	next_turn.emit()
	pass # Replace with function body.
