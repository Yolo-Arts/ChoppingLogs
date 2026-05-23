extends Control

var zoom_speed: float = 0.05
var min_zoom: float = 0.3
var max_zoom: float = 2.0
var drag_sensitivity: float = 1.0
var pan_tween: Tween

func _ready() -> void:
	EventSystem.SKL_update_panning.connect(updating_panning)

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

func updating_panning(target_global_center: Vector2) -> void:
	if pan_tween and pan_tween.is_running():
		pan_tween.kill()
		
	var parent_node = get_parent()
	var window_center = parent_node.global_position + (parent_node.size / 2)
	
	var target_local_pos = get_global_transform().affine_inverse() * target_global_center
	
	var desired_position = window_center - (target_local_pos * scale)
	
	pan_tween = create_tween()
	pan_tween.set_ease(Tween.EASE_OUT)
	pan_tween.set_trans(Tween.TRANS_QUAD)
	pan_tween.tween_property(self, "position", desired_position, 0.4)
