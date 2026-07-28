extends Node

var min_rrs_ig_mins := 8  # Minimum Reduced Runway Separation (ingame minutes)
var one_ingame_minute_seconds: float = 1.25
var selected_city: String

var _runways_number: String
var runways_number: String:
	get:
		return _runways_number
	set(val):
		if _runways_number != "":
			push_warning("Runways number is already assigned, ignoring.")
			return
		_runways_number = val
