extends TextureRect
class_name Runway

enum RunwayType { L, R }
@export var side: RunwayType
@export var number_label: Label

func _ready() -> void:
	number_label.text = Settings.runways_number + RunwayType.keys()[side]
