extends Control

@export var auto_time: float = 0.8  # seconds; set to 0 to require input

func _ready() -> void:
	if auto_time > 0.0:
		await get_tree().create_timer(auto_time).timeout
		_go_main()

func _unhandled_input(event: InputEvent) -> void:
	if auto_time <= 0.0 and (event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton):
		_go_main()

func _go_main() -> void:
	await SceneRouter.change_scene("res://scenes/main/main.tscn")
