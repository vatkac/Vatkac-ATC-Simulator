extends Resource
class_name FlightClearance

enum ClearanceType { Landing, Takeoff }
@export var aircraft_callsign: String
@export var clearance_time: String
@export var city1: String
@export var city2: String
@export var runway: String
@export var clearance_type: ClearanceType
@export var clearance_total_mins_time: int
