extends Node

@export var search_dropdown_packed: PackedScene

func _ready() -> void:
	call_deferred("_deferred_ready")

func _deferred_ready() -> void:
	var result = SaveManager.try_load_game()
	if not result:
		GlobalEvents.dropdown_option_picked.connect(
			func(x):
				Settings.selected_city = x
				get_tree().change_scene_to_file("res://scenes/MainScreen.tscn")
		)
		Settings.runways_number = str(randi_range(1, 37)).pad_zeros(2)
		add_child(search_dropdown_packed.instantiate())
	else:
		get_tree().change_scene_to_file("res://scenes/MainScreen.tscn")
