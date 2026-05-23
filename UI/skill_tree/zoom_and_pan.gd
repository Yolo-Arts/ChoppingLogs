extends Camera2D

var zoomSpd: float = 0.05
var Minzoom: float = 0.3
var Maxzoom: float = 2.0
var dragSen: float = 1.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		position -= event.relative * dragSen / zoom
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoomSpd, zoomSpd)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoomSpd, zoomSpd)
		zoom.x = clamp(zoom.x, Minzoom, Maxzoom)
		zoom.y = clamp(zoom.y, Minzoom, Maxzoom)
