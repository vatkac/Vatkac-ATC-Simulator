extends Button
class_name LTButton

## We're assuming that in the end of the text there is a counter in brackets like this: (4) and there
## are no other brackets in the text. That's not the best practice, but fine for pre-alpha.

@export var LTScreen: ColorRect
var opening_bracket_index: int
func _ready() -> void:
	opening_bracket_index = text.find("(")
	pressed.connect(func(): LTScreen.visible = true)

func update_counter(_clearance) -> void:
	text = text.substr(0, opening_bracket_index + 1) + str(UserData.pending_clearances.size()) + ")"
