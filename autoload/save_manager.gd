
extends Node

const SAVE_PATH := "user://savegame.json"
const CONFIG_PATH := "user://config.cfg"

func save_game(payload: Dictionary) -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Cannot open save file")
		return false
	file.store_string(JSON.stringify(payload, "\t"))
	file.flush()
	return true

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var txt: String = file.get_as_text()
	var res: Variant = JSON.parse_string(txt)
	if typeof(res) == TYPE_DICTIONARY:
		return res as Dictionary
	return {}

func write_config(section: String, key: String, value: Variant) -> void:
	var cfg := ConfigFile.new()
	cfg.load(CONFIG_PATH)
	cfg.set_value(section, key, value)
	cfg.save(CONFIG_PATH)

func read_config(section: String, key: String, default_value: Variant = null) -> Variant:
	var cfg := ConfigFile.new()
	cfg.load(CONFIG_PATH)
	return cfg.get_value(section, key, default_value)
