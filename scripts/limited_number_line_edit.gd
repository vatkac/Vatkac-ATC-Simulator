extends LineEdit

@export var min_value: int
@export var max_value: int
var prev: String = ""

func _ready() -> void:
	virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	focus_entered.connect(func(): prev = text; clear())
	focus_exited.connect(correct_text)

func correct_text():
	if text == "": text = prev; return
	var clamped = clamp(int(text), min_value, max_value)
	text = str(clamped).pad_zeros(2)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if not get_global_rect().has_point(event.position):
			release_focus()
