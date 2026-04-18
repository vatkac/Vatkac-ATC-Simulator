extends HBoxContainer
class_name AcceptDeclineButtons

const DEFAULT = preload("res://assets/textures/default_accept.svg")
const UP = preload("res://assets/textures/up_accept.svg")
const DOWN = preload("res://assets/textures/down_accept.svg")

enum ButtonTypes {DEFAULT, UP, DOWN}

@export var accept_button: Button
@export var decline_button: Button
var _button_type: ButtonTypes;

signal accepted
signal declined

func update_button_icon(type: ButtonTypes):
	_button_type = type
	match type:
		ButtonTypes.DEFAULT: accept_button.icon = DEFAULT
		ButtonTypes.UP: accept_button.icon = UP
		ButtonTypes.DOWN: accept_button.icon = DOWN

func _ready() -> void:
	update_button_icon(ButtonTypes.DEFAULT)
	accept_button.pressed.connect(accepted.emit)
	decline_button.pressed.connect(declined.emit)
