extends Node

signal level_loaded(level_name: String)
signal game_paused
signal game_resumed

signal enemy_killed(who: Node)
signal item_picked(item_id: String, amount: int)

signal toast_requested(message: String)

var debug_log: bool = false
func emit_and_log(sig: String, args: Array = []) -> void:
	if debug_log:
		print("[EventBus]", sig, args)
	callv("emit_signal", [sig] + args)
