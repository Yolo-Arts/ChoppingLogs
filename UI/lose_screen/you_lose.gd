extends Bulletin
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var prestige_button: Button = $PrestigeButton

func _ready() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	for child in v_box_container.get_children():
		child.modulate.a = 0.0
	prestige_button.visible = false
	
	for child in v_box_container.get_children():
		tween.tween_property(child, "modulate:a", 1.0, 0.3).from(0.0)
		tween.parallel().tween_property(child, "scale", Vector2.ONE, 0.7).from(Vector2.ZERO)
	
	tween.tween_callback(func(): prestige_button.visible = true)
	tween.parallel().tween_property(prestige_button, "position:y", 790, 1.0).from(1500)


func _on_prestige_button_pressed() -> void:
	TransitionManager.play_iris(true)
	await TransitionManager.iris_transition_player.animation_finished
	
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SkillTree)
