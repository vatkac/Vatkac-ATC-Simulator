class_name GameDate
extends RefCounted

const MONTH_NAMES := [
	"",
	"Январь", "Февраль", "Март", "Апрель",
	"Май", "Июнь", "Июль", "Август",
	"Сентябрь", "Октябрь", "Ноябрь", "Декабрь"
]

var year: int
var month: int
var day: int

func _init(year_: int, month_: int, day_: int):
	year = year_
	month = month_
	day = day_

func to_unix() -> int:
	return Time.get_unix_time_from_datetime_dict({
		"year": year,
		"month": month,
		"day": day,
		"hour": 0,
		"minute": 0,
		"second": 0
	})

static func from_unix(unix: int) -> GameDate:
	var d := Time.get_date_dict_from_unix_time(unix)
	return GameDate.new(d.year, d.month, d.day)

func add_days(days: int) -> void:
	var tmp = from_unix(to_unix() + days * 86400)
	year = tmp.year
	month = tmp.month
	day = tmp.day

func to_formatted_string(template: String) -> String:
	return template % [day, month, year]

func to_month_string() -> String:
	return MONTH_NAMES[month] + " " + str(year)
