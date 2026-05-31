extends AudioStreamPlayer

func _ready() -> void:
	get_window().window_input.connect(_on_window_input)

func _on_window_input(event: InputEvent) -> void:
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed:
		play()
