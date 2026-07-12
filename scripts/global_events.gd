extends Node

@warning_ignore_start("unused_signal")
signal trust_changed(new_trust: int)
signal balance_changed(new_balance: int)

signal flight_clearance_created(clearance: FlightClearance)
signal flight_clearance_accepted(clearance: FlightClearance)
signal flight_clearance_declined(clearance: FlightClearance)

signal search_option_picked(option: String)
signal dropdown_option_picked(option: String)

signal marker_configured(takeoff: bool, time: String)
signal marker_configuration_cancelled()

signal minute_passed(total_since_day_start: int)
