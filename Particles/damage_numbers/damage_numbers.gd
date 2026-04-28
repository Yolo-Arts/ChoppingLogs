extends Sprite3D

@onready var label: Label = %Label

func display_damage():
	var final_pos = global_position + Vector3(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5), 0) 
	scale = Vector3.ZERO
	modulate.a = 1.0
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "global_position", final_pos, 0.6)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector3.ONE * 1.5, 0.15)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(self, "scale", Vector3.ONE, 0.15)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "modulate:a", 0.0, 0.4).set_delay(0.2)

func _ready() -> void:
	display_damage()
