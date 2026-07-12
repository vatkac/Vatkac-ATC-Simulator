extends Button

@export var scene_to_switch: PackedScene

func _ready() -> void:
	pressed.connect(switch_scene)

func switch_scene() -> void:
	get_tree().change_scene_to_packed(scene_to_switch)
