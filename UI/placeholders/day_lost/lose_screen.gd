extends Bulletin

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.HUD_hide_hud.emit()
	get_tree().paused = true

func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	EventSystem.QUO_reset_quota.emit()
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Prototype)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.LoseScreen)
	

func _on_back_to_menu_button_pressed() -> void:
	get_tree().paused = false
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.LoseScreen)
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
