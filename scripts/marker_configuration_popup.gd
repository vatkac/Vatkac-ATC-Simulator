extends CanvasLayer
class_name MarkerConfigurator

# === Interface Controls ===
@export_category("Interface Controls")
@export var accept_button: Button
@export var decline_button: Button
@export var switch: TextureRect

# === Time Input Fields ===
@export_category("Time Input Fields")
@export var hours_line_edit: LineEdit
@export var minutes_line_edit: LineEdit

# === Visual Overlays ===
@export_category("Visual Overlays")
@export var popup_contents: TextureRect
@export var blur_node: ColorRect

var tween: Tween

func _ready() -> void:
	popup_contents.scale = Vector2.ZERO
	blur_node.material.set_shader_parameter("blur_amount", 0.0)
	blur_node.material.set_shader_parameter("darkness", 0.0)
	visible = false
	
	decline_button.pressed.connect(play_hide_animation)
	accept_button.pressed.connect(accept_marker)

func accept_marker() -> void:
	hours_line_edit.release_focus()
	minutes_line_edit.release_focus()
	var time := hours_line_edit.text + ":" + minutes_line_edit.text
	var takeoff: bool = switch.selected == switch.Selected.Left
	GlobalEvents.marker_configured.emit(takeoff, time)
	play_hide_animation()

func play_show_animation() -> void:
	if tween and tween.is_running() and tween.is_valid(): return
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	visible = true
	tween.tween_property(popup_contents, "scale", Vector2.ONE, 0.5)
	tween.parallel().tween_property(blur_node, "material:shader_parameter/blur_amount", 2.5, 0.5)
	tween.parallel().tween_property(blur_node, "material:shader_parameter/darkness", 0.6, 0.5)

func play_hide_animation() -> void:
	if tween and tween.is_running() and tween.is_valid(): return
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(popup_contents, "scale", Vector2.ZERO, 0.5)
	tween.parallel().tween_property(blur_node, "material:shader_parameter/blur_amount", 0.0, 0.5)
	tween.parallel().tween_property(blur_node, "material:shader_parameter/darkness", 0.0, 0.5)
	tween.tween_callback(func(): visible = false)
