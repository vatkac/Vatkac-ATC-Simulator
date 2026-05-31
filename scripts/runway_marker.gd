extends Control
class_name RunwayMarker

# === UI Elements ===
@export_category("UI Elements")
@export var icon: TextureRect
@export var time_label: Label

# === Textures ===
@export_category("Textures")
@export var arrow_up: CompressedTexture2D
@export var arrow_down: CompressedTexture2D

var tween: Tween

func _ready() -> void:
	gui_input.connect(play_self_destroy_animation)

func initiate_marker(takeoff: bool, time: String) -> void:
	icon.texture = arrow_up if takeoff else arrow_down
	time_label.text = time

func play_self_destroy_animation(event):
	if event is not InputEventScreenTouch and event is not InputEventMouseButton: return
	if tween: return
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(queue_free)
