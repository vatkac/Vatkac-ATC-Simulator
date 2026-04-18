extends Node

signal trust_changed(new_trust: int)
signal balance_changed(new_balance: int)
signal flight_clearance_accepted(clearance: FlightClearance)
signal flight_clearance_declined(clearance: FlightClearance)
