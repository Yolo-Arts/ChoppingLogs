extends Control

@onready var money_label: Label = %MoneyLabel

func _ready() -> void:
	EventSystem.MON_money_updated.connect(update_text)
	money_label.text = "$" + str(0.0)

func update_text(money: float, red: bool = false):
	money_label.text = "$" + str(money)
	money_text_effect(red)


func money_text_effect(red: bool = false):
	var tween = create_tween().set_parallel(true)
	
	var color_chain = create_tween()
	if red:
		color_chain.tween_property(money_label, "theme_override_colors/font_color", Color.RED, 0.1)
	else:
		color_chain.tween_property(money_label, "theme_override_colors/font_color", Color.YELLOW, 0.1)
		
	color_chain.tween_property(money_label, "theme_override_colors/font_color", Color.WHITE, 0.3).set_delay(0.1)
	
	tween.tween_property(money_label, "scale", Vector2(1.3, 1.3), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(money_label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1)
