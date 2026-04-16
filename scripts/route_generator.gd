extends Node

## Class to store data about airports.
class Airport:
	var city: String
	var latitude: float
	var longitude: float

	func _init(_city: String, _lat: float, _long: float):
		assert(abs(_lat) <= 90 && abs(_long) <= 180, "Invalid coordinates: (%f, %f)" % [_lat, _long])
		city = _city
		latitude = _lat
		longitude = _long

## Class to store data about aircrafts.
class Aircraft:
	var designation: String
	var service_ceiling_m: int
	var range_km: int
	var cruise_speed_kmh: int
	
	func _init(_des: String, _ceiling: int, _rng: int, _cruise: int):
		assert(_ceiling >= 0, "Ceiling cannot be negative!")
		assert(_rng >= 0, "Range cannot be negative!")
		assert(_cruise >= 0, "Cruise speed cannot be negative!")
		
		designation = _des
		service_ceiling_m = _ceiling
		range_km = _rng
		cruise_speed_kmh = _cruise

const EARTH_RADIUS_KM := 6371
@onready var aircrafts_raw: Array[Dictionary] = preload("res://assets/aircrafts.csv").records  # Using the CSV Data Importer plugin
@onready var airports_raw: Array[Dictionary] = preload("res://assets/airports.csv").records

var aircrafts: Array[Aircraft]
var airports: Array[Airport]

## Finds distance between two points on Earth. Returns approximate int result in km.
static func find_distance_between_points(lat1: float, long1: float, lat2: float, long2: float) -> int:
	if abs(lat1) > 90 || abs(long1) > 180:
		push_error("Invalid coordinates: (%f, %f)" % [lat1, long1]); return -1
	if abs(lat2) > 90 || abs(long2) > 180:
		push_error("Invalid coordinates: (%f, %f)" % [lat2, long2]); return -1
	if lat1 == lat2 && long1 == long2:  # Micro-optimization
		return 0
	
	var phi1 := deg_to_rad(lat1)
	var phi2 := deg_to_rad(lat2)
	
	var dphi := phi2 - phi1
	var dlam := deg_to_rad(long2 - long1)
	
	var a := (sin(dphi / 2) ** 2
			 + cos(phi1) * cos(phi2)
			 * sin(dlam / 2) ** 2)
	
	var c := 2 * asin(sqrt(a))
	var d := EARTH_RADIUS_KM * c
	
	return roundi(d)


## Prepares aircrafts and airports arrays.
func prepare_data():
	aircrafts = aircrafts_raw.map(func(row):
		return Aircraft.new(
			row.designation, 
			row.service_ceiling, 
			row.range, 
			row.cruise_speed
		)
	)
	airports = airports_raw.map(func(row):
		return Airport.new(
			row.city,
			row.latitude,
			row.longitude
		)
	)

func _ready() -> void:
	aircrafts_raw.make_read_only()
	airports_raw.make_read_only()
	prepare_data()
