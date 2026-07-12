extends Node

const SAVE_PATH = "user://save_game.cfg"

var selected_city: String = ""
var current_trust: int = 50
var current_balance: int = 5000
var runways_number: String
var cur_hours: int = 0
var cur_minutes: int = 0
var total_minutes: int = 0
var pending_clearances: Array[FlightClearance] = []
var scheduled_flights: Dictionary[int, Array] = {}
var table_overflows: int = 0
var disaster_runway: String
var disaster: bool = false
var disaster_time_total_mins: int

func initialize_time(hours_start: int, minutes_start: int) -> void:
	cur_hours = hours_start
	cur_minutes = minutes_start
	total_minutes = hours_start * 60 + minutes_start

func _ready() -> void:
	_check_initial_scene.call_deferred()

func _check_initial_scene() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		get_tree().change_scene_to_file("res://scenes/CitySelectionPopup.tscn")
		runways_number = str(randi_range(1, 36)).pad_zeros(2)
	else:
		load_game()
		get_tree().change_scene_to_file("res://scenes/main_gameplay.tscn")

func set_city(city_name: String) -> void:
	selected_city = city_name
	get_tree().change_scene_to_file("res://scenes/MainScreen.tscn")

func change_balance(amount: int) -> void:
	current_balance += amount
	GlobalEvents.balance_changed.emit(current_balance)

func change_trust(amount: int) -> void:
	current_trust = clampi(current_trust + amount, 0, 100)
	GlobalEvents.trust_changed.emit(current_trust)

# === Save/Load ===
func save_game() -> void:
	var config := ConfigFile.new()
	config.set_value("Player", "selected_city", selected_city)
	config.set_value("Player", "current_trust", current_trust)
	config.set_value("Player", "current_balance", current_balance)
	config.save(SAVE_PATH)

func load_game() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		selected_city = config.get_value("Player", "selected_city", selected_city)
		current_trust = config.get_value("Player", "current_trust", current_trust)
		current_balance = config.get_value("Player", "current_balance", current_balance)
