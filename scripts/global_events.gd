extends Node

@warning_ignore("unused_signal")
signal trust_changed(new_trust: int)
@warning_ignore("unused_signal")
signal balance_changed(new_balance: int)

@warning_ignore("unused_signal")
signal flight_clearance_accepted(clearance: FlightClearance)
@warning_ignore("unused_signal")
signal flight_clearance_declined(clearance: FlightClearance)

@warning_ignore("unused_signal")
signal search_option_picked(option: String)
@warning_ignore("unused_signal")
signal dropdown_option_picked(option: String)

@warning_ignore("unused_signal")
signal marker_configured(takeoff: bool, time: String)
@warning_ignore("unused_signal")
signal marker_configuration_cancelled()
