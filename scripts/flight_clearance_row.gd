extends MarginContainer
class_name FlightClearanceRow

@export var designation_label: Label
@export var route_label: Label
@export var runway_label: Label
@export var time_label: Label
@export var buttons: AcceptDeclineButtons

var current_clearance: FlightClearance
var tween: Tween

func _ready() -> void:
	buttons.accepted.connect(func(): on_desicion_made(true))
	buttons.declined.connect(func(): on_desicion_made(false))
	GlobalEvents.minute_passed.connect(on_minute_passed)

## Sets the row info based on a FlightClearance object.
func set_info(clearance: FlightClearance) -> void:
	if clearance == null:
		push_error("The flight clearance must not be null!")
		return
	
	current_clearance = clearance
	designation_label.text = clearance.aircraft_callsign
	route_label.text = clearance.city1 + " — " + clearance.city2
	runway_label.text = clearance.runway
	time_label.text = clearance.clearance_time
	
	var icon_type: AcceptDeclineButtons.ButtonTypes
	match clearance.clearance_type:
		FlightClearance.ClearanceType.Landing: icon_type = AcceptDeclineButtons.ButtonTypes.DOWN
		FlightClearance.ClearanceType.Takeoff: icon_type = AcceptDeclineButtons.ButtonTypes.UP
		
	buttons.update_button_icon(icon_type)

## Removes the row from the table and emits the corresponding global signal.
func on_desicion_made(accepted: bool) -> void:
	UserData.pending_clearances.erase(current_clearance)
	if accepted: GlobalEvents.flight_clearance_accepted.emit(current_clearance)
	else: GlobalEvents.flight_clearance_declined.emit(current_clearance)
	play_delete_animation()

func play_delete_animation() -> void:
	if tween and tween.is_valid() and tween.is_running(): return
	tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position:x", 500, 0.5).set_trans(Tween.TRANS_BACK).finished.connect(queue_free)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.3)

func on_minute_passed(total_mins: int) -> void:
	if current_clearance.clearance_total_mins_time == total_mins:
		UserData.ignored_clearances_count += 1
		UserData.pending_clearances.erase(current_clearance)
		GlobalEvents.flight_clearance_ignored.emit(current_clearance)
		play_delete_animation()
