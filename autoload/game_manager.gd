extends Node

var run_id: int = 0
var is_paused: bool = false

func new_run() -> void:
	run_id += 1

func pause_game() -> void:
	if is_paused: return
	is_paused = true
	get_tree().paused = true
	EventBus.emit_signal("game_paused")

func resume_game() -> void:
	if not is_paused: return
	is_paused = false
	get_tree().paused = false
	EventBus.emit_signal("game_resumed")
