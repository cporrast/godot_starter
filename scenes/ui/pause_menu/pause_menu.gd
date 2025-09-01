extends Control

@onready var resume_btn: Button = $CenterContainer/VBoxContainer/ResumeButton
@onready var quit_btn: Button   = $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	visible = false
	resume_btn.pressed.connect(_on_resume)
	quit_btn.pressed.connect(_on_quit)
	# listen for global pause/resume
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_resumed.connect(_on_game_resumed)

func _on_game_paused() -> void:
	show_menu()

func _on_game_resumed() -> void:
	hide_menu()

func show_menu() -> void:
	visible = true
	resume_btn.grab_focus()

func hide_menu() -> void:
	visible = false

func _on_resume() -> void:
	GameManager.resume_game()

func _on_quit() -> void:
	get_tree().paused = false
	await SceneRouter.change_scene("res://scenes/main/main.tscn")
