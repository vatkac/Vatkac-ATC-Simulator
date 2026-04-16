extends HBoxContainer

const DEFAULT = preload("res://assets/textures/default_accept.svg")
const UP = preload("res://assets/textures/up_accept.svg")
const DOWN = preload("res://assets/textures/down_accept.svg")

enum Types {DEFAULT, UP, DOWN}

@export var accept_button: Button
@export var decline_button: Button
var _button_type: Types;

signal accepted(buttons)
signal declined(buttons)

func update_button_icon(type: Types):
	_button_type = type
	match type:
		Types.DEFAULT: accept_button.icon = DEFAULT
		Types.UP: accept_button.icon = UP
		Types.DOWN: accept_button.icon = DOWN

func _ready() -> void:
	update_button_icon(Types.DEFAULT)
	accept_button.pressed.connect(func(): accepted.emit(self))
	decline_button.pressed.connect(func(): declined.emit(self))
