extends TextureRect

@export_group("Textures")
@export var good_trust: CompressedTexture2D
@export var mid_trust: CompressedTexture2D
@export var bad_trust: CompressedTexture2D

@export_group("Lower thresholds")
@export_range(0, 100) var good_trust_threshold: int
@export_range(0, 100) var mid_trust_threshold: int

var _trust: int
@export_range(0, 100) var trust: int:
	get:
		return _trust
	set(val):
		_set_trust(val)

func _ready() -> void:
	GlobalEvents.trust_changed.connect(_set_trust)
	_set_trust(100)

func _between(value: int, left_inclusive: int, right_exclusive: int) -> bool:
	return clamp(value, left_inclusive, right_exclusive - 1) == value

func _is_valid_trust(trust_to_check: int) -> bool:
	return 0 <= trust_to_check and trust_to_check <= 100

func _set_trust(new_trust: int) -> void:
	if _is_valid_trust(new_trust):
		if _between(new_trust, mid_trust_threshold, good_trust_threshold):             
			self.texture = mid_trust
		elif _between(new_trust, 0, mid_trust_threshold):
			self.texture = bad_trust
		else:
			self.texture = good_trust
		_trust = new_trust
	else:
		push_error("Invalid trust! {d} is not in the allowed range 0-100.".format([new_trust]))
