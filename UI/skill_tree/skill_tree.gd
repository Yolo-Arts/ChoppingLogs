extends Bulletin

@onready var zoom_content: Control = %ZoomContent
@onready var money_label: Label = %MoneyLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	EventSystem.MON_money_updated.connect(update_text)
	EventSystem.MON_cannot_decrease_money.connect(func(): 
		update_text(EventSystem.MON_get_player_money.call(), Color.RED)
	)
	var current_money = EventSystem.MON_get_player_money.call()
	money_label.text = "$" + str(current_money)
	EventSystem.HUD_hide_hud.emit()
	if zoom_content:
		_run_ripple_cascade(zoom_content, 0.0)

func _close_skill_tree() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SkillTree)
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.HUD_show_hud.emit()
	SaveManager.save_skill_tree_upgrades()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		_close_skill_tree()

func _run_ripple_cascade(current_node: Node, current_delay: float) -> void:
	var next_delay = current_delay
	
	if current_node is SkillNode:
		if not current_node.visible:
			return 
			
		current_node.animate_pop_in(current_delay)
		next_delay += 0.12
		
	for child in current_node.get_children():
		_run_ripple_cascade(child, next_delay)

func update_text(money: float, color: Color):
	money_label.text = "$" + str(money)
	apply_text_effect(money_label, color)

func apply_text_effect(label: Label, color: Color):
	var tween = create_tween().set_parallel(true)
	
	var color_chain = create_tween()
	color_chain.tween_property(label, "theme_override_colors/font_color", color, 0.1)
	color_chain.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.3).set_delay(0.1)
	
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1)


func _on_next_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Prototype)
	#EventSystem.STA_change_stage.emit(StageConfig.Keys.Level)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.YouLose)
	_close_skill_tree()
	get_tree().paused = false
