extends Bulletin

@onready var zoom_content: Control = %ZoomContent
@onready var prestige_label: Label = %PrestigeLabel
@onready var color_rect: ColorRect = %ColorRect
@onready var panel: Panel = %Panel
@onready var vignette: ColorRect = %Vignette

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	
	EventSystem.HUD_update_prestige_points.connect(func(new_amount: float):
		update_prestige_text(new_amount, Color.YELLOW)
	)
	
	EventSystem.PRE_cannot_decrease_prestige_points.connect(func(): update_prestige_text(EventSystem.PRE_get_prestige_points.call(), Color.RED))
	
	var current_prestige = EventSystem.PRE_get_prestige_points.call() 
	prestige_label.text = str(current_prestige)
	
	EventSystem.HUD_hide_hud.emit()
	if zoom_content:
		_run_ripple_cascade(zoom_content, 0.0)
	
	# make them automatically visible and make testing easier
	color_rect.visible = true
	panel.visible = true
	vignette.visible = true

func _close_skill_tree() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SkillTree)
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.HUD_show_hud.emit()
	SaveManager.save_skill_tree_upgrades()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		#_close_skill_tree()
		pass

func _run_ripple_cascade(current_node: Node, current_delay: float) -> void:
	var next_delay = current_delay
	
	if current_node is SkillNode:
		if not current_node.visible:
			return 
			
		current_node.animate_pop_in(current_delay)
		next_delay += 0.12
		
	for child in current_node.get_children():
		_run_ripple_cascade(child, next_delay)

func update_prestige_text(amount: float, color: Color) -> void:
	#prestige_label.text = str(amount)
	prestige_label.text = "%.1f" % amount
	apply_text_effect(prestige_label, color)

func apply_text_effect(label: Label, color: Color) -> void:
	var tween = create_tween().set_parallel(true)
	
	var color_chain = create_tween()
	color_chain.tween_property(label, "theme_override_colors/font_color", color, 0.1)
	color_chain.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.3).set_delay(0.1)
	
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1)


func _on_next_button_pressed() -> void:
	#EventSystem.STA_change_stage.emit(StageConfig.Keys.Prototype)
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Level)
	EventSystem.DAR_reset_encroaching_dark.emit()
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.YouLose)
	SaveManager.reset_run_upgrades()
	EventSystem.QUO_reset_quota.emit()
	_close_skill_tree()
	get_tree().paused = false
