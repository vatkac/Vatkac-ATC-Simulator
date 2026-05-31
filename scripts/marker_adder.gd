extends Button

@export var configuration_popup: MarkerConfigurator
@export var marker_scene: PackedScene
@export var markers_container: VBoxContainer
@export var max_markers: int = 5

var started_configuring_marker := false

func _ready() -> void:
	pressed.connect(
		func():
			if markers_container.get_child_count() >= max_markers: return
			configuration_popup.play_show_animation();
			started_configuring_marker = true
	)
	GlobalEvents.marker_configuration_cancelled.connect(func(): started_configuring_marker = false)
	GlobalEvents.marker_configured.connect(create_marker)

func create_marker(takeoff: bool, time: String):
	if not started_configuring_marker: return
	var marker_object: RunwayMarker = marker_scene.instantiate()
	marker_object.initiate_marker(takeoff, time)
	markers_container.add_child(marker_object)
	started_configuring_marker = false
