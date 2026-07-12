extends Button

@export var root: ColorRect
func _ready() -> void:
	pressed.connect(func(): root.visible = false)
