extends TextureRect
class_name Airplane

## === Landing and Takeoff Properties ===
@export_category("Landing and Takeoff Properties")
@export var max_scale: Vector2 = Vector2(1.5, 1.5)
@export var max_shadow_scale: Vector2 = Vector2(1.3, 1.3)
@export var max_shadow_offset: float = -35.0
@export var farthest_y: float
@export var takeoff_end_y: float
@export var landing_start_y: float

## === Nodes ===
@export_category("Nodes")
@export var shadow: TextureRect
@export var LT_sound_player: AudioStreamPlayer

## === Sounds ===
@export_category("Sounds")
@export var landing: AudioStream
@export var takeoff: AudioStream

## === Takeoff Animation Settings ===
@export_category("Takeoff Animation Settings")
@export var takeoff_roll_seconds := 2.5
@export var takeoff_duration_seconds := 6
@export var takeoff_climb_seconds := 5

## === Landing Animation Settings ===
@export_category("Landing Animation Settings")
@export var descent_duration_seconds := 3
@export var landing_duration_seconds := 8
@export var opacity_animation_duration_seconds := 0.4

var tween: Tween
var clearance: FlightClearance

func _ready() -> void:
	visible = false

func set_clearance(clearance_to_set: FlightClearance) -> void:
	clearance = clearance_to_set

func land() -> void:
	if tween and tween.is_valid() and tween.is_running(): return
	else: execute_landing_checklist()
	
	tween.tween_property(self, "scale", Vector2.ONE, descent_duration_seconds)
	
	tween.parallel().tween_property(shadow, "scale", Vector2.ONE, descent_duration_seconds)
	tween.parallel().tween_property(shadow, "position:y", 0, descent_duration_seconds)
	tween.parallel().tween_property(self, "position:y", farthest_y, landing_duration_seconds)
	
	tween.tween_property(self, "modulate:a", 0, opacity_animation_duration_seconds)
	
	await get_tree().create_timer(Settings.min_rrs_ig_mins * Settings.one_ingame_minute_seconds).timeout
	UserData.scheduled_flights[clearance.clearance_total_mins_time].erase(clearance)
	if UserData.scheduled_flights[clearance.clearance_total_mins_time].is_empty():
		UserData.scheduled_flights.erase(clearance.clearance_total_mins_time)
	await LT_sound_player.finished
	await tween.finished
	
	queue_free()

func execute_landing_checklist() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	position.y = landing_start_y
	shadow.position.y = max_shadow_offset
	shadow.scale = max_shadow_scale
	scale = max_scale
	rotation_degrees = 180
	visible = true
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	LT_sound_player.stream = landing
	LT_sound_player.play()

func execute_takeoff_checklist() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	position.y = size.y
	rotation_degrees = 0
	shadow.position.y = 0
	shadow.scale = Vector2.ONE
	scale = Vector2.ONE
	visible = true
	modulate.a = 0
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 1, opacity_animation_duration_seconds)
	await tween.finished
	
	LT_sound_player.stream = takeoff
	LT_sound_player.play()

func take_off() -> void:
	if tween and tween.is_valid() and tween.is_running(): return
	else: execute_takeoff_checklist()
	
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position:y", takeoff_end_y, takeoff_duration_seconds)
	
	await get_tree().create_timer(takeoff_roll_seconds).timeout
	var tween2 = create_tween()
	tween2.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(self, "scale", max_scale, takeoff_climb_seconds)
	tween2.parallel().tween_property(shadow, "scale", max_shadow_scale, takeoff_climb_seconds)
	tween2.parallel().tween_property(shadow, "position:y", max_shadow_offset, takeoff_climb_seconds)
	
	await get_tree().create_timer(Settings.min_rrs_ig_mins * Settings.one_ingame_minute_seconds).timeout
	UserData.scheduled_flights[clearance.clearance_total_mins_time].erase(clearance)
	if UserData.scheduled_flights[clearance.clearance_total_mins_time].is_empty():
		UserData.scheduled_flights.erase(clearance.clearance_total_mins_time)
	await LT_sound_player.finished
	await tween.finished
	queue_free()
