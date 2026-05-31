extends VBoxContainer

@export var row_scene: PackedScene;
@export var end_object_scene: PackedScene;
@export var max_rows: int = 5;

var data: Array[FlightClearance] = [];
var end_object: Label;

func setup_test_data():
	# Пример 1: Аэрофлот из Берлина (классика — Airbus A320)
	var flight1 = FlightClearance.new()
	flight1.aircraft_designation = "ABC123" 
	flight1.clearance_time = 36000 
	flight1.city1 = "Berlin"
	flight1.city2 = "Moscow"
	flight1.runway = "24L"
	flight1.clearance_type = FlightClearance.ClearanceType.Landing
	add_row(flight1)

	# Пример 2: Emirates в Дубай (они летают только на больших бортах)
	var flight2 = FlightClearance.new()
	flight2.aircraft_designation = "DEF456" 
	flight2.clearance_time = 36600 
	flight2.city1 = "Moscow"
	flight2.city2 = "Dubai"
	flight2.runway = "06R"
	flight2.clearance_type = FlightClearance.ClearanceType.Takeoff
	add_row(flight2)

	# Пример 3: Lufthansa из Франкфурта
	var flight3 = FlightClearance.new()
	flight3.aircraft_designation = "GHI789" 
	flight3.clearance_time = 37200 
	flight3.city1 = "Frankfurt"
	flight3.city2 = "Moscow"
	flight3.runway = "24L"
	flight3.clearance_type = FlightClearance.ClearanceType.Landing
	add_row(flight3)
	add_row(flight3)
	add_row(flight3)


func _ready() -> void:
	end_object = end_object_scene.instantiate()
	add_child(end_object)
	child_exiting_tree.connect(func(_child): end_object.visible = true)
	
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
