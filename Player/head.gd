extends Node3D
class_name CameraController

@export var mouse_sensitivity := 0.005
@export var vertical_clamp := 90.0
@export var tilt_up := 1.5
@export var tilt_down := -1.0


@onready var tilt_node: Node3D = $CameraTiltNode


func look_around(relative: Vector2) -> void:
	rotate_x(-relative.y * mouse_sensitivity)
	rotation_degrees.x = clampf(rotation_degrees.x, -vertical_clamp, vertical_clamp)

func play_tilt(target_degrees: float, duration: float, return_duration: float):
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(tilt_node, "rotation_degrees:x", target_degrees, duration)
	tween.tween_property(tilt_node, "rotation_degrees:x", 0.0, return_duration)
