extends HBoxContainer
class_name FlightClearanceRow

@export var info: FlightClearance
@export var designation_label: Label
@export var route_label: Label
@export var runway_label: Label
@export var time_label: Label
@export var buttons: AcceptDeclineButtons

var current_clearance: FlightClearance;
func _ready() -> void:
	buttons.accepted.connect(func(): on_desicion_made(true))
	buttons.declined.connect(func(): on_desicion_made(false))

## Returns a FlightClearance object of the row.
func get_info() -> FlightClearance:
	return info

## Sets the row info based on a FlightClearance object.
func set_info(clearance: FlightClearance) -> void:
	if clearance == null:
		push_error("The flight clearance must not be null!")
		return
	
	current_clearance = clearance
	designation_label.text = clearance.aircraft_designation
	route_label.text = clearance.city1 + " — " + clearance.city2
	runway_label.text = clearance.runway
	time_label.text = "12:00"  # TODO: Use real data when implement the time system.
	
	var icon_type: AcceptDeclineButtons.ButtonTypes
	match clearance.clearance_type:
		FlightClearance.ClearanceType.Landing: icon_type = AcceptDeclineButtons.ButtonTypes.DOWN
		FlightClearance.ClearanceType.Takeoff: icon_type = AcceptDeclineButtons.ButtonTypes.UP
		
	buttons.update_button_icon(icon_type)

## Removes the row from the table and emits the corresponding global signal.
func on_desicion_made(accepted: bool) -> void:
	if accepted: GlobalEvents.flight_clearance_accepted.emit(current_clearance)
	else: GlobalEvents.flight_clearance_declined.emit(current_clearance)
	play_delete_animation()

func play_delete_animation() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position:x", 500, 0.5).set_trans(Tween.TRANS_BACK).finished.connect(queue_free)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.3)
