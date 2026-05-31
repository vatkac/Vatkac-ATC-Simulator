extends TextureRect

# === Background ===
@export_category("Background")
@export var left_selected_background: CompressedTexture2D
@export var right_selected_background: CompressedTexture2D

# === Icons ===
@export_category("Icons")
@export var arrow_down_filled: CompressedTexture2D
@export var arrow_down_outlined: CompressedTexture2D
@export var arrow_up_filled: CompressedTexture2D
@export var arrow_up_outlined: CompressedTexture2D

# === UI Elements ===
@export_category("UI Elements")
@export var arrow_up: Button
@export var arrow_down: Button

# === Other ===
enum Selected { Left, Right }
var selected: Selected = Selected.Left

func _ready() -> void:
	arrow_up.pressed.connect(func(): set_selected(Selected.Left))
	arrow_down.pressed.connect(func(): set_selected(Selected.Right))

func set_selected(new: Selected) -> void:
	texture = left_selected_background if new == Selected.Left else right_selected_background
	arrow_up.icon = arrow_up_filled if new == Selected.Left else arrow_up_outlined
	arrow_down.icon = arrow_down_filled if new != Selected.Left else arrow_down_outlined
	selected = new
