extends Node
class_name TimeController

## === Shift Settings ===
@export_category("Shift Settings")
@export var one_ingame_minute_seconds: float = 1.25
@export var shift_duration_hours: int = 8
# == Shift Start Settings ==
@export var hours_start: int = 8
@export var minutes_start: int = 0

## === Other ===
@export_category("Other")
@export var time_node: Label
@export var date_node: Label

var timer := 0.0

func _ready() -> void:
	UserData.initialize_time(hours_start, minutes_start)
	date_node.text = UserData.cur_date.to_formatted_string("%02d.%02d\n%04d")
	update_UI()

func _process(delta: float) -> void:
	timer += delta
	if timer >= one_ingame_minute_seconds:
		timer -= one_ingame_minute_seconds
		update_time()

func update_time() -> void:
	UserData.cur_minutes += 1
	UserData.total_minutes += 1
	
	GlobalEvents.minute_passed.emit(UserData.total_minutes)
	
	if UserData.cur_minutes == 60:
		UserData.cur_hours += 1
		UserData.cur_minutes = 0
	
	if UserData.cur_hours == hours_start + shift_duration_hours and UserData.cur_minutes == minutes_start:
		finish_day()
	
	update_UI()

func update_UI() -> void:
	time_node.text = str(UserData.cur_hours).pad_zeros(2) + ":" + str(UserData.cur_minutes).pad_zeros(2)

func finish_day() -> void:
	UserData.cur_hours = hours_start
	UserData.cur_minutes = minutes_start
	UserData.total_minutes = hours_start * 60 + minutes_start
	
	get_tree().change_scene_to_file("res://scenes/DayEndScreen.tscn")
