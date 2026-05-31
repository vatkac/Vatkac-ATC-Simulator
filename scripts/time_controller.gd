extends Node

## === Shift Settings ===
@export_category("Shift Settings")
@export var one_ingame_minute_seconds: int = 2
@export var shift_duration_hours: int = 8
# == Shift Start Settings ==
@export var hours_start: int = 8
@export var minutes_start: int = 0

## === Other ===
@export_category("Other")
@export var time_node: Label

var timer := 0.0
var cur_hours: int
var cur_minutes: int

func _ready() -> void:
	cur_hours = hours_start
	cur_minutes = minutes_start
	update_UI()

func _process(delta: float) -> void:
	timer += delta
	if timer >= one_ingame_minute_seconds:
		timer -= one_ingame_minute_seconds
		update_time()

func update_time() -> void:
	cur_minutes += 1
	if cur_minutes == 60:
		cur_hours += 1
		cur_minutes = 0
		if cur_hours == hours_start + shift_duration_hours:
			finish_day()
	update_UI()

func update_UI() -> void:
	time_node.text = str(cur_hours).pad_zeros(2) + ":" + str(cur_minutes).pad_zeros(2)

func finish_day() -> void:
	print("Day finished!")
	cur_hours = hours_start
	cur_minutes = minutes_start
	# TODO: Show the "Day complete!" screen.
