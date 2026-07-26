extends Node

var DATA_CONFIG_PATH = "res://assets/cities_data.cfg"
@export var generate_interval_ingame_minutes := 4
@export_range(0.0, 1.0) var generate_chance := 0.4
@export var min_notice_time_ingame_minutes := 15
@export var max_notice_time_ingame_minutes := 40

static var ALPHABET: Array = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split()
var cities_pool: Array

func _ready() -> void:
	prepare_cities_pool()
	GlobalEvents.minute_passed.connect(on_minute_passed)

func prepare_cities_pool() -> void:
	var config := ConfigFile.new()
	var error = config.load(DATA_CONFIG_PATH)
	
	if error == OK:
		var packed_array = config.get_value("Data", "data") as PackedStringArray
		cities_pool = Array(packed_array)
		cities_pool.erase(Settings.selected_city)
	else:
		push_error("Error while loading cities!")

func get_random_city() -> String:
	if not cities_pool.is_empty():
		return cities_pool.pick_random()
	return ""

func generate_route(clearance_type: FlightClearance.ClearanceType) -> Array:
	var random_city = get_random_city()
	var player_city = Settings.selected_city
	
	if clearance_type == FlightClearance.ClearanceType.Takeoff:
		return [player_city, random_city]
	else:
		return [random_city, player_city]

func generate_clearance() -> FlightClearance:
	var clearance = FlightClearance.new()
	var notice_time := randi_range(min_notice_time_ingame_minutes, max_notice_time_ingame_minutes)
	
	var clearance_hours = UserData.cur_hours
	var clearance_minutes = UserData.cur_minutes + notice_time
	
	if clearance_minutes > 59:
		@warning_ignore("integer_division")
		clearance_hours += clearance_minutes / 60
		clearance_minutes %= 60
		
	var unformatted_time = clearance_hours * 60 + clearance_minutes
	
	var formatted_time = str(clearance_hours).pad_zeros(2) + ":" + str(clearance_minutes).pad_zeros(2)
	var clearance_type = FlightClearance.ClearanceType.values().pick_random() as FlightClearance.ClearanceType
	var route = generate_route(clearance_type)
	
	clearance.clearance_time = formatted_time
	clearance.clearance_total_mins_time = unformatted_time
	clearance.clearance_type = clearance_type
	clearance.aircraft_callsign = generate_callsign()
	clearance.city1 = route[0]
	clearance.city2 = route[1]
	clearance.runway = Settings.runways_number + Runway.RunwayType.keys()[randi_range(0, 1)]
	
	return clearance

func generate_callsign() -> String:
	var letters = []
	for _i in 3:
		letters.append(ALPHABET.pick_random())
	letters = "".join(letters)
	
	var number := str(randi_range(100, 999))
	return letters + number

func on_minute_passed(total_minutes: int) -> void:
	if total_minutes % generate_interval_ingame_minutes: return
	if randf() > generate_chance: return
	
	var clearance = generate_clearance()
	UserData.pending_clearances.append(clearance)
	GlobalEvents.flight_clearance_created.emit(clearance)
