extends TextureRect

# === UI Elements — Main ===
@export_group("Main UI Elements")
@export var action_button: Button
@export var agree_button: Button
@export var picked_option: Label
@export var main_bar: Button

# === Search ===
@export_group("Search")
@export var search_bar: HBoxContainer
@export var search_bar_line_edit: LineEdit
@export var search_results_container: VBoxContainer

# === Option Buttons ===
@export_group("Option Buttons")
@export var option_buttons: Array[Button]

# === Background ===
@export_group("Background")
@export var background_node: TextureRect
@export var first_stage_background_texture: CompressedTexture2D
@export var second_stage_background_texture: CompressedTexture2D
@export var blur_node: ColorRect

# === Stage Positions ===
@export_group("Stage Positions")
@export var bar_first_stage_x := 79
@export var bar_second_stage_x := 110

var DATA_CONFIG_PATH = "res://assets/cities_data.cfg"
enum Stage { OPTION_PICKED, SEARCH_NOT_STARTED, SEARCHING }
var current_stage := Stage.OPTION_PICKED
var data: PackedStringArray
var are_search_results_minimized := false
var search_results_tween: Tween
var show_hide_tween: Tween

func _ready() -> void:
	action_button.pressed.connect(on_action_button_pressed)
	search_bar_line_edit.text_changed.connect(update_search_results)
	agree_button.pressed.connect(confirm_option)
	GlobalEvents.search_option_picked.connect(pick_option)
	
	data = load_data()
	self.scale = Vector2.ZERO
	blur_node.material.set_shader_parameter("blur_amount", 0.0)
	blur_node.material.set_shader_parameter("darkness", 0.0)
	play_show_animation()

func load_data() -> PackedStringArray:
	var config := ConfigFile.new()
	var error = config.load(DATA_CONFIG_PATH)
	
	if error == OK:
		var packed_array = config.get_value("Data", "data") as PackedStringArray
		return packed_array
			
	push_error("Error while loading data!")
	return []

func switch_stage(new_stage: Stage):
	current_stage = new_stage
	background_node.texture = first_stage_background_texture if new_stage == Stage.OPTION_PICKED else second_stage_background_texture
	agree_button.visible = new_stage == Stage.OPTION_PICKED
	picked_option.visible = new_stage == Stage.OPTION_PICKED
	search_bar.visible = new_stage != Stage.OPTION_PICKED
	if new_stage == Stage.SEARCHING: set_search_results_visibility(true)
	else: set_search_results_visibility(false)
	
	var tween = create_tween()
	var new_x = bar_first_stage_x if new_stage == Stage.OPTION_PICKED else bar_second_stage_x
	var new_rotation = -90 if new_stage == Stage.SEARCH_NOT_STARTED else 0
	
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(main_bar, "position:x", new_x, 0.3)
	tween.parallel().tween_property(action_button, "rotation_degrees", new_rotation, 0.3)

func set_search_results_visibility(viewable: bool) -> void:
	if search_results_tween and search_results_tween.is_running(): search_results_tween.kill()
	elif search_results_container.visible == viewable: return
	
	var target_alpha := int(viewable)
	var target_y := 0.0 if viewable else -search_results_container.size.y
	
	if viewable: search_results_container.visible = true
	search_results_tween = create_tween()
	search_results_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	search_results_tween.tween_property(search_results_container, "position:y", target_y, 0.3)
	search_results_tween.parallel().tween_property(search_results_container, "modulate:a", target_alpha, 0.3)
	search_results_tween.tween_callback(func(): search_results_container.visible = viewable)

func on_action_button_pressed() -> void:
	if current_stage != Stage.SEARCH_NOT_STARTED:
		are_search_results_minimized = current_stage == Stage.SEARCHING
		switch_stage(Stage.SEARCH_NOT_STARTED)
	elif search_bar_line_edit.text != "":
		are_search_results_minimized = false
		switch_stage(Stage.SEARCHING)
		update_search_results(search_bar_line_edit.text)
	else:
		switch_stage(Stage.OPTION_PICKED)

func update_search_results(new_text: String) -> void:
	if are_search_results_minimized: return
	if new_text == "":
		switch_stage(Stage.SEARCH_NOT_STARTED)
	elif current_stage != Stage.SEARCHING:
		switch_stage(Stage.SEARCHING)
		
	new_text = new_text.to_lower()
	var options_count := len(option_buttons)
	var results: Array[String] = []
	var found_start := false  # The data are sorted. If we find start of 
							  # a prefix and then hit the end, there is no need to try finding another city
	for city in data:  # Linear search is... fine for 4000 data I guess.
		if city.to_lower().begins_with(new_text) and len(results) < options_count:
			results.append(city)
			found_start = true
		elif found_start or len(results) >= options_count:
			break
		
	for i in range(len(option_buttons)):
		var button := option_buttons[i]
		var text := results[i] if i < len(results) else ""
		
		button.text = text

func pick_option(option: String) -> void:
	search_bar_line_edit.clear()
	picked_option.text = option
	switch_stage(Stage.OPTION_PICKED)

func play_show_animation() -> void:
	if show_hide_tween and show_hide_tween.is_running() and show_hide_tween.is_valid(): return
	show_hide_tween = create_tween()
	show_hide_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	visible = true
	show_hide_tween.tween_property(self, "scale", Vector2.ONE, 0.5)
	show_hide_tween.parallel().tween_property(blur_node, "material:shader_parameter/blur_amount", 2.5, 0.5)
	show_hide_tween.parallel().tween_property(blur_node, "material:shader_parameter/darkness", 0.6, 0.5)

func play_self_destroy_animation() -> void:
	if show_hide_tween and show_hide_tween.is_running() and show_hide_tween.is_valid(): return
	show_hide_tween = create_tween()
	show_hide_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	show_hide_tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	show_hide_tween.parallel().tween_property(blur_node, "material:shader_parameter/blur_amount", 0.0, 0.5)
	show_hide_tween.parallel().tween_property(blur_node, "material:shader_parameter/darkness", 0.0, 0.5)
	await show_hide_tween.finished
	blur_node.queue_free()
	GlobalEvents.dropdown_option_picked.emit(picked_option.text)

func confirm_option() -> void:
	agree_button.disabled = true
	play_self_destroy_animation()
