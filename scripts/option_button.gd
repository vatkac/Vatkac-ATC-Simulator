extends Button

func _pressed() -> void:
	if text != "":
		GlobalEvents.search_option_picked.emit(text)
