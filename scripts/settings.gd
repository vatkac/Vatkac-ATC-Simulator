extends Node

var _selected_city: String
var selected_city: String:
	get:
		return _selected_city
	set(val):
		if _selected_city != "":
			push_warning("Selected city is already assigned, ignoring.")
			return
		_selected_city = val

var _runways_number: String
var runways_number: String:
	get:
		return _runways_number
	set(val):
		if _runways_number != "":
			push_warning("Runways number is already assigned, ignoring.")
			return
		_runways_number = val
