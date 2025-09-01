
extends Node

@export var fade_time: float = 0.25
var _fade_layer: CanvasLayer
var _fade_rect: ColorRect

signal scene_change_started(target_path: String)
signal scene_change_finished(target_path: String)

func _ready() -> void:
	_fade_layer = CanvasLayer.new()
	_fade_layer.layer = 100
	add_child(_fade_layer)

	_fade_rect = ColorRect.new()
	_fade_rect.color = Color(0, 0, 0, 0)
	_fade_rect.size = get_viewport().get_visible_rect().size
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_layer.add_child(_fade_rect)

	get_viewport().size_changed.connect(_on_viewport_resized)

func _on_viewport_resized() -> void:
	_fade_rect.size = get_viewport().get_visible_rect().size

func change_scene(target_path: String) -> void:
	await _fade_to(1.0)
	scene_change_started.emit(target_path)
	await _load_async(target_path)
	await _fade_to(0.0)
	scene_change_finished.emit(target_path)
	if EventBus.has_signal("level_loaded"):
		EventBus.emit_signal("level_loaded", target_path)
	else:
		push_warning("EventBus missing 'level_loaded' signal. Check event_bus.gd/autoload.")

func _fade_to(alpha: float) -> void:
	var t: float = 0.0
	var start: float = float(_fade_rect.color.a)
	while t < fade_time:
		t += get_process_delta_time()
		var k: float = clamp(t / fade_time, 0.0, 1.0)
		var a: float = lerp(start, alpha, k)
		_fade_rect.color = Color(0, 0, 0, a)
		await get_tree().process_frame
	_fade_rect.color = Color(0, 0, 0, alpha)

func _load_async(path: String) -> void:
	var loading_path: String = "res://scenes/meta/loading_screen/loading_screen.tscn"
	var had_loading: bool = false

	if ResourceLoader.exists(loading_path):
		var packed_loading: PackedScene = load(loading_path) as PackedScene
		if packed_loading:
			var loading: Control = packed_loading.instantiate() as Control
			loading.name = "LoadingScreen"
			get_tree().root.add_child(loading)
			had_loading = true

	var req: int = ResourceLoader.load_threaded_request(path)
	if req != OK:
		push_error("Failed to start threaded load: %s" % path)
		return

	while true:
		var status: int = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		if status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Threaded load failed: %s" % path)
			return
		await get_tree().process_frame

	var packed: PackedScene = ResourceLoader.load_threaded_get(path)
	if packed == null:
		push_error("Threaded get returned null: %s" % path)
		return

	get_tree().change_scene_to_packed(packed)

	if had_loading:
		var ls: Node = get_tree().root.get_node_or_null("LoadingScreen")
		if ls:
			ls.queue_free()
