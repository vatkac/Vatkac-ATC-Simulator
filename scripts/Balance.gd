extends PanelContainer

@export var text_node: Label
@export var balance: int

func _ready() -> void:
	_set_balance(UserData.current_balance)

func _set_balance(new: int) -> void:
	text_node.text = str(new)
	balance = new
