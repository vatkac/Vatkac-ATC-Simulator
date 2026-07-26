extends Control

var TEXT_TEMPLATE := "Два самолёта столкнулись на ВПП %s. Аэропорт закрыт до завтрашнего дня."
@export var text: Label
@export var button: Button

func _ready() -> void:
	text.text = TEXT_TEMPLATE % UserData.disaster_runway
	button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/DayEndScreen.tscn"))
