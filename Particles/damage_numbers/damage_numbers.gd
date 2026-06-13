extends Sprite3D

@onready var label: Label = %Label

# TODO: There must be some way to re-use the 
#		function below from hud.gd
func apply_text_effect(label: Label, color: Color):
	# var color_chain = create_tween()
	# Yellow -> White
	# color_chain.tween_property(label, "theme_override_colors/font_color", color, 0.1)
	# color_chain.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.3).set_delay(0.1)
	# White -> Yellow
	# color_chain.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.1)
	# color_chain.tween_property(label, "theme_override_colors/font_color", color, 0.3).set_delay(0.1)
	# Set color to Yellow.
	label.add_theme_color_override("font_color", color)

func display_damage(dmg: Damage) -> void:
	if dmg == null:	# return if damage is missing
		return

	var final_pos = global_position + Vector3(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5), 0) 
	scale = Vector3.ZERO
	modulate.a = 1.0
	
	# Set color to yellow on crit
	if label and dmg.crit:	# check if label exists + crit.
		apply_text_effect(label, Color.YELLOW)

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
