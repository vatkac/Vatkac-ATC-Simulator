extends VBoxContainer

@export var row_scene: PackedScene
@export var end_object_scene: PackedScene
@export var max_rows: int = 5

var end_object: Label

func _ready() -> void:
	end_object = end_object_scene.instantiate()
	add_child(end_object)
	child_exiting_tree.connect(func(_child): end_object.visible = true)
	GlobalEvents.flight_clearance_created.connect(add_row)

func add_row(info: FlightClearance) -> void:
	if get_child_count() - 1 >= max_rows:
		UserData.table_overflows += 1
		return
	
	var new_row: FlightClearanceRow = row_scene.instantiate()
	if new_row is not FlightClearanceRow:
		push_error("Row scene's class must be FlightClearanceRow!")
	
	new_row.set_info(info)
	
	add_child(new_row)
	move_child(new_row, -2)
	
	if get_child_count() - 1 == max_rows:
		end_object.visible = false
