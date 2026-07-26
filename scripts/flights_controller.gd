extends Node

@export var airplane_scene: PackedScene
@export var left_runway: Runway
@export var right_runway: Runway

func _ready() -> void:
	GlobalEvents.flight_clearance_accepted.connect(on_clearance_accepted)
	GlobalEvents.minute_passed.connect(on_minute_passed)

func on_clearance_accepted(clearance: FlightClearance) -> void:
	var time = clearance.clearance_total_mins_time
	UserData.scheduled_flights[time] = UserData.scheduled_flights.get(time, []) + [clearance]

func on_minute_passed(total_mins: int) -> void:
	for clearance in UserData.scheduled_flights.get(total_mins, []):
		clearance = clearance as FlightClearance
		var airplane = airplane_scene.instantiate() as Airplane
		if clearance.runway[-1] == "L":  # костыль
			left_runway.add_child(airplane)
		else:
			right_runway.add_child(airplane)
		if clearance.clearance_type == FlightClearance.ClearanceType.Landing:
			airplane.land()
		else:
			airplane.take_off()
	UserData.scheduled_flights.erase(total_mins)
