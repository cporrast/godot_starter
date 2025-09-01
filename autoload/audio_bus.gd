extends Node

func set_bus_volume_db(bus_name: String, db: float) -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, db)

func get_bus_volume_db(bus_name: String) -> float:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx >= 0:
		return float(AudioServer.get_bus_volume_db(idx))
	return 0.0

func set_bus_mute(bus_name: String, muted: bool) -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx >= 0:
		AudioServer.set_bus_mute(idx, muted)

func crossfade_music(from_stream: AudioStreamPlayer, to_stream: AudioStreamPlayer, time_sec: float = 0.5) -> void:
	if from_stream == to_stream:
		return
	var t: float = 0.0
	var start_from: float = float(from_stream.volume_db)
	var start_to: float = float(to_stream.volume_db)
	to_stream.play()
	while t < time_sec:
		t += get_process_delta_time()
		var k: float = clamp(t / time_sec, 0.0, 1.0)
		from_stream.volume_db = lerp(start_from, -60.0, k)
		to_stream.volume_db = lerp(-60.0, start_to, k)
		await get_tree().process_frame
	from_stream.stop()
