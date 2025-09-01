extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if GameManager.is_paused:
			GameManager.resume_game()
		else:
			GameManager.pause_game()
