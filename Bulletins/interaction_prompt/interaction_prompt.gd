extends Bulletin

@onready var label: Label = $Label

var prompt_text := ""

func initialize(prompt) -> void:
	if prompt is String:
		prompt_text = "E\n" + prompt

func _ready() -> void:
	label.text = prompt_text
	EventSystem.WEI_cannot_pickup_due_to_weight.connect(cannot_pickup_warning.bind("Cannot pickup due to weight"))
	EventSystem.WEI_cannot_pickup_due_to_space.connect(cannot_pickup_warning.bind("Cannot pickup due to space"))

func cannot_pickup_warning(warning_text: String):
	label.text = warning_text
	warning_effect()

func warning_effect():
	var tween = create_tween().set_parallel(true)
	
	var color_chain = create_tween()
	color_chain.tween_property(label, "theme_override_colors/font_color", Color.RED, 0.1)
	color_chain.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.3).set_delay(0.1)
	
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1)
	
	var original_pos = label.position
	var shake_tween = create_tween()
	for i in range(4):
		var intensity = 7.0 
		var direction = 1 if i % 2 == 0 else -1
		shake_tween.tween_property(label, "position:x", original_pos.x + (intensity * direction), 0.05)
	shake_tween.tween_property(label, "position:x", original_pos.x, 0.05)
