extends PanelContainer

const TEMPLATE = '[color="#bfbfbf"][font_size=16]$[/font_size][/color][color=white][font_size=20]%d[/font_size][/color]'

@export var text_node: RichTextLabel
@export var balance: int
func _ready() -> void:
	_set_balance(518)

func _set_balance(new: int) -> void:
	text_node.text = TEMPLATE % [new]
	balance = new
