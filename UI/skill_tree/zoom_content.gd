extends Control

var zoom_speed: float = 0.05
var min_zoom: float = 0.3
var max_zoom: float = 2.0
var drag_sensitivity: float = 1.0

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		position += event.relative * drag_sensitivity

	if event is InputEventMouseButton and event.is_pressed():
		var zoom_factor: float = 0.0
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_factor = 1.0 + zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_factor = 1.0 - zoom_speed
			
		if zoom_factor != 0.0:
			zoom_at_mouse(zoom_factor)

func zoom_at_mouse(zoom_factor: float) -> void:
	var mouse_pos = get_local_mouse_position()
	
	var new_scale = scale * zoom_factor
	

	new_scale.x = clamp(new_scale.x, min_zoom, max_zoom)
	new_scale.y = clamp(new_scale.y, min_zoom, max_zoom)
	
	position -= mouse_pos * (new_scale - scale)
	
	scale = new_scale
