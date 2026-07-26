extends Node

const SAVE_PATH = "user://save_game.cfg"

var current_trust: int = 50
var current_balance: int = 5000
var cur_hours: int = 0
var cur_minutes: int = 0
var total_minutes: int = 0
var pending_clearances: Array[FlightClearance] = []
var scheduled_flights: Dictionary[int, Array] = {}
var table_overflows: int = 0
var disaster_runway: String
var disaster: bool = false
var disaster_time_total_mins: int
var unjustified_declines_count: int = 0
var cur_date: GameDate = GameDate.new(2025, 1, 1)
var days_since_last_weekend: int = 0
var prev_month_salary: int = 0
var ignored_clearances_count: int = 0

func initialize_time(hours_start: int, minutes_start: int) -> void:
	cur_hours = hours_start
	cur_minutes = minutes_start
	total_minutes = hours_start * 60 + minutes_start

func reset_all() -> void:
	reset_day()
	current_trust = 50
	current_balance = 5000
	cur_hours = 0
	cur_minutes = 0
	total_minutes = 0
	cur_date = GameDate.new(2025, 1, 1)
	days_since_last_weekend = 0
	prev_month_salary = 0

func change_balance(amount: int) -> void:
	current_balance += amount
	GlobalEvents.balance_changed.emit(current_balance)

func change_trust(amount: int) -> void:
	current_trust = clampi(current_trust + amount, 0, 100)
	GlobalEvents.trust_changed.emit(current_trust)

func reset_day() -> void:
	pending_clearances = []
	scheduled_flights = {}
	table_overflows = 0
	disaster = false
	disaster_runway = ""
	disaster_time_total_mins = 0
	unjustified_declines_count = 0
	ignored_clearances_count = 0

func add_days() -> void:
	cur_date.add_days(3 if days_since_last_weekend == 3 else 1)
	days_since_last_weekend += 1
	
