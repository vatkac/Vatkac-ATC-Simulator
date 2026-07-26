extends Node

@export var min_rrs_ig_mins := 8  # Minimum Reduced Runway Separation (ingame minutes)
@export var disaster_screen: PackedScene
@export var collision_sound_player: AudioStreamPlayer
@export var overlay: ColorRect
@export var fade_duration := 3
@export var fade_offset := -2

func _ready() -> void:
	GlobalEvents.minute_passed.connect(on_minute_passed)
	GlobalEvents.flight_clearance_accepted.connect(update_disasters_list)
	GlobalEvents.flight_clearance_declined.connect(evaluate_decline)

func check_for_upcoming_disasters(clearance: FlightClearance) -> Array:
	var disaster := false
	var disaster_runway: String
	var disaster_time_total_mins: int
	
	for time in UserData.scheduled_flights:
		var difference: int = abs(clearance.clearance_total_mins_time - time)
		if difference >= min_rrs_ig_mins: continue
		for existing_clearance in UserData.scheduled_flights[time]:
			if clearance == existing_clearance: continue
			if clearance.runway != existing_clearance.runway: continue
			if UserData.disaster and UserData.disaster_time_total_mins < clearance.clearance_total_mins_time: continue
			disaster = true
			disaster_runway = clearance.runway
			disaster_time_total_mins = min(clearance.clearance_total_mins_time, existing_clearance.clearance_total_mins_time)
	return [disaster, disaster_runway, disaster_time_total_mins]

func update_disasters_list(new_clearance: FlightClearance) -> void:
	var tmp = check_for_upcoming_disasters(new_clearance)
	if not tmp[0]: return
	UserData.disaster = true
	UserData.disaster_runway = tmp[1]
	UserData.disaster_time_total_mins = tmp[2]

func evaluate_decline(declined_clearance: FlightClearance) -> void:
	if not check_for_upcoming_disasters(declined_clearance)[0]:
		UserData.unjustified_declines_count += 1

func on_minute_passed(total_mins: int) -> void:
	if UserData.disaster and total_mins == UserData.disaster_time_total_mins + fade_offset:
		var tween = create_tween()
		tween.tween_property(overlay, "modulate:a", 1.0, fade_duration)
		await tween.finished
		get_tree().paused = true
		collision_sound_player.play()
		await collision_sound_player.finished
		get_tree().paused = false
		get_tree().change_scene_to_packed(disaster_screen)
