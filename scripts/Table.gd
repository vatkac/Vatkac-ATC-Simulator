extends PanelContainer

### ASSIGNED IN INSPECTOR
@export var rows: Array[PanelContainer]
@export var table: VBoxContainer


### PRELOADS
const BUTTONS = preload("res://scenes/AcceptDeclineButtons.tscn")
const STANDART_FONT = preload("res://assets/fonts/Raleway-VariableFont.tres")

### STYLES
## Styleboxes
const EVEN_STYLEBOX: StyleBoxFlat = preload("res://assets/styles/RowStyleboxEven.stylebox")
const ODD_STYLEBOX: StyleBoxFlat = preload("res://assets/styles/RowStyleboxOdd.stylebox")

## Text
# Colors
const MAIN_TEXT_COLOR: Color = Color.WHITE
const SUB_TEXT_COLOR: Color = Color("#bfbfbf")
# Font
const RUNWAY_FONT_PATH = "res://assets/fonts/Inder-Regular.ttf"
const MAIN_FONT_SIZE: int = 14
const SUB_TEXT_SIZE: int = 7

## Other
const CORNER_RADIUS = 22
const TEXT1_SIZE = Vector2(123, 35)
const TEXT2_SIZE = Vector2(36, 36)


var cur_row = 0
var data = []
var end_obj: RichTextLabel

func _ready() -> void:
	end_obj = _setup_text_node("[font_size=16][color=#bfbfbf]Это всё![/color][/font_size]", Vector2(318, 60))
	update_rows_styles()
	
	rows[0].add_child(end_obj)
	
	# TEST ROWS
	add_row(
		build_airplane_and_route_cell("Boeing 747", "Aleksandrovsk-Sakhalinskiy — Yuzhno-Sakhalinsk"), \
		build_runway_and_time_cell("36R", "15:30")
	)
	add_row(
		build_airplane_and_route_cell("WWWWWWWWWWWWWWWW", "St. Petersburg — Ivanovo"), \
		build_runway_and_time_cell("36L", "15:00")
	)
	add_row(
		build_airplane_and_route_cell("Beechcraft 18", "Kaliningrad — St. Petersburg"), \
		build_runway_and_time_cell("18R", "18:18")
	)

func build_airplane_and_route_cell(airplane: String, route: String) -> String:
	var template: String = "[font_size={2}]{0}[/font_size]\n[font_size={3}][color={4}]{1}[/color][/font_size]"
	return template.format([airplane, route, MAIN_FONT_SIZE, SUB_TEXT_SIZE, SUB_TEXT_COLOR.to_html()])

func build_runway_and_time_cell(runway: String, time: String) -> String:
	var template: String = "[font_size={2}][font='{5}']{0}[/font][/font_size]\n[font_size={3}][color={4}]{1}[/color][/font_size]"
	return template.format([runway, time, MAIN_FONT_SIZE, SUB_TEXT_SIZE, SUB_TEXT_COLOR.to_html(), RUNWAY_FONT_PATH])

func _start_delete_animation(row: HBoxContainer) -> PropertyTweener:
	var tween = create_tween()
	row.pivot_offset = size / 2
	
	tween.tween_property(row, "scale", Vector2(5, 5), .5).set_ease(Tween.EASE_IN_OUT)
	var property = tween.parallel().tween_property(row, "modulate:a", 0.0, .5).set_ease(Tween.EASE_IN_OUT)
	
	return property

func update_rows_styles(from: int=0) -> void:
	for i in range(from, rows.size()):
		var row: PanelContainer = rows[i]
		var stylebox = ODD_STYLEBOX if i % 2 else EVEN_STYLEBOX
		row.add_theme_stylebox_override("panel", stylebox)

func delete_row(row: PanelContainer) -> void:
	var items: HBoxContainer = row.get_child(0)
	_start_delete_animation(items).finished.connect(
	func():
		for child in items.get_children(): child.queue_free()
		table.move_child(row, len(rows) - 1)
		var pos = rows.find(row)
		data.remove_at(pos)
		rows.append(rows.pop_at(pos))
		update_rows_styles(pos)
		cur_row -= 1
	)

func _on_accepted(buttons: HBoxContainer) -> void: 
	if not buttons.has_meta("PLTableRow"): return
	var row = buttons.get_meta("PLTableRow")
	delete_row(row)

func _on_declined(buttons: HBoxContainer) -> void:
	if not buttons.has_meta("PLTableRow"): return
	var row = buttons.get_meta("PLTableRow")
	delete_row(row)

func _setup_text_node(
	text: String, 
	text_size: Vector2, 
	font=STANDART_FONT, 
	bbcode_enabled=true,
	vertical_alignment=VERTICAL_ALIGNMENT_CENTER,
	horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
) -> RichTextLabel:
	var node = RichTextLabel.new()
	
	node.text = text
	node.custom_minimum_size = text_size
	node.add_theme_font_override("normal_font", font)
	node.bbcode_enabled = bbcode_enabled
	node.vertical_alignment = vertical_alignment
	node.horizontal_alignment = horizontal_alignment
	
	return node

func _setup_buttons_node(row: PanelContainer) -> HBoxContainer:
	var buttons_node = BUTTONS.instantiate()
	buttons_node.set_meta("PLTableRow", row)  # PLT — Permissions for Landing and Takeoff
	buttons_node.accepted.connect(_on_accepted); buttons_node.declined.connect(_on_declined)
	
	return buttons_node

func _move_end_obj() -> void:
	if cur_row + 1 == len(rows):
		end_obj.visible = false
	else:
		end_obj.reparent(rows[cur_row + 1])

func _setup_row_nodes(text1: String, text2: String) -> Array[Node]:
	# NODES SETUP
	var row = rows[cur_row]
	var text1_node = _setup_text_node(text1, TEXT1_SIZE)
	var text2_node = _setup_text_node(text2, TEXT2_SIZE)
	var buttons_node = _setup_buttons_node(row)
	
	return [text1_node, text2_node, buttons_node]

func add_row(text1: String, text2: String) -> void:
	if cur_row >= len(rows):
		push_error("Cannot add a row, the table is full!")
		return
	_move_end_obj()
	
	var items = rows[cur_row].get_child(0)
	assert(items != null and items.name.to_lower() == "items", "Error while adding a row! Check the row structure — the 1st child must be 'items'.")
	
	for child in _setup_row_nodes(text1, text2):
		items.add_child(child)
	data.append([text1, text2])
	cur_row += 1
