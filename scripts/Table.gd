extends VBoxContainer

@export var row_scene: PackedScene;
@export var end_object_scene: PackedScene;
@export var max_rows: int = 5;

var data: Array[FlightClearance] = [];
var end_object: Label;

func setup_test_data():
	# Пример 1: Посадка рейса из Берлина
	var flight1 = FlightClearance.new()
	flight1.aircraft_designation = "AFL123"
	flight1.clearance_time = 36000 # 10:00 AM
	flight1.city1 = "Berlin"
	flight1.city2 = "Moscow"
	flight1.runway = "24L"
	flight1.clearance_type = FlightClearance.ClearanceType.Landing
	add_row(flight1)

	# Пример 2: Взлет частного джета
	var flight2 = FlightClearance.new()
	flight2.aircraft_designation = "G-LEX4"
	flight2.clearance_time = 36600 # 10:10 AM
	flight2.city1 = "Moscow"
	flight2.city2 = "Dubai"
	flight2.runway = "06R"
	flight2.clearance_type = FlightClearance.ClearanceType.Takeoff
	add_row(flight2)

	# Пример 3: Посадка тяжелого грузового борта
	var flight3 = FlightClearance.new()
	flight3.aircraft_designation = "CGO789"
	flight3.clearance_time = 37200 # 10:20 AM
	flight3.city1 = "Beijing"
	flight3.city2 = "Moscow"
	flight3.runway = "24L"
	flight3.clearance_type = FlightClearance.ClearanceType.Landing
	add_row(flight3)

func _ready() -> void:
	end_object = end_object_scene.instantiate()
	add_child(end_object)
	
	setup_test_data()

func add_row(info: FlightClearance) -> void:
	if len(data) >= max_rows:
		push_error("Table overflow!")
		return
	
	var new_row: FlightClearanceRow = row_scene.instantiate()
	if new_row is not FlightClearanceRow:
		push_error("Row scene's class must be FlightClearanceRow!")
	
	new_row.set_info(info)
	data.append(info)
	
	add_child(new_row)
	move_child(new_row, -2)
	
	if len(data) == max_rows:
		end_object.visible = false
