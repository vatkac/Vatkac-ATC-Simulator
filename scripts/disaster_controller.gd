extends Node

@export var min_rrs_ig_mins := 7  # Minimum Reduced Runway Separation (ingame minutes)
@export var disaster_screen: PackedScene
@export var collision_sound_player: AudioStreamPlayer
@export var overlay: ColorRect
@export var fade_duration := 2

func _ready() -> void:
	GlobalEvents.minute_passed.connect(on_minute_passed)
	GlobalEvents.flight_clearance_accepted.connect(check_for_future_disasters)

func check_for_future_disasters(clearance: FlightClearance) -> void:
	for time in UserData.scheduled_flights:
		var difference: int = abs(clearance.clearance_total_mins_time - time)
		if difference >= min_rrs_ig_mins: continue
		for existing_clearance in UserData.scheduled_flights[time]:
			if clearance == existing_clearance: continue
			if clearance.runway != existing_clearance.runway: continue
			if UserData.disaster and UserData.disaster_time_total_mins < clearance.clearance_total_mins_time: continue
			UserData.disaster = true
			UserData.disaster_runway = clearance.runway
			UserData.disaster_time_total_mins = min(clearance.clearance_total_mins_time, existing_clearance.clearance_total_mins_time)

func on_minute_passed(total_mins: int) -> void:
	if UserData.disaster and total_mins == UserData.disaster_time_total_mins:
		get_tree().paused = true
		var tween = create_tween()
		tween.tween_property(overlay, "modulate:a", 1.0, fade_duration)
		await tween.finished
		collision_sound_player.play()
		await collision_sound_player.finished
		get_tree().change_scene_to_packed(disaster_screen)
