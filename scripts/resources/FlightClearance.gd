extends Resource
class_name FlightClearance

enum ClearanceType { Landing, Takeoff }
@export var aircraft_designation: String
@export var clearance_time: int  # Seconds from the start of the day
@export var city1: String
@export var city2: String
@export var runway: String
@export var clearance_type: ClearanceType
